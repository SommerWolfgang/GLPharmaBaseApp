tableextension 50027 BASLotNoInformatioNextPHA extends "Lot No. Information"
{
    fields
    {
        field(50000; BASExpirationDatePHA; Date)
        {
            Caption = 'Expiration Date';
            // ToDo
            trigger OnValidate()
            // var
            //     ChargenVerw: Codeunit BASChargeMgtPHA;
            begin
                // if Rec.BASExpirationDatePHA <> xRec.BASExpirationDatePHA then
                //     ChargenVerw."Aktualisiere Verkaufscharge"("Item No.", BASLotNoPHA, 1, BASSalesLotNoPHA, BASExpirationDatePHA);

                ChangeStatus('E');
            end;
        }
        field(50001; BASSalesLotNoPHA; Code[50])
        {
            trigger OnValidate()
            // var
            //     ChargenVerw: Codeunit BASChargeMgtPHA;
            begin
                // ChargenVerw."Aktualisiere Verkaufscharge"("Item No.", BASLotNoPHA, 0, BASSalesLotNoPHA, BASExpirationDatePHA);
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
                ItemLedgEntry.SetCurrentKey("Item No.", BASSalesLotNoPHA);
                ItemLedgEntry.SetRange("Item No.", "Item No.");
                ItemLedgEntry.SetRange(BASSalesLotNoPHA, BASSalesLotNoPHA);
                ItemLedgEntry.SetRange("Entry Type", ItemLedgEntry."Entry Type"::Consumption);
                if not ItemLedgEntry.IsEmpty then
                    if Confirm('Die Charge ist in Verbrauchsbuchungen vorhanden! Trotzdem ändern?', false) = false then
                        Error('Änderung wurde nicht durchgeführt.');

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
        field(50009; BASLaetusCodePHA; Text[15])
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
                    if not Confirm('Neuer Chargenstatus: ''%1'' entspricht nicht dem Lims-Chargenstatus: ''%2''. Trotzdem übernehmen?', false, Format(Rec.BASStatusPHA), Rec.BASLimsStatusPHA) then
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
                                if not Confirm('Patentschutz für Artikel %1 ist bis zum %2 eingetragen! Trotzdem Freigeben?', false, "Item No.", Item."BASPatentschutz bisPHA") then
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

                if Item.BASItemTypePHA = Item.BASItemTypePHA::"Finished Product" then
                    if uNaviPharma.Permission('$MARKTFREIGABE') = false then
                        Error('Berechtigung für Marktfreigabe nicht vorhanden!');

                if Rec.BASStatusPHA <> xRec.BASStatusPHA then
                    // ToDo
                    ;//CheckMarktfreigabePin();

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
        field(50014; BASItemDescriptionPHA; Text[100])
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
        field(50103; BASManufaturingNoPHA; Code[20])
        {
            Caption = 'Manufacturing No.', comment = 'DEA="Herstellernr."';
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
        // ToDo
        // field(50106; "BASAnzahl FreigabenPHA"; Integer)
        // {
        //     CalcFormula = count("Change Log Entry" where("Table No." = const(6505),
        //                                                   "Primary Key Field 1 Value" = field("Item No."),
        //                                                   "Primary Key Field 3 Value" = field(BASLotNoPHA),
        //                                                   //"New Value" = const(1),
        //                                                   "Field No." = const(50010)));
        //     Editable = false;
        //     FieldClass = FlowField;
        // }
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

    procedure CheckComponents(ItemNo: Text[20]; LotNo: Text[20]; bMehrstufig: Boolean; var cInfoText: Text[1000]) cMeldung: Text
    var
        Item: Record Item;
        ItemLedgerEntry: Record "Item Ledger Entry";
        ItemLedgerEntry2: Record "Item Ledger Entry";
        LotNoInformation: Record "Lot No. Information";
        CountChecked: Integer;
    begin
        if Item.GET(ItemNo) then
            if Item.BASItemTypePHA = Item.BASItemTypePHA::"Row Material" then begin
                cInfoText := 'Rohstoffe werden nicht geprüft!';  //Update2013
                exit;
            end;

        CountChecked := 0;
        ItemLedgerEntry.SetCurrentKey("Item No.", BASSalesLotNoPHA, "Posting Date");
        ItemLedgerEntry.SetFilter(BASSalesLotNoPHA, LotNo);
        ItemLedgerEntry.SetFilter("Item No.", ItemNo);
        ItemLedgerEntry.SetRange("Entry Type", ItemLedgerEntry."Entry Type"::Output);
        if ItemLedgerEntry.FindFirst() then begin
            ItemLedgerEntry2.SetCurrentKey("Order Type", "Order No.", "Order Line No.", "Entry Type", "Prod. Order Comp. Line No.");
            ItemLedgerEntry2.SetRange("Order Type", ItemLedgerEntry."Order Type"::Production);
            ItemLedgerEntry2.SetFilter("Order No.", ItemLedgerEntry."Order No.");
            ItemLedgerEntry2.SetFilter("Entry Type", 'Verbrauch|Abgang');
            if ItemLedgerEntry2.FindSet() then
                repeat
                    LotNoInformation.SetFilter("Item No.", ItemLedgerEntry2."Item No.");
                    LotNoInformation.SetFilter(BASSalesLotNoPHA, ItemLedgerEntry2.BASSalesLotNoPHA);
                    if LotNoInformation.FindFirst() then
                        if LotNoInformation.BASStatusPHA <> LotNoInformation.BASStatusPHA::Free then begin
                            if not ItemIsBulk(ItemNo) and ItemIsBulk(LotNoInformation."Item No.") then
                                cMeldung := cMeldung + '\' + 'Artikel ' + LotNoInformation."Item No." + ' Chargennr. ' + LotNoInformation.BASSalesLotNoPHA + ' ist ';
                            cMeldung := cMeldung + Format(LotNoInformation.BASStatusPHA) + ' ';
                        end;
                    CountChecked += 1;
                until ItemLedgerEntry2.Next() = 0;
        end;
        Evaluate(cInfoText, Format(CountChecked) + ' Komponenten geprüft' + ' ' + cMeldung);
    end;

    procedure ItemIsBulk(ItemNo: Code[20]): Boolean
    var
        Item: Record Item;
    begin
        if Item.GET(ItemNo) then
            exit(Item.BASItemTypePHA = Item.BASItemTypePHA::"Semifinished Product");
    end;

    // ToDo
    local procedure CheckExpDate()
    var
        // cuCodesammlung: Codeunit Codesammlung;
        iDayHelp: Integer;
        iMonHelp: Integer;
        tMonHelp: Text[2];
        tMonHelpDM: Text[2];
        tYearHelp: Text[4];
        tYearHelpDM: Text[4];
    begin
        if BASExpirationDateDMPHA <> '' then begin
            if StrLen(BASExpirationDateDMPHA) < 6 then
                Error('DataMatrix Ablaufdatum muss Format JJMMTT (YYMMDD) haben!');

            if Evaluate(iMonHelp, CopyStr(BASExpirationDateDMPHA, 3, 2)) then begin
                if (iMonHelp < 1) or (iMonHelp > 12) then
                    Error('DataMatrix Ablaufdatum muss Format JJMMTT (YYMMDD) haben!');
            end else
                Error('DataMatrix Ablaufdatum muss Format JJMMTT (YYMMDD) haben!');

            if Evaluate(iDayHelp, CopyStr(BASExpirationDateDMPHA, 5, 2)) then begin
                if (iDayHelp < 0) or (iDayHelp > 31) then
                    Error('DataMatrix Ablaufdatum muss Format JJMMTT (YYMMDD) haben!');
            end else
                Error('DataMatrix Ablaufdatum muss Format JJMMTT (YYMMDD) haben!');

            if (BASExpirationDatePHA <> 0D) then begin
                tYearHelp := Format(DATE2DMY(BASExpirationDatePHA, 3));
                tYearHelpDM := '20' + CopyStr(BASExpirationDateDMPHA, 1, 2);
                // ToDo
                // tMonHelp := cuCodesammlung.TextAuffuellen(Format(DATE2DMY(BASExpirationDatePHA, 2)), 2, '0');
                tMonHelpDM := CopyStr(BASExpirationDateDMPHA, 3, 2);
                if (tYearHelp <> tYearHelpDM) or (tMonHelp <> tMonHelpDM) then
                    if not Confirm('DataMatrix Ablaufdatum: %1-%2 weicht von Ablaufdatum: %3-%4 ab. Trotzdem übernehmen?', false, tMonHelp, tYearHelp, tMonHelpDM, tYearHelpDM) then
                        Error('Abgebrochen: DataMatrix Ablaufdatum weicht ab!');
            end;
        end;
        //+GL030
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
        ItemLedgEntry: Record "Item Ledger Entry";
        ItemTrackingComment: Record "Item Tracking Comment";
    begin
        ItemTrackingComment.Reset();
        ItemTrackingComment.SetRange(Type, ItemTrackingComment.Type::"Lot No.");
        ItemTrackingComment.SetRange("Item No.", "Item No.");
        ItemTrackingComment.SetRange("Variant Code", "Variant Code");
        ItemTrackingComment.SetRange("Serial/Lot No.", BASSalesLotNoPHA);
        ItemTrackingComment.DeleteAll();

        ItemLedgEntry.SetCurrentKey("Item No.", BASSalesLotNoPHA);
        ItemLedgEntry.SetRange("Item No.", "Item No.");
        ItemLedgEntry.SetRange(BASSalesLotNoPHA, BASSalesLotNoPHA);
        if not ItemLedgEntry.IsEmpty then
            Error('FEHLENDE TEXTVARIABLE 6506');
    end;

    trigger OnBeforeRename()
    var
        ItemJnlLine: Record "Item Journal Line";
        PurchLine: Record "Purchase Line";
        ReservEntry: Record "Reservation Entry";
        SalesLine: Record "Sales Line";
        TrackSpec: Record "Tracking Specification";
    begin
        CheckLotNo();
        if BASSalesLotNoPHA <> xRec.BASSalesLotNoPHA then begin
            PurchLine.SetCurrentKey("Document Type", Type, "No.");
            PurchLine.SetRange(Type, PurchLine.Type::Item);
            PurchLine.SetRange("No.", xRec."Item No.");
            PurchLine.SetRange("Variant Code", xRec."Variant Code");
            PurchLine.SetRange(BASLotNoPHA, xRec.BASSalesLotNoPHA);
            if PurchLine.FindSet() then
                repeat
                    PurchLine.BASLotNoPHA := BASSalesLotNoPHA;
                    PurchLine.Modify();
                until PurchLine.Next() = 0;

            ReservEntry.SetRange(BASSalesLotNoPHA, xRec.BASSalesLotNoPHA);
            ReservEntry.SetRange("Item No.", xRec."Item No.");
            ReservEntry.SetRange("Variant Code", xRec."Variant Code");
            if ReservEntry.FindSet() then
                repeat
                    ReservEntry.BASSalesLotNoPHA := BASSalesLotNoPHA;
                    ReservEntry.Modify();
                until ReservEntry.Next() = 0;

            TrackSpec.SetRange(BASSalesLotNoPHA, xRec.BASSalesLotNoPHA);
            TrackSpec.SetRange("Item No.", xRec."Item No.");
            TrackSpec.SetRange("Variant Code", xRec."Variant Code");
            if TrackSpec.FindSet() then
                repeat
                    TrackSpec.BASSalesLotNoPHA := BASSalesLotNoPHA;
                    TrackSpec.Modify();
                until TrackSpec.Next() = 0;

            SalesLine.SetCurrentKey("Document Type", Type, "No.");
            SalesLine.SetRange(Type, SalesLine.Type::Item);
            SalesLine.SetRange("No.", xRec."Item No.");
            SalesLine.SetRange("Variant Code", xRec."Variant Code");
            SalesLine.SetRange(BASLotNoPHA, xRec.BASSalesLotNoPHA);
            if SalesLine.FindSet() then
                repeat
                    SalesLine.BASLotNoPHA := BASSalesLotNoPHA;
                    SalesLine.Modify();
                until SalesLine.Next() = 0;

            ItemJnlLine.SetRange("No.", xRec."Item No.");
            ItemJnlLine.SetRange("Variant Code", xRec."Variant Code");
            ItemJnlLine.SetRange(BASSalesLotNoPHA, xRec.BASSalesLotNoPHA);
            if ItemJnlLine.FindSet() then
                repeat
                    ItemJnlLine.BASSalesLotNoPHA := BASSalesLotNoPHA;
                    ItemJnlLine.Modify();
                until ItemJnlLine.Next() = 0;
        end;
    end;

    local procedure ChangeStatus(ch: Char)
    begin
        if StrPos(BASChangeStatusPHA, ch) = 0 then
            Evaluate(BASChangeStatusPHA, BASChangeStatusPHA + 'M');

    end;
}