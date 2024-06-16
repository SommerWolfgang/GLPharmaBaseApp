tableextension 50044 BASSalesReceivablesSetupExtPHA extends "Sales & Receivables Setup"
{
    fields
    {
        field(50000; BASVorauswahlAuftragBuchenPHA; Option)
        {
            OptionMembers = " ",Liefern,Fakturieren,"Liefern und Fakturieren";
        }
        field(50001; BASDueDateCalculationPHA; DateFormula)
        {
            Caption = 'Due Date Calculation';

        }
        field(50002; BASDiscountDateCalculationPHA; DateFormula)
        {
            Caption = 'Discount Date Calculation';

        }
        field(50003; BASReminderTermsCodePHA; Code[10])
        {
            Caption = 'Reminder Terms Code';
            TableRelation = "Reminder Terms";
        }
        field(50004; BASSaldoAbstimmungGSAktivPHA; Boolean)
        {
        }
        field(50005; BASStockoutWarningOnlySalesPHA; Boolean)
        {

        }
        field(50006; BASSingleInvoiceMailAddrPHA; Text[250])
        {
        }
        field(50007; BASSingleInvoiceMailAddr2PHA; Text[250])
        {
        }
        field(50008; BASSingleInvoiceMailAddr3PHA; Text[250])
        {
        }
    }
}