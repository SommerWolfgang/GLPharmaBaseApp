
//TASK59.01    23.04.2024  MFU: Zusätzliche Felder für Anzeige von Chargeninfos auf Page

tableextension 50060 BASEntrySummaryExtPHA extends "Entry Summary"
{
    fields
    {
        // >> TASK59.01
        field(50000; BASChargenstatusPHA; Code[20])
        {
            Caption = 'Chargenstatus';
            DataClassification = CustomerContent;
        }
        // >> TASK59.01
    }
}
