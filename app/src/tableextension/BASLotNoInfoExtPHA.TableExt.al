tableextension 50027 BASLotNoInfoExtPHA extends "Lot No. Information"
{
    // Datum      | Autor   | Status     | Beschreibung
    // ------------------------------------------------------------------------------------------------------------------------------------
    // 2010-01-15 | Petsch  | ok         | Update von 360
    // ------------------------------------------------------------------------------------------------------------------------------------
    // 2010-04-12 | Petsch  | ok         | GL003
    // ------------------------------------------------------------------------------------------------------------------------------------
    // 2010-07-07 | MFU     | ok         | GL004 Umbenennen von Chargen auf schon vorhandene bei Rohstoff u Verpackung verhindern
    // ------------------------------------------------------------------------------------------------------------------------------------
    // 2010-08-19 | Petsch  | ok         | In CheckComponents hat IF recItemLedgerEntry1.FIND('-') THEN gefehlt
    // ------------------------------------------------------------------------------------------------------------------------------------
    // 2011-01-18 | Rieder  | ok         | GL010 Besonderheiten für Standort Wien nachgezogen (log)
    // ------------------------------------------------------------------------------------------------------------------------------------
    // 2011-04-28 | Rieder  | ok         | GL011 Unterstufenprüfung mit den Parametern Loop=true und BulkOnly=no aufrufen (log)
    // ------------------------------------------------------------------------------------------------------------------------------------
    // 2011-09-28 | MFU     | ok         | GL012 Gehalt nur mit Nachfrage ändern, wenn schon einmal als Verbrauch gebucht wurde
    // ------------------------------------------------------------------------------------------------------------------------------------
    // 2012-02-17 | MFU     | ok         | GL013 Bei Chargennummernänderung auch die Chargen in der Analyse-DB mit ändern
    // ------------------------------------------------------------------------------------------------------------------------------------
    // 2013-05-15 | MFU     | ok         | GL014 Bei Chargennummernänderung auch die Chargen in der Analyse-DB Header und Line mit ändern
    // ------------------------------------------------------------------------------------------------------------------------------------
    // 2013-05-23 | MFU     | ok         | GL015 "Beschreibung 2" aus Fertigungsauftrag mittels Lookup übernehmen
    //                                             (Zur Erkennung von Umpackaufträgen im Chargenstamm)
    // ------------------------------------------------------------------------------------------------------------------------------------
    // 2013-07-02 | MFU     | ok         | GL016 Meldung bei Statusänderung wenn es eine Validierungscharge ist
    // ------------------------------------------------------------------------------------------------------------------------------------
    // 2015-08-17 | Petsch  | ok         | Status - OnValidate: wieder Code wie in Nav2009 eingebaut, in Lannach ist Unterstufenprüfung
    //                                     in alle Ebenen nicht möglich, da die Tablettenkerne nie freigegeben werden
    // ------------------------------------------------------------------------------------------------------------------------------------
    // 2015-09-24 | MFU     | ok         | Textlänge des Feldes "Artikelname" von 40 auf 50 erhöht (Anpassung an Artikelstamm wegen Fehler in Chargenstamm)
    // ------------------------------------------------------------------------------------------------------------------------------------
    // 2015-09-29 | MFU     | ok         | Feld ArtikelPackungsgröße eingebaut (In Chargenstamm Liste benötigt)
    // ------------------------------------------------------------------------------------------------------------------------------------
    // 2015-12-09 | Petsch  | ok         | in Lannach: Freigabedatum + Name nur bei Status=Frei, Anforderung Jutta Eberl
    // ------------------------------------------------------------------------------------------------------------------------------------
    // 2016-10-17 | MFU     | ok         | GL020 - Bei Chargenfreigabe an Mepis die Freigabeaufforderung senden
    // ------------------------------------------------------------------------------------------------------------------------------------
    // 2017-05-04 | MFU     | ok         | "Field Groups" eintrag erstellt um bei Schnellauswahl richtige Spalten anzuzeigen
    // ------------------------------------------------------------------------------------------------------------------------------------
    // 2017-10-19 | MFU     | ok         | GL021 - Marktfreigabe Pin bei Statusänderung der Charge  (NOCH NICHT AKTIV)
    // ------------------------------------------------------------------------------------------------------------------------------------
    // 2017-11-14 | MFU     | ok         | GL022 - "Patentschutz bis" bei Chargenfreigabe eines Fertigartikel prüfen
    // ------------------------------------------------------------------------------------------------------------------------------------
    // 2017-11-30 | MFU     | ok         | GL023 - Zusammenfürhung der Chargenfreigabe LAn / WIEN
    // ------------------------------------------------------------------------------------------------------------------------------------
    // 2018-04-09 | MFU     | ok         | GL024 - ERROR statt MESSAGE bei MEPIS Prüfung
    // ------------------------------------------------------------------------------------------------------------------------------------
    // 2018-04-17 | MFU     | ok         | GL025 - Freigabepin nicht anzeigen, wenn keine Statusänderung erfolgte
    //                                             Bei nächsten Change Aktivieren  !!!!!!!!!!!!!!!!!!!!!!!!!!!
    // ------------------------------------------------------------------------------------------------------------------------------------
    // 2018-06-14 | MFU     | ok         | GL026 - Prüfungen von P50192 in Tabelle übertragen
    // ------------------------------------------------------------------------------------------------------------------------------------
    // 2017-12-21 | MFU     | ok         | Projekt Rohstoffprüfbericht: MIBI Charge Merker (Bool) eingebaut
    // ------------------------------------------------------------------------------------------------------------------------------------
    // 2018-08-24 | MFU     | ok         | GL027 - Marktfreigabe Pin Abbrechen Fehler, wenn richtiger Pin Vorhanden
    // ------------------------------------------------------------------------------------------------------------------------------------
    // 2018-09-04 | DKO     | ok         | Neue Spalte "CEP Nr" - Für LQ18 - Lieferantenqualifizierung
    // ------------------------------------------------------------------------------------------------------------------------------------
    // 2018-09-24 | MFU     | ok         | GL028 - Mit einem COMMIT den Chargenstatus im NAV und MEPIS fix auf das gleiche setzen
    // ------------------------------------------------------------------------------------------------------------------------------------
    // 2018-12-18 | DKO     | ok         | GL029 - HerstellerNr & CEP Nr für CEP, LQ18 Change hinzugefügt
    // ------------------------------------------------------------------------------------------------------------------------------------
    // 2018-12-18 | DKO     | ok         | GL030 - Ablaufdatum DataMatrix Feld für EU-Hub hinzugefügt.
    // ------------------------------------------------------------------------------------------------------------------------------------
    // 2019-01-15 | MFU     | ok         | GL031 - Chargenfreigabe bei serialisierten HW Artikel verbessert
    // ------------------------------------------------------------------------------------------------------------------------------------
    // 2019-01-29 | DKO     | ok         | GL032 - Neues Feld "HF Kommentar" für Kommentare bei Halbfabrikat
    //                                             --> Anzeige bei Freigabe von Fertigprodukt
    // ------------------------------------------------------------------------------------------------------------------------------------
    // 2019-01-16 | MFU     | ok         | GL033 - "Vermarktungsexklusivität bis" bei Chargenfreigabe eines Fertigartikels prüfen
    // ------------------------------------------------------------------------------------------------------------------------------------
    // 2019-02-25 | DKO     | ok         | GL034 - Bei Freigabe von Handelsware, wenn MEPIS Fehler meldet --> CONFIRM ob trotzdem freigeben
    //                                           - statt nur MESSAGE
    // ------------------------------------------------------------------------------------------------------------------------------------
    // 2019-03-29 | DKO     | ok         | GL035 - CheckCepChange - Bei Änderung von CEP Nr. Benachrichtigung an QS per Mail
    // ------------------------------------------------------------------------------------------------------------------------------------
    // 2019-04-05 | DKO     | ok         | GL036 - ShowHerstellerLookup - Für nachträgliche Änderung der HerstellerNr ein Lookup Bereitstellen.
    //                                           - CheckHerstellerChange - Wenn HerstellerNr geändert, dann Änderung in Lieferzeile zurückschreiben
    //                                           - GetVendorNo - LieferantenNr der aktuellen Chargenstammzeile ermitteln
    // ------------------------------------------------------------------------------------------------------------------------------------
    // 2019-04-18 | DKO     | ok         | GL037 - Meldung bei fehlender Istmeldung in Zukunft ERROR
    //                                           - Wenn Artikel bereits Zertifiziert war, jetzt aber nicht --> Chargenfreigabe nicht möglich
    // ------------------------------------------------------------------------------------------------------------------------------------
    // 2019-11-27 | DKO     | ok         | GL038 - Freigabedatum/-Name nur setzen wenn tatsächlich Freigeben wird.
    //                                           - "Anzahl Freigaben" - Flowfield auf Änderungsprotokollposten --> Anzahl wie oft Status einer Charge auf "Frei" geändert wurde
    // ------------------------------------------------------------------------------------------------------------------------------------
    // 2020-07-13 | DKO     | ok         | GL039 - LIMS Anpassungen
    // ------------------------------------------------------------------------------------------------------------------------------------
    // 2021-01-14 | MFU     | ok         | GL040 - Offen Hakerl bei Änderungsanzeige auslassen
    // ------------------------------------------------------------------------------------------------------------------------------------
    // 2021-04-16 | DKO     | ok         | GL041 - Fremdverpackungs FW ohne ständige Anpassung freigebbar
    // ------------------------------------------------------------------------------------------------------------------------------------
    // 2021-05-04 | DKO     | ok         | GL042 - Fremdverpackungs FW ohne ständige Anpassung freigebbar - Trotzdem Versuch der Meldung an MEPIS
    // ------------------------------------------------------------------------------------------------------------------------------------
    fields
    {


        field(50000; "BASExpiration DatePHA"; Date)
        {
            Caption = 'Expiration Date';
            Description = 'LAN1.00';

            trigger OnValidate()
            var
                ChargenVerw: Codeunit Chargenverwaltung;


            begin

                IF Rec."Expiration Date" <> xRec."Expiration Date" THEN
                    ChargenVerw."Aktualisiere Verkaufscharge"("Item No.", "Lot No.", 1, "Verkaufschargennr.", "Expiration Date");

                IF STRPOS("Change Status", 'E') = 0 THEN
                    "Change Status" := "Change Status" + 'E';

            end;
        }
        field(50001; "BASVerkaufschargennr.PHA"; Code[20])
        {
            Description = 'LAN1.00';

            trigger OnValidate()
            var
                ChargenVerw: Codeunit Chargenverwaltung;
            begin
                //-LAN002
                ChargenVerw."Aktualisiere Verkaufscharge"("Item No.", "Lot No.", 0, "Verkaufschargennr.", "Expiration Date");
                //+LAN002

                //-GL009
                IF STRPOS("Change Status", 'V') = 0 THEN
                    "Change Status" := "Change Status" + 'V';
                //+GL009
            end;
        }
        field(50002; "BASLief. Chargennr.PHA"; Code[20])
        {
            Description = 'LAN1.00';

            trigger OnValidate()
            begin
                //-GL009
                IF STRPOS("Change Status", 'D') = 0 THEN
                    "Change Status" := "Change Status" + 'D';
                //+GL009
            end;
        }
        field(50003; "BASLief. AblaufdatumPHA"; Date)
        {
            Description = 'LAN1.00';
        }
        field(50004; BASOpenPHA; Boolean)
        {
            Caption = 'Open';
            Description = 'LAN1.00';
        }
        field(50005; BASFreigabedatumPHA; Date)
        {
            Description = 'LAN1.00';
        }
        field(50006; BASFreigabenamePHA; Text[50])
        {
            Description = 'LAN1.00';
        }
        field(50007; BASGehaltPHA; Decimal)
        {
            Description = 'LAN1.00';

            trigger OnValidate()
            var
                ItemLedgEntry: Record "Item Ledger Entry";
            begin


                //-GL012
                //Prüfen, ob die Charge schon in einer Verbrauchsbuchung vorhanden ist, wenn ja dann eine Meldung mit Bestättigung anzeigen
                ItemLedgEntry.RESET();
                ItemLedgEntry.SETCURRENTKEY("Item No.", "Lot No.");
                ItemLedgEntry.SETRANGE("Item No.", "Item No.");
                ItemLedgEntry.SETRANGE("Lot No.", "Lot No.");
                ItemLedgEntry.SETRANGE("Entry Type", ItemLedgEntry."Entry Type"::Consumption);
                IF NOT ItemLedgEntry.IsEmpty THEN
                    IF CONFIRM('Die Charge ist in Verbrauchsbuchungen vorhanden! Trotzdem ändern?', FALSE) = FALSE THEN
                        ERROR('Änderung wurde nicht durchgeführt.');
                //+GL012

                //-GL009
                IF STRPOS("Change Status", 'G') = 0 THEN
                    "Change Status" := "Change Status" + 'G';
                //+GL009

            end;
        }
        field(50008; BASLaborkommentarPHA; Text[100])
        {
            Description = 'LAN1.00';

            trigger OnValidate()
            begin
                //-GL009
                IF STRPOS("Change Status", 'M') = 0 THEN
                    "Change Status" := "Change Status" + 'M';
                //+GL009

            end;
        }
        field(50009; "BASLaetus-CodePHA"; Text[15])
        {
            Description = 'LAN1.00';

        }
        field(50010; BASStatusPHA; Option)
        {
            Description = 'LAN1.00';
            OptionCaption = 'Quarantine,Free,Blocked';
            OptionMembers = "Quarantäne",Frei,Gesperrt;

            trigger OnValidate()
            var
                recItem: Record "27";

                recItemPosten: Record "32";
                recProdOrder: Record "5405";
                cuNaviPharma: Codeunit NaviPharma;
                bLotStatusMismatch: Boolean;

                bOK: Boolean;
                iChargenStatus: Integer;
                iReturn: Integer;
                cInfoText: Text;

                cText: Text;
                tmpTxt: Text;
                tReturn: Text[100];
            begin
                //-GL038
                /*
                //-LAN002
                IF (Status = Status::Frei) AND (xRec.Status <> Status::Frei) THEN BEGIN
                  IF Freigabedatum = 0D THEN
                    Freigabedatum := TODAY;
                  IF Freigabename = '' THEN
                    Freigabename := USERID;
                END;
                //+LAN002
                */
                //+GL038

                //-GL039
                bLotStatusMismatch := FALSE;
                CASE Rec.Status OF
                    Rec.Status::Frei:
                        BEGIN
                            IF STRPOS(UPPERCASE(Rec.LimsStatus), 'FREI') = 0 THEN //FREI, FREIGEGEBEN
                                bLotStatusMismatch := TRUE;
                        END;
                    Rec.Status::Quarantäne:
                        BEGIN
                            IF STRPOS(UPPERCASE(Rec.LimsStatus), 'QUARANT') = 0 THEN //QUARANTINE, QUARANTÄNE
                                bLotStatusMismatch := TRUE;
                        END;
                    Rec.Status::Gesperrt:
                        BEGIN
                            IF STRPOS(UPPERCASE(Rec.LimsStatus), 'GESPERRT') = 0 THEN
                                bLotStatusMismatch := TRUE;
                        END;
                END;
                IF bLotStatusMismatch THEN BEGIN
                    IF NOT CONFIRM('Neuer Chargenstatus: ''%1'' entspricht nicht dem Lims-Chargenstatus: ''%2''. Trotzdem übernehmen?', FALSE, FORMAT(Rec.Status), Rec.LimsStatus) THEN
                        ERROR('');
                END;
                //+GL039

                //-GL010
                //IF cuNaviPharma.StandortWeiche('ITEM_SITE_BATCH_RELEASE',"Item No.") = 'WIEN' THEN        //GL023
                IF Rec.Status = Rec.Status::Frei THEN BEGIN
                    IF ("Expiration Date" < TODAY) THEN
                        ERROR('Bevor Sie den Freigabestatus ' +
' auf "Frei" setzen können, muss die Charge mit einem gültigen Ablaufdatum versehen werden!');

                    IF NOT recItem.GET("Item No.") THEN ERROR('Artikel %1 ist nicht im Artikelstamm angelegt!', "Item No.");
                    //+GL011
                    //    IF NOT cuNaviPharma.PrüfeUnterstufeFrei(Rec."Item No.", Rec."Lot No.",
                    //        recItem.Artikelart <> recItem.Artikelart::Fertigprodukt, FALSE, TRUE) THEN
                    IF NOT cuNaviPharma.PrüfeUnterstufeFrei(Rec."Item No.", Rec."Lot No.", FALSE, TRUE, TRUE) THEN
                        //-GL011
                        //-GL018
                        //-GL017
                        //ERROR('Bevor Sie den Freigabestatus auf ''Frei'' setzen können, müssen die Unterstufen freigegeben sein!');
                        //MESSAGE('Das System lässt die Freigabe dieser Charge zu. Bitte beachten Sie jedoch, dass ' +
                        //  ' zumindest eine unfreie Unterstufe erkannt wurde! \'+
                        //  'Bitte kontrollieren Sie die Stati mit "Übersicht unfreie Artikel"');

                        IF CONFIRM('Das System lässt die Freigabe dieser Charge zu. Bitte beachten Sie jedoch, dass ' +
                        ' zumindest eine unfreie Unterstufe erkannt wurde! \' +
                        'Bitte kontrollieren Sie die Stati mit "Gesamtübersicht beteiligte Artikel"\' +
                        'CHARGE FREIGEBEN?') = FALSE THEN BEGIN
                            Status := xRec.Status;
                            EXIT;
                        END;

                    //frmChargenfreigabeWien.ZeigeBeteiligteStufen; //28.11.13 JP
                    //+GL017
                    //+GL018
                END;
                //+GL010

                //-GL009
                IF (xRec.Status = xRec.Status::Frei) AND (xRec.Status <> Rec.Status) THEN
                    IF STRPOS("Change Status", 'S') = 0 THEN "Change Status" := "Change Status" + 'S';
                //+GL009


                //-GL022
                IF (Status = Status::Frei) AND (xRec.Status <> Status::Frei) THEN
                    IF recItem.GET("Item No.") THEN
                        IF recItem.Artikelart = recItem.Artikelart::Fertigprodukt THEN
                            IF recItem."Patentschutz bis" >= TODAY THEN
                                IF CONFIRM('Patentschutz für Artikel %1 ist bis zum %2 eingetragen! Trotzdem Freigeben?', FALSE, "Item No.", recItem."Patentschutz bis") = FALSE THEN
                                    ERROR('Chargenfreigabe wurde abgebrochen!');
                //+GL022

                //-GL033
                IF (Status = Status::Frei) AND (xRec.Status <> Status::Frei) THEN
                    IF recItem.GET("Item No.") THEN
                        IF recItem.Artikelart = recItem.Artikelart::Fertigprodukt THEN
                            IF recItem."Vermarktungsexklusivität bis" >= TODAY THEN
                                IF CONFIRM('Vermarktungsexklusivität für Artikel %1 ist bis zum %2 eingetragen! Trotzdem Freigeben?', FALSE, "Item No.", recItem."Vermarktungsexklusivität bis") = FALSE THEN
                                    ERROR('Chargenfreigabe wurde abgebrochen!');
                //+GL033



                //-GL026
                IF Rec.Status = Rec.Status::Frei THEN BEGIN
                    IF Rec."Expiration Date" = 0D THEN
                        ERROR('Bitte vergeben Sie ein Ablaufdatum für die Charge!');
                    IF NOT cuNaviPharma.AblaufDatumPlausibel("Item No.", "Expiration Date") THEN
                        Rec.Status := xRec.Status;
                END;


                cInfoText := '';
                cText := CheckComponents(Rec."Item No.", Rec."Lot No.", FALSE, cInfoText);
                IF (cText <> '') AND (Status = Status::Frei) THEN
                    IF NOT CONFIRM(cText + '- trotzdem freigeben?') THEN
                        ERROR('Freigabe wird abgebrochen');


                IF NOT recItem.GET("Item No.") THEN ERROR('Artikel %1 ist nicht im Artikelstamm angelegt!', "Item No.");

                //Bei Freigabe von Fertigartikel das Recht $MARKTFREIGABE prüfen
                IF (recItem.Artikelart = recItem.Artikelart::Fertigprodukt) THEN
                    IF cuNaviPharma.Berechtigung('$MARKTFREIGABE') = FALSE THEN
                        ERROR('Berechtigung für Marktfreigabe nicht vorhanden!');

                //+GL026



                //-GL021
                //Marktfreigabe Pin bei Fertigartikel Abfragen
                IF Rec.Status <> xRec.Status THEN //GL025  Wenn vorher schon abgebrochen wurde, keinen Pin mehr prüfen
                    CheckMarktfreigabePin();
                //+GL021
                //MESSAGE('Einkommentieren!');

                //-GL038
                IF (Status = Status::Frei) AND (xRec.Status <> Status::Frei) THEN BEGIN
                    Freigabedatum := TODAY;
                    Freigabename := USERID;
                END;
                //+GL038


            end;
        }
        field(50011; BASPackmittelversionPHA; Code[20])
        {

            trigger OnValidate()
            begin
                //-GL009
                IF STRPOS("Change Status", 'P') = 0 THEN
                    "Change Status" := "Change Status" + 'P';
                //+GL009

            end;
        }
        field(50012; BASLagerstandPHA; Decimal)
        {
            CalcFormula = Sum("Item Ledger Entry".Quantity WHERE("Item No." = FIELD("Item No."),
                                                                  "Lot No." = FIELD("Lot No.")));
            DecimalPlaces = 0 : 5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(50013; "Rückstellmuster"; Integer)
        {

        }
        field(50014; BASArtikelnamePHA; Text[50])
        {
            CalcFormula = Lookup(Item.Description WHERE("No." = FIELD("Item No.")));
            FieldClass = FlowField;
        }
        field(50015; BASArtikelartPHA; Option)
        {
            CalcFormula = Lookup(Item.Artikelart WHERE("No." = FIELD("Item No.")));
            FieldClass = FlowField;
            OptionCaption = ' ,Rohstoff,Halbfabrikat,Fertigprodukt,Verpackungsstoff,Arbeitsschritt';
            OptionMembers = " ",Rohstoff,Halbfabrikat,Fertigprodukt,Verpackungsstoff,Arbeitsschritt;
        }
        field(50016; BASMIBIPHA; Boolean)
        {
        }
        field(50099; "BASChange StatusPHA"; Text[30])
        {
            Caption = 'Änderungsstatus';
        }
        field(50100; BASFABeschreibung2PHA; Text[50])
        {

        }
        field(50101; "ArtikelPackungsgröße"; Text[10])
        {
            CalcFormula = Lookup(Item."Packungsgröße" WHERE("No." = FIELD("Item No.")));
            FieldClass = FlowField;
        }
        field(50102; "BASCEP NrPHA"; Code[50])
        {
            Description = 'GL029,LQ18.1';

        }
        field(50103; BASHerstellerNrPHA; Code[20])
        {
            Description = 'GL029,LQ18.1';
            //TableRelation = Hersteller.HerstellerNr;
        }
        field(50104; "BASExpiration Date DMPHA"; Text[6])
        {
            Description = 'GL030,EUHUB';
            Numeric = true;

            trigger OnValidate()
            begin
                CheckExpDate(); //GL030
            end;
        }
        field(50105; "BASHF KommentarPHA"; Text[100])
        {
            Description = 'GL032';
        }
        field(50106; "BASAnzahl FreigabenPHA"; Integer)
        {
            CalcFormula = Count("Change Log Entry" WHERE("Table No." = CONST(6505),
                                                          "Primary Key Field 1 Value" = FIELD("Item No."),
                                                          "Primary Key Field 3 Value" = FIELD("Lot No."),
                                                          //"New Value" = CONST(1),
                                                          "Field No." = CONST(50010)));
            Description = 'GL038';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50117; BASLimsStatusPHA; Code[29])
        {
            Description = 'LIMS,CCU105';
        }
        field(50118; BASLimsImportInProgressPHA; Boolean)
        {
            Description = 'LIMS';
        }
        field(50119; BASLimsBacklogEntriesPHA; Integer)
        {
        }
        field(50120; BASItem_BlockedPHA; Boolean)
        {
            CalcFormula = Lookup(Item.Blocked WHERE("No." = FIELD("Item No.")));
            Caption = 'Artikel gesperrt';
            Description = 'LIMS';
            FieldClass = FlowField;
        }
        field(50507; "BASStatistikcode IPHA"; Code[10])
        {
            CalcFormula = Lookup(Item."Statistikcode I" WHERE("No." = FIELD("Item No.")));
            Editable = false;
            FieldClass = FlowField;
            TableRelation = Statistikcode2.Code WHERE(Ebene = CONST(1));
        }
        field(50508; "BASStatistikcode IIPHA"; Code[10])
        {
            CalcFormula = Lookup(Item."Statistikcode II" WHERE("No." = FIELD("Item No.")));
            Editable = false;
            FieldClass = FlowField;
            TableRelation = Statistikcode2.Code WHERE(Ebene = CONST(2));
        }
        field(50509; "BASStatistikcode IIIPHA"; Code[10])
        {
            CalcFormula = Lookup(Item."Statistikcode III" WHERE("No." = FIELD("Item No.")));
            Editable = false;
            FieldClass = FlowField;
            TableRelation = Statistikcode2.Code WHERE(Ebene = CONST(3));
        }
        field(50510; BASChangeDatePHA; DateTime)
        {
            CalcFormula = Max("Change Log Entry"."Date and Time" WHERE("Table No." = CONST(6505),
                                                                        "Primary Key Field 1 Value" = FIELD("Item No."),
                                                                        "Primary Key Field 2 Value" = FIELD("Variant Code"),
                                                                        "Primary Key Field 3 Value" = FIELD("Lot No."),
                                                                        "Type of Change" = FILTER(Modification)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(50511; BASErstablaufdatumPHA; Date)
        {
            Description = 'CCU553';
        }
        field(50512; BASProduktionsdatumPHA; Date)
        {
            Description = 'CCU656';
        }
        field(50513; "BASEntry DatePHA"; Date)
        {
            Caption = 'Zugangsdatum';
            Description = 'CCU656';
        }
    }



    procedure LotNoCheck()
    var
        recItem: Record "27";
        recLotNoInfo: Record "6505";
    begin
        //Eindeutigkeit der Rohstoffchargennr. (darf nie zweimal vergeben werden)
        recItem.GET("Item No.");
        IF recItem.Artikelart IN [recItem.Artikelart::Rohstoff, recItem.Artikelart::Verpackungsstoff] THEN BEGIN
            recLotNoInfo.SETCURRENTKEY("Lot No.");
            recLotNoInfo.SETRANGE("Lot No.", "Lot No.");
            IF recLotNoInfo.FIND('-') THEN
                IF recLotNoInfo."Item No." <> "Item No." THEN
                    ERROR('Rohstoffcharge wurde schon zu anderer Artikelnummer vergeben!');
        END;
    end;

    procedure CheckComponents(ItemNo: Text[20]; LotNo: Text[20]; bMehrstufig: Boolean; var cInfoText: Text[1000]) cMeldung: Text[1000]
    var
        recItem: Record "27";
        recItemLedgerEntry: Record "32";
        recItemLedgerEntry1: Record "32";
        recProductionOrder: Record "5405";
        recLotNoInformation: Record "6505";
        nCountChecked: Integer;

    begin

        //Funktion für Unterstufenprüfung
        IF recItem.GET(ItemNo) THEN
            IF recItem.Artikelart = recItem.Artikelart::Rohstoff THEN BEGIN
                cInfoText := 'Rohstoffe werden nicht geprüft!';  //UPDATE2013
                EXIT;
            END;
        nCountChecked := 0;
        recItemLedgerEntry.SETCURRENTKEY("Item No.", "Lot No.", "Posting Date");
        recItemLedgerEntry.SETFILTER("Lot No.", LotNo);
        recItemLedgerEntry.SETFILTER("Item No.", ItemNo);
        recItemLedgerEntry.SETRANGE("Entry Type", recItemLedgerEntry."Entry Type"::Output);
        IF recItemLedgerEntry.FIND('-') THEN BEGIN

            //-UPDATE2013
            //neu
            recItemLedgerEntry1.SETCURRENTKEY("Order Type", "Order No.", "Order Line No.", "Entry Type", "Prod. Order Comp. Line No.");
            recItemLedgerEntry1.SETRANGE("Order Type", recItemLedgerEntry."Order Type"::Production);
            recItemLedgerEntry1.SETFILTER("Order No.", recItemLedgerEntry."Order No.");
            //Alt
            //recItemLedgerEntry1.SETCURRENTKEY("Prod. Order No.","Prod. Order Line No.","Entry Type","Prod. Order Comp. Line No.");
            //recItemLedgerEntry1.SETFILTER("Prod. Order No.", recItemLedgerEntry."Prod. Order No.");
            //+UPDATE2013
            recItemLedgerEntry1.SETFILTER("Entry Type", 'Verbrauch|Abgang');
            IF recItemLedgerEntry1.FIND('-') THEN
                REPEAT
                    recLotNoInformation.SETFILTER("Item No.", recItemLedgerEntry1."Item No.");
                    recLotNoInformation.SETFILTER("Lot No.", recItemLedgerEntry1."Lot No.");
                    IF recLotNoInformation.FIND('-') THEN BEGIN
                        IF recLotNoInformation.Status <> recLotNoInformation.Status::Frei THEN BEGIN
                            IF ItemIsBulk(ItemNo) AND ItemIsBulk(recLotNoInformation."Item No.") THEN BEGIN
                                //TA-Artikel (Tablettenkerne) werden nie freigegeben
                            END ELSE BEGIN
                                cMeldung := cMeldung + '\' + 'Artikel ' + recLotNoInformation."Item No." + ' Chargennr. ' + recLotNoInformation."Lot No." + ' ist ';
                                cMeldung := cMeldung + FORMAT(recLotNoInformation.Status) + ' ';
                            END;
                        END;
                    END;
                    nCountChecked += 1;

                UNTIL (recItemLedgerEntry1.NEXT = 0);

            //-GL016
            //Ist im FA als Validierungscharge eingetragen?
            //recProductionOrder.SETRANGE("No.", recItemLedgerEntry."Order No.");
            //IF recProductionOrder.FINDSET THEN
            //    IF recProductionOrder.Validierungscharge = TRUE THEN
            //        MESSAGE(Text50001);
            /*
                  //-GL019
                  //Chargenplanung laden
                  CLEAR(recChargenPlanung_);
                  IF recItem.Artikelart = recItem.Artikelart::Fertigprodukt THEN BEGIN
                    recChargenPlanung_.GET(COPYSTR(LotNo,1,8));
                  END ELSE BEGIN
                    recChargenPlanung_.GET(LotNo);
                  END;

                  //Kommt die Validierungscharge von der Chargenplanung, dann vom HF kommend
                  IF (recChargenPlanung_.Validierungscharge=TRUE) AND (recChargenPlanung_.ValidierungschargeFertig=FALSE) THEN
                    MESSAGE(Text50001);

                  //Kommt die Validierungscharge nur vom FA, dann vom Fertigartikel kommend
                  IF (recChargenPlanung_.Validierungscharge=FALSE) THEN
                    MESSAGE(Text50002);
            */
            //+GL019

            //+GL016

        END;
        cInfoText := FORMAT(nCountChecked) + ' Komponenten geprüft' + ' ' + cMeldung;

    end;

    procedure ItemIsBulk(ItemNo: Code[20]): Boolean
    var
        recItem: Record "27";
    begin
        IF recItem.GET(ItemNo) THEN
            IF recItem.Artikelart = recItem.Artikelart::Halbfabrikat THEN
                EXIT(TRUE);
    end;

    procedure CheckMarktfreigabePin() bReturn: Boolean
    var
        recUserSetup: Record "91";
        recManufacturingSetup: Record "Manufacturing Setup";
        cuNaviPharma: Codeunit NaviPharma;
        cAct: Action;
        tPin: Text[30];
        tPinUser: Text[30];
    begin
        //-GL021
        /*
        bReturn:=FALSE;
        Rec.CALCFIELDS(Artikelart);
        IF Rec.Artikelart=Rec.Artikelart::Fertigprodukt THEN BEGIN   //Nur bei Fertigprodukten
        
          pDialog.SetCaption('Marktfreigabe Pin:');
          pDialog.LOOKUPMODE(TRUE);
          cAct := pDialog.RUNMODAL;
        
        
          IF (cAct = ACTION::OK) OR (cAct = ACTION::LookupOK) THEN BEGIN   //GL027
            IF (pDialog.GetAction()=TRUE) THEN BEGIN
              tPin:=pDialog.GetValue();
              tPin := UPPERCASE(tPin);
        
              //Benutzer Pin holen
              recUserSetup.GET(USERID);
              tPinUser := recUserSetup.MarktfreigabePin;
              IF STRLEN(tPinUser)=0 THEN
                ERROR('Es ist kein PIN für die Marktfreigabe für den Benutzer %1 vorhanden!', USERID);
        
              //Entschlüsseln des Benutzer Pin
              recManufacturingSetup.GET;
              IF recManufacturingSetup.WaagePinVerschlüsselung > 0 THEN
                tPinUser:= cuNaviPharma.StrCrypt(tPinUser, recManufacturingSetup.WaagePinVerschlüsselung, FALSE);
        
              IF NOT (tPinUser=tPin) THEN
                ERROR('Pin nicht korrekt!')
              ELSE
                bReturn:=TRUE;
        
            END ELSE BEGIN
              ERROR('Pin Eingabe wurde Abgebrochen!');
            END;
          END ELSE BEGIN
            ERROR('Pin Eingabe wurde Abgebrochen!');
          END;
        
        END;
        //+GL021
        */

    end;

    local procedure CheckExpDate()
    var
        cuCodesammlung: Codeunit Codesammlung;
        iDayHelp: Integer;
        iMonHelp: Integer;
        tMonHelp: Text[2];
        tMonHelpDM: Text[2];
        tYearHelp: Text[4];
        tYearHelpDM: Text[4];
    begin
        //-GL030
        IF ("Expiration Date DM" <> '') THEN BEGIN
            IF STRLEN("Expiration Date DM") < 6 THEN
                ERROR('DataMatrix Ablaufdatum muss Format JJMMTT (YYMMDD) haben!');

            IF EVALUATE(iMonHelp, COPYSTR("Expiration Date DM", 3, 2)) THEN BEGIN
                IF (iMonHelp < 1) OR (iMonHelp > 12) THEN
                    ERROR('DataMatrix Ablaufdatum muss Format JJMMTT (YYMMDD) haben!');
            END ELSE
                ERROR('DataMatrix Ablaufdatum muss Format JJMMTT (YYMMDD) haben!');

            IF EVALUATE(iDayHelp, COPYSTR("Expiration Date DM", 5, 2)) THEN BEGIN
                IF (iDayHelp < 0) OR (iDayHelp > 31) THEN
                    ERROR('DataMatrix Ablaufdatum muss Format JJMMTT (YYMMDD) haben!');
            END ELSE
                ERROR('DataMatrix Ablaufdatum muss Format JJMMTT (YYMMDD) haben!');

            IF ("Expiration Date" <> 0D) THEN BEGIN
                tYearHelp := FORMAT(DATE2DMY("Expiration Date", 3));
                tYearHelpDM := '20' + COPYSTR("Expiration Date DM", 1, 2);
                tMonHelp := cuCodesammlung.TextAuffuellen(FORMAT(DATE2DMY("Expiration Date", 2)), 2, '0');
                tMonHelpDM := COPYSTR("Expiration Date DM", 3, 2);
                IF (tYearHelp <> tYearHelpDM) OR (tMonHelp <> tMonHelpDM) THEN
                    IF NOT CONFIRM('DataMatrix Ablaufdatum: %1-%2 weicht von Ablaufdatum: %3-%4 ab. Trotzdem übernehmen?', FALSE, tMonHelp, tYearHelp, tMonHelpDM, tYearHelpDM) THEN
                        ERROR('Abgebrochen: DataMatrix Ablaufdatum weicht ab!');
            END;
        END;
        //+GL030
    end;



    local procedure GetVendorNo() VendorNo: Code[50]
    var
        recPurchRcptLine: Record "121";
        LieferNr: Code[50];
    begin
        //-GL036
        VendorNo := '';
        //LieferNr := regEx.Match(xRec.Description, 'EL[\d]+').Value; //Einkaufsliefernr aus Beschreibung auslesen
        CLEAR(recPurchRcptLine);
        IF LieferNr <> '' THEN
            recPurchRcptLine.SETRANGE("Document No.", LieferNr);
        recPurchRcptLine.SETRANGE("No.", xRec."Item No.");
        recPurchRcptLine.SETRANGE("Lot No.", xRec."Lot No.");
        //IF Rec.HerstellerNr <> '' THEN
        //  recPurchRcptLine.SETRANGE(HerstellerNr,xRec.HerstellerNr);
        IF recPurchRcptLine.FINDFIRST THEN
            VendorNo := recPurchRcptLine."Buy-from Vendor No.";
        //+GL036
    end;




    procedure GetLastChange(What: Option Date,Name) ChangeValue: Text
    var
        ChangeLog: Record "405";
    begin
        ChangeValue := '';
        ChangeLog.SETRANGE("Table No.", DATABASE::"Lot No. Information");
        ChangeLog.SETRANGE("Primary Key Field 1 Value", "Item No.");
        ChangeLog.SETRANGE("Primary Key Field 2 Value", "Variant Code");
        ChangeLog.SETRANGE("Primary Key Field 3 Value", "Lot No.");
        ChangeLog.SETRANGE("Type of Change", ChangeLog."Type of Change"::Modification);
        ChangeLog.SETFILTER(ChangeLog."Field No.", '<>50004');  //GL040  Offen Hakerl nicht als Änderung Anzeigen  (Wunsch Magg, Weberhofer)
        IF ChangeLog.FINDLAST THEN BEGIN
            CASE What OF
                What::Date:
                    BEGIN
                        ChangeValue := FORMAT(ChangeLog."Date and Time");
                    END;
                What::Name:
                    BEGIN
                        ChangeValue := ChangeLog."User ID";
                    END;
            END;
        END;
    end;

    trigger OnBeforeDelete()
    var
        ItemJnlLine: Record "Item Journal Line";
        ItemLedgEntry: Record "Item Ledger Entry";
        ItemTrackingComment: Record "Item Tracking Comment";
    begin

        ItemTrackingComment.SETRANGE(Type, ItemTrackingComment.Type::"Lot No.");
        ItemTrackingComment.SETRANGE("Item No.", "Item No.");
        ItemTrackingComment.SETRANGE("Variant Code", "Variant Code");
        ItemTrackingComment.SETRANGE("Serial/Lot No.", "Lot No.");
        ItemTrackingComment.DELETEALL();


        //-LAN002
        ItemLedgEntry.SETCURRENTKEY("Item No.", "Lot No.");
        ItemLedgEntry.SETRANGE("Item No.", "Item No.");
        ItemLedgEntry.SETRANGE("Lot No.", "Lot No.");
        IF not ItemLedgEntry.IsEmpty THEN
            ERROR('FEHLENDE TEXTVARIABLE 6506', "Lot No.");
        //+LAN002
    end;



    trigger OnBeforeRename()
    var
        ItemJnlLine: Record "Item Journal Line";
        PurchLine: Record "Purchase Line";
        ReservEntry: Record "Reservation Entry";
        SalesLine: Record "Sales Line";
        TrackSpec: Record "Tracking Specification";
        TransLine: Record "Transfer Line";
    begin


        //-GL004
        LotNoCheck();
        //+GL004

        //-LAN003
        IF "Lot No." <> xRec."Lot No." THEN BEGIN
            PurchLine.SETCURRENTKEY("Document Type", Type, "No.");
            PurchLine.SETRANGE(Type, PurchLine.Type::Item);
            PurchLine.SETRANGE("No.", xRec."Item No.");
            PurchLine.SETRANGE("Variant Code", xRec."Variant Code");
            PurchLine.SETRANGE("Lot No.", xRec."Lot No.");
            IF PurchLine.FINDSET(TRUE, TRUE) THEN
                REPEAT
                    PurchLine."Lot No." := "Lot No.";
                    PurchLine.MODIFY;
                UNTIL PurchLine.NEXT = 0;

            ReservEntry.SETRANGE("Lot No.", xRec."Lot No.");
            ReservEntry.SETRANGE("Item No.", xRec."Item No.");
            ReservEntry.SETRANGE("Variant Code", xRec."Variant Code");
            IF ReservEntry.FINDSET(TRUE, TRUE) THEN
                REPEAT
                    ReservEntry."Lot No." := "Lot No.";
                    ReservEntry.MODIFY;
                UNTIL ReservEntry.NEXT = 0;

            TrackSpec.SETRANGE("Lot No.", xRec."Lot No.");
            TrackSpec.SETRANGE("Item No.", xRec."Item No.");
            TrackSpec.SETRANGE("Variant Code", xRec."Variant Code");
            IF TrackSpec.FINDSET(TRUE, TRUE) THEN
                REPEAT
                    TrackSpec."Lot No." := "Lot No.";
                    TrackSpec.MODIFY;
                UNTIL TrackSpec.NEXT = 0;

            SalesLine.SETCURRENTKEY("Document Type", Type, "No.");
            SalesLine.SETRANGE(Type, SalesLine.Type::Item);
            SalesLine.SETRANGE("No.", xRec."Item No.");
            SalesLine.SETRANGE("Variant Code", xRec."Variant Code");
            SalesLine.SETRANGE("Lot No.", xRec."Lot No.");
            IF SalesLine.FINDSET(TRUE, TRUE) THEN
                REPEAT
                    SalesLine."Lot No." := "Lot No.";
                    SalesLine.MODIFY;
                UNTIL SalesLine.NEXT = 0;

            TransLine.SETCURRENTKEY("Item No.");
            TransLine.SETRANGE("Item No.", xRec."Item No.");
            //TransLine.SETRANGE(Type, TransLine.Type::Item);
            TransLine.SETRANGE("Variant Code", xRec."Variant Code");
            //TransLine.SETRANGE("Lot No.", xRec."Lot No.");
            IF TransLine.FIND('-') THEN
                REPEAT
                    //TransLine."Lot No." := "Lot No.";
                    TransLine.MODIFY;
                UNTIL TransLine.NEXT = 0;

            ItemJnlLine.SETRANGE("No.", xRec."Item No.");
            ItemJnlLine.SETRANGE("Variant Code", xRec."Variant Code");
            ItemJnlLine.SETRANGE("Lot No.", xRec."Lot No.");
            IF ItemJnlLine.FINDSET(TRUE, TRUE) THEN
                REPEAT
                    ItemJnlLine."Lot No." := "Lot No.";
                    ItemJnlLine.MODIFY;
                UNTIL ItemJnlLine.NEXT = 0;



        END;

    end;

}
