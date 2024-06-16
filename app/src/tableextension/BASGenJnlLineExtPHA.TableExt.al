tableextension 50016 BASGenJnlLineExtPHA extends "Gen. Journal Line"
{
    fields
    {
        field(50000; "BASKORE DatePHA"; Date)
        {
            Caption = 'KOREdatum';
        }
        field(50005; BASAufteilungscodePHA; Code[10])
        {
        }
        field(50006; "BASAufteilung erfolgtPHA"; Boolean)
        {
        }
        field(50500; "BASOrder No.PHA"; Code[20])
        {
            Caption = 'Order No.';

        }
        field(50501; "BASOrder DatePHA"; Date)
        {
            Caption = 'Order Date';

        }
        field(50502; "BASValuta DatePHA"; Date)
        {
            Caption = 'Valuta Date';

        }
        field(50580; "BASBezogen auf Artikelnr.PHA"; Code[20])
        {

            TableRelation = Item;
        }
    }
}