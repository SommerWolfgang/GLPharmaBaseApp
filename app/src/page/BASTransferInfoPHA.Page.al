page 50017 BASTransferInfoPHA
{
    ApplicationArea = All;
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
                field(FilterTextTop; Locationfilter + ';' + Itemfilter)
                {
                    ApplicationArea = All;
                    Caption = 'Filter';
                    ToolTip = 'Specifies the value of the Filter field.';

                }
            }
            repeater(Group)
            {
                IndentationColumn = Rec.BASTreeViewStatus_TempPHA;
                ShowAsTree = true;
                field(TreeViewStatus_Temp; Rec.BASTreeViewStatus_TempPHA)
                {
                    ApplicationArea = All;
                    Caption = 'Klappen';
                    Editable = false;
                    Enabled = false;
                    ToolTip = 'Specifies the value of the Klappen field.';
                    Visible = false;
                }
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Item No. field.';
                }
                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Location Code field.';
                }
                field(BASBinCodeHelpFieldPHA; Rec.BASBinCodeHelpFieldPHA)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the BASBinCodeHelpFieldPHA field.';
                }
                field("Lot No."; Rec."Lot No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Lot No. field.';
                }
                field("Remaining Quantity"; Rec."Remaining Quantity")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Remaining Quantity field.';
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Quantity field.';
                    Visible = false;
                }
                field("Verkaufschargennr."; Rec.BASSalesLotNoPHA)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Verkaufschargennr. field.';
                }
                field(Status; FreigabeStatus)
                {
                    ApplicationArea = All;
                    Caption = 'Status', comment = 'DEA="Status"';
                    ToolTip = 'Specifies the value of the FreigabeStatus field.';
                }
                field(Ablaufdatum; Ablaufdatum)
                {
                    ApplicationArea = All;
                    Caption = 'Ablaufdatum';
                    ToolTip = 'Specifies the value of the Ablaufdatum field.';
                }
                field(Lieferantenchargennr; Lieferantenchargennr)
                {
                    ApplicationArea = All;
                    Caption = 'Lieferantenchargennr';
                    ToolTip = 'Specifies the value of the Lieferantenchargennr field.';
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Posting Date field.';
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
        SetExpansionStatus();

        Ablaufdatum := 0D;
        FreigabeStatus := '';

        if LotNoInformation.GET(Rec."Item No.", Rec."Variant Code", Rec."Lot No.") then begin
            Ablaufdatum := LotNoInformation.BASExpirationDatePHA;
            FreigabeStatus := FORMAT(LotNoInformation.BASStatusPHA);
            Lieferantenchargennr := LotNoInformation.BASShipmentLotNoPHA;
        end;
    end;

    trigger OnInit()
    begin
        if Rec.Count <> 0 then
            Error('Itemledgerentry nicht sourcetabletemporary!!! ');
    end;

    trigger OnOpenPage()
    begin
        if Itemfilter = '' then
            Itemfilter := Rec."Item No.";

        LotFilter := Rec."Lot No.";

        Locationfilter := Rec."Location Code";
        if StrLen(Rec.GetFilter("Location Code")) > 0 then
            Locationfilter := Rec.GetFilter("Location Code");
        if (StrLen(Itemfilter) = 0) and (StrLen(Locationfilter) = 0) then
            Error('Umlagerungs Info muss mit Filter gestartet werden!');
        if Rec.GetFilter(Nonstock) > '' then
            EVALUATE(FreeLotNoFilter, Rec.GetFilter(Nonstock));

        CurrPage.Update(false);

        InitTempTable();
        Rec.SetCurrentKey("Item No.", "Lot No.", Open, Positive, "Location Code", BASBinCodeHelpFieldPHA);
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        if CloseAction = ACTION::LookupOK then
            if (ActualExpansionStatus <> 2) and (StrLen(Rec."Item No.") > 0) then
                Error('Bitte einen Datensatz mit Lagerplatz auswählen!');
    end;

    var
        ItemLedgerEntry: Record "Item Ledger Entry";
        LotNoInformation: Record "Lot No. Information";
        recLot: Record "Lot No. Information";
        WareHouseEntry: Record "Warehouse Entry";
        FreeLotNoFilter: Boolean;
        Lieferantenchargennr: Code[20];
        LotFilter: Code[50];
        Ablaufdatum: Date;
        ActualExpansionStatus: Integer;
        nCount: Integer;
        Itemfilter: Text;
        Locationfilter: Text;
        FreigabeStatus: Text[30];

    procedure InitTempTable()
    var
        Bin: Record Bin;
        Item: Record Item;
    begin
        Rec.Reset();
        rec.DeleteAll();

        ItemLedgerEntry.Reset();
        ItemLedgerEntry.SETCURRENTKEY("Item No.", Open, "Variant Code", Positive, "Location Code", "Posting Date");
        ItemLedgerEntry.SetFilter("Item No.", Itemfilter);
        ItemLedgerEntry.SetFilter("Lot No.", LotFilter);
        ItemLedgerEntry.SetRange(Open, true);
        if Locationfilter <> '' then
            ItemLedgerEntry.SetFilter("Location Code", Locationfilter);
        if ItemLedgerEntry.FindSet() then
            repeat
                Rec.Reset();
                Rec.SetFilter("Item No.", ItemLedgerEntry."Item No.");
                Rec.SetFilter("Location Code", ItemLedgerEntry."Location Code");
                Rec.SetFilter("Lot No.", ItemLedgerEntry."Lot No.");
                if Rec.FindFirst() then begin
                    Rec."Remaining Quantity" += ItemLedgerEntry."Remaining Quantity";
                    Rec.Quantity += ItemLedgerEntry.Quantity;
                    Rec.Modify();
                end else
                    if CheckChargeFrei(FreeLotNoFilter, ItemLedgerEntry."Item No.", ItemLedgerEntry."Lot No.") = true then begin
                        Rec."Item No." := ItemLedgerEntry."Item No.";
                        Rec."Location Code" := ItemLedgerEntry."Location Code";
                        Rec."Remaining Quantity" := ItemLedgerEntry."Remaining Quantity";
                        Rec.Quantity += ItemLedgerEntry.Quantity;
                        Rec."Lot No." := ItemLedgerEntry."Lot No.";
                        // Rec."Verkaufschargennr." := ItemLedgerEntry."Verkaufschargennr.";
                        Rec."Posting Date" := ItemLedgerEntry."Posting Date";
                        nCount += 1;
                        Rec."Entry No." := nCount;
                        if Item.GET(Rec."Item No.") then
                            Rec."Unit of Measure Code" := Item."Base Unit of Measure";
                        // Rec.TreeViewStatus_Temp := 0; //Oberste Ebene im Tree View
                        Rec.INSERT();

                        //Untereinträge im TreeView machen (wenn vorhanden)

                        // Bin.SetFilter("Item No.", ItemLedgerEntry."Item No.");
                        Bin.SetFilter("Location Code", ItemLedgerEntry."Location Code");
                        //TODOPBArecMyBincontent.SetFilter(Rec."Lot No.", recItemLedgerEntry."Lot No.");

                        // if Bin.FIND('-') then
                        //     repeat
                        //         Bin.CALCFIELDS("Quantity (Base)");
                        //         if Bin."Quantity (Base)" > 0 then begin

                        //             Rec."Item No." := Bin."Item No.";
                        //             Rec."Location Code" := Bin."Location Code";
                        //             Rec.BASBinCodeHelpFieldPHA := Bin."Bin Code";
                        //             Rec."Remaining Quantity" := Bin."Quantity (Base)";
                        //             Rec.Quantity := 0;
                        //             Rec."Lot No." := ItemLedgerEntry."Lot No.";
                        //             Rec."Verkaufschargennr." := ItemLedgerEntry."Verkaufschargennr.";
                        //             nCount += 1;
                        //             Rec."Entry No." := nCount;
                        //             Rec."Unit of Measure Code" := Item."Base Unit of Measure";
                        //             Rec.TreeViewStatus_Temp := 1; //Unter Ebene im Tree View
                        //                                           //Buchungsdatum aus den Lagerplatzposten holen
                        //             CLEAR(WareHouseEntry);
                        //             WareHouseEntry.SetRange("Item No.", Bin.."Item No.");
                        //             WareHouseEntry.SetRange("Location Code", Bin."Location Code");
                        //             WareHouseEntry.SetRange("Bin Code", Bin."Bin Code");
                        //             if WareHouseEntry.FINDLAST() then
                        //                 Rec."Posting Date" := WareHouseEntry."Registering Date";

                        //             Rec.Insert();
                        //         end;
                        //     until Bin.Next() = 0;
                    end;
                Rec.Reset();
            until ItemLedgerEntry.Next() = 0;
    end;

    procedure SetExpansionStatus()
    begin
        case true of
            IsExpanded(Rec):
                ActualExpansionStatus := 1;
            HasChildren(Rec):
                ActualExpansionStatus := 0
            else
                ActualExpansionStatus := 2;
        end;
    end;

    local procedure IsExpanded(ItemLedgEntry: Record "Item Ledger Entry"): Boolean
    var
        TempItemLedgEntry: Record "Item Ledger Entry" temporary;
        Found: Boolean;
    begin
        if ItemLedgEntry.BASBinCodeHelpFieldPHA <> '' then
            exit(false);

        TempItemLedgEntry.COPY(Rec);
        Rec := ItemLedgEntry;
        Rec.SetFilter("Item No.", Rec."Item No.");
        Rec.SetFilter("Location Code", Rec."Location Code");
        Rec.SetFilter("Lot No.", Rec."Lot No.");
        Rec.SetFilter(BASBinCodeHelpFieldPHA, '<>%1', '');
        if Rec.FindFirst() then
            Found := true;
        Rec.Copy(TempItemLedgEntry);
        exit(Found);
    end;

    local procedure HasChildren(var ItemLedgEntry: Record "Item Ledger Entry"): Boolean
    begin
        if ItemLedgEntry.BASBinCodeHelpFieldPHA <> '' then
            exit(false);

        WareHouseEntry.Reset();
        WareHouseEntry.SetCurrentKey("Item No.", "Bin Code", "Location Code", "Variant Code", "Unit of Measure Code", "Lot No.", "Serial No.", "Entry Type");
        WareHouseEntry.SetRange("Item No.", Rec."Item No.");
        WareHouseEntry.SetRange("Location Code", Rec."Location Code");
        WareHouseEntry.SetRange("Lot No.", Rec."Lot No.");
        WareHouseEntry.CalcSums("Qty. (Base)");
        exit(WareHouseEntry."Qty. (Base)" <> 0);
    end;

    procedure CheckChargeFrei(CheckLotNo: Boolean; ItemNo: Code[20]; LotNo: Code[50]): Boolean
    begin
        if CheckLotNo then
            if LotNo > '' then begin
                if LotNo <> recLot."Lot No." then
                    recLot.Get(ItemNo, '', LotNo);
                exit(not (recLot.BASStatusPHA <> recLot.BASStatusPHA::Free));
            end;
    end;

    procedure SetFilter(ItemFilter2: Text[100])
    begin
        ItemFilter := ItemFilter2;
    end;
}