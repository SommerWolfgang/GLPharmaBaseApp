page 50017 BASTransferInfoPHA
{
    ApplicationArea = All;
    // version GL

    // 
    // Datum      | Autor     | Status  | Beschreibung
    // ----------------------------------------------------------------------------------------------------
    // 2015-06-08 | MFU       | ok      | UPDATE2013
    // ----------------------------------------------------------------------------------------------------
    // 2015-09-08 | MFU       | ok      | GL001 - Meldung wie im alten NAV einbauen
    // ----------------------------------------------------------------------------------------------------
    // 2017-06-13 | MFU       | ok      | Variable "locationfilter" Textlänge erweitern
    // ----------------------------------------------------------------------------------------------------

    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = Worksheet;
    SourceTable = "Item Ledger Entry";
    SourceTableTemporary = true;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            group("Filter")
            {
                field(FilterTextTop; locationfilter + ';' + itemfilter)
                {
                    ApplicationArea = All;
                    Caption = 'Filter';

                }
            }
            repeater(Group)
            {
                IndentationColumn = TreeViewStatus_Temp;
                ShowAsTree = true;
                field(TreeViewStatus_Temp; TreeViewStatus_Temp)
                {
                    ApplicationArea = All;
                    Caption = 'Klappen';
                    Editable = false;
                    Enabled = false;
                    Visible = false;
                }
                field("Item No."; "Item No.")
                {
                    ApplicationArea = All;
                }
                field("Location Code"; "Location Code")
                {
                    ApplicationArea = All;
                }
                field(Lagerplatzhilfsfeld; Lagerplatzhilfsfeld)
                {
                    ApplicationArea = All;
                }
                field("Lot No."; "Lot No.")
                {
                    ApplicationArea = All;
                }
                field("Remaining Quantity"; "Remaining Quantity")
                {
                    ApplicationArea = All;
                }
                field(Quantity; Quantity)
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Verkaufschargennr."; "Verkaufschargennr.")
                {
                    ApplicationArea = All;
                }
                field(Status; FreigabeStatus)
                {
                    ApplicationArea = All;
                }
                field(Ablaufdatum; Ablaufdatum)
                {
                    ApplicationArea = All;
                    Caption = 'Ablaufdatum';
                }
                field(Lieferantenchargennr; Lieferantenchargennr)
                {
                    ApplicationArea = All;
                    Caption = 'Lieferantenchargennr';
                }
                field("Posting Date"; "Posting Date")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin

        SetExpansionStatus;

        Ablaufdatum := 0D;
        FreigabeStatus := '';
        IF Chargenstamm.GET("Item No.", "Variant Code", "Lot No.") THEN BEGIN
            Ablaufdatum := Chargenstamm."Expiration Date";
            FreigabeStatus := FORMAT(Chargenstamm.Status);
            Lieferantenchargennr := Chargenstamm."Lief. Chargennr.";
        END;
    end;

    trigger OnInit()
    begin

        //Absicherung falls mal irrtümlich irgendwann die temporär-Eigenschaft entfernt werden sollte...
        //wegen dem deleteall unten...
        IF Rec.COUNT <> 0 THEN ERROR('Itemledgerentry nicht sourcetabletemporary!!! ');
    end;

    trigger OnOpenPage()
    begin

        itemfilter := Rec."Item No.";
        IF STRLEN(itemFilterParameter) > 0 THEN
            itemfilter := itemFilterParameter;

        lotFilter := Rec."Lot No.";

        locationfilter := Rec."Location Code";
        IF STRLEN(Rec.GETFILTER("Location Code")) > 0 THEN     //Bei Aufruf aus Auftrag/Rechnung den Logerortfilter nehmen, können mehrere sein
            locationfilter := Rec.GETFILTER("Location Code");

        //tempRecItemLedgerEntry.SETFILTER("Location Code"

        //UPDATE2013 -> Ohne Filter nicht aufmachen lassen
        IF (STRLEN(itemfilter) = 0) AND (STRLEN(locationfilter) = 0) THEN
            ERROR('Umlagerungs Info muss mit Filter gestartet werden!');

        IF Rec.GETFILTER(Nonstock) > '' THEN
            EVALUATE(bChargeFreiFilter, Rec.GETFILTER(Nonstock)); //UPDATE2013 Feld Katalogartikel benutzt

        CurrPage.UPDATE(FALSE);

        InitTempTable();
        Rec.SETCURRENTKEY("Item No.", "Lot No.", Open, Positive, "Location Code", Lagerplatzhilfsfeld);
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin

        //-GL001
        IF (CloseAction = ACTION::LookupOK) THEN BEGIN
            IF (ActualExpansionStatus <> 2) AND (STRLEN("Item No.") > 0) THEN BEGIN
                ERROR('Bitte einen Datensatz mit Lagerplatz auswählen!');
            END;
        END;
        //+GL001
    end;

    var
        Item: Record "27";
        recItemLedgerEntry: Record "32";
        Chargenstamm: Record "6505";
        recLot: Record "6505";
        recWareHouseEntry: Record "7312";
        bChargeFreiFilter: Boolean;
        itemfilter: Code[20];
        Lieferantenchargennr: Code[20];
        lotFilter: Code[20];
        locationfilter: Code[50];
        itemFilterParameter: Code[100];
        Ablaufdatum: Date;
        ActualExpansionStatus: Integer;
        nCount: Integer;
        FreigabeStatus: Text[30];
        tFilter: Text[100];
        FilterTextTop: Text[250];

    procedure InitTempTable()
    var
        recItem: Record "27";
        recMyBincontent: Record "7302";
    begin
        CLEAR(Rec);
        RESET;
        DELETEALL;


        CLEAR(recItemLedgerEntry);
        recItemLedgerEntry.SETCURRENTKEY("Item No.", Open, "Variant Code", Positive, "Location Code", "Posting Date");
        recItemLedgerEntry.SETFILTER("Item No.", itemfilter);
        recItemLedgerEntry.SETFILTER("Lot No.", lotFilter);
        recItemLedgerEntry.SETRANGE(Open, TRUE);
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
                    Rec.MODIFY;
                END ELSE BEGIN

                    //UPDATE2013 -> Für Anzeige nur freie Artikel
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
                        Rec.INSERT;

                        //Untereinträge im TreeView machen (wenn vorhanden)

                        recMyBincontent.SETFILTER("Item No.", recItemLedgerEntry."Item No.");
                        recMyBincontent.SETFILTER("Location Code", recItemLedgerEntry."Location Code");
                        //TODOPBArecMyBincontent.SETFILTER(Rec."Lot No.", recItemLedgerEntry."Lot No.");

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
                                    Rec."Verkaufschargennr." := recItemLedgerEntry."Verkaufschargennr.";
                                    nCount += 1;
                                    Rec."Entry No." := nCount;
                                    Rec."Unit of Measure Code" := recItem."Base Unit of Measure";
                                    Rec.TreeViewStatus_Temp := 1; //Unter Ebene im Tree View
                                                                  //Buchungsdatum aus den Lagerplatzposten holen
                                    CLEAR(recWareHouseEntry);
                                    recWareHouseEntry.SETRANGE("Item No.", recMyBincontent."Item No.");
                                    recWareHouseEntry.SETRANGE("Location Code", recMyBincontent."Location Code");
                                    recWareHouseEntry.SETRANGE("Bin Code", recMyBincontent."Bin Code");
                                    IF recWareHouseEntry.FINDLAST() THEN
                                        Rec."Posting Date" := recWareHouseEntry."Registering Date";

                                    Rec.INSERT;

                                END;
                            UNTIL recMyBincontent.NEXT = 0;

                    END;
                END;
                Rec.RESET;
            UNTIL recItemLedgerEntry.NEXT = 0;
    end;

    procedure SetExpansionStatus()
    begin

        CASE TRUE OF
            IsExpanded(Rec):
                ActualExpansionStatus := 1;
            HasChildren(Rec):
                ActualExpansionStatus := 0
            ELSE
                ActualExpansionStatus := 2;
        END;
    end;

    local procedure IsExpanded(ItemLedgEntry: Record "32"): Boolean
    var
        localRec: Record "32";
        xItemLedgEntry: Record "32" temporary;
        Found: Boolean;
        Direction: Integer;
    begin

        IF ItemLedgEntry.Lagerplatzhilfsfeld <> '' THEN
            EXIT(FALSE);

        xItemLedgEntry.COPY(Rec);
        //Rec.RESET;
        Rec := ItemLedgEntry;
        Rec.SETFILTER("Item No.", Rec."Item No.");
        Rec.SETFILTER("Location Code", Rec."Location Code");
        Rec.SETFILTER("Lot No.", Rec."Lot No.");
        Rec.SETFILTER(Lagerplatzhilfsfeld, '<>%1', '');
        IF Rec.FINDFIRST THEN
            Found := TRUE;
        COPY(xItemLedgEntry);
        //Rec.RESET;
        EXIT(Found);
    end;

    local procedure HasChildren(var ItemLedgEntry: Record "32"): Boolean
    begin

        IF ItemLedgEntry.Lagerplatzhilfsfeld <> '' THEN
            EXIT(FALSE);

        recWareHouseEntry.RESET;
        recWareHouseEntry.SETCURRENTKEY(
            "Item No.", "Bin Code", "Location Code", "Variant Code", "Unit of Measure Code", "Lot No.", "Serial No.", "Entry Type");
        recWareHouseEntry.SETRANGE("Item No.", Rec."Item No.");
        recWareHouseEntry.SETRANGE("Location Code", Rec."Location Code");
        recWareHouseEntry.SETRANGE("Lot No.", Rec."Lot No.");
        recWareHouseEntry.CALCSUMS("Qty. (Base)");
        IF recWareHouseEntry."Qty. (Base)" <> 0 THEN
            EXIT(TRUE);
        EXIT(FALSE);
    end;

    procedure CheckChargeFrei(bCheckCharge: Boolean; cItemNo: Code[20]; cLotNo: Code[20]) bReturn: Boolean
    begin
        //-UPDATE2013
        bReturn := TRUE;
        IF bCheckCharge = TRUE THEN BEGIN

            IF (cLotNo > '') THEN BEGIN

                IF (cLotNo <> recLot."Lot No.") THEN BEGIN
                    //Chargen Rec neu laden
                    recLot.GET(cItemNo, '', cLotNo)
                END;

                IF recLot.Status <> recLot.Status::Frei THEN
                    bReturn := FALSE;

            END;

        END;

        //+UPDATE2013
    end;

    procedure SetFilter(tItemFilter: Text[100])
    begin
        //-UPDATE2013
        itemFilterParameter := tItemFilter;


        //+UPDATE2013
    end;
}

