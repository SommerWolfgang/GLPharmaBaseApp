page 50001 BASCopyUserPHA
{
    ApplicationArea = All;
    PageType = Card;
    UsageCategory = Administration;

    layout
    {
        area(Content)
        {
            group(UserKopieren)
            {
                field(tUserVon; tUserVon)
                {
                    ApplicationArea = All;
                    Caption = 'Benutzer von';
                    ToolTip = 'Kopieren von Benutzer';

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        cuCodesammlung.LookupUser(tUserVon, tSIDVon);
                    end;

                    trigger OnValidate()
                    begin
                        tSIDVon := HoleSID(tUserVon);
                    end;

                }
                field(tUserNach; tUserNach)
                {
                    ApplicationArea = All;
                    Caption = 'Benutzer nach';
                    ToolTip = 'Kopieren auf Benutzer';
                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        cuCodesammlung.LookupUser(tUserNach, tSIDNach);
                    end;

                    trigger OnValidate()
                    begin
                        tSIDNach := HoleSID(tUserNach);
                    end;
                }
                field(bRollenKopieren; bRollenKopieren)
                {
                    ApplicationArea = All;
                    Caption = 'Rollen kopieren';
                }
                field(bRechteKopieren; bRechteKopieren)
                {
                    ApplicationArea = All;
                    Caption = 'Rechte kopieren';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action("Benutzer kopieren")
            {
                ApplicationArea = All;
                Image = Users;
                Promoted = true;
                PromotedIsBig = true;

                trigger OnAction()
                begin

                    if not ValidateUserID(tUserVon) then
                        exit;
                    if not ValidateUserID(tUserNach) then
                        exit;

                    if tUserNach = '' then
                        ERROR('ZielUser darf nicht leer sein');
                    if tUserVon = '' then
                        ERROR('QuellUser darf nicht leer sein');


                    if bRechteKopieren then
                        CopyPermission();


                    if bRollenKopieren then
                        RollenKopieren();



                end;
            }
        }
    }


    //Globale Variablen
    var
        LoginMgt: Codeunit "418";
        cuCodesammlung: Codeunit CodesammlungGLDE;
        bRechteKopieren: Boolean;
        bRollenKopieren: Boolean;
        tUserNach: Code[132];
        tUserVon: Code[132];
        tSIDNach: Guid;
        tSIDVon: Guid;


    procedure HoleSID(UserID: Text[100]) SID: Guid
    var
        //recSIDAccount: Record "2000000055";
        recLogin: Record "2000000120";
    begin

        recLogin.SetRange("User Name", UserID);
        if recLogin.FindFirst() then
            SID := recLogin."User Security ID";
    end;

    procedure ValidateUserID(UserID: Text[100]): Boolean
    var
        User: Record User;
    begin
        User.SetRange("User Name", UserID);
        if User.IsEmpty then
            Message('User %1 not found', UserID);

        exit(true);
    end;

    procedure RollenKopieren()
    var
        UserMetadata: Record "User Metadata";
        UserMetaDataSource: Record "User Metadata";
        UserPersonalization: Record "User Personalization";
        UserPersonalizationSource: Record "User Personalization";
        iAnpassungenCounter: Integer;
    begin
        UserPersonalization.Reset();
        UserPersonalization.SetRange("User SID", tSIDNach);
        if UserPersonalization.FindFirst() then
            UserPersonalization.DELETE();

        //Rolle Kopieren
        UserPersonalizationSource.Reset();
        if UserPersonalizationSource.GET(tSIDVon) then begin
            UserPersonalization.Reset();
            UserPersonalization.INIT();
            UserPersonalization.COPY(UserPersonalizationSource);
            UserPersonalization."User SID" := tSIDNach;
            if not UserPersonalization.INSERT() then
                ERROR('Rolle %1 konnte nicht auf Benutzer %2 kopiert werden', UserPersonalizationSource."Profile ID", tUserNach);
        end else
            Message('Keine Rollen zum kopieren von Benutzer %1 gefunden!', tUserVon);

        UserMetadata.Reset();
        UserMetadata.SetRange("User SID", tSIDNach);
        if UserMetadata.FindFirst() then
            UserMetadata.DELETEALL();

        UserMetaDataSource.Reset();
        UserMetaDataSource.SetRange("User SID", tSIDVon);
        if UserMetaDataSource.FindFirst() then
            repeat
                iAnpassungenCounter += 1;
                UserMetaDataSource.CALCFIELDS("Page Metadata Delta");   //Blob Felder zuerst Berechnen und dann extra kopieren
                UserMetadata.Reset();
                UserMetadata.INIT();
                UserMetadata.COPY(UserMetaDataSource);
                UserMetadata."User SID" := tSIDNach;
                UserMetadata."Page Metadata Delta" := UserMetaDataSource."Page Metadata Delta";
                if not UserMetadata.INSERT() then
                    ERROR('Metadaten von %1 konnte nicht auf %2 kopiert werden', tUserVon, tUserNach);
            until UserMetaDataSource.NEXT() = 0
    end else
            Message('Keine User-Metadaten zum kopieren von Benutzer %1 gefunden!', tUserVon);

        recSeitenanpassungNach.Reset();
        recSeitenanpassungNach.SetRange("User SID", tSIDNach);
        if recSeitenanpassungNach.FindFirst() then
            recSeitenanpassungNach.DELETEALL();

        recSeitenanpassungVon.Reset();
        recSeitenanpassungVon.SetRange("User SID", tSIDVon);
        if recSeitenanpassungVon.FindFirst() then
            repeat
                iAnpassungenCounter += 1;
                recSeitenanpassungVon.CALCFIELDS(Value);
                recSeitenanpassungNach.Reset();
                recSeitenanpassungNach.INIT();
                recSeitenanpassungNach.COPY(recSeitenanpassungVon);
                recSeitenanpassungNach."User SID" := tSIDNach;
                recSeitenanpassungNach.Value := recSeitenanpassungVon.Value;
                if not recSeitenanpassungNach.INSERT() then
                    ERROR('Metadaten von %1 konnte nicht auf %2 kopiert werden', tUserVon, tUserNach);
            until recSeitenanpassungVon.NEXT() = 0
        else
            Message('Keine Seitenanpassungen zum kopieren von Benutzer %1 gefunden!', tUserVon);

        Message('%1 Anzeige-Anpassungen auf %2 kopiert', iAnpassungenCounter, tUserNach);
    end;

    procedure CopyPermission()
    var
        recUserSetupNach: Record "91";
        recUserSetupVon: Record "91";
        recUserGruppenNach: Record "9001";
        recUserGruppenVon: Record "9001";
        recAccessControlNach: Record "2000000053";
        recAccessControlVon: Record "2000000053";
        recUserNach: Record "2000000120";
        recUserVon: Record "2000000120";
        User_Sec_ID_Nach: Guid;
        User_Sec_ID_Von: Guid;
        iRechteAnzahl: Integer;
    begin
        iRechteAnzahl := 0;

        //Benutzersicherheitskennung ("User Security ID") aus der User Tabelle holen (Anlage des Benutzers nmus manuell gemacht werden)
        recUserNach.Reset();
        recUserNach.SetRange("User Security ID", tSIDNach);
        if not recUserNach.FindFirst() then
            ERROR('Ziel-User %1 wurde nicht gefunden', tUserNach);

        recUserVon.Reset();
        recUserVon.SetRange("User Security ID", tSIDVon);
        if not recUserVon.FindFirst() then
            ERROR('Ausgangs-User %1 wurde nicht gefunden', tUserVon);


        //Mögliche vorhandene Einträge löschen
        //Benutzer einrichtung löschen
        recUserSetupNach.Reset();
        recUserSetupNach.SetRange("User ID", tUserNach);
        if recUserSetupNach.FindFirst() then
            recUserSetupNach.DELETE();

        //Einzelrechte löschen
        recAccessControlNach.Reset();
        recAccessControlNach.SetRange("User Security ID", tSIDNach);
        if recAccessControlNach.FindFirst() then
            recAccessControlNach.DELETEALL(true);

        //Berechtigungsgruppen löschen
        recUserGruppenNach.Reset();
        recUserGruppenNach.SetRange("User Security ID", tSIDNach);
        if recUserGruppenNach.FindFirst() then
            recUserGruppenNach.DELETEALL(true);




        //Einträge Kopieren
        recUserSetupNach.Reset();
        recUserSetupVon.SetRange("User ID", tUserVon);
        if recUserSetupVon.FindFirst() then begin
            recUserSetupNach.Reset();
            recUserSetupNach.INIT();
            recUserSetupNach.COPY(recUserSetupVon);
            recUserSetupNach."User ID" := tUserNach;
            //Gewisse Felder nicht kopieren, sondern leer setzen
            recUserSetupNach."Salespers./Purch. Code" := '';
            recUserSetupNach."E-Mail" := '';
            if not recUserSetupNach.INSERT() then
                ERROR('Benutzereinrichtung konnte nicht auf Benutzer %1 kopiert werden', tUserNach);
        end else begin
            Message('Keine Benutzereinrichtung zu Benutzer %1 gefunden!', tUserVon);
        end;


        //Berechtigungsgruppen kopieren
        recUserGruppenNach.Reset();
        recUserGruppenVon.SetRange("User Security ID", tSIDVon);
        if recUserGruppenVon.FindFirst() then begin
            repeat
                recUserGruppenNach.Reset();
                recUserGruppenNach.Reset();
                recUserGruppenNach.COPY(recUserGruppenVon);
                recUserGruppenNach."User Security ID" := tSIDNach;
                if not recUserGruppenNach.INSERT(true) then        //Einzelrechte gleich anlegen -> Zusätzliche EInzelrechte im nächsten Schritt
                    ERROR('Zugriffsrechtegruppe konnte nicht auf Benutzer %1 kopiert werden', tUserNach);
            until recUserGruppenVon.NEXT() = 0;
        end;


        recAccessControlNach.Reset();
        recAccessControlVon.SetRange("User Security ID", tSIDVon);
        if recAccessControlVon.FindFirst() then
            repeat
                recAccessControlNach.SetRange("User Security ID", tSIDNach);
                recAccessControlNach.SetRange("Role ID", recAccessControlVon."Role ID");
                if not recAccessControlNach.FindFirst() then begin
                    //Einzelrecht nicht durch Rechtegruppe vorhanden
                    recAccessControlNach.Reset();
                    recAccessControlNach.INIT();
                    recAccessControlNach.COPY(recAccessControlVon);
                    recAccessControlNach."User Security ID" := tSIDNach;
                    iRechteAnzahl += 1;
                    if not recAccessControlNach.INSERT() then
                        ERROR('Zugriffsrechte konnte nicht auf Benutzer %1 kopiert werden', tUserNach);

                end;
            until recAccessControlVon.NEXT() = 0;
    end else
            Message('Keine Zugriffsrechte zu Benutzer %1 gefunden!', tUserVon);

        Message('%1 DB-Rechte auf %2 kopiert', iRechteAnzahl, tUserNach);
    end;
}