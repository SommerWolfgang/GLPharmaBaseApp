table 50108 "BASWindream ButtonPHA"
{
    // version WD9.00,TODOPBA

    Caption = 'Windream Button';

    fields
    {
        field(1; "Form ID"; Integer)
        {
            Caption = 'Form ID';
        }
        field(2; "Document Type"; Text[50])
        {
            Caption = 'Document Type';
        }
        field(3; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(4; Description; Text[50])
        {
            Caption = 'Description';
        }
        field(5; Level; Integer)
        {
            Caption = 'Level';
        }
        field(6; "Parent Line No."; Integer)
        {
            Caption = 'Parent Line No.';
        }
        field(7; "Presentation Order"; Text[100])
        {
            Caption = 'Presentation Order';
        }
        field(8; Function; Option)
        {
            Caption = 'Function';
            OptionCaption = ' ,Add,Search';
            OptionMembers = " ","Anhängen",Suchen;
        }
        field(9; "Label"; Text[250])
        {
            Caption = 'Label';
        }
        field(10; "Table ID"; Integer)
        {
            Caption = 'Table ID';
        }
        field(11; Deleted; Boolean)
        {
            Caption = 'Deleted';
        }
        field(12; Document; Option)
        {
            Caption = 'Document';
            OptionCaption = ' ,2.Document,3.Document';
            OptionMembers = " ","2.Beleg","3.Beleg";
        }
        field(13; "More Search"; Boolean)
        {
            Caption = 'More Search';
        }
        field(50000; "Function Visible"; Boolean)
        {
        }
    }

    keys
    {
        key(Key1; "Form ID", "Line No.")
        {
        }
        key(Key2; "Form ID", "Document Type", "Line No.", "Function")
        {
        }
    }

    fieldgroups
    {
    }
}
