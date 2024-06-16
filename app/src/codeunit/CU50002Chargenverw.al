codeunit 50002 Chargenverwaltung
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

    trigger OnRun()
    begin
    end;

    var
        TrackingSpecification: Record "336";
        ReservEntry: Record "337";
        ItemTrackMgt: Codeunit "6500";
        CreateReservEntry: Codeunit "Create Reserv. Entry";
        Text000: Label 'Verarbeitung unterbrochen!';
        Text001: Label '%1 in den Posten wird mitverändert!\ Wollen Sie Fortfahren?';
        Text002: Label 'Von Artikel %1, Charge %2 sind im Lager %3 nur mehr %4 vorhanden!';
        CurrentEntryStatus: Option Reservation,Tracking,Surplus,Prospect;

    procedure FaktMengeCharge(ForType: Option; ForSubtype: Integer; ForID: Code[20]; ForBatchName: Code[10]; ForProdOrderLine: Integer; ForRefNo: Integer; ForLotNo: Code[20]; InvQuantity: Decimal)
    var
        QtyToInvoiceThisLine: Decimal;
        TotalQtyToInvoice: Decimal;
        CurrentSignFactor: Integer;
    begin
        ReservEntry."Source Type" := ForType;
        ReservEntry."Source Subtype" := ForSubtype;
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
        //+LAN001
    end;

    procedure "Chargenpostenwählen"(var recCharge: Record "6505"): Boolean
    var
        Chargenstamm: Record "6505";
        Item: Record Item;
    begin

        //Message('Funktion Chargenpostenwählen nicht aktiv');

        //-LAN001
        Item.GET(recCharge."Item No.");
        Item.TestField("Item Tracking Code");

        Chargenstamm.SetRange("Item No.", recCharge."Item No.");
        Chargenstamm.SetFilter(Inventory, '>0');
        if recCharge."Location Filter" <> '' then
            Chargenstamm.SetFilter("Location Filter", recCharge."Location Filter");

        if recCharge."Bin Filter" <> '' then
            Chargenstamm.SetFilter(Chargenstamm."Bin Filter", recCharge."Bin Filter");

        if recCharge.GETFILTER(Inventory) <> '' then
            Chargenstamm.SetFilter(Chargenstamm.Inventory, recCharge.GETFILTER(Inventory));

        Chargenstamm."Item No." := recCharge."Item No.";
        Chargenstamm."Lot No." := recCharge."Lot No.";


        //TODOPBA - 
        if PAGE.RUNMODAL(PAGE::"Lot No. Information List", Chargenstamm) = ACTION::LookupOK then begin
            recCharge := Chargenstamm;
            exit(true);
            //END;

            //+LAN001
        end;
    end;

    procedure ChargenstammAnlegen(ItemJnlLine: Record "Item Journal Line")
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
            if not Confirm(Text001, false, ItemLedgEntry.FIELDCAPTION(BASSalesLotNoPHA)) then
                Error(Text000);

        if Option = Option::Haltbarkeitsdatum then
            if not Confirm(Text001, false, ItemLedgEntry.FIELDCAPTION("Expiration Date")) then
                Error(Text000);

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
        Item.GET(ItemNo);
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
                Error(Text002,
                  ItemNo, LotNo, LocationCode, Item.Inventory);
        end;
        //+LAN001
    end;

    procedure EingabeChargeUmlagerungEingang(ForType: Option; ForSubtype: Integer; ForID: Code[20]; ForBatchName: Code[10]; ForProdOrderLine: Integer; ForRefNo: Integer; ForLotNo: Code[20]; ForItemNo: Code[20]; ForLocation: Code[10]; FromLocation: Code[10]; ForReceiptDate: Date)
    var
        ReservEntry_Insert: Record "337";
    begin
        //-GL003
        //Anlegen einer Reservierungszeile für den Umlagerungs Eingang

        CLEAR(ReservEntry);

        ReservEntry.SetRange("Source Type", ForType);
        ReservEntry.SetRange("Source ID", ForID);
        ReservEntry.SetRange("Source Ref. No.", ForRefNo);
        ReservEntry.SetRange("Location Code", FromLocation);
        ReservEntry.SetRange("Item No.", ForItemNo);
        ReservEntry.SetFilter(
          "Reservation Status", '%1|%2', ReservEntry."Reservation Status"::Surplus, ReservEntry."Reservation Status"::Prospect);
        ReservEntry.SetRange("Lot No.", ForLotNo);

        if ReservEntry.FINDFIRST() then begin
            CLEAR(ReservEntry_Insert);
            ReservEntry_Insert.COPY(ReservEntry);
            ReservEntry_Insert."Entry No." += 1;
            ReservEntry_Insert.Positive := true;
            ReservEntry_Insert."Location Code" := ForLocation;
            ReservEntry_Insert."Quantity (Base)" := (ReservEntry."Quantity (Base)" * (-1));
            ReservEntry_Insert.Quantity := (ReservEntry.Quantity * (-1));
            ReservEntry_Insert."Qty. to Handle (Base)" := (ReservEntry."Qty. to Handle (Base)" * (-1));
            ReservEntry_Insert."Qty. to Invoice (Base)" := (ReservEntry."Qty. to Invoice (Base)" * (-1));
            ReservEntry_Insert."Source Subtype" := ReservEntry_Insert."Source Subtype"::"1";
            ReservEntry_Insert."Shipment Date" := 0D;
            ReservEntry_Insert."Expected Receipt Date" := ForReceiptDate;
            if not ReservEntry_Insert.Insert() then
                Message('Fehler beim Einfügen der Reservierungszeile %1.', ReservEntry_Insert."Entry No.");
        end;

        //+GL003
    end;

    // ToDo -> all
    procedure MakeChargenNr(iChargenArt: Integer; cChargennr: Code[20]; bFertigprodukt: Boolean; cItemNo: Code[20]) cReturnCharge: Code[20]
    var
        chAsciiZeichen: Char;
        iAsciiWert: Integer;
        iAsciiWertZusatz: Integer;
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

    procedure GetLastChargeNrNew(cChargennr: Code[20]; cItemNo: Code[20]) cReturnCharge: Code[20]
    var
        recProdOrder: Record "5405";
        LotNoInformationNoInformation: Record "6505";
        bChargeFound: Boolean;
        chAsciiZeichen: Char;
        iAsciiWert: Integer;
    begin
        //+017
        //MFU 02.12.2009
        //cChargennr -> Chargennummer "2010A001A"
        //cItemNo -> Artikelnummer
        //Die erste freie Chargennummer ermitteln


        //Sollange erhöhen, bis eine Endziffer frei ist (A,B,C,...)
        repeat

            //Prüfen, ob die Chargennr schon im Chargenstamm existiert
            LotNoInformationNoInformation.RESET();
            LotNoInformationNoInformation.SetCurrentKey("Lot No.", "Item No.");
            LotNoInformationNoInformation.SetRange("Lot No.", cChargennr);
            LotNoInformationNoInformation.SetRange("Item No.", cItemNo);
            bChargeFound := LotNoInformationNoInformation.FindSet();



            //Hinaufzählen, wenn ein gleicher Eintrag gefunden wurde
            if bChargeFound then begin

                chAsciiZeichen := 0;
                //Ascii Wert des letzten Zeichens
                EVALUATE(chAsciiZeichen, CopyStr(cChargennr, StrLen(cChargennr), 1));
                chAsciiZeichen += 1;

                cChargennr := CopyStr(cChargennr, 1, StrLen(cChargennr) - 1);  //erster Teil der Chargennummer
                cChargennr := cChargennr + Format(chAsciiZeichen);

            end;

        until not bChargeFound;

        cReturnCharge := cChargennr;

        //-017
    end;

    procedure RowMaterialLotNoSeries(ItemNo: Code[20]): Code[20]
    var
        InventorySetup: Record "Inventory Setup";
        Item: Record Item;
        ManufacturingSetup: Record "Manufacturing Setup";
    begin
        Item.GET(ItemNo);

        if Item.BASSiteManufacturingPHA = '' then begin
            InventorySetup.Get();
            InventorySetup.TestField(BASRohstoffchargennummernPHA);
            exit(InventorySetup.BASRohstoffchargennummernPHA);
        end else begin
            ManufacturingSetup.GET(Item.BASSiteManufacturingPHA);
            ManufacturingSetup.TestField(BasRohstoffchargennummernPHA);
            exit(ManufacturingSetup.BASRohstoffchargennummernPHA);
        end;
    end;
}