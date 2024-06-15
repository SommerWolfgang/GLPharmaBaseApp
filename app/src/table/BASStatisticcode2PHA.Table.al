
table 50015 BASStatisticcode2PHA
{
    Caption = 'Statistikcode';
    DataClassification = CustomerContent;
    //LookupPageID = StatistikcodeList;
    //DrillDownPageID = StatistikcodeList;

    fields
    {
        field(1; "Code"; Code[10])
        {
            Caption = 'Code', comment = 'DEA="Code"';
        }
        field(2; Description; Text[30])
        {
            Caption = 'Description', comment = 'DEA="Bezeichnung"';
        }
        field(3; Level; Integer)
        {
            Caption = 'Level', comment = 'DEA="Ebene"';
        }
        field(4; "Belongs to"; Code[10])
        {
            Caption = 'Belongs to', comment = 'DEA=" Gehört Zu"';
            TableRelation = BASStatisticcode2PHA;
        }
        field(5; PM; Code[10])
        {
            Caption = 'PM', comment = 'DEA="PM"';
            TableRelation = "Salesperson/Purchaser";
        }
        field(6; Marketinglinie; Code[20])
        {

        }
        field(7; Wirkstoff; Code[30])
        {
        }
        field(8; Standort; Code[20])
        {
        }
        field(9; NichtInBCUebernehmen; Boolean)
        {
        }
        field(10; InNAVBCStatcode4; Boolean)
        {
        }
    }

    keys
    {
        key(Key1; "Code", Level)
        {
        }
        key(Key2; Description)
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Code", Description)
        {
        }
    }
}