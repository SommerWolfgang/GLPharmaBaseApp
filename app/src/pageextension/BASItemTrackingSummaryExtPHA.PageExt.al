pageextension 50009 BASItemTrackingSummaryExtPHA extends "Item Tracking Summary"
{
    layout
    {
        addafter("Lot No.")
        {
            field(Chargenstatus; Rec.BASChargenstatusPHA)
            {
                ApplicationArea = All;
                Editable = false;
                ToolTip = 'Specifies the value of the Chargenstatus field.';
                Visible = true;
            }
        }
    }
}