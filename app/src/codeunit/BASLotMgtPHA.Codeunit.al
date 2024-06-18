codeunit 50002 BASLotMgtPHA
{
    Permissions =
        tabledata "Inventory Setup" = R,
        tabledata Item = R,
        tabledata "Item Journal Line" = R,
        tabledata "Item Ledger Entry" = RM,
        tabledata "Manufacturing Setup" = R,
        tabledata "Production Order" = R,
        tabledata "Purchase Line" = R,
        tabledata "Reservation Entry" = RIMD,
        tabledata "Tracking Specification" = RM;

    var
        ReservEntry: Record "Reservation Entry";
        TrackingSpecification: Record "Tracking Specification";
        CreateReservEntry: Codeunit "Create Reserv. Entry";
        Text000Txt: Label 'Verarbeitung unterbrochen!';
        Text001Txt: Label '%1 in den Posten wird mitverändert!\ Wollen Sie Fortfahren?', comment = 'DEA="%1 in den Posten wird mitverändert!\ Wollen Sie Fortfahren?"', Locked = true;
        Text002Txt: Label 'Von Artikel %1, Charge %2 sind im Lager %3 nur mehr %4 vorhanden!', comment = 'DEA="Von Artikel %1, Charge %2 sind im Lager %3 nur mehr %4 vorhanden!"', Locked = true;

    procedure FaktMengeCharge(ForType: Option; ForSubtype: Enum "Purchase Document Type"; ForID: Code[20]; ForBatchName: Code[10]; ForProdOrderLine: Integer; ForRefNo: Integer; ForLotNo: Code[50]; InvQuantity: Decimal)
    var
        QtyToInvoiceThisLine: Decimal;
        TotalQtyToInvoice: Decimal;
        CurrentSignFactor: Integer;
    begin
        ReservEntry."Source Type" := ForType;
        // ToDo -> check optionfield in ReservEntry
        ReservEntry.Validate("Source Subtype", ForSubtype);
        CurrentSignFactor := CreateReservEntry.SignFactor(ReservEntry);
        TotalQtyToInvoice := InvQuantity * CurrentSignFactor;

        TrackingSpecification.SetRange("Source Type", ForType);
        TrackingSpecification.SetRange("Source Subtype", ForSubtype);
        TrackingSpecification.SetRange("Source ID", ForID);
        TrackingSpecification.SetRange("Source Batch Name", ForBatchName);
        TrackingSpecification.SetRange("Source Prod. Order Line", ForProdOrderLine);
        TrackingSpecification.SetRange("Source Ref. No.", ForRefNo);
        TrackingSpecification.SetRange("Lot No.", ForLotNo);
        if TrackingSpecification.FindSet() then
            repeat
                if not TrackingSpecification.Correction then begin
                    QtyToInvoiceThisLine :=
                      TrackingSpecification."Quantity Handled (Base)" - TrackingSpecification."Quantity Invoiced (Base)";
                    if ABS(QtyToInvoiceThisLine) > ABS(TotalQtyToInvoice) then
                        QtyToInvoiceThisLine := TotalQtyToInvoice;

                    if TrackingSpecification."Qty. to Invoice (Base)" <> QtyToInvoiceThisLine then begin
                        TrackingSpecification."Qty. to Invoice (Base)" := QtyToInvoiceThisLine;
                        TrackingSpecification.Modify();
                    end;

                    TotalQtyToInvoice -= QtyToInvoiceThisLine;
                end;
            until TrackingSpecification.Next() = 0;

        ReservEntry.SetRange("Source Type", ForType);
        ReservEntry.SetRange("Source Subtype", ForSubtype);
        ReservEntry.SetRange("Source ID", ForID);
        ReservEntry.SetRange("Source Batch Name", ForBatchName);
        ReservEntry.SetRange("Source Prod. Order Line", ForProdOrderLine);
        ReservEntry.SetRange("Source Ref. No.", ForRefNo);
        ReservEntry.SetFilter(
          "Reservation Status", '%1|%2', ReservEntry."Reservation Status"::Surplus, ReservEntry."Reservation Status"::Prospect);
        ReservEntry.SetRange("Lot No.", ForLotNo);
        if ReservEntry.FindSet() then
            repeat
                QtyToInvoiceThisLine := ReservEntry."Quantity (Base)";

                if ABS(QtyToInvoiceThisLine) > ABS(TotalQtyToInvoice) then
                    QtyToInvoiceThisLine := TotalQtyToInvoice;

                if (ReservEntry."Qty. to Invoice (Base)" <> QtyToInvoiceThisLine) and not ReservEntry.Correction then begin
                    ReservEntry."Qty. to Invoice (Base)" := QtyToInvoiceThisLine;
                    ReservEntry.Modify();
                end;

                TotalQtyToInvoice -= QtyToInvoiceThisLine;
            until (ReservEntry.Next() = 0) or (TotalQtyToInvoice = 0);
    end;

    procedure LiefMengeCharge(ForType: Option; ForSubtype: Integer; ForID: Code[20]; ForBatchName: Code[10]; ForProdOrderLine: Integer; ForRefNo: Integer; ForLotNo: Code[20]; InvQuantity: Decimal)
    var
        QtyToHandleThisLine: Decimal;
        TotalQtyToHandle: Decimal;
        CurrentSignFactor: Integer;
    begin
        ReservEntry."Source Type" := ForType;
        ReservEntry."Source Subtype" := ForSubtype;
        CurrentSignFactor := CreateReservEntry.SignFactor(ReservEntry);
        TotalQtyToHandle := InvQuantity * CurrentSignFactor;

        ReservEntry.SetRange("Source Type", ForType);
        ReservEntry.SetRange("Source Subtype", ForSubtype);
        ReservEntry.SetRange("Source ID", ForID);
        ReservEntry.SetRange("Source Batch Name", ForBatchName);
        ReservEntry.SetRange("Source Prod. Order Line", ForProdOrderLine);
        ReservEntry.SetRange("Source Ref. No.", ForRefNo);
        ReservEntry.SetFilter(
          "Reservation Status", '%1|%2', ReservEntry."Reservation Status"::Surplus, ReservEntry."Reservation Status"::Prospect);
        ReservEntry.SetRange("Lot No.", ForLotNo);
        if ReservEntry.FindSet() then
            repeat
                QtyToHandleThisLine := ReservEntry."Quantity (Base)";

                if ABS(QtyToHandleThisLine) > ABS(TotalQtyToHandle) then
                    QtyToHandleThisLine := TotalQtyToHandle;

                if (ReservEntry."Qty. to Handle (Base)" <> QtyToHandleThisLine) and not ReservEntry.Correction then begin
                    ReservEntry."Qty. to Handle (Base)" := QtyToHandleThisLine;
                    ReservEntry.Modify();
                end;

                TotalQtyToHandle -= QtyToHandleThisLine;

            until (ReservEntry.Next() = 0) or (TotalQtyToHandle = 0);
    end;

    procedure SelectLotNoEntry(var LotNoInformation2: Record "Lot No. Information"): Boolean
    var
        Item: Record Item;
        LotNoInformation: Record "Lot No. Information";
    begin
        Item.Get(LotNoInformation2."Item No.");
        Item.TestField("Item Tracking Code");

        LotNoInformation.SetRange("Item No.", LotNoInformation2."Item No.");
        LotNoInformation.SetFilter(Inventory, '>0');
        if LotNoInformation2."Location Filter" <> '' then
            LotNoInformation.SetFilter("Location Filter", LotNoInformation2."Location Filter");

        if LotNoInformation2."Bin Filter" <> '' then
            LotNoInformation.SetFilter(LotNoInformation."Bin Filter", LotNoInformation2."Bin Filter");

        if LotNoInformation2.GetFilter(Inventory) <> '' then
            LotNoInformation.SetFilter(LotNoInformation.Inventory, LotNoInformation2.GetFilter(Inventory));

        LotNoInformation."Item No." := LotNoInformation2."Item No.";
        LotNoInformation."Lot No." := LotNoInformation2."Lot No.";

        if Page.RunModal(Page::"Lot No. Information List", LotNoInformation) = Action::LookupOK then begin
            LotNoInformation2 := LotNoInformation;
            exit(true);
        end;
    end;

    procedure InsertLot(ItemJnlLine: Record "Item Journal Line")
    var
        Item: Record Item;
        LotNoInformation: Record "Lot No. Information";
        PurchLine: Record "Purchase Line";
        Navipharma: Codeunit BASNaviPharmaPHA;
    begin
        GlobalLanguage(3079);

        if ItemJnlLine."Lot No." = '' then
            exit;

        if not LotNoInformation.Get(ItemJnlLine."Item No.", ItemJnlLine."Variant Code", ItemJnlLine."Lot No.") then begin
            LotNoInformation.Init();
            LotNoInformation."Item No." := ItemJnlLine."Item No.";
            LotNoInformation."Variant Code" := '';
            LotNoInformation."Lot No." := ItemJnlLine."Lot No.";
            LotNoInformation.BASExpirationDatePHA := ItemJnlLine."Expiration Date";
            LotNoInformation.BASSalesLotNoPHA := ItemJnlLine.BASSalesLotNoPHA;
            // ToDo
            // LotNoInformation.BASShipmentLotNoPHA := ItemJnlLine."Lieferantenchargennr.";
            LotNoInformation.BASPackmittelversionPHA := ItemJnlLine.BASPackmittelversionPHA;
            LotNoInformation.Description :=
                StrSubstNo(
                    '%1 %2; %3', ItemJnlLine."Entry Type", ItemJnlLine."Document No.", Format(ItemJnlLine."Posting Date", 0, '<day,2>.<month,2>.<year4>'));

            if ItemJnlLine."Entry Type" = ItemJnlLine."Entry Type"::Purchase then begin
                PurchLine.SetRange("Document No.", ItemJnlLine.BASOrderNoPHA);
                PurchLine.SetRange("No.", ItemJnlLine."Item No.");
                if PurchLine.FindFirst() then
                    if StrLen(PurchLine.BASManufaturingNoPHA) > 0 then
                        LotNoInformation.BASManufaturingNoPHA := PurchLine.BASManufaturingNoPHA;

                // ToDo                
                // if StrLen(PurchLine."CEP Nr") > 0 then
                //     LotNoInformation."CEP Nr" := PurchLine."CEP Nr";

                if PurchLine.BASExpirationDateDMPHA <> '' then
                    LotNoInformation.BASExpirationDateDMPHA := PurchLine.BASExpirationDateDMPHA;
            end else begin
                // ToDo
                ;
                ;
                // if ItemJnlLine."Entry Type" = ItemJnlLine."Entry Type"::"Positive Adjmt." then
                //     if (StrLen(ItemJnlLine.BASManufaturingNoPHA) > 0) and (StrLen(LotNoInformation.BASManufaturingNoPHA) = 0) then
                //         LotNoInformation.BASManufaturingNoPHA := HerstellerNr;
                // if (StrLen("CEP Nr") > 0) and (StrLen(LotNoInformation."CEP Nr") = 0) then
                //     LotNoInformation."CEP Nr" := "CEP Nr";
            end;

            LotNoInformation.BASOpenPHA := true;

            if (ItemJnlLine."Location Code" <> '') and (Navipharma.StandortWeiche('LOCATION_SITE_MANUFACTURING', ItemJnlLine."Location Code") = 'WIEN') then
                if Item.Get(ItemJnlLine."Item No.") then
                    LotNoInformation.BASLaetusCodePHA := Item.BASLaetusCodePHA;

            LotNoInformation.Insert();
        end;
    end;

    procedure FaktMengeChargeAlt(ForType: Option; ForSubtype: Integer; ForID: Code[20]; ForBatchName: Code[10]; ForProdOrderLine: Integer; ForRefNo: Integer; ForLotNo: Code[20]; InvQuantity: Decimal)
    var
        CurrentSignFactor: Integer;
    begin
        ReservEntry.SetRange("Source Type", ForType);
        ReservEntry.SetRange("Source Subtype", ForSubtype);
        ReservEntry.SetRange("Source ID", ForID);
        ReservEntry.SetRange("Source Batch Name", ForBatchName);
        ReservEntry.SetRange("Source Prod. Order Line", ForProdOrderLine);
        ReservEntry.SetRange("Source Ref. No.", ForRefNo);
        ReservEntry.SetFilter(
          "Reservation Status", '%1|%2', ReservEntry."Reservation Status"::Surplus, ReservEntry."Reservation Status"::Prospect);
        ReservEntry.SetRange("Lot No.", ForLotNo);
        if ReservEntry.FindFirst() then begin
            CurrentSignFactor := CreateReservEntry.SignFactor(ReservEntry);

            ReservEntry."Qty. to Invoice (Base)" := InvQuantity * CurrentSignFactor;
            ReservEntry.Modify();
        end;
    end;

    procedure "Aktualisiere Verkaufscharge"("Artikelnr.": Code[20]; "Chargennr.": Code[20]; Option: Option BASSalesLotNoPHA,Haltbarkeitsdatum; VKCNeu: Code[20]; HBNeu: Date): Boolean
    var
        ItemLedgEntry: Record "Item Ledger Entry";
    begin
        if Option = Option::BASSalesLotNoPHA then
            if not Confirm(Text001Txt, false, ItemLedgEntry.FIELDCAPTION(BASSalesLotNoPHA)) then
                Error(Text000Txt);

        if Option = Option::Haltbarkeitsdatum then
            if not Confirm(Text001Txt, false, ItemLedgEntry.FIELDCAPTION("Expiration Date")) then
                Error(Text000Txt);

        ItemLedgEntry.SetCurrentKey("Item No.");
        ItemLedgEntry.SetRange("Item No.", "Artikelnr.");
        ItemLedgEntry.SetRange("Lot No.", "Chargennr.");

        if Option = Option::BASSalesLotNoPHA then
            ItemLedgEntry.ModifyALL(BASSalesLotNoPHA, VKCNeu);

        if Option = Option::Haltbarkeitsdatum then
            ItemLedgEntry.ModifyALL("Expiration Date", HBNeu);
    end;

    procedure "PrüfeChargenMenge"(ItemNo: Code[20]; LotNo: Code[20]; Qty: Decimal; LocationCode: Code[10]) Haltbarkeitsdatum: Date
    var
        Item: Record Item;
    begin
        //-LAN001
        Item.Get(ItemNo);
        if Item."Item Tracking Code" <> '' then begin
            Item.SetFilter("Lot No. Filter", LotNo);
            //-GL013
            //Item.SetFilter("Location Filter",LocationCode);
            if LocationCode = 'VKL' then
                Item.SetFilter("Location Filter", 'SVKL|VKL')
            else
                Item.SetFilter("Location Filter", LocationCode);
            //+GL013
            Item.CALCFIELDS(Inventory);

            if ABS(Qty) > Item.Inventory then
                Error(Text002Txt,
                  ItemNo, LotNo, LocationCode, Item.Inventory);
        end;
        //+LAN001
    end;

    procedure EingabeChargeUmlagerungEingang(ForType: Option; ForSubtype: Integer; ForID: Code[20]; ForBatchName: Code[10]; ForProdOrderLine: Integer; ForRefNo: Integer; ForLotNo: Code[20]; ForItemNo: Code[20]; ForLocation: Code[10]; FromLocation: Code[10]; ForReceiptDate: Date)
    var
        ReservationEntry: Record "Reservation Entry";
    begin
        ReservEntry.SetRange("Source Type", ForType);
        ReservEntry.SetRange("Source ID", ForID);
        ReservEntry.SetRange("Source Ref. No.", ForRefNo);
        ReservEntry.SetRange("Location Code", FromLocation);
        ReservEntry.SetRange("Item No.", ForItemNo);
        ReservEntry.SetFilter(
          "Reservation Status", '%1|%2', ReservEntry."Reservation Status"::Surplus, ReservEntry."Reservation Status"::Prospect);
        ReservEntry.SetRange("Lot No.", ForLotNo);

        if ReservEntry.FindFirst() then begin
            ReservationEntry.Reset();
            ReservationEntry.COPY(ReservEntry);
            ReservationEntry."Entry No." += 1;
            ReservationEntry.Positive := true;
            ReservationEntry."Location Code" := ForLocation;
            ReservationEntry."Quantity (Base)" := (ReservEntry."Quantity (Base)" * (-1));
            ReservationEntry.Quantity := (ReservEntry.Quantity * (-1));
            ReservationEntry."Qty. to Handle (Base)" := (ReservEntry."Qty. to Handle (Base)" * (-1));
            ReservationEntry."Qty. to Invoice (Base)" := (ReservEntry."Qty. to Invoice (Base)" * (-1));
            ReservationEntry."Source Subtype" := ReservationEntry."Source Subtype"::"1";
            ReservationEntry."Shipment Date" := 0D;
            ReservationEntry."Expected Receipt Date" := ForReceiptDate;
            if not ReservationEntry.Insert() then
                Message('Fehler beim Einfügen der Reservierungszeile %1.', ReservationEntry."Entry No.");
        end;
    end;

    // ToDo -> all
    procedure MakeChargenNr(iChargenArt: Integer; cChargennr: Code[20]; bFertigprodukt: Boolean; cItemNo: Code[20]) cReturnCharge: Code[20]
    // var
    //     chAsciiZeichen: Char;
    //     iAsciiWert: Integer;
    //     iAsciiWertZusatz: Integer;
    begin
        cReturnCharge := cChargennr;
        // if bFertigprodukt then begin
        //     if iChargenArt = 2 then begin
        //         iAsciiWertZusatz := 0;
        //         cReturnCharge := GetLastLotNo(cChargennr, cItemNo);
        //         if cReturnCharge = '' then
        //             cReturnCharge := cChargennr
        //         else
        //             iAsciiWertZusatz := 1;

        //         if StrLen(cReturnCharge) = 8 then begin
        //             chAsciiZeichen := 65 + iAsciiWertZusatz;
        //             cReturnCharge := cReturnCharge + Format(chAsciiZeichen);
        //         end;
        //         if StrLen(cReturnCharge) > 9 then begin
        //             EVALUATE(iAsciiWert, CopyStr(cReturnCharge, StrLen(cReturnCharge), 1));
        //             chAsciiZeichen := 65 + iAsciiWert + iAsciiWertZusatz;  //z.B. aus den 1 ein B machen
        //             cReturnCharge := CopyStr(cReturnCharge, 1, 8) + Format(chAsciiZeichen);
        //         end;

        //         if StrLen(cReturnCharge) <> 9 then
        //             Error('Falsche Chargennummer %1', cReturnCharge);

        //         cReturnCharge := GetLastChargeNrNew(cReturnCharge, cItemNo);
        //     end else
        //         cReturnCharge := MakeVKchargennr(cChargennr);
        // end;
    end;

    procedure MakeVKchargennr(chnr: Code[20]): Code[20]
    var
        ManufacturingSetup: Record "Manufacturing Setup";
    begin
        ManufacturingSetup.Get();
        if ManufacturingSetup.BASChargennummernsystemPHA = ManufacturingSetup.BASChargennummernsystemPHA::Lannacher then begin
            if StrLen(chnr) = 9 then
                exit(CopyStr(chnr, 4, 1) + CopyStr(chnr, 5, 1) + CopyStr(chnr, 6, 3) + CopyStr(chnr, 9, 1));
            if StrLen(chnr) = 8 then
                exit(CopyStr(chnr, 4, 1) + CopyStr(chnr, 5, 1) + CopyStr(chnr, 6, 3));
        end;
    end;

    procedure GetLastLotNo(LotNo: Code[20]; ItemNo: Code[20]): Code[50]
    var
        Item: Record Item;
        LotNoInformation: Record "Lot No. Information";
    begin
        if StrLen(LotNo) = 8 then begin
            LotNoInformation.Reset();
            LotNoInformation.SetCurrentKey("Lot No.", "Item No.");
            LotNoInformation.SetFilter("Lot No.", LotNo + '*');
            LotNoInformation.SetFilter("Item No.", ItemNo);
            if LotNoInformation.FindSet() then
                repeat
                    if StrLen(LotNoInformation."Lot No.") < 11 then
                        if Item.Get(LotNoInformation."Item No.") then
                            if Item.BASItemTypePHA = Item.BASItemTypePHA::"Finished Product" then
                                // ToDo
                                // if LotNoInformation."Lot No." > cReturnCharge then
                                    exit(LotNoInformation."Lot No.");
                until LotNoInformation.Next() = 0;
        end;
    end;

    procedure GetLastChargeNrNew(LotNo: Code[20]; ItemNo: Code[20]): Code[20]
    var
        LotNoInformation: Record "Lot No. Information";
        LotNoFound: Boolean;
        ch: Char;
    begin
        repeat
            LotNoInformation.Reset();
            LotNoInformation.SetCurrentKey("Lot No.", "Item No.");
            LotNoInformation.SetRange("Lot No.", LotNo);
            LotNoInformation.SetRange("Item No.", ItemNo);
            LotNoFound := not LotNoInformation.IsEmpty;
            if LotNoFound then begin
                ch := 0;
                Evaluate(ch, CopyStr(LotNo, StrLen(LotNo), 1));
                ch += 1;

                Evaluate(LotNo, CopyStr(LotNo, 1, StrLen(LotNo) - 1) + Format(ch));
            end;
        until not LotNoFound;

        exit(LotNo);
    end;

    procedure RowMaterialLotNoSeries(ItemNo: Code[20]): Code[20]
    var
        InventorySetup: Record "Inventory Setup";
        Item: Record Item;
        ManufacturingSetup: Record "Manufacturing Setup";
    begin
        Item.Get(ItemNo);

        if Item.BASSiteManufacturingPHA = '' then begin
            InventorySetup.Get();
            InventorySetup.TestField(BASRohstoffchargennummernPHA);
            exit(InventorySetup.BASRohstoffchargennummernPHA);
        end else begin
            ManufacturingSetup.Get(Item.BASSiteManufacturingPHA);
            ManufacturingSetup.TestField(BasRohstoffchargennummernPHA);
            exit(ManufacturingSetup.BASRohstoffchargennummernPHA);
        end;
    end;
}