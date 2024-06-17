pageextension 50002 BASItemLedgerEntryExtPHA extends "Item Ledger Entries"
{
    layout
    {
        addafter("Source No.")
        {
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
    }
}