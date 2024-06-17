page 50005 BASTransferOrderInfoPHA
{
    ApplicationArea = All;
    Caption = '', comment = 'DEA="Umlagerung Information"';
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
                    Caption = 'Itemfilter', comment = 'DEA="Artikelfilter"';
                    ToolTip = 'Specifies the value of the FilterText field.';
                }
            }
            group(Lagerstand)
            {

                repeater(Control1)
                {
                    IndentationColumn = Rec.BASTreeViewStatus_TempPHA;
                    ShowAsTree = true;
                    field(Expand; Rec.BASTreeViewStatus_TempPHA)
                    {
                        ApplicationArea = All;
                        Editable = false;
                        Enabled = false;
                        HideValue = true;
                        ToolTip = 'Lagerplatz Aufklappen';
                    }
                    field(ItemNo; Rec."Item No.")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the Item No. field.';
                    }
                    field(LocationCode; Rec."Location Code")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the Location Code field.';
                    }
                    field(BinCode; Rec.BASBinCodeHelpFieldPHA)
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the Lagerplatzhilfsfeld field.';
                    }
                    field(LotNo; Rec."Lot No.")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the Lot No. field.';
                    }
                    field(RemainingQuantity; Rec."Remaining Quantity")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the Remaining Quantity field.';
                    }
                }
            }
        }
    }

    trigger OnInit()
    begin
        if Rec.Count <> 0 then
            Error('Itemledgerentry nicht sourcetabletemporary!!!');
    end;

    trigger OnOpenPage()
    begin
        Itemfilter := Rec."Item No.";

        if StrLen(Rec.BASBinCodeHelpFieldPHA) > 0 then
            Itemfilter := Rec.BASBinCodeHelpFieldPHA;

        LotFilter := Rec."Lot No.";

        Locationfilter := Rec."Location Code";
        if StrLen(Rec.GetFilter("Location Code")) > 0 then
            Locationfilter := Rec.GetFilter("Location Code");

        Infilter := Rec.BASBinCodeHelpFieldPHA;
        if StrLen(Rec.GetFilter(BASBinCodeHelpFieldPHA)) > 0 then
            Infilter := Rec.GetFilter(BASBinCodeHelpFieldPHA);

        if (StrLen(Itemfilter) = 0) and (StrLen(Locationfilter) = 0) then
            Error('Umlagerungs Info muss mit Filter gestartet werden!');

        FilterText := Itemfilter;
        if (StrLen(LotFilter) > 0) and (StrLen(FilterText) > 0) then
            FilterText += '; ';

        FilterText += LotFilter;
        if (StrLen(Locationfilter) > 0) and (StrLen(FilterText) > 0) then
            FilterText += '; ';

        FilterText += Locationfilter;
        if (StrLen(Infilter) > 0) and (StrLen(FilterText) > 0) then
            FilterText += '; ';

        FilterText += Infilter;

        CurrPage.Update(false);

        InitTempTable();
    end;

    trigger OnAfterGetRecord()
    begin
        SetExpansionStatus();

        ReleaseStatus := '';
        if LotNoInformation.Get(Rec."Item No.", Rec."Variant Code", Rec."Lot No.") then
            ReleaseStatus := Format(LotNoInformation.BASStatusPHA);
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin

        if CloseAction = Action::LookupOK then
            if (ActualExpansionStatus <> 2) and (StrLen(Rec."Item No.") > 0) then
                Error('Bitte einen Datensatz mit Lagerplatz auswaehlen!');
    end;

    var
        ItemLedgerEntry: Record "Item Ledger Entry";
        LotNoInformation: Record "Lot No. Information";
        WareHouseEntry: Record "Warehouse Entry";
        Itemfilter: Code[20];
        LotFilter: Code[50];
        ActualExpansionStatus: Integer;
        Infilter: Text;
        Locationfilter: Text;
        ReleaseStatus: Text[30];
        FilterText: Text[85];

    procedure SetExpansionStatus();
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

    local procedure IsExpanded(ItemLedgEntry: Record 32): Boolean;
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
        Found := Rec.FindFirst();

        Rec.Copy(TempItemLedgEntry);

        exit(Found);
    end;

    local procedure HasChildren(var ItemLedgEntry: Record "Item Ledger Entry"): Boolean;
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

    procedure InitTempTable();
    var
        Bincontent: Record "Bin Content";
        Item: Record Item;
        Counter: Integer;
    begin
        Rec.Reset();
        Rec.DeleteAll();

        ItemLedgerEntry.SetAutoCalcFields("Reserved Quantity");

        ItemLedgerEntry.Reset();
        ItemLedgerEntry.SetCurrentKey("Item No.", Open, "Variant Code", Positive, "Location Code", "Posting Date");
        ItemLedgerEntry.SetFilter("Item No.", Itemfilter);
        ItemLedgerEntry.SetFilter("Lot No.", LotFilter);
        ItemLedgerEntry.SetRange(Open, true);
        if Locationfilter <> '' then
            ItemLedgerEntry.SetFilter("Location Code", Locationfilter);
        if ItemLedgerEntry.FindSet() then
            repeat
                Rec.SetFilter("Item No.", ItemLedgerEntry."Item No.");
                Rec.SetFilter("Location Code", ItemLedgerEntry."Location Code");
                Rec.SetFilter("Lot No.", ItemLedgerEntry."Lot No.");
                if Rec.FindFirst() then begin
                    Rec."Remaining Quantity" += ItemLedgerEntry."Remaining Quantity";
                    Rec.Quantity += ItemLedgerEntry.Quantity;
                    Rec."Invoiced Quantity" += ItemLedgerEntry."Reserved Quantity";
                    Rec.Modify();
                end else
                    if CheckFreeLot(ItemLedgerEntry."Item No.", ItemLedgerEntry."Lot No.") then begin
                        Rec."Item No." := ItemLedgerEntry."Item No.";
                        Rec."Location Code" := ItemLedgerEntry."Location Code";
                        Rec."Remaining Quantity" := ItemLedgerEntry."Remaining Quantity";
                        Rec.Quantity += ItemLedgerEntry.Quantity;
                        Rec."Lot No." := ItemLedgerEntry."Lot No.";
                        Rec.BASSalesLotNoPHA := ItemLedgerEntry.BASSalesLotNoPHA;
                        Rec."Posting Date" := ItemLedgerEntry."Posting Date";

                        Counter += 1;
                        Rec."Entry No." := Counter;

                        if Item.Get(Rec."Item No.") then
                            Rec."Unit of Measure Code" := Item."Base Unit of Measure";

                        Rec.BASTreeViewStatus_TempPHA := 0;

                        Rec."Invoiced Quantity" := ItemLedgerEntry."Reserved Quantity";
                        Rec."Variant Code" := ItemLedgerEntry."Variant Code";
                        Rec.Insert();

                        Bincontent.SetFilter("Item No.", ItemLedgerEntry."Item No.");
                        Bincontent.SetFilter("Location Code", ItemLedgerEntry."Location Code");
                        Bincontent.SetFilter("Lot No. Filter", ItemLedgerEntry."Lot No.");

                        if Infilter > '' then
                            Bincontent.SetFilter("Bin Code", Infilter);

                        if Bincontent.FindSet() then
                            repeat
                                Bincontent.CALCFIELDS("Quantity (Base)");
                                if Bincontent."Quantity (Base)" > 0 then begin
                                    Rec."Item No." := Bincontent."Item No.";
                                    Rec."Location Code" := Bincontent."Location Code";
                                    Rec.BASBinCodeHelpFieldPHA := Bincontent."Bin Code";
                                    Rec."Remaining Quantity" := Bincontent."Quantity (Base)";
                                    Rec.Quantity := 0;
                                    Rec."Lot No." := ItemLedgerEntry."Lot No.";
                                    Rec."Variant Code" := Bincontent."Variant Code";

                                    Counter += 1;

                                    Rec."Entry No." := Counter;
                                    Rec."Unit of Measure Code" := Item."Base Unit of Measure";
                                    Rec.BASEntwicklungsprojektPHA := Bincontent.Default;
                                    Rec.BASTreeViewStatus_TempPHA := 1;

                                    WareHouseEntry.Reset();
                                    WareHouseEntry.SetRange("Item No.", Bincontent."Item No.");
                                    WareHouseEntry.SetRange("Location Code", Bincontent."Location Code");
                                    WareHouseEntry.SetRange("Bin Code", Bincontent."Bin Code");
                                    if WareHouseEntry.FindLast() then
                                        Rec."Posting Date" := WareHouseEntry."Registering Date";

                                    Rec."Invoiced Quantity" := 0;
                                    Rec.Insert();
                                end;
                            until Bincontent.Next() = 0;

                    end;
                Rec.Reset();
            until ItemLedgerEntry.Next() = 0;
    end;

    local procedure CheckFreeLot(ItemNo2: Code[20]; LotNo2: Code[50]): Boolean;
    var
        LotNoInformation2: Record "Lot No. Information";
    begin
        if LotNo2 > '' then begin
            if (LotNo2 <> LotNoInformation2."Lot No.") then
                LotNoInformation2.Get(ItemNo2, '', LotNo2);

            exit(false);
        end;

        exit(true);
    end;
}