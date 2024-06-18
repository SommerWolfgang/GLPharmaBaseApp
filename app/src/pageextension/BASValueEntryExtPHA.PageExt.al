pageextension 50003 BASValueEntryExtPHA extends "Value Entries"
{
    layout
    {
        addafter("Shortcut Dimension 8 Code")
        {
            field(BASStatistiCcodeIPHA; Rec.BASStatistiCcodeIPHA)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the BASStatistiCcodeIPHA field.', Comment = '%';
            }
            field(BASStatistiCcodeIIPHA; Rec.BASStatistiCcodeIIPHA)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the BASStatistiCcodeIIPHA field.', Comment = '%';
            }
            field(BASStatistiCcodeIIIPHA; Rec.BASStatistiCcodeIIIPHA)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the BASStatistiCcodeIIIPHA field.', Comment = '%';
            }
        }
    }
}