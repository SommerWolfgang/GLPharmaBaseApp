tableextension 50059 BASCommentLinePHA extends "Comment Line"
{
    fields
    {
        field(50000; "BASMeldung bei EK-LieferungPHA"; Boolean)
        {
            DataClassification = CustomerContent;

        }
        field(50001; BASShowMsgInSalesOrderPHA; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(50002; BASShowNoteCustLedgerEntryPHA; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(50003; BASShowNotePurchaseInvoicePHA; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(50004; BASNoteFAPHA; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(50500; BASShowNoteOrderPHA; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(50501; "BASMeldung bei UmlagerungPHA"; Boolean)
        {
            DataClassification = CustomerContent;
        }
    }
}