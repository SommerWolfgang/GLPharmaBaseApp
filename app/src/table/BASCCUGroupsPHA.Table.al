table 50107 BASCCUGroupsPHA
{
    // version LAN1.00,Petsch

    // LAN001 22.12.09 ACPSS LAN1.00
    //   Object aus Version 3.60 übernommen
    // 
    // Petsch, 10.7.03:
    // 
    // Documentation()
    // ------------------------------------------------------------------------------------------------------------------------------------
    // Datum      | Autor   | Status     | Beschreibung
    // ------------------------------------------------------------------------------------------------------------------------------------
    // 2003-07-10 | Petsch  | ok         | Packungsgroesse als Optionswert hinzugefügt
    // ------------------------------------------------------------------------------------------------------------------------------------
    // 2009-05-05 | Petsch  | ok         | Betriebskennzeichen als Optionswert hinzugefügt
    // ------------------------------------------------------------------------------------------------------------------------------------
    // 2017-05-08 | MFU     | ok         | GL001 - Umbenennen einer Leeren PKG nicht zulassen -> Werden alle leeren Einträge im Artikelstamm sonst überschrieben
    // ------------------------------------------------------------------------------------------------------------------------------------
    // 2018-02-16 | MFU     | ok         | Spalte "GruppeZahl" eingefügt um zu einen Eintrag einen Dezimalwert eintragen zu können (Benötigt für PKG für Serialisierung)
    // ------------------------------------------------------------------------------------------------------------------------------------

    Caption = 'Gruppen';


    fields
    {
        field(1; Typ; Option)
        {
            OptionCaption = 'Artikel,Debitor,Kreditor,Verkauf,SK-Gruppe,Packungsgroesse,Betriebskennzeichen';
            OptionMembers = Artikel,Debitor,Kreditor,Verkauf,"SK-Gruppe",Packungsgroesse,Betriebskennzeichen;
        }
        field(2; Gruppe; Code[10])
        {
        }
        field(3; Description; Text[30])
        {
            Caption = 'Description';
        }
        field(4; GruppeZahl; Integer)
        {
        }
    }

    keys
    {
        key(Key1; Typ, Gruppe)
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnRename()
    begin

        // Leere Gruppe nicht umbenennen lassen
        if (Typ = Typ::Packungsgroesse) and (xRec.Gruppe = '') then
            Error('Leere PKG kann nicht umbenannt werden!');
    end;
}

