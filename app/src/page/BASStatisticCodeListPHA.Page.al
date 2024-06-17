page 50006 BASStatisticCodeListPHA
{
    ApplicationArea = All;
    Caption = 'Statistic Code List', comment = 'DEA="Statisticcode Übersicht"';
    PageType = List;
    SourceTable = BASStatisticcodePHA;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field(Code; Rec.Code)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Code field.', Comment = 'DEA="Code"';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Bezeichnung field.';
                }
            }
        }
    }
}