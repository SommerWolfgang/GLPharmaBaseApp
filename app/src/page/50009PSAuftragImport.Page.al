
//TASK29.01     07.05.2024   MFU: Auftrag Imort PS Pharma

page 50018 PS_Auftrag_Import
{
    // version Schenker,PS

    // 
    // 
    // Datum      | Autor   | Status     | Beschreibung
    // --------------------------------------------------------------------------------------------------------
    // 2018-04-23 | MFU     | ok         | GL001 - Anpassungen EDI Import
    // --------------------------------------------------------------------------------------------------------
    // 2019-10-16 | MFU     | ok         | GL002 - Schenker Anpassungen
    // --------------------------------------------------------------------------------------------------------


    layout
    {
        area(content)
        {
            /*
            field(FileName; FileName)
            {
                ApplicationArea = All;
                Caption = 'Dateiname';

                trigger OnAssistEdit()                
                begin

                  //FileManagement.GetFileName()
                  //!!!!!! FileName := FileManagement.OpenFileDialog('Import Datei','*.csv','');
                  //UploadFile(FileName);
                end;

            }
            */

            field(dtAuftragsdatum; dtAuftragsdatum)
            {
                ApplicationArea = All;
                Caption = 'Datum';
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Import PS Aufträge")
            {
                ApplicationArea = All;
                Image = Import;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    cFileEnd: Code[20];
                begin

                    //cFileEnd := UPPERCASE(GetFileEnding(FileName));
                    //IF cFileEnd <> 'CSV' THEN
                    //    ERROR('Es sind nur CSV-Dateien zulässig!');

                    //ImportBestellungXML(FileName);

                    ImportPSPharmaAuftraegeCSV(FileName);
                end;
            }
        }
    }

    var
        recCSVBuffer: Record "CSV Buffer";

    trigger OnOpenPage()
    begin

        IF recTmpItem.COUNT > 0 THEN
            ERROR('Variable nicht Temporär!');

        IF (USERID <> 'FUERBASST1') AND (USERID <> 'FUERBASS') THEN
            ERROR('Funktion nicht Freigegeben!');

        dtAuftragsdatum := TODAY;
    end;

    var
        recTmpItem: Record "27" temporary;
        FileManagement: Codeunit "419";
        dtAuftragsdatum: Date;
        ImportFileCaption: Label 'Importierte Datei';
        FileName: Text;
        ServerFileName: Text;
        tFertigstellungsmeldung: Text;

    procedure UploadFile(FileName: Text)
    var
        cFileEnd: Code[20];

    begin

        CLEAR(ServerFileName);
        IF FileName = '' THEN
            EXIT;

    end;

    procedure GetFileEnding(tFileName: Text) cFileEndung: Code[20]
    var
        iLen: Integer;
    begin
        CLEAR(cFileEndung);

        iLen := STRLEN(tFileName);
        WHILE (tFileName[iLen] <> '.') OR (iLen < 1) DO
            iLen -= 1;

        IF iLen = 0 THEN
            ERROR('Keine Dateiendung gefunden!');

        cFileEndung := COPYSTR(tFileName, iLen + 1, STRLEN(tFileName));
        EXIT(cFileEndung);
    end;

    procedure ShowAuftragHeaderInfo(cKundenNr_: Code[20])
    var
        recCommentLine: Record "97";
        s: Text[500];
    begin

        s := '';
        recCommentLine.SetRange("Table Name", recCommentLine."Table Name"::Customer);
        recCommentLine.SetRange("No.", cKundenNr_);
        recCommentLine.SetRange("Meldung in VK-Auftrag anzeigen", TRUE);
        IF recCommentLine.FIND('-') THEN
            REPEAT
                IF STRLEN(s + recCommentLine.Comment) > 250 THEN
                    //ALT:  s:= s + COPYSTR(recCommentLine.Comment, 1, 250 - STRLEN(s) - 5) + ' ...->'
                    s := s + ' ...->'
                ELSE
                    s := s + recCommentLine.Comment + '\';  //der backslash ersetzt #13
            UNTIL recCommentLine.NEXT = 0;
        IF s <> '' THEN Message(s);
        CLEAR(recCommentLine);
    end;

    procedure GetErsatzartikel(sItemNo: Code[20]) cItemNoReturn: Code[20]
    var
        recItem_: Record "27";
        recItemSubstitution: Record "5715";
    begin

        cItemNoReturn := '';
        IF recItem_.GET(sItemNo) THEN BEGIN

            recItem_.CALCFIELDS("Substitutes Exist");
            IF recItem_."Substitutes Exist" = TRUE THEN BEGIN
                recItemSubstitution.SetRange("No.", recItem_."No.");
                IF recItemSubstitution.FindFirst THEN
                    cItemNoReturn := recItemSubstitution."Substitute No.";
            END;

        END;
    end;

    procedure InsertExtendedText(recSL_: Record "37"; Unconditionally: Boolean)
    var
        TransferExtendedText: Codeunit "378";
    begin
        IF TransferExtendedText.SalesCheckIfAnyExtText(recSL_, Unconditionally) THEN BEGIN
            CurrPage.SAVERECORD;
            COMMIT;
            TransferExtendedText.InsertSalesExtText(recSL_);
        END;
    end;

    /*
    //Noch aktivieren / einbauen??
    procedure VerschiebeImportierteDatei(tDateiPfad: Text)
    var
        iHelp: Integer;
        wshFSO: Automation ;
        cuCodeSammlung: Codeunit "50500";
        tOrdnerPfad: Text;
        tOrdnerPfadTarget: Text;
        tDateiName: Text;
    begin

        //-GL001

        CREATE(wshFSO,FALSE,TRUE);
        tDateiName := wshFSO.GetFileName(tDateiPfad);
        tOrdnerPfad := wshFSO.GetParentFolderName(tDateiPfad);
        tOrdnerPfadTarget := wshFSO.BuildPath(tOrdnerPfad,'Archiv');
        IF wshFSO.FolderExists(tOrdnerPfadTarget) = FALSE THEN BEGIN
          //Unterordner erstellen
          wshFSO.CreateFolder(tOrdnerPfadTarget);
        END;
        wshFSO.MoveFile(tDateiPfad,tOrdnerPfadTarget+'\\Imp_'+tDateiName);

        //+GL001
    end;
    */

    procedure ImportPSPharmaAuftraegeCSV(tDateiPfad: Text)
    var
        recSalesPerson: Record "13";
        recCust: Record "18";
        recItem: Record "27";
        recSH: Record "36";
        recTempSH: Record "36" temporary;
        recSL: Record "37";
        recTempSL: Record "37" temporary;
        recGebVKRech: Record "112";
        recLot: Record "Lot No. Information";
        cuSalesPriceCalcMgt: Codeunit "7000";
        cuChargenverwaltung: Codeunit ChargenverwaltungPageApp;
        cuCodesammlung: Codeunit Codesammlung;
        InputFileManagement: Codeunit "File Management";
        pTest: Page 348;
        bAuftragsKopfErstelltVorhanden: Boolean;
        bAuftragsNrGefunden: Boolean;
        cAuftragNr: Code[20];
        cAuftragNrVorher: Code[20];
        cKunde: Code[20];
        cKundenNr: Code[20];
        tCharge: Code[20];
        cAuftragNrVorhanden: Code[50];
        dtLieferdatum: Date;
        dMenge: Decimal;
        InputFile: File;

        //recCSVBuffer: Record "CSV Buffer";
        InS: InStream;
        iAuftraegeAngelegt: Integer;
        iAuftraegeDatei: Integer;
        iLine: Integer;
        iLinesInRecord: Integer;
        iPos: Integer;
        iZeilennrIntern: Integer;
        tMatNr: Text[20];
        tExtBelegNr: Text[50];
        tReferenz: Text[50];
        tRef: Text[100];
        tRefVorher: Text[100];
        FileName: Text[250];
        tBemerkung: Text[250];
        tLine: Text[1024];

    begin

        //Öffnen der XML Datei und Durchparsen

        //Löschen der Temp Tabelle, sonst werden beim offen lassen der Page Artikel doppelt angelegt
        CLEAR(recTmpItem);
        recTmpItem.DELETEALL(FALSE);

        tFertigstellungsmeldung := '';
        iLine := 1;
        iAuftraegeDatei := 0;
        iAuftraegeAngelegt := 0;

        if UploadIntoStream('PS Auftraege', '', '', FileName, InS) then begin
            recCSVBuffer.DeleteAll(false);
            recCSVBuffer.LoadDataFromStream(InS, ';');
            iLinesInRecord := recCSVBuffer.GetNumberOfLines();

            IF iLinesInRecord > 1 then
                repeat

                    //BC23 InputFile.READ(tLine);
                    //tLine += ';';

                    IF iLine > 1 THEN BEGIN

                        //Spalten in Variablen schreiben (von Record, nicht rausschneiden wie im NAV2013)
                        cAuftragNr := GetValueAtCell(iLine, 26);
                        cKunde := GetValueAtCell(iLine, 16);
                        tRef := GetValueAtCell(iLine, 1);
                        Evaluate(iPos, GetValueAtCell(iLine, 18));
                        tMatNr := GetValueAtCell(iLine, 19);
                        Evaluate(dMenge, GetValueAtCell(iLine, 21));
                        tCharge := GetValueAtCell(iLine, 22);


                        IF dMenge > 0 THEN begin

                            //Wenn die Sendungsverfolgung leer ist
                            IF cAuftragNr = '' THEN BEGIN
                                //Bei einem Chargenwechsel die vorherige Auftragsnummer nehmen (ist dann leer) -> Die Referenz muss aber zur vorherigen Zeile passen
                                IF tRefVorher = tRef THEN BEGIN
                                    cAuftragNr := cAuftragNrVorher;
                                END ELSE BEGIN
                                    cAuftragNr := tRef;    //Die Auftragsnummer ist leer alternativ als eindeutige Kennung die Referenz nehmen
                                END;
                            END;

                            bAuftragsKopfErstelltVorhanden := FALSE;

                            //Temp Kopf anlegen, wenn neue Auftragsnummer
                            IF cAuftragNrVorher <> cAuftragNr THEN BEGIN
                                iAuftraegeDatei += 1;
                                iZeilennrIntern := 10000;

                                recTempSH.SetRange("No.", cAuftragNr);
                                IF recTempSH.FindFirst = FALSE THEN BEGIN
                                    CLEAR(recTempSH);
                                    recTempSH.INIT;
                                    recTempSH."No." := cAuftragNr;
                                    recTempSH."Your Reference" := tRef;
                                    recTempSH.Ladehilfsmittel := cAuftragNr;  //Feld im Kopf für die PS Auftragsnr verwenden
                                    recCust.SetRange("No.", cKunde);
                                    IF recCust.FindFirst THEN BEGIN
                                        recTempSH."Sell-to Customer No." := recCust."No.";
                                        recTempSH.INSERT(FALSE);

                                        bAuftragsKopfErstelltVorhanden := TRUE;
                                    END ELSE BEGIN
                                        Message('Auftrag %1 konnte nicht erstellt werden. Kunde %2 nicht gefunden!', tRef, cKunde);
                                    END;
                                END;

                            END ELSE BEGIN
                                bAuftragsKopfErstelltVorhanden := TRUE;
                            END;
                            cAuftragNrVorher := cAuftragNr;
                            tRefVorher := tRef;


                            //Temp Zeilen anlegen
                            IF bAuftragsKopfErstelltVorhanden = TRUE THEN BEGIN
                                recItem.SetRange("Pharmazentralnr.", tMatNr);
                                IF recItem.FindFirst THEN BEGIN
                                    CLEAR(recTempSL);
                                    recTempSL."Document Type" := recTempSL."Document Type"::Order;
                                    recTempSL."Document No." := recTempSH."No.";
                                    recTempSL."Line No." := iZeilennrIntern;
                                    iZeilennrIntern += 10000;
                                    recTempSL."No." := recItem."No.";
                                    recTempSL.Quantity := dMenge;
                                    recTempSL."Lot No." := tCharge;
                                    //Charge noch dazu!

                                    recTempSL.INSERT(FALSE);

                                END;
                            END;
                        END;
                    END;

                    iLine += 1;

                until iLine > iLinesInRecord;

            if 1 = 1 then begin   //deaktivieren zum testen

                //Erstellen der Aufträge nach dem Import
                CLEAR(recTempSH);
                IF recTempSH.FINDSET THEN
                    REPEAT

                        //Gibt es den Auftrag schon (InAufträgen oder geb.Rechnung)? (Auf externe Belegnr prüfen)
                        bAuftragsNrGefunden := FALSE;
                        CLEAR(recSH);
                        recSH.SetRange("External Document No.", recTempSH.Ladehilfsmittel);
                        IF recSH.COUNT > 0 THEN BEGIN
                            bAuftragsNrGefunden := TRUE;
                            cAuftragNrVorhanden := recSH."No.";
                        END;
                        IF bAuftragsNrGefunden = FALSE THEN BEGIN
                            CLEAR(recGebVKRech);
                            recGebVKRech.SetRange("External Document No.", recTempSH.Ladehilfsmittel);
                            IF recGebVKRech.COUNT > 0 THEN BEGIN
                                bAuftragsNrGefunden := TRUE;
                                cAuftragNrVorhanden := recGebVKRech."No.";
                            END;
                        END;

                        IF bAuftragsNrGefunden = TRUE THEN
                            IF CONFIRM('Der Auftrag %1 ist mit %2 schon vorhanden! Neuen Auftrag erstellen?', FALSE, recTempSH.Ladehilfsmittel, cAuftragNrVorhanden) = TRUE THEN
                                bAuftragsNrGefunden := FALSE;

                        //Anlegen des Auftrag, wenn kein selber Auftrag gefunden wurde, oder es bestättigt wurde
                        IF bAuftragsNrGefunden = FALSE THEN BEGIN
                            //Neuer Auftragskopf anlegen
                            CLEAR(recSH);
                            recSH.INIT;
                            recSH."Document Type" := recSH."Document Type"::Order;
                            recSH.INSERT(TRUE);
                            recSH.VALIDATE("Sell-to Customer No.", recTempSH."Sell-to Customer No.");
                            recSH."Your Reference" := recTempSH."Your Reference";
                            recSH.VALIDATE("Posting Date", dtAuftragsdatum);     //Datum in Auftrag schreiben                    
                            //BC23! recSH."Desired Delivery Date" := dtAuftragsdatum;     //Gewünschtes Lieferdatum
                            IF recSalesPerson.GET(USERID) THEN
                                recSH."Salesperson Code" := recSalesPerson.Code;
                            recSH."External Document No." := recTempSH.Ladehilfsmittel;  //PS-Pharma Auftragsnummer merken

                            recSH.MODIFY(TRUE);
                            //ShowAuftragHeaderInfo(recTempSH."Sell-to Customer No.");   //Kundeninfo Anzeigen
                            iAuftraegeAngelegt += 1;

                            //Artikelzeilen anlegen
                            CLEAR(recTempSL);
                            recTempSL.SetRange("Document No.", recTempSH."No.");
                            IF recTempSL.FindFirst THEN BEGIN

                                //Textzeile mit PS-Pharma Auftragsnummer anlegen
                                IF (recTempSH.Ladehilfsmittel > '') THEN BEGIN
                                    CLEAR(recSL);
                                    recSL.INIT;         //Document Type,Document No.,Line No.
                                    recSL."Document Type" := recSL."Document Type"::Order;
                                    recSL."Document No." := recSH."No.";
                                    recSL."Line No." := 500;
                                    recSL.INSERT(TRUE);
                                    recSL.Type := recSL.Type::" ";
                                    recSL.Description := recTempSH.Ladehilfsmittel;
                                    recSL.MODIFY(TRUE);
                                END;

                                REPEAT

                                    CLEAR(recSL);
                                    recSL.INIT;
                                    recSL."Document Type" := recSL."Document Type"::Order;
                                    recSL."Document No." := recSH."No.";
                                    recSL."Line No." := recTempSL."Line No.";
                                    recSL.INSERT(TRUE);

                                    recSL.Type := recSL.Type::Item;
                                    recSL.VALIDATE("No.", recTempSL."No.");
                                    recSL.VALIDATE(Quantity, recTempSL.Quantity);
                                    //recSL.VALIDATE("Lot No.", recTempSL."Lot No.");
                                    recSL.VALIDATE(Quantity);  //Teilmenge Validate wegen Preise Update
                                    recSL."Location Code" := recSH."Location Code";

                                    InsertExtendedText(recSL, FALSE);    //Artikelinfo in Zeilenspalte anzeigen

                                    recSL.MODIFY;

                                    if CheckCharge(recTempSL."No.", recTempSL."Lot No.") then begin
                                        //Chargennr aus VK-Charge holen
                                        CLEAR(recLot);
                                        recLot.SetRange("Item No.", recTempSL."No.");
                                        recLot.SetRange("Verkaufschargennr.", recTempSL."Lot No.");
                                        //Weitermachen!

                                        IF recLot.FindFirst THEN BEGIN
                                            // ResPosten zu VK Zeile erstellen
                                            recSL."Lot No." := recLot."Lot No.";
                                            cuChargenverwaltung.EingabeChargeForSalesLine(recSL);
                                            /*
                                            LotMgt.EingabeCharge(
                                            DATABASE::"Sales Line", recVKLine."Document Type", recVKLine."Document No.", '', 0, recVKLine."Line No.",
                                            recVKLine."Qty. per Unit of Measure", recVKLine.Quantity, recVKLine."Qty. to Invoice (Base)",
                                            recLot."Lot No.", recLot."External Lot No.", '', '', recLot."Expiration Date",
                                            recVKLine."No.", recVKLine."Variant Code", recVKLine."Location Code", recVKLine."Shipment Date");
                                            */
                                        END;

                                    end;

                                UNTIL recTempSL.NEXT = 0;

                            END;
                        END;
                    UNTIL recTempSH.NEXT = 0;

            end;

            //-GL001
            //Verschieben der importierten Datei in einen Unterordner
            //VerschiebeImportierteDatei(tDateiPfad);
            //+GL001
        end;

        Message('%1 Aufträge in Datei, %2 Aufträge angelegt', iAuftraegeDatei, iAuftraegeAngelegt);   //Endmeldung
    end;


    local procedure GetValueAtCell(RowNo: Integer; ColNo: Integer): Text
    begin
        if recCSVBuffer.Get(RowNo, ColNo) then
            exit(recCSVBuffer.Value)
        else
            exit('');
    end;

    local procedure CheckCharge(cItemNo: Code[20]; cExtLot: Code[50]): Boolean
    var
        recLotNoInformation: Record "Lot No. Information";
        bReturn: Boolean;
    begin
        bReturn := FALSE;
        recLotNoInformation.SetRange("Item No.", cItemNo);
        recLotNoInformation.SetRange("Verkaufschargennr.", cExtLot);
        IF recLotNoInformation.FINDSET THEN BEGIN
            IF STRLEN(recLotNoInformation."Lot No.") > 0 THEN
                bReturn := TRUE;
        END;

        EXIT(bReturn);
    end;
}

