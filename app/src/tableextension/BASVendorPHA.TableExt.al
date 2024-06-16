tableextension 50010 BASVendorPHA extends Vendor
{
    fields
    {
        field(50003; "BASModified byPHA"; Code[50])
        {
            Caption = 'Korrigiert durch';

            Editable = false;
        }
        field(50004; "BASE-MailAvisPHA"; Text[80])
        {

        }
        field(50010; "BASARA-LizenzPHA"; Option)
        {

            OptionCaption = ' ,Ja,Nein';
            OptionMembers = " ",Ja,Nein;
        }
        field(50011; BASBetriebsnummerPHA; Code[10])
        {

        }
        field(50020; BASBestellemailPHA; Text[80])
        {

        }

    }
}
