tableextension 50043 BASReminderHeaderExtPHA extends "Reminder Header"
{
    // GL001 MFU 03.05.2010  Durch Rundungen bei Mahnungen wurden keine richtigen Konteneinrichtungen gefunden -> wurde entfernt
    // GL002 MFU 09.10.2012  Feld "Bill-to Code" für Auswahl einer Rechnungsadresse in Mahnungen eingebaut
    fields
    {
        field(50000; "BASBill-to CodePHA"; Code[10])
        {
            TableRelation = "Ship-to Address".Code WHERE("Customer No." = FIELD("Customer No."),
                                                          Type = FILTER(<> Shipment));

            trigger OnValidate()
            var
                Cust: Record Customer;
                ShipToAddr: Record "Ship-to Address";
            begin

                //-GL002
                IF "Bill-to Code" <> '' THEN BEGIN
                    ShipToAddr.GET("Customer No.", "Bill-to Code");
                    Name := ShipToAddr.Name;
                    "Name 2" := ShipToAddr."Name 2";
                    Address := ShipToAddr.Address;
                    "Address 2" := ShipToAddr."Address 2";
                    City := ShipToAddr.City;
                    "Post Code" := ShipToAddr."Post Code";
                END ELSE
                    IF Cust.GET("Customer No.") THEN BEGIN
                        Name := Cust.Name;
                        "Name 2" := Cust."Name 2";
                        Address := Cust.Address;
                        "Address 2" := Cust."Address 2";
                        City := Cust.City;
                        "Post Code" := Cust."Post Code";
                    END;
                //+GL002
            end;
        }
    }
}
