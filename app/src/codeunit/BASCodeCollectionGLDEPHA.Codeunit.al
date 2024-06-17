codeunit 50004 BASCodeCollectionGLDEPHA
{
    procedure StatusInventory(ItemNo: Code[20]; LotStatus: code[20]; LocationCode: Code[20]): Decimal
    var
        Item: Record Item;
        ItemLedgerEntry: Record "Item Ledger Entry";
        LotNoInformation: Record "Lot No. Information";
        Inventory: Decimal;
    begin
        if Item.Get(ItemNo) then
            if Item."Item Tracking Code" <> '' then begin
                ItemLedgerEntry.SetCurrentKey("Item No.", "Variant Code", "Open", "Positive", "Location Code", "Expiration Date", "Lot No.");
                ItemLedgerEntry.SetRange("Item No.", ItemNo);
                ItemLedgerEntry.SetRange("Open", true);
                if LocationCode <> '' then
                    ItemLedgerEntry.SetRange("Location Code", LocationCode);
                if ItemLedgerEntry.FindSet(false) then
                    repeat
                        if LotNoInformation.Get(ItemLedgerEntry."Item No.", '', ItemLedgerEntry."Lot No.") then
                            if Format(LotNoInformation.BASStatusPHA) = LotStatus then
                                Inventory := Inventory + ItemLedgerEntry."Remaining Quantity";
                    until ItemLedgerEntry.Next() = 0;
            end else begin
                Item.CalcFields(Inventory);
                Inventory := Item.Inventory;
            end;
        exit(Inventory);
    end;

    procedure ReplaceText(BCText: Text[250]; tTextReplace: Text; tReplaceTo: Text): text
    begin
        exit(BCText.Replace(tTextReplace, tReplaceTo));
    end;

    procedure LookupUser(var UserName: Code[50]; var SID: Guid): Boolean
    var
        User: Record User;
    begin
        User.Reset();
        User.SetCurrentKey("User Name");
        User."User Name" := UserName;
        if User.Find('=><') then;
        if Page.RunModal(PAGE::Users, User) = Action::LookupOK then begin
            UserName := User."User Name";
            SID := User."User Security ID";
            exit(true);
        end;

        exit(false);
    end;

    procedure IsTestEnvironment(): boolean
    var
        ActiveSession: Record "Active Session";
        GLSetup: Record "General Ledger Setup";
    begin
        GLSetup.Get();

        ActiveSession.SetRange("Server Instance ID", ServiceInstanceId());
        ActiveSession.SetRange("Session ID", SessionId());
        ActiveSession.FindFirst();
        exit(UpperCase(ActiveSession."Database Name") <> GLSetup.BASProductionDatabasePHA);
    end;

    procedure Permission(Action: Code[20]) ok: Boolean
    var
        AccessControl: Record "Access Control";
        User: Record User;
        UserSecurityID: Guid;
        CompanyCheckLbl: Label '$MANDANTENCHECK', Locked = true;
    begin
        User.SetCurrentKey("User Name");
        User.SetRange("User Name", UserID);
        User.FindFirst();
        UserSecurityID := User."User Security ID";

        AccessControl.SetRange("User Security ID", UserSecurityID);
        AccessControl.SetRange("Role ID", Action);
        ok := AccessControl.FindFirst();

        if Action = CompanyCheckLbl then begin
            ok := Permission('$' + UpperCase(CompanyName));
            exit(ok);
        end;

        if not ok then begin
            AccessControl.SetRange("Role ID", 'SUPER');
            exit(not AccessControl.IsEmpty);
        end;
    end;

    procedure Division(Numerator: Decimal; Denominator: Decimal): Decimal
    begin
        if Denominator <> 0 then
            exit(Numerator / Denominator);
    end;

    procedure BelivableExpiredDate(ItemNo: Text[20]; ExpiredDate: Date): boolean
    var
        Item: Record Item;
        DummyDate: Date;
        DummyDateToday: Date;
        ExpiredDateMustBeInFuture2Msg: Label '', comment = 'DEA="Gemäß der Ablaufdatumsformel würde das Herstelldatum in der Zukunft liegen! Das kann nicht sein.\Das Datum wird zurückgesetzt.';
        ExpiredDateMustBeInFutureMsg: Label 'Expired Date must be in future!\Date will be restored', comment = 'DEA="Das Ablaufdatum muss in der Zukunft liegen!\Das Datum wird zurückgesetzt."';
    begin
        if ExpiredDate = 0D then
            exit(true);

        if ExpiredDate <= Today then begin
            Message(ExpiredDateMustBeInFutureMsg);
            exit(false);
        end;

        if not Item.Get(ItemNo) then
            exit(false);

        if Format(Item."Expiration Calculation") <> '' then begin
            DummyDate := CalcDate('<-' + Format(Item."Expiration Calculation") + '>', ExpiredDate);
            DummyDateToday := CalcDate('<CM>', ToDay);
            if DummyDate > DummyDateToday then begin
                Message(ExpiredDateMustBeInFuture2Msg);
                exit(false);
            end;
        end;

        exit(true);
    end;
}