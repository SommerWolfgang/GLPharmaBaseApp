codeunit 50000 BASCodeCollectionPHA
{
    Permissions =
        tabledata "Bin Content" = R,
        tabledata "Comment Line" = R,
        tabledata "Currency Exchange Rate" = R,
        tabledata Customer = R,
        tabledata "General Ledger Setup" = R,
        tabledata "Inventory Setup" = R,
        tabledata Item = R,
        tabledata "Item Journal Batch" = RID,
        tabledata "Item Journal Line" = RID,
        tabledata "Item Ledger Entry" = R,
        tabledata Location = R,
        tabledata "Lot No. Information" = R,
        tabledata "Purch. Cr. Memo Hdr." = R,
        tabledata "Purch. Cr. Memo Line" = R,
        tabledata "Purch. Inv. Header" = R,
        tabledata "Purch. Inv. Line" = R,
        tabledata "Purchase Header" = R,
        tabledata "Purchase Line" = RIM,
        tabledata "Sales Cr.Memo Header" = RM,
        tabledata "Sales Header" = RM,
        tabledata "Sales Invoice Header" = RM,
        tabledata "Sales Price" = R,
        tabledata "Sales Shipment Header" = R,
        tabledata "Ship-to Address" = R,
        tabledata "Transfer Header" = R,
        tabledata "Transfer Line" = R,
        tabledata "Value Entry" = R,
        tabledata Vendor = R,
        tabledata "Warehouse Entry" = R;

    trigger OnRun()
    begin
    end;

    var
        HasBeenInitialized: Boolean;
        BATCH_NAME: Label '$BEREITST.';
        DOCUMENT_NAME: Label 'BEREITSTELLUNG';
        TEMPLATE_NAME: Label 'UMLAGERUNG';
        ANSI: Text[94];
        ASCII: Text[94];

    procedure Bemerkungsmeldung(ItemNo: Code[20])
    var
        Bemerkzeile: Record "Comment Line";
        CommentText: Text;
    begin
        CommentText := '';
        Bemerkzeile.SetCurrentKey("Table Name", Code, Date, BASShowNoteOrderPHA);
        Bemerkzeile.SetRange("Table Name", Bemerkzeile."Table Name"::Item);
        Bemerkzeile.SetRange("No.", ItemNo);
        Bemerkzeile.SetRange(BASShowNoteOrderPHA, true);
        if Bemerkzeile.FindSet() then
            repeat
                if Bemerkzeile.Comment <> '' then begin
                    CommentText += CopyStr(Bemerkzeile.Comment, 1,
                      MaxStrLen(CommentText) - StrLen(CommentText));
                    if MaxStrLen(CommentText) > StrLen(CommentText) then
                        CommentText += '\';
                end;
            until Bemerkzeile.Next() = 0;

        if CommentText <> '' then
            Message(CopyStr(CommentText, 1, StrLen(CommentText) - 1));
    end;

    procedure EKLiefBemerkungsmeldung(EKKopf: Record "Purchase Header")
    var
        CommentLine: Record "Comment Line";
        PurchaseLine: Record "Purchase Line";
        OldItem: Code[20];
        CommentText: Text[1000];
    begin
        OldItem := '';

        PurchaseLine.Reset();
        PurchaseLine.SetRange("Document Type", EKKopf."Document Type");
        PurchaseLine.SetRange("Document No.", EKKopf."No.");
        PurchaseLine.SetRange(Type, PurchaseLine.Type::Item);
        if PurchaseLine.FindSet() then
            repeat
                CommentText := '';
                CommentLine.SetCurrentKey("Table Name", Code, Date, BASShowNoteOrderPHA);
                CommentLine.SetRange("Table Name", CommentLine."Table Name"::Item);
                CommentLine.SetRange("No.", PurchaseLine."No.");
                CommentLine.SetRange(BASShowNoteOrderPHA, true);
                if CommentLine.FindSet() then
                    repeat
                        if CommentLine.Comment <> '' then begin
                            CommentText += CopyStr(CommentLine.Comment, 1,
                              MaxStrLen(CommentText) - StrLen(CommentText));
                            if MaxStrLen(CommentText) > StrLen(CommentText) then
                                CommentText += '\';
                        end;
                    until CommentLine.Next() = 0;

                if OldItem <> PurchaseLine."No." then
                    if CommentText <> '' then
                        Message(CopyStr(CommentText, 1, StrLen(CommentText) - 1));

                OldItem := PurchaseLine."No.";
            until PurchaseLine.Next() = 0;
    end;

    procedure SalesLocation(): Code[10]
    var
        InventorySetup: Record "Inventory Setup";
    begin
        InventorySetup.Get();
        InventorySetup.TestField(BASVerkaufslagerortcodePHA);
        exit(InventorySetup.BASVerkaufslagerortcodePHA);
    end;

    procedure AktArtikelkonto(Item: Record Item)
    var
        CurrencyExchRate: Record "Currency Exchange Rate";
        PurchCrMemoHeader: Record "Purch. Cr. Memo Hdr.";
        PurchCrMemoLine: Record "Purch. Cr. Memo Line";
        PurchInvHeader: Record "Purch. Inv. Header";
        PurchInvLine: Record "Purch. Inv. Line";
        TempValueEntry: Record "Value Entry" temporary;
        ValueEntry: Record "Value Entry";
        Window: Dialog;
        LineNo: Integer;
    begin
        Window.OPEN('Ermittle Artikelkontoinfo ' + Item."No." + ' #1#########');
        ValueEntry.Reset();
        ValueEntry.SetCurrentKey("Item No.", "Posting Date", "Item Ledger Entry Type", "Entry Type");
        ValueEntry.SetFilter("Item No.", Item."No.");
        ValueEntry.SetRange("Entry Type", ValueEntry."Entry Type"::"Direct Cost");
        ValueEntry.SetRange("Item Ledger Entry Type", ValueEntry."Item Ledger Entry Type"::Purchase);
        Window.Update(1, 'Wertposten');
        if ValueEntry.FindSet() then
            repeat
                TempValueEntry.Init();
                TempValueEntry := ValueEntry;
                TempValueEntry."No." := '';
                if not TempValueEntry.Insert() then
                    TempValueEntry.Modify();
            until ValueEntry.Next() = 0;

        Window.Update(1, PurchInvHeader.TableCaption);
        LineNo := 99990000;
        PurchInvLine.SetCurrentKey(Type, "BASZuordnung zu Artikelnr.PHA");
        PurchInvLine.SetRange(Type, PurchInvLine.Type::"G/L Account");
        PurchInvLine.SetRange("BASZuordnung zu Artikelnr.PHA", Item."No.");
        if PurchInvLine.FindSet() then
            repeat
                LineNo += 1;
                TempValueEntry.Init();
                TempValueEntry."Entry No." := LineNo;
                TempValueEntry."Document No." := PurchInvLine."Document No.";
                TempValueEntry.Description := PurchInvLine.Description;
                TempValueEntry."No." := PurchInvLine."No.";          //Sachkontonr.
                TempValueEntry."Item No." := PurchInvLine."BASZuordnung zu Artikelnr.PHA";
                // ToDo
                // TempValueEntry."Item Ledger Entry No." := PurchInvLine."BASZuordnung zu ArtikelpostenPHA";
                TempValueEntry."Item Ledger Entry Type" := TempValueEntry."Item Ledger Entry Type"::Purchase;
                TempValueEntry."Global Dimension 1 Code" := PurchInvLine."Shortcut Dimension 1 Code";
                TempValueEntry."Valued Quantity" := PurchInvLine."Quantity (Base)";
                TempValueEntry."Invoiced Quantity" := PurchInvLine."Quantity (Base)";
                //Rechnungskopf holen
                PurchInvHeader.GET(PurchInvLine."Document No.");
                TempValueEntry."Document Date" := PurchInvHeader."Document Date";
                TempValueEntry."Posting Date" := PurchInvHeader."Posting Date";
                TempValueEntry."External Document No." := PurchInvHeader."Vendor Invoice No.";
                TempValueEntry."Cost per Unit" := PurchInvLine."Unit Cost (LCY)";
                TempValueEntry."Cost Amount (Actual)" := CurrencyExchRate.ExchangeAmtFCYToLCY(
                  PurchInvHeader."Posting Date",
                  PurchInvHeader."Currency Code",
                  PurchInvLine.Amount,
                  PurchInvHeader."Currency Factor");
                TempValueEntry."BASBetrag (FW)PHA" := PurchInvLine.Amount;
                TempValueEntry.Fremdwährung := PurchInvHeader."Currency Code";
                TempValueEntry."BASBestellnr.PHA" := PurchInvHeader."Order No.";
                TempValueEntry.BASBestelldatumPHA := PurchInvHeader."Order Date";
                TempValueEntry."Source Type" := TempValueEntry."Source Type"::Vendor;
                TempValueEntry."Source No." := PurchInvLine."Buy-from Vendor No.";
                TempValueEntry.Insert();
            until PurchInvLine.Next() = 0;

        Window.Update(1, PurchCrMemoHeader.TableCaption);

        PurchCrMemoLine.SetCurrentKey(Type, "BASZuordnung zu Artikelnr.PHA");
        PurchCrMemoLine.SetRange("BASZuordnung zu Artikelnr.PHA", Item."No.");
        if PurchCrMemoLine.FindSet() then
            repeat
                LineNo += 1;
                TempValueEntry.Init();
                TempValueEntry."Entry No." := LineNo;
                TempValueEntry."Document No." := PurchCrMemoLine."Document No.";
                TempValueEntry.Description := PurchCrMemoLine.Description;
                TempValueEntry."No." := PurchCrMemoLine."No.";          //Sachkontonr.
                TempValueEntry."Item No." := PurchCrMemoLine."BASZuordnung zu Artikelnr.PHA";
                // TempValueEntry."Item Ledger Entry No." := PurchCrMemoLine."Zuordnung zu Artikelposten";
                TempValueEntry."Item Ledger Entry Type" := TempValueEntry."Item Ledger Entry Type"::Purchase;
                TempValueEntry."Global Dimension 1 Code" := PurchCrMemoLine."Shortcut Dimension 1 Code";
                TempValueEntry."Valued Quantity" := PurchCrMemoLine."Quantity (Base)";
                TempValueEntry."Invoiced Quantity" := PurchCrMemoLine."Quantity (Base)";
                //Gutschriftskopf holen
                PurchCrMemoHeader.GET(PurchCrMemoLine."Document No.");
                TempValueEntry."Document Date" := PurchCrMemoHeader."Document Date";
                TempValueEntry."Posting Date" := PurchCrMemoHeader."Posting Date";
                TempValueEntry."External Document No." := PurchCrMemoHeader."Vendor Cr. Memo No.";
                TempValueEntry."Cost per Unit" := PurchCrMemoLine."Unit Cost (LCY)";
                TempValueEntry."Cost Amount (Actual)" := CurrencyExchRate.ExchangeAmtFCYToLCY(
                  PurchCrMemoHeader."Posting Date",
                  PurchCrMemoHeader."Currency Code",
                  PurchCrMemoLine.Amount,
                  PurchCrMemoHeader."Currency Factor");
                TempValueEntry."BASBetrag (FW)PHA" := PurchCrMemoLine.Amount;
                TempValueEntry.Fremdwährung := PurchCrMemoHeader."Currency Code";
                TempValueEntry."Source Type" := TempValueEntry."Source Type"::Vendor;
                TempValueEntry."Source No." := PurchCrMemoLine."Buy-from Vendor No.";
                TempValueEntry.Insert();
            until PurchCrMemoLine.Next() = 0;
        Window.CLOSE();
        TempValueEntry.SetRange("Item Ledger Entry Type", TempValueEntry."Item Ledger Entry Type"::Purchase);

        // ToDo -> search page
        Page.RunModal(51205, TempValueEntry);
    end;

    procedure ASCII2ANSI(Text: Text[1024]): Text[1024]
    begin
        InitCharMap();
        exit(CONVERTSTR(Text, ASCII, ANSI));
    end;

    procedure ANSI2ASCII(Text: Text[1024]): Text[1024]
    begin
        InitCharMap();
        exit(CONVERTSTR(Text, ANSI, ASCII));
    end;

    local procedure InitCharMap()
    begin
        if HasBeenInitialized then
            exit;

        ANSI[1] := 131;
        ASCII[1] := 159;  // ƒ
        ANSI[2] := 161;
        ASCII[2] := 173;  // ¡
        ANSI[3] := 162;
        ASCII[3] := 189;  // ¢
        ANSI[4] := 163;
        ASCII[4] := 156;  // £
        ANSI[5] := 164;
        ASCII[5] := 207;  // ¤
        ANSI[6] := 165;
        ASCII[6] := 190;  // ¥
        ANSI[7] := 166;
        ASCII[7] := 221;  // ¦
        ANSI[8] := 167;
        ASCII[8] := 245;  // §
        ANSI[9] := 168;
        ASCII[9] := 249;  // ¨
        ANSI[10] := 169;
        ASCII[10] := 184;  // ©
        ANSI[11] := 170;
        ASCII[11] := 166;  // ª
        ANSI[12] := 171;
        ASCII[12] := 174;  // «
        ANSI[13] := 173;
        ASCII[13] := 240;  // ­
        ANSI[14] := 174;
        ASCII[14] := 169;  // ®
        ANSI[15] := 175;
        ASCII[15] := 238;  // ¯
        ANSI[16] := 176;
        ASCII[16] := 167;  // °
        ANSI[17] := 177;
        ASCII[17] := 241;  // ±
        ANSI[18] := 178;
        ASCII[18] := 253;  // ²
        ANSI[19] := 179;
        ASCII[19] := 252;  // ³
        ANSI[20] := 180;
        ASCII[20] := 239;  // ´
        ANSI[21] := 181;
        ASCII[21] := 230;  // µ
        ANSI[22] := 182;
        ASCII[22] := 244;  // ¶
        ANSI[23] := 183;
        ASCII[23] := 250;  // ·
        ANSI[24] := 184;
        ASCII[24] := 247;  // ¸
        ANSI[25] := 185;
        ASCII[25] := 251;  // ¹
        ANSI[26] := 187;
        ASCII[26] := 175;  // »
        ANSI[27] := 188;
        ASCII[27] := 172;  // ¼
        ANSI[28] := 189;
        ASCII[28] := 171;  // ½
        ANSI[29] := 190;
        ASCII[29] := 243;  // ¾
        ANSI[30] := 191;
        ASCII[30] := 168;  // ¿
        ANSI[31] := 192;
        ASCII[31] := 183;  // À
        ANSI[32] := 193;
        ASCII[32] := 181;  // Á
        ANSI[33] := 194;
        ASCII[33] := 182;  // Â
        ANSI[34] := 195;
        ASCII[34] := 199;  // Ã
        ANSI[35] := 196;
        ASCII[35] := 142;  // Ä
        ANSI[36] := 197;
        ASCII[36] := 143;  // Å
        ANSI[37] := 198;
        ASCII[37] := 146;  // Æ
        ANSI[38] := 199;
        ASCII[38] := 128;  // Ç
        ANSI[39] := 200;
        ASCII[39] := 212;  // È
        ANSI[40] := 201;
        ASCII[40] := 144;  // É
        ANSI[41] := 202;
        ASCII[41] := 210;  // Ê
        ANSI[42] := 203;
        ASCII[42] := 211;  // Ë
        ANSI[43] := 204;
        ASCII[43] := 222;  // Ì
        ANSI[44] := 205;
        ASCII[44] := 214;  // Í
        ANSI[45] := 206;
        ASCII[45] := 215;  // Î
        ANSI[46] := 207;
        ASCII[46] := 216;  // Ï
        ANSI[47] := 208;
        ASCII[47] := 209;  // Ð
        ANSI[48] := 209;
        ASCII[48] := 165;  // Ñ
        ANSI[49] := 210;
        ASCII[49] := 227;  // Ò
        ANSI[50] := 211;
        ASCII[50] := 224;  // Ó
        ANSI[51] := 212;
        ASCII[51] := 226;  // Ô
        ANSI[52] := 213;
        ASCII[52] := 229;  // Õ
        ANSI[53] := 214;
        ASCII[53] := 153;  // Ö
        ANSI[54] := 215;
        ASCII[54] := 158;  // ×
        ANSI[55] := 216;
        ASCII[55] := 157;  // Ø
        ANSI[56] := 217;
        ASCII[56] := 235;  // Ù
        ANSI[57] := 218;
        ASCII[57] := 233;  // Ú
        ANSI[58] := 219;
        ASCII[58] := 234;  // Û
        ANSI[59] := 220;
        ASCII[59] := 154;  // Ü
        ANSI[60] := 221;
        ASCII[60] := 237;  // Ý
        ANSI[61] := 222;
        ASCII[61] := 232;  // Þ
        ANSI[62] := 223;
        ASCII[62] := 225;  // ß
        ANSI[63] := 224;
        ASCII[63] := 133;  // à
        ANSI[64] := 225;
        ASCII[64] := 160;  // á
        ANSI[65] := 226;
        ASCII[65] := 131;  // â
        ANSI[66] := 227;
        ASCII[66] := 198;  // ã
        ANSI[67] := 228;
        ASCII[67] := 132;  // ä
        ANSI[68] := 229;
        ASCII[68] := 134;  // å
        ANSI[69] := 230;
        ASCII[69] := 145;  // æ
        ANSI[70] := 231;
        ASCII[70] := 135;  // ç
        ANSI[71] := 232;
        ASCII[71] := 138;  // è
        ANSI[72] := 233;
        ASCII[72] := 130;  // é
        ANSI[73] := 234;
        ASCII[73] := 136;  // ê
        ANSI[74] := 235;
        ASCII[74] := 137;  // ë
        ANSI[75] := 236;
        ASCII[75] := 141;  // ì
        ANSI[76] := 237;
        ASCII[76] := 161;  // í
        ANSI[77] := 238;
        ASCII[77] := 140;  // î
        ANSI[78] := 239;
        ASCII[78] := 139;  // ï
        ANSI[79] := 240;
        ASCII[79] := 208;  // ð
        ANSI[80] := 241;
        ASCII[80] := 164;  // ñ
        ANSI[81] := 242;
        ASCII[81] := 149;  // ò
        ANSI[82] := 243;
        ASCII[82] := 162;  // ó
        ANSI[83] := 244;
        ASCII[83] := 147;  // ô
        ANSI[84] := 245;
        ASCII[84] := 228;  // õ
        ANSI[85] := 246;
        ASCII[85] := 148;  // ö
        ANSI[86] := 247;
        ASCII[86] := 246;  // ÷
        ANSI[87] := 248;
        ASCII[87] := 155;  // ø
        ANSI[88] := 249;
        ASCII[88] := 151;  // ù
        ANSI[89] := 250;
        ASCII[89] := 163;  // ú
        ANSI[90] := 251;
        ASCII[90] := 150;  // û
        ANSI[91] := 252;
        ASCII[91] := 129;  // ü
        ANSI[92] := 253;
        ASCII[92] := 236;  // ý
        ANSI[93] := 254;
        ASCII[93] := 231;  // þ
        ANSI[94] := 255;
        ASCII[94] := 152;  // ÿ

        HasBeenInitialized := true;
    end;

    procedure Fakturenkontrolle(PurchaseHeader: Record "Purchase Header"): Boolean
    var
        PurchaseLine: Record "Purchase Line";
    begin
        PurchaseLine.SetRange("Document Type", PurchaseHeader."Document Type");
        PurchaseLine.SetRange("Document No.", PurchaseHeader."No.");
        PurchaseLine.SetRange(Type, PurchaseLine.Type::Item);
        if PurchaseLine.FindSet() then
            repeat
                if (PurchaseLine."Qty. to Receive" > 0) or (PurchaseLine."Qty. to Invoice" > 0) then
                    if CheckItem(PurchaseLine, 20) then
                        exit(false);
            until PurchaseLine.Next() = 0;

        exit(true);
    end;

    procedure Suchtgiftliste()
    begin
        /*
        //Update2013 - Wird nicht mehr benötigt
        ReportSuchtgiftliste.Starten;
        ReportSuchtgiftliste.RUNMODAL;
        IF ReportSuchtgiftliste."alles gedruckt" THEN
          IF Confirm('Wurde der Druck ohne Fehler durchgeführt?',TRUE) THEN
            ReportSuchtgiftliste.ArtikelModify;
        */

    end;

    procedure CheckItem(PurchaseLine: Record "Purchase Line"; WarningValue: Decimal): Boolean
    var
        Item: Record Item;
        PurchInvLine: Record "Purch. Inv. Line";
        nhilf: Decimal;
        cHilf: Text[150];
    begin
        if Item.Get(PurchaseLine."No.") then begin
            if CopyStr(PurchInvLine."No.", 1, 2) = 'DI' then
                if Format(Item.BASItemTypePHA) = ' ' then
                    exit(false);

            nhilf := Difference(Item."Unit Cost",
                               PurchaseLine."Unit Cost" / PurchaseLine."Qty. per Unit of Measure");    //GL020 "Unit Cost" statt "Unit Cost (LCY)" genommen
            cHilf := 'bisher: ' + Format(Item."Unit Cost") + ' jetzt: ' + Format(PurchaseLine."Unit Cost" / PurchaseLine."Qty. per Unit of Measure");
            Evaluate(cHilf, '(' + cHilf + ')');

            if Item."Costing Method" = Item."Costing Method"::Standard then begin
                if ABS(nhilf) > 0 then
                    if not Confirm(
                      'Der Einstandspreis von %1 weicht um %2 Prozent ab.%3\' +
                      'Wollen Sie trotzdem Buchen?', false, PurchaseLine."No.", ROUND(nhilf, 0.1), cHilf) then
                        exit(true);

            end else
                if ABS(nhilf) >= WarningValue then
                    if not Confirm(
                      'Der Einstandspreis von %1 weicht um %2 Prozent ab.%3\' +
                      'Wollen Sie trotzdem Buchen?', false, PurchaseLine."No.", ROUND(nhilf, 0.1), cHilf)
                    then
                        exit(true);
        end;

        exit(false);
    end;

    procedure Difference(Value1: Decimal; Wert2: Decimal) Abweich: Decimal
    begin
        if Value1 <> 0 then
            exit((Wert2 / Value1 - 1) * 100);
    end;

    procedure Bereitstellungslager(var LocationName: Code[10]) Result: Boolean
    var
        InventorySetup: Record "Inventory Setup";
    begin
        InventorySetup.Get();
        Result := InventorySetup.BASBereitstellungslagerortcodePHA <> '';
        LocationName := InventorySetup.BASBereitstellungslagerortcodePHA;
    end;

    procedure FAPDatum(ItemNo: Code[20]; tDatum: Text[30]): Decimal
    var
        CurrencyExchangeRate: Record "Currency Exchange Rate";
        SalesPrice: Record "Sales Price";
    begin
        SalesPrice.SetFilter("Item No.", ItemNo);
        SalesPrice.SetRange("Sales Type", SalesPrice."Sales Type"::"Customer Price Group");
        SalesPrice.SetFilter("Sales Code", '1FAP');
        SalesPrice.SetFilter("Starting Date", '<=' + tDatum);
        SalesPrice.SetFilter("Ending Date", '>' + tDatum + '|''''');
        if not SalesPrice.FindLast() then
            if SalesPrice."Currency Code" <> '' then begin
                CurrencyExchangeRate.Reset();
                CurrencyExchangeRate.SetRange("Currency Code", SalesPrice."Currency Code");
                if CurrencyExchangeRate.FindLast() then
                    exit(Round(SalesPrice."Unit Price" / CurrencyExchangeRate."Exchange Rate Amount", 0.00001));
            end;

        exit(SalesPrice."Unit Price");
    end;

    procedure ShowBelegKundenInfoBox(cKundenNr: Code[20])
    var
        CommentLine: Record "Comment Line";
        s: Text;
    begin
        //-GL007
        //Kundenmeldung von Auftrag Rechnung und Gutschriften aufrufen
        s := '';
        CommentLine.SetRange("Table Name", CommentLine."Table Name"::Customer);
        CommentLine.SetRange("No.", cKundenNr);
        CommentLine.SetRange(BASShowNoteOrderPHA, true);
        if CommentLine.FindSet() then
            repeat
                s := s + CommentLine.Comment + '\';
            until CommentLine.Next() = 0;

        if s <> '' then
            Message(s);

        Clear(CommentLine);
    end;

    procedure BemerkungsmeldungAuftrag("Artikelnr.": Code[20])
    var
        CommentLine: Record "Comment Line";
        CommentText: Text;
    begin
        CommentText := '';
        CommentLine.SetCurrentKey("Table Name", "No.");
        CommentLine.SetRange("Table Name", CommentLine."Table Name"::Item);
        CommentLine.SetRange("No.", "Artikelnr.");
        CommentLine.SetRange(BASShowNoteOrderPHA, true);
        if CommentLine.FindSet() then
            repeat
                if CommentLine.Comment <> '' then begin
                    CommentText += CopyStr(CommentLine.Comment, 1,
                      MaxStrLen(CommentText) - StrLen(CommentText));
                    if MaxStrLen(CommentText) > StrLen(CommentText) then
                        CommentText += '\';
                end;
            until CommentLine.Next() = 0;

        if CommentText <> '' then
            Message(CopyStr(CommentText, 1, StrLen(CommentText) - 1));
    end;

    procedure BemerkungsmeldungAuftragGetText(ItemNo: Code[20]): Text
    var
        CommentLine: Record "Comment Line";
    begin
        CommentLine.SetCurrentKey("Table Name", "No.");
        CommentLine.SetRange("Table Name", CommentLine."Table Name"::Item);
        CommentLine.SetRange("No.", ItemNo);
        CommentLine.SetRange(BASShowNoteOrderPHA, true);
        // ToDo
        // if CommentLine.FindSet() then
        //     repeat
        //         if CommentLine.Comment <> '' then begin
        //             CommentLine.Comment += CopyStr(CommentLine.Comment, 1,
        //               MaxStrLen(CommentText) - StrLen(BemerkungsText));
        //             if MaxStrLen(BemerkungsText) > StrLen(BemerkungsText) then
        //                 CommentText += '\';
        //         end;
        //     until CommentLine.Next() = 0;
    end;

    procedure GetTextTeil(tText: Text[1000]; tSeparator: Text[10]; iSektion: Integer) tReturn: Text[1000]
    var
        iSek_lokal: Integer;
        pos: Integer;
        tRet_lokal: Text[250];
    begin
        //-GL010
        //Liefert aus einem Text mit Trennzeichen einen Teilbereich
        //z.B.: GetTextTeil('aa;bbbb;cccc;d;eee;',';',3)   ->  'cccc'

        tReturn := '';
        iSek_lokal := 1;
        pos := STRPOS(tText, tSeparator);
        if pos > 0 then begin
            //Bis zur geforderten Sektion weitergehen (wenn vorhanden)
            repeat
                //Text der derzzeitigen Sektion holen
                tRet_lokal := CopyStr(tText, 1, pos - 1);
                tText := CopyStr(tText, pos + StrLen(tSeparator), StrLen(tText));

                if iSek_lokal = iSektion then begin
                    tReturn := tRet_lokal;
                    pos := 0;
                end else begin
                    //Zur nächsten Sektion wechseln
                    pos := STRPOS(tText, tSeparator);
                    iSek_lokal += 1;
                end;

            until pos = 0;
        end;
        //+GL010
    end;

    procedure BemerkungsmeldungEKRechnung(KreditorenNr: Code[20])
    var
        Bemerkzeile: Record "Comment Line";
        BemerkungsText: Text[1000];
    begin
        //-GL013
        //Artikelbemerkungs Meldung vom Auftrag Aufrufen
        BemerkungsText := '';
        Bemerkzeile.SetCurrentKey("Table Name", "No.");
        Bemerkzeile.SetRange("Table Name", Bemerkzeile."Table Name"::Vendor);
        Bemerkzeile.SetRange("No.", KreditorenNr);
        // ToDo
        // Bemerkzeile.SetRange("Meldung in Einkauf Rechnung an", true);
        if Bemerkzeile.FindSet() then
            repeat
                if Bemerkzeile.Comment <> '' then begin
                    BemerkungsText += CopyStr(Bemerkzeile.Comment, 1,
                      MaxStrLen(BemerkungsText) - StrLen(BemerkungsText));
                    if MaxStrLen(BemerkungsText) > StrLen(BemerkungsText) then
                        BemerkungsText += '\';
                end;
            until Bemerkzeile.Next() = 0;

        if BemerkungsText <> '' then
            Message(CopyStr(BemerkungsText, 1, StrLen(BemerkungsText) - 1));
    end;

    procedure GetLagerplatzinhaltStichtag(cLagerort: Code[10]; cLagerplatz: Code[20]; cItemNo: Code[20]; dtStichtag_: Date) nReturn: Decimal
    var
        recWarehouseEntry: Record "7312";
    begin
        //-GL015
        nReturn := 0;

        recWarehouseEntry.Reset();
        recWarehouseEntry.SetCurrentKey("Location Code", "Bin Code", "Item No.", "Variant Code", "Registering Date", "Lot No.");

        recWarehouseEntry.SetFilter("Location Code", cLagerort);
        recWarehouseEntry.SetFilter("Bin Code", cLagerplatz);
        recWarehouseEntry.SetRange("Item No.", cItemNo);
        recWarehouseEntry.SetFilter("Registering Date", '..' + Format(dtStichtag_));

        recWarehouseEntry.CALCSUMS("Qty. (Base)");
        nReturn := recWarehouseEntry."Qty. (Base)";
    end;

    procedure CopyPurchaseLine(PurchaseLine3: Record "Purchase Line")
    var
        PurchaseLine: Record "Purchase Line";
        PurchaseLine2: Record "Purchase Line";
        NewLine: Integer;
        NextLine: Integer;
    begin
        PurchaseLine.Init();
        PurchaseLine.Copy(PurchaseLine);
        PurchaseLine2.Init();
        PurchaseLine2.SetRange("Document Type", PurchaseLine."Document Type");
        PurchaseLine2.SetRange("Document No.", PurchaseLine."Document No.");
        PurchaseLine2.SetFilter("Line No.", '>%1', PurchaseLine."Line No.");
        if PurchaseLine2.FindLast() then begin
            NextLine := PurchaseLine2."Line No.";
            NewLine := Round((NextLine + PurchaseLine."Line No.") / 2, 1)
        end else
            NewLine := PurchaseLine."Line No." + 10000;

        PurchaseLine."Line No." := NewLine;
        PurchaseLine."Qty. Rcd. Not Invoiced" := 0;
        PurchaseLine."Amt. Rcd. Not Invoiced" := 0;
        PurchaseLine."Quantity Received" := 0;
        PurchaseLine."Quantity Invoiced" := 0;
        PurchaseLine."Qty. Rcd. Not Invoiced (Base)" := 0;
        PurchaseLine."Qty. Received (Base)" := 0;
        PurchaseLine."Qty. Invoiced (Base)" := 0;
        PurchaseLine."Quantity (Base)" := 0;
        // ToDo
        // PurchaseLine."Urspr. Menge" := 0;
        PurchaseLine."Receipt No." := '';
        PurchaseLine."Receipt Line No." := 0;
        PurchaseLine.VALIDATE(Quantity, 0);
        PurchaseLine.BASLotNoPHA := '';
        // PurchaseLine.BASSalesLotNoPHA := '';
        PurchaseLine.BASExpirationDatePHA := 0D;
        PurchaseLine.Insert();
        PurchaseLine.VALIDATE("Shortcut Dimension 1 Code");
        PurchaseLine.Modify();
    end;

    procedure IsTextInTextTeil(tText: Text[1000]; tSeparator: Text[10]; tSearchText: Text[20]) bReturn: Boolean
    var
        iSek_lokal: Integer;
        pos: Integer;
        tRet_lokal: Text[250];
    begin

        //-GL017
        //Liefert aus einem Text mit Trennzeichen, ob ein Text in einem Teil ist
        //z.B.: IsTextInTextTeil('aa;bbbb;cccc;d;eee;',';','cccc')   ->  TRUE

        bReturn := false;
        iSek_lokal := 1;
        pos := STRPOS(tText, tSeparator);
        if pos > 0 then begin
            //Bis zur Sektion mit dem Suchtext weitergehen
            repeat
                //Text der derzzeitigen Sektion holen
                tRet_lokal := CopyStr(tText, 1, pos - 1);
                tText := CopyStr(tText, pos + StrLen(tSeparator), StrLen(tText));

                if tRet_lokal = tSearchText then begin
                    bReturn := true;
                    pos := 0;
                end else begin
                    //Zur nächsten Sektion wechseln
                    pos := STRPOS(tText, tSeparator);
                    iSek_lokal += 1;
                end;

            until pos = 0;
        end;
        if tText = tSearchText then //Gleich ohne Trennzeichen
            bReturn := true;
        //+GL017
    end;


    procedure TextAuffuellen(tText: Text[50]; iLaenge: Integer; tFuellzeichen: Text[1]) tReturn: Text[50]
    var
        iCounter: Integer;
    begin
        //-GL023
        //Füllt einen Text mit einem Textzeichen vorne sollange auf, bis die gewünschte Textlänge erreicht ist
        //Z.B.: 12 -> 00012

        tReturn := tText;
        iCounter := StrLen(tText);
        if (iCounter < iLaenge) then begin
            repeat
                tReturn := tFuellzeichen + tReturn;
                iCounter += 1;
            until iCounter >= iLaenge   //GL030 vorher:   iCounter>iLaenge
        end;
        //+GL023
    end;

    procedure RemoveChars(BCText: Text[250]; iCharAsciiCode: Integer) tBCReturn: Text[250]
    var
        iCounter: Integer;
    begin
        //-GL024
        iCounter := 1;
        while iCounter <= StrLen(BCText) do begin
            if not (BCText[iCounter] = iCharAsciiCode) then
                tBCReturn += CopyStr(BCText, iCounter, 1);
            iCounter += 1;
        end;
        //+GL024
    end;

    procedure KWInDatum(iKW: Integer; iJahr: Integer) dtReturn: Date
    var
        dtHelp: Date;
        iKWHelp: Integer;
    begin
        //-GL025

        //Jahresanfang ermitteln
        //dtHelp := CALCDATE('-LJ',TODAY);
        EVALUATE(dtHelp, '01.01.' + Format(iJahr));

        //Zur Ermittlung, ob 01.01 diesen Jahres KW1 oder KW53 ist
        EVALUATE(iKWHelp, Format(dtHelp, 0, '<Week,2><Filler Character,0>'));

        if iKWHelp = 1 then
            dtReturn := CALCDATE('+' + Format(iKW - 1) + 'W', dtHelp)
        else
            dtReturn := CALCDATE('+' + Format(iKW) + 'W', dtHelp);

        //Auf Wochenanfang konvertieren
        dtReturn := CALCDATE('-LW', dtReturn);
        //+GL025
    end;

    procedure EKBemerkungsmeldung(VendorNo: Code[20])
    var
        CommentLine: Record "Comment Line";
        CommentText: Text;
    begin
        CommentLine.SetCurrentKey("Table Name", Code, Date, BASShowNotePurchaseInvoicePHA);
        CommentLine.SetRange("Table Name", CommentLine."Table Name"::Vendor);
        CommentLine.SetRange("No.", VendorNo);
        CommentLine.SetRange(BASShowNotePurchaseInvoicePHA, true);
        if CommentLine.FindSet() then begin
            repeat
                if CommentLine.Comment <> '' then begin
                    CommentText += CopyStr(CommentLine.Comment, 1,
                      MaxStrLen(CommentText) - StrLen(CommentText));
                    if MaxStrLen(CommentText) > StrLen(CommentText) then
                        CommentText += '\';
                end;
            until CommentLine.Next() = 0;

            if CommentText <> '' then
                Message(CopyStr(CommentText, 1, StrLen(CommentText) - 1));

        end;
    end;

    procedure GetWFScompatibleString(tOriginal: Text[250]) tFormatted: Text[250]
    var
        tTemp: Text[250];
    begin
        tTemp := CONVERTSTR(tOriginal, '<', '-');
        tTemp := CONVERTSTR(tTemp, '>', '-');
        tTemp := CONVERTSTR(tTemp, ':', '.');
        tTemp := CONVERTSTR(tTemp, '"', '_');
        tTemp := CONVERTSTR(tTemp, '/', '_');
        tTemp := CONVERTSTR(tTemp, '\', '_');
        tTemp := CONVERTSTR(tTemp, '|', '-');
        tTemp := CONVERTSTR(tTemp, '?', '_');
        tTemp := CONVERTSTR(tTemp, '*', '_');
        tFormatted := tTemp;
    end;

    procedure RemoveBadChars(BCText: Text[250]) tBCReturn: Text[250]
    var
        iCounter: Integer;
    begin

        iCounter := 1;
        while iCounter <= StrLen(BCText) do begin
            if not ((BCText[iCounter] = 9) or (BCText[iCounter] = 13) or (BCText[iCounter] = 10)) then
                tBCReturn += CopyStr(BCText, iCounter, 1);
            iCounter += 1;
        end;
    end;

    procedure BemerkungsmeldungUmlagerung("Artikelnr.": Code[20])
    var
        CommentLine: Record "Comment Line";
        CommentText: Text;
    begin
        CommentText := '';
        CommentLine.SetCurrentKey("Table Name", "No.");
        CommentLine.SetRange("Table Name", CommentLine."Table Name"::Item);
        CommentLine.SetRange("No.", "Artikelnr.");
        // ToDo
        // Bemerkzeile.SetRange("Meldung bei Umlagerung", true);
        if CommentLine.FindSet() then
            repeat
                if CommentLine.Comment <> '' then begin
                    CommentText += CopyStr(CommentLine.Comment, 1,
                      MaxStrLen(CommentText) - StrLen(CommentText));
                    if MaxStrLen(CommentText) > StrLen(CommentText) then
                        CommentText += '\';
                end;
            until CommentLine.Next() = 0;

        if CommentText <> '' then
            Message(CopyStr(CommentText, 1, StrLen(CommentText) - 1));
    end;
}