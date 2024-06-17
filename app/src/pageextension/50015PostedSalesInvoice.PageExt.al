pageextension 50015 "50015PostedSalesInvoice" extends "Posted Sales Invoice"
{

    layout
    {

        //Chargenanzeige Faktbox dazugeben
        addfirst(factboxes)
        {
            part(SalesLotFaktBox; SalesInvLotFactBox)
            {
                ApplicationArea = All;
                Caption = 'Chargen Info';
                Provider = SalesInvLines;
                //Visible = SalesDocCheckFactboxVisible;
                SubPageLink = "Document No." = field("Document No."),
                                "No." = field("No."),
                                "Line No." = field("Line No.");
                UpdatePropagation = SubPart;

            }
        }
        //}

    }
}
