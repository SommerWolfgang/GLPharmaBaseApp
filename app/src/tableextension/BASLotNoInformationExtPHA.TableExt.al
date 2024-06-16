tableextension 50027 BASLotNoInformationExtPHA extends "Lot No. Information"
{
    fields
    {
        field(50000; BASExpirationDatePHA; Date)
        {
            Caption = 'Expiration Date';


            trigger OnValidate()
            var
                ChargenVerw: Codeunit BASChargeMgtPHA;
            begin

                // ToDo
                // if Rec.BASExpirationDatePHA <> xRec.BASExpirationDatePHA then
                //     ChargenVerw."Aktualisiere Verkaufscharge"("Item No.", BASLotNoPHA, 1, BASSalesLotNoPHA, BASExpirationDatePHA);

                ChangeStatus('E');
            end;
        }
        field(50001; BASSalesLotNoPHA; Code[20])
        {
            trigger OnValidate()
            var
                ChargenVerw: Codeunit ChargenMgt;
            begin
                ChargenVerw."Aktualisiere Verkaufscharge"("Item No.", BASLotNoPHA, 0, BASSalesLotNoPHA, BASExpirationDatePHA);

                ChangeStatus('Y');
            end;
        }
        field(50002; BASShipmentLotNoPHA; Code[20])
        {
            trigger OnValidate()
            begin
                ChangeStatus('D');
            end;
        }
        field(50003; BASShipmentFinishedDatePHA; Date)
        {
        }
        field(50004; BASOpenPHA; Boolean)
        {
            Caption = 'Open', comment = 'DEA="Offen"';
        }
        field(50005; BASReleaseDatePHA; Date)
        {
            Caption = 'Release Date', comment = 'DEA="Freigabedatum"';
        }
        field(50006; BASReleaseNamePHA; Text[50])
        {
            Caption = 'Release Name', comment = 'DEA="Freigabename"';
        }
        field(50007; BASGehaltPHA; Decimal)
        {


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


            trigger OnValidate()
            begin
                ChangeStatus('M');
            end;
        }
        field(50009; "BASLaetus-CodePHA"; Text[15])
        {


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
                bLotStatusMismatch := false;

                case Rec.BASStatusPHA of
                    Rec.BASStatusPHA::Free:
                        if StrPos(UPPERCASE(Rec.BASLimsStatusPHA), 'FREI') = 0 then //FREI, FREIGEGEBEN
                            bLotStatusMismatch := true;
                    Rec.BASStatusPHA::Quarantine:
                        if StrPos(UPPERCASE(Rec.BASLimsStatusPHA), 'QUARANT') = 0 then //QUARANTINE, QUARANTÄNE
                            bLotStatusMismatch := true;
                    Rec.BASStatusPHA::Blocked:
                        if StrPos(UPPERCASE(Rec.BASLimsStatusPHA), 'GESPERRT') = 0 then
                            bLotStatusMismatch := true;
                end;

                if bLotStatusMismatch then
                    if not Confirm('Neuer Chargenstatus: ''%1'' entspricht nicht dem Lims-Chargenstatus: ''%2''. Trotzdem übernehmen?', false, FORMAT(Rec.Status), Rec.LimsStatus) then
                        Error('');

                if Rec.BASStatusPHA = Rec.BASStatusPHA::Free then begin
                    if (BASExpirationDatePHA < Today) then
                        Error('Bevor Sie den Freigabestatus auf "Frei" setzen können, muss die Charge mit einem gültigen Ablaufdatum versehen werden!');

                    if not Item.GET("Item No.") then
                        Error('Artikel %1 ist nicht im Artikelstamm angelegt!', "Item No.");

                    if not uNaviPharma.PrüfeUnterstufeFrei(Rec."Item No.", Rec.BASSalesLotNoPHA, false, true, true) then
                        if not Confirm('Das System lässt die Freigabe dieser Charge zu. Bitte beachten Sie jedoch, dass ' +
                        ' zumindest eine unfreie Unterstufe erkannt wurde! \' +
                        'Bitte kontrollieren Sie die Stati mit "Gesamtübersicht beteiligte Artikel"\' +
                        'CHARGE FREIGEBEN?')
                        then begin
                            BASStatusPHA := xRec.BASStatusPHA;
                            exit;
                        end;
                end;

                if (xRec.BASStatusPHA = xRec.BASStatusPHA::Free) and (xRec.BASStatusPHA <> Rec.BASStatusPHA) then
                    ChangeStatus('S');

                if (BASStatusPHA = BASStatusPHA::Free) and (xRec.BASStatusPHA <> BASStatusPHA::Free) then
                    if Item.Get("Item No.") then
                        if Item.BASItemTypePHA = Item.BASItemTypePHA::"Finished Product" then
                            if Item."BASPatentschutz bisPHA" >= Today then
                                if Confirm('Patentschutz für Artikel %1 ist bis zum %2 eingetragen! Trotzdem Freigeben?', false, "Item No.", Item."Patentschutz bis") = false then
                                    Error('Chargenfreigabe wurde abgebrochen!');

                if (BASStatusPHA = BASStatusPHA::Free) and (xRec.BASStatusPHA <> BASStatusPHA::Free) then
                    if Item.Get("Item No.") then
                        if Item.BASItemTypePHA = Item.BASItemTypePHA::"Finished Product" then
                            if Item."Vermarktungsexklusivität bis" >= Today then
                                if Confirm('Vermarktungsexklusivität für Artikel %1 ist bis zum %2 eingetragen! Trotzdem Freigeben?', false, "Item No.", Item."Vermarktungsexklusivität bis") = false then
                                    Error('Chargenfreigabe wurde abgebrochen!');

                if Rec.BASStatusPHA = Rec.BASStatusPHA::Free then begin
                    if Rec.BASExpirationDatePHA = 0D then
                        Error('Bitte vergeben Sie ein Ablaufdatum für die Charge!');
                    if not uNaviPharma.AblaufDatumPlausibel("Item No.", BASExpirationDatePHA) then
                        Rec.BASStatusPHA := xRec.BASStatusPHA;
                end;

                cInfoText := '';
                cText := CheckComponents(Rec."Item No.", Rec.BASSalesLotNoPHA, false, cInfoText);
                if (cText <> '') and (BASStatusPHA = BASStatusPHA::Free) then
                    if not Confirm(cText + '- trotzdem freigeben?') then
                        Error('Freigabe wird abgebrochen');

                if not Item.Get("Item No.") then
                    Error('Artikel %1 ist nicht im Artikelstamm angelegt!', "Item No.");

                if (Item.BASItemTypePHA = Item.BASItemTypePHA::"Finished Product") then
                    if uNaviPharma.Permission('$MARKTFREIGABE') = false then
                        Error('Berechtigung für Marktfreigabe nicht vorhanden!');

                if Rec.BASStatusPHA <> xRec.BASStatusPHA then
                    CheckMarktfreigabePin();

                // if (BASStatusPHA = BASStatusPHA::Free) and (xRec.BASStatusPHA <> BASStatusPHA::Free) then begin
                //     BASFreigabedatumPHA := Today;
                //     Freigabename := UserId;
                // end;
            end;
        }
        field(50011; BASPackmittelversionPHA; Code[20])
        {
            trigger OnValidate()
            begin
                ChangeStatus('P');
            end;
        }
        // field(50012; BASLagerstandPHA; Decimal)
        // {
        //     CalcFormula = sum("Item Ledger Entry".Quantity where("Item No." = field("Item No."),
        //                                                           BASLotNoPHA = field(BASLotNoPHA)));
        //     DecimalPlaces = 0 : 5;
        //     Editable = false;
        //     FieldClass = FlowField;
        // }
        field(50013; "Rückstellmuster"; Integer)
        {

        }
        field(50014; BASArtikelnamePHA; Text[50])
        {
            CalcFormula = lookup(Item.Description where("No." = field("Item No.")));
            FieldClass = FlowField;
        }
        field(50015; BASArtikelartPHA; enum BASItemTypePHA)
        {
            CalcFormula = lookup(Item.BASItemTypePHA where("No." = field("Item No.")));
            FieldClass = FlowField;
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
            CalcFormula = lookup(Item.BASPackageSizePHA where("No." = field("Item No.")));
            FieldClass = FlowField;
        }
        field(50102; "BASCEP NrPHA"; Code[50])
        {
        }
        field(50103; BASHerstellerNrPHA; Code[20])
        {
        }
        field(50104; BASExpirationDateDMPHA; Text[6])
        {
            Numeric = true;
            trigger OnValidate()
            begin
                CheckExpDate();
            end;
        }
        field(50105; BASHFCommentPHA; Text[100])
        {
        }
        field(50106; "BASAnzahl FreigabenPHA"; Integer)
        {
            CalcFormula = count("Change Log Entry" where("Table No." = const(6505),
                                                          "Primary Key Field 1 Value" = field("Item No."),
                                                          "Primary Key Field 3 Value" = field(BASLotNoPHA),
                                                          //"New Value" = const(1),
                                                          "Field No." = const(50010)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(50117; BASLimsStatusPHA; Code[29])
        {
        }
        field(50118; BASLimsImportInProgressPHA; Boolean)
        {
        }
        field(50119; BASLimsBacklogEntriesPHA; Integer)
        {
        }
        field(50120; BASItemBlockedPHA; Boolean)
        {
            CalcFormula = lookup(Item.Blocked where("No." = field("Item No.")));
            Caption = 'Artikel gesperrt';
            FieldClass = FlowField;
        }
        field(50507; "BASStatistikcode IPHA"; Code[10])
        {
            CalcFormula = lookup(Item.BASStatisticCodeIPHA where("No." = field("Item No.")));
            Editable = false;
            FieldClass = FlowField;
            TableRelation = BASStatisticCodePHA.Code where(Level = const(1));
        }
        field(50508; "BASStatistikcode IIPHA"; Code[10])
        {
            CalcFormula = lookup(Item.BASStatisticCodeIIPHA where("No." = field("Item No.")));
            Editable = false;
            FieldClass = FlowField;
            TableRelation = BASStatisticCodePHA.Code where(Level = const(2));
        }
        field(50509; "BASStatistikcode IIIPHA"; Code[10])
        {
            CalcFormula = lookup(Item.BASStatisticCodeIIIPHA where("No." = field("Item No.")));
            Editable = false;
            FieldClass = FlowField;
            TableRelation = BASStatisticCodePHA.Code where(Level = const(3));
        }
        // field(50510; BASChangeDatePHA; DateTime)
        // {
        //     CalcFormula = max("Change Log Entry"."Date and Time" where("Table No." = const(6505),
        //                                                                 "Primary Key Field 1 Value" = field("Item No."),
        //                                                                 "Primary Key Field 2 Value" = field("Variant Code"),
        //                                                                 "Primary Key Field 3 Value" = field(BASLotNoPHA),
        //                                                                 "Type of Change" = filter(Modification)));
        //     Editable = false;
        //     FieldClass = FlowField;
        // }
        field(50511; BASErstablaufdatumPHA; Date)
        {
        }
        field(50512; BASProduktionsdatumPHA; Date)
        {
        }
        field(50513; BASEntryDatePHA; Date)
        {
            Caption = 'Zugangsdatum';
        }
    }
    procedure CheckLotNo()
    var
        Item: Record Item;
        LotNoInformation: Record "Lot No. Information";
    begin
        Item.GET("Item No.");
        if Item.BASItemTypePHA in [Item.BASItemTypePHA::"Row Material", Item.BASItemTypePHA::"Package Material"] then begin
            LotNoInformation.SetCurrentKey(BASSalesLotNoPHA);
            LotNoInformation.SetRange(BASSalesLotNoPHA, BASSalesLotNoPHA);
            if LotNoInformation.FindFirst() then
                if LotNoInformation."Item No." <> "Item No." then
                    Error('Rohstoffcharge wurde schon zu anderer Artikelnummer vergeben!');
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
            if recItem.BASItemTypePHA = recItem.BASItemTypePHA::"Row Material" then begin
                cInfoText := 'Rohstoffe werden nicht geprüft!';  //UPDATE2013
                exit;
            end;
        nCountChecked := 0;
        recItemLedgerEntry.SETCURRENTKEY("Item No.", BASLotNoPHA, "Posting Date");
        // recItemLedgerEntry.SetFilter(BASLotNoPHA, LotNo);
        recItemLedgerEntry.SetFilter("Item No.", ItemNo);
        recItemLedgerEntry.SetRange("Entry Type", recItemLedgerEntry."Entry Type"::Output);
        if recItemLedgerEntry.FindSet() then begin

            //-UPDATE2013
            //neu
            recItemLedgerEntry1.SETCURRENTKEY("Order Type", "Order No.", "Order Line No.", "Entry Type", "Prod. Order Comp. Line No.");
            recItemLedgerEntry1.SetRange("Order Type", recItemLedgerEntry."Order Type"::Production);
            recItemLedgerEntry1.SetFilter("Order No.", recItemLedgerEntry."Order No.");
            //Alt
            //recItemLedgerEntry1.SETCURRENTKEY("Prod. Order No.","Prod. Order Line No.","Entry Type","Prod. Order Comp. Line No.");
            //recItemLedgerEntry1.SetFilter("Prod. Order No.", recItemLedgerEntry."Prod. Order No.");
            //+UPDATE2013
            recItemLedgerEntry1.SetFilter("Entry Type", 'Verbrauch|Abgang');
            if recItemLedgerEntry1.FindSet() then
                repeat
                    recLotNoInformation.SetFilter("Item No.", recItemLedgerEntry1."Item No.");
                    recLotNoInformation.SetFilter(BASLotNoPHA, recItemLedgerEntry1.BASLotNoPHA);
                    if recLotNoInformation.FindFirst() then
                        if recLotNoInformation.BASStatusPHA <> recLotNoInformation.BASStatusPHA::Free then begin
                            if not ItemIsBulk(ItemNo) and ItemIsBulk(recLotNoInformation."Item No.") then
                                cMeldung := cMeldung + '\' + 'Artikel ' + recLotNoInformation."Item No." + ' Chargennr. ' + recLotNoInformation.BASLotNoPHA + ' ist ';
                            cMeldung := cMeldung + FORMAT(recLotNoInformation.Status) + ' ';
                        end;
                    nCountChecked += 1;
                until recItemLedgerEntry1.Next() = 0;
        end;
        Evaluate(cInfoText, Format(nCountChecked) + ' Komponenten geprüft' + ' ' + cMeldung);
    end;

    procedure ItemIsBulk(ItemNo: Code[20]): Boolean
    var
        Item: Record Item;
    begin
        if Item.GET(ItemNo) then
            exit(Item.BASItemTypePHA = Item.BASItemTypePHA::"Semifinished Product");
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




    procedure GetLastChange(What: Option Date,Name): Text
    var
        ChangeLogEntry: Record "Change Log Entry";
    begin
        ChangeLogEntry.SetRange("Table No.", DATABASE::"Lot No. Information");
        ChangeLogEntry.SetRange("Primary Key Field 1 Value", "Item No.");
        ChangeLogEntry.SetRange("Primary Key Field 2 Value", "Variant Code");
        // ToDo -> hardcoded!!! <>50004 and BASLotNoPHA-Field in change log entry
        // ChangeLog.SetRange("Primary Key Field 3 Value", BASLotNoPHA);
        ChangeLogEntry.SetRange("Type of Change", ChangeLogEntry."Type of Change"::Modification);
        ChangeLogEntry.SetFilter(ChangeLogEntry."Field No.", '<>50004');
        if ChangeLogEntry.FindLast() then
            case What of
                What::Date:
                    exit(Format(ChangeLogEntry."Date and Time"));
                What::Name:
                    exit(ChangeLogEntry."User ID");
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
        CheckLotNo();
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
            if TransLine.FindSet() then
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