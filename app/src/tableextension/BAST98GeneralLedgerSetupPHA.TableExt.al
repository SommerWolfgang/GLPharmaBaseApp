tableextension 50018 BAST98GeneralLedgerSetupPHA extends "General Ledger Setup"
{
    // version NAVW114.45,NAVDACH14.45,TODOPBA

    // GL001 Felder bIncJnlBatchName, AllowNegativPurchInvoices
    //       "URL Latest Rates" (URL neueste Kurse) angelegt. Definiert die URL, wo das XML File
    //       für die Währungskurse downgeloadet werden kann.
    // 
    // ------------------------------------------------------------------------------------------------------------------------------------
    // Datum      | Autor   | Status     | Beschreibung
    // ------------------------------------------------------------------------------------------------------------------------------------
    // 2010-02-05 | Petsch  | ok         | Update von 3.60
    // ------------------------------------------------------------------------------------------------------------------------------------
    // 2013-08-01 | MFU     | ok         | Felder für PDF Zuestelladressen eingebaut
    // ------------------------------------------------------------------------------------------------------------------------------------
    // 2016-07-12 | MFU     | ok         | PDFPfadExport für eigenen Speicherort der Export PDF-Belege eingebaut
    // ------------------------------------------------------------------------------------------------------------------------------------
    // 2016-08-01 | MFU     | ok         | GL002 - Buchungszeitraum mit Kore-Buchungszeitraum synchronisieren  (OswaldH)
    // ------------------------------------------------------------------------------------------------------------------------------------
    // 2016-09-14 | MFU     | ok         | ProjektRessBuchAb für Projektbuchungen vor Fibu Buchungszeitraum (OswaldH)
    // ------------------------------------------------------------------------------------------------------------------------------------
    // 2017-02-08 | MFU     | ok         | PDFPfadAvis eingebaut
    // ------------------------------------------------------------------------------------------------------------------------------------
    // 2018-04-23 | DKO     | ok         | PDFPfadEK eingebaut für EK Bestellungen
    // ------------------------------------------------------------------------------------------------------------------------------------

    fields
    {
        field(50000; "BASURL Latest RatesPHA"; Text[250])
        {
            Caption = 'URL Latest Rates';

        }
        field(50500; BASArtikelBuchDatGrenzePHA; Boolean)
        {

        }
        field(50501; BASIncJnlBatchNamePHA; Boolean)
        {
            Caption = 'Incr. no. in jnl. batch name';

        }
        field(50502; BASAllowNegativePurchInvoicesPHA; Boolean)
        {

        }
        field(50504; BASPDFPfadPHA; Text[250])
        {
        }
        field(50505; BASPDFPfadGHBestellungPHA; Text[250])
        {
        }
        field(50506; BASPDFPfadExportPHA; Text[250])
        {
        }
        field(50507; BASProjektRessBuchAbPHA; DateFormula)
        {
            Description = 'MFU';
        }
        field(50508; BASPDFPfadAvisPHA; Text[250])
        {
            Description = 'MFU';
        }
        field(50509; BASPDFPfadEKPHA; Text[250])
        {
            Description = 'DKO';
        }
    }
}
