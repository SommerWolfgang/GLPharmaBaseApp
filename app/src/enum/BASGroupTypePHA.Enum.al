enum 50002 BASGroupTypePHA
{
    Extensible = true;

    value(0; Item)
    {
        Caption = 'Item', comment = 'DEA="Artikel"';
    }
    value(1; Customer)
    {
        Caption = 'Customer', comment = 'DEA="Debitor"';
    }
    value(2; Vendor)
    {
        Caption = 'Vendor', comment = 'DEA="Kreditor"';
    }
    value(3; Sale)
    {
        Caption = 'Sale', comment = 'DEA="Verkauf"';
    }
    value(4; SKGroup)
    {
        Caption = 'SK-Group', comment = 'DEA="SK-Gruppe"';
    }
    value(5; PackageSize)
    {
        Caption = 'Package Size', comment = 'DEA="Packetgröße"';
    }
    value(6; LicencePlateNumber)
    {
        Caption = 'Licence Plate Number', comment = 'DEA="Betriebskennzeichen"';
    }
}