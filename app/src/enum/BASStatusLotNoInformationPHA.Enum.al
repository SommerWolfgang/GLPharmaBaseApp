enum 50001 BASStatusLotNoInformationPHA
{
    Extensible = true;
    value(0; Quarantine)
    {
        Caption = 'Quarantine', comment = 'DEA="Quarantäne"';
    }
    value(1; Free)
    {
        Caption = 'Free', comment = 'DEA="Frei"';
    }
    value(2; Blocked)
    {
        Caption = 'Blocked', comment = 'DEA="Gesperrt"';
    }
}