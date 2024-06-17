pageextension 50013 BASPuchOrderPageExtPHA extends "Purchase Order"
{
    layout
    {
        addfirst(factboxes)
        {
            part(PurchaseLotFactBox; BASPurchaseLotFactBoxPHA)
            {
                ApplicationArea = All;
                Caption = 'Chargen Info';
                Provider = PurchLines;
                //Visible = SalesDocCheckFactboxVisible;
                SubPageLink = "Document No." = field("Document No."), "Document Type" = field("Document Type"), "Line No." = field("Line No.");
                UpdatePropagation = SubPart;
            }
        }
    }
}