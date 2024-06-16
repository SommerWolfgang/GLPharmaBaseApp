
//TASK59 TASK59.01   23.04.2024  MFU:  Zusätzliche Felder für Anzeige von Chargeninfos auf Page

pageextension 50009 ItemTrackingSummaryExt extends "Item Tracking Summary"
{
    layout
    {
        addafter("Lot No.")
        {
            // >> TASK59.01    
            field(Chargenstatus; Chargenstatus)
            {
                //cuChargenVerwaltung.GetChargenStatus(Rec.get, "Lot No.")
                ApplicationArea = All;
                Visible = true;
                Editable = false;

            }
            // << TASK59.01

        }
    }


}
