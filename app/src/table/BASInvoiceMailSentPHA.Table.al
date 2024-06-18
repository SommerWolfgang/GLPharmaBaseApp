table 50011 BASInvoiceMailSentPHA
{
    Caption = 'Rechnung Mailversand';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Invoice No"; Code[20])
        {
            Caption = 'Rechnungs Nr';
        }
        field(2; EMailEmpfaenger; Text[80])
        {
            Caption = 'EMail Empfaenger';
        }
        field(4; SendeDatum; DateTime)
        {
            Caption = 'Sende Datum';
        }
        field(5; Versendet; Boolean)
        {
            Caption = 'Versendet';
        }
        field(6; Buchungsdatum; Date)
        {
            Caption = 'Buchungsdatum';
        }
        field(7; RechKdnNr; Code[20])
        {
            CalcFormula = lookup("Sales Invoice Header"."Bill-to Customer No." where("No." = field("Invoice No")));
            Caption = 'Rechnungs Kunden Nr';
            FieldClass = FlowField;
        }
        field(8; "Responsibility Center"; Code[10])
        {
            CalcFormula = lookup("Sales Invoice Header"."Responsibility Center" where("No." = field("Invoice No")));
            Caption = 'Zuständigkeitseinheitencode';
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "Invoice No")
        {
        }
        key(Key2; EMailEmpfaenger, "Invoice No")
        {
        }
    }
}