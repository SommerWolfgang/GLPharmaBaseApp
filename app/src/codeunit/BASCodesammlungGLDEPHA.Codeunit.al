codeunit 50004 BASCodesammlungGLDEPHA
{
    procedure StatusInventory(itemNo: Code[20]; LotStatus: code[20]; LocationCode: Code[20]): Decimal
    var
        Item: Record Item;
        ItemLedgerEntry: Record "Item Ledger Entry";
        LotNoInformation: Record "Lot No. Information";
        Inventory: Decimal;
    begin
        if Item.Get(itemNo) then
            if Item."Item Tracking Code" <> '' then begin
                ItemLedgerEntry.SetCurrentKey("Item No.", "Variant Code", "Open", "Positive", "Location Code", "Expiration Date", "Lot No.");
                ItemLedgerEntry.SetRange("Item No.", itemNo);
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
        if User.FIND('=><') then;
        if PAGE.RUNMODAL(PAGE::Users, User) = ACTION::LookupOK then begin
            UserName := User."User Name";
            SID := User."User Security ID";
            exit(TRUE);
        end;

        exit(FALSE);
    end;
    // >> TASK47.01


    procedure IsTestEnvironment(): boolean
    var
        ActiveSession: Record "Active Session";
        bResult: Boolean;
        cDatabasename: Text[100];
    begin
        bResult := FALSE;
        ActiveSession.SetRange("Server Instance ID", SERVICEINSTANCEID());
        ActiveSession.SetRange("Session ID", SESSIONID());
        ActiveSession.FINDFIRST();
        cDatabasename := ActiveSession."Database Name";

        IF (UPPERCASE(cDatabasename) <> 'BC_ECHT') THEN
            bResult := true;

        EXIT(bResult);

    end;


    procedure Berechtigung(Aktion: Code[20]): boolean
    var
        recAccessControl: Record "Access Control";
        recUser: Record User;
        ok: Boolean;
        UserSecurityID: Guid;
    begin

        ok := false;

        recUser.SetCurrentKey("User Name");
        recUser.SetRange("User Name", USERID);
        recUser.FINDFIRST();
        UserSecurityID := recUser."User Security ID";

        recAccessControl.SetRange("User Security ID", UserSecurityID);
        recAccessControl.SetRange("Role ID", Aktion);
        IF recAccessControl.FINDFIRST() THEN
            ok := true;

        IF Aktion = '$MANDANTENCHECK' THEN BEGIN
            ok := Berechtigung('$' + UPPERCASE(COMPANYNAME)); //rekursiver Funktionsaufruf
            EXIT(ok);
        END;

        IF NOT ok THEN BEGIN  //bei Rolle Super alle Berechtigung für
            recAccessControl.SetRange("Role ID", 'SUPER');
            IF recAccessControl.FINDFIRST() THEN
                EXIT(true);
        END;

        EXIT(ok);

    end;


    procedure AblaufDatumPlausibel(sArtikelnummer: Text[20]; dtDate: Date): boolean
    var
        recItem: Record Item;
        bResult: Boolean;
        dtHelp: Date;
        dtHelpToday: Date;
    begin

        bResult := FALSE;
        IF dtDate = 0D THEN EXIT(TRUE);
        IF dtDate <= TODAY THEN BEGIN
            Message('Das Ablaufdatum muss in der Zukunft liegen!\Das Datum wird zurückgesetzt.');
            EXIT;
        END;
        IF NOT recItem.GET(sArtikelnummer) THEN EXIT;
        IF (FORMAT(recItem."Expiration Calculation") <> '') THEN BEGIN

            dtHelp := CALCDATE('<-' + FORMAT(recItem."Expiration Calculation") + '>', dtDate);
            dtHelpToday := CALCDATE('+LM', TODAY); //Auf Monatsletzten setzen

            IF (dtHelp > dtHelpToday) THEN BEGIN
                Message('Gemäß der Ablaufdatumsformel würde das Herstelldatum in der Zukunft liegen! Das kann nicht sein.\' +
                'Das Datum wird zurückgesetzt.');
                EXIT;
            END;
        END;
        bResult := TRUE;
    end;

}
