
//TASK53 TASK53.01   20.03.2024  MFU:  Verkaufschargennr von Artikelverfolgung mitbuchen
//TASK59 TASK59.01   23.04.2024  MFU:  Zusätzliche Felder für Anzeige von Chargeninfos auf Page


codeunit 50006 ChargenverwaltungPageApp
{

    [EventSubscriber(ObjectType::Codeunit, 99000830, 'OnCreateReservEntryExtraFields', '', false, false)]
    local procedure CU99000830OnCreateReservEntryExtraFields(var InsertReservEntry: Record "Reservation Entry"; OldTrackingSpecification: Record "Tracking Specification"; NewTrackingSpecification: Record "Tracking Specification")
    begin
        // >> TASK53.01
        InsertReservEntry.BASSalesLotNoPHA := NewTrackingSpecification.BASSalesLotNoPHA;
        // << TASK53.01
    end;

    [EventSubscriber(ObjectType::Page, 6510, 'OnAfterCreateReservEntryFor', '', false, false)]
    local procedure P6510OnAfterCreateReservEntryFor(var OldTrackingSpecification: Record "Tracking Specification"; var NewTrackingSpecification: Record "Tracking Specification"; var CreateReservEntry: Codeunit "Create Reserv. Entry")
    begin
        // >> TASK53.01
        //NewTrackingSpecification.BASSalesLotNoPHA := OldTrackingSpecification.BASSalesLotNoPHA;
        // << TASK53.01
    end;


    [EventSubscriber(ObjectType::Page, 6510, 'OnAfterCollectPostedOutputEntries', '', false, false)]
    local procedure P6510OnAfterCollectPostedOutputEntries(ItemLedgerEntry: Record "Item Ledger Entry"; var TempTrackingSpecification: Record "Tracking Specification")
    var
        recLot: Record "Lot No. Information";
    begin
        // >> TASK53.01
        //IF recLot.Get(TempTrackingSpecification."Item No.", TempTrackingSpecification."Variant Code", TempTrackingSpecification."Lot No.") then begin
        //    TempTrackingSpecification.BASSalesLotNoPHA := recLot.BASSalesLotNoPHA;
        //end;
        // << TASK53.01
    end;


    [EventSubscriber(ObjectType::Page, 6510, 'OnAfterCopyTrackingSpec', '', false, false)]
    local procedure P6510OnAfterCopyTrackingSpec(var SourceTrackingSpec: Record "Tracking Specification"; var DestTrkgSpec: Record "Tracking Specification")
    begin
        // >> TASK53.01
        //Beim schließen der Artikelverfolgung in den Ziel Record kopieren
        DestTrkgSpec.BASSalesLotNoPHA := SourceTrackingSpec.BASSalesLotNoPHA;
        // << TASK53.01 
    end;


    [EventSubscriber(ObjectType::Page, 6510, 'OnAfterMoveFields', '', false, false)]
    local procedure P6510OnAfterMoveFields(var TrkgSpec: Record "Tracking Specification"; var ReservEntry: Record "Reservation Entry")
    begin
        // >> TASK53.01
        //Eigene Felder in der Artikelverfolgung mitspeichern
        ReservEntry.BASSalesLotNoPHA := TrkgSpec.BASSalesLotNoPHA;
        // << TASK53.01
    end;


    [EventSubscriber(ObjectType::Page, 6510, 'OnAfterAssignNewTrackingNo', '', false, false)]
    local procedure P6510OnAfterAssignNewTrackingNo(var TrkgSpec: Record "Tracking Specification"; xTrkgSpec: Record "Tracking Specification"; FieldID: Integer)
    var
        recItem: Record Item;
        recLot: Record "Lot No. Information";
    begin
        // >> TASK53.01
        TrkgSpec.BASSalesLotNoPHA := TrkgSpec."Lot No.";  //Defaultzuweisung
        IF recItem.GET(TrkgSpec."Item No.") then
            if recItem.Artikelart = recItem.Artikelart::Fertigprodukt then begin
                if recLot.Get(TrkgSpec."Item No.", TrkgSpec."Variant Code", TrkgSpec."Lot No.") then
                    TrkgSpec.BASSalesLotNoPHA := recLot.BASSalesLotNoPHA;
            end;

        // << TASK53.01
    end;

    [EventSubscriber(ObjectType::Page, 6510, 'OnBeforeLotNoOnAfterValidate', '', false, false)]
    local procedure P6510OnBeforeLotNoOnAfterValidate(var TempTrackingSpecification: Record "Tracking Specification" temporary; SecondSourceQuantityArray: array[3] of Decimal)
    var
        recItem: Record Item;
        recLot: Record "Lot No. Information";
    begin
        // >> TASK53.01
        //Gibt es zu der eingegebenen Chargennr einen Chargenstamm Eintrag? -> Wenn Ja VK-Charge setzen
        if recLot.Get(TempTrackingSpecification."Item No.", '', TempTrackingSpecification."Lot No.") then begin
            TempTrackingSpecification.BASSalesLotNoPHA := recLot.BASSalesLotNoPHA;
        end;
        // << TASK53.01
    end;




    [EventSubscriber(ObjectType::Codeunit, 6500, 'OnAfterCreateLotInformation', '', false, false)]
    local procedure CU6500OnAfterCreateLotInformation(var LotNoInfo: Record "Lot No. Information"; var TrackingSpecification: Record "Tracking Specification")
    begin
        // >> TASK53.01
        //Beim Anlegen des Chargenstamm eigene Felder mitschreiben  !! -> Funkt noch nicht!
        LotNoInfo.BASSalesLotNoPHA := TrackingSpecification.BASSalesLotNoPHA;
        LotNoInfo."Expiration Date" := TrackingSpecification."Expiration Date";
        LotNoInfo.Modify(false);  //Sind hier schon nach dem Insert also nochmal speichern
        // << TASK53.01
    end;

    [EventSubscriber(ObjectType::Codeunit, 22, 'OnAfterCheckItemTrackingInformation', '', false, false)]
    local procedure CU22OnAfterCheckItemTrackingInformation(var ItemJnlLine2: Record "Item Journal Line"; var TrackingSpecification: Record "Tracking Specification"; ItemTrackingSetup: Record "Item Tracking Setup"; Item: Record Item)
    var
        recLot: Record "Lot No. Information";
    begin
        // >> TASK53.01
        IF recLot.GET(TrackingSpecification."Item No.", TrackingSpecification."Variant Code", TrackingSpecification."Lot No.") then begin
            //Beim Anlegen des Chargenstamm eigene Felder mitschreiben  !! -> Funkt noch nicht!
            if recLot.Description = '' then begin
                recLot.Description := Format(ItemJnlLine2."Document Type") + ', ' + ItemJnlLine2."Document No." + ', ' + Format(ItemJnlLine2."Document Date");
                recLot.Modify(false);  //Sind hier schon nach dem Insert also nochmal speichern
            end;
        end
        // << TASK53.01
    end;

    [EventSubscriber(ObjectType::Table, 83, 'OnAfterCopyTrackingFromSpec', '', false, false)]
    local procedure CU22OnAfterCopyTrackingFromSpec(var ItemJournalLine: Record "Item Journal Line"; TrackingSpecification: Record "Tracking Specification")
    begin
        // >> TASK53.01
        /*
                ItemJournalLine.BASSalesLotNoPHA := TrackingSpecification.BASSalesLotNoPHA;
                //Infos vom Wareneingang über IJL in Chargenstamm schreiben
                if ItemJournalLine."Entry Type" = ItemJournalLine."Entry Type"::Purchase then begin
                    ItemJournalLine.BASSalesLotNoPHA := TrackingSpecification.BASSalesLotNoPHA;
                end;
        */
        // << TASK53.01
    end;

    [EventSubscriber(ObjectType::CodeUnit, 99000831, 'OnBeforeUpdateItemTracking', '', false, false)]
    local procedure CU9000831OnBeforeUpdateItemTracking(var ReservEntry: Record "Reservation Entry"; var TrackingSpecification: Record "Tracking Specification")
    begin
        // >> TASK53.01
        ReservEntry.BASSalesLotNoPHA := TrackingSpecification.BASSalesLotNoPHA;
        // << TASK53.01    
    end;


    [EventSubscriber(ObjectType::Page, 6510, 'OnAfterUpdateExpDateEditable', '', false, false)]
    local procedure P6510OnAfterUpdateExpDateEditable(var TrackingSpecification: Record "Tracking Specification"; var ExpirationDateEditable: Boolean; var ItemTrackingCode: Record "Item Tracking Code"; var NewExpirationDateEditable: Boolean; CurrentSignFactor: Integer)
    begin
        // >> TASK53.01
        //Ablaufdatum bei Bestellungen editierbar machen
        if ExpirationDateEditable = false then begin
            if (TrackingSpecification."Source Type" = 39) and (TrackingSpecification."Source Subtype" = 1) then
                ExpirationDateEditable := true;
        end;
        // << TASK53.01 
    end;

    [EventSubscriber(ObjectType::Codeunit, 6500, 'OnBeforeTempHandlingSpecificationInsert', '', false, false)]
    local procedure CU6500OnBeforeTempHandlingSpecificationInsert(var TempTrackingSpecification: Record "Tracking Specification" temporary; ReservationEntry: Record "Reservation Entry"; var ItemTrackingCode: Record "Item Tracking Code"; var EntriesExist: Boolean)
    begin
        // >> TASK53.01
        //Ablaufdatum bei buchen der Bestellung von den Reservierungsposten in die Ablaufverfolgung kopieren
        if (TempTrackingSpecification."Expiration Date" = 0D) and (ReservationEntry."Expiration Date" > 0D) then
            TempTrackingSpecification."Expiration Date" := ReservationEntry."Expiration Date";
        // << TASK53.01 
    end;


    [EventSubscriber(ObjectType::Codeunit, 22, 'OnCheckExpirationDateOnBeforeTestFieldExpirationDate', '', false, false)]
    local procedure Cu22OnCheckExpirationDateOnBeforeTestFieldExpirationDate(var TempTrackingSpecification: Record "Tracking Specification" temporary; var EntriesExist: Boolean; var ExistingExpirationDate: Date)
    begin
        // >> TASK53.01
        //Beim buchen der Bestellungeinen fehler umgehen
        if TempTrackingSpecification."Expiration Date" > 0D then
            ExistingExpirationDate := TempTrackingSpecification."Expiration Date";
        // << TASK53.01 
    end;

    [EventSubscriber(ObjectType::Table, 6505, 'OnAfterInsertEvent', '', false, false)]
    local procedure T6505OnAfterInsertEvent(var Rec: Record "Lot No. Information"; RunTrigger: Boolean)
    begin
        //TestEvent
        //Message('Lot Insert');

    end;

    // TASK58.01  Löschen der Chargennr bei manueller Auswahl einer Charge im Artikelbuchblatt verhindern
    [EventSubscriber(ObjectType::Table, 83, 'OnBeforeCheckItemTracking', '', false, false)]
    local procedure T83OnBeforeCheckItemTracking(var ItemJournalLine: Record "Item Journal Line"; var IsHandled: Boolean)
    begin
        IsHandled := true;
    end;


    // TASK58.01  Bei Mengenänderung in ArtikelBuchblatt, das löschen von schon richtig erstellter Artikelverfolgung verhindern 
    [EventSubscriber(ObjectType::Codeunit, 99000835, 'OnBeforeVerifyQuantity', '', false, false)]
    local procedure CU99000835OnBeforeVerifyQuantity(var NewItemJournalLine: Record "Item Journal Line"; OldItemJournalLine: Record "Item Journal Line"; var ReservMgt: Codeunit "Reservation Management"; var Blocked: Boolean; var IsHandled: Boolean)
    var
        recRes: Record "Reservation Entry";
    begin

        //Gibt es eine passende Reservierung zu dem Artikel?
        //recRes.SetRange("Source Type", NewItemJournalLine."Source Type");
        recRes.SetRange("Source ID", NewItemJournalLine."Journal Template Name");
        recRes.SetRange("Item No.", NewItemJournalLine."Item No.");
        recRes.SetRange("Lot No.", NewItemJournalLine."Lot No.");
        recRes.SetRange("Location Code", NewItemJournalLine."Location Code");

        recRes.SetRange("Quantity (Base)", NewItemJournalLine."Quantity (Base)");
        IF NewItemJournalLine."Entry Type" = NewItemJournalLine."Entry Type"::"Negative Adjmt." THEN
            recRes.SetRange("Quantity (Base)", NewItemJournalLine."Quantity (Base)" * (-1));
        //recRes.SetRange("Reservation Status",recRes."Reservation Status"::Prospect);
        IF recRes.FindFirst() then
            IsHandled := true;  //MFU true !!

    end;

    // TASK58.01  Bei Mengenänderung in ArtikelBuchblatt, das löschen von schon richtig erstellter Artikelverfolgung verhindern 
    [EventSubscriber(ObjectType::Codeunit, 99000835, 'OnBeforeVerifyChange', '', false, false)]
    local procedure CU99000835OnBeforeVerifyChange(var NewItemJournalLine: Record "Item Journal Line"; OldItemJournalLine: Record "Item Journal Line"; var Blocked: Boolean; var IsHandled: Boolean)
    var
        recRes: Record "Reservation Entry";
    begin

        //Gibt es eine passende Reservierung zu dem Artikel?
        //recRes.SetRange("Source Type", NewItemJournalLine."Source Type");
        recRes.SetRange("Source ID", NewItemJournalLine."Journal Template Name");
        recRes.SetRange("Item No.", NewItemJournalLine."Item No.");
        recRes.SetRange("Lot No.", NewItemJournalLine."Lot No.");
        recRes.SetRange("Location Code", NewItemJournalLine."Location Code");

        recRes.SetRange("Quantity (Base)", NewItemJournalLine."Quantity (Base)");
        IF NewItemJournalLine."Entry Type" = NewItemJournalLine."Entry Type"::"Negative Adjmt." THEN
            recRes.SetRange("Quantity (Base)", NewItemJournalLine."Quantity (Base)" * (-1));
        //recRes.SetRange("Reservation Status",recRes."Reservation Status"::Prospect);
        IF recRes.FindFirst() then
            IsHandled := true;  //MFU true !!

    end;

    // >> TASK58.01
    [EventSubscriber(ObjectType::Table, 337, 'OnAfterCopyTrackingFromTrackingSpec', '', false, false)]
    local procedure T337OnAfterCopyTrackingFromTrackingSpec(var ReservationEntry: Record "Reservation Entry"; TrackingSpecification: Record "Tracking Specification")
    begin
        //Nach dem Kopieren der Werte in Artikelvervolgung  Aus Funktion EingabeChargeForItemJnlLine() -> ReservEntry.CopyTrackingFromSpec()
        //Verkaufscharge mitkopieren
        ReservationEntry.BASSalesLotNoPHA := TrackingSpecification.BASSalesLotNoPHA;
        ReservationEntry."Expiration Date" := TrackingSpecification."Expiration Date";
    end;
    // << TASK58.01
    // >> TASK58.01
    [EventSubscriber(ObjectType::Table, 337, 'OnAfterCopyTrackingFromReservEntry', '', false, false)]
    local procedure T337OnAfterCopyTrackingFromReservEntry(var ReservationEntry: Record "Reservation Entry"; FromReservationEntry: Record "Reservation Entry")
    begin
        //Verkaufscharge bei Eingabe in Artikelbuchblatt in Artikelverfolgung mitkopieren
        ReservationEntry.BASSalesLotNoPHA := FromReservationEntry.BASSalesLotNoPHA;
        ReservationEntry."Expiration Date" := FromReservationEntry."Expiration Date";
    end;
    // << TASK58.01


    // >> TASK58.01
    procedure EingabeChargeForItemJnlLine(VAR ItemJnlLine: Record "Item Journal Line")
    var
        ReservEntry: Record "Reservation Entry";
        recTrackingSpecification: Record "Tracking Specification";
        ItemTrackMgt: Codeunit "6500";
        CreateReservEntry: Codeunit "Create Reserv. Entry";
        ForBatchName: Code[10];
        ForID: Code[20];
        ForLotNo: Code[50];
        ForProdOrderLine: Integer;
        ForRefNo: Integer;
        ForSubtype: Integer;
        ForType: Integer;
        CurrentEntryStatus: Option Reservation,Tracking,Surplus,Prospect;

    begin

        WITH ItemJnlLine DO BEGIN

            //Befüllen von Variablen für weitere Schritte
            ForType := 83;
            if ItemJnlLine."Entry Type" = ItemJnlLine."Entry Type"::"Negative Adjmt." then
                ForSubtype := 3
            else
                ForSubtype := 2;

            ForID := "Journal Template Name";
            ForBatchName := "Journal Batch Name";
            ForProdOrderLine := 0;
            ForRefNo := "Line No.";
            ForLotNo := "Lot No.";

            //Werte in Tracking Tabelle füllen um mit Standart Funktionen weiter machen zu können
            recTrackingSpecification."Source Type" := ForType;
            recTrackingSpecification."Source Subtype" := ForSubtype;
            recTrackingSpecification."Source ID" := ForID;
            recTrackingSpecification."Source Batch Name" := ForBatchName;
            recTrackingSpecification."Source Prod. Order Line" := 0;
            recTrackingSpecification."Source Ref. No." := ForRefNo;
            recTrackingSpecification."Qty. per Unit of Measure" := "Qty. per Unit of Measure";
            recTrackingSpecification."Quantity (Base)" := Quantity;  //"Quantity (Base)";
            recTrackingSpecification."Item No." := "Item No.";
            recTrackingSpecification."Lot No." := ForLotNo;
            recTrackingSpecification.BASSalesLotNoPHA := BASSalesLotNoPHA;
            recTrackingSpecification."Expiration Date" := "Expiration Date";
            recTrackingSpecification."Location Code" := "Location Code";



        END;

        IF ItemTrackMgt.IsOrderNetworkEntity(
        ForType,
        ForSubtype)
        THEN
            CurrentEntryStatus := CurrentEntryStatus::Surplus
        ELSE
            CurrentEntryStatus := CurrentEntryStatus::Prospect;

        //Suche, ob Reservierungsposten zu Charge vorhanden
        ReservEntry.SetRange("Source Type", ForType);
        ReservEntry.SetRange("Source Subtype", ForSubtype);
        ReservEntry.SetRange("Source ID", ForID);
        ReservEntry.SetRange("Source Batch Name", ForBatchName);
        ReservEntry.SetRange("Source Prod. Order Line", ForProdOrderLine);
        ReservEntry.SetRange("Source Ref. No.", ForRefNo);
        ReservEntry.SetFilter(
        "Reservation Status", '%1|%2', ReservEntry."Reservation Status"::Surplus, ReservEntry."Reservation Status"::Prospect);
        ReservEntry.SetRange("Lot No.", ForLotNo);
        IF ReservEntry.FINDFIRST() THEN BEGIN
            IF CompareChargeToItemJnlLine(ReservEntry, ItemJnlLine) THEN
                EXIT;
            LöscheCharge(ForType, ForSubtype, ForID, ForBatchName, ForProdOrderLine, ForRefNo, ForLotNo);
        END;

        //Anlegen einer Artikelverfolgung mit den eigenen Feldern
        CLEAR(ReservEntry);
        ReservEntry.CopyTrackingFromSpec(recTrackingSpecification);

        CreateReservEntry.CreateReservEntryFor(
                      recTrackingSpecification."Source Type",
                      recTrackingSpecification."Source Subtype",
                      recTrackingSpecification."Source ID",
                      recTrackingSpecification."Source Batch Name",
                      recTrackingSpecification."Source Prod. Order Line",
                      recTrackingSpecification."Source Ref. No.",
                      recTrackingSpecification."Qty. per Unit of Measure",
                      0,
                      recTrackingSpecification."Quantity (Base)", ReservEntry);

        CreateReservEntry.CreateEntry(recTrackingSpecification."Item No.",
                      recTrackingSpecification."Variant Code",
                      recTrackingSpecification."Location Code",
                      recTrackingSpecification.Description,
                      ItemJnlLine."Posting Date",
                      ItemJnlLine."Posting Date", 0, CurrentEntryStatus);

        CreateReservEntry.GetLastEntry(ReservEntry);
        //Eigene Werte direkt in Reservierungsposten schreiben?

    end;
    // << TASK58.01

    procedure EingabeChargeForSalesLine(VAR SalesLine: Record "Sales Line")
    var
        ReservEntry: Record "Reservation Entry";
        recTrackingSpecification: Record "Tracking Specification";
        ItemTrackMgt: Codeunit "6500";
        CreateReservEntry: Codeunit "Create Reserv. Entry";
        ForBatchName: Code[10];
        ForID: Code[20];
        ForLotNo: Code[50];
        ForProdOrderLine: Integer;
        ForRefNo: Integer;
        ForSubtype: Integer;
        ForType: Integer;
        CurrentEntryStatus: Option Reservation,Tracking,Surplus,Prospect;

    begin

        WITH SalesLine DO BEGIN

            //Befüllen von Variablen für weitere Schritte
            ForType := 37;
            if SalesLine."Document Type" = SalesLine."Document Type"::Order then
                ForSubtype := 1
            else
                ForSubtype := 2;  //Passt das für alles außer Auftrag??

            ForID := "Document No.";
            //ForBatchName := "Journal Batch Name";
            ForProdOrderLine := 0;
            ForRefNo := "Line No.";
            ForLotNo := "Lot No.";

            //Werte in Tracking Tabelle füllen um mit Standart Funktionen weiter machen zu können
            recTrackingSpecification."Source Type" := ForType;
            recTrackingSpecification."Source Subtype" := ForSubtype;
            recTrackingSpecification."Source ID" := ForID;
            recTrackingSpecification."Source Batch Name" := '';
            recTrackingSpecification."Source Prod. Order Line" := 0;
            recTrackingSpecification."Source Ref. No." := ForRefNo;
            recTrackingSpecification."Qty. per Unit of Measure" := "Qty. per Unit of Measure";
            recTrackingSpecification."Quantity (Base)" := Quantity;  //"Quantity (Base)";
            recTrackingSpecification."Item No." := "No.";
            recTrackingSpecification."Lot No." := ForLotNo;
            recTrackingSpecification.BASSalesLotNoPHA := BASSalesLotNoPHA;
            recTrackingSpecification."Expiration Date" := "Expiration Date";
            recTrackingSpecification."Location Code" := "Location Code";

        END;

        IF ItemTrackMgt.IsOrderNetworkEntity(
        ForType,
        ForSubtype)
        THEN
            CurrentEntryStatus := CurrentEntryStatus::Surplus
        ELSE
            CurrentEntryStatus := CurrentEntryStatus::Prospect;

        //Suche, ob Reservierungsposten zu Charge vorhanden
        ReservEntry.SetRange("Source Type", ForType);
        ReservEntry.SetRange("Source Subtype", ForSubtype);
        ReservEntry.SetRange("Source ID", ForID);
        ReservEntry.SetRange("Source Batch Name", ForBatchName);
        ReservEntry.SetRange("Source Prod. Order Line", ForProdOrderLine);
        ReservEntry.SetRange("Source Ref. No.", ForRefNo);
        ReservEntry.SetFilter(
        "Reservation Status", '%1|%2', ReservEntry."Reservation Status"::Surplus, ReservEntry."Reservation Status"::Prospect);
        ReservEntry.SetRange("Lot No.", ForLotNo);
        IF ReservEntry.FINDFIRST() THEN BEGIN
            //IF CompareChargeToItemJnlLine(ReservEntry, ItemJnlLine) THEN
            //    EXIT;
            LöscheCharge(ForType, ForSubtype, ForID, ForBatchName, ForProdOrderLine, ForRefNo, ForLotNo);
        END;

        //Anlegen einer Artikelverfolgung mit den eigenen Feldern
        CLEAR(ReservEntry);
        ReservEntry.CopyTrackingFromSpec(recTrackingSpecification);

        CreateReservEntry.CreateReservEntryFor(
                      recTrackingSpecification."Source Type",
                      recTrackingSpecification."Source Subtype",
                      recTrackingSpecification."Source ID",
                      recTrackingSpecification."Source Batch Name",
                      recTrackingSpecification."Source Prod. Order Line",
                      recTrackingSpecification."Source Ref. No.",
                      recTrackingSpecification."Qty. per Unit of Measure",
                      0,
                      recTrackingSpecification."Quantity (Base)", ReservEntry);

        CreateReservEntry.CreateEntry(recTrackingSpecification."Item No.",
                      recTrackingSpecification."Variant Code",
                      recTrackingSpecification."Location Code",
                      recTrackingSpecification.Description,
                      SalesLine."Posting Date",
                      SalesLine."Posting Date", 0, CurrentEntryStatus);

        CreateReservEntry.GetLastEntry(ReservEntry);
        //Eigene Werte direkt in Reservierungsposten schreiben?

    end;
    // << TASK58.01



    // >> TASK58.01
    procedure "LöscheCharge"(ForType: Option; ForSubtype: Integer; ForID: Code[20]; ForBatchName: Code[10]; ForProdOrderLine: Integer; ForRefNo: Integer; ForLotNo: Code[50])
    var
        ReservEntry: Record "Reservation Entry";
    begin

        //Suche, ob Reservierungsposten zu Charge vorhanden
        ReservEntry.SetRange("Source Type", ForType);
        ReservEntry.SetRange("Source Subtype", ForSubtype);
        ReservEntry.SetRange("Source ID", ForID);
        ReservEntry.SetRange("Source Batch Name", ForBatchName);
        ReservEntry.SetRange("Source Prod. Order Line", ForProdOrderLine);
        ReservEntry.SetRange("Source Ref. No.", ForRefNo);
        //ReservEntry.SetRange("Lot No.", ForLotNo); //Nicht nach Charge Filtern, damit beim ändern der Charge die Reservierung gefunden wird
        ReservEntry.SetFilter(
          "Reservation Status", '%1|%2', ReservEntry."Reservation Status"::Surplus, ReservEntry."Reservation Status"::Prospect);
        IF ReservEntry.FINDFIRST() THEN
            ReservEntry.DELETE();

    end;
    // << TASK58.01


    procedure CompareChargeToItemJnlLine(var ReservationEntry: Record "337"; var ItemJnlLine: Record "83") Identical: Boolean
    var
        recRE2: Record "337";
    begin
        IF ReservationEntry."Item No." <> ItemJnlLine."Item No." THEN
            EXIT(FALSE);
        IF ReservationEntry."Lot No." <> ItemJnlLine."Lot No." THEN
            EXIT(FALSE);
        IF ReservationEntry."Variant Code" <> ItemJnlLine."Variant Code" THEN
            EXIT(FALSE);
        IF (ReservationEntry."Source Ref. No." <> ItemJnlLine."Line No.") THEN
            EXIT(FALSE);
        IF (ReservationEntry."Source Subtype" <> ItemJnlLine."Entry Type") THEN
            EXIT(FALSE);
        IF (ReservationEntry."Source ID" <> ItemJnlLine."Journal Template Name") THEN
            EXIT(FALSE);
        IF (ReservationEntry."Source Batch Name" <> ItemJnlLine."Journal Batch Name") THEN
            EXIT(FALSE);

        IF (ReservationEntry."Expiration Date" <> ItemJnlLine."Expiration Date") AND (ItemJnlLine."Expiration Date" <> 0D) THEN
            EXIT(FALSE);
        IF (ReservationEntry."Serial No." <> ItemJnlLine."Serial No.") AND (ItemJnlLine."Serial No." <> '') THEN
            EXIT(FALSE);
        IF (ReservationEntry."Lieferantenchargennr." <> ItemJnlLine."Lieferantenchargennr.") AND (ItemJnlLine."Lieferantenchargennr." <> '') THEN
            EXIT(FALSE);
        //IF (ReservationEntry.BASSalesLotNoPHA <> ItemJnlLine.ex) AND (ItemJnlLine."External Lot No." <> '') THEN
        //  EXIT(FALSE);
        //IF (ReservationEntry.Gebindeanzahl <> ItemJnlLine.Gebindeanzahl) AND (ItemJnlLine.Gebindeanzahl <> 0) THEN
        //  EXIT(FALSE);
        //IF (ReservationEntry.Gebindeartencode <> ItemJnlLine.Gebindeartencode) AND (ItemJnlLine.Gebindeartencode <> '') THEN
        //  EXIT(FALSE);
        //IF (ReservationEntry.Palettenanzahl <> ItemJnlLine.Palettenanzahl) AND (ItemJnlLine.Palettenanzahl <> 0) THEN
        //  EXIT(FALSE);

        recRE2.SetRange("Source Type", ReservationEntry."Source Type");
        recRE2.SetRange("Source Subtype", ReservationEntry."Source Subtype");
        recRE2.SetRange("Source ID", ReservationEntry."Source ID");
        recRE2.SetRange("Source Batch Name", ReservationEntry."Source Batch Name");
        recRE2.SetRange("Source Prod. Order Line", ReservationEntry."Source Prod. Order Line");
        recRE2.SetRange("Source Ref. No.", ReservationEntry."Source Ref. No.");
        recRE2.SetFilter(
          "Reservation Status", '%1|%2', recRE2."Reservation Status"::Surplus, recRE2."Reservation Status"::Prospect);
        IF recRE2.CALCSUMS("Quantity (Base)") THEN BEGIN
            IF (recRE2."Quantity (Base)" <> ItemJnlLine."Quantity (Base)") THEN
                EXIT(FALSE);
        END;

        EXIT(TRUE);
    end;


    procedure GetChargenStatus(cItemNo: Code[20]; cLotNo: Code[20]) tChargenStatus: Text[20]
    var
        recLot: Record "Lot No. Information";
    begin
        tChargenStatus := '';
        IF (StrLen(cItemNo) > 0) AND (StrLen(cLotNo) > 0) THEN
            IF recLot.GET(cItemNo, '', cLotNo) THEN
                tChargenStatus := FORMAT(recLot.Status);
    end;


    // >> TASK59.01
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Tracking Data Collection", 'OnAssistEditTrackingNoOnBeforeSetSources', '', false, false)]
    local procedure CU6501OnAssistEditTrackingNoOnBeforeSetSources(var TempTrackingSpecification: Record "Tracking Specification" temporary; var TempGlobalEntrySummary: Record "Entry Summary" temporary; var MaxQuantity: Decimal)
    var
        recLot: Record "Lot No. Information";
        bOK: Boolean;
    begin
        /*
        //Befüllen der TempTrackingSpecification mit den zusätzlichen Infos zur Charge
        IF TempTrackingSpecification."Entry No." = 0 then
            bOK := TempTrackingSpecification.FindFirst()
        else
            bOK := true;
        */
        bOK := true;
        if bOK then begin
            if TempGlobalEntrySummary.FindSet() then
                repeat
                    IF recLot.GET(TempTrackingSpecification."Item No.", TempTrackingSpecification."Variant Code", TempGlobalEntrySummary."Lot No.") then begin
                        TempGlobalEntrySummary.Chargenstatus := Format(recLot.Status);
                        TempGlobalEntrySummary.Modify(false);
                    end;
                until TempGlobalEntrySummary.Next() = 0;
        end;

    end;
    // << TASK59.01


}
