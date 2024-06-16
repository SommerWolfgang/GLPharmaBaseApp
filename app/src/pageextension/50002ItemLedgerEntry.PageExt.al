pageextension 50002 "50002ItemLedgerEntry" extends "Item Ledger Entries"
{
    layout
    {
        addafter("Source No.")
        {
            field("Statistikcode I"; Rec."Statistikcode I")
            {
                ApplicationArea = Basic, Suite;
                ToolTip = 'Artikelstamm Statistikcode zum Buchungszeitpunkt';
                Visible = true;
            }
            field("Statistikcode II"; Rec."Statistikcode II")
            {
                ApplicationArea = Basic, Suite;
                ToolTip = 'Artikelstamm Statistikcode zum Buchungszeitpunkt';
                Visible = true;
            }
            field("Statistikcode III"; Rec."Statistikcode III")
            {
                ApplicationArea = Basic, Suite;
                ToolTip = 'Artikelstamm Statistikcode zum Buchungszeitpunkt';
                Visible = true;
            }
        }
    }
}