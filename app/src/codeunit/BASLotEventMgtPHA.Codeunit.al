codeunit 50006 BASLotEventMgtPHA
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Create Reserv. Entry", 'OnCreateReservEntryExtraFields', '', false, false)]
    local procedure OnCreateReservEntryExtraFields(var InsertReservEntry: Record "Reservation Entry"; OldTrackingSpecification: Record "Tracking Specification"; NewTrackingSpecification: Record "Tracking Specification")
    begin
        InsertReservEntry.BASSalesLotNoPHA := NewTrackingSpecification.BASSalesLotNoPHA;
    end;

    [EventSubscriber(ObjectType::Page, Page::"Item Tracking Lines", 'OnAfterCreateReservEntryFor', '', false, false)]
    local procedure OnAfterCreateReservEntryFor(var OldTrackingSpecification: Record "Tracking Specification"; var NewTrackingSpecification: Record "Tracking Specification"; var CreateReservEntry: Codeunit "Create Reserv. Entry")
    begin
    end;

    [EventSubscriber(ObjectType::Page, Page::"Item Tracking Lines", 'OnAfterCollectPostedOutputEntries', '', false, false)]
    local procedure OnAfterCollectPostedOutputEntries(ItemLedgerEntry: Record "Item Ledger Entry"; var TempTrackingSpecification: Record "Tracking Specification")
    begin
    end;

    [EventSubscriber(ObjectType::Page, Page::"Item Tracking Lines", 'OnAfterCopyTrackingSpec', '', false, false)]
    local procedure OnAfterCopyTrackingSpec(var SourceTrackingSpec: Record "Tracking Specification"; var DestTrkgSpec: Record "Tracking Specification")
    begin
        DestTrkgSpec.BASSalesLotNoPHA := SourceTrackingSpec.BASSalesLotNoPHA;
    end;

    [EventSubscriber(ObjectType::Page, Page::"Item Tracking Lines", 'OnAfterMoveFields', '', false, false)]
    local procedure OnAfterMoveFields(var TrkgSpec: Record "Tracking Specification"; var ReservEntry: Record "Reservation Entry")
    begin
        ReservEntry.BASSalesLotNoPHA := TrkgSpec.BASSalesLotNoPHA;
    end;

    [EventSubscriber(ObjectType::Page, Page::"Item Tracking Lines", 'OnAfterAssignNewTrackingNo', '', false, false)]
    local procedure OnAfterAssignNewTrackingNo(var TrkgSpec: Record "Tracking Specification"; xTrkgSpec: Record "Tracking Specification"; FieldID: Integer)
    var
        Item: Record Item;
        LotNoInformation: Record "Lot No. Information";
    begin
        TrkgSpec.BASSalesLotNoPHA := TrkgSpec."Lot No.";
        if Item.Get(TrkgSpec."Item No.") then
            if Item.BASItemTypePHA = Item.BASItemTypePHA::"Finished Product" then
                if LotNoInformation.Get(TrkgSpec."Item No.", TrkgSpec."Variant Code", TrkgSpec."Lot No.") then
                    TrkgSpec.BASSalesLotNoPHA := LotNoInformation.BASSalesLotNoPHA;
    end;

    [EventSubscriber(ObjectType::Page, Page::"Item Tracking Lines", 'OnBeforeLotNoOnAfterValidate', '', false, false)]
    local procedure OnBeforeLotNoOnAfterValidate(var TempTrackingSpecification: Record "Tracking Specification" temporary; SecondSourceQuantityArray: array[3] of Decimal)
    var
        LotNoInformation: Record "Lot No. Information";
    begin
        if LotNoInformation.Get(TempTrackingSpecification."Item No.", '', TempTrackingSpecification."Lot No.") then
            TempTrackingSpecification.BASSalesLotNoPHA := LotNoInformation.BASSalesLotNoPHA;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Tracking Management", 'OnAfterCreateLotInformation', '', false, false)]
    local procedure OnAfterCreateLotInformation(var LotNoInfo: Record "Lot No. Information"; var TrackingSpecification: Record "Tracking Specification")
    begin
        LotNoInfo.BASSalesLotNoPHA := TrackingSpecification.BASSalesLotNoPHA;
        LotNoInfo.BASExpirationDatePHA := TrackingSpecification."Expiration Date";
        LotNoInfo.Modify(false);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Jnl.-Post Line", 'OnAfterCheckItemTrackingInformation', '', false, false)]
    local procedure OnAfterCheckItemTrackingInformation(var ItemJnlLine2: Record "Item Journal Line"; var TrackingSpecification: Record "Tracking Specification"; ItemTrackingSetup: Record "Item Tracking Setup"; Item: Record Item)
    var
        LotNoInformation: Record "Lot No. Information";
    begin
        if LotNoInformation.Get(TrackingSpecification."Item No.", TrackingSpecification."Variant Code", TrackingSpecification."Lot No.") then
            if LotNoInformation.Description = '' then begin
                LotNoInformation.Description := Format(ItemJnlLine2."Document Type") + ', ' + ItemJnlLine2."Document No." + ', ' + Format(ItemJnlLine2."Document Date");
                LotNoInformation.Modify(false);
            end;
    end;

    [EventSubscriber(ObjectType::CodeUnit, Codeunit::"Reservation Engine Mgt.", 'OnBeforeUpdateItemTracking', '', false, false)]
    local procedure CU9000831OnBeforeUpdateItemTracking(var ReservEntry: Record "Reservation Entry"; var TrackingSpecification: Record "Tracking Specification")
    begin
        ReservEntry.BASSalesLotNoPHA := TrackingSpecification.BASSalesLotNoPHA;
    end;

    [EventSubscriber(ObjectType::Page, Page::"Item Tracking Lines", 'OnAfterUpdateExpDateEditable', '', false, false)]
    local procedure OnAfterUpdateExpDateEditable(var TrackingSpecification: Record "Tracking Specification"; var ExpirationDateEditable: Boolean; var ItemTrackingCode: Record "Item Tracking Code"; var NewExpirationDateEditable: Boolean; CurrentSignFactor: Integer)
    begin
        if not ExpirationDateEditable then
            if (TrackingSpecification."Source Type" = 39) and (TrackingSpecification."Source Subtype" = 1) then
                ExpirationDateEditable := true;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Tracking Management", 'OnBeforeTempHandlingSpecificationInsert', '', false, false)]
    local procedure OnBeforeTempHandlingSpecificationInsert(var TempTrackingSpecification: Record "Tracking Specification" temporary; ReservationEntry: Record "Reservation Entry"; var ItemTrackingCode: Record "Item Tracking Code"; var EntriesExist: Boolean)
    begin
        if (TempTrackingSpecification."Expiration Date" = 0D) and (ReservationEntry."Expiration Date" > 0D) then
            TempTrackingSpecification."Expiration Date" := ReservationEntry."Expiration Date";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Jnl.-Post Line", 'OnCheckExpirationDateOnBeforeTestFieldExpirationDate', '', false, false)]
    local procedure OnCheckExpirationDateOnBeforeTestFieldExpirationDate(var TempTrackingSpecification: Record "Tracking Specification" temporary; var EntriesExist: Boolean; var ExistingExpirationDate: Date)
    begin
        if TempTrackingSpecification."Expiration Date" > 0D then
            ExistingExpirationDate := TempTrackingSpecification."Expiration Date";
    end;

    [EventSubscriber(ObjectType::Table, Database::"Lot No. Information", 'OnAfterInsertEvent', '', false, false)]
    local procedure OnAfterInsertEvent(var Rec: Record "Lot No. Information"; RunTrigger: Boolean)
    begin
    end;

    [EventSubscriber(ObjectType::Table, Database::"Item Journal Line", 'OnBeforeCheckItemTracking', '', false, false)]
    local procedure OnBeforeCheckItemTracking(var ItemJournalLine: Record "Item Journal Line"; var IsHandled: Boolean)
    begin
        IsHandled := true;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Jnl. Line-Reserve", 'OnBeforeVerifyQuantity', '', false, false)]
    local procedure OnBeforeVerifyQuantity(var NewItemJournalLine: Record "Item Journal Line"; OldItemJournalLine: Record "Item Journal Line"; var ReservMgt: Codeunit "Reservation Management"; var Blocked: Boolean; var IsHandled: Boolean)
    begin
        PreventDeleteItemTracking(NewItemJournalLine, OldItemJournalLine, Blocked, IsHandled);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Jnl. Line-Reserve", 'OnBeforeVerifyChange', '', false, false)]
    local procedure OnBeforeVerifyChange(var NewItemJournalLine: Record "Item Journal Line"; OldItemJournalLine: Record "Item Journal Line"; var Blocked: Boolean; var IsHandled: Boolean)
    begin
        PreventDeleteItemTracking(NewItemJournalLine, OldItemJournalLine, Blocked, IsHandled);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Reservation Entry", 'OnAfterCopyTrackingFromTrackingSpec', '', false, false)]
    local procedure OnAfterCopyTrackingFromTrackingSpec(var ReservationEntry: Record "Reservation Entry"; TrackingSpecification: Record "Tracking Specification")
    begin
        ReservationEntry.BASSalesLotNoPHA := TrackingSpecification.BASSalesLotNoPHA;
        ReservationEntry."Expiration Date" := TrackingSpecification."Expiration Date";
    end;

    [EventSubscriber(ObjectType::Table, Database::"Reservation Entry", 'OnAfterCopyTrackingFromReservEntry', '', false, false)]
    local procedure OnAfterCopyTrackingFromReservEntry(var ReservationEntry: Record "Reservation Entry"; FromReservationEntry: Record "Reservation Entry")
    begin
        ReservationEntry.BASSalesLotNoPHA := FromReservationEntry.BASSalesLotNoPHA;
        ReservationEntry."Expiration Date" := FromReservationEntry."Expiration Date";
    end;

    procedure PreventDeleteItemTracking(var NewItemJournalLine: Record "Item Journal Line"; OldItemJournalLine: Record "Item Journal Line"; Blocked: Boolean; var IsHandled: Boolean)
    var
        ReservationEntry: Record "Reservation Entry";
    begin
        ReservationEntry.SetRange("Source ID", NewItemJournalLine."Journal Template Name");
        ReservationEntry.SetRange("Item No.", NewItemJournalLine."Item No.");
        ReservationEntry.SetRange("Lot No.", NewItemJournalLine."Lot No.");
        ReservationEntry.SetRange("Location Code", NewItemJournalLine."Location Code");
        ReservationEntry.SetRange("Quantity (Base)", NewItemJournalLine."Quantity (Base)");
        if NewItemJournalLine."Entry Type" = NewItemJournalLine."Entry Type"::"Negative Adjmt." then
            ReservationEntry.SetRange("Quantity (Base)", NewItemJournalLine."Quantity (Base)" * (-1));
        IsHandled := not ReservationEntry.IsEmpty;
    end;

    procedure InputLotNoForItemJnlLine(var ItemJnlLine: Record "Item Journal Line")
    var
        TrackingSpecification: Record "Tracking Specification";
        ForBatchName: Code[10];
        ForID: Code[20];
        ForLotNo: Code[50];
        ForRefNo: Integer;
        ForSubtype: Integer;
        ForType: Integer;
    begin
        ForType := Database::"Item Journal Line";

        if ItemJnlLine."Entry Type" = ItemJnlLine."Entry Type"::"Negative Adjmt." then
            ForSubtype := 3
        else
            ForSubtype := 2;

        ForID := ItemJnlLine."Journal Template Name";
        ForBatchName := ItemJnlLine."Journal Batch Name";
        ForRefNo := ItemJnlLine."Line No.";
        ForLotNo := ItemJnlLine."Lot No.";

        TrackingSpecification."Source Type" := ForType;
        TrackingSpecification."Source Subtype" := ForSubtype;
        TrackingSpecification."Source ID" := ForID;
        TrackingSpecification."Source Batch Name" := ForBatchName;
        TrackingSpecification."Source Prod. Order Line" := 0;
        TrackingSpecification."Source Ref. No." := ForRefNo;
        TrackingSpecification."Qty. per Unit of Measure" := ItemJnlLine."Qty. per Unit of Measure";
        TrackingSpecification."Quantity (Base)" := ItemJnlLine.Quantity;
        TrackingSpecification."Item No." := ItemJnlLine."Item No.";
        TrackingSpecification."Lot No." := ForLotNo;
        TrackingSpecification.BASSalesLotNoPHA := ItemJnlLine.BASSalesLotNoPHA;
        TrackingSpecification."Expiration Date" := ItemJnlLine."Expiration Date";
        TrackingSpecification."Location Code" := ItemJnlLine."Location Code";

        // ToDo -> all
        // if ItemTrackMgt.IsOrderNetworkEntity(ForType, ForSubtype) then
        //     CurrentEntryStatus := CurrentEntryStatus::Surplus
        // else
        //     CurrentEntryStatus := CurrentEntryStatus::Prospect;

        // ReservEntry.SetRange("Source Type", ForType);
        // ReservEntry.SetRange("Source Subtype", ForSubtype);
        // ReservEntry.SetRange("Source ID", ForID);
        // ReservEntry.SetRange("Source Batch Name", ForBatchName);
        // ReservEntry.SetRange("Source Prod. Order Line", ForProdOrderLine);
        // ReservEntry.SetRange("Source Ref. No.", ForRefNo);
        // ReservEntry.SetFilter(
        // "Reservation Status", '%1|%2', ReservEntry."Reservation Status"::Surplus, ReservEntry."Reservation Status"::Prospect);
        // ReservEntry.SetRange("Lot No.", ForLotNo);
        // if ReservEntry.FindFirst() then begin
        //     if CompareChargeToItemJnlLine(ReservEntry, ItemJnlLine) then
        //         exit;
        //     LöscheCharge(ForType, ForSubtype, ForID, ForBatchName, ForProdOrderLine, ForRefNo, ForLotNo);
        // end;

        // //Anlegen einer Artikelverfolgung mit den eigenen Feldern
        // CLEAR(ReservEntry);
        // ReservEntry.CopyTrackingFromSpec(recTrackingSpecification);

        // CreateReservEntry.CreateReservEntryFor(
        //               recTrackingSpecification."Source Type",
        //               recTrackingSpecification."Source Subtype",
        //               recTrackingSpecification."Source ID",
        //               recTrackingSpecification."Source Batch Name",
        //               recTrackingSpecification."Source Prod. Order Line",
        //               recTrackingSpecification."Source Ref. No.",
        //               recTrackingSpecification."Qty. per Unit of Measure",
        //               0,
        //               recTrackingSpecification."Quantity (Base)", ReservEntry);

        // CreateReservEntry.CreateEntry(recTrackingSpecification."Item No.",
        //               recTrackingSpecification."Variant Code",
        //               recTrackingSpecification."Location Code",
        //               recTrackingSpecification.Description,
        //               ItemJnlLine."Posting Date",
        //               ItemJnlLine."Posting Date", 0, CurrentEntryStatus);

        // CreateReservEntry.GetLastEntry(ReservEntry);
    end;

    // ToDo -> all
    procedure InputLotNoForSalesLine(var SalesLine: Record "Sales Line")
    var
        TrackingSpecification: Record "Tracking Specification";
        ForID: Code[20];
        ForLotNo: Code[50];
        ForRefNo: Integer;
        ForSubtype: Integer;
        ForType: Integer;
    begin
        ForType := 37;
        if SalesLine."Document Type" = SalesLine."Document Type"::Order then
            ForSubtype := 1
        else
            ForSubtype := 2;

        ForID := SalesLine."Document No.";
        ForRefNo := SalesLine."Line No.";
        // ToDo
        // ForLotNo := SalesLine."Lot No.";

        TrackingSpecification."Source Type" := ForType;
        TrackingSpecification."Source Subtype" := ForSubtype;
        TrackingSpecification."Source ID" := ForID;
        TrackingSpecification."Source Batch Name" := '';
        TrackingSpecification."Source Prod. Order Line" := 0;
        TrackingSpecification."Source Ref. No." := ForRefNo;
        TrackingSpecification."Qty. per Unit of Measure" := SalesLine."Qty. per Unit of Measure";
        TrackingSpecification."Quantity (Base)" := SalesLine.Quantity;
        TrackingSpecification."Item No." := SalesLine."No.";
        // ToDo
        // TrackingSpecification."Lot No." := ForLotNo;
        TrackingSpecification.BASSalesLotNoPHA := SalesLine.BASSalesLotNoPHA;
        TrackingSpecification."Expiration Date" := SalesLine.BASExpirationDatePHA;
        TrackingSpecification."Location Code" := SalesLine."Location Code";

        // if ItemTrackingMgt.IsOrderNetworkEntity(ForType, ForSubtype) then
        //     CurrentEntryStatus := CurrentEntryStatus::Surplus
        // else
        //     CurrentEntryStatus := CurrentEntryStatus::Prospect;

        // //Suche, ob Reservierungsposten zu Charge vorhanden
        // ReservEntry.SetRange("Source Type", ForType);
        // ReservEntry.SetRange("Source Subtype", ForSubtype);
        // ReservEntry.SetRange("Source ID", ForID);
        // ReservEntry.SetRange("Source Batch Name", ForBatchName);
        // ReservEntry.SetRange("Source Prod. Order Line", ForProdOrderLine);
        // ReservEntry.SetRange("Source Ref. No.", ForRefNo);
        // ReservEntry.SetFilter(
        // "Reservation Status", '%1|%2', ReservEntry."Reservation Status"::Surplus, ReservEntry."Reservation Status"::Prospect);
        // ReservEntry.SetRange("Lot No.", ForLotNo);
        // if ReservEntry.FindFirst() then begin
        //     //IF CompareChargeToItemJnlLine(ReservEntry, ItemJnlLine) THEN
        //     //    EXIT;
        //     LöscheCharge(ForType, ForSubtype, ForID, ForBatchName, ForProdOrderLine, ForRefNo, ForLotNo);
        // end;

        // //Anlegen einer Artikelverfolgung mit den eigenen Feldern
        // CLEAR(ReservEntry);
        // ReservEntry.CopyTrackingFromSpec(TrackingSpecification);

        // CreateReservEntry.CreateReservEntryFor(
        //               TrackingSpecification."Source Type",
        //               TrackingSpecification."Source Subtype",
        //               TrackingSpecification."Source ID",
        //               TrackingSpecification."Source Batch Name",
        //               TrackingSpecification."Source Prod. Order Line",
        //               TrackingSpecification."Source Ref. No.",
        //               TrackingSpecification."Qty. per Unit of Measure",
        //               0,
        //               TrackingSpecification."Quantity (Base)", ReservEntry);

        // CreateReservEntry.CreateEntry(TrackingSpecification."Item No.",
        //               TrackingSpecification."Variant Code",
        //               TrackingSpecification."Location Code",
        //               TrackingSpecification.Description,
        //               SalesLine."Posting Date",
        //               SalesLine."Posting Date", 0, CurrentEntryStatus);

        // CreateReservEntry.GetLastEntry(ReservEntry);
        // //Eigene Werte direkt in Reservierungsposten schreiben?

    end;

    procedure DeleteReservationEntry(ForType: Option; ForSubtype: Integer; ForID: Code[20]; ForBatchName: Code[10]; ForProdOrderLine: Integer; ForRefNo: Integer; ForLotNo: Code[50])
    var
        ReservationEntry: Record "Reservation Entry";
    begin
        ReservationEntry.SetRange("Source Type", ForType);
        ReservationEntry.SetRange("Source Subtype", ForSubtype);
        ReservationEntry.SetRange("Source ID", ForID);
        ReservationEntry.SetRange("Source Batch Name", ForBatchName);
        ReservationEntry.SetRange("Source Prod. Order Line", ForProdOrderLine);
        ReservationEntry.SetRange("Source Ref. No.", ForRefNo);
        ReservationEntry.SetFilter("Reservation Status", '%1|%2', ReservationEntry."Reservation Status"::Surplus, ReservationEntry."Reservation Status"::Prospect);
        ReservationEntry.Delete();
    end;

    // ToDo -> all
    procedure CompareChargeToItemJnlLine(var ReservationEntry: Record "Reservation Entry"; var ItemJnlLine: Record "Item Journal Line") Identical: Boolean
    // var
    //     ReservationEntry2: Record "Reservation Entry";
    begin
        // if ReservationEntry."Item No." <> ItemJnlLine."Item No." then
        //     exit(false);
        // if ReservationEntry."Lot No." <> ItemJnlLine."Lot No." then
        //     exit(false);
        // if ReservationEntry."Variant Code" <> ItemJnlLine."Variant Code" then
        //     exit(false);
        // if (ReservationEntry."Source Ref. No." <> ItemJnlLine."Line No.") then
        //     exit(false);
        // if (ReservationEntry."Source Subtype" <> ItemJnlLine."Entry Type") then
        //     exit(false);
        // if (ReservationEntry."Source ID" <> ItemJnlLine."Journal Template Name") then
        //     exit(false);
        // if (ReservationEntry."Source Batch Name" <> ItemJnlLine."Journal Batch Name") then
        //     exit(false);

        // if (ReservationEntry."Expiration Date" <> ItemJnlLine."Expiration Date") and (ItemJnlLine."Expiration Date" <> 0D) then
        //     exit(false);
        // if (ReservationEntry."Serial No." <> ItemJnlLine."Serial No.") and (ItemJnlLine."Serial No." <> '') then
        //     exit(false);
        // if (ReservationEntry."BASLieferantenchargennr.PHA" <> ItemJnlLine."BASLieferantenchargennr.PHA") and (ItemJnlLine."Lieferantenchargennr." <> '') then
        //     exit(false);

        // ReservationEntry2.SetRange("Source Type", ReservationEntry."Source Type");
        // ReservationEntry2.SetRange("Source Subtype", ReservationEntry."Source Subtype");
        // ReservationEntry2.SetRange("Source ID", ReservationEntry."Source ID");
        // ReservationEntry2.SetRange("Source Batch Name", ReservationEntry."Source Batch Name");
        // ReservationEntry2.SetRange("Source Prod. Order Line", ReservationEntry."Source Prod. Order Line");
        // ReservationEntry2.SetRange("Source Ref. No.", ReservationEntry."Source Ref. No.");
        // ReservationEntry2.SetFilter("Reservation Status", '%1|%2', ReservationEntry2."Reservation Status"::Surplus, ReservationEntry2."Reservation Status"::Prospect);
        // if ReservationEntry2.CalcSums("Quantity (Base)") then
        //     if (ReservationEntry2."Quantity (Base)" <> ItemJnlLine."Quantity (Base)") then
        //         exit(false);

        // exit(true);
    end;

    procedure GetChargenStatus(cItemNo: Code[20]; cLotNo: Code[20]) tChargenStatus: Text[20]
    var
        LotNoInformation: Record "Lot No. Information";
    begin
        tChargenStatus := '';
        if (StrLen(cItemNo) > 0) and (StrLen(cLotNo) > 0) then
            if LotNoInformation.Get(cItemNo, '', cLotNo) then
                tChargenStatus := Format(LotNoInformation.BASStatusPHA);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Tracking Data Collection", 'OnAssistEditTrackingNoOnBefoResetSources', '', false, false)]
    local procedure OnAssistEditTrackingNoOnBefoResetSources(var TempTrackingSpecification: Record "Tracking Specification" temporary; var TempGlobalEntrySummary: Record "Entry Summary" temporary; var MaxQuantity: Decimal)
    var
        LotNoInformation: Record "Lot No. Information";
    begin
        if TempGlobalEntrySummary.FindSet() then
            repeat
                if LotNoInformation.Get(TempTrackingSpecification."Item No.", TempTrackingSpecification."Variant Code", TempGlobalEntrySummary."Lot No.") then begin
                    TempGlobalEntrySummary.BASChargenstatusPHA := Format(LotNoInformation.BASStatusPHA);
                    TempGlobalEntrySummary.Modify(false);
                end;
            until TempGlobalEntrySummary.Next() = 0;
    end;
}