codeunit 50001 BASNaviPharmaPHA
{
    trigger OnRun()
    begin
    end;

    procedure CheckArtikelBewegung(ItemJnlLine: Record "Item Journal Line") ok: Boolean
    var
        Item: Record Item;
        Chargenstamm: Record "Lot No. Information";
        lOK: Boolean;
    begin
        exit(true); // >> 02.07.2021 PBA
        lOK := false;

        with ItemJnlLine do begin
            if "Entry Type" <> "Entry Type"::Transfer then
                if Item.GET("Item No.") then
                    if not Item."Inventory Value Zero" then
                        if "Shortcut Dimension 1 Code" = '' then
                            Error('Kostenstelle fehlt bei Artikelnummer %1, Buchblattzeilennummer %2, Belegzeilennummer %3', "Item No.",
                                    "Line No.", "Document Line No.");

            //Schränke zulässiges Buchungsdatum ein
            CheckArtikelBuchDatGrenze("Posting Date");

            //Prüfung: keine Chargennr. bei nichtchargenpflicht. Artikeln erlaubt
            if "Lot No." <> '' then
                if Item.GET("Item No.") then
                    if Item."Item Tracking Code" = '' then
                        Error('Artikel ' + "Item No." + ': Chargennr. eingegeben, aber Artikel nicht chargenpflichtig ' +
                                 '(Feld Artikelverfolgungscode in Artikelkarte leer)');

            if Quantity = 0 then  //Wenn nur Rechnungsmenge ohne Liefervorgang: keine Artikelbewegung, also keine Ch.Prüfungen
                exit(true);

            if Item.GET("Item No.") then  //bei nicht chargenpflichtigen Artikeln ab hier Aussprung
                if Item."Item Tracking Code" = '' then
                    exit(true);

            //Prüfung auf Freigabe bei Umlagerung ins VKL/KONL/LOHN
            if "New Location Code" in ['VKL', 'KONL', 'LOHN', 'SVKL'] then begin      //-GL033
                if Chargenstamm.GET("Item No.", '', "Lot No.") = false then
                    Error('Artikel ' + "Item No." + ', Ch.Nr.' + "Lot No." + ': kein Eintrag in Chargenstammm, Umlagerung in '
                           + 'VKL/KONL/LOHN/SVKL unzulässig!')
                else begin
                    if Chargenstamm.Status <> Chargenstamm.Status::Frei then
                        Error('Artikel ' + "Item No." + ', Ch.Nr.' + "Lot No." + ' ist nicht freigegeben, Umlagerung in VKL/KONL/LOHN/SVKL unzulässig!');
                    if Chargenstamm."Expiration Date" = 0D then
                        Error('Artikel ' + "Item No." + ', Ch.Nr.' + "Lot No." +
                              ' kein Ablaufdatum eingetragen, Umlagerung in VKL/KONL/LOHN unzulässig!');
                    if Chargenstamm."Expiration Date" <= (WORKDATE) then
                        Error('Artikel ' + "Item No." + ', Ch.Nr.' + "Lot No." + ' ist abgelaufen, Umlagerung in VKL/KONL/LOHN/SVKL unzulässig!');

                end;
            end;

            //Umlagerung in PL bei Artikelart=Halbfabrikat+Fertigware von Quarantäneware erlaubt
            if "New Location Code" in ['PL'] then begin
                if Chargenstamm.GET("Item No.", '', "Lot No.") = false then
                    Error('Artikel ' + "Item No." + ', Ch.Nr.' + "Lot No." + ': kein Eintrag in Chargenstammm, Umlagerung in '
                           + 'PL unzulässig!')
                else begin
                    if ((Item.Artikelart = Item.Artikelart::Halbfabrikat) or (Item.Artikelart = Item.Artikelart::Fertigprodukt)) then begin
                        if Chargenstamm.Status = Chargenstamm.Status::Gesperrt then
                            Error('Artikel ' + "Item No." + ', Ch.Nr.' + "Lot No." + ' ist gesperrt, Umlagerung in PL unzulässig!');
                    end else begin  // Sperren für alles außer Bulk+FW
                        if Chargenstamm.Status <> Chargenstamm.Status::Frei then
                            Error('Artikel ' + "Item No." + ', Ch.Nr.' + "Lot No." + ' ist nicht freigegeben, Umlagerung in PL unzulässig!');
                        if Chargenstamm."Expiration Date" = 0D then
                            Error('Artikel ' + "Item No." + ', Ch.Nr.' + "Lot No." +
                               ' kein Ablaufdatum eingetragen, Umlagerung in PL unzulässig!');
                        if Chargenstamm."Expiration Date" <= (WORKDATE) then
                            Error('Artikel ' + "Item No." + ', Ch.Nr.' + "Lot No." + ' ist abgelaufen, Umlagerung in PL unzulässig!');
                    end;
                end;
            end;


            //Prüfung auf Freigabe Verkauf von chargenpflichtigen Artikeln
            if ("Entry Type" = "Entry Type"::Sale) and (Quantity > 0) then begin  //Gutschriften nicht prüfen!AND (Menge > 0)
                if Chargenstamm.GET("Item No.", '', "Lot No.") = false then
                    Error('Artikel ' + "Item No." + ', Ch.Nr.' + "Lot No." + ': kein Chargeneintrag vorhanden!')
                else begin
                    //Prüfungen auf abgelaufene Ware
                    if Chargenstamm.Status <> Chargenstamm.Status::Frei then //Freigabedatum = 0D THEN
                        Error('Artikel ' + "Item No." + ', Ch.Nr.' + "Lot No." + ' ist noch nicht freigegeben, kein Verkauf möglich');
                    if "Location Code" = 'KONL' then begin
                        if Chargenstamm."Expiration Date" <= (WORKDATE) then
                            if CONFIRM('Artikel ' + "Item No." + ', Ch.Nr.' + "Lot No." + ' ist am ' + FORMAT(Chargenstamm."Expiration Date")
                                     + ' abgelaufen!, Rechnungsposition trotzdem fakturieren?') = false then
                                Error('Auftrag abgebrochen');
                    end else begin //alle anderen Lagerorte
                        if Chargenstamm."Expiration Date" <= (WORKDATE - 14) then
                            Error('Artikel ' + "Item No." + ', Ch.Nr.' + "Lot No." + ' ist abgelaufen, kein Verkauf möglich');
                        if Chargenstamm."Expiration Date" <= CalcDate('<CM-9M>', WORKDATE) then
                            if CONFIRM('Artikel ' + "Item No." + ', Ch.Nr.' + "Lot No." + ' läuft in weniger als 9 '
                                 + 'Monaten ab, trotzdem verkaufen ?') = false then
                                Error('Auftrag abgebrochen');
                    end;
                end;
            end;

            //Prüfung auf gleiche Verkaufschargennr., wenn plus-Mengenbuchung
            if Chargenstamm.GET("Item No.", "Variant Code", "Lot No.") then begin
                if (("Entry Type" in ["Entry Type"::Sale, "Entry Type"::Consumption, "Entry Type"::"Negative Adjmt."]) and (Quantity < 0))
                  or (("Entry Type" in ["Entry Type"::Purchase, "Entry Type"::Output, "Entry Type"::"Positive Adjmt."]) and (Quantity > 0))
                  or ("Entry Type" = "Entry Type"::Transfer)
                then begin
                    if Chargenstamm."Verkaufschargennr." <> "Verkaufschargennr." then
                        Error('Die Verkaufschargennr. %1 stimmt nicht mit dem Chargenstammeintrag %2 überein; ' +
                           '(Änderung ist nur mehr im Chargenstamm (Artikelnr. %3, Chargennr. %4) möglich) ',
                          "Verkaufschargennr.", Chargenstamm."Verkaufschargennr.", "Item No.", "Lot No.");
                    //IF StandortWeiche("Item No.",'ITEM')='LANNACH' THEN BEGIN
                    if Chargenstamm."Expiration Date" <> "Expiration Date" then
                        Error('Das Ablaufdatum %1 stimmt nicht mit dem Chargenstammeintrag %2 überein; ' +
                        '(Änderung ist nur mehr im Chargenstamm (Artikelnr. %3, Chargennr. %4) möglich) ',
                       "Expiration Date", Chargenstamm."Expiration Date", "Item No.", "Lot No.");
                    //END ELSE IF StandortWeiche("Item No.",'ITEM')='WIEN' THEN BEGIN
                    //  IF ("Expiration Date" <> 0D) AND (Chargenstamm."Expiration Date" <> "Expiration Date") THEN
                    //    Error('Das Ablaufdatum %1 stimmt nicht mit dem Chargenstammeintrag %2 überein; ' +
                    //     '(Änderung ist nur mehr im Chargenstamm (Artikelnr. %3, Chargennr. %4) möglich) ',
                    //    "Expiration Date",Chargenstamm."Expiration Date","Item No.","Lot No.");
                    //END;

                end;
            end;

            exit(lOK);
        end;
    end;

    procedure CheckArtikelBuchDatGrenze(BuchDatum: Date)
    var
        GLSetup: Record "General Ledger Setup";
        dBeginn: Date;
    begin
        //Anmerkung: in Nav. 2009 gäbe es eigene Artikelbuchungsperioden...
        GLSetup.Get();
        if GLSetup.ArtikelBuchDatGrenze then begin
            if (Date2DMY(WORKDATE(), 2) - 1) = 0 then
                dBeginn := DMY2Date(1, 12, Date2DMY(WORKDATE(), 3) - 1)
            else
                dBeginn := DMY2Date(1, Date2DMY(WORKDATE(), 2) - 1, Date2DMY(WORKDATE(), 3));
            if ((BuchDatum < dBeginn) or (BuchDatum >= WORKDATE() + 15)) then
                Error('Buchungsdatum %1 liegt ausserhalb des zulässigen Bereichs von 1. des Vormonats bzw. +15 Tagen', BuchDatum);
        end;
    end;


    procedure Ablaufdatum(artikelnummer: Code[20]; chargennummer: Code[20]; startdatum: Date) ablaufdatum: Date
    var
        Item: Record Item;
        ManufacturingSetup: Record "Manufacturing Setup";
        dHilf: Date;
        nJahr: Integer;
        nMonat: Integer;
        cHilf: Text[30];
    begin
        ManufacturingSetup.Get();

        if ManufacturingSetup.Chargennummernsystem = ManufacturingSetup.Chargennummernsystem::Lannacher then begin
            if Item.GET(artikelnummer) then begin
                if (COPYSTR(chargennummer, 1, 4) > '2200') or (COPYSTR(chargennummer, 1, 4) < '1999') or
                    (COPYSTR(chargennummer, 5, 1) < 'A') or (COPYSTR(chargennummer, 5, 1) > 'M') then begin //keine gültige Ch.nr, nimm startdatum
                    if startdatum = 0D then
                        MESSAGE('weder erkennbare Chargennummer, noch Startdatum vorhanden!')
                    else begin
                        //dHilf := CalcDate('+1M-1T',startdatum); //Monatsletzten bestimmen
                        dHilf := DMY2Date(1, Date2DMY(startdatum, 2), Date2DMY(startdatum, 3)); //Monatsersten errechnen MFU
                        dHilf := CalcDate('<-1D>', dHilf); //Damit es gleich ist wie das Datum von den Chargennummern kommend MFU
                        dHilf := CalcDate('<-1M>', dHilf); //Damit es gleich ist wie von den Chargennummern kommend MFU
                    end;
                end else begin //errechnen aus gültiger Ch.nr
                    cHilf := COPYSTR(chargennummer, 5, 1);
                    case cHilf of
                        'A':
                            nMonat := 1;
                        'B':
                            nMonat := 2;
                        'C':
                            nMonat := 3;
                        'D':
                            nMonat := 4;
                        'E':
                            nMonat := 5;
                        'F':
                            nMonat := 6;
                        'G':
                            nMonat := 7;
                        'H':
                            nMonat := 8;
                        'J':
                            nMonat := 9;
                        'K':
                            nMonat := 10;
                        'L':
                            nMonat := 11;
                        'M':
                            nMonat := 12;
                    end;
                    EVALUATE(nJahr, COPYSTR(chargennummer, 1, 4));
                    dHilf := DMY2Date(1, nMonat, nJahr);
                    dHilf := CalcDate('<-1D>', dHilf); //Monatsletzten bestimmen
                    dHilf := CalcDate('<-1M>', dHilf);
                end;

                if dHilf <> 0D then begin
                    if FORMAT(Item."Expiration Calculation") <> '' then begin
                        ablaufdatum := CalcDate('<+' + FORMAT(Item."Expiration Calculation") + '>', dHilf);
                        //IF CalcDate('+24M',dHilf) >= ablaufdatum THEN  //016 MFU
                        ablaufdatum := CalcDate('<+1M>', ablaufdatum); //Artikel unter 24 Monate Laufzeit bis letzten des lauf. Monats
                        ablaufdatum := DMY2Date(1, Date2DMY(ablaufdatum, 2), Date2DMY(ablaufdatum, 3)); //Monatsletzten errechnen
                        ablaufdatum := CalcDate('<+2M>', ablaufdatum); //Monatsletzten errechnen
                        ablaufdatum := CalcDate('<-1D>', ablaufdatum); //Monatsletzten errechnen
                    end else
                        MESSAGE('Keine Haltbarkeitsformel in der Artikelkarte hinterlegt!');
                end;
            end;
        end;
    end;


    procedure AblaufdatumFremd(artikelnummer: Code[20]; chargennummer: Code[20]; startdatum: Date) ablaufdatum: Date
    var
        artikel: Record Item;
        ManufacturingSetup: Record "Manufacturing Setup";
        dHilf: Date;
        nHilf: Integer;
        nJahr: Integer;
        nMonat: Integer;
        cHilf: Text[30];
    begin
        ManufacturingSetup.GET;
        if ManufacturingSetup.Chargennummernsystem = ManufacturingSetup.Chargennummernsystem::Lannacher then begin
            if artikel.GET(artikelnummer) then begin
                if (COPYSTR(chargennummer, 1, 4) > '2200') or (COPYSTR(chargennummer, 1, 4) < '1999') or
                    (COPYSTR(chargennummer, 5, 1) < 'A') or (COPYSTR(chargennummer, 5, 1) > 'M') then begin //keine gültige Ch.nr, nimm startdatum
                    if startdatum = 0D then
                        MESSAGE('weder erkennbare Chargennummer, noch Startdatum vorhanden!')
                    else begin
                        //dHilf := CalcDate('+1M-1T',startdatum); //Monatsletzten bestimmen
                        dHilf := DMY2Date(1, Date2DMY(startdatum, 2), Date2DMY(startdatum, 3)); //Monatsersten errechnen MFU
                        dHilf := CalcDate('<-1D>', dHilf); //Damit es gleich ist wie das Datum von den Chargennummern kommend MFU
                        dHilf := CalcDate('<-1M>', dHilf); //Damit es gleich ist wie von den Chargennummern kommend MFU
                    end;
                end else begin //errechnen aus gültiger Ch.nr
                    cHilf := COPYSTR(chargennummer, 5, 1);
                    case cHilf of
                        'A':
                            nMonat := 1;
                        'B':
                            nMonat := 2;
                        'C':
                            nMonat := 3;
                        'D':
                            nMonat := 4;
                        'E':
                            nMonat := 5;
                        'F':
                            nMonat := 6;
                        'G':
                            nMonat := 7;
                        'H':
                            nMonat := 8;
                        'J':
                            nMonat := 9;
                        'K':
                            nMonat := 10;
                        'L':
                            nMonat := 11;
                        'M':
                            nMonat := 12;
                    end;
                    EVALUATE(nJahr, COPYSTR(chargennummer, 1, 4));
                    dHilf := DMY2Date(1, nMonat, nJahr);
                    dHilf := CalcDate('<-1D>', dHilf); //Monatsletzten bestimmen
                    dHilf := CalcDate('<-1M>', dHilf);
                end;

                if dHilf <> 0D then begin
                    if FORMAT(artikel."Expiration Calculation") <> '' then begin
                        ablaufdatum := CalcDate('<+' + FORMAT(artikel."Expiration Calculation") + '>', dHilf);
                        //IF CalcDate('+24M',dHilf) >= ablaufdatum THEN  diese zeile nicht bei gerotschen artikeln
                        ablaufdatum := CalcDate('<+1M>', ablaufdatum); //Artikel unter 24 Monate Laufzeit bis letzten des lauf. Monats
                        ablaufdatum := DMY2Date(1, Date2DMY(ablaufdatum, 2), Date2DMY(ablaufdatum, 3)); //Monatsletzten errechnen
                        ablaufdatum := CalcDate('<+2M>', ablaufdatum); //Monatsletzten errechnen
                        ablaufdatum := CalcDate('<-1D>', ablaufdatum); //Monatsletzten errechnen
                    end else
                        MESSAGE('Keine Haltbarkeitsformel in der Artikelkarte hinterlegt!');
                end;
            end;
        end;
    end;

    procedure AblaufDatumPlausibel(sArtikelnummer: Text[20]; dtDate: Date) bResult: Boolean
    var
        recItem: Record Item;
        dtHelp: Date;
        dtHelpToday: Date;
    begin

        bResult := false;
        if dtDate = 0D then exit(true);
        if dtDate <= TODAY then begin
            MESSAGE('Das Ablaufdatum muss in der Zukunft liegen!\Das Datum wird zurückgesetzt.');
            exit;
        end;
        if not recItem.GET(sArtikelnummer) then exit;
        if (FORMAT(recItem."Expiration Calculation") <> '') then begin
            //-GL021
            //Neu:
            dtHelp := CalcDate('<-' + FORMAT(recItem."Expiration Calculation") + '>', dtDate);
            dtHelpToday := CalcDate('+LM', TODAY); //Auf Monatsletzten setzen
                                                   //ORG:  IF (CalcDate('<-' + FORMAT(recItem."Expiration Calculation")+'>', dtDate) > TODAY) THEN
                                                   //+GL021
            if (dtHelp > dtHelpToday) then begin
                MESSAGE('Gemäß der Ablaufdatumsformel würde das Herstelldatum in der Zukunft liegen! Das kann nicht sein.\' +
                  'Das Datum wird zurückgesetzt.');
                exit;
            end;
        end;
        bResult := true;
    end;

    procedure DatumsUltimoGerot(dtDate: Date) dtResult: Date
    var
        iMonth: Integer;
        iYear: Integer;
    begin
        if dtDate = 0D then
            Error('Der Funktion DatumsUltimoGerot wurde kein gültiges Datum übergeben!');

        iMonth := Date2DMY(dtDate, 2);
        iYear := Date2DMY(dtDate, 3);

        dtResult := DMY2Date(1, iMonth, iYear);
        dtResult := CalcDate('<-1D>', dtResult);
    end;

    procedure DateFormatGerot(Date: Date; DateFormat: Text[60]): Text[30]
    begin
        if Date = 0D then
            exit('');

        if DateFormat = '' then
            exit(Format(Date));

        exit(Format(Date, 0, DateFormat));
    end;

    procedure Produktionsdatum(chargennummer: Code[20]) produktionsdatum: Date
    var
        ManufacturingSetup: Record "Manufacturing Setup";
        nJahr: Integer;
        nMonat: Integer;
        cHilf: Text[30];
    begin
        produktionsdatum := 0D;
        ManufacturingSetup.GET;
        if ManufacturingSetup.Chargennummernsystem = ManufacturingSetup.Chargennummernsystem::Lannacher then begin
            //Ermitteln des Produktionsdatums aus der Chargennr. (für GUS-Artikel)
            if (COPYSTR(chargennummer, 1, 4) > '2200') or (COPYSTR(chargennummer, 1, 4) < '1999') or
              (COPYSTR(chargennummer, 5, 1) < 'A') or (COPYSTR(chargennummer, 5, 1) > 'M') then
                MESSAGE(chargennummer + ' ist keine gültige Lannacher Chargennummer!')
            else begin
                cHilf := COPYSTR(chargennummer, 5, 1);
                case cHilf of
                    'A':
                        nMonat := 1;
                    'B':
                        nMonat := 2;
                    'C':
                        nMonat := 3;
                    'D':
                        nMonat := 4;
                    'E':
                        nMonat := 5;
                    'F':
                        nMonat := 6;
                    'G':
                        nMonat := 7;
                    'H':
                        nMonat := 8;
                    'J':
                        nMonat := 9;
                    'K':
                        nMonat := 10;
                    'L':
                        nMonat := 11;
                    'M':
                        nMonat := 12;
                end;
                EVALUATE(nJahr, COPYSTR(chargennummer, 1, 4));
                produktionsdatum := DMY2Date(1, nMonat, nJahr);
            end;
        end else
            if ManufacturingSetup.Chargennummernsystem = ManufacturingSetup.Chargennummernsystem::Gerot then begin

            end;
    end;

    procedure FABulkMenge()
    begin
    end;


    procedure LagerStandFrei(artikelnummer: Code[20]) mengefrei: Decimal
    var
        artikel: Record Item;
        chargenstamm: Record "Lot No. Information";
        nFrei: Decimal;
        nGesamt: Decimal;
    begin
        //Duallogik verwenden, je nachdem ob mehr Chargen frei oder unfrei sind...
        if artikel.GET(artikelnummer) then begin
            artikel.CALCFIELDS(Inventory);
            mengefrei := artikel.Inventory;
        end;
        chargenstamm.SETFILTER("Item No.", artikelnummer);
        nGesamt := chargenstamm.COUNT();
        if nGesamt = 0 then
            exit(0);
        //-GL031
        //chargenstamm.SETCURRENTKEY(Status,"Item No.","Lot No.");
        //chargenstamm.SETFILTER(Status,'Frei');
        //nFrei := chargenstamm.COUNT();
        //IF nFrei / nGesamt > 0.8 THEN BEGIN
        //  chargenstamm.SETFILTER(Status,'<>Frei');
        //  chargenstamm.SETFILTER(Inventory,'>0');
        //  IF chargenstamm.FIND('-') THEN
        //     REPEAT
        //       chargenstamm.CALCFIELDS(Inventory);
        //       mengefrei := mengefrei - chargenstamm.Inventory;
        //     UNTIL chargenstamm.NEXT = 0;
        //END ELSE BEGIN
        //  chargenstamm.SETFILTER(Status,'=Frei');
        //  chargenstamm.SETFILTER(Inventory,'>0');
        //  mengefrei := 0;
        //  IF chargenstamm.FIND('-') THEN
        //     REPEAT
        //       chargenstamm.CALCFIELDS(Inventory);
        //       mengefrei := mengefrei + chargenstamm.Inventory;
        //     UNTIL chargenstamm.NEXT = 0;
        //END;
        //+GL031
        //-GL031 Ohne Duallogik:
        chargenstamm.SETFILTER("Item No.", artikelnummer);
        chargenstamm.SETFILTER(Status, '=Frei');
        chargenstamm.SETFILTER(Inventory, '>0');
        //GL-030
        chargenstamm.SETFILTER("Location Filter", '<>W-RÜL & <>W-GESPERRT & <>W-PE & <>W-ANALYTIK');
        //GL+030
        mengefrei := 0;
        if chargenstamm.FIND('-') then begin
            //mengefrei := 0;
            repeat
                chargenstamm.CALCFIELDS(Inventory);
                mengefrei := mengefrei + chargenstamm.Inventory;
            until chargenstamm.NEXT = 0;
        end;
        //+GL031
    end;

    procedure LagerStandGesperrt(artikelnummer: Code[20]) mengegesperrt: Decimal
    var
        artikel: Record Item;
        chargenstamm: Record "Lot No. Information";
    begin
        chargenstamm.SETCURRENTKEY(Status, "Item No.", "Lot No.");
        chargenstamm.SETRANGE("Item No.", artikelnummer);
        chargenstamm.SETRANGE(Status, chargenstamm.Status::Gesperrt);
        if chargenstamm.FIND('-') then
            repeat
                chargenstamm.CALCFIELDS(Inventory);
                mengegesperrt += chargenstamm.Inventory;
            until chargenstamm.NEXT = 0;
    end;

    procedure DatumsFilterVorjahr(datumsstring: Text[30]) neuerstring: Text[30]
    var
        artikel: Record Item;
    begin
        artikel.SETFILTER("Date Filter", datumsstring);
        neuerstring := FORMAT(CalcDate('<-1Y>', artikel.GETRANGEMIN("Date Filter"))) + '..'
                             + FORMAT(CalcDate('<-1Y>', artikel.GETRANGEMAX("Date Filter")));
    end;

    procedure Berechtigung(Aktion: Code[20]) ok: Boolean
    var
        recAccessControl: Record "2000000053";
        recUser: Record "2000000120";
        MfgSetup: Record "Manufacturing Setup";
        UserSecurityID: Guid;
    begin
        //Im Code verwendete Aktionen
        //'$HALTBARKEITSINFO' Eingaberecht ins Feld Ablaufdatumsformel der Artikelkarte
        //'$CHARGENVERGABE' Vollrechte in der Maske Chargenvergabe
        //'$ARTIKELBEARBEITEN' Bearbeiten Button in der Artikelkarte
        //'$EINSTANDSPREISE' (wenn nicht vorhanden, werden die Einstandspreise+DB ausgeblendet
        //'$KALKULATION' Aufruf des Reports Produktkalkulation
        //'$MANDANTENCHECK' Im Lannacher-System: Sperre der Mandanten über diesen Weg
        //'$ADMIN' Administratorberechtigung

        ok := false;

        recUser.SETCURRENTKEY("User Name");
        recUser.SETRANGE("User Name", USERID);
        recUser.FINDFIRST;
        UserSecurityID := recUser."User Security ID";

        recAccessControl.SETRANGE("User Security ID", UserSecurityID);
        recAccessControl.SETRANGE("Role ID", Aktion);
        if recAccessControl.FINDFIRST then
            ok := true;

        if Aktion = '$MANDANTENCHECK' then begin
            ok := Berechtigung('$' + UPPERCASE(COMPANYNAME)); //rekursiver Funktionsaufruf
            exit(ok);
        end;

        if not ok then begin  //bei Rolle Super alle Berechtigung für
            recAccessControl.SETRANGE("Role ID", 'SUPER');
            if recAccessControl.FINDFIRST then
                exit(true);
        end;
    end;

    procedure Division("zähler": Decimal; nenner: Decimal) ergebnis: Decimal
    begin
        ergebnis := 0;
        if nenner <> 0 then
            ergebnis := zähler / nenner;
    end;

    procedure "DatumÜbersetzen"(dtDate: Date; sLanguage: Text[3]) sResult: Text[30]
    var
        iVal: array[3] of Integer;
        month_french: array[12] of Text[10];
    begin
        month_french[1] := 'janvier';
        month_french[2] := 'février';
        month_french[3] := 'mars';
        month_french[4] := 'avril';
        month_french[5] := 'mai';
        month_french[6] := 'juin';
        month_french[7] := 'juillet';
        month_french[8] := 'août';
        month_french[9] := 'septembre';
        month_french[10] := 'octobre';
        month_french[11] := 'novembre';
        month_french[12] := 'décembre';

        sResult := 'n/a for ' + sLanguage + '!';
        iVal[1] := Date2DMY(dtDate, 1);
        iVal[2] := Date2DMY(dtDate, 2);
        iVal[3] := Date2DMY(dtDate, 3);

        case sLanguage of
            '':
                sResult := FORMAT(dtDate, 0, 4);
            'DE':
                sResult := FORMAT(dtDate, 0, 4);
            'EN':
                sResult := FORMAT(dtDate, 0, 4);
            'FR':
                sResult := STRSUBSTNO('%1. %2 %3', iVal[1], month_french[iVal[2]], iVal[3]);
        end;

        exit(sResult);
    end;

    procedure IncStr(source: Text[10]; increase: Integer; fillupcount: Integer) result: Text[10]
    var
        iResult: Integer;
        sResult: Text[50];
    begin

        if not EVALUATE(iResult, source) then Error('Der übergebene Wert kann nicht in eine Zahl umgewandelt werden!');
        if increase < 1 then Error('Der Erhöhungswert muss größer oder gleich 1 sein!');
        if fillupcount > 9 then
            MESSAGE('Die Auffüllung ist maximal auf 10 Zeichen möglich! Darüber hinaus wird die Auffüllung ignoriert!');

        sResult := FORMAT(iResult + increase);

        if StrLen(sResult) > 10 then Error('Das Ergebnis würde eine Stringlänge von mehr als 10 Zeichen ergeben!');

        if fillupcount > 0 then
            while (StrLen(sResult) < 10) and (StrLen(sResult) < fillupcount) do
                sResult := '0' + sResult;

        result := sResult;
    end;

    procedure "PrüfeUnterstufeFrei"(sItemNr: Text[20]; sLotNr: Text[20]; bBulkOnly: Boolean; bLoop: Boolean; bWarnings: Boolean) bResult: Boolean
    var
        recItemLedgerEntry: Record "32";
        recItem: Record Item;
        recLotNoInformation: Record "Lot No. Information";
        bBulk: Boolean;
        bCheck: Boolean;
        sProdOrderNr: Text[20];
    begin
        recItemLedgerEntry.SETCURRENTKEY("Item No.", "Lot No.", "Posting Date");
        recItemLedgerEntry.SETFILTER("Lot No.", sLotNr);
        recItemLedgerEntry.SETFILTER("Item No.", sItemNr);
        recItemLedgerEntry.SETRANGE("Entry Type", recItemLedgerEntry."Entry Type"::Output);
        if not recItemLedgerEntry.FIND('-') then begin
            recItem.GET(sItemNr);
            if (recItem."Replenishment System" = recItem."Replenishment System"::"Prod. Order") and
                bWarnings then
                MESSAGE('Die Prüfung des Status der Unterstufen wurde abgebrochen, da für Charge ''%1'' des ' +
'Artikels ''%2'' keine Istmeldungsposten vorhanden sind! Dies deutet darauf hin, dass die Charge ''%1'' nicht ' +
'im Haus gefertigt wurde. Das System lässt die Freigabe daher ohne weitere Prüfung dieser Unterstufe zu.',
sLotNr, sItemNr);
            exit(true);
        end;

        sProdOrderNr := recItemLedgerEntry."Order No.";
        if recItemLedgerEntry.COUNT > 1 then
            repeat
                if sProdOrderNr <> recItemLedgerEntry."Order No." then begin
                    if bWarnings then
                        Error('Die Freigabe der Charge ''%1'' des Artikels ''%2'' kann nicht gestattet werden, da ' +
        'mehrere Istmeldungen mit unterschiedlichen Fertigungsauftragsnummern verbucht sind. Bitte melden Sie diesen ' +
        'Fehler dringend der obersten Qualitätssicherung! ', recItemLedgerEntry."Lot No.", recItemLedgerEntry."Item No.");
                end;
            until recItemLedgerEntry.NEXT = 0;

        recItemLedgerEntry.RESET;
        //+GL005
        //recArtikelposten.SETCURRENTKEY("Prod. Order No.","Prod. Order Line No.","Prod. Order Comp. Line No.","Entry Type");
        recItemLedgerEntry.SETCURRENTKEY("Order Type", "Order No.", "Order Line No.", "Entry Type", "Prod. Order Comp. Line No.");
        //-GL005
        recItemLedgerEntry.SETRANGE("Order Type", recItemLedgerEntry."Order Type"::Production);
        recItemLedgerEntry.SETFILTER("Order No.", sProdOrderNr);
        recItemLedgerEntry.SETRANGE("Entry Type", recItemLedgerEntry."Entry Type"::Consumption);
        recItemLedgerEntry.SETFILTER("Source No.", sItemNr);
        recItemLedgerEntry.SETFILTER("Item No.", '<>TA*');      //GL022
        if not recItemLedgerEntry.FIND('-') then begin
            if bWarnings then
                MESSAGE('Die Prüfung des Status der Unterstufen wurde abgebrochen, da für Charge ''%1'' des ' +
'Artikels ''%2'' keine Herstellposten vorhanden sind! Das System lässt die Freigabe daher ohne Unterstufenprüfung zu.',
recItemLedgerEntry."Lot No.", recItemLedgerEntry."Item No.");
            exit(true);
        end;

        bCheck := false;
        //+GL007
        bResult := true;
        //-GL007
        //+GL008
        repeat
            recItem.GET(recItemLedgerEntry."Item No.");
            bBulk := recItem.Artikelart = recItem.Artikelart::Halbfabrikat;

            if ((not bBulkOnly) or (bBulk and bBulkOnly)) and (recItem."Item Tracking Code" <> '') then   //GL007 Tracking Code ergänzt
            begin
                bCheck := true;
                if recItem."Als Unterstufe nicht prüfen" then
                    bResult := true
                else begin
                    recLotNoInformation.SETFILTER("Item No.", recItemLedgerEntry."Item No.");
                    recLotNoInformation.SETFILTER("Lot No.", recItemLedgerEntry."Lot No.");
                    recLotNoInformation.FIND('-');
                    bResult := recLotNoInformation.Status = recLotNoInformation.Status::Frei;
                    if not bResult and bWarnings then
                        MESSAGE('Charge %1 von Artikel %2 ist nicht freigegeben!',
recItemLedgerEntry."Lot No.", recItemLedgerEntry."Item No.");
                    //-GL026
                    if recLotNoInformation."HF Kommentar" <> '' then
                        if not CONFIRM('Kommentar bei %1:\\%2\\Freigabe fortsetzen?', false, recItemLedgerEntry."Item No.", recLotNoInformation."HF Kommentar") then
                            Error('Freigabe aufgrund von HF Kommentar abgebrochen');
                    //+GL026

                end;

                if bResult and bBulk and bLoop then

                    //-GL010
                    if (sItemNr <> recItemLedgerEntry."Item No.") or (sLotNr <> recItemLedgerEntry."Lot No.") then
                        bResult := PrüfeUnterstufeFrei(recItemLedgerEntry."Item No.", recItemLedgerEntry."Lot No.", bBulkOnly, bLoop, bWarnings)
                    else
                        if bWarnings then
                            MESSAGE('Istmeldung und Verbrauchsbuchung zu gleichem Artikel in einem FA vorhanden! Unterstufenprüfung abgebrochen!');
                //+GL010

            end;
        until (recItemLedgerEntry.NEXT = 0) or (not bResult);
        //-GL008

        if bBulkOnly and not bCheck then begin
            bResult := true;
            if bWarnings then
                MESSAGE('Da in den Stücklisten kein Bulk enthalten ist, wurde keine Unterstufencharge auf ihren ' +
'Status überprüft! Das System lässt die Freigabe daher ohne Unterstufenprüfung zu.');
        end;
    end;

    procedure StrCrypt(sWord: Text[30]; iKey: Integer; bDecode: Boolean) Result: Text[30]
    var
        c: Char;
        i: Integer;
        i_ARRAYLENGTH: Integer;
        t: Integer;
        x: Integer;
        z: Integer;
        s_CHARARRAY: Text[100];
    begin
        //Achtung: randomize+random liefern in 2009 und 2013R2 verschiedene Ergebnisse!!!!!!!!!!!!!!!!!!!!!!!!
        //PIN-Codes daher beim Update entschlüsseln in 2009 und neu Verschlüsseln mit 2013
        Result := '';
        s_CHARARRAY := '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ';
        i_ARRAYLENGTH := StrLen(s_CHARARRAY);

        if bDecode then z := -1 else z := 1;
        RANDOMIZE(iKey);

        Result := '';
        for i := 1 to StrLen(sWord) do begin
            c := sWord[i];
            t := STRPOS(s_CHARARRAY, FORMAT(sWord[i]));
            if t > 0 then begin
                x := RANDOM(i_ARRAYLENGTH);
                //MESSAGE(FORMAT(x));
                t := t + (z * x);
                if (t < 1) or (t > i_ARRAYLENGTH) then t := t - (z * i_ARRAYLENGTH);
                c := s_CHARARRAY[t];
            end;
            Result := Result + FORMAT(c);
        end;
    end;

    procedure LagerstandFreiLannacher_EXP(artikelnummer: Code[20]) mengefrei: Decimal
    var
        recCompanyInfo: Record "79";
        artikel: Record Item;
        chargenstamm: Record "Lot No. Information";
    begin

        //+014
        //Lagerstand fix vom Lannacher Mandanten holen

        //Negativlogik verwenden, da performance besser, weil meiste Chargen ja frei sind
        recCompanyInfo.GET;
        artikel.CHANGECOMPANY('LANNACHER');
        chargenstamm.CHANGECOMPANY('LANNACHER');

        if artikel.GET(artikelnummer) then begin
            artikel.CALCFIELDS(Inventory);
            mengefrei := artikel.Inventory;
        end;
        chargenstamm.SETCURRENTKEY("Item No.", "Variant Code", "Lot No.");
        chargenstamm.SETFILTER("Item No.", artikelnummer);
        chargenstamm.SETFILTER(Inventory, '>0');
        chargenstamm.SETFILTER(Status, '<>Frei');  //chargenstamm.SETRANGE(Status,chargenstamm.Status::Frei);
        if chargenstamm.FIND('-') then
            repeat
                chargenstamm.CALCFIELDS(Inventory);
                mengefrei := mengefrei - chargenstamm.Inventory;
            until chargenstamm.NEXT = 0;
        //-014
    end;

    procedure FremdChargennrRequired(cItemNo: Code[20]): Boolean
    var
        recItem: Record Item;
        recManufacturingSetup: Record "Manufacturing Setup";
        lRequired: Boolean;
    begin
        //1.7.09, Petsch
        lRequired := false;
        recItem.SETRANGE("No.", cItemNo);
        if recItem.FIND('-') then begin
            recManufacturingSetup.GET;
            if recItem."Gen. Prod. Posting Group" = recManufacturingSetup.FremdChNrProdBuchGruppe then
                lRequired := true;
            if recItem."Item Tracking Code" = 'CHARGEWIEN' then
                lRequired := true;
        end;
        exit(lRequired);
    end;

    procedure StandortWeiche(Datenfeld: Text[30]; Wert: Text[40]): Text[30]
    var
        recLocation: Record "14";
        recUserSetup: Record "91";
        recProductionOrder: Record "5405";
        recItem: Record Item;
        iNum: Integer;
    begin
        //+GL002
        case Datenfeld of
            'ITEM_SITE_MANUFACTURING':
                if recItem.GET(Wert) and (recItem."Site Manufacturing" <> '') then
                    exit(recItem."Site Manufacturing");  //LANNACH/WIEN/EXTERN
            'ITEM_SITE_BATCH_RELEASE':
                if recItem.GET(Wert) and (recItem."Site Batch Release" <> '') then
                    exit(recItem."Site Batch Release");  //LANNACH/WIEN
            'ITEM_SITE_ASSIGNMENT':
                if recItem.GET(Wert) and (recItem."Site Assignment" <> '') then
                    exit(recItem."Site Assignment");  //LANNACH/WIEN
            'ITEM_SITE_SAMPLES':
                if recItem.GET(Wert) and (recItem."Site Samples" <> '') then
                    exit(recItem."Site Samples");  //LANNACH/WIEN
            'ITEM_SITE_ANALYSES':
                if recItem.GET(Wert) and (recItem."Site Analyses" <> '') then
                    exit(recItem."Site Analyses");  //LANNACH/WIEN
            'ITEM_SITE_STABILITIES':
                if recItem.GET(Wert) and (recItem."Site Stabilities" <> '') then
                    exit(recItem."Site Stabilities");  //LANNACH/WIEN/EXTERN
        end;

        case Datenfeld of
            'USER_SITE_MANUFACTURING':
                if recUserSetup.GET(Wert) and (recUserSetup."Site Manufacturing" <> '') then
                    exit(recUserSetup."Site Manufacturing");  //LANNACH/WIEN
            'USER_SALES_RESPONSIBILITY':
                if recUserSetup.GET(Wert) and (recUserSetup."Sales Resp. Ctr. Filter" <> '') then
                    exit(recUserSetup."Sales Resp. Ctr. Filter");  //EXPORT/INLAND/LOHN/MUSTER
            'USER_PURCHASE_RESPONSIBILITY':
                if recUserSetup.GET(Wert) and (recUserSetup."Purchase Resp. Ctr. Filter" <> '') then
                    exit(recUserSetup."Purchase Resp. Ctr. Filter");  //EK-LANNACH/EK-WIEN
            'USER_SERVICE_RESPONSIBILITY':
                if recUserSetup.GET(Wert) and (recUserSetup."Service Resp. Ctr. Filter" <> '') then
                    exit(recUserSetup."Service Resp. Ctr. Filter");  //
        end;
        //-GL002
        //+GL003
        /*
        CASE Datenfeld OF
            'LOCATION_SITE_MANUFACTURING':
                IF recLocation.GET(Wert) AND (recLocation."Site Manufacturing" <> '') THEN
                    exit(recLocation."Site Manufacturing");  //LANNACH/WIEN
            'LOCATION_MANUFACTURING_AREA':
                IF recLocation.GET(Wert) AND (recLocation."Manufacturing Area" <> '') THEN
                    exit(recLocation."Manufacturing Area");  //KONF/...
            'LOCATION_CITY':
                IF recLocation.GET(Wert) AND (recLocation.City <> '') THEN
                    exit(recLocation.City);  //Wien/Lannach/...
        END;
       
        //-GL003
        //+GL004
        CASE Datenfeld OF
            'PROD_ORDER_SITE_MANUFACTURING':
                BEGIN
                    recProductionOrder.SETFILTER("No.", Wert);
                    IF recProductionOrder.FINDLAST AND (recProductionOrder."Site Manufacturing" <> '') THEN
                        exit(recProductionOrder."Site Manufacturing");  //LANNACH/WIEN
                END;
            'PROD_ORDER_MANUFACTURING_AREA':
                BEGIN
                    recProductionOrder.SETFILTER("No.", Wert);
                    IF recProductionOrder.FINDLAST AND (recProductionOrder."Manufacturing Area" <> '') THEN
                        exit(recProductionOrder."Manufacturing Area");  //KONF/...
                END;
        END;
        //-GL004
        */
        if Datenfeld = 'USER' then begin
            recUserSetup.SETFILTER("User ID", UPPERCASE(Wert));
            if recUserSetup.FINDFIRST then
                exit(recUserSetup."Site Manufacturing");
        end;

        if Datenfeld = 'ITEM' then
            if recItem.GET(Wert) then begin
                if recItem."Item Tracking Code" = 'CHARGEALLE' then
                    exit('LANNACH');
                if recItem."Item Tracking Code" = 'CHARGEWIEN' then  //UPDATE2013
                    exit('WIEN');
            end;

        //-GL006
        if Datenfeld = 'SCHULUNG_USER' then begin
            recUserSetup.SETFILTER("User ID", UPPERCASE(Wert));
            if recUserSetup.FINDFIRST then
                exit(recUserSetup.Schulung_Zuordnung)
            else
                exit('');  //Wenn kein Benutzer gefunden wurde -> keine Einschränkung
        end;
        //+GL006


        exit('LANNACH'); //Fallback
    end;



    procedure LagerStandFreiVorOrt(artikelnummer: Code[20]) mengefrei: Decimal
    var
        recItemLedgerEntry: Record "32";
        artikel: Record Item;
        chargenstamm: Record "Lot No. Information";
        recManufacturingSetup: Record "Manufacturing Setup";
        nFrei: Decimal;
        nGesamt: Decimal;
    begin

        mengefrei := 0;

        if artikel.GET(artikelnummer) then;
        if recManufacturingSetup.GET(artikel."Site Manufacturing") then;

        CLEAR(recItemLedgerEntry);
        recItemLedgerEntry.SETCURRENTKEY("Item No.", Open, "Variant Code", Positive, "Location Code", "Posting Date");
        recItemLedgerEntry.SETFILTER("Item No.", artikelnummer);
        recItemLedgerEntry.SETFILTER("Location Code", recManufacturingSetup."Lagerbestand vor Ort Filter");
        recItemLedgerEntry.SETRANGE(Open, true);
        if recItemLedgerEntry.FIND('-') then
            repeat

                //Prüfen ob die Charge frei ist
                chargenstamm.SETCURRENTKEY(Status, "Item No.", "Lot No.");
                chargenstamm.SETFILTER(Status, 'Frei');
                chargenstamm.SETFILTER("Item No.", artikelnummer);
                chargenstamm.SETFILTER("Lot No.", recItemLedgerEntry."Lot No.");
                if chargenstamm.FINDSET then begin
                    //Menge nur dazugeben wenn die Charge auch frei ist
                    mengefrei += recItemLedgerEntry."Remaining Quantity";
                end;

            until recItemLedgerEntry.NEXT = 0;
    end;
    /* TODPBA
    procedure IsTestEnvironment() bResult: Boolean
    var
        nPos: Integer;
        cServername: Text[100];
        cDatabasename: Text[100];
        recDatabase: Record "2000000048";
        ActiveSession: Record "2000000110";
    begin
        bResult := FALSE;
    

      

        ActiveSession.SETRANGE("Server Instance ID", SERVICEINSTANCEID);
        ActiveSession.SETRANGE("Session ID", SESSIONID);
        ActiveSession.FINDFIRST;
        cDatabasename := ActiveSession."Database Name";


        //recServer.SETRANGE("My Server",TRUE);     //also not supported in 2013R2 !!!!!!!!!!!!!!
        //recServer.FINDFIRST;
        //cServername := recServer."Server Name";

        //-GL012 Änderung schnell ohne Serverabfrage damit Echt funktioniert
        // IF (UPPERCASE(cServername) <> 'NAVISIONSQL') OR (UPPERCASE(cDatabasename) <> 'GL-PHARMA') THEN
        IF (UPPERCASE(cDatabasename) <> 'GL-PHARMA') THEN
            //-GL012
            exit(true);

       

    end;
    
    procedure GetDatabaseName() tDBName: Text[50]
    var
        recDatabase: Record "2000000048";
    begin
        //-UPDATE2013
        tDBName := '';

        //Datenbankname für SQL Zugriff ermitteln
        recDatabase.SETRANGE("My Database", TRUE);
        recDatabase.FINDFIRST;
        tDBName := recDatabase."Database Name";

        //tDBName := 'gl-pharma-vortagessicherung2013R2';  //Datenbankname für Tests in Vortagessicherung
        //+UPDATE2013
    end;

    procedure GetUserName() sReturn: Text[30]
    var
        recUser: Record "2000000120";
    begin
        //-UPDATE2013
        sReturn := USERID; //Defaultname
        recUser.SETRANGE("User Name", USERID);
        IF recUser.FINDFIRST THEN
            sReturn := recUser."Full Name";  //Vollständiger Name (definierbarer Name aus User Einrichtung)
        //+UPDATE2013
    end;
    */
    procedure GetClientartWeb() bWebClient: Boolean
    var
        recActiveSession: Record "2000000110";
    begin
        //-UPDATE2013
        bWebClient := false;
        CLEAR(recActiveSession);
        recActiveSession.SETRANGE("User ID", USERID);
        recActiveSession.SETRANGE("Session ID", SESSIONID);
        if recActiveSession.FINDFIRST then begin
            if recActiveSession."Client Type" = recActiveSession."Client Type"::"Web Client" then
                bWebClient := true;
        end;
        //-UPDATE2013
    end;


    procedure GetArtikelMarketingLinie(cItemNo: Code[20]) cReturn: Code[20]
    var
        recStatCode: Record BASStatisticcode2PHA;
        recItem: Record Item;
    begin
        //-GL017
        //Rückgabewert muss HKL,ZNS,SOU,... sein -> Text in Tabelle umbenennen?
        cReturn := '';
        if recItem.GET(cItemNo) then
            if StrLen(recItem."BASStatisticCode2PHA IIIPHA") > 0 then
                if recStatCode.GET(recItem."Statistikcode III", 3) then
                    if StrLen(recStatCode.Marketinglinie) > 0 then
                        cReturn := recStatCode.Marketinglinie;
        //+GL017
    end;

    procedure GetLastShipmentDate(CustomerNo: Code[20]) dtLastShipment: Date
    var
        recSSH: Record "110";
    begin
        if CustomerNo <> '' then begin
            recSSH.SETRANGE("Sell-to Customer No.", CustomerNo);
            if recSSH.FINDLAST then
                dtLastShipment := recSSH."Shipment Date";
        end;
    end;

    procedure GetArtikelAufLagerplatz(cLagerort: Code[10]; cLagerplatz: Code[100]; var recTmpILE: Record "32")
    var
        recLocation: Record "14";
        recILE: Record "32";
        recBin: Record "7302";
        nCount: Integer;
    begin
        //Artikel auf Lagerort/Lagerplatz finden und in Tmp-Tabelle schreiben

        if cLagerort = '' then Error('Ein Lagerort muss angegeben sein!');
        if recLocation.GET(cLagerort) then
            if recLocation."Bin Mandatory" = true then
                if cLagerplatz = '' then Error('Ein Lagerplatz muss bei Lagerorten mit Lagerplatzpflicht angegeben sein!');

        nCount := 1;


        if cLagerplatz > '' then begin

            //Lagerplatz finden
            recBin.SETRANGE("Location Code", cLagerort);
            //recBin.SETRANGE("Item No.", recILE."Item No.");
            //recBin.SETRANGE("Lot No.", recILE."Lot No.");
            recBin.SETFILTER(Quantity, '>0');
            recBin.SETFILTER("Bin Code", cLagerplatz);
            if recBin.FINDFIRST then
                repeat

                    recBin.CALCFIELDS(Quantity, "Quantity (Base)");
                    if recBin."Quantity (Base)" > 0 then begin
                        CLEAR(recTmpILE);
                        recTmpILE."Item No." := recBin."Item No.";
                        //GLDE recTmpILE."Lot No." := recBin."Lot No.";
                        recTmpILE."Remaining Quantity" += recBin."Quantity (Base)";
                        recTmpILE.Lagerplatzhilfsfeld := recBin."Bin Code";
                        recTmpILE."Entry No." := nCount;
                        nCount += 1;
                        recTmpILE.INSERT;
                    end;

                until (recBin.NEXT = 0);

        end else begin

            CLEAR(recILE);
            recILE.SETCURRENTKEY("Item No.", Open, "Variant Code", Positive, "Location Code", "Posting Date");
            recILE.SETRANGE("Location Code", cLagerort);
            recILE.SETRANGE(Open, true);
            recILE.SETFILTER("Remaining Quantity", '>0');
            if recILE.FINDSET then
                repeat

                    //Nur Lagerort ohne Lagerplätze
                    CLEAR(recTmpILE);
                    recTmpILE."Item No." := recILE."Item No.";
                    recTmpILE."Lot No." := recILE."Lot No.";
                    recTmpILE.Lagerplatzhilfsfeld := '';
                    recTmpILE."Remaining Quantity" := recILE."Remaining Quantity";
                    recTmpILE."Entry No." := nCount;
                    nCount += 1;
                    recTmpILE.INSERT;

                until (recILE.NEXT = 0);

        end;
    end;

    procedure CheckLagerstandAeltereChargeAufLagerort(cItemNo: Code[20]; cLotNo: Code[20]; cLocationCode: Code[20]) bVorhanden: Boolean
    var
        recBin: Record "7302";
        recLot: Record "Lot No. Information";
        recLotVergleich: Record "Lot No. Information";
    begin
        //-GL036
        bVorhanden := false;
        if recLot.GET(cItemNo, '', cLotNo) then begin
            //Gibt es andere Chargen am Prüflagerort?
            recLotVergleich.SETRANGE("Item No.", cItemNo);
            recLotVergleich.SETFILTER("Location Filter", cLocationCode);
            recLotVergleich.SETFILTER(Inventory, '>0');
            if recLotVergleich.FINDFIRST then
                repeat
                    if recLotVergleich.Status = recLotVergleich.Status::Frei then  //Nur freie Chargen
                        if recLot."Expiration Date" > recLotVergleich."Expiration Date" then begin

                            //Differenz Lagerplatz ausnehmen
                            recBin.SETRANGE("Location Code", cLocationCode);
                            recBin.SETRANGE("Item No.", cItemNo);
                            //GLDE recBin.SETRANGE("Lot No.", recLotVergleich."Lot No.");
                            recBin.SETFILTER(Quantity, '>0');
                            recBin.SETFILTER("Bin Code", 'DIFFERENZ|BRUCH');
                            if recBin.FINDFIRST = false then
                                bVorhanden := true;
                        end;
                until (recLotVergleich.NEXT = 0) or (bVorhanden = true);
        end;
        //+GL036
    end;

    procedure GetErsatzartikel(sItemNo: Code[20]) cItemNoReturn: Code[20]
    var
        recItemSubstitution: Record "5715";
        recItem_: Record Item;
    begin

        // >> 176.01
        cItemNoReturn := '';
        if recItem_.GET(sItemNo) then begin

            recItem_.CALCFIELDS("Substitutes Exist");
            if recItem_."Substitutes Exist" = true then begin
                recItemSubstitution.SETRANGE("No.", recItem_."No.");
                if recItemSubstitution.FINDFIRST then
                    cItemNoReturn := recItemSubstitution."Substitute No.";
            end;

        end;
        // << 176.01
    end;

    procedure IsItemRestrictionRelevant(ItemNo: Code[20]): Boolean
    var
        recItem: Record Item;
    begin
        // >> CCU507.03
        //Zusätzliche Kriterien einbauen? SKU mit Beschaffung <> Prod. Auftrag? Standort Herstellung leer?
        if not recItem.GET(ItemNo) then
            exit(false);

        //Artikelart muss "Rohstoff", "Fertigware" oder "Halbfabrikat" sein
        case recItem.Artikelart of
            recItem.Artikelart::" ",
          recItem.Artikelart::Verpackungsstoff,
          recItem.Artikelart::Arbeitsschritt:
                exit(false);
        end;

        // Wirkstoff, Hilfsstoff oder Restr-Dummy Item
        if (recItem."Statistikcode I" <> '115') and
           (recItem."Statistikcode I" <> '110') then //AND
                                                     //(NOT IsRestrDummyItem(recItem."No.")) THEN
            exit(false);

        //Wenn Hilfsstoff dann nur wenn Leerkapsel
        if recItem."Statistikcode I" = '110' then begin
            if recItem."Statistikcode II" <> '2060' then
                exit(false);
        end;

        //Beigestelte Ware auch nicht
        if recItem."Statistikcode II" = '9000' then //Beigestellte Ware
            exit(false);

        exit(true);
        // << CCU507.03
    end;

    procedure GetUserName(): Text
    var
        recUser: Record User;
        sReturn: Text[30];
    begin

        sReturn := USERID; //Defaultname
        recUser.SETRANGE("User Name", USERID);
        if recUser.FINDFIRST then
            sReturn := recUser."Full Name";  //Vollständiger Name (definierbarer Name aus User Einrichtung)
    end;
}

