
//TASK47 TASK47.01  14.03.2024  MFU:  Benutzer Lookup Funktion

pageextension 50000 "50000_User" extends Users
{
    actions
    {
        addlast(processing)   //Creation
        {
            // group(processing)
            // {
            action("BenutzerBereinigung")
            {

                ApplicationArea = all;
                Caption = 'Benutzerbereinigung';

                trigger OnAction()
                var
                    xmlBenutzerBer: XmlPort XmlportBenutzerbereinigung;
                begin
                    xmlBenutzerBer.Run();
                end;

            }

            // >> TASK47.01  
            action("BenutzerKopieren")
            {

                ApplicationArea = all;
                Caption = 'Benutzer kopieren';

                trigger OnAction()
                var
                    pBenutzerKopieren: Page CopyUser;
                begin
                    pBenutzerKopieren.Run();
                end;

            }
            // << TASK47.01
            // }
        }
    }
}
