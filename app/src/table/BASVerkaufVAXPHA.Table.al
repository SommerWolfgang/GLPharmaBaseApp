table 50008 "BASVerkauf_VAXPHA"
{
    Caption = 'Verkauf_VAX';
    DataClassification = SystemMetadata;

    // version Petsch,TODOPBA

    // 
    // Datum      | Autor   | Status   | Beschreibung
    // --------------------------------------------------------------------------------------
    // 2010-02-09 | MFU     | ok       | Update von 360
    // --------------------------------------------------------------------------------------


    fields
    {
        field(1; Artikelnr; Code[20])
        {
        }
        field(2; Kundennr; Code[20])
        {
        }
        field(3; Monat; Text[10])
        {
        }
        field(4; Betrag; Decimal)
        {
        }
        field(5; Menge; Decimal)
        {
        }
        field(6; NR; Decimal)
        {
        }
        field(7; GW; Decimal)
        {
        }
        field(8; Verkaufsstatistikcode; Code[10])
        {
        }
        field(9; Artikelpostennr; Integer)
        {
        }
    }

    keys
    {
        key(Key1; Kundennr, Artikelnr, Monat, Verkaufsstatistikcode, Artikelpostennr)
        {
        }
        key(Key2; Artikelnr, Monat)
        {
        }
    }

    fieldgroups
    {
    }
}
