pageextension 50015 "50015PostedSalesInvoice" extends "Posted Sales Invoice"
{

    layout
    {

        //Chargenanzeige Faktbox dazugeben
        addfirst(factboxes)
        {
            part(SalesLotFaktBox; "Sales Inv Lot FactBox")
            {
                ApplicationArea = All;
                Caption = 'Chargen Info';
                UpdatePropagation = SubPart;
                Provider = SalesInvLines;
                //Visible = SalesDocCheckFactboxVisible;
                SubPageLink = "Document No." = field("Document No."),
                                "No." = field("No."),
                                "Line No." = field("Line No.");

            }
        }
        //}

    }
}
