pageextension 50000 BASUserExtPHA extends Users
{
    actions
    {
        addlast(processing)
        {
            action(BASUserPurgePHA)
            {
                ApplicationArea = all;
                Caption = 'Benutzerbereinigung';
                Image = ClearFilter;
                ToolTip = 'Executes the Benutzerbereinigung action.';

                trigger OnAction()
                // var
                //     xmlBenutzerBer: XmlPort XmlportBenutzerbereinigung;
                begin
                    // ToDo 
                    Message('Under Construction!');
                    // xmlBenutzerBer.Run();
                end;
            }
            action(CopyUser)
            {
                ApplicationArea = all;
                Caption = 'Benutzer kopieren';
                Image = Copy;
                ToolTip = 'Executes the Benutzer kopieren action.';

                trigger OnAction()
                var
                    CopyUser: Page BASCopyUserPHA;
                begin
                    CopyUser.Run();
                end;
            }
        }
    }
}