
page 50015 BASReleaseLotPHA
{
    ApplicationArea = All;
    DataCaptionExpression = 'Chargendaten - Änderungs: ' + Rec."Item No." + '  ' + Rec."Lot No.";
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Worksheet;
    SourceTable = "Lot No. Information";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            group(group)
            {
                //The GridLayout property is only supported on controls of type Grid
                //GridLayout = Columns;
                group(group2)
                {
                    field("Lot No."; Rec."Lot No.")
                    {
                        ApplicationArea = All;
                        Editable = bEditable;
                        Style = StandardAccent;
                        StyleExpr = FarbeLotNo;
                        ToolTip = 'Specifies the value of the Lot No. field.';

                        trigger OnValidate()
                        begin

                            //IF STRPOS("Change Status",'L') > 0 THEN StatusFarbeLotNo = ;

                            IF xRec."Lot No." <> Rec."Lot No." THEN
                                IF NOT CONFIRM('Wollen Sie die Chargennummer von %1 in %2 umbenennen?', FALSE, xRec."Lot No.", Rec."Lot No.") THEN
                                    ERROR('Chargennummer wurde nicht umbenannt');


                            //Unsichtbarer Filter ändern
                            Rec.FILTERGROUP(2);
                            Rec.SETRANGE("Lot No.", Rec."Lot No.");
                            Rec.FILTERGROUP(0);

                            SetChangeStatusFarben();
                        end;
                    }
                    field("Verkaufschargennr."; Rec."Verkaufschargennr.")
                    {
                        ApplicationArea = All;
                        Editable = bEditable;
                        Style = StandardAccent;
                        StyleExpr = FarbeVKCh;
                        ToolTip = 'Specifies the value of the Verkaufschargennr. field.';

                        trigger OnValidate()
                        begin
                            SetChangeStatusFarben();
                        end;
                    }
                    field("Lief. Chargennr."; Rec."Lief. Chargennr.")
                    {
                        ApplicationArea = All;
                        Editable = bEditable;
                        Style = StandardAccent;
                        StyleExpr = FarbeLiefCh;
                        ToolTip = 'Specifies the value of the Lief. Chargennr. field.';

                        trigger OnValidate()
                        begin
                            SetChangeStatusFarben();
                        end;
                    }
                    field("Expiration Date"; Rec."Expiration Date")
                    {
                        ApplicationArea = All;
                        Editable = bEditable;
                        Style = StandardAccent;
                        StyleExpr = FarbeAblaufDatum;
                        ToolTip = 'Specifies the value of the Expiration Date field.';

                        trigger OnValidate()
                        begin

                            IF NOT cuNaviPharma.AblaufDatumPlausibel(Rec."Item No.", Rec."Expiration Date") THEN
                                ERROR('Ablaufdatum %1 ist nicht Plausibel', FORMAT(Rec."Expiration Date"));

                            SetChangeStatusFarben();
                        end;
                    }
                    field(Erstablaufdatum; Rec.Erstablaufdatum)
                    {
                        ApplicationArea = All;
                        Editable = bEditable;
                        ToolTip = 'Specifies the value of the Erstablaufdatum field.';
                    }
                    field(Status; Rec.Status)
                    {
                        ApplicationArea = All;
                        Style = Favorable;
                        StyleExpr = StatusFarbe;
                        ToolTip = 'Specifies the value of the Status field.';

                        trigger OnValidate()
                        var

                        begin


                            IF recItem.GET(Rec."Item No.") THEN
                                IF (Rec.Status = Rec.Status::Frei) AND (recItem.Artikelart = recItem.Artikelart::Rohstoff) THEN
                                    IF Rec.Gehalt = 0 THEN
                                        MESSAGE('Hinweis: das Feld Gehalt ist noch leer');



                            SetStatusFarbe();

                            bEditable := TRUE;
                            //IF recItem."Site Batch Release" = 'WIEN' THEN  //GL006
                            IF Rec.Status = Rec.Status::Frei THEN
                                bEditable := FALSE;


                        END;



                    }

                    field(Freigabedatum; Rec.Freigabedatum)
                    {
                        ApplicationArea = All;
                        Caption = 'Änderung am';
                        Editable = false;
                        StyleExpr = TRUE;
                        ToolTip = 'Specifies the value of the Änderung am field.';

                        trigger OnValidate()
                        begin
                            SetChangeStatusFarben();
                        end;
                    }
                    field(Freigabename; Rec.Freigabename)
                    {
                        ApplicationArea = All;
                        Caption = 'Änderung durch';
                        Editable = false;
                        ToolTip = 'Specifies the value of the Änderung durch field.';

                    }
                    field(Gehalt; Rec.Gehalt)
                    {
                        ApplicationArea = All;
                        Editable = bEditable;
                        Style = StandardAccent;
                        StyleExpr = FarbeGehalt;
                        ToolTip = 'Specifies the value of the Gehalt field.';


                        trigger OnValidate()
                        begin
                            SetChangeStatusFarben();
                        end;
                    }
                    field(Lagerstand; Rec.Lagerstand)
                    {
                        ApplicationArea = All;
                        Editable = false;
                        ToolTip = 'Specifies the value of the Lagerstand field.';

                        trigger OnLookup(var Text: Text): Boolean
                        var
                            tempRecItemLedgerEntry: Record "32" temporary;
                        begin
                            //-UPDATE2013
                            tempRecItemLedgerEntry."Item No." := Rec."Item No.";
                            tempRecItemLedgerEntry.SETRANGE("Item No.", Rec."Item No.");
                            tempRecItemLedgerEntry.SETRANGE(Open, TRUE);
                            IF PAGE.RUNMODAL(PAGE::TransferInfo, tempRecItemLedgerEntry) = ACTION::LookupOK THEN;
                            //+UPDATE2013
                        end;

                    }
                    field(Description; Rec.Description)
                    {
                        ApplicationArea = All;
                        Editable = bEditable;
                        ToolTip = 'Specifies the value of the Description field.';
                    }
                    field(Laborkommentar; Rec.Laborkommentar)
                    {
                        ApplicationArea = All;
                        Editable = bEditable;
                        Style = StandardAccent;
                        StyleExpr = FarbeLabKommentar;
                        ToolTip = 'Specifies the value of the Laborkommentar field.';
                        trigger OnValidate()
                        begin
                            SetChangeStatusFarben();
                        end;
                    }
                    field("Laetus-Code"; Rec."Laetus-Code")
                    {
                        ApplicationArea = All;
                        Editable = bEditable;
                        ToolTip = 'Specifies the value of the Laetus-Code field.';
                    }
                    field(Packmittelversion; Rec.Packmittelversion)
                    {
                        ApplicationArea = All;
                        Editable = bEditable;
                        Style = StandardAccent;
                        StyleExpr = FarbePackmittelVersion;
                        ToolTip = 'Specifies the value of the Packmittelversion field.';
                        trigger OnValidate()
                        begin
                            SetChangeStatusFarben();
                        end;
                    }
                    field(HerstellerNr; Rec.HerstellerNr)
                    {
                        ApplicationArea = All;
                        Editable = bEditable;
                        ToolTip = 'Specifies the value of the HerstellerNr field.';
                    }
                    field("CEP Nr"; Rec."CEP Nr")
                    {
                        ApplicationArea = All;
                        Editable = bEditable;
                        ToolTip = 'Specifies the value of the CEP Nr field.';
                    }
                    field("Expiration Date DM"; Rec."Expiration Date DM")
                    {
                        ApplicationArea = All;
                        Caption = 'DM Ablaufdatum';
                        Editable = bEditable;
                        ToolTip = 'Specifies the value of the DM Ablaufdatum field.';
                    }
                    field("HF Kommentar"; Rec."HF Kommentar")
                    {
                        ApplicationArea = All;
                        Editable = bEditable;
                        ToolTip = 'Specifies the value of the HF Kommentar field.';
                        Visible = true;
                    }

                }

            }
        }
    }

    actions
    {
        area(processing)
        {
            action("ÜbersichtbeteiligteArtikel")
            {
                ApplicationArea = All;
                Caption = 'Übersicht beteiligte Artikel';
                Image = CheckList;
                Promoted = true;
                PromotedIsBig = true;
                ToolTip = 'Executes the Übersicht beteiligte Artikel action.';

                trigger OnAction()
                begin
                    ZeigeBeteiligteStufen(FALSE, Rec);
                end;
            }
            action(GesamtuebersichtArtikel)
            {
                ApplicationArea = All;
                Caption = 'Gesamtübersicht beteiligte Artikel';
                Image = CheckRulesSyntax;
                Promoted = true;
                PromotedIsBig = true;
                ToolTip = 'Executes the Gesamtübersicht beteiligte Artikel action.';

                trigger OnAction()
                begin
                    ZeigeBeteiligteStufen(TRUE, Rec);
                end;
            }
            action(TestComponents)
            {
                ApplicationArea = All;
                Caption = 'Komponenten testen';
                Image = PreviewChecks;
                Promoted = true;
                PromotedIsBig = true;
                ToolTip = 'Executes the Komponenten testen action.';
                trigger OnAction()
                begin
                    //cText := CheckComponents("Item No.", "Lot No.", FALSE, cInfoText);
                    //MESSAGE(cInfoText);
                end;
            }
            action("Änderungsprotokoll")
            {
                ApplicationArea = All;
                Image = ChangeLog;
                Promoted = true;
                PromotedIsBig = true;
                RunObject = Page 595;
                RunPageLink = "Table No." = FILTER(6505),
                              "Primary Key Field 1 Value" = FIELD("Item No.");
                RunPageView = SORTING("Table No.", "Primary Key Field 1 Value");
                ToolTip = 'Executes the Änderungsprotokoll action.';
            }

        }
    }

    trigger OnAfterGetRecord()
    var
        recItem: Record "27";
        cRechtText: Code[20];
    begin

        //Öffnen nur mit Berechtigung
        CLEAR(recItem);
        recItem.GET(Rec."Item No.");

        //-GL010
        //alt:
        //IF cuNaviPharma.Berechtigung('$'+ recItem."Item Tracking Code") = FALSE THEN
        //  ERROR('Keine Chargenfreigabe Berechtigung für %1 vorhanden!', recItem."Item Tracking Code");   //GL006  Meldung erweitert

        IF COMPANYNAME <> 'GL-DE' THEN BEGIN    //GL012
                                                //Neu:
            IF STRLEN(recItem."Site Batch Release") >= 4 THEN
                cRechtText := '$CHARGE' + COPYSTR(recItem."Site Batch Release", 1, 4)
            ELSE
                cRechtText := '$' + recItem."Item Tracking Code";
            IF cuNaviPharma.Berechtigung(cRechtText) = FALSE THEN
                ERROR('Keine Chargenfreigabe Berechtigung für %1 vorhanden!', cRechtText);
            //+GL010
        END;

        IF Rec.Artikelart = Rec.Artikelart::Fertigprodukt THEN
            IF cuNaviPharma.Berechtigung('$MARKTFREIGABE') = FALSE THEN
                ERROR('Keine Marktfreigabe Berechtigung vorhanden!');

        SetStatusFarbe();
        SetChangeStatusFarben();

        bEditable := TRUE;
        IF Rec.Status = Rec.Status::Frei THEN
            bEditable := FALSE;

        IF recItem.Artikelart = recItem.Artikelart::Halbfabrikat THEN
            bIsHF := TRUE;

    end;

    trigger OnInit()
    begin

    end;

    trigger OnOpenPage()
    begin

        //+GL002
        sTestumgebung := '';
        bTestumgebung := FALSE;


    end;

    var
        recItem: Record 27;
        recItemLedgEntry: Record "32";
        recProdEinrichtung: Record "99000765";
        cuNaviPharma: Codeunit NaviPharma;
        BacklogVisible: Boolean;
        bEditable: Boolean;
        bIsHF: Boolean;
        bLotNoEditable: Boolean;
        bTestumgebung: Boolean;
        bTrendAnzeige: Boolean;
        iAnzahlChargenAnzeige: Integer;
        cInfoText: Text;
        cText: Text;
        FarbeAblaufDatum: Text;
        FarbeGehalt: Text;
        FarbeLabKommentar: Text;
        FarbeLiefCh: Text;
        FarbeLotNo: Text;
        FarbePackmittelVersion: Text;
        FarbeStatus: Text;
        FarbeVKCh: Text;
        StatusFarbe: Text;
        StatusFarbeLotNo: Text;
        sTestumgebung: Text[50];




    procedure SetStatusFarbe()
    begin

        //Statusfarbe setzen
        StatusFarbe := 'Standard';

        IF Rec.Status = Rec.Status::Gesperrt THEN
            StatusFarbe := 'Attention';
        IF Rec.Status = Rec.Status::Frei THEN
            StatusFarbe := 'Favorable';
    end;

    procedure getEditStatus(sFieldName: Text[30]) bResult: Boolean
    var
        result: Boolean;
        iFieldNo: Integer;
    begin

        result := FALSE;
        IF sFieldName = 'Chargennr.' THEN
            result := bLotNoEditable AND (Rec.Status <> Rec.Status::Frei)
        ELSE
            IF getChangeLogStatus(sFieldName, iFieldNo) THEN
                result := Rec.Status <> Rec.Status::Frei
            ELSE
                result := TRUE;

        EXIT(result);
    end;

    procedure getChangeLogStatus(sFieldName: Text[30]; var iFieldNo: Integer) bResult: Boolean
    var
        recChangeLogSetupField: Record "404";
        result: Boolean;
    begin
        result := FALSE;
        recChangeLogSetupField.SETRANGE("Table No.", 6505);
        IF recChangeLogSetupField.FIND('-') THEN
            REPEAT
                recChangeLogSetupField.CALCFIELDS("Field Caption");
                result := recChangeLogSetupField."Field Caption" = sFieldName;
                IF result THEN iFieldNo := recChangeLogSetupField."Field No.";
            UNTIL (recChangeLogSetupField.NEXT = 0) OR result;
        //   IF result THEN MESSAGE('%1 [%2] im Protokoll', sFieldName, iFieldNo);
        IF sFieldName = 'Status' THEN result := FALSE;
        EXIT(result);
    end;

    procedure setLotNoEditable(bStatus: Boolean)
    begin
        bLotNoEditable := bStatus;
    end;

    procedure getModificationStatus(sFieldName: Text[30]; sFieldValue: Text[100]; bChangedOnly: Boolean) bResult: Boolean
    var
        recChangeLogEntry: Record "405";
        result: Boolean;
        iFieldNo: Integer;
    begin
        IF getChangeLogStatus(sFieldName, iFieldNo) THEN BEGIN
            recChangeLogEntry.SETRANGE("Table No.", 6505);
            recChangeLogEntry.SETRANGE("Field No.", iFieldNo);
            recChangeLogEntry.SETRANGE("Primary Key Field 1 Value", Rec."Item No.");
            //+GL003
            recChangeLogEntry.SETRANGE("Primary Key Field 3 Value", Rec."Lot No.");
            //-GL003
            recChangeLogEntry.SETRANGE("New Value", sFieldValue);

            result := recChangeLogEntry.FIND('-');
            EXIT(result);
        END;
    end;

    procedure ZeigeBeteiligteStufen(bUnfrei: Boolean; recLotNo: Record "6505")
    var
        bDummy: Boolean;
        sLotNr: Text[1024];
        sSubFA: Text[1024];
    begin
        sLotNr := '';
        recItemLedgEntry.RESET;
        recItemLedgEntry.SETCURRENTKEY("Item No.", "Lot No.", "Posting Date");
        recItemLedgEntry.SETFILTER("Item No.", recLotNo."Item No.");
        recItemLedgEntry.SETFILTER("Lot No.", recLotNo."Lot No.");
        IF recItemLedgEntry.FIND('-') THEN
            REPEAT
                IF (recItemLedgEntry."Order Type" = recItemLedgEntry."Order Type"::Production) AND (recItemLedgEntry."Order No." <> '') THEN BEGIN
                    //+GL002  JP
                    IF STRPOS(sLotNr, recItemLedgEntry."Order No.") = 0 THEN
                        sLotNr := sLotNr + recItemLedgEntry."Order No." + '|';

                    IF bUnfrei THEN BEGIN
                        sSubFA := ZeigeBeteiligteUnterStufen1(recItemLedgEntry."Item No.", recItemLedgEntry."Order No.", sLotNr);
                        IF STRLEN(sSubFA) > 0 THEN BEGIN
                            sLotNr := sLotNr + sSubFA + '|';
                        END;
                    END;
                END;
            //-GL002
            UNTIL recItemLedgEntry.NEXT = 0
        ELSE
            EXIT;
        IF STRLEN(sLotNr) > 0 THEN sLotNr := DELSTR(sLotNr, STRLEN(sLotNr), 1) ELSE sLotNr := '$unmöglicheFANr';
        recItemLedgEntry.RESET;
        //+001
        //recItemLedgEntry.SETCURRENTKEY("Prod. Order No.", "Prod. Order Line No.", "Prod. Order Comp. Line No.", "Entry Type");
        recItemLedgEntry.SETCURRENTKEY("Order Type", "Order No.", "Order Line No.", "Entry Type", "Prod. Order Comp. Line No.");
        //-001
        recItemLedgEntry.SETFILTER("Order No.", sLotNr);
        bDummy := recItemLedgEntry.FIND('-');
        PAGE.RUNMODAL(50194, recItemLedgEntry);
    end;

    procedure ZeigeBeteiligteUnterStufen1("Item No.": Code[10]; FANo: Code[10]; sLotnr1: Text[1024]) SUnterLot1: Text[1024]
    var
        recItemLedgEntry1: Record "32";
        recItemLedgEntry2: Record "32";
        bDummy: Boolean;
        sLotNr: Text[1024];
        sSubFA: Text[1024];
    begin
        SUnterLot1 := '';
        recItemLedgEntry1.RESET;
        recItemLedgEntry1.SETCURRENTKEY("Order Type", "Order No.", "Order Line No.", "Entry Type", "Prod. Order Comp. Line No.");
        //recItemLedgEntry1.SETFILTER("Item No.","Item No.");
        recItemLedgEntry1.SETRANGE("Order Type", recItemLedgEntry1."Order Type"::Production);
        recItemLedgEntry1.SETFILTER("Order No.", FANo);


        IF recItemLedgEntry1.FIND('-') THEN
            REPEAT
                recItemLedgEntry2.RESET;
                //++GL003
                //  recItemLedgEntry2.SETCURRENTKEY("Prod. Order No.","Prod. Order Line No.","Entry Type","Prod. Order Comp. Line No.");
                recItemLedgEntry2.SETCURRENTKEY("Item No.", "Lot No.", "Posting Date");
                //--GL003

                recItemLedgEntry2.SETFILTER("Item No.", recItemLedgEntry1."Item No.");
                recItemLedgEntry2.SETFILTER("Lot No.", recItemLedgEntry1."Lot No.");
                recItemLedgEntry2.SETRANGE("Entry Type", recItemLedgEntry2."Entry Type"::Output); //Output Verbrauch
                                                                                                  // recItemLedgEntry2.SETfilter("Entry Type",'7');
                IF recItemLedgEntry2.FIND('-') THEN
                    REPEAT
                        //???IF (recItemLedgEntry2."Order Type" <> recItemLedgEntry2."Order Type"::Production) AND (recItemLedgEntry2."Order No." <> '') THEN
                        IF (recItemLedgEntry2."Order No." <> '') THEN BEGIN
                            IF (STRPOS(SUnterLot1, recItemLedgEntry2."Order No.") = 0) AND
                               (STRPOS(sLotnr1, recItemLedgEntry2."Order No.") = 0) THEN
                                SUnterLot1 := SUnterLot1 + recItemLedgEntry2."Order No." + '|';
                            sSubFA := ZeigeBeteiligteUnterStufen2(recItemLedgEntry2."Item No.", recItemLedgEntry2."Order No.", sLotnr1);
                            IF (STRLEN(sSubFA) > 0) THEN
                                IF (STRPOS(SUnterLot1, sSubFA)) = 0 THEN BEGIN
                                    SUnterLot1 := SUnterLot1 + sSubFA + '|';
                                END;
                        END;
                    UNTIL recItemLedgEntry2.NEXT = 0
            UNTIL recItemLedgEntry1.NEXT = 0
        ELSE
            EXIT;
        IF STRLEN(SUnterLot1) > 0 THEN SUnterLot1 := DELSTR(SUnterLot1, STRLEN(SUnterLot1), 1) ELSE SUnterLot1 := '$unmöglicheFANr1';
        recItemLedgEntry1.RESET;
    end;

    procedure ZeigeBeteiligteUnterStufen2("Item No.": Code[10]; FANo: Code[10]; sLotNr2: Text[1024]) SUnterLot2: Text[1024]
    var
        recItemLedgEntry1: Record "32";
        recItemLedgEntry2: Record "32";
        bDummy: Boolean;
        sLotNr: Text[1024];
    begin
        SUnterLot2 := '';
        recItemLedgEntry1.RESET;
        recItemLedgEntry1.SETCURRENTKEY("Order Type", "Order No.", "Order Line No.", "Entry Type", "Prod. Order Comp. Line No.");
        //recItemLedgEntry1.SETFILTER("Item No.","Item No.");
        recItemLedgEntry1.SETRANGE("Order Type", recItemLedgEntry1."Order Type"::Production);
        recItemLedgEntry1.SETFILTER("Order No.", FANo);


        IF recItemLedgEntry1.FIND('-') THEN
            REPEAT
                recItemLedgEntry2.RESET;
                //++GL003
                //  recItemLedgEntry2.SETCURRENTKEY("Prod. Order No.","Prod. Order Line No.","Entry Type","Prod. Order Comp. Line No.");
                recItemLedgEntry2.SETCURRENTKEY("Item No.", "Lot No.", "Posting Date");
                //--GL003
                recItemLedgEntry2.SETFILTER("Item No.", recItemLedgEntry1."Item No.");
                recItemLedgEntry2.SETFILTER("Lot No.", recItemLedgEntry1."Lot No.");
                recItemLedgEntry2.SETRANGE("Entry Type", recItemLedgEntry2."Entry Type"::Output);
                IF recItemLedgEntry2.FIND('-') THEN
                    REPEAT
                        //???IF (recItemLedgEntry2."Order Type" <> recItemLedgEntry2."Order Type"::Production) AND (recItemLedgEntry2."Order No." <> '') THEN
                        IF (recItemLedgEntry2."Order No." <> '') THEN BEGIN
                            IF (STRPOS(SUnterLot2, recItemLedgEntry2."Order No.") = 0) AND
                               (STRPOS(sLotNr2, recItemLedgEntry2."Order No.") = 0) THEN
                                SUnterLot2 := SUnterLot2 + recItemLedgEntry2."Order No." + '|';
                        END;
                    UNTIL recItemLedgEntry2.NEXT = 0
            UNTIL recItemLedgEntry1.NEXT = 0
        ELSE
            EXIT;
        IF STRLEN(SUnterLot2) > 0 THEN SUnterLot2 := DELSTR(SUnterLot2, STRLEN(SUnterLot2), 1) ELSE SUnterLot2 := '$unmöglicheFANr2';
        recItemLedgEntry1.RESET;
    end;

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
        /*
                IF STRPOS("Change Status",'L') > 0 THEN
                  FarbeLotNo := 'StandardAccent';
                IF STRPOS("Change Status",'D') > 0 THEN
                  FarbeLiefCh := 'StandardAccent';
                IF STRPOS("Change Status",'E') > 0 THEN
                  FarbeAblaufDatum := 'StandardAccent';
                IF STRPOS("Change Status",'V') > 0 THEN
                  FarbeVKCh := 'StandardAccent';
                IF STRPOS("Change Status",'G') > 0 THEN
                  FarbeGehalt := 'StandardAccent';
                IF STRPOS("Change Status",'M') > 0 THEN
                  FarbeLabKommentar := 'StandardAccent';
                IF STRPOS("Change Status",'S') > 0 THEN
                  FarbeStatus := 'StandardAccent';
                IF STRPOS("Change Status",'P') > 0 THEN
                  FarbePackmittelVersion := 'StandardAccent';
                  */
    end;


}

