
//TASK40 TASK40.01          03.04.2024  MFU:  Chargenstamm Anpassungeen: Lagerstand Info dazu

page 50005 UmlagerInfoNeu
{
    ApplicationArea = All;
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = Worksheet;
    SourceTable = "Item Ledger Entry";
    SourceTableTemporary = true;
    UsageCategory = Administration;


    layout
    {
        area(Content)
        {
            group(Filterfeld)
            {

                field(Artikelfilter; FilterText)
                {
                    ApplicationArea = All;
                }

            }
            group(Lagerstand)
            {

                repeater(Control1)
                {
                    IndentationColumn = TreeViewStatus_Temp;
                    ShowAsTree = true;

                    field(Klappen; Rec.TreeViewStatus_Temp)
                    {
                        ApplicationArea = All;
                        Editable = false;
                        Enabled = false;
                        HideValue = true;
                        ToolTip = 'Lagerplatz Aufklappen';
                    }
                    field(ArtikelNr; Rec."Item No.")
                    {
                        ApplicationArea = All;
                    }
                    field(Lagerort; Rec."Location Code")
                    {
                        ApplicationArea = All;
                    }
                    field(Lagerplatz; Rec.Lagerplatzhilfsfeld)
                    {
                        ApplicationArea = All;
                    }
                    field(Chargennr; Rec."Lot No.")
                    {
                        ApplicationArea = All;
                    }
                    field(Restmenge; Rec."Remaining Quantity")
                    {
                        ApplicationArea = All;
                    }

                }
            }
        }
    }

    /*  Keine Actions benötigt
        actions
        {
            area(Processing)
            {
                action("test aktion")
                {
                    ApplicationArea = All;

                    trigger OnAction()
                    begin
                        Message('mfutest');
                    end;
                }
            }
        }
    */

    trigger OnInit()
    begin
        IF Rec.COUNT <> 0 THEN ERROR('Itemledgerentry nicht sourcetabletemporary!!! ');
    end;

    trigger OnOpenPage()
    var

        bChargeFreiFilter: Boolean;
        itemFilterParameter: Code[100];
    begin

        itemfilter := Rec."Item No.";
        IF STRLEN(itemFilterParameter) > 0 THEN
            itemfilter := itemFilterParameter;

        lotFilter := Rec."Lot No.";

        locationfilter := Rec."Location Code";
        IF STRLEN(Rec.GETFILTER("Location Code")) > 0 THEN     //Bei Aufruf aus Auftrag/Rechnung den Logerortfilter nehmen, k�nnen mehrere sein
            locationfilter := Rec.GETFILTER("Location Code");

        // >> CCU32.02
        binfilter := Rec.Lagerplatzhilfsfeld;
        IF STRLEN(Rec.GETFILTER(Lagerplatzhilfsfeld)) > 0 THEN     //Bei Aufruf aus Auftrag/Rechnung den Logerortfilter nehmen, k�nnen mehrere sein
            binfilter := Rec.GETFILTER(Lagerplatzhilfsfeld);
        // << CCU32.02

        IF (STRLEN(itemfilter) = 0) AND (STRLEN(locationfilter) = 0) THEN
            ERROR('Umlagerungs Info muss mit Filter gestartet werden!');

        IF Rec.GETFILTER(Nonstock) > '' THEN
            EVALUATE(bChargeFreiFilter, Rec.GETFILTER(Nonstock)); //UPDATE2013 Feld Katalogartikel benutzt

        FilterText := itemfilter;
        IF (STRLEN(lotFilter) > 0) AND (STRLEN(FilterText) > 0) THEN
            FilterText += '; ';
        FilterText += lotFilter;
        IF (STRLEN(locationfilter) > 0) AND (STRLEN(FilterText) > 0) THEN
            FilterText += '; ';
        FilterText += locationfilter;
        // >> CCU32.02
        IF (STRLEN(binfilter) > 0) AND (STRLEN(FilterText) > 0) THEN
            FilterText += '; ';
        FilterText += binfilter;
        // << CCU32.02

        CurrPage.UPDATE(FALSE);

        InitTempTable();

        // >> CCU32.03
        //Rec.SETCURRENTKEY("Item No.","Lot No.",Open,Positive,"Location Code",Lagerplatzhilfsfeld);
        ////Rec.SETCURRENTKEY("Item No.",FreigabedatumHerkunftsartikel,"Lot No.",Open,Positive,"Location Code",Lagerplatzhilfsfeld);  //Sortierung nach Produktionsdatum  (FreigabedatumHerkunftsartikel daf�r benutzt)
        // << CCU32.03

    end;

    trigger OnAfterGetRecord()
    begin
        SetExpansionStatus;

        Ablaufdatum := 0D;
        FreigabeStatus := '';
        IF Chargenstamm.GET("Item No.", "Variant Code", "Lot No.") THEN BEGIN
            Ablaufdatum := Chargenstamm."Expiration Date";
            FreigabeStatus := FORMAT(Chargenstamm.Status);
            //Lieferantenchargennr := Chargenstamm."Lief. Chargennr.";
            WarningAblaufdatum := Ablaufdatum < TODAY;
            //Muster := Chargenstamm.Muster;  // CCU702.01
            //Produktionsdatum := Chargenstamm.Produktionsdatum; //CCUDKO.01
            //tLaetusCode := Chargenstamm."Laetus-Code"; //CCUDKO.02
            //cCepNo := Chargenstamm."CEP Nr"; //CCUDKO.03
            //iRestrID := Chargenstamm."Restriction Set ID"; //CCUDKO.03
        END;

    END;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin

        IF (CloseAction = ACTION::LookupOK) THEN BEGIN
            IF (ActualExpansionStatus <> 2) AND (STRLEN("Item No.") > 0) THEN BEGIN
                ERROR('Bitte einen Datensatz mit Lagerplatz auswaehlen!');
            END;
        END;
    END;

    var
        recItemLedgerEntry: Record "Item Ledger Entry";
        Chargenstamm: Record "Lot No. Information";
        recWareHouseEntry: Record "Warehouse Entry";
        bChargeFreiFilter: Boolean;
        WarningAblaufdatum: Boolean;
        itemfilter: Code[20];
        Lieferantenchargennr: Code[20];
        lotFilter: Code[20];
        binfilter: Code[50];
        locationfilter: Code[50];
        Ablaufdatum: Date;
        ActualExpansionStatus: Integer;
        myInt: Integer;
        FreigabeStatus: Text[30];
        FilterText: Text[85];




    PROCEDURE SetExpansionStatus();
    BEGIN

        CASE TRUE OF
            IsExpanded(Rec):
                ActualExpansionStatus := 1;
            HasChildren(Rec):
                ActualExpansionStatus := 0
            ELSE
                ActualExpansionStatus := 2;
        END;
    END;

    LOCAL PROCEDURE IsExpanded(ItemLedgEntry: Record 32): Boolean;
    VAR
        localRec: Record "Item Ledger Entry";
        xItemLedgEntry: Record "Item Ledger Entry" temporary;
        Found: Boolean;
        Direction: Integer;
    BEGIN

        IF ItemLedgEntry.Lagerplatzhilfsfeld <> '' THEN
            EXIT(FALSE);

        xItemLedgEntry.COPY(Rec);
        //Rec.Reset;
        Rec := ItemLedgEntry;
        Rec.SETFILTER("Item No.", Rec."Item No.");
        Rec.SETFILTER("Location Code", Rec."Location Code");
        Rec.SETFILTER("Lot No.", Rec."Lot No.");
        Rec.SETFILTER(Lagerplatzhilfsfeld, '<>%1', '');
        IF Rec.FindFirst THEN
            Found := TRUE;
        COPY(xItemLedgEntry);
        //Rec.Reset;
        EXIT(Found);
    END;

    LOCAL PROCEDURE HasChildren(VAR ItemLedgEntry: Record "Item Ledger Entry"): Boolean;
    BEGIN

        IF ItemLedgEntry.Lagerplatzhilfsfeld <> '' THEN
            EXIT(FALSE);

        recWareHouseEntry.Reset;
        recWareHouseEntry.SETCURRENTKEY(
            "Item No.", "Bin Code", "Location Code", "Variant Code", "Unit of Measure Code", "Lot No.", "Serial No.", "Entry Type");
        recWareHouseEntry.SetRange("Item No.", Rec."Item No.");
        recWareHouseEntry.SetRange("Location Code", Rec."Location Code");
        recWareHouseEntry.SetRange("Lot No.", Rec."Lot No.");
        recWareHouseEntry.CALCSUMS("Qty. (Base)");
        IF recWareHouseEntry."Qty. (Base)" <> 0 THEN
            EXIT(TRUE);
        EXIT(FALSE);
    END;


    PROCEDURE InitTempTable();
    VAR
        recMyBincontent: Record "Bin Content";
        recItem: Record Item;
        dMengeAufPlatz: Decimal;
        nCount: Integer;

    BEGIN
        CLEAR(Rec);
        Reset;
        DELETEALL;


        CLEAR(recItemLedgerEntry);
        recItemLedgerEntry.SETCURRENTKEY("Item No.", Open, "Variant Code", Positive, "Location Code", "Posting Date");
        recItemLedgerEntry.SETFILTER("Item No.", itemfilter);
        recItemLedgerEntry.SETFILTER("Lot No.", lotFilter);
        recItemLedgerEntry.SetRange(Open, TRUE);
        IF locationfilter <> '' THEN
            recItemLedgerEntry.SETFILTER("Location Code", locationfilter);
        IF recItemLedgerEntry.FIND('-') THEN
            REPEAT
                //Zusammenfassen bei gesplitteten ItemLedgerentries aufgrund vergangener Lagerfachaufteilung
                CLEAR(Rec);
                Rec.SETFILTER("Item No.", recItemLedgerEntry."Item No.");
                Rec.SETFILTER("Location Code", recItemLedgerEntry."Location Code");
                Rec.SETFILTER("Lot No.", recItemLedgerEntry."Lot No.");
                IF Rec.FIND('-') THEN BEGIN

                    Rec."Remaining Quantity" += recItemLedgerEntry."Remaining Quantity";
                    Rec.Quantity += recItemLedgerEntry.Quantity;
                    // >> CCU32.02
                    recItemLedgerEntry.CALCFIELDS("Reserved Quantity");
                    Rec."Invoiced Quantity" += recItemLedgerEntry."Reserved Quantity";
                    // << CCU32.02
                    Rec.MODIFY;

                END ELSE BEGIN
                    //UPDATE2013 -> F�r Anzeige nur freie Artikel
                    //Chargeninfo nur holen wenn notwendig
                    IF CheckChargeFrei(bChargeFreiFilter, recItemLedgerEntry."Item No.", recItemLedgerEntry."Lot No.") = TRUE THEN BEGIN

                        Rec."Item No." := recItemLedgerEntry."Item No.";
                        Rec."Location Code" := recItemLedgerEntry."Location Code";
                        Rec."Remaining Quantity" := recItemLedgerEntry."Remaining Quantity";
                        Rec.Quantity += recItemLedgerEntry.Quantity;
                        Rec."Lot No." := recItemLedgerEntry."Lot No.";
                        Rec."Verkaufschargennr." := recItemLedgerEntry."Verkaufschargennr.";
                        Rec."Posting Date" := recItemLedgerEntry."Posting Date";

                        nCount += 1;
                        Rec."Entry No." := nCount;
                        IF recItem.GET(Rec."Item No.") THEN
                            Rec."Unit of Measure Code" := recItem."Base Unit of Measure";
                        Rec.TreeViewStatus_Temp := 0; //Oberste Ebene im Tree View
                                                      // >> CCU32.02
                        recItemLedgerEntry.CALCFIELDS("Reserved Quantity");
                        Rec."Invoiced Quantity" := recItemLedgerEntry."Reserved Quantity";
                        // >> CCU32.04
                        Rec."Variant Code" := recItemLedgerEntry."Variant Code";
                        // << CCU32.04
                        Rec.INSERT;
                        // << CCU32.02
                        //Untereintr�ge im TreeView machen (wenn vorhanden)

                        recMyBincontent.SETFILTER("Item No.", recItemLedgerEntry."Item No.");
                        recMyBincontent.SETFILTER("Location Code", recItemLedgerEntry."Location Code");
                        //recMyBincontent.SETFILTER("Lot No.", recItemLedgerEntry."Lot No.");
                        recMyBincontent.SETFILTER("Lot No. Filter", recItemLedgerEntry."Lot No.");  //CCU59
                                                                                                    // >> CCU32.02
                        IF binfilter > '' THEN
                            recMyBincontent.SETFILTER("Bin Code", binfilter);
                        // << CCU32.02
                        IF recMyBincontent.FIND('-') THEN
                            REPEAT
                                recMyBincontent.CALCFIELDS("Quantity (Base)");
                                IF recMyBincontent."Quantity (Base)" > 0 THEN BEGIN

                                    Rec."Item No." := recMyBincontent."Item No.";
                                    Rec."Location Code" := recMyBincontent."Location Code";
                                    Rec.Lagerplatzhilfsfeld := recMyBincontent."Bin Code";
                                    Rec."Remaining Quantity" := recMyBincontent."Quantity (Base)";
                                    Rec.Quantity := 0;
                                    Rec."Lot No." := recItemLedgerEntry."Lot No.";
                                    // >> CCU32.04
                                    Rec."Variant Code" := recMyBincontent."Variant Code";
                                    // << CCU32.04
                                    nCount += 1;
                                    Rec."Entry No." := nCount;
                                    Rec."Unit of Measure Code" := recItem."Base Unit of Measure";
                                    Rec.Entwicklungsprojekt := recMyBincontent.Default; // >> CCU641.01
                                    Rec.TreeViewStatus_Temp := 1; //Unter Ebene im Tree View
                                                                  //Buchungsdatum aus den Lagerplatzposten holen
                                    CLEAR(recWareHouseEntry);
                                    recWareHouseEntry.SetRange("Item No.", recMyBincontent."Item No.");
                                    recWareHouseEntry.SetRange("Location Code", recMyBincontent."Location Code");
                                    recWareHouseEntry.SetRange("Bin Code", recMyBincontent."Bin Code");
                                    IF recWareHouseEntry.FINDLAST() THEN
                                        Rec."Posting Date" := recWareHouseEntry."Registering Date";
                                    // >> CCU32.02
                                    Rec."Invoiced Quantity" := 0; //Bei Lagerplatzposten Menge auf 0 setzen, da sonst nur verwirrend
                                                                  // << CCU32.02

                                    Rec.INSERT;

                                END;
                            UNTIL recMyBincontent.NEXT = 0;

                    END;
                END;
                Rec.Reset;
            UNTIL recItemLedgerEntry.NEXT = 0;
    END;



    local procedure CheckChargeFrei(bCheckCharge: Boolean; cItemNo: Code[20]; cLotNo: Code[20]) bReturn: Boolean;
    var
        recLot: Record "Lot No. Information";
    BEGIN

        bReturn := TRUE;
        IF bCheckCharge = TRUE THEN BEGIN
            IF (cLotNo > '') THEN BEGIN

                IF (cLotNo <> recLot."Lot No.") THEN BEGIN
                    //Chargen Rec neu laden
                    recLot.GET(cItemNo, '', cLotNo)
                END;

                //IF recLot.Status <> recLot.Status::"1" THEN  CCU32 ????????????????????
                bReturn := FALSE;

            END;
        END;
    END;


}

