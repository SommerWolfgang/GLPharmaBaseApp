table 50105 BASDropDownContentPHA
{
    Permissions =
        tabledata BASDropDownContentPHA = R,
        tabledata BASDropDownContentParameterPHA = R;

    fields
    {
        field(1; Tabelle; Integer)
        {
        }
        field(2; Feld; Code[20])
        {
        }
        field(3; ID; Code[20])
        {
        }
        field(4; Inhalt; Text[250])
        {
        }
        field(5; "Standort Zuordnung"; Code[20])
        {
        }
    }

    keys
    {
        key(Key1; Tabelle, Feld, ID, "Standort Zuordnung")
        {
        }
        key(Key2; ID, Inhalt)
        {
        }
        key(Key3; Tabelle, Feld, ID, Inhalt)
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; ID, Inhalt)
        {
        }
        fieldgroup(Whatsapp; Tabelle, Feld, ID, "Standort Zuordnung", Inhalt)
        {
        }
    }

    trigger OnDelete()
    begin
        DropDownContentParameter.SetFilter(Table, '%1', Tabelle);
        DropDownContentParameter.SetFilter(Field, Feld);
        DropDownContentParameter.SetFilter(ID, ID);
        if DropDownContentParameter.FIND('-') then begin
            if not DropDownContentParameter.Allow_Delete then
                Error('Für Tabelle=''%1'', Feld=''%2'', ID=''%3'' darf keine Löschung erfolgen!', Tabelle, Feld, ID);
            exit
        end;

        DropDownContentParameter.SetFilter(ID, '%1', '');
        if DropDownContentParameter.FIND('-') then begin
            if not DropDownContentParameter.Allow_Delete then
                Error('Für Tabelle=''%1'', Feld=''%2'' darf keine Löschung erfolgen!', Tabelle, Feld);
            exit;
        end;

        DropDownContentParameter.SetFilter(Field, '%1', '');
        if DropDownContentParameter.FIND('-') then begin
            if not DropDownContentParameter.Allow_Delete then
                Error('Für Tabelle=''%1'' darf keine Löschung erfolgen!', Tabelle);
            exit;
        end;
    end;

    trigger OnInsert()
    begin

        DropDownContentParameter.SetFilter(Table, '%1', Tabelle);
        DropDownContentParameter.SetFilter(Field, Feld);
        DropDownContentParameter.SetFilter(ID, ID);
        //-GL001
        DropDownContentParameter.SetFilter("Standort Zuordnung", "Standort Zuordnung");
        //+GL001
        if DropDownContentParameter.FIND('-') then begin
            if not DropDownContentParameter.Allow_New then
                Error('Für Tabelle=''%1'', Feld=''%2'', ID=''%3'' darf kein Eintrag erstellt werden!', Tabelle, Feld, ID);
            exit
        end;

        DropDownContentParameter.SetFilter(ID, '%1', '');
        if DropDownContentParameter.FIND('-') then begin
            if not DropDownContentParameter.Allow_New then
                Error('Für Tabelle=''%1'', Feld=''%2'' darf kein Eintrag erstellt werden!', Tabelle, Feld);
            exit;
        end;

        DropDownContentParameter.SetFilter(Field, '%1', '');
        if DropDownContentParameter.FIND('-') then begin
            if not DropDownContentParameter.Allow_New then
                Error('Für Tabelle=''%1'' darf kein neuer Eintrag erstellt werden!', Tabelle);
            exit;
        end;

        //-GL001
        //"Standort Zuordnung" := cuNaviPharma.StandortWeiche('SCHULUNG_USER', USERID);
        //+GL001
    end;

    trigger OnModify()
    begin
        DropDownContentParameter.SetFilter(Table, '%1', Tabelle);
        DropDownContentParameter.SetFilter(Field, Feld);
        DropDownContentParameter.SetFilter(ID, ID);
        if DropDownContentParameter.FIND('-') then begin
            if ((xRec.Tabelle = Rec.Tabelle) and (xRec.Feld = Rec.Feld) and (xRec.ID = Rec.ID)) then
                if DropDownContentParameter.Allow_Description then
                    exit
                else
                    Error('Für Tabelle=''%1'', Feld=''%2'', ID=''%3'' darf die Beschreibung nicht verändert werden!', Tabelle, Feld, ID);


            if not DropDownContentParameter.Allow_Modify then
                Error('Für Tabelle=''%1'', Feld=''%2'', ID=''%3'' darf keine Änderung erfolgen!', Tabelle, Feld, ID);
            exit;
        end;

        DropDownContentParameter.SetFilter(ID, '%1', '');
        if DropDownContentParameter.FIND('-') then begin
            if not DropDownContentParameter.Allow_Modify then
                Error('Für Tabelle=''%1'', Feld=''%2'' darf keine Änderung erfolgen!', Tabelle, Feld);
            exit;
        end;

        DropDownContentParameter.SetFilter(Field, '%1', '');
        if DropDownContentParameter.FIND('-') then begin
            if not DropDownContentParameter.Allow_Modify then
                Error('Für Tabelle=''%1'' darf keine Änderung erfolgen!', Tabelle);
            exit;
        end;
    end;

    trigger OnRename()
    begin
        DropDownContentParameter.SetFilter(Table, '%1', Tabelle);
        DropDownContentParameter.SetFilter(Field, Feld);
        DropDownContentParameter.SetFilter(ID, ID);
        if DropDownContentParameter.FIND('-') then begin
            if ((xRec.Tabelle = Rec.Tabelle) and (xRec.Feld = Rec.Feld) and (xRec.ID = Rec.ID)) then
                if DropDownContentParameter.Allow_Description then
                    exit
                else
                    Error('Für Tabelle=''%1'', Feld=''%2'', ID=''%3'' darf die Beschreibung nicht verändert werden!', Tabelle, Feld, ID);


            if not DropDownContentParameter.Allow_Modify then
                Error('Für Tabelle=''%1'', Feld=''%2'', ID=''%3'' darf keine Änderung erfolgen!', Tabelle, Feld, ID);
            exit
        end;

        DropDownContentParameter.SetFilter(ID, '%1', '');
        if DropDownContentParameter.FIND('-') then begin
            if not DropDownContentParameter.Allow_Modify then
                Error('Für Tabelle=''%1'', Feld=''%2'' darf keine Änderung erfolgen!', Tabelle, Feld);
            exit;
        end;

        DropDownContentParameter.SetFilter(Field, '%1', '');
        if DropDownContentParameter.FIND('-') then begin
            if not DropDownContentParameter.Allow_Modify then
                Error('Für Tabelle=''%1'' darf keine Änderung erfolgen!', Tabelle);
            exit;
        end;

        //-GL002  //Von leerer ID auf einen Wert abändern nicht zulassen, Werte in Tabellen werden sonst gesetzt
        if (StrLen(xRec.ID) = 0) and (StrLen(Rec.ID) > 0) then
            Error('Ein leerer ID Wert darf nicht geändert werden!');
        //+GL002
    end;

    var
        DropDownContentParameter: Record 50106;

}

