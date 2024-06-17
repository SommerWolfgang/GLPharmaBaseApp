table 50107 BASCCUGroupsPHA
{
    Caption = 'Groups', comment = 'DEA="Gruppen"';
    DataClassification = CustomerContent;
    fields
    {
        field(1; Typ; enum BASGroupTypePHA)
        {
            Caption = 'Typ', comment = 'DEA="Type"';
        }
        field(2; Group; Code[10])
        {
            Caption = 'Group', comment = 'DEA="Gruppe"';
        }
        field(3; Description; Text[30])
        {
            Caption = 'Description', comment = 'DEA="Beschreibung"';
        }
        field(4; GroupInteger; Integer)
        {
            Caption = 'GroupInteger', comment = 'DEA="GruppeZahl"';
        }
    }

    keys
    {
        key(Key1; Typ, Group)
        {
        }
    }
    trigger OnRename()
    var
        EmptyPKGErr: Label 'Empty PKG can not rename!', comment = 'DEA="Leere PKG kann nicht umbenannt werden!"';
    begin
        if (Typ = Typ::PackageSize) and (xRec.Group = '') then
            Error(EmptyPKGErr);
    end;
}