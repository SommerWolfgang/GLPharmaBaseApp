pageextension 50014 "PurchOrderListeExt" extends "Purchase Order List"
{

    trigger OnOpenPage()
    var
        myInt: Integer;
    begin
        //Absteigend sortieren der Bestellliste
        Rec.Ascending(false);
    end;
}
