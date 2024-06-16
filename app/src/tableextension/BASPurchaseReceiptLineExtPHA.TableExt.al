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
    // 2014-05-02 | MFU     | ok         | Neuer Key bei Update2013: Pay-to Vendor No.,Buy-from Vendor No.,Qty. Rcd. Not Invoiced
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

        }
        field(50001; BASPackmittelVersionPHA; Code[20])
        {

        }
        field(50010; BASLotNoPHA; Code[20])
        {
            Caption = 'Lot No.';
            TableRelation = if (Type = const(Item)) "Lot No. Information"."Lot No."
                where("Item No." = field("No."), "Variant Code" = field("Variant Code"));
        }
        field(50506; BASArtikelgruppePHA; Code[10])
        {
            Editable = false;
        }
        field(50507; BASStatisticCodeIPHA; Code[10])
        {
            Editable = false;
            TableRelation = BASStatisticCodePHA where(Level = const(1));
        }
        field(50508; BASStatisticCodeIIPHA; Code[10])
        {
            Editable = false;
            TableRelation = BASStatisticCodePHA where(Level = const(2));
        }
        field(50509; BASStatisticCodeIIIPHA; Code[10])
        {
            Editable = false;
            TableRelation = BASStatisticCodePHA where(Level = const(3));
        }
        field(50510; BASCountryRegionCodePHA; Code[10])
        {
            Caption = 'Country/Region Code';
            TableRelation = "Country/Region";
        }
        field(50511; BASEinAusFuhrBewilligungsNrPHA; Text[100])
        {
        }
        field(50512; BASSMVerwendungszweckPHA; Option)
        {
            OptionMembers = " ","Import für Inlandsverbrauch","Import für Wiederausfuhr";
        }
        field(50514; "BASSuchtgift/PsychotropPHA"; Text[1])
        {

        }
        field(50515; BASDirectUnitCostPEPHA; Decimal)
        {
            AutoFormatExpression = GetCurrencyCodeFromHeader();
            AutoFormatType = 2;
            Caption = 'Direct Unit Cost PE';
        }
        field(50526; BASPurchaseLotNoPHA; Code[20])
        {
        }
        field(50528; BASSalesLotNoPHA; Code[20])
        {
        }
        field(50529; "BASUrspr. MengePHA"; Decimal)
        {
            DecimalPlaces = 0 : 5;

        }
        field(50530; BASExpirationDatePHA; Date)
        {
            Caption = 'Expiration Date';
        }
        field(50550; BASGebindeanzahlPHA; Decimal)
        {
            DecimalPlaces = 0 : 5;
        }
        field(50551; BASGebindeartencodePHA; Code[10])
        {
        }
        field(50553; BASPalettsPHA; Integer)
        {
        }
        field(50585; BASDescriptionLongPHA; MediaSet)
        {
        }
        field(50586; BASCEPNoPHA; Code[50])
        {
        }
        field(50587; BASExpirationDateDMPHA; Text[6])
        {
            Numeric = true;
            Width = 6;
        }
    }
}