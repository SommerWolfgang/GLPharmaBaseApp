enum 50000 BASItemTypePHA
{
    Extensible = true;

    value(0; " ")
    {
    }
    value(1; "Row Material")
    {
        Caption = 'Row Material', comment = 'DEA="Rohstoff"';
    }
    value(2; "Semifinished Product")
    {
        Caption = 'Semifinished Product', comment = 'DEA="Halbfabrikat"';
    }
    value(3; "Finished Product")
    {
        Caption = 'Finished Product', comment = 'DEA="Fertigprodukt"';
    }
    value(4; "Package Material")
    {
        Caption = 'Package Material', comment = 'DEA="Verpackungsstoff"';
    }
    value(5; "Production Step")
    {
        Caption = 'Production Step', comment = 'DEA="Arbeitsschritt"';
    }
}