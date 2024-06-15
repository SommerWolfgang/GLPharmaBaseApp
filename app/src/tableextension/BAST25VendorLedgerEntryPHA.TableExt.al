tableextension 50034 BAST25VendorLedgerEntryPHA extends "Vendor Ledger Entry"
{
    fields
    {
        field(50000; "BASOrder No.PHA"; Code[20])
        {
            Caption = 'Order No.';
            Description = 'LAN1.00';
        }
        field(50001; "BASOrder DatePHA"; Date)
        {
            Caption = 'Order Date';
            Description = 'LAN1.00';
        }
        field(50002; "BASValuta DatePHA"; Date)
        {
            Caption = 'Valuta Date';
            Description = 'LAN1.00';
        }
    }
}
