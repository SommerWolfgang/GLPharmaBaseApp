tableextension 50044 BASSalesReceivablesSetupExtPHA extends "Sales & Receivables Setup"
{
    // LAN001 25.11.09 ACPSS LAN1.00
    //   New Fields: ID 50001 - 50003
    // 
    // 001 15.11.06 ACPWF
    //   New Fields: "Due Date Calculation", "Discount Date Calculation", "Reminder Terms Code"
    // #DOKU#
    // 
    // Pkt 001 nur wenn Sald.AbstimmGutschriftAktiv = true
    // 
    // GL001 Vorauswahl Auftrag-Buchen-Dialogbox
    // GL002 Feld StockoutWarningSales
    // 
    // 
    // Datum      | Autor   | Status     | Beschreibung
    // --------------------------------------------------------------------------------------------------------
    // 2010-02-05 | Petsch  | ok         | Update von 3.60
    // --------------------------------------------------------------------------------------------------------
    // 2014-02-26 | MFU     | ok         | GL003 - Spalte "EinzelrechnungMailAdressen" eingefügt für PDF-Rechnung Versenden
    // --------------------------------------------------------------------------------------------------------
    // 2018-02-05 | MFU     | ok         | GL004 - Spalte "EinzelrechnungMailAdressen2" eingefügt für PDF-Rechnung Versenden (250 Zeichen zu wenig)
    // --------------------------------------------------------------------------------------------------------
    fields
    {
        field(50000; BASVorauswahlAuftragBuchenPHA; Option)
        {
            Description = 'Petsch';
            OptionMembers = " ",Liefern,Fakturieren,"Liefern und Fakturieren";
        }
        field(50001; "BASDue Date CalculationPHA"; DateFormula)
        {
            Caption = 'Due Date Calculation';
            Description = 'LAN1.00';
        }
        field(50002; "BASDiscount Date CalculationPHA"; DateFormula)
        {
            Caption = 'Discount Date Calculation';
            Description = 'LAN1.00';
        }
        field(50003; "BASReminder Terms CodePHA"; Code[10])
        {
            Caption = 'Reminder Terms Code';
            Description = 'LAN1.00';
            TableRelation = "Reminder Terms";
        }
        field(50004; "BASSald.AbstimmungGutschriftAktivPHA"; Boolean)
        {
            Description = 'Petsch';
        }
        field(50005; BASStockoutWarningOnlySalesPHA; Boolean)
        {
            Description = 'Petsch';
        }
        field(50006; BASEinzelrechnungMailAdressenPHA; Text[250])
        {
            Description = 'MFU';
        }
        field(50007; BASEinzelrechnungMailAdressen2PHA; Text[250])
        {
            Description = 'MFU';
        }
        field(50008; BASEinzelrechnungMailAdressen3PHA; Text[250])
        {
            Description = 'MFU';
        }
    }
}
