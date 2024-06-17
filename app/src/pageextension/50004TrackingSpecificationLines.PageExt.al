

//TASK53 TASK53.01          20.03.2024  MFU:  Verkaufschargennr von Artikelverfolgung mitbuchen

pageextension 50004 TrackingSpecificationLines extends "Item Tracking Lines"
{

    //Verkaufschargennr
    layout
    {
        addafter("Lot No.")
        {

            // >> TASK53.01
            field("Verkaufschargennr"; Rec."Verkaufschargennr.")
            {
                ApplicationArea = Basic, Suite;
                ToolTip = 'Artikelstamm Statistikcode zum Buchungszeitpunkt';
                Visible = true;
            }
            // << TASK53.01

        }

        //Ablaufdatum fix Einblenden
        modify("Expiration Date")
        {
            Visible = true;

        }

    }

    trigger OnAfterGetRecord()
    var
        recLot: Record "Lot No. Information";
    begin
        if recLot.Get(Rec."Item No.", '', Rec."Lot No.") then begin
            Rec."Verkaufschargennr." := recLot."Verkaufschargennr.";
        end;

    end;

}
