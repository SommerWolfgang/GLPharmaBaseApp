tableextension 50051 BASDepreciationBookExtPHA extends "Depreciation Book"
{
    // Petsch: Feld "Afa vom Wiederbeschaffungswert rechnen" -> für kalkulatorische AfA
    // 22.3.2005 Indexierung unter Null zulassen
    // ------------------------------------------------------------------------------------------------------------------------------------
    // 
    // 
    // 1) Tabellenspalten übernommen
    // 2) Feld "KORE Integration Depreciation" hinzugefügt (KORE integration)
    // 3) Feld "Blocked" hinzugefügt -> Wenn gesetzt bei der übernahme zu einer Anlage sperren
    // 
    // ------------------------------------------------------------------------------------------------------------------------------------
    // Datum      | Autor   | Status     | Beschreibung
    // ------------------------------------------------------------------------------------------------------------------------------------
    // 2010-02-19 | MFU     | ok         | Update von 360
    // ------------------------------------------------------------------------------------------------------------------------------------
    // 2016-09-14 | MFU     | ok         | Feld "Afa bis doppelte Nutzungsdauer" eingebaut (Reisenhofer)
    // ------------------------------------------------------------------------------------------------------------------------------------
    fields
    {
        field(50000; BASReplacmentAfaValuePHA; Boolean)
        {

        }
        field(50001; BASAllowIndexUnderNull; Boolean)
        {

        }
        field(50002; BASForceAfaBelowZeroPHA; Boolean)
        {

        }
        field(50003; BASKOREIntegrationDeprPHA; Boolean)
        {
            Caption = 'G/L Integration - Depreciation';

        }
        field(50004; BASBlockedPHA; Boolean)
        {
            Caption = 'Gesperrt';

        }
        field(50005; BASAfaUntilDoubleEcoLifePHA; Boolean)
        {
            Caption = '', comment = 'DEA="Afa bis doppelte Nutzungsdauer"';
        }
    }
}
