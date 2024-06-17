pageextension 50004 BASTrackingSpecLinesPHA extends "Item Tracking Lines"
{
    layout
    {
        addafter("Lot No.")
        {
            field(BASSalesLotNoPHA; Rec.BASSalesLotNoPHA)
            {
                ApplicationArea = Basic, Suite;
                ToolTip = 'Artikelstamm Statistikcode zum Buchungszeitpunkt';
                Visible = true;
            }
        }

        modify("Expiration Date")
        {
            Visible = true;
        }
    }

    trigger OnAfterGetRecord()
    var
        LotNoInformation: Record "Lot No. Information";
    begin
        if LotNoInformation.Get(Rec."Item No.", '', Rec."Lot No.") then
            Rec.BASSalesLotNoPHA := LotNoInformation.BASSalesLotNoPHA;
    end;
}