tableextension 50027 BASLotNoInformationExtPHA extends "Lot No. Information"
{
    fields
    {
        field(50000; BASExpirationDatePHA; Date)
        {
            Caption = 'Expiration Date';
            Description = 'LAN1.00';

            trigger OnValidate()
            var
                ChargenVerw: Codeunit BASChargeMgtPHA;
            begin

                // ToDo
                // if Rec.BASExpirationDatePHA <> xRec.BASExpirationDatePHA then
                //     ChargenVerw."Aktualisiere Verkaufscharge"("Item No.", BASLotNoPHA, 1, BASSalesLotNoPHA, BASExpirationDatePHA);

                // ToDo
                if StrPos(BASChangeStatusPHA, 'E') = 0 then
                    BASChangeStatusPHA := BASChangeStatusPHA + 'E';

            end;
        }
        field(50001; BASSalesLotNoPHA; Code[20])
        {
            trigger OnValidate()
            var
                ChargenVerw: Codeunit ChargenMgt;
            begin
                ChargenVerw."Aktualisiere Verkaufscharge"("Item No.", BASLotNoPHA, 0, BASSalesLotNoPHA, BASExpirationDatePHA);

                if StrPos(BASChangeStatusPHA, 'V') = 0 then
                    Evaluate(BASChangeStatusPHA, BASChangeStatusPHA + 'V');
            end;
        }
        field(50002; "BASLief. Chargennr.PHA"; Code[20])
        {
            Description = 'LAN1.00';

            trigger OnValidate()
            begin
                //-GL009
                if StrPos(BASChangeStatusPHA, 'D') = 0 then
                    BASChangeStatusPHA := BASChangeStatusPHA + 'D';
                //+GL009
            end;
        }
        field(50003; "BASLief. AblaufdatumPHA"; Date)
        {
            Description = 'LAN1.00';
        }
        field(50004; BASOpenPHA; Boolean)
        {
            Caption = 'Open';
            Description = 'LAN1.00';
        }
        field(50005; BASFreigabedatumPHA; Date)
        {
            Description = 'LAN1.00';
        }
        field(50006; BASFreigabenamePHA; Text[50])
        {
            Description = 'LAN1.00';
        }
        field(50007; BASGehaltPHA; Decimal)
        {
            Description = 'LAN1.00';

            trigger OnValidate()
            var
                ItemLedgEntry: Record "Item Ledger Entry";
            begin


                //-GL012
                //Prüfen, ob die Charge schon in einer Verbrauchsbuchung vorhanden ist, wenn ja dann eine Meldung mit Bestättigung anzeigen
                ItemLedgEntry.RESET();
                ItemLedgEntry.SETCURRENTKEY("Item No.", BASLotNoPHA);
                ItemLedgEntry.SetRange("Item No.", "Item No.");
                ItemLedgEntry.SetRange(BASLotNoPHA, BASLotNoPHA);
                ItemLedgEntry.SetRange("Entry Type", ItemLedgEntry."Entry Type"::Consumption);
                if not ItemLedgEntry.IsEmpty then
                    if Confirm('Die Charge ist in Verbrauchsbuchungen vorhanden! Trotzdem ändern?', false) = false then
                        ERROR('Änderung wurde nicht durchgeführt.');

                ChangeStatus('G');
            end;
        }
        field(50008; BASLaborkommentarPHA; Text[100])
        {
            Description = 'LAN1.00';

            trigger OnValidate()
            begin
                ChangeStatus('M');
            end;
        }
        field(50009; "BASLaetus-CodePHA"; Text[15])
        {
            Description = 'LAN1.00';

        }
        field(50010; BASStatusPHA; enum BASStatusLotNoInformationPHA)
        {
            trigger OnValidate()
            var
                Item: Record Item;
                uNaviPharma: Codeunit BASNaviPharmaPHA;
                bLotStatusMismatch: Boolean;

                cInfoText: Text;

                cText: Text;
            begin
                //-GL038
                /*
                //-LAN002
                IF (Status = Status::Frei) AND (xRec.Status <> Status::Frei) THEN BEGIN
                  IF Freigabedatum = 0D THEN
                    Freigabedatum := TODAY;
                  IF Freigabename = '' THEN
                    Freigabename := USERID;
                END;
                //+LAN002
                */
                //+GL038

                //-GL039
                bLotStatusMismatch := false;
                case Rec.Status of
                    Rec.Status::Frei:
                        begin
                            if StrPos(UPPERCASE(Rec.LimsStatus), 'FREI') = 0 then //FREI, FREIGEGEBEN
                                bLotStatusMismatch := true;
                        end;
                    Rec.Status::Quarantäne:
                        begin
                            if StrPos(UPPERCASE(Rec.LimsStatus), 'QUARANT') = 0 then //QUARANTINE, QUARANTÄNE
                                bLotStatusMismatch := true;
                        end;
                    Rec.Status::Gesperrt:
                        begin
                            if StrPos(UPPERCASE(Rec.LimsStatus), 'GESPERRT') = 0 then
                                bLotStatusMismatch := true;
                        end;
                end;
                if bLotStatusMismatch then begin
                    if not Confirm('Neuer Chargenstatus: ''%1'' entspricht nicht dem Lims-Chargenstatus: ''%2''. Trotzdem übernehmen?', false, FORMAT(Rec.Status), Rec.LimsStatus) then
                        ERROR('');
                end;
                //+GL039

                //-GL010
                //IF cuNaviPharma.StandortWeiche('ITEM_SITE_BATCH_RELEASE',"Item No.") = 'WIEN' THEN        //GL023
                if Rec.Status = Rec.Status::Frei then begin
                    if (BASExpirationDatePHA < TODAY) then
                        ERROR('Bevor Sie den Freigabestatus ' +
' auf "Frei" setzen können, muss die Charge mit einem gültigen Ablaufdatum versehen werden!');

                    if not Item.GET("Item No.") then ERROR('Artikel %1 ist nicht im Artikelstamm angelegt!', "Item No.");
                    //+GL011
                    //    IF NOT cuNaviPharma.PrüfeUnterstufeFrei(Rec."Item No.", Rec.BASLotNoPHA,
                    //        recItem.Artikelart <> recItem.Artikelart::Fertigprodukt, FALSE, TRUE) THEN
                    if not uNaviPharma.PrüfeUnterstufeFrei(Rec."Item No.", Rec.BASLotNoPHA, false, true, true) then
                        //-GL011
                        //-GL018
                        //-GL017
                        //ERROR('Bevor Sie den Freigabestatus auf ''Frei'' setzen können, müssen die Unterstufen freigegeben sein!');
                        //Message('Das System lässt die Freigabe dieser Charge zu. Bitte beachten Sie jedoch, dass ' +
                        //  ' zumindest eine unfreie Unterstufe erkannt wurde! \'+
                        //  'Bitte kontrollieren Sie die Stati mit "Übersicht unfreie Artikel"');

                        if Confirm('Das System lässt die Freigabe dieser Charge zu. Bitte beachten Sie jedoch, dass ' +
                        ' zumindest eine unfreie Unterstufe erkannt wurde! \' +
                        'Bitte kontrollieren Sie die Stati mit "Gesamtübersicht beteiligte Artikel"\' +
                        'CHARGE FREIGEBEN?') = false then begin
                            Status := xRec.Status;
                            exit;
                        end;

                    //frmChargenfreigabeWien.ZeigeBeteiligteStufen; //28.11.13 JP
                    //+GL017
                    //+GL018
                end;
                //+GL010

                //-GL009
                if (xRec.Status = xRec.Status::Frei) and (xRec.Status <> Rec.Status) then
                    if StrPos(BASChangeStatusPHA, 'S') = 0 then BASChangeStatusPHA := BASChangeStatusPHA + 'S';
                //+GL009


                //-GL022
                if (Status = Status::Frei) and (xRec.Status <> Status::Frei) then
                    if Item.GET("Item No.") then
                        if Item.Artikelart = Item.Artikelart::Fertigprodukt then
                            if Item."Patentschutz bis" >= TODAY then
                                if Confirm('Patentschutz für Artikel %1 ist bis zum %2 eingetragen! Trotzdem Freigeben?', false, "Item No.", Item."Patentschutz bis") = false then
                                    ERROR('Chargenfreigabe wurde abgebrochen!');
                //+GL022

                //-GL033
                if (Status = Status::Frei) and (xRec.Status <> Status::Frei) then
                    if Item.GET("Item No.") then
                        if Item.Artikelart = Item.Artikelart::Fertigprodukt then
                            if Item."Vermarktungsexklusivität bis" >= TODAY then
                                if Confirm('Vermarktungsexklusivität für Artikel %1 ist bis zum %2 eingetragen! Trotzdem Freigeben?', false, "Item No.", Item."Vermarktungsexklusivität bis") = false then
                                    ERROR('Chargenfreigabe wurde abgebrochen!');
                //+GL033



                //-GL026
                if Rec.Status = Rec.Status::Frei then begin
                    if Rec.BASExpirationDatePHA = 0D then
                        ERROR('Bitte vergeben Sie ein Ablaufdatum für die Charge!');
                    if not uNaviPharma.AblaufDatumPlausibel("Item No.", BASExpirationDatePHA) then
                        Rec.Status := xRec.Status;
                end;


                cInfoText := '';
                cText := CheckComponents(Rec."Item No.", Rec.BASLotNoPHA, false, cInfoText);
                if (cText <> '') and (Status = Status::Frei) then
                    if not Confirm(cText + '- trotzdem freigeben?') then
                        ERROR('Freigabe wird abgebrochen');


                if not Item.GET("Item No.") then ERROR('Artikel %1 ist nicht im Artikelstamm angelegt!', "Item No.");

                //Bei Freigabe von Fertigartikel das Recht $MARKTFREIGABE prüfen
                if (Item.Artikelart = Item.Artikelart::Fertigprodukt) then
                    if uNaviPharma.Berechtigung('$MARKTFREIGABE') = false then
                        ERROR('Berechtigung für Marktfreigabe nicht vorhanden!');

                //+GL026



                //-GL021
                //Marktfreigabe Pin bei Fertigartikel Abfragen
                if Rec.Status <> xRec.Status then //GL025  Wenn vorher schon abgebrochen wurde, keinen Pin mehr prüfen
                    CheckMarktfreigabePin();
                //+GL021
                //Message('Einkommentieren!');

                //-GL038
                if (Status = Status::Frei) and (xRec.Status <> Status::Frei) then begin
                    Freigabedatum := TODAY;
                    Freigabename := USERID;
                end;
                //+GL038


            end;
        }
        field(50011; BASPackmittelversionPHA; Code[20])
        {

            trigger OnValidate()
            begin
                //-GL009
                if StrPos(BASChangeStatusPHA, 'P') = 0 then
                    BASChangeStatusPHA := BASChangeStatusPHA + 'P';
                //+GL009

            end;
        }
        field(50012; BASLagerstandPHA; Decimal)
        {
            CalcFormula = sum("Item Ledger Entry".Quantity where("Item No." = field("Item No."),
                                                                  BASLotNoPHA = field(BASLotNoPHA)));
            DecimalPlaces = 0 : 5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(50013; "Rückstellmuster"; Integer)
        {

        }
        field(50014; BASArtikelnamePHA; Text[50])
        {
            CalcFormula = lookup(Item.Description where("No." = field("Item No.")));
            FieldClass = FlowField;
        }
        field(50015; BASArtikelartPHA; Option)
        {
            CalcFormula = lookup(Item.Artikelart where("No." = field("Item No.")));
            FieldClass = FlowField;
            OptionCaption = ' ,Rohstoff,Halbfabrikat,Fertigprodukt,Verpackungsstoff,Arbeitsschritt';
            OptionMembers = " ",Rohstoff,Halbfabrikat,Fertigprodukt,Verpackungsstoff,Arbeitsschritt;
        }
        field(50016; BASMIBIPHA; Boolean)
        {
        }
        field(50099; BASChangeStatusPHA; Text[30])
        {
            Caption = 'Change Status', comment = 'DEA="Änderungsstatus"';
        }
        field(50100; BASFABeschreibung2PHA; Text[50])
        {

        }
        field(50101; "ArtikelPackungsgröße"; Text[10])
        {
            CalcFormula = lookup(Item."Packungsgröße" where("No." = field("Item No.")));
            FieldClass = FlowField;
        }
        field(50102; "BASCEP NrPHA"; Code[50])
        {
            Description = 'GL029,LQ18.1';

        }
        field(50103; BASHerstellerNrPHA; Code[20])
        {
            Description = 'GL029,LQ18.1';
            //TableRelation = Hersteller.HerstellerNr;
        }
        field(50104; "BASExpiration Date DMPHA"; Text[6])
        {
            Description = 'GL030,EUHUB';
            Numeric = true;

            trigger OnValidate()
            begin
                CheckExpDate(); //GL030
            end;
        }
        field(50105; "BASHF KommentarPHA"; Text[100])
        {
            Description = 'GL032';
        }
        field(50106; "BASAnzahl FreigabenPHA"; Integer)
        {
            CalcFormula = count("Change Log Entry" where("Table No." = const(6505),
                                                          "Primary Key Field 1 Value" = field("Item No."),
                                                          "Primary Key Field 3 Value" = field(BASLotNoPHA),
                                                          //"New Value" = CONST(1),
                                                          "Field No." = const(50010)));
            Description = 'GL038';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50117; BASLimsStatusPHA; Code[29])
        {
            Description = 'LIMS,CCU105';
        }
        field(50118; BASLimsImportInProgressPHA; Boolean)
        {
            Description = 'LIMS';
        }
        field(50119; BASLimsBacklogEntriesPHA; Integer)
        {
        }
        field(50120; BASItem_BlockedPHA; Boolean)
        {
            CalcFormula = lookup(Item.Blocked where("No." = field("Item No.")));
            Caption = 'Artikel gesperrt';
            Description = 'LIMS';
            FieldClass = FlowField;
        }
        field(50507; "BASStatistikcode IPHA"; Code[10])
        {
            CalcFormula = lookup(Item."Statistikcode I" where("No." = field("Item No.")));
            Editable = false;
            FieldClass = FlowField;
            TableRelation = Statistikcode2.Code where(Ebene = const(1));
        }
        field(50508; "BASStatistikcode IIPHA"; Code[10])
        {
            CalcFormula = lookup(Item."Statistikcode II" where("No." = field("Item No.")));
            Editable = false;
            FieldClass = FlowField;
            TableRelation = Statistikcode2.Code where(Ebene = const(2));
        }
        field(50509; "BASStatistikcode IIIPHA"; Code[10])
        {
            CalcFormula = lookup(Item."Statistikcode III" where("No." = field("Item No.")));
            Editable = false;
            FieldClass = FlowField;
            TableRelation = Statistikcode2.Code where(Ebene = const(3));
        }
        field(50510; BASChangeDatePHA; DateTime)
        {
            CalcFormula = max("Change Log Entry"."Date and Time" where("Table No." = const(6505),
                                                                        "Primary Key Field 1 Value" = field("Item No."),
                                                                        "Primary Key Field 2 Value" = field("Variant Code"),
                                                                        "Primary Key Field 3 Value" = field(BASLotNoPHA),
                                                                        "Type of Change" = filter(Modification)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(50511; BASErstablaufdatumPHA; Date)
        {
            Description = 'CCU553';
        }
        field(50512; BASProduktionsdatumPHA; Date)
        {
            Description = 'CCU656';
        }
        field(50513; "BASEntry DatePHA"; Date)
        {
            Caption = 'Zugangsdatum';
            Description = 'CCU656';
        }
    }



    procedure LotNoCheck()
    var
        recItem: Record Item;
        recLotNoInfo: Record "Lot No. Information";
    begin
        //Eindeutigkeit der Rohstoffchargennr. (darf nie zweimal vergeben werden)
        recItem.GET("Item No.");
        if recItem.Artikelart in [recItem.Artikelart::Rohstoff, recItem.Artikelart::Verpackungsstoff] then begin
            recLotNoInfo.SETCURRENTKEY(BASLotNoPHA);
            recLotNoInfo.SetRange(BASLotNoPHA, BASLotNoPHA);
            if recLotNoInfo.FIND('-') then
                if recLotNoInfo."Item No." <> "Item No." then
                    ERROR('Rohstoffcharge wurde schon zu anderer Artikelnummer vergeben!');
        end;
    end;

    procedure CheckComponents(ItemNo: Text[20]; LotNo: Text[20]; bMehrstufig: Boolean; var cInfoText: Text[1000]) cMeldung: Text[1000]
    var
        recItem: Record Item;
        recItemLedgerEntry: Record "Item Ledger Entry";
        recItemLedgerEntry1: Record "Item Ledger Entry";
        recLotNoInformation: Record "Lot No. Information";
        recProductionOrder: Record "Production Order";
        nCountChecked: Integer;

    begin

        //Funktion für Unterstufenprüfung
        if recItem.GET(ItemNo) then
            if recItem.Artikelart = recItem.Artikelart::Rohstoff then begin
                cInfoText := 'Rohstoffe werden nicht geprüft!';  //UPDATE2013
                exit;
            end;
        nCountChecked := 0;
        recItemLedgerEntry.SETCURRENTKEY("Item No.", BASLotNoPHA, "Posting Date");
        recItemLedgerEntry.SETFILTER(BASLotNoPHA, LotNo);
        recItemLedgerEntry.SETFILTER("Item No.", ItemNo);
        recItemLedgerEntry.SetRange("Entry Type", recItemLedgerEntry."Entry Type"::Output);
        if recItemLedgerEntry.FIND('-') then begin

            //-UPDATE2013
            //neu
            recItemLedgerEntry1.SETCURRENTKEY("Order Type", "Order No.", "Order Line No.", "Entry Type", "Prod. Order Comp. Line No.");
            recItemLedgerEntry1.SetRange("Order Type", recItemLedgerEntry."Order Type"::Production);
            recItemLedgerEntry1.SETFILTER("Order No.", recItemLedgerEntry."Order No.");
            //Alt
            //recItemLedgerEntry1.SETCURRENTKEY("Prod. Order No.","Prod. Order Line No.","Entry Type","Prod. Order Comp. Line No.");
            //recItemLedgerEntry1.SETFILTER("Prod. Order No.", recItemLedgerEntry."Prod. Order No.");
            //+UPDATE2013
            recItemLedgerEntry1.SETFILTER("Entry Type", 'Verbrauch|Abgang');
            if recItemLedgerEntry1.FIND('-') then
                repeat
                    recLotNoInformation.SETFILTER("Item No.", recItemLedgerEntry1."Item No.");
                    recLotNoInformation.SETFILTER(BASLotNoPHA, recItemLedgerEntry1.BASLotNoPHA);
                    if recLotNoInformation.FIND('-') then begin
                        if recLotNoInformation.Status <> recLotNoInformation.Status::Frei then begin
                            if ItemIsBulk(ItemNo) and ItemIsBulk(recLotNoInformation."Item No.") then begin
                                //TA-Artikel (Tablettenkerne) werden nie freigegeben
                            end else begin
                                cMeldung := cMeldung + '\' + 'Artikel ' + recLotNoInformation."Item No." + ' Chargennr. ' + recLotNoInformation.BASLotNoPHA + ' ist ';
                                cMeldung := cMeldung + FORMAT(recLotNoInformation.Status) + ' ';
                            end;
                        end;
                    end;
                    nCountChecked += 1;

                until (recItemLedgerEntry1.NEXT = 0);

            //-GL016
            //Ist im FA als Validierungscharge eingetragen?
            //recProductionOrder.SetRange("No.", recItemLedgerEntry."Order No.");
            //IF recProductionOrder.FINDSET THEN
            //    IF recProductionOrder.Validierungscharge = TRUE THEN
            //        Message(Text50001);
            /*
                  //-GL019
                  //Chargenplanung laden
                  CLEAR(recChargenPlanung_);
                  IF recItem.Artikelart = recItem.Artikelart::Fertigprodukt THEN BEGIN
                    recChargenPlanung_.GET(COPYSTR(LotNo,1,8));
                  END ELSE BEGIN
                    recChargenPlanung_.GET(LotNo);
                  END;

                  //Kommt die Validierungscharge von der Chargenplanung, dann vom HF kommend
                  IF (recChargenPlanung_.Validierungscharge=TRUE) AND (recChargenPlanung_.ValidierungschargeFertig=FALSE) THEN
                    Message(Text50001);

                  //Kommt die Validierungscharge nur vom FA, dann vom Fertigartikel kommend
                  IF (recChargenPlanung_.Validierungscharge=FALSE) THEN
                    Message(Text50002);
            */
            //+GL019

            //+GL016

        end;
        cInfoText := FORMAT(nCountChecked) + ' Komponenten geprüft' + ' ' + cMeldung;

    end;

    procedure ItemIsBulk(ItemNo: Code[20]): Boolean
    var
        recItem: Record Item;
    begin
        if recItem.GET(ItemNo) then
            if recItem.Artikelart = recItem.Artikelart::Halbfabrikat then
                exit(true);
    end;

    procedure CheckMarktfreigabePin() bReturn: Boolean
    var
        recUserSetup: Record "91";
        recManufacturingSetup: Record "Manufacturing Setup";
        cuNaviPharma: Codeunit BASNaviPharmaPHA;
        cAct: Action;
        tPin: Text[30];
        tPinUser: Text[30];
    begin
        //-GL021
        /*
        bReturn:=FALSE;
        Rec.CALCFIELDS(Artikelart);
        IF Rec.Artikelart=Rec.Artikelart::Fertigprodukt THEN BEGIN   //Nur bei Fertigprodukten
        
          pDialog.SetCaption('Marktfreigabe Pin:');
          pDialog.LOOKUPMODE(true);
          cAct := pDialog.RUNMODAL;
        
        
          IF (cAct = ACTION::OK) OR (cAct = ACTION::LookupOK) THEN BEGIN   //GL027
            IF (pDialog.GetAction()=TRUE) THEN BEGIN
              tPin:=pDialog.GetValue();
              tPin := UPPERCASE(tPin);
        
              //Benutzer Pin holen
              recUserSetup.GET(USERID);
              tPinUser := recUserSetup.MarktfreigabePin;
              IF STRLEN(tPinUser)=0 THEN
                ERROR('Es ist kein PIN für die Marktfreigabe für den Benutzer %1 vorhanden!', USERID);
        
              //Entschlüsseln des Benutzer Pin
              recManufacturingSetup.GET;
              IF recManufacturingSetup.WaagePinVerschlüsselung > 0 THEN
                tPinUser:= cuNaviPharma.StrCrypt(tPinUser, recManufacturingSetup.WaagePinVerschlüsselung, FALSE);
        
              IF NOT (tPinUser=tPin) THEN
                ERROR('Pin nicht korrekt!')
              ELSE
                bReturn:=TRUE;
        
            END ELSE BEGIN
              ERROR('Pin Eingabe wurde Abgebrochen!');
            END;
          END ELSE BEGIN
            ERROR('Pin Eingabe wurde Abgebrochen!');
          END;
        
        END;
        //+GL021
        */

    end;

    local procedure CheckExpDate()
    var
        cuCodesammlung: Codeunit Codesammlung;
        iDayHelp: Integer;
        iMonHelp: Integer;
        tMonHelp: Text[2];
        tMonHelpDM: Text[2];
        tYearHelp: Text[4];
        tYearHelpDM: Text[4];
    begin
        //-GL030
        if ("Expiration Date DM" <> '') then begin
            if STRLEN("Expiration Date DM") < 6 then
                ERROR('DataMatrix Ablaufdatum muss Format JJMMTT (YYMMDD) haben!');

            if EVALUATE(iMonHelp, COPYSTR("Expiration Date DM", 3, 2)) then begin
                if (iMonHelp < 1) or (iMonHelp > 12) then
                    ERROR('DataMatrix Ablaufdatum muss Format JJMMTT (YYMMDD) haben!');
            end else
                ERROR('DataMatrix Ablaufdatum muss Format JJMMTT (YYMMDD) haben!');

            if EVALUATE(iDayHelp, COPYSTR("Expiration Date DM", 5, 2)) then begin
                if (iDayHelp < 0) or (iDayHelp > 31) then
                    ERROR('DataMatrix Ablaufdatum muss Format JJMMTT (YYMMDD) haben!');
            end else
                ERROR('DataMatrix Ablaufdatum muss Format JJMMTT (YYMMDD) haben!');

            if (BASExpirationDatePHA <> 0D) then begin
                tYearHelp := FORMAT(DATE2DMY(BASExpirationDatePHA, 3));
                tYearHelpDM := '20' + COPYSTR("Expiration Date DM", 1, 2);
                tMonHelp := cuCodesammlung.TextAuffuellen(FORMAT(DATE2DMY(BASExpirationDatePHA, 2)), 2, '0');
                tMonHelpDM := COPYSTR("Expiration Date DM", 3, 2);
                if (tYearHelp <> tYearHelpDM) or (tMonHelp <> tMonHelpDM) then
                    if not Confirm('DataMatrix Ablaufdatum: %1-%2 weicht von Ablaufdatum: %3-%4 ab. Trotzdem übernehmen?', false, tMonHelp, tYearHelp, tMonHelpDM, tYearHelpDM) then
                        ERROR('Abgebrochen: DataMatrix Ablaufdatum weicht ab!');
            end;
        end;
        //+GL030
    end;



    local procedure GetVendorNo() VendorNo: Code[50]
    var
        recPurchRcptLine: Record "121";
        LieferNr: Code[50];
    begin
        //-GL036
        VendorNo := '';
        //LieferNr := regEx.Match(xRec.Description, 'EL[\d]+').Value; //Einkaufsliefernr aus Beschreibung auslesen
        CLEAR(recPurchRcptLine);
        if LieferNr <> '' then
            recPurchRcptLine.SetRange("Document No.", LieferNr);
        recPurchRcptLine.SetRange("No.", xRec."Item No.");
        recPurchRcptLine.SetRange(BASLotNoPHA, xRec.BASLotNoPHA);
        //IF Rec.HerstellerNr <> '' THEN
        //  recPurchRcptLine.SetRange(HerstellerNr,xRec.HerstellerNr);
        if recPurchRcptLine.FindFirst then
            VendorNo := recPurchRcptLine."Buy-from Vendor No.";
        //+GL036
    end;




    procedure GetLastChange(What: Option Date,Name) ChangeValue: Text
    var
        ChangeLog: Record "405";
    begin
        ChangeValue := '';
        ChangeLog.SetRange("Table No.", DATABASE::"Lot No. Information");
        ChangeLog.SetRange("Primary Key Field 1 Value", "Item No.");
        ChangeLog.SetRange("Primary Key Field 2 Value", "Variant Code");
        ChangeLog.SetRange("Primary Key Field 3 Value", BASLotNoPHA);
        ChangeLog.SetRange("Type of Change", ChangeLog."Type of Change"::Modification);
        ChangeLog.SETFILTER(ChangeLog."Field No.", '<>50004');  //GL040  Offen Hakerl nicht als Änderung Anzeigen  (Wunsch Magg, Weberhofer)
        if ChangeLog.FINDLAST then begin
            case What of
                What::Date:
                    begin
                        ChangeValue := FORMAT(ChangeLog."Date and Time");
                    end;
                What::Name:
                    begin
                        ChangeValue := ChangeLog."User ID";
                    end;
            end;
        end;
    end;

    trigger OnBeforeDelete()
    var
        ItemJnlLine: Record "Item Journal Line";
        ItemLedgEntry: Record "Item Ledger Entry";
        ItemTrackingComment: Record "Item Tracking Comment";
    begin

        ItemTrackingComment.SetRange(Type, ItemTrackingComment.Type::BASLotNoPHA);
        ItemTrackingComment.SetRange("Item No.", "Item No.");
        ItemTrackingComment.SetRange("Variant Code", "Variant Code");
        ItemTrackingComment.SetRange("Serial/Lot No.", BASLotNoPHA);
        ItemTrackingComment.DELETEALL();


        //-LAN002
        ItemLedgEntry.SETCURRENTKEY("Item No.", BASLotNoPHA);
        ItemLedgEntry.SetRange("Item No.", "Item No.");
        ItemLedgEntry.SetRange(BASLotNoPHA, BASLotNoPHA);
        if not ItemLedgEntry.IsEmpty then
            ERROR('FEHLENDE TEXTVARIABLE 6506', BASLotNoPHA);
        //+LAN002
    end;



    trigger OnBeforeRename()
    var
        ItemJnlLine: Record "Item Journal Line";
        PurchLine: Record "Purchase Line";
        ReservEntry: Record "Reservation Entry";
        SalesLine: Record "Sales Line";
        TrackSpec: Record "Tracking Specification";
        TransLine: Record "Transfer Line";
    begin


        //-GL004
        LotNoCheck();
        //+GL004

        //-LAN003
        if BASLotNoPHA <> xRec.BASLotNoPHA then begin
            PurchLine.SETCURRENTKEY("Document Type", Type, "No.");
            PurchLine.SetRange(Type, PurchLine.Type::Item);
            PurchLine.SetRange("No.", xRec."Item No.");
            PurchLine.SetRange("Variant Code", xRec."Variant Code");
            PurchLine.SetRange(BASLotNoPHA, xRec.BASLotNoPHA);
            if PurchLine.FINDSET(true, true) then
                repeat
                    PurchLine.BASLotNoPHA := BASLotNoPHA;
                    PurchLine.modify;
                until PurchLine.NEXT = 0;

            ReservEntry.SetRange(BASLotNoPHA, xRec.BASLotNoPHA);
            ReservEntry.SetRange("Item No.", xRec."Item No.");
            ReservEntry.SetRange("Variant Code", xRec."Variant Code");
            if ReservEntry.FINDSET(true, true) then
                repeat
                    ReservEntry.BASLotNoPHA := BASLotNoPHA;
                    ReservEntry.modify;
                until ReservEntry.NEXT = 0;

            TrackSpec.SetRange(BASLotNoPHA, xRec.BASLotNoPHA);
            TrackSpec.SetRange("Item No.", xRec."Item No.");
            TrackSpec.SetRange("Variant Code", xRec."Variant Code");
            if TrackSpec.FINDSET(true, true) then
                repeat
                    TrackSpec.BASLotNoPHA := BASLotNoPHA;
                    TrackSpec.modify;
                until TrackSpec.NEXT = 0;

            SalesLine.SETCURRENTKEY("Document Type", Type, "No.");
            SalesLine.SetRange(Type, SalesLine.Type::Item);
            SalesLine.SetRange("No.", xRec."Item No.");
            SalesLine.SetRange("Variant Code", xRec."Variant Code");
            SalesLine.SetRange(BASLotNoPHA, xRec.BASLotNoPHA);
            if SalesLine.FINDSET(true, true) then
                repeat
                    SalesLine.BASLotNoPHA := BASLotNoPHA;
                    SalesLine.modify;
                until SalesLine.NEXT = 0;

            TransLine.SETCURRENTKEY("Item No.");
            TransLine.SetRange("Item No.", xRec."Item No.");
            //TransLine.SetRange(Type, TransLine.Type::Item);
            TransLine.SetRange("Variant Code", xRec."Variant Code");
            //TransLine.SetRange(BASLotNoPHA, xRec.BASLotNoPHA);
            if TransLine.FIND('-') then
                repeat
                    //TransLine.BASLotNoPHA := BASLotNoPHA;
                    TransLine.modify;
                until TransLine.NEXT = 0;

            ItemJnlLine.SetRange("No.", xRec."Item No.");
            ItemJnlLine.SetRange("Variant Code", xRec."Variant Code");
            ItemJnlLine.SetRange(BASLotNoPHA, xRec.BASLotNoPHA);
            if ItemJnlLine.FINDSET(true, true) then
                repeat
                    ItemJnlLine.BASLotNoPHA := BASLotNoPHA;
                    ItemJnlLine.modify;
                until ItemJnlLine.NEXT = 0;



        end;

    end;

    local procedure ChangeStatus(ch: Char)
    begin
        if StrPos(BASChangeStatusPHA, ch) = 0 then
            Evaluate(BASChangeStatusPHA, BASChangeStatusPHA + 'M');

    end;
}