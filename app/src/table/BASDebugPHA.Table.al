table 50007 BASDebugPHA
{
    Caption = 'Debug';
    DataClassification = SystemMetadata;
    fields
    {
        field(1; "text"; Text[250])
        {
        }
        field(2; id; Integer)
        {
            AutoIncrement = true;
        }
        field(3; datum; Date)
        {
        }
        field(4; uhrzeit; Time)
        {
        }
        field(5; benutzer; Text[30])
        {
        }
    }

    keys
    {
        key(Key1; id)
        {
        }
    }

    fieldgroups
    {
    }
}


