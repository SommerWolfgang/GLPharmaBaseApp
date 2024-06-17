
pageextension 50006 BASItemListExtPHA extends "Item List"
{
    layout
    {
        addafter(InventoryField)
        {
            field(Lagerstand; Rec.Inventory)
            {
                ApplicationArea = all;
                Editable = false;
                ToolTip = 'Specifies the value of the Inventory field.';

                trigger OnDrillDown()
                var
                    TempItemLedgerEntry: Record "Item Ledger Entry" temporary;
                begin
                    TempItemLedgerEntry."Item No." := Rec."No.";
                    TempItemLedgerEntry.SetRange("Item No.", Rec."No.");
                    TempItemLedgerEntry.SetRange(Open, true);

                    if Rec.GetFilter("Location Filter") > '' then
                        TempItemLedgerEntry.SETFILTER("Location Code", Rec.GetFilter("Location Filter"));

                    // if Page::RunModal(PAGE::TransferOrderInfo, TempItemLedgerEntry) = Action::LookupOK THEN;
                end;
            }
            field(BASPackageSizePHA; Rec.BASPackageSizePHA)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Packing size field.', Comment = '%';
            }
            field(BASStatisticCodeIPHA; Rec.BASStatisticCodeIPHA)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the BASStatisticCodeIPHA field.', Comment = '%';
            }
            field(BASStatisticCodeIIPHA; Rec.BASStatisticCodeIIPHA)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the BASStatisticCodeIIPHA field.', Comment = '%';
            }
            field(BASStatisticCodeIIIPHA; Rec.BASStatisticCodeIIIPHA)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the BASStatisticCodeIIIPHA field.', Comment = '%';
            }

        }
        modify(InventoryField)
        {
            Visible = false;
        }
    }

    actions
    {
        addfirst(processing)
        {
            action(BASChangeLogEntryPHA)
            {
                ApplicationArea = All;
                Image = ChangeLog;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Executes the BASChangeLogEntry action.';

                trigger OnAction()
                var
                    ChangeLogLookup: Page BASChangeLogEntryPHA;
                begin
                    // ToDo 
                    // ChangeLogLookup.setFilterByRec('', Rec);
                    ChangeLogLookup.RunModal();
                end;
            }
        }
    }
    trigger OnOpenPage()
    begin
        Rec.SetAutoCalcFields(Inventory);
    end;
}