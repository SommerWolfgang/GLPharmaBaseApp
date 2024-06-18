page 50016 BASReleaseLotSubPagePHA
{
    ApplicationArea = all;
    // version GL,LQ18.1,EUHUB,LIMS,CCU553

    // 
    // ------------------------------------------------------------------------------------------------------------------------------------
    // Datum      | Autor     | Status     | Beschreibung
    // ------------------------------------------------------------------------------------------------------------------------------------
    // 2015-06-08 | MFU       | OK         | UPDATE2013
    // ------------------------------------------------------------------------------------------------------------------------------------
    // 2015-08-20 | MFU       | OK         | GL001 - Chargenkorrektur Recht einbauen
    // ------------------------------------------------------------------------------------------------------------------------------------
    // 2015-09-02 | MFU       | OK         | Dezimalstellen bei Spalte Lagerstand verändert
    // ------------------------------------------------------------------------------------------------------------------------------------
    // 2016-07-11 | MFU       | OK         | GL002 - Trend Anzeige in Wiener Freigabe eingebaut
    // ------------------------------------------------------------------------------------------------------------------------------------
    // 2016-09-22 | MFU       | OK         | GL003 - Trend Anzeige nur für Lannacher Benutzer aktiviert
    // ------------------------------------------------------------------------------------------------------------------------------------
    // 2017-06-06 | PRA       | OK         | GL004 - Wien: Funktion Label Balance eingebaut
    // ------------------------------------------------------------------------------------------------------------------------------------
    // 2017-11-17 | MFU       | OK         | GL005 - Aufruf der Prüfpunkte Page nicht mehr Modal, damit Trend Page daneben kommt
    // ------------------------------------------------------------------------------------------------------------------------------------
    // 2017-11-17 | MFU       | OK         | GL006 - Andere Fehlermeldung bei Chargenfreigabe
    // ------------------------------------------------------------------------------------------------------------------------------------
    // 2017-11-30 | MFU       | OK         | GL007 - Zusammenführung LAN / WIEN
    // ------------------------------------------------------------------------------------------------------------------------------------
    // 2018-09-26 | PRA       | OK         | GL008 - Funtkionen/GesamtübersichtBeteiligteArtikel hinzugefügt
    // ------------------------------------------------------------------------------------------------------------------------------------
    // 2018-09-04 | DKO       | OK         | HerstellerNr & CEP Nr hinzugefügt für LQ18, CEP
    // ------------------------------------------------------------------------------------------------------------------------------------
    // 2018-12-18 | DKO       | OK         | "Expiration Date DM" hinzugefügt für EU-HUB
    // ------------------------------------------------------------------------------------------------------------------------------------
    // 2020-07-13 | DKO       | OK         | GL009 - LIMS einbau
    // ------------------------------------------------------------------------------------------------------------------------------------
    // 2021-01-11 | MFU       | OK         | GL010 - Lagerstand Produktionslagerorte für MAGG
    // ------------------------------------------------------------------------------------------------------------------------------------

    PageType = ListPart;
    SourceTable = "Lot No. Information";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Lot No."; "Lot No.")
                {
                    ApplicationArea = all;
                    Editable = bChargenkorrekturFelder;
                    Style = StandardAccent;
                    StyleExpr = FarbeLotNo;
                }
                field("Verkaufschargennr."; "Verkaufschargennr.")
                {
                    ApplicationArea = all;
                    Editable = bChargenkorrekturFelder;
                    Style = StandardAccent;
                    StyleExpr = FarbeVKCh;
                }
                field("Lief. Chargennr."; "Lief. Chargennr.")
                {
                    ApplicationArea = all;
                    Editable = bChargenkorrekturFelder;
                    Style = StandardAccent;
                    StyleExpr = FarbeLiefCh;
                }
                field("Expiration Date"; "Expiration Date")
                {
                    ApplicationArea = all;
                    Editable = bChargenkorrekturFelder;
                    Style = StandardAccent;
                    StyleExpr = FarbeAblaufDatum;
                }
                field(Erstablaufdatum; Erstablaufdatum)
                {
                    ApplicationArea = all;
                }
                field(Status; Status)
                {
                    ApplicationArea = all;
                    Editable = false;
                    Style = Favorable;
                    StyleExpr = StatusFarbe;
                    trigger OnValidate()
                    var
                        cText: Text[100];
                    begin

                        cText := CheckComponents(Rec."Item No.", Rec."Lot No.", FALSE, cInfoText);
                        IF (cText <> '') AND (Status = Status::Frei) THEN
                            IF NOT CONFIRM(cText + '- trotzdem freigeben?') THEN
                                ERROR('Freigabe wird abgebrochen');

                        //Statusfarbe setzen
                        StatusFarbe := 'Standard';
                        IF Status = Status::Gesperrt THEN
                            StatusFarbe := 'Attention';
                        IF Status = Status::Frei THEN
                            StatusFarbe := 'Favorable';
                    end;
                }
                field(Freigabedatum; Freigabedatum)
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field(Freigabename; Freigabename)
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field(Gehalt; Gehalt)
                {
                    ApplicationArea = all;
                    Editable = bChargenkorrekturFelder;
                    Style = StandardAccent;
                    StyleExpr = FarbeGehalt;
                }
                field(Lagerstand; Lagerstand)
                {
                    ApplicationArea = all;
                    DecimalPlaces = 0 : 5;
                    Editable = false;

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        tempRecItemLedgerEntry: Record "32" temporary;
                    begin

                        //-UPDATE2013
                        tempRecItemLedgerEntry."Item No." := "Item No.";
                        tempRecItemLedgerEntry.SETRANGE("Item No.", "Item No.");
                        tempRecItemLedgerEntry.SETRANGE(Open, TRUE);
                        IF PAGE.RUNMODAL(PAGE::TransferInfo, tempRecItemLedgerEntry) = ACTION::LookupOK THEN;
                        //+UPDATE2013
                    end;
                }
                field(Description; Description)
                {
                    ApplicationArea = all;
                    Editable = bChargenkorrekturFelder;
                }
                field(Laborkommentar; Laborkommentar)
                {
                    ApplicationArea = all;
                    Editable = bChargenkorrekturFelder;
                    Style = StandardAccent;
                    StyleExpr = FarbeLabKommentar;
                }
                field("Laetus-Code"; "Laetus-Code")
                {
                    ApplicationArea = all;
                    Editable = bChargenkorrekturFelder;
                }
                field(Packmittelversion; Packmittelversion)
                {
                    ApplicationArea = all;
                    Editable = bChargenkorrekturFelder;
                    Style = StandardAccent;
                    StyleExpr = FarbePackmittelVersion;
                }
                field(Rückstellmuster; Rückstellmuster)
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field(FABeschreibung2; FABeschreibung2)
                {
                    ApplicationArea = all;
                    Caption = 'Beschreibung 2';
                    Visible = false;
                }
                field(HerstellerNr; HerstellerNr)
                {
                    ApplicationArea = all;
                    Editable = bChargenkorrekturFelder;
                }
                field("CEP Nr"; "CEP Nr")
                {
                    ApplicationArea = all;
                    Editable = bChargenkorrekturFelder;
                }
                field("Expiration Date DM"; "Expiration Date DM")
                {
                    ApplicationArea = all;
                    Caption = 'DM Ablaufdatum';
                    Editable = bChargenkorrekturFelder;
                }
                field(LimsStatus; LimsStatus)
                {
                    ApplicationArea = all;
                    Caption = 'LIMS Status';
                    Editable = false;
                }
                field(LastChange_Date; ChangeDate)
                {
                    ApplicationArea = all;
                    Caption = 'Änderung am';
                }
                field(LastChange_Name; GetLastChange(1))
                {
                    ApplicationArea = all;
                    Caption = 'Änderung durch';
                }
                field("Anzahl Freigaben"; "Anzahl Freigaben")
                {
                    ApplicationArea = all;
                }
                field("Lagerstand Produktion Lannach"; dLagerstandProduktionLagerorte)
                {
                    ApplicationArea = all;
                    DecimalPlaces = 0 : 5;
                    Editable = false;
                    Visible = false;

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        tempRecItemLedgerEntry: Record "32" temporary;
                    begin

                        //-GL010
                        tempRecItemLedgerEntry."Item No." := "Item No.";
                        tempRecItemLedgerEntry.SETRANGE("Item No.", "Item No.");
                        tempRecItemLedgerEntry.SETFILTER("Location Code", 'AL|WEL|PL|S');
                        tempRecItemLedgerEntry.SETRANGE(Open, TRUE);
                        IF PAGE.RUNMODAL(PAGE::TransferInfo, tempRecItemLedgerEntry) = ACTION::LookupOK THEN;
                        //+GL010
                    end;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(Bearbeiten)
            {
                Image = EditLines;
                Visible = bBearbeiten;

                trigger OnAction()
                var
                    recLot: Record "6505";
                    recItem: Record Item;
                    cuNaviPharma: Codeunit NaviPharma;
                    pLotFreigabe: Page ReleaseLot;
                    bEditable: Boolean;
                begin

                    //Page mit versteckten Filtern Aufrufen -> Dadurch sicherer machen
                    CLEAR(recLot);
                    recLot.FILTERGROUP(2);
                    recLot.SETRANGE("Item No.", Rec."Item No.");
                    recLot.SETRANGE("Lot No.", Rec."Lot No.");
                    recLot.FILTERGROUP(0);

                    CLEAR(pLotFreigabe);
                    pLotFreigabe.SETTABLEVIEW(recLot);
                    pLotFreigabe.SETRECORD(recLot);


                    Rec.CALCFIELDS(Artikelart);  //GL002


                    bEditable := TRUE;
                    IF Rec.Artikelart = Rec.Artikelart::Fertigprodukt THEN
                        IF cuNaviPharma.Berechtigung('$MARKTFREIGABE') = FALSE THEN
                            bEditable := FALSE;

                    IF bEditable THEN BEGIN
                        pLotFreigabe.setLotNoEditable(TRUE);
                    END ELSE BEGIN
                        //-GL006
                        MESSAGE('Keine Marktfreigaberechte vorhanden!');       //GL007  Anderer Text bei fehlenden MArktfreigaberechten
                                                                               //+GL006
                    END;

                    //-GL009 - Trends in LIMS
                    /*
                    //-GL002
                    IF (Rec.Artikelart = Rec.Artikelart::Fertigprodukt) OR (Rec.Artikelart = Rec.Artikelart::Halbfabrikat) THEN BEGIN
                      //-GL003   //Für Win noch nicht aktivieren
                      IF cuNaviPharma.StandortWeiche('ITEM_SITE_BATCH_RELEASE',"Item No.") <> 'WIEN' THEN      //-GL007  Trend nur für Lannach anzeigen -> Auch Vereinheitlichen?
                        pLotFreigabe.SetTrendAnzeige(TRUE);  //MFU 03.11.2017    War nach Import für Wien aktiviert und wurde wieder deaktiviert
                      //+GL003
                    END ELSE
                      pLotFreigabe.SetTrendAnzeige(FALSE);
                    //-GL002
                    */
                    //+GL009

                    //pLotFreigabe.SetTrendAnzeige(FALSE);
                    pLotFreigabe.RUNMODAL;

                end;
            }
            action(ChargeBearbeiten)
            {
                Caption = 'Charge Bearbeiten';
                Image = ChangeTo;
                Visible = bChargenkorrektur;

                trigger OnAction()
                var
                    cuNaviPharma: Codeunit NaviPharma;
                begin

                    //-GL001
                    //Nur für Chargen in Quarantäne zulassen
                    IF Status = Status::Quarantäne THEN BEGIN
                        bChargenkorrekturFelder := TRUE;  //Spalten in Liste Freigeben
                        CurrPage.EDITABLE := TRUE;
                        CurrPage.UPDATE;

                    END ELSE
                        MESSAGE('Chargenkorrektur nur im Status "Quarantäne" erlaubt!')
                    //+GL001
                end;
            }
            action("Chargenposten anzeigen")
            {

                trigger OnAction()
                var
                    recItemLedgEntry: Record "32";
                begin

                    recItemLedgEntry.SETCURRENTKEY("Item No.", "Lot No.");
                    recItemLedgEntry.SETRANGE("Item No.", "Item No.");
                    recItemLedgEntry.SETRANGE("Lot No.", "Lot No.");
                    PAGE.RUNMODAL(0, recItemLedgEntry);
                end;
            }
            action("Chargen Prüfpunkte")
            {
                Image = Agreement;

                trigger OnAction()
                begin
                    //ChargenPruefpunkteShow();
                end;
            }
            action(Ablaufverfolgung)
            {

                trigger OnAction()
                var
                    recItemTracingBuffer: Record "6520";
                    pVerfolgung: Page "6520";
                begin

                    //-UPDATE2013
                    //Artikelverfolgung für Bernhard  MFU 23.02.2015
                    CLEAR(recItemTracingBuffer);
                    recItemTracingBuffer.SETFILTER("Lot No.", Rec."Lot No.");
                    recItemTracingBuffer.SETFILTER("Item No.", Rec."Item No.");

                    pVerfolgung.InitFilters(recItemTracingBuffer);
                    pVerfolgung.RUN;
                    //+UPDATE2013
                end;
            }
            group(Funktionen)
            {
                Caption = 'Funktionen';
                action("ÜbersichtbeteiligteArtikel")
                {
                    Caption = 'Übersicht beteiligte Artikel';
                    Image = CheckList;

                    trigger OnAction()
                    var
                        recLot: Record "6505";
                        pLotFreigabe: Page ReleaseLot;
                    begin

                        CLEAR(recLot);
                        recLot.SETRANGE("Item No.", Rec."Item No.");
                        recLot.SETRANGE("Lot No.", Rec."Lot No.");
                        recLot.FINDFIRST;

                        pLotFreigabe.ZeigeBeteiligteStufen(FALSE, recLot);
                    end;
                }
                action("GesamtübersichtBeteiligteArtikel")
                {
                    Caption = 'Gesamtübersicht beteiligte Artikel';
                    Image = CheckList;

                    trigger OnAction()
                    var
                        recLot: Record "6505";
                        pLotFreigabe: Page ReleaseLot;
                    begin
                        //- GL008
                        CLEAR(recLot);
                        recLot.SETRANGE("Item No.", Rec."Item No.");
                        recLot.SETRANGE("Lot No.", Rec."Lot No.");
                        recLot.FINDFIRST;

                        pLotFreigabe.ZeigeBeteiligteStufen(TRUE, recLot);
                        //+ GL008
                    end;
                }
                action(Kartonetiketten)
                {
                    Image = "Report";

                    trigger OnAction()
                    begin
                        //DruckKartonEtiketten;
                    end;
                }
                action(Artikeletiketten)
                {
                    Image = "Report";

                    trigger OnAction()
                    begin
                        //DruckArtikelEtikett;
                    end;
                }
                /*
                action(Palettenetikett)
                {
                    Image = "Report";
                    ToolTip = 'Palettenschein DIN A4';

                    trigger OnAction()
                    var
                        reportPalettenEtikett: Report "50076";
                    begin
                        CLEAR(reportPalettenEtikett);
                        reportPalettenEtikett.SetParameter('', 0, "Item No.", "Lot No.");
                        reportPalettenEtikett.RUNMODAL;
                    end;
                }
                */
                action(Artikelablaufverfolgung)
                {

                    trigger OnAction()
                    var
                        recITB: Record "6520";
                        pItemTracking: Page "6520";
                    begin
                        //-UPDATE2013
                        //Filter übergeben
                        CLEAR(recITB);
                        recITB.SETRANGE("Item No.", "Item No.");
                        recITB.SETRANGE("Lot No.", "Lot No.");
                        pItemTracking.InitFilters(recITB);
                        pItemTracking.RUN;
                        //+UPDATE2013
                    end;
                }
                /*
                action("Rückstellmusterverwaltung")
                {
                    Image = ViewDetails;

                    trigger OnAction()
                    var
                        "frmRückstellmusterverwaltung": Page "50049";
                    begin

                        CLEAR(frmRückstellmusterverwaltung);
                        frmRückstellmusterverwaltung.SetFilter("Item No.", "Lot No.");
                        frmRückstellmusterverwaltung.RUNMODAL;
                    end;
                }
                action("Labor Etikettendruck")
                {
                    Image = PrintCover;
                    RunObject = Page 50037;
                }
                action("Chargen Prüfpunkte - Annual Review")
                {
                    Caption = 'Chargen Prüfpunkte - Annual Review';
                    Image = ExportToExcel;

                    trigger OnAction()
                    begin
                        ChargenPruefpunkteShowAR();
                    end;
                }
                separator()
                {
                }
                action("Druck Lagerkarte")
                {
                    Image = Print;

                    trigger OnAction()
                    var
                        repLagerkarte: Report "50121";
                    begin
                        //repLagerkarte.SetzeNachdruck("Lot No.","Item No.");
                        //repLagerkarte.RUNMODAL;
                        DruckLagerkarte;
                    end;
                }
                action("Freigabeetiketten Wien")
                {
                    Image = MiniForm;

                    trigger OnAction()
                    begin
                        cuDruckausgabe.DruckFreigabeEtikettWien(0, 0, "Item No.", "Lot No.");
                    end;
                }
                action("Quarantäneetiketten Wien")
                {
                    Image = MiniForm;

                    trigger OnAction()
                    begin
                        cuDruckausgabe.DruckFreigabeEtikettWien(1, 0, "Item No.", "Lot No.");
                    end;
                }
                action("Kennzeichnungsetiketten Wien")
                {
                    Image = MiniForm;

                    trigger OnAction()
                    begin
                        cuDruckausgabe.DruckFreigabeEtikettWien(2, 0, "Item No.", "Lot No.");
                    end;
                }
                action("Musteretiketten Wien")
                {
                    Image = MiniForm;

                    trigger OnAction()
                    begin
                        cuDruckausgabe.DruckFreigabeEtikettWien(2, 1, "Item No.", "Lot No.");
                    end;
                }
                action("Label Balance")
                {
                    Image = Allocations;

                    trigger OnAction()
                    var
                        PLabel: Page "50167";
                        recItem: Record "27";
                    begin
                        recItem.SETRANGE("No.", "Item No.");
                        PLabel.SETTABLEVIEW(recItem);
                        PLabel.Setparameter("Lot No.");
                        PLabel.RUNMODAL;
                    end;
                }
                */
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin

        //-GL001
        //Bei Chargenwechsel in der Liste wieder sperren
        IF xRec."Lot No." <> "Lot No." THEN
            bChargenkorrekturFelder := FALSE;
        //+GL001
    end;

    trigger OnAfterGetRecord()
    var
        recLot: Record "6505";
        recProdEinrichtung: Record "99000765";
    begin

        //Statusfarbe setzen
        StatusFarbe := 'Standard';
        IF Status = Status::Gesperrt THEN
            StatusFarbe := 'Attention';
        IF Status = Status::Frei THEN
            StatusFarbe := 'Favorable';

        SetChangeStatusFarben();

        //-GL010
        dLagerstandProduktionLagerorte := 0;
        recLot.SETRANGE("Item No.", "Item No.");
        recLot.SETRANGE("Lot No.", "Lot No.");
        IF recLot.FINDFIRST THEN BEGIN
            recLot.SETFILTER("Location Filter", 'AL|WEL|PL|S');
            recLot.CALCFIELDS(Inventory);
            dLagerstandProduktionLagerorte := recLot.Inventory;
        END;
        //+GL010
    end;

    trigger OnInit()
    begin

        bBearbeiten := FALSE;  //UPDATE2013
    end;

    trigger OnModifyRecord(): Boolean
    begin

        //-GL001
        //Sicherheitsabfrage
        IF NOT NaviPharma.Berechtigung('$CHARGENKORREKTUR') THEN
            ERROR('Für Änderungen nicht Berechtigt!');
        //+GL001
    end;

    trigger OnOpenPage()
    begin
        SETFILTER(Lagerstand, '<>0');

        //-GL001
        //Freigabe in Zeilen nicht anzeigen, wenn das generelle Bearbeiten aktiv ist
        IF bBearbeiten = FALSE THEN BEGIN

            bChargenkorrekturFelder := FALSE;  //Diese Variable erst nach "Charge Bearbeiten" Aktion freigeben
            bChargenkorrektur := FALSE;
            IF NaviPharma.Berechtigung('$CHARGENKORREKTUR') THEN
                bChargenkorrektur := TRUE;

        END;
        //+GL001
    end;

    var
        cuDruckausgabe: Codeunit "50002";
        NaviPharma: Codeunit NaviPharma;
        bBearbeiten: Boolean;
        bChargenkorrektur: Boolean;
        bChargenkorrekturFelder: Boolean;
        [InDataSet]
        bStatusStyle: Boolean;
        dLagerstandProduktionLagerorte: Decimal;
        FarbeAblaufDatum: Text;
        FarbeGehalt: Text;
        FarbeLabKommentar: Text;
        FarbeLiefCh: Text;
        FarbeLotNo: Text;
        FarbePackmittelVersion: Text;
        FarbeStatus: Text;
        FarbeVKCh: Text;
        [InDataSet]
        StatusFarbe: Text;
        cInfoText: Text[1000];
    /*
        procedure ChargenPruefpunkteShow()
        var
            pAnalyseErgebniss: Page "50039";
            iVersion: Integer;
        begin

            //-GL001

            //Gibt es zu dem Artikel und Charge schon Prüfpunkte?
            iVersion := pAnalyseErgebniss.GetVersionAnzahlCharge("Item No.", "Lot No.");
            IF iVersion > 0 THEN
                ERROR('Es sind mehr als eine Prüfpunktversion zu der Charge vorhanden!');
            IF iVersion < 0 THEN
                iVersion *= (-1);    //0 wenn es keine Prüfpunkte gibt

            CLEAR(pAnalyseErgebniss);
            pAnalyseErgebniss.SetParameter('CHARGEN', "Item No.", "Lot No.", iVersion, '');  //Bei Chargen gibt es nur eine Version pro Charge

            pAnalyseErgebniss.RUN;          //-GL005  ALT: RUNMODAL;
            //+GL001
        end;

        procedure DruckArtikelEtikett()
        var
            objArtikeletikett: Page "50106";
        begin
            CLEAR(objArtikeletikett);
            objArtikeletikett.SetzeParameter("Item No.", "Lot No.", 0, 0);
            objArtikeletikett.RUN;
        end;

        procedure DruckKartonEtiketten()
        var
            cuDruckausgaben: Codeunit "50002";
        begin
            cuDruckausgaben.DruckeKartonEtiketten("Item No.", "Lot No.", '', '');
        end;

        procedure DruckLagerkarte()
        var
            repLagerkarte: Report "50121";
            printed: Boolean;
        begin
            //repLagerkarte.SetzeNachdruck(Rec."Lot No.","Item No.");
            printed := FALSE;
            repLagerkarte.SetzeNachdruck("Lot No.", "Item No.");
            //IF  NOT repLagerkarte.SetPrinted THEN
            //  BEGIN
            repLagerkarte.RUNMODAL;
            //  END;
        end;
    */
    procedure SetChangeStatusFarben()
    begin
        //Farben der Eingabefelder zentral setzen

        FarbeLotNo := 'Standard';
        FarbeLiefCh := 'Standard';
        FarbeAblaufDatum := 'Standard';
        FarbeVKCh := 'Standard';
        FarbeGehalt := 'Standard';
        FarbeLabKommentar := 'Standard';
        FarbeStatus := 'Standard';
        FarbePackmittelVersion := 'Standard';

        IF STRPOS("Change Status", 'L') > 0 THEN
            FarbeLotNo := 'StandardAccent';
        IF STRPOS("Change Status", 'D') > 0 THEN
            FarbeLiefCh := 'StandardAccent';
        IF STRPOS("Change Status", 'E') > 0 THEN
            FarbeAblaufDatum := 'StandardAccent';
        IF STRPOS("Change Status", 'V') > 0 THEN
            FarbeVKCh := 'StandardAccent';
        IF STRPOS("Change Status", 'G') > 0 THEN
            FarbeGehalt := 'StandardAccent';
        IF STRPOS("Change Status", 'M') > 0 THEN
            FarbeLabKommentar := 'StandardAccent';
        IF STRPOS("Change Status", 'S') > 0 THEN
            FarbeStatus := 'StandardAccent';
        IF STRPOS("Change Status", 'P') > 0 THEN
            FarbePackmittelVersion := 'StandardAccent';
    end;
    /*
        procedure FreigabeEtikettDrucken("Label Type": Option Release,Quarantine,Analysis; "Label Subtype": Integer)
        var
            GerotFreiGabeEtikett: Report "50086";
            "GerotQuarantäneEtikett": Report "50087";
            GerotAnalyseEtikett: Report "50088";
            recLotNoInfo: Record "6505";
        begin
            recLotNoInfo.SETRANGE("Item No.", "Item No.");
            recLotNoInfo.SETRANGE("Lot No.", "Lot No.");

            CASE "Label Type" OF
                "Label Type"::Release:
                    BEGIN
                        GerotFreiGabeEtikett.SETTABLEVIEW(recLotNoInfo);
                        GerotFreiGabeEtikett.RUNMODAL;
                    END;
                "Label Type"::Quarantine:
                    BEGIN
                        GerotQuarantäneEtikett.SETTABLEVIEW(recLotNoInfo);
                        GerotQuarantäneEtikett.RUNMODAL;
                    END;
                "Label Type"::Analysis:
                    BEGIN
                        GerotAnalyseEtikett.SetType("Label Subtype");
                        GerotAnalyseEtikett.SETTABLEVIEW(recLotNoInfo);
                        GerotAnalyseEtikett.RUNMODAL;
                    END;
                ELSE
                    ERROR('Der gewünschte Etikettentyp existiert nicht!');
            END;
        end;

        procedure ChargenPruefpunkteShowAR()
        var
            frmAnalyseErgebniss: Page "50039";
            iVersion: Integer;
            fArtikelPruefpunkteListe: Page "50186";
            recAnalyseDBPruefungen: Record "50061";
        begin

            //-GL001

            //Wenn der Artikel mehrere Versionen hat, die richjtige Auswählen

            //Gibt es mehr als 1 Prüfpunkt Version zum Artikel?
            iVersion := frmAnalyseErgebniss.GetVersionAnzahl("Item No.");
            IF iVersion > 1 THEN BEGIN
                //Artikel Prüfpunkte Übersicht starten
                CLEAR(frmAnalyseErgebniss);
                fArtikelPruefpunkteListe.SetParameter("Item No.", FALSE);
                fArtikelPruefpunkteListe.RUNMODAL;
                //Rückgabe des Versions Wertes
                iVersion := fArtikelPruefpunkteListe.GetValue();
            END ELSE BEGIN
                iVersion *= (-1);  //Wenn nur eine Version vorhanden ist, ist sie zur erkennung negativ vorhanden
            END;

            frmAnalyseErgebniss.CreateAnnualReview("Item No.", TRUE, Rec, iVersion);  //Ausgabe ohne Chargenstammfilter aufrufen

            //+GL001
        end;
    */
    procedure SetBearbeitenStatus(bStatus: Boolean)
    begin
        //UPDATE2013
        bBearbeiten := bStatus;
    end;
}


