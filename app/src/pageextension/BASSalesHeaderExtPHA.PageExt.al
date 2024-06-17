pageextension 50010 BASSalesHeaderExtPHA extends "Sales Order"
{
    layout
    {
        addfirst(factboxes)
        {
            part(SalesLotFaktBox; BASSalesLotFactBoxPHA)
            {
                ApplicationArea = All;
                Caption = 'Chargen Info';
                Provider = SalesLines;
                SubPageLink = "Document No." = field("Document No."), "Document Type" = field("Document Type"), "Line No." = field("Line No.");
                UpdatePropagation = SubPart;
            }
        }
    }
}