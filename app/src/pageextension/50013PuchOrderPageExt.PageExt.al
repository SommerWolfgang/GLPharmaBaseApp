pageextension 50013 "PuchOrderPageExt" extends "Purchase Order"
{
    layout
    {

        addfirst(factboxes)
        {
            part(PurchaseLotFactBox; "Purchase Lot FactBox")
            {
                ApplicationArea = All;
                Caption = 'Chargen Info';
                UpdatePropagation = SubPart;
                Provider = PurchLines;
                //Visible = SalesDocCheckFactboxVisible;
                SubPageLink = "Document No." = field("Document No."),
                    "Document Type" = field("Document Type"),
                    "Line No." = field("Line No.");

            }
        }

    }

}
