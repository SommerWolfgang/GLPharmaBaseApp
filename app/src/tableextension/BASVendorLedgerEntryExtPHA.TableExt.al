tableextension 50034 BASVendorLedgerEntryExtPHA extends "Vendor Ledger Entry"
{
    fields
    {
        field(50000; "BASOrder No.PHA"; Code[20])
        {
            Caption = 'Order No.';

        }
        field(50001; "BASOrder DatePHA"; Date)
        {
            Caption = 'Order Date';

        }
        field(50002; "BASValuta DatePHA"; Date)
        {
            Caption = 'Valuta Date';

        }
    }
}
