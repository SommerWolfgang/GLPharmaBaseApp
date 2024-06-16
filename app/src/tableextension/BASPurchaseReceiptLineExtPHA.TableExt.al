tableextension 50023 BASPurchaseReceiptLineExtPHA extends "Purch. Rcpt. Line"
{// version NAVW114.45,TODOPBA

    // LAN001 25.11.09 ACPSS LAN1.00
    //   New Fields: ID 50000, 50010, 50506 - 50510, 50514, 50515, 50526, 50528 - 50530, 50550, 50551
    // LAN002 25.11.09 ACPSS LAN1.00
    //   Urspr. Menge zurücksetzen
    // 
    // Datum      | Autor   | Status     | Beschreibung
    // --------------------------------------------------------------------------------------------------------
    // 2011-01-24 | Petsch  | ok         | Neuer Key: Pay-to Vendor No., Location Code, Qty. Rcd. Not Invoiced
    //                                     damit Wareneingangszeilen holen schneller
    // --------------------------------------------------------------------------------------------------------
    // 2012-09-25 | MFU     | ok         | Neuer Key: Pay-to Vendor No., Location Code, Line No., Qty. Rcd. Not Invoiced
    //                                     für Sortierungs Verbesserung in Wareneingangszeilen holen
    // --------------------------------------------------------------------------------------------------------
    // 2014-05-02 | MFU     | ok         | Neuer Key bei UPDATE2013: Pay-to Vendor No.,Buy-from Vendor No.,Qty. Rcd. Not Invoiced
    //                                     für Sortierungs Verbesserung in Wareneingangszeilen holen
    // --------------------------------------------------------------------------------------------------------
    // 2016-05-23 | MFU     | ok         | Feld "BeschreibungLang" eingebaut
    // --------------------------------------------------------------------------------------------------------
    // 2017-01-23 | MFU     | ok         | SMVerwendungszweck Spalte eingebaut
    // --------------------------------------------------------------------------------------------------------
    // 2017-08-28 | MFU     | ok         | GL001 - Bei "Wareneingangszeilen holen" das Transportversicherungshakerl und den Lieferbedingungscode mitnehmen
    // --------------------------------------------------------------------------------------------------------
    // 2017-12-20 | MFU     | ok         | Palettenanzahl dazu
    // --------------------------------------------------------------------------------------------------------
    // 2018-09-04 | DKO     | ok         | Neue Spalte "CEP Nr" - Für LQ18 - Lieferantenqualifizierung
    // ------------------------------------------------------------------------------------------------------------------------------------

    fields
    {
        field(50000; BASPreisfaktorPHA; Decimal)
        {
            Description = 'LAN1.00';
        }
        field(50001; BASPackmittelVersionPHA; Code[20])
        {
            Description = 'Petsch';
        }
        field(50010; "BASLot No.PHA"; Code[20])
        {
            Caption = 'Lot No.';
            Description = 'LAN1.00';
            TableRelation = IF (Type = const(Item)) "Lot No. Information"."Lot No." where("Item No." = FIELD("No."),
                                                                                         "Variant Code" = FIELD("Variant Code"));
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
            TableRelation = BASStatisticCodePHA where(Level = const(1));
        }
        field(50508; "BASStatistikcode IIPHA"; Code[10])
        {
            Description = 'LAN1.00';
            Editable = false;
            TableRelation = BASStatisticCodePHA where(Level = const(2));
        }
        field(50509; "BASStatistikcode IIIPHA"; Code[10])
        {
            Description = 'LAN1.00';
            Editable = false;
            TableRelation = BASStatisticCodePHA where(Level = const(3));
        }
        field(50510; "BASCountry/Region CodePHA"; Code[10])
        {
            Caption = 'Country/Region Code';
            Description = 'LAN1.00';
            TableRelation = "Country/Region";
        }
        field(50511; BASEinAusFuhrBewilligungsNrPHA; Text[100])
        {
            Description = 'MFU';
        }
        field(50512; BASSMVerwendungszweckPHA; Option)
        {
            Description = 'MFU';
            OptionMembers = " ","Import für Inlandsverbrauch","Import für Wiederausfuhr";
        }
        field(50514; "BASSuchtgift/PsychotropPHA"; Text[1])
        {
            Description = 'LAN1.00';
        }
        field(50515; "BASDirect Unit Cost PEPHA"; Decimal)
        {
            AutoFormatExpression = GetCurrencyCodeFromHeader;
            AutoFormatType = 2;
            Caption = 'Direct Unit Cost PE';
            Description = 'LAN1.00';
        }
        field(50526; "BASLieferantenchargennr.PHA"; Code[20])
        {
            Description = 'LAN1.00';
        }
        field(50528; "BASVerkaufschargennr.PHA"; Code[20])
        {
            Description = 'LAN1.00';
        }
        field(50529; "BASUrspr. MengePHA"; Decimal)
        {
            DecimalPlaces = 0 : 5;
            Description = 'LAN1.00';
        }
        field(50530; "BASExpiration DatePHA"; Date)
        {
            Caption = 'Expiration Date';
            Description = 'LAN1.00';
        }
        field(50550; BASGebindeanzahlPHA; Decimal)
        {
            DecimalPlaces = 0 : 5;
            Description = 'LAN1.00';
        }
        field(50551; BASGebindeartencodePHA; Code[10])
        {
            Description = 'LAN1.00';

        }
        field(50553; BASPalettenanzahlPHA; Integer)
        {
        }
        field(50585; BASBeschreibungLangPHA; BLOB)
        {
            Description = 'MFU';
        }
        field(50586; "BASCEP NrPHA"; Code[50])
        {
        }
        field(50587; "BASExpiration Date DMPHA"; Text[6])
        {
            Description = 'GL015,EUHUB';
            Numeric = true;
            Width = 6;
        }
    }
}
