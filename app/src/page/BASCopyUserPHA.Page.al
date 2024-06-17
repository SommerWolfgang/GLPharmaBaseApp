page 50001 BASCopyUserPHA
{
    ApplicationArea = All;
    PageType = Card;
    UsageCategory = Administration;

    layout
    {
        area(Content)
        {
            group(CopyUser)
            {
                field(tUserVon; SourceUser)
                {
                    ApplicationArea = All;
                    Caption = 'Benutzer von';
                    ToolTip = 'Kopieren von Benutzer';

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        User2: Record user;
                    begin
                        User2 := GetUser(SourceUser);
                        UserSelection.Open(User2);
                    end;

                    trigger OnValidate()
                    begin
                        SourceId := GetSid(SourceUser);
                    end;
                }
                field(tUserNach; TargetUser)
                {
                    ApplicationArea = All;
                    Caption = 'Benutzer nach';
                    ToolTip = 'Kopieren auf Benutzer';

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        User2: Record user;
                    begin
                        User2 := GetUser(TargetUser);
                        UserSelection.Open(User2);
                    end;

                    trigger OnValidate()
                    begin
                        TargetId := GetSid(TargetUser);
                    end;
                }
                field(bRollenKopieren; CopyRoles)
                {
                    ApplicationArea = All;
                    Caption = 'Rollen kopieren';
                    ToolTip = 'Specifies the value of the Rollen kopieren field.';
                }
                field(bRechteKopieren; CopyPermsissions)
                {
                    ApplicationArea = All;
                    Caption = 'Rechte kopieren';
                    ToolTip = 'Specifies the value of the Rechte kopieren field.';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(UserCopy)
            {
                ApplicationArea = All;
                Image = Users;
                Promoted = true;
                PromotedIsBig = true;
                PromotedOnly = true;
                ToolTip = 'Executes the UserCopy action.';

                trigger OnAction()
                begin

                    if not ValidateUserID(SourceUser) then
                        exit;
                    if not ValidateUserID(TargetUser) then
                        exit;

                    if TargetUser = '' then
                        Error('ZielUser darf nicht leer sein');
                    if SourceUser = '' then
                        Error('QuellUser darf nicht leer sein');

                    if CopyPermsissions then
                        CopyPermission();
                    if CopyRoles then
                        CopyRole();
                end;
            }
        }
    }

    var
        User: Record User;
        CodeCollection: Codeunit BASCodeCollectionPHA;
        UserSelection: Codeunit "User Selection";
        CopyPermsissions: Boolean;
        CopyRoles: Boolean;
        SourceUser: Code[50];
        TargetUser: Code[50];
        SourceId: Guid;
        TargetId: Guid;

    local procedure CopyRole()
    begin
        CodeCollection.CopyRole(SourceId, TargetId, SourceUser, TargetUser);
    end;

    local procedure CopyPermission()
    begin
        CodeCollection.CopyPermission(SourceId, TargetId, SourceUser, TargetUser);
    end;

    procedure GetSid(UserID: Text[100]) SID: Guid
    begin
        User.Reset();
        User.SetRange("User Name", UserID);
        if User.FindFirst() then
            SID := User."User Security ID";
    end;

    procedure ValidateUserID(UserID: Text[100]): Boolean
    begin
        User.Reset();
        User.SetRange("User Name", UserID);
        if User.IsEmpty then
            Message('User %1 not found', UserID);

        exit(true);
    end;

    procedure GetUser(UserID: Code[50]): Record User
    begin
        User.Reset();
        User.SetRange("User Name", UserID);
        if User.FindFirst() then
            exit(User);
    end;
}