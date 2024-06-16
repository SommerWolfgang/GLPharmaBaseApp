codeunit 50001 BASNaviPharmaPHA
{
    procedure CheckItemNetChange(ItemJnlLine: Record "Item Journal Line"): Boolean
    var
        Item: Record Item;
        LotNoInFormation: Record "Lot No. InFormation";
        ExpirationDateDMP: Date;
        EmptyErr: Label '', comment = 'DEA="Artikel %1 Chargennr. eingegeben, aber Artikel nicht chargenpflichtig!\n(Feld Artikelverfolgungscode in Artikelkarte leer)"';
        MissingCostCenterErr: Label '', comment = 'DEA="Kostenstelle fehlt bei Artikelnummer %1, Buchblattzeilennummer %2, Belegzeilennummer %3"';
    begin
        if ItemJnlLine."Entry Type" <> ItemJnlLine."Entry Type"::Transfer then
            if Item.Get(ItemJnlLine."Item No.") then
                if not Item."Inventory Value Zero" then
                    if ItemJnlLine."Shortcut Dimension 1 Code" = '' then
                        Error(MissingCostCenterErr, ItemJnlLine."Item No.", ItemJnlLine."Line No.", ItemJnlLine."Document Line No.");

        CheckArtikelBuchDatGrenze(ItemJnlLine."Posting Date");

        if ItemJnlLine."Lot No." <> '' then
            if Item.Get(ItemJnlLine."Item No.") then
                if Item."Item Tracking Code" = '' then
                    Error(EmptyErr, ItemJnlLine."Item No.");

        if ItemJnlLine.Quantity = 0 then
            exit(true);

        if Item.Get(ItemJnlLine."Item No.") then
            if Item."Item Tracking Code" = '' then
                exit(true);

        // ToDo -> hardcoded!!!

        Evaluate(ExpirationDateDMP, LotNoInFormation.BASExpirationDateDMPHA);

        if ItemJnlLine."New Location Code" in ['VKL', 'KONL', 'LOHN', 'SVKL'] then
            if not LotNoInFormation.Get(ItemJnlLine."Item No.", '', ItemJnlLine."Lot No.") then
                Error('Artikel ' + ItemJnlLine."Item No." + ', Ch.Nr.' + ItemJnlLine."Lot No." + ': kein Eintrag in Chargenstammm, Umlagerung in '
                       + 'VKL/KONL/LOHN/SVKL unzulässig!')
            else
                if LotNoInFormation.BASStatusPHA <> LotNoInFormation.BASStatusPHA::Free then
                    Error('Artikel ' + ItemJnlLine."Item No." + ', Ch.Nr.' + ItemJnlLine."Lot No." + ' ist nicht freigegeben, Umlagerung in VKL/KONL/LOHN/SVKL unzulässig!');
        if ExpirationDateDMP = 0D then
            Error('Artikel ' + ItemJnlLine."Item No." + ', Ch.Nr.' + ItemJnlLine."Lot No." +
                  ' kein Ablaufdatum eingetragen, Umlagerung in VKL/KONL/LOHN unzulässig!');
        if ExpirationDateDMP <= WorkDate() then
            Error('Artikel ' + ItemJnlLine."Item No." + ', Ch.Nr.' + ItemJnlLine."Lot No." + ' ist abgelaufen, Umlagerung in VKL/KONL/LOHN/SVKL unzulässig!');

        //Umlagerung in PL bei BASItemTypePHA=Halbfabrikat+Fertigware von Quarantäneware erlaubt
        if ItemJnlLine."New Location Code" in ['PL'] then
            if LotNoInFormation.Get(ItemJnlLine."Item No.", '', ItemJnlLine."Lot No.") = false then
                Error('Artikel ' + ItemJnlLine."Item No." + ', Ch.Nr.' + ItemJnlLine."Lot No." + ': kein Eintrag in Chargenstammm, Umlagerung in '
                       + 'PL unzulässig!')
            else
                if ((Item.BASItemTypePHA = Item.BASItemTypePHA::"Semifinished Product") or
                    (Item.BASItemTypePHA = Item.BASItemTypePHA::"Finished Product"))
                then begin
                    if LotNoInFormation.BASStatusPHA = LotNoInFormation.BASStatusPHA::Blocked then
                        Error('Artikel ' + ItemJnlLine."Item No." + ', Ch.Nr.' + ItemJnlLine."Lot No." + ' ist gesperrt, Umlagerung in PL unzulässig!');
                end else begin  // Sperren für alles außer Bulk+FW
                    if LotNoInFormation.BASStatusPHA <> LotNoInFormation.BASStatusPHA::Free then
                        Error('Artikel ' + ItemJnlLine."Item No." + ', Ch.Nr.' + ItemJnlLine."Lot No." + ' ist nicht freigegeben, Umlagerung in PL unzulässig!');
                    if ExpirationDateDMP = 0D then
                        Error('Artikel ' + ItemJnlLine."Item No." + ', Ch.Nr.' + ItemJnlLine."Lot No." +
                           ' kein Ablaufdatum eingetragen, Umlagerung in PL unzulässig!');
                    if ExpirationDateDMP <= WorkDate() then
                        Error('Artikel ' + ItemJnlLine."Item No." + ', Ch.Nr.' + ItemJnlLine."Lot No." + ' ist abgelaufen, Umlagerung in PL unzulässig!');
                end;

        if (ItemJnlLine."Entry Type" = ItemJnlLine."Entry Type"::Sale) and (ItemJnlLine.Quantity > 0) then
            if not LotNoInFormation.Get(ItemJnlLine."Item No.", '', ItemJnlLine."Lot No.") then
                Error('Artikel ' + ItemJnlLine."Item No." + ', Ch.Nr.' + ItemJnlLine."Lot No." + ': kein Chargeneintrag vorhanden!')
            else begin
                if LotNoInFormation.BASStatusPHA <> LotNoInFormation.BASStatusPHA::Free then //Freigabedatum = 0D THEN
                    Error('Artikel ' + ItemJnlLine."Item No." + ', Ch.Nr.' + ItemJnlLine."Lot No." + ' ist noch nicht freigegeben, kein Verkauf möglich');
                if ItemJnlLine."Location Code" = 'KONL' then begin
                    if ExpirationDateDMP <= WorkDate() then
                        if Confirm('Artikel ' + ItemJnlLine."Item No." + ', Ch.Nr.' + ItemJnlLine."Lot No." + ' ist am ' + Format(LotNoInFormation.BASExpirationDatePHA)
                                 + ' abgelaufen!, Rechnungsposition trotzdem fakturieren?') = false then
                            Error('Auftrag abgebrochen');
                end else begin //alle anderen Lagerorte
                    if ExpirationDateDMP <= (WorkDate() - 14) then
                        Error('Artikel ' + ItemJnlLine."Item No." + ', Ch.Nr.' + ItemJnlLine."Lot No." + ' ist abgelaufen, kein Verkauf möglich');
                    if ExpirationDateDMP <= CalcDate('<CM-9M>', WorkDate()) then
                        if CONFIRM('Artikel ' + ItemJnlLine."Item No." + ', Ch.Nr.' + ItemJnlLine."Lot No." + ' läuft in weniger als 9 '
                             + 'Monaten ab, trotzdem verkaufen ?') = false then
                            Error('Auftrag abgebrochen');
                end;
            end;

        if LotNoInFormation.Get(ItemJnlLine."Item No.", ItemJnlLine."Variant Code", ItemJnlLine."Lot No.") then
            if ((ItemJnlLine."Entry Type" in [
                    ItemJnlLine."Entry Type"::Sale,
                    ItemJnlLine."Entry Type"::Consumption,
                    ItemJnlLine."Entry Type"::"Negative Adjmt."]) and
                    (ItemJnlLine.Quantity < 0)) or
                ((ItemJnlLine."Entry Type" in [
                    ItemJnlLine."Entry Type"::Purchase,
                    ItemJnlLine."Entry Type"::Output, ItemJnlLine."Entry Type"::"Positive Adjmt."]) and
                    (ItemJnlLine.Quantity > 0)) or
                (ItemJnlLine."Entry Type" = ItemJnlLine."Entry Type"::Transfer)
            then begin
                if LotNoInFormation.BASSalesLotNoPHA <> ItemJnlLine.BASSalesLotNoPHA then
                    Error('Die Verkaufschargennr. %1 stimmt nicht mit dem Chargenstammeintrag %2 überein; ' +
                       '(Änderung ist nur mehr im Chargenstamm (Artikelnr. %3, Chargennr. %4) möglich) ',
                        ItemJnlLine.BASSalesLotNoPHA, LotNoInFormation.BASSalesLotNoPHA,
                            ItemJnlLine."Item No.", ItemJnlLine."Lot No.");
                if ExpirationDateDMP <> ItemJnlLine."Expiration Date" then
                    Error('Das Ablaufdatum %1 stimmt nicht mit dem Chargenstammeintrag %2 überein; ' +
                    '(Änderung ist nur mehr im Chargenstamm (Artikelnr. %3, Chargennr. %4) möglich) ',
                        ItemJnlLine."Expiration Date",
                            ExpirationDateDMP, ItemJnlLine."Item No.", ItemJnlLine."Lot No.");
            end;
        exit(true);
    end;

    local procedure CheckArtikelBuchDatGrenze(PostingDate: Date)
    var
        GLSetup: Record "General Ledger Setup";
        BeginDate: Date;
    begin
        GLSetup.Get();

        if GLSetup.BASArtikelBuchDatGrenzePHA then begin
            if (Date2DMY(WorkDate(), 2) - 1) = 0 then
                BeginDate := DMY2Date(1, 12, Date2DMY(WorkDate(), 3) - 1)
            else
                BeginDate := DMY2Date(1, Date2DMY(WorkDate(), 2) - 1, Date2DMY(WorkDate(), 3));
            if ((PostingDate < BeginDate) or (PostingDate >= WorkDate() + 15)) then
                Error('Buchungsdatum %1 liegt ausserhalb des zulässigen Bereichs von 1. des Vormonats bzw. +15 Tagen', PostingDate);
        end;
    end;

    // ToDo -> do we need this function?
    // local procedure Ablaufdatum(artikelnummer: Code[20]; chargennummer: Code[20]; startdatum: Date) ablaufdatum: Date
    // var
    //     Item: Record Item;
    //     ManufacturingSetup: Record "Manufacturing Setup";
    //     dHilf: Date;
    //     nJahr: Integer;
    //     nMonat: Integer;
    //     cHilf: Text[30];
    // begin
    //     ManufacturingSetup.Get();

    //     if ManufacturingSetup.Chargennummernsystem = ManufacturingSetup.Chargennummernsystem::Lannacher then begin
    //         if Item.Get(artikelnummer) then begin
    //             if (CopyStr(chargennummer, 1, 4) > '2200') or (CopyStr(chargennummer, 1, 4) < '1999') or
    //                 (CopyStr(chargennummer, 5, 1) < 'A') or (CopyStr(chargennummer, 5, 1) > 'M') then begin //keine gültige Ch.nr, nimm startdatum
    //                 if startdatum = 0D then
    //                     Message('weder erkennbare Chargennummer, noch Startdatum vorhanden!')
    //                 else begin
    //                     //dHilf := CalcDate('+1M-1T',startdatum); //Monatsletzten bestimmen
    //                     dHilf := DMY2Date(1, Date2DMY(startdatum, 2), Date2DMY(startdatum, 3)); //Monatsersten errechnen MFU
    //                     dHilf := CalcDate('<-1D>', dHilf); //Damit es gleich ist wie das Datum von den Chargennummern kommend MFU
    //                     dHilf := CalcDate('<-1M>', dHilf); //Damit es gleich ist wie von den Chargennummern kommend MFU
    //                 end;
    //             end else begin //errechnen aus gültiger Ch.nr
    //                 cHilf := CopyStr(chargennummer, 5, 1);
    //                 case cHilf of
    //                     'A':
    //                         nMonat := 1;
    //                     'B':
    //                         nMonat := 2;
    //                     'C':
    //                         nMonat := 3;
    //                     'D':
    //                         nMonat := 4;
    //                     'E':
    //                         nMonat := 5;
    //                     'F':
    //                         nMonat := 6;
    //                     'G':
    //                         nMonat := 7;
    //                     'H':
    //                         nMonat := 8;
    //                     'J':
    //                         nMonat := 9;
    //                     'K':
    //                         nMonat := 10;
    //                     'L':
    //                         nMonat := 11;
    //                     'M':
    //                         nMonat := 12;
    //                 end;
    //                 Evaluate(nJahr, CopyStr(chargennummer, 1, 4));
    //                 dHilf := DMY2Date(1, nMonat, nJahr);
    //                 dHilf := CalcDate('<-1D>', dHilf); //Monatsletzten bestimmen
    //                 dHilf := CalcDate('<-1M>', dHilf);
    //             end;

    //             if dHilf <> 0D then begin
    //                 if Format(Item."Expiration Calculation") <> '' then begin
    //                     ablaufdatum := CalcDate('<+' + Format(Item."Expiration Calculation") + '>', dHilf);
    //                     //IF CalcDate('+24M',dHilf) >= ablaufdatum THEN  //016 MFU
    //                     ablaufdatum := CalcDate('<+1M>', ablaufdatum); //Artikel unter 24 Monate Laufzeit bis letzten des lauf. Monats
    //                     ablaufdatum := DMY2Date(1, Date2DMY(ablaufdatum, 2), Date2DMY(ablaufdatum, 3)); //Monatsletzten errechnen
    //                     ablaufdatum := CalcDate('<+2M>', ablaufdatum); //Monatsletzten errechnen
    //                     ablaufdatum := CalcDate('<-1D>', ablaufdatum); //Monatsletzten errechnen
    //                 end else
    //                     Message('Keine Haltbarkeitsformel in der Artikelkarte hinterlegt!');
    //             end;
    //         end;
    //     end;
    // end;


    procedure AblaufdatumFremd(ItemNo: Code[20]; LotNo: Code[20]; StartDate: Date): Date
    var
        Item: Record Item;
        ManufacturingSetup: Record "Manufacturing Setup";
        DummyDate: Date;
        ExpirationDate: Date;
        Month: Integer;
        nMonat: Integer;
        Year: Integer;
        cHilf: Text[30];
    begin
        ManufacturingSetup.Get();

        if ManufacturingSetup.BASChargennummernsystemPHA = ManufacturingSetup.BASChargennummernsystemPHA::Lannacher then
            if Item.Get(ItemNo) then begin
                if (CopyStr(LotNo, 1, 4) > '2200') or (CopyStr(LotNo, 1, 4) < '1999') or
                    (CopyStr(LotNo, 5, 1) < 'A') or (CopyStr(LotNo, 5, 1) > 'M') then begin //keine gültige Ch.nr, nimm startdatum
                    if StartDate = 0D then
                        Message('weder erkennbare Chargennummer, noch Startdatum vorhanden!')
                    else begin
                        DummyDate := CalcDate('<CM>', StartDate);
                        DummyDate := CalcDate('<-1D>', DummyDate);
                        DummyDate := CalcDate('<-1M>', DummyDate);
                    end;
                end else begin //errechnen aus gültiger Ch.nr
                    cHilf := CopyStr(LotNo, 5, 1);
                    Month := cHilf[1] - 65;
                    nMonat := Month;

                    Evaluate(Year, CopyStr(LotNo, 1, 4));
                    DummyDate := DMY2Date(1, nMonat, Year);
                    DummyDate := CalcDate('<-1D>', DummyDate); //Monatsletzten bestimmen
                    DummyDate := CalcDate('<-1M>', DummyDate);
                end;

                if DummyDate <> 0D then
                    if Format(Item."Expiration Calculation") <> '' then begin
                        ExpirationDate := CalcDate('<+' + Format(Item."Expiration Calculation") + '>', DummyDate);
                        ExpirationDate := CalcDate('<+1M>', ExpirationDate);
                        ExpirationDate := CalcDate('<CW>', ExpirationDate);
                        ExpirationDate := CalcDate('<+2M>', ExpirationDate);
                        ExpirationDate := CalcDate('<-1D>', ExpirationDate);
                        exit(ExpirationDate);
                    end else
                        Message('Keine Haltbarkeitsformel in der Artikelkarte hinterlegt!');
            end;
    end;

    procedure AblaufDatumPlausibel(sArtikelnummer: Text[20]; dtDate: Date) bResult: Boolean
    var
        Item: Record Item;
        dtHelp: Date;
        dtHelpToday: Date;
    begin
        bResult := false;
        if dtDate = 0D then
            exit(true);

        if dtDate <= TODAY then begin
            Message('Das Ablaufdatum muss in der Zukunft liegen!\Das Datum wird zurückgesetzt.');
            exit;
        end;

        if not Item.Get(sArtikelnummer) then
            exit;

        if Format(Item."Expiration Calculation") <> '' then begin
            dtHelp := CalcDate('<-' + Format(Item."Expiration Calculation") + '>', dtDate);
            dtHelpToday := CalcDate('<+LM>', Today);
            if dtHelp > dtHelpToday then begin
                Message('Gemäß der Ablaufdatumsformel würde das Herstelldatum in der Zukunft liegen! Das kann nicht sein.\' +
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
        ManufacturingSetup.Get();
        if ManufacturingSetup.BASChargennummernsystemPHA = ManufacturingSetup.BASChargennummernsystemPHA::Lannacher then
            if (CopyStr(chargennummer, 1, 4) > '2200') or (CopyStr(chargennummer, 1, 4) < '1999') or
              (CopyStr(chargennummer, 5, 1) < 'A') or (CopyStr(chargennummer, 5, 1) > 'M') then
                Message(chargennummer + ' ist keine gültige Lannacher Chargennummer!')
            else begin
                cHilf := CopyStr(chargennummer, 5, 1);
                nMonat := cHilf[1] - 65;
                Evaluate(nJahr, CopyStr(chargennummer, 1, 4));
                produktionsdatum := DMY2Date(1, nMonat, nJahr);
            end;
    end;

    procedure InventoryAvailable(ItemNo: Code[20]): Decimal
    var
        item: Record Item;
        LotNoInformation: Record "Lot No. InFormation";
        AvailableQuantity: Decimal;
        Total: Decimal;
    begin
        if item.Get(ItemNo) then begin
            item.CalcFields(Inventory);
            AvailableQuantity := item.Inventory;
        end;

        LotNoInformation.SetFilter("Item No.", ItemNo);
        Total := LotNoInformation.Count();
        if Total = 0 then
            exit(Total);

        LotNoInformation.SetAutoCalcFields(Inventory);
        LotNoInformation.SetFilter("Item No.", ItemNo);
        LotNoInformation.SetRange(BASStatusPHA, LotNoInformation.BASStatusPHA::Free);
        LotNoInformation.SetFilter(Inventory, '>0');
        LotNoInformation.SetFilter("Location Filter", '<>W-RÜL & <>W-GESPERRT & <>W-PE & <>W-ANALYTIK');
        if LotNoInformation.FindSet() then
            repeat
                AvailableQuantity += LotNoInformation.Inventory;
            until LotNoInformation.Next() = 0;

        exit(AvailableQuantity);
    end;

    procedure InventoryBlocked(ItemNo: Code[20]): Decimal
    var
        LotNoInformation: Record "Lot No. InFormation";
        BlockedQuantity: Decimal;
    begin
        LotNoInformation.SetCurrentKey(BASStatusPHA, "Item No.", "Lot No.");
        LotNoInformation.SetRange("Item No.", ItemNo);
        LotNoInformation.SetRange(BASStatusPHA, LotNoInformation.BASStatusPHA::Blocked);
        if LotNoInformation.FindSet() then
            repeat
                LotNoInformation.CalcFields(Inventory);
                BlockedQuantity += LotNoInformation.Inventory;
            until LotNoInformation.Next() = 0;

        exit(BlockedQuantity);
    end;

    procedure DateFilterPreviousYear(DateString: Text[30]): Text[30]
    var
        Item: Record Item;
    begin
        Item.SetFilter("Date Filter", DateString);
        exit(Format(CalcDate('<-1Y>', Item.GetRangeMin("Date Filter"))) + '..' +
                Format(CalcDate('<-1Y>', Item.GetRangeMax("Date Filter"))));
    end;

    procedure Permission(Action: Code[20]) ok: Boolean
    var
        AccessControl: Record "Access Control";
        User: Record User;
        UserSecurityID: Guid;
    begin
        User.SetCurrentKey("User Name");
        User.SetRange("User Name", UserID);
        User.FindFirst();
        UserSecurityID := User."User Security ID";

        AccessControl.SetRange("User Security ID", UserSecurityID);
        AccessControl.SetRange("Role ID", Action);
        ok := AccessControl.FindFirst();

        if Action = '$MANDANTENCHECK' then begin
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
                sResult := Format(dtDate, 0, 4);
            'DE':
                sResult := Format(dtDate, 0, 4);
            'EN':
                sResult := Format(dtDate, 0, 4);
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
        if not Evaluate(iResult, source) then
            Error('Der übergebene Wert kann nicht in eine Zahl umgewandelt werden!');
        if increase < 1 then
            Error('Der Erhöhungswert muss größer oder gleich 1 sein!');
        if fillupcount > 9 then
            Message('Die Auffüllung ist maximal auf 10 Zeichen möglich! Darüber hinaus wird die Auffüllung ignoriert!');

        sResult := Format(iResult + increase);

        if StrLen(sResult) > 10 then
            Error('Das Ergebnis würde eine Stringlänge von mehr als 10 Zeichen ergeben!');

        if fillupcount > 0 then
            while (StrLen(sResult) < 10) and (StrLen(sResult) < fillupcount) do
                Evaluate(sResult, '0' + sResult);

        Evaluate(result, sResult);
    end;

    procedure "PrüfeUnterstufeFrei"(ItemNo: Text[20]; LotNo: Code[50]; BulkOnly: Boolean; Loop: Boolean; Warnings: Boolean): Boolean
    var
        Item: Record Item;
        ItemLedgerEntry: Record "Item Ledger Entry";
        LotNoInFormation: Record "Lot No. InFormation";
        Bulk: Boolean;
        Check: Boolean;
        Result: Boolean;
        FreeChargeNotPosibleErr: Label '', comment = 'DEA="Die Freigabe der Charge ''%1'' des Artikels ''%2'' kann nicht gestattet werden, da mehrere Istmeldungen mit unterschiedlichen Fertigungsauftragsnummern verbucht sind. Bitte melden Sie diesen Fehler dringend der obersten Qualitätssicherung!"';
        InfoTest2Msg: Label '', comment = 'DEA="Die Prüfung des Status der Unterstufen wurde abgebrochen, da für Charge ''%1'' des Artikels ''%2'' keine Herstellposten vorhanden sind! Das System lässt die Freigabe daher ohne Unterstufenprüfung zu.';
        InfoTestMsg: Label '', comment = 'DEA="Die Prüfung des Status der Unterstufen wurde abgebrochen, da für Charge ''%1'' des Artikels ''%2'' keine Istmeldungsposten vorhanden sind! Dies deutet darauf hin, dass die Charge ''%1'' nicht im Haus gefertigt wurde. Das System lässt die Freigabe daher ohne weitere Prüfung dieser Unterstufe zu."';
        ProdOrderNo: Text[20];
    begin
        ItemLedgerEntry.SetCurrentKey("Item No.", "Lot No.", "Posting Date");
        ItemLedgerEntry.SetFilter("Lot No.", LotNo);
        ItemLedgerEntry.SetFilter("Item No.", ItemNo);
        ItemLedgerEntry.SetRange("Entry Type", ItemLedgerEntry."Entry Type"::Output);
        if not ItemLedgerEntry.FindSet() then begin
            Item.Get(ItemNo);
            if (Item."Replenishment System" = Item."Replenishment System"::"Prod. Order") and Warnings then
                Message(InfoTestMsg, LotNo, ItemNo);

            exit(true);
        end;

        ProdOrderNo := ItemLedgerEntry."Order No.";
        if ItemLedgerEntry.Count > 1 then
            repeat
                if ProdOrderNo <> ItemLedgerEntry."Order No." then
                    if Warnings then
                        Error(FreeChargeNotPosibleErr, ItemLedgerEntry."Lot No.", ItemLedgerEntry."Item No.");
            until ItemLedgerEntry.Next() = 0;

        ItemLedgerEntry.Reset();
        ItemLedgerEntry.SetCurrentKey("Order Type", "Order No.", "Order Line No.", "Entry Type", "Prod. Order Comp. Line No.");
        ItemLedgerEntry.SetRange("Order Type", ItemLedgerEntry."Order Type"::Production);
        ItemLedgerEntry.SetFilter("Order No.", ProdOrderNo);
        ItemLedgerEntry.SetRange("Entry Type", ItemLedgerEntry."Entry Type"::Consumption);
        ItemLedgerEntry.SetFilter("Source No.", ItemNo);
        ItemLedgerEntry.SetFilter("Item No.", '<>TA*');      //GL022
        if not ItemLedgerEntry.FindSet() then begin
            if Warnings then
                Message(InfoTest2Msg, ItemLedgerEntry."Lot No.", ItemLedgerEntry."Item No.");
            exit(true);
        end;

        Check := false;

        repeat
            Item.Get(ItemLedgerEntry."Item No.");
            Bulk := Item.BASItemTypePHA = Item.BASItemTypePHA::"Semifinished Product";

            if ((not BulkOnly) or (Bulk and BulkOnly)) and (Item."Item Tracking Code" <> '') then begin
                Check := true;
                if Item."Als Unterstufe nicht prüfen" then
                    Result := true
                else begin
                    LotNoInFormation.SetFilter("Item No.", ItemLedgerEntry."Item No.");
                    LotNoInFormation.SetFilter("Lot No.", ItemLedgerEntry."Lot No.");
                    Result := LotNoInFormation.FindFirst();
                    if Result then
                        Result := LotNoInFormation.BASStatusPHA = LotNoInFormation.BASStatusPHA::Free;

                    if not Result and Warnings then
                        Message('Charge %1 von Artikel %2 ist nicht freigegeben!', ItemLedgerEntry."Lot No.", ItemLedgerEntry."Item No.");
                    if LotNoInFormation.BASHFCommentPHA <> '' then
                        if not CONFIRM('Kommentar bei %1:\\%2\\Freigabe fortsetzen?', false, ItemLedgerEntry."Item No.", LotNoInFormation.BASHFCommentPHA) then
                            Error('Freigabe aufgrund von HF Kommentar abgebrochen');
                end;

                if Result and Bulk and Loop then
                    if (ItemNo <> ItemLedgerEntry."Item No.") or (LotNo <> ItemLedgerEntry."Lot No.") then
                        Result := PrüfeUnterstufeFrei(ItemLedgerEntry."Item No.", ItemLedgerEntry."Lot No.", BulkOnly, Loop, Warnings)
                    else
                        if Warnings then
                            Message('Istmeldung und Verbrauchsbuchung zu gleichem Artikel in einem FA vorhanden! Unterstufenprüfung abgebrochen!');
            end;
        until (ItemLedgerEntry.Next() = 0) or not Result;

        if BulkOnly and not Check then begin
            Result := true;
            if Warnings then
                Message('Da in den Stücklisten kein Bulk enthalten ist, wurde keine Unterstufencharge auf ihren ' +
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
            t := STRPOS(s_CHARARRAY, Format(sWord[i]));
            if t > 0 then begin
                x := RANDOM(i_ARRAYLENGTH);
                //Message(Format(x));
                t := t + (z * x);
                if (t < 1) or (t > i_ARRAYLENGTH) then t := t - (z * i_ARRAYLENGTH);
                c := s_CHARARRAY[t];
            end;
            Result := Result + Format(c);
        end;
    end;

    procedure LagerstandFreiLannacher_EXP(ItemNo: Code[20]): Decimal
    var
        CompanyInfo: Record "Company Information";
        Item: Record Item;
        LotNoInformation: Record "Lot No. InFormation";
        AvailableQuantity: Decimal;
    begin
        CompanyInfo.Get();
        Item.ChangeCompany('LANNACHER');
        LotNoInformation.ChangeCompany('LANNACHER');

        if Item.Get(ItemNo) then begin
            Item.CalcFields(Inventory);
            AvailableQuantity := Item.Inventory;
        end;
        LotNoInformation.SetCurrentKey("Item No.", "Variant Code", "Lot No.");
        LotNoInformation.SetFilter("Item No.", ItemNo);
        LotNoInformation.SetFilter(Inventory, '>0');
        LotNoInformation.SetFilter(BASStatusPHA, '<>%1', LotNoInformation.BASStatusPHA::Free);
        if LotNoInformation.FindSet() then
            repeat
                LotNoInformation.CalcFields(Inventory);
                AvailableQuantity -= LotNoInformation.Inventory;
            until LotNoInformation.Next() = 0;

        exit(AvailableQuantity);
    end;

    procedure FremdChargennrRequired(ItemNo: Code[20]): Boolean
    var
        Item: Record Item;
        ManufacturingSetup: Record "Manufacturing Setup";
    begin
        Item.Get(ItemNo);
        ManufacturingSetup.Get();

        exit((
            Item."Gen. Prod. Posting Group" = ManufacturingSetup.BASFremdChNrProdBuchGruppePHA) and
                (Item."Item Tracking Code" = 'CHARGEWIEN'));
    end;

    procedure StandortWeiche(Fld: Text[30]; Value: Text[40]): Text[30]
    var
        Item: Record Item;
        UserSetup: Record "User Setup";
    begin
        case Fld of
            'ITEM_SITE_MANUFACTURING':
                if Item.Get(Value) and (Item.BASSiteManufacturingPHA <> '') then
                    exit(Item.BASSiteManufacturingPHA);  //LANNACH/WIEN/EXTERN
            'ITEM_SITE_BATCH_RELEASE':
                if Item.Get(Value) and (Item.BASSiteBatchReleasePHA <> '') then
                    exit(Item.BASSiteBatchReleasePHA);  //LANNACH/WIEN
            'ITEM_SITE_ASSIGNMENT':
                if Item.Get(Value) and (Item.BASSiteAssignmentPHA <> '') then
                    exit(Item.BASSiteAssignmentPHA);  //LANNACH/WIEN
            'ITEM_SITE_SAMPLES':
                if Item.Get(Value) and (Item.BASSiteSamplesPHA <> '') then
                    exit(Item.BASSiteSamplesPHA);  //LANNACH/WIEN
            'ITEM_SITE_ANALYSES':
                if Item.Get(Value) and (Item.BASSiteAnalysesPHA <> '') then
                    exit(Item.BASSiteAnalysesPHA);  //LANNACH/WIEN
            'ITEM_SITE_STABILITIES':
                if Item.Get(Value) and (Item.BASSiteStabilitiesPHA <> '') then
                    exit(Item.BASSiteStabilitiesPHA);  //LANNACH/WIEN/EXTERN
            'USER_SITE_MANUFACTURING':
                if UserSetup.Get(Value) and (UserSetup."BASSite ManufacturingPHA" <> '') then
                    exit(UserSetup."BASSite ManufacturingPHA");  //LANNACH/WIEN
            'USER_SALES_RESPONSIBILITY':
                if UserSetup.Get(Value) and (UserSetup."Sales Resp. Ctr. Filter" <> '') then
                    exit(UserSetup."Sales Resp. Ctr. Filter");  //EXPORT/INLAND/LOHN/MUSTER
            'USER_PURCHASE_RESPONSIBILITY':
                if UserSetup.Get(Value) and (UserSetup."Purchase Resp. Ctr. Filter" <> '') then
                    exit(UserSetup."Purchase Resp. Ctr. Filter");  //EK-LANNACH/EK-WIEN
            'USER_SERVICE_RESPONSIBILITY':
                if UserSetup.Get(Value) and (UserSetup."Service Resp. Ctr. Filter" <> '') then
                    exit(UserSetup."Service Resp. Ctr. Filter");  //
        end;

        if Fld = 'USER' then begin
            UserSetup.SetFilter("User ID", UpperCase(Value));
            if UserSetup.FindFirst() then
                exit(UserSetup."BASSite ManufacturingPHA");
        end;

        if Fld = 'ITEM' then
            if Item.Get(Value) then begin
                if Item."Item Tracking Code" = 'CHARGEALLE' then
                    exit('LANNACH');
                if Item."Item Tracking Code" = 'CHARGEWIEN' then  //Update2013
                    exit('WIEN');
            end;

        //-GL006
        if Fld = 'SCHULUNG_USER' then begin
            UserSetup.SetFilter("User ID", UpperCase(Value));
            if UserSetup.FindFirst() then
                exit(UserSetup.BASSchulung_ZuordnungPHA)
            else
                exit('');  //Wenn kein Benutzer gefunden wurde -> keine Einschränkung
        end;

        exit('LANNACH'); //Fallback
    end;

    procedure AvailableSiteInventory(ItemNo: Code[20]): Decimal
    var
        Item: Record Item;
        ItemLedgerEntry: Record "Item Ledger Entry";
        LotNoInformation: Record "Lot No. InFormation";
        ManufacturingSetup: Record "Manufacturing Setup";
        AvailableQuantity: Decimal;
    begin
        Item.Get(ItemNo);
        ManufacturingSetup.Get(Item.BASSiteManufacturingPHA);

        LotNoInformation.SetCurrentKey(BASStatusPHA, "Item No.", "Lot No.");

        ItemLedgerEntry.Reset();
        ItemLedgerEntry.SetCurrentKey("Item No.", Open, "Variant Code", Positive, "Location Code", "Posting Date");
        ItemLedgerEntry.SetFilter("Item No.", ItemNo);
        ItemLedgerEntry.SetFilter("Location Code", ManufacturingSetup.BASInventorySiteFilterPHA);
        ItemLedgerEntry.SetRange(Open, true);
        if ItemLedgerEntry.FindSet() then
            repeat
                LotNoInformation.SetRange(BASStatusPHA, LotNoInformation.BASStatusPHA::Free);
                LotNoInformation.SetFilter("Item No.", ItemNo);
                LotNoInformation.SetFilter("Lot No.", ItemLedgerEntry."Lot No.");
                if not LotNoInformation.IsEmpty then
                    AvailableQuantity += ItemLedgerEntry."Remaining Quantity";
            until ItemLedgerEntry.Next() = 0;

        exit(AvailableQuantity);
    end;

    procedure GetClientartWeb(): Boolean
    var
        ActiveSession: Record "Active Session";
    begin
        ActiveSession.Reset();
        ActiveSession.SetRange("User ID", UserID);
        ActiveSession.SetRange("Session ID", SessionId());
        if ActiveSession.FindFirst() then
            exit(ActiveSession."Client Type" = ActiveSession."Client Type"::"Web Client");
    end;

    procedure GetItemMarketingLinie(ItemNo: Code[20]): Code[20]
    var
        StatisticCode: Record BASStatisticcodePHA;
        Item: Record Item;
    begin
        if Item.Get(ItemNo) then
            if StrLen(Item.BASStatisticCodeIIIPHA) > 0 then
                if StatisticCode.Get(Item.BASStatisticCodeIIIPHA, 3) then
                    if StrLen(StatisticCode.Marketinglinie) > 0 then
                        exit(StatisticCode.Marketinglinie);
    end;

    procedure GetLastShipmentDate(CustomerNo: Code[20]): Date
    var
        SalesShipmentHeader: Record "Sales Shipment Header";
    begin
        if CustomerNo <> '' then begin
            SalesShipmentHeader.SetRange("Sell-to Customer No.", CustomerNo);
            if SalesShipmentHeader.FindLast() then
                exit(SalesShipmentHeader."Shipment Date");
        end;
    end;

    // ToDo -> check code in PROD
    procedure GetArtikelAufLagerplatz(LocationCode: Code[10]; BinCode: Code[100]; var ItemLedgerEntry2: Record "Item Ledger Entry")
    var
        Bin: Record Bin;
        ItemLedgerEntry: Record "Item Ledger Entry";
        Location: Record Location;
        Counter: Integer;
    begin
        if LocationCode = '' then
            Error('Ein Lagerort muss angegeben sein!');

        if Location.Get(LocationCode) then
            if Location."Bin Mandatory" = true then
                if BinCode = '' then Error('Ein Lagerplatz muss bei Lagerorten mit Lagerplatzpflicht angegeben sein!');

        Counter := 1;

        if BinCode > '' then begin
            Bin.SetRange("Location Code", LocationCode);
            // Bin.SetFilter(Quantity, '>0');
            // Bin.SetFilter("Bin Code", BinCode);
            if Bin.FindSet() then
                repeat
                    if true then begin
                        // Bin.CalcFields(Quantity, "Quantity (Base)");
                        // if Bin."Quantity (Base)" > 0 then begin
                        //     CLEAR(ItemLedgerEntry2);
                        //     ItemLedgerEntry2."Item No." := Bin."Item No.";
                        //     ItemLedgerEntry2."Remaining Quantity" += Bin."Quantity (Base)";
                        //     ItemLedgerEntry2.BASBinCodeHelpFieldPHA := Bin."Bin Code";
                        //     ItemLedgerEntry2."Entry No." := Counter;
                        //     Counter += 1;
                        //     ItemLedgerEntry2.Insert();
                        Message('ToDo');
                        Message('ToDo2');
                    end;

                until Bin.Next() = 0;
        end else begin
            ItemLedgerEntry.Reset();
            ItemLedgerEntry.SetCurrentKey("Item No.", Open, "Variant Code", Positive, "Location Code", "Posting Date");
            ItemLedgerEntry.SetRange("Location Code", LocationCode);
            ItemLedgerEntry.SetRange(Open, true);
            ItemLedgerEntry.SetFilter("Remaining Quantity", '>0');
            if ItemLedgerEntry.FindSet() then
                repeat

                    //Nur Lagerort ohne Lagerplätze
                    CLEAR(ItemLedgerEntry2);
                    ItemLedgerEntry2."Item No." := ItemLedgerEntry."Item No.";
                    ItemLedgerEntry2."Lot No." := ItemLedgerEntry."Lot No.";
                    ItemLedgerEntry2.BASBinCodeHelpFieldPHA := '';
                    ItemLedgerEntry2."Remaining Quantity" := ItemLedgerEntry."Remaining Quantity";
                    ItemLedgerEntry2."Entry No." := Counter;
                    Counter += 1;
                    ItemLedgerEntry2.Insert();
                until ItemLedgerEntry.Next() = 0;

        end;
    end;

    // ToDo -> Check code in prod
    procedure CheckLagerstandAeltereChargeAufLagerort(ItemNo: Code[20]; LotNo: Code[20]; LocationCode: Code[20]): Boolean
    var
        Bin: Record Bin;
        LotNoInformation: Record "Lot No. InFormation";
        LotNoInformation2: Record "Lot No. InFormation";
        Exists: Boolean;
    begin
        if LotNoInformation.Get(ItemNo, '', LotNo) then begin
            LotNoInformation2.SetRange("Item No.", ItemNo);
            LotNoInformation2.SetFilter("Location Filter", LocationCode);
            LotNoInformation2.SetFilter(Inventory, '>0');
            if LotNoInformation2.FindSet() then
                repeat
                    if LotNoInformation2.BASStatusPHA = LotNoInformation2.BASStatusPHA::Free then
                        if LotNoInformation.BASExpirationDatePHA > LotNoInformation2.BASExpirationDatePHA then begin
                            Bin.SetRange("Location Code", LocationCode);
                            // Bin.SetRange("Item No.", ItemNo);
                            // Bin.SetFilter(Quantity, '>0');
                            // Bin.SetFilter("Bin Code", 'DIFFERENZ|BRUCH');
                            Exists := bin.IsEmpty;
                        end;
                until (LotNoInformation2.Next() = 0) or Exists;
        end;
    end;

    procedure GetSubstitutionItem(ItemNo: Code[20]): Code[20]
    var
        Item: Record Item;
        ItemSubstitution: Record "Item Substitution";
    begin
        if Item.Get(ItemNo) then begin
            Item.CalcFields("Substitutes Exist");
            if Item."Substitutes Exist" then begin
                ItemSubstitution.SetRange("No.", Item."No.");
                if ItemSubstitution.FindFirst() then
                    exit(ItemSubstitution."Substitute No.");
            end;
        end;
    end;

    procedure IsItemRestrictionRelevant(ItemNo: Code[20]): Boolean
    var
        Item: Record Item;
    begin
        if not Item.Get(ItemNo) then
            exit(false);

        case Item.BASItemTypePHA of
            Item.BASItemTypePHA::" ",
            Item.BASItemTypePHA::"Package Material",
            Item.BASItemTypePHA::"Production Step":
                exit(false);
        end;

        if (Item.BASStatisticCodeIPHA <> '115') and
           (Item.BASStatisticCodeIPHA <> '110')
        then
            exit(false);

        if Item.BASStatisticCodeIPHA = '110' then
            if Item.BASStatisticCodeIIPHA <> '2060' then
                exit(false);

        if Item.BASStatisticCodeIIPHA = '9000' then
            exit(false);

        exit(true);
    end;

    procedure GetUserName(): Text
    var
        User: Record User;
    begin
        User.SetRange("User Name", UserID);
        if User.FindFirst() then
            exit(User."Full Name");
        exit(UserId);
    end;
}