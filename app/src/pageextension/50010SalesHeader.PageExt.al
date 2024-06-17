pageextension 50010 "SalesHeaderExt" extends "Sales Order"
{
    layout
    {
        //area(factboxes)
        //{
        addfirst(factboxes)
        //addafter(SalesDocCheckFactbox)    
        {
            part(SalesLotFaktBox; "Sales Lot FactBox")
            {
                ApplicationArea = All;
                Caption = 'Chargen Info';
                UpdatePropagation = SubPart;
                Provider = SalesLines;
                //Visible = SalesDocCheckFactboxVisible;
                SubPageLink = "Document No." = field("Document No."),
                                "Document Type" = field("Document Type"),
                                "Line No." = field("Line No.");
            }
        }
        //}

    }

}
