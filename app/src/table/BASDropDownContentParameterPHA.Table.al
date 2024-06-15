table 50106 BASDropDownContentParameterPHA
{

    // version Rieder

    // ------------------------------------------------------------------------------------------------------------------------------------
    // Datum      | Autor   | Status     | Beschreibung
    // ------------------------------------------------------------------------------------------------------------------------------------
    // 2007-02-20 | Rieder  | erstellt   | sichert den Inhalt von T50034 DropDownContent durch Trigger
    // ------------------------------------------------------------------------------------------------------------------------------------
    // 2011-04-13 | MFU     | OK         | "Standort Zuordnung" für Schulungsverwaltung Trennung Wien/Lannach
    // ------------------------------------------------------------------------------------------------------------------------------------
    Permissions = tabledata BASDropDownContentPHA = R,
        tabledata BASDropDownContentParameterPHA = R;

    fields
    {
        field(1; "Table"; Integer)
        {
            Caption = 'Tabelle';
            TableRelation = BASDropDownContentPHA.Tabelle;
            ValidateTableRelation = false;
        }
        field(2; "Field"; Code[20])
        {
            Caption = 'Feld';
            TableRelation = BASDropDownContentPHA.Feld;
            ValidateTableRelation = false;
        }
        field(3; ID; Code[20])
        {
            TableRelation = BASDropDownContentPHA.ID;
            ValidateTableRelation = false;
        }
        field(5; Description; Text[250])
        {
            Caption = 'Beschreibung';
        }
        field(10; Allow_New; Boolean)
        {
            Caption = 'Anlegen';
            InitValue = true;
        }
        field(11; Allow_Modify; Boolean)
        {
            Caption = 'Ändern';
            InitValue = true;
        }
        field(12; Allow_Delete; Boolean)
        {
            Caption = 'Löschen';
            InitValue = true;
        }
        field(13; Allow_Description; Boolean)
        {
            Caption = 'Text ändern';
            InitValue = true;
        }
        field(14; "Standort Zuordnung"; Code[20])
        {
        }
    }

    keys
    {
        key(Key1; "Table", "Field", ID)
        {
        }
    }

    fieldgroups
    {
    }
}

