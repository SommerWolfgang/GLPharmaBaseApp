tableextension 50043 BASReminderHeaderExtPHA extends "Reminder Header"
{
    fields
    {
        field(50000; BASBillToCodePHA; Code[10])
        {
            TableRelation = "Ship-to Address".Code where("Customer No." = field("Customer No."), BASTypePHA = filter(<> Shipment));
            trigger OnValidate()
            var
                Cust: Record Customer;
                ShipToAddr: Record "Ship-to Address";
            begin
                if BASBillToCodePHA <> '' then begin
                    ShipToAddr.Get("Customer No.", BASBillToCodePHA);
                    Name := ShipToAddr.Name;
                    "Name 2" := ShipToAddr."Name 2";
                    Address := ShipToAddr.Address;
                    "Address 2" := ShipToAddr."Address 2";
                    City := ShipToAddr.City;
                    "Post Code" := ShipToAddr."Post Code";
                end else
                    if Cust.Get("Customer No.") then begin
                        Name := Cust.Name;
                        "Name 2" := Cust."Name 2";
                        Address := Cust.Address;
                        "Address 2" := Cust."Address 2";
                        City := Cust.City;
                        "Post Code" := Cust."Post Code";
                    end;
            end;
        }
    }
}