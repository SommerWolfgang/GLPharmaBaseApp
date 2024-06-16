tableextension 50018 BASGeneralLedgerSetupPHA extends "General Ledger Setup"
{
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
        field(50502; BASAllowNegativePurchInvPHA; Boolean)
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

        }
        field(50508; BASPDFPfadAvisPHA; Text[250])
        {

        }
        field(50509; BASPDFPfadEKPHA; Text[250])
        {

        }
    }
}
