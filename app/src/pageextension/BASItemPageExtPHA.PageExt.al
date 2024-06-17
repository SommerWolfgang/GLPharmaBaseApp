
pageextension 50001 BASItemPageExtPHA extends "Item Card"
{
    layout
    {
        addafter("Description 2")
        {
            field(BASStatisticCodeIPHA; Rec.BASStatisticCodeIPHA)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the BASStatisticCodeIPHA field.', Comment = '%';
            }
            field(BASPackageSizePHA; Rec.BASPackageSizePHA)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Packing size field.', Comment = '%';
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

        // ToDo ??
        modify(Inventory)
        {
            Visible = false;
            trigger OnDrillDown()
            var
                TempItemLedgerEntry: Record "Item Ledger Entry" temporary;
            begin
                TempItemLedgerEntry."Item No." := Rec."No.";
                TempItemLedgerEntry.SetRange("Item No.", Rec."No.");
                TempItemLedgerEntry.SetRange(Open, true);
                if Rec.GetFilter("Location Filter") > '' then
                    TempItemLedgerEntry.SetFilter("Location Code", Rec.GetFilter("Location Filter"));

                // if Page::RunModal(PAGE::TransferOrderInfo, TempItemLedgerEntry) = Action::LookupOK THEN;
            end;
        }
    }

    trigger OnOpenPage()
    begin
        Rec.SetAutoCalcFields(Inventory);
    end;
}