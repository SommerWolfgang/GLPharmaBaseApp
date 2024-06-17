pageextension 50014 BASPurchOrderListeExtPHA extends "Purchase Order List"
{

    trigger OnOpenPage()
    begin
        Rec.Ascending(false);
    end;
}