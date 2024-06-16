
//TASK53 TASK53.01          20.03.2024  MFU:  Verkaufschargennr von Artikelverfolgung mitbuchen
//TASK40 TASK40.01          03.04.2024  MFU:  Chargenstamm Anpassungeen: Lagerstand Info dazu, Chargenfreigabe
//Task57 Task57.01          11.04.2024  MFU:  Änderungsprotokoll  

pageextension 50005 LotInformationList extends "Lot No. Information List"
{
    layout
    {
        addafter("Lot No.")
        {
            // >> TASK40.01    
            field(Status; Rec.Status)
            {
                ApplicationArea = All;
                Editable = false;
                ToolTip = 'Chargenstatus';
                Visible = true;
            }
            // << TASK40.01

            // >> TASK53.01    
            field("Verkaufschargennr."; Rec."Verkaufschargennr.")
            {
                ApplicationArea = Basic, Suite;
                ToolTip = 'Verkaufschargennr.';
                Visible = true;
            }
            // << TASK53.01

            // >> TASK53.01    
            field("Expiration Date"; Rec."Expiration Date")
            {
                ApplicationArea = Basic, Suite;
                ToolTip = 'Ablaufdatum';
                Visible = true;
            }
            // << TASK53.01
        }

        // >> TASK40.01
        modify(Inventory)
        {
            ApplicationArea = All;

            trigger OnDrillDown()
            var
                tempRecItemLedgerEntry: Record "Item Ledger Entry" temporary;
                s: record "Lot No. Information";
            begin
                // >> CCU
                //Aufrufen der Lagerstand Seite und nicht die Artikelposten
                tempRecItemLedgerEntry."Item No." := "Item No.";
                tempRecItemLedgerEntry.SetRange("Item No.", "Item No.");
                tempRecItemLedgerEntry.SetRange(Open, TRUE);

                IF Rec.GETFILTER("Location Filter") > '' THEN
                    tempRecItemLedgerEntry.SETFILTER("Location Code", Rec.GETFILTER("Location Filter"));

                IF PAGE.RUNMODAL(PAGE::UmlagerInfoNeu, tempRecItemLedgerEntry) = ACTION::LookupOK THEN;
                // << CCU
            end;

        }
        // << TASK40.01
    }

    actions
    {
        addfirst(processing)
        {

            action("GL-Chargenfreigabe")
            {
                ApplicationArea = All;
                Image = OpenWorksheet;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    recLNI: Record "Lot No. Information";
                begin

                    IF recLNI.GET(Rec."Item No.", Rec."Variant Code", Rec."Lot No.") THEN
                        OpenGLChargenfreigabe(recLNI);

                end;
            }


            // >> Task57.01
            action("Änderungsprotokoll")
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    pChangeLogLookup: Page BASChangeLogEntryPHA;
                begin

                    CLEAR(pChangeLogLookup);
                    pChangeLogLookup.setFilterByRec('', Rec);
                    pChangeLogLookup.RUNMODAL;

                end;
            }
            // << Task57.01

        }
    }

    local procedure OpenGLChargenfreigabe(var recLNI_: Record "Lot No. Information")
    var
        //recLotStatusNAV: Record Lot;   //Lot-/ Serial No. Status   5034621
        //recLotStatusLIMS: Record "5034621";
        recITC: Record "6502";
        //cuNaviPharma: Codeunit "50506";
        recItem: Record Item;
        recLot: Record "Lot No. Information";
        recLotTmp: Record "Lot No. Information" temporary;
        ActResult: Action;
        bEditable: Boolean;

    begin
        // COMMIT;

        CLEAR(recLotTmp);
        recLotTmp.COPY(recLNI_);
        recLotTmp.INSERT;
        recLotTmp.SetRange("Item No.", recLNI_."Item No.");
        recLotTmp.SetRange("Lot No.", recLNI_."Lot No.");
        //Eigene Page mit TmpRecord öffnen


        ActResult := PAGE.RUNMODAL(PAGE::GLChargenfreigabe, recLotTmp);
        IF ActResult IN [ACTION::OK, ACTION::LookupOK] THEN BEGIN

            //Marktfreigabepin nur bei Statusänderung prüfen
            //IF recLotTmp.Status <> recLNI_.Status THEN BEGIN
            //    CheckMarktfreigabePin();
            //END;

            //Chargenfreigebefunktion auch für direkten Aufruf von Lims
            GLChargenStammSpeichern(recLotTmp, recLNI_);  //recLotTmp->Neue Chargenwerte;  Rec->alte Chargenwerte

            //Seite neu laden
            CurrPage.UPDATE(FALSE);

        END;

    end;


    local procedure GLChargenStammSpeichern(recLotTmpNew: Record "Lot No. Information"; recLotOld: Record "Lot No. Information"): Boolean
    var
        recItem: Record Item;
        recILE: Record "Item Ledger Entry";
        recLot: Record "Lot No. Information";
        bOk: Boolean;
        DoMepisUpdate: Boolean;
        cExpDatefilter: Code[10];
        cQuarantinefilter: Code[10];
        cRetestDatefilter: Code[10];
        cStatusfilter: Code[10];
        cTradeUnitfilter: Code[10];
        tReturn: Text;

    begin

        //Chargenfreigabe nach Variante NAV2013 machen! -> Status in T6505 umsetzen
        IF recLot.Get(recLotTmpNew."Item No.", recLotTmpNew."Variant Code", recLotTmpNew."Lot No.") then begin

            IF recLotTmpNew.Status <> recLotOld.Status THEN begin
                recLot.Status := recLotTmpNew.Status;
                if recLot.Status = recLot.Status::Frei then begin
                    recLot.Freigabedatum := Today;
                    recLot.Freigabename := UserId;
                end;
            end;

            //Andere Felder in Chargenstamm schreiben
            recLot."Verkaufschargennr." := recLotTmpNew."Verkaufschargennr.";
            recLot."Expiration Date" := recLotTmpNew."Expiration Date";
            recLot.Description := recLotTmpNew.Description;
            //Weitere Felder speichern?


            recLot.Modify(true);
        end;


        //Umbuchen des Lagerstand nur mit Funktionen in QM Modul möglich!

    end;



    //Globale Variablen
    var
        cuCodeSammlung: codeunit CodesammlungGLDE;

}
