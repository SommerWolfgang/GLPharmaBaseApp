table 50014 BASStatistikcodePHA
{
    Caption = 'Statistikcode';
    DataClassification = CustomerContent;


    // version LAN1.00,TODOPBA

    // LAN001 22.12.09 ACPSS LAN1.00
    //   Object aus Version 3.60 übernommen
    // 
    // 
    // ------------------------------------------------------------------------------------------------------------------------------------
    // Datum      | Autor   | Status     | Beschreibung
    // ------------------------------------------------------------------------------------------------------------------------------------
    // 2014-11-10 | MFU     | ok         | GL001 Löschen bei vorhandenen Posten zu Statistikcodes nicht zulassen
    // ------------------------------------------------------------------------------------------------------------------------------------
    // 2014-12-16 | MFU     | ok         | UPDATE2013 -> Key auf Bescgreibung dazu für Schnellsuche bei VK-Berichten
    // ------------------------------------------------------------------------------------------------------------------------------------
    // 2017-05-17 | MFU     | ok         | Marketinglinie über Statcode3 auf Dropdowncontent gelegt
    // ------------------------------------------------------------------------------------------------------------------------------------
    // 2018-11-19 | MFU     | ok         | Wirkstoff angelegt (Wunsch Oswald für BI4C Auswertungen)
    // ------------------------------------------------------------------------------------------------------------------------------------

    fields
    {
        field(1; "Code"; Code[10])
        {
        }
        field(2; Bezeichnung; Text[30])
        {
        }
        field(3; Ebene; Integer)
        {
        }
        field(4; "Gehört Zu"; Code[10])
        {
            TableRelation = BASStatistikcode2PHA;
        }
        field(5; PM; Code[10])
        {
            TableRelation = "Salesperson/Purchaser";
        }
        field(6; Marketinglinie; Code[20])
        {

        }
        field(7; Wirkstoff; Code[30])
        {
        }
        field(8; Standort; Code[20])
        {
        }
        field(9; NichtInBCUebernehmen; Boolean)
        {
        }
        field(10; InNAVBCStatcode4; Boolean)
        {
        }
    }

    keys
    {
        key(Key1; "Code", Ebene)
        {
        }
        key(Key2; Bezeichnung)
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Code", Bezeichnung)
        {
        }
    }

}