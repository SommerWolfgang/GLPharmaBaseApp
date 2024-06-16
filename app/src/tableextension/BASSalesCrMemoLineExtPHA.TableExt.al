tableextension 50037 BASSalesCrMemoLineExtPHA extends "Sales Cr.Memo Line"
{// LAN001 25.11.09 ACPSS LAN1.00
    //   New Fields: ID 50000, 50005, 50006, 50010, 50011, 50506 - 50513, 50515 - 50517, 50519
    // 
    // GL001 Key für Sachkonto-Artikelbuchungsauswertung
    //            Type,Zuordnung zu Artikelnr.,Shipment Date,Sell-to Customer No.,Verkaufsstatistikcode,Shortcut Dimension 1 Code,No.
    //                SumIndex: Quantity,Amount
    // 
    // ------------------------------------------------------------------------------------------------------------------------------------
    // Datum      | Autor   | Status     | Beschreibung
    // ------------------------------------------------------------------------------------------------------------------------------------
    // 2010-02-00 | Petsch  | ok         | Update von 3.60
    // ------------------------------------------------------------------------------------------------------------------------------------
    // 2010-04-29 | MFU     | ok         | Spalte Zegehörigkeitsdatum für Wertgutschriften eingebaut und zu Summen Key hinzugefügt
    // ------------------------------------------------------------------------------------------------------------------------------------
    // 2014-10-02 | MFU     | ok         | UPDATE2013 - Key "Zuordnung zu Artikelnr." für Artikel löschen hinzugefügt
    // ------------------------------------------------------------------------------------------------------------------------------------
    // 2015-08-18 | Petsch  | ok         | Function Packungsgroesse()
    // ------------------------------------------------------------------------------------------------------------------------------------
    fields
    {
        field(50000; BASTeilmengePHA; Decimal)
        {
            DecimalPlaces = 0 : 5;
            Description = 'LAN1.00';
        }
        field(50005; "BASAbzug %PHA"; Decimal)
        {
            DecimalPlaces = 0 : 5;
            Description = 'LAN1.00';
        }
        field(50006; BASAbzugsbetragPHA; Decimal)
        {
            Description = 'LAN1.00';
        }
        field(50010; "BASLot No.PHA"; Code[20])
        {
            Caption = 'Lot No.';
            Description = 'LAN1.00';
            TableRelation = IF (Type = CONST(Item)) "Lot No. Information"."Lot No." WHERE("Item No." = FIELD("No."),
                                                                                         "Variant Code" = FIELD("Variant Code"));
        }
        field(50011; "BASZuordnung zu LieferungPHA"; Code[20])
        {
            Description = 'Petsch';
        }
        field(50014; "Zugehörigkeitsdatum"; Date)
        {
            Description = 'MFU für Wertgutschriften';
        }
        field(50506; BASArtikelgruppePHA; Code[10])
        {
            Description = 'LAN1.00';
            Editable = false;

        }
        field(50507; "BASStatistikcode IPHA"; Code[10])
        {
            Description = 'LAN1.00';
            Editable = false;
            TableRelation = Statistikcode2 WHERE(Ebene = CONST(1));
        }
        field(50508; "BASStatistikcode IIPHA"; Code[10])
        {
            Description = 'LAN1.00';
            Editable = false;
            TableRelation = Statistikcode2 WHERE(Ebene = CONST(2));
        }
        field(50509; "BASStatistikcode IIIPHA"; Code[10])
        {
            Description = 'LAN1.00';
            Editable = false;
            TableRelation = Statistikcode2 WHERE(Ebene = CONST(3));
        }
        field(50510; "BASZuordnung zu Artikelnr.PHA"; Code[20])
        {
            Description = 'LAN1.00';
            TableRelation = Item;
        }
        field(50511; "BASWertkorrektur zu ArtikelpostenPHA"; Integer)
        {
            Description = 'LAN1.00';
        }
        field(50512; "BASCountry/Region CodePHA"; Code[10])
        {
            Caption = 'Country/Region Code';
            Description = 'LAN1.00';
            TableRelation = "Country/Region";
        }
        field(50513; BASNaturalrabattmengePHA; Decimal)
        {
            DecimalPlaces = 0 : 5;
            Description = 'LAN1.00';
        }
        field(50515; BASVerkaufsstatistikcodePHA; Code[10])
        {
            Description = 'LAN1.00';
        }
        field(50516; "BASExpiration DatePHA"; Date)
        {
            Caption = 'Expiration Date';
            Description = 'LAN1.00';
        }
        field(50517; "BASSuchtgift/PsychotropPHA"; Text[1])
        {
            Description = 'LAN1.00';
        }
        field(50519; "BASVerkaufschargennr.PHA"; Code[20])
        {
            Description = 'LAN1.00';
        }
    }
}
