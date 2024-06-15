tableextension 50010 "BAST23 VendorPHA" extends Vendor
{
    fields
    {
        field(50003; "BASModified byPHA"; Code[50])
        {
            Caption = 'Korrigiert durch';
            Description = 'Petsch';
            Editable = false;
        }
        field(50004; "BASE-MailAvisPHA"; Text[80])
        {
            Description = 'MFU';
        }
        field(50010; "BASARA-LizenzPHA"; Option)
        {
            Description = 'Rieder';
            OptionCaption = ' ,Ja,Nein';
            OptionMembers = " ",Ja,Nein;
        }
        field(50011; BASBetriebsnummerPHA; Code[10])
        {
            Description = 'MFU';
        }
        field(50020; BASBestellemailPHA; Text[80])
        {
            Description = 'DKO';
        }

    }
}
