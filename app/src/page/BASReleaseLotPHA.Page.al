
page 50015 BASReleaseLotPHA
{
    ApplicationArea = All;
    DataCaptionExpression = 'Chargendaten - Änderungs: ' + Rec."Item No." + '  ' + Rec."Lot No.";
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Worksheet;
    SourceTable = "Lot No. Information";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            group(group)
            {
            }
        }
    }
}