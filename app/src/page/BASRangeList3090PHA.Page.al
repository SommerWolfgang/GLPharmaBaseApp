
page 50013 BASRangeList3090PHA
{
    ApplicationArea = Basic, Suite;
    PageType = List;
    Permissions =
        tabledata "Bin Content" = R,
        tabledata "Item Ledger Entry" = R,
        tabledata Location = R,
        tabledata "Lot No. Information" = R,
        tabledata "BASRechnung MailversandPHA" = R,
        tabledata Item = RIMD;
    SaveValues = false;
    SourceTable = Item;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            group(Einstellungen)
            {
                field(Stichtag; dStichtag)
                {

                    trigger OnValidate()
                    begin

                        //Page neu berechnen
                        CurrPage.UPDATE(TRUE);
                    end;
                }
            }
            repeater(Group)
            {
                field("No."; Rec."No.")
                {
                    ToolTip = 'Artikelnummer';

                }
                field(Description; Rec.Description)
                {
                }
                field("Packungsgröße"; Rec."Packungsgröße")
                {
                    ApplicationArea = BasicIT;
                    Caption = 'Packungsgröße';
                }
                field(FAP; Rec.FAP(Rec."No."))
                {
                    ApplicationArea = BasicIT;
                    Visible = false;

                }
                field("HK (9HK)"; Rec.HK(Rec."No."))
                {
                    ApplicationArea = BasicIT;
                    Visible = false;
                }
                field(DB; Rec.FAP(Rec."No.") - Rec.HK(Rec."No."))
                {
                    Visible = false;
                }
                field("Reichweite 30"; sReichweite30)
                {
                    Caption = 'Reichweite 30';
                    //TODODecimalPlaces = 0 : 0;
                    Style = Favorable;
                    StyleExpr = StatusFarbe30;
                }
                field("Reichweite 90"; sReichweite90)
                {
                    Caption = 'Reichweite 90';
                    //TODODecimalPlaces = 0 : 0;
                    Style = Favorable;
                    StyleExpr = StatusFarbe90;
                }
                field(Inventory; Rec.Inventory)
                {
                    Caption = 'Inventory';
                    ToolTip = 'Lagerbestand in Lagerorten L/S/W';
                }
                field("Lagerbestand Frei"; dLagerstandFrei)
                {
                }
                field("Lagerbestand Quarantäne"; dLagerstandQ)
                {
                }
                //TODO field(InventoryTotal; InventoryTotal)
                //{
                //    ToolTip = 'Lagerbestand alle Lagerorte, inklusive Lohn und Sperrlager';
                //}
                field("Gesperrter Lagerbestand"; NaviPharma.LagerStandGesperrt(Rec."No."))
                {
                    Caption = 'Gesperrter Lagerbestand';
                    DecimalPlaces = 0 : 0;
                    Visible = false;
                }
                field("Absatz 30"; Absatz30)
                {
                    Caption = 'Absatz 30';
                    DecimalPlaces = 0 : 0;
                }
                field("Absatz 90"; Absatz90)
                {
                    Caption = 'Absatz 90';
                    DecimalPlaces = 0 : 0;
                }
                field("Qty. on Purch. Order"; Rec."Qty. on Purch. Order")
                {
                }
                field("Ältestes Ablaufdatum"; OldestExpirationDate)
                {
                    Caption = 'Ältestes Ablaufdatum';
                    //TODODecimalPlaces = 0 : 0;
                }
                field("Menge ältestes Ablaufdatum"; ExpiredQuantity)
                {
                    Caption = 'Menge ältestes Ablaufdatum';
                    DecimalPlaces = 0 : 0;
                }
                field(AbsatzHilfslieferung90; AbsatzHilfslieferung90)
                {
                    Caption = 'Absatz Hilfslieferung 90';
                    DecimalPlaces = 0 : 0;
                }
                field("Lagerplätze"; GetLagerplätze())
                {
                    Visible = LagerplätzeVisible;
                }
                field("Site Manufacturing"; Rec."Site Manufacturing")
                {
                }
                /* TODO field("Wirkstoff Statcode 3"; "Wirkstoff Statcode 3")
                {
                }
                */
                field("Reichweite 30 Freier Lagerstand"; sReichweite30Frei)
                {
                    StyleExpr = StatusFarbe30Frei;
                    Visible = true;
                }
                field("Reichweite 90 Freier Lagerstand"; sReichweite90Frei)
                {
                    StyleExpr = StatusFarbe90Frei;
                    Visible = true;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Lagerplätze anzeigen")
            {
                Image = Bins;

                trigger OnAction()
                begin
                    LagerplätzeVisible := NOT LagerplätzeVisible;
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    var
        recItem: Record "27";
        dReichweite30: Decimal;
        dReichweite30Frei: Decimal;
        dReichweite90: Decimal;
        dReichweite90Frei: Decimal;

    begin

        ExpiredQuantity := 0;
        sReichweite30 := s_INFINITE;
        sReichweite90 := s_INFINITE;
        sReichweite30Frei := s_INFINITE;
        sReichweite90Frei := s_INFINITE;

        //Interne Verkäufe ausnehmen
        Rec.SETRANGE("Date Filter", dStichtag - 30, dStichtag);
        Rec.CALCFIELDS("Sales (Qty.) Deb Filter");
        Absatz30 := Rec."Sales (Qty.) Deb Filter";



        Rec.SETRANGE("Date Filter", dStichtag - 90, dStichtag);
        Rec.CALCFIELDS("Sales (Qty.) Deb Filter");
        Absatz90 := Rec."Sales (Qty.) Deb Filter";


        // MFU 10.09.2021
        dLagerstandFrei := 0;
        dLagerstandQ := 0;
        IF recItem.GET(Rec."No.") THEN BEGIN
            dLagerstandFrei := CodesammlungGLDE.LagerstandStatus(Rec."No.", 'QUARANTÄNE', ''); // >>  CCU104.04
            dLagerstandQ := CodesammlungGLDE.LagerstandStatus(Rec."No.", 'STATUS', '');
        END;


        //Fakturierte Menge mit Statistikcode 6 (Hilfslieferungen) aus Artikelposten holen
        AbsatzHilfslieferung90 := 0;
        CLEAR(Artikelposten);

        // >> CCU104.03
        AbsatzHilfslieferung90 := GetHilfslieferung(Rec."No.", dStichtag - 90, dStichtag);
        AbsatzHilfslieferung30 := GetHilfslieferung(Rec."No.", dStichtag - 30, dStichtag);
        IF AbsatzHilfslieferung90 <> 0 THEN
            Absatz90 -= AbsatzHilfslieferung90;
        IF AbsatzHilfslieferung30 <> 0 THEN
            Absatz30 -= AbsatzHilfslieferung30;
        // << CCU104.03

        Rec.SETRANGE("Date Filter", 0D, dStichtag);

        Artikelposten.SETCURRENTKEY("Item No.", Open, "Variant Code", Positive, "Location Code", "Posting Date");



        Artikelposten.SETRANGE("Item No.", Rec."No.");
        Artikelposten.SETRANGE("Posting Date", 0D, dStichtag);
        Artikelposten.SETFILTER("Location Code", Rec.GETFILTER("Location Filter"));
        Artikelposten.CALCSUMS(Quantity);
        Rec.Inventory := Artikelposten.Quantity;


        IF Absatz30 <> 0 THEN BEGIN
            dReichweite30 := Rec.Inventory / Absatz30;  //Inventory
            sReichweite30 := FORMAT(dReichweite30, 0, '<Precision,2:2><Standard Format,0>');
            dReichweite30Frei := dLagerstandFrei / Absatz30;  //Inventory  MFU 14.09  InventoryFreeLagerort
            sReichweite30Frei := FORMAT(dReichweite30Frei, 0, '<Precision,2:2><Standard Format,0>');
        END;
        IF Absatz90 <> 0 THEN BEGIN
            dReichweite90 := Rec.Inventory / Absatz90 * 3;   //Inventory
            sReichweite90 := FORMAT(dReichweite90, 0, '<Precision,2:2><Standard Format,0>');
            dReichweite90Frei := dLagerstandFrei / Absatz90 * 3;   //Inventory
            sReichweite90Frei := FORMAT(dReichweite90Frei, 0, '<Precision,2:2><Standard Format,0>');
        END;

        //CCU358
        StatusFarbe30 := 'Standard';
        IF (Absatz30 <> 0) AND (sReichweite30 <> s_INFINITE) THEN BEGIN  //bloß angelegte Artikel sollen nicht stören
            IF (dReichweite30 <= 4.0) AND (dReichweite30 >= 2.0) THEN
                StatusFarbe30 := 'Ambiguous';
            IF (dReichweite30 < 2.0) AND (dReichweite30 > 0.5) THEN  //MFU 10.02.2022
                StatusFarbe30 := 'Attention';
            IF (dReichweite30 <= 0.5) THEN
                StatusFarbe30 := 'Unfavorable';
        END;

        StatusFarbe90 := 'Standard';
        IF (Absatz90 <> 0) AND (sReichweite90 <> s_INFINITE) THEN BEGIN  //bloß angelegte Artikel sollen nicht stören
            IF (dReichweite90 <= 4.0) AND (dReichweite90 >= 2.0) THEN
                StatusFarbe90 := 'Ambiguous';
            IF (dReichweite30 < 2.0) AND (dReichweite30 > 0.5) THEN  //MFU 10.02.2022
                StatusFarbe90 := 'Attention';
            IF (dReichweite90 <= 0.5) THEN
                StatusFarbe90 := 'Unfavorable';
        END;

        StatusFarbe30Frei := 'Standard';
        IF (Absatz30 <> 0) AND (sReichweite30 <> s_INFINITE) THEN BEGIN  //bloß angelegte Artikel sollen nicht stören
            IF (dReichweite30 <= 4.0) AND (dReichweite30Frei >= 2.0) THEN
                StatusFarbe30Frei := 'Ambiguous';
            IF (dReichweite30 < 2.0) AND (dReichweite30 > 0.5) THEN  //MFU 10.02.2022
                StatusFarbe30Frei := 'Attention';
            IF (dReichweite30Frei <= 0.5) THEN
                StatusFarbe30Frei := 'Unfavorable';
        END;

        StatusFarbe90frei := 'Standard';
        IF (Absatz90 <> 0) AND (sReichweite90Frei <> s_INFINITE) THEN BEGIN  //bloß angelegte Artikel sollen nicht stören
            IF (dReichweite90Frei <= 4.0) AND (dReichweite90Frei >= 2.0) THEN
                StatusFarbe90frei := 'Ambiguous';
            IF (dReichweite30 < 2.0) AND (dReichweite30 > 0.5) THEN  //MFU 10.02.2022
                StatusFarbe90frei := 'Attention';
            IF (dReichweite90Frei <= 0.5) THEN
                StatusFarbe90frei := 'Unfavorable';
        END;
        //CCU358



        //-001
        Chargenstamm.SETCURRENTKEY("Item No.", Status, "Expiration Date", "Lot No.");  //MFU 10.09.2021 Key geändert
        Chargenstamm.SETFILTER(Status, 'FREI');  //MFU 10.09.2021
        Chargenstamm.SETFILTER("Item No.", Rec."No.");
        Chargenstamm.SETFILTER(Inventory, '>0');
        Chargenstamm.SETFILTER("Location Filter", Rec.GETFILTER("Location Filter"));   //GL002 //GL005

        IF Chargenstamm.FINDFIRST THEN BEGIN

            OldestExpirationDate := Chargenstamm."Expiration Date";
            REPEAT
                //für mehrere chargen mit gleichem Ablaufdatum

                IF (OldestExpirationDate = Chargenstamm."Expiration Date") THEN BEGIN
                    Chargenstamm.CALCFIELDS(Inventory);
                    ExpiredQuantity := ExpiredQuantity + Chargenstamm.Inventory;
                END;
            UNTIL Chargenstamm.NEXT = 0;

        END ELSE BEGIN
            OldestExpirationDate := 0D;
            ExpiredQuantity := 0;
        END;
        //+001



        //>> CCU838.01
        IF (OldestExpirationDate < CALCDATE('<+6M>')) THEN BEGIN
            StatusFarbe30 := 'StandardAccent';
            StatusFarbe90 := 'StandardAccent';
            StatusFarbe30Frei := 'StandardAccent';
            StatusFarbe90frei := 'StandardAccent';
        END;

        //<< CCU838.01
    end;

    trigger OnDeleteRecord(): Boolean
    begin

        ERROR('Löschen von Artikel ist in der Reichweitenliste nicht zulässig!');  //MFU 11.07.2022
    end;

    trigger OnOpenPage()
    begin

        Rec.SETFILTER("Location Filter", 'L|W|S');  //CCU104  -> Lagerortfilter anpassen!!!!!!!!!!!!!!!!!!!!

        Rec.SETFILTER(Artikelart, 'Fertigprodukt');
        Rec.SETRANGE(Blocked, FALSE);

        IF (COMPANYNAME = 'GL-DE') THEN
            Rec.SETRANGE("Country/Region Code", '', 'DE')  //CCU342 -> Ländercode-Filter anpassen
        ELSE
            Rec.SETRANGE("Country/Region Code", '', 'AT');  //CCU342 -> Ländercode-Filter anpassen

        dStichtag := TODAY;
    end;

    var
        Artikelposten: Record "32";
        Chargenstamm: Record "6505";
        Codesammlung: Codeunit 50000;
        NaviPharma: Codeunit 50001;
        CodesammlungGLDE: Codeunit 50004;
        "LagerplätzeVisible": Boolean;
        dStichtag: Date;
        OldestExpirationDate: Date;
        Absatz30: Decimal;
        Absatz90: Decimal;
        AbsatzHilfslieferung30: Decimal;
        AbsatzHilfslieferung90: Decimal;
        dLagerstandFrei: Decimal;
        dLagerstandQ: Decimal;
        ExpiredQuantity: Decimal;
        s_INFINITE: Label 'n/a';
        sReichweite30Frei: Text;
        sReichweite90Frei: Text;
        [InDataSet]
        StatusFarbe30: Text;
        [InDataSet]
        StatusFarbe30Frei: Text;
        [InDataSet]
        StatusFarbe90: Text;
        [InDataSet]
        StatusFarbe90frei: Text;
        sReichweite30: Text[30];
        sReichweite90: Text[30];

    procedure "GetLagerplätze"() "Lagerplätze": Text
    var
        Location: Record "14";
        ILE: Record "32";
        BinContent: Record "7302";
        tmpText: Text;
    begin

        IF (NOT LagerplätzeVisible) OR (Rec.Inventory = 0) THEN
            EXIT('');

        tmpText := '';

        Location.SETFILTER(Code, Rec.GETFILTER("Location Filter"));

        ILE.SETRANGE("Item No.", Rec."No.");
        ILE.SETRANGE(Open, TRUE);

        BinContent.SETRANGE("Item No.", Rec."No.");
        BinContent.SETFILTER(Quantity, '>0');
        BinContent.SETFILTER("Variant Code", Rec."Variant Filter");

        IF Location.FINDSET THEN
            REPEAT
                ILE.SETFILTER("Location Code", Location.Code);
                ILE.CALCSUMS(Quantity);
                IF ILE.Quantity > 0 THEN BEGIN
                    tmpText += Location.Code;
                    BinContent.SETFILTER("Location Code", Location.Code);
                    BinContent.SETFILTER("Bin Code", Rec.GETFILTER("Bin Filter"));
                    IF BinContent.FINDSET THEN BEGIN
                        tmpText += ' (';
                        REPEAT
                            tmpText += BinContent."Bin Code" + '; ';
                        UNTIL BinContent.NEXT = 0;
                        IF STRLEN(tmpText) > 2 THEN
                            tmpText := COPYSTR(tmpText, 1, STRLEN(tmpText) - 2);
                        tmpText += ')'
                    END;
                    tmpText += ', ';
                END;
            UNTIL Location.NEXT = 0;
        IF STRLEN(tmpText) > 2 THEN
            tmpText := COPYSTR(tmpText, 1, STRLEN(tmpText) - 2);
        EXIT(tmpText);
    end;



    local procedure GetHilfslieferung(cItemNo: Code[20]; dtStart: Date; dtEnde: Date) dMenge: Decimal
    var
        ItemLedgerEntry: Record "Item Ledger Entry";
    begin
        /* TODO
        // >> CCU104.03
        CLEAR(ItemLedgerEntry);
        ItemLedgerEntry.SETRANGE("Item No.", cItemNo);
        ItemLedgerEntry.SETRANGE("Entry Type", 1);
        ItemLedgerEntry.SETRANGE("Posting Date", dtStart, dtEnde);
        ItemLedgerEntry.SETRANGE(ItemLedgerEntry.reas, '6');       //Hilfslieferungen   //CCU104  Richtigen Ursachencode nehmen -> In Wertposten mitschreiben!!??? !!!!!!!!!!!!!!!!
        IF "Item Ledger Entry".FINDSET THEN
            REPEAT
                dMenge += (ValueEntryHistory.NRMenge + ValueEntryHistory.VKMenge + ValueEntryHistory.GWMenge);
            UNTIL ValueEntryHistory.NEXT = 0;

        // << CCU104.03
        */
    end;
}



