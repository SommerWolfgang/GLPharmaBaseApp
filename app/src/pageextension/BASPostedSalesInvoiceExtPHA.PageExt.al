pageextension 50015 BASPostedSalesInvoiceExtPHA extends "Posted Sales Invoice"
{
    layout
    {
        addfirst(factboxes)
        {
            part(SalesLotFaktBox; BASSalesInvLotFactBoxPHA)
            {
                ApplicationArea = All;
                Caption = 'Chargen Info';
                Provider = SalesInvLines;
                SubPageLink = "Document No." = field("Document No."), "No." = field("No."), "Line No." = field("Line No.");
                UpdatePropagation = SubPart;
            }
        }
    }
}