tableextension 50013 BASSalesLineExtPHA extends "Sales Line"
{
    fields
    {
        field(50000; BASSubsetPHA; Decimal)
        {
            DecimalPlaces = 0 : 5;
            trigger OnValidate()
            begin
                Validate(Quantity, BASsubsetPHA + BASNaturalrabattmengePHA);
                Validate("BASAbzug %PHA");
            end;
        }
        field(50002; BASNachlieferungstextPHA; Text[30])
        {
        }
        field(50003; "BASTeilmenge geliefertPHA"; Decimal)
        {
            DecimalPlaces = 0 : 5;
        }
        field(50005; "BASAbzug %PHA"; Decimal)
        {
            DecimalPlaces = 0 : 5;
            trigger OnValidate()
            var
                Currency: Record Currency;
            begin
                if Quantity <> 0 then
                    "BASAbzug %PHA" := (Quantity - BASSubsetPHA) * 100 / Quantity
                else
                    "BASAbzug %PHA" := 100;

                BASAbzugsbetragPHA := 0;
                if ("Document Type" <> "Document Type"::"Blanket Order") and ("Document Type" <> "Document Type"::Quote) then //MFU 15.09.2021
                                                                                                                              //+GL037
                    BASAbzugsbetragPHA :=
                        Round(
                            Round(Quantity * "Unit Price", Currency."Amount Rounding Precision") *
                      "BASAbzug %PHA" / 100, Currency."Amount Rounding Precision");

                if GetHeaderMengeZuNrBerechnung(Rec."Document No.") then
                    BASAbzugsbetragPHA := 0;

                UpdateAmounts();

                Validate("Line Discount %");
            end;
        }
        field(50006; BASAbzugsbetragPHA; Decimal)
        {

        }
        field(50007; BASFoundPricePHA; Boolean)
        {
        }
        field(50008; BASCheckInventoryPHA; Boolean)
        {
        }
        field(50010; BASLotNoPHA; Code[20])
        {
            Caption = 'Lot No.';
            TableRelation = if (Type = const(Item)) "Lot No. Information".BASSalesLotNoPHA
                where("Item No." = field("No."), "Variant Code" = field("Variant Code"));
            ValidateTableRelation = false;
        }
        field(50011; BASAssignShipmentPHA; Code[20])
        {
            trigger OnValidate()
            var
                SalesShipmentLines: Record "Sales Shipment Line";
            begin
                if Type <> Type::"Charge (Item)" then
                    Error('Zuordnung zu Lieferung ist nur bei Art = Zu/Abschlag möglich');
                if "BASZuordnung zu Artikelnr.PHA" = '' then
                    Error('Bitte zuerst Zuweisung zu Artikel setzen');
                if BASAssignInvoicePHA <> '' then
                    Error('Zuordnung zu Rechnung darf nicht gleichzeitig ausgefüllt sein!');

                SalesShipmentLines.SetCurrentKey("Sell-to Customer No.");
                SalesShipmentLines.SetRange(Type, SalesShipmentLines.Type::Item);
                SalesShipmentLines.SetRange("No.", "BASZuordnung zu Artikelnr.PHA");
                SalesShipmentLines.SetRange("Sell-to Customer No.", "Sell-to Customer No.");
                SalesShipmentLines.SetRange("Document No.", BASAssignShipmentPHA);
                if SalesShipmentLines.FindSet() then
                    CheckItemChargeShipment(FIELDNO(BASAssignShipmentPHA), SalesShipmentLines)
                else
                    if BASAssignShipmentPHA <> '' then
                        Error('Unzulässige Liefernummer');

                if (BASAssignShipmentPHA = '') and (xRec.BASAssignShipmentPHA <> '') then
                    DeleteChargeChargeAssgnt("Document Type", "Document No.", "Line No.");
            end;
        }
        field(50012; BASAssignInvoicePHA; Code[20])
        {
            trigger OnLookup()
            var
                SalesInvoiceLines: Record "Sales Invoice Line";
            begin
                if ("BASZuordnung zu Artikelnr.PHA" <> '') and (Type = Type::"Charge (Item)") then begin
                    SalesInvoiceLines.SetCurrentKey("Sell-to Customer No.");
                    SalesInvoiceLines.SetRange(Type, SalesInvoiceLines.Type::Item);
                    SalesInvoiceLines.SetRange("No.", "BASZuordnung zu Artikelnr.PHA");
                    SalesInvoiceLines.SetRange("Sell-to Customer No.", "Sell-to Customer No.");
                end;
            end;

            trigger OnValidate()
            var
                SalesInvoiceLines: Record "Sales Invoice Line";
            begin
                if Type <> Type::"Charge (Item)" then
                    Error('Zuordnung zu Rechnung ist nur bei Art = Zu/Abschlag möglich');
                if "BASZuordnung zu Artikelnr.PHA" = '' then
                    Error('Bitte zuerst Zuweisung zu Artikel setzen');
                if BASAssignShipmentPHA <> '' then
                    Error('Zuordnung zu Lieferung darf nicht gleichzeitig ausgefüllt sein!');

                SalesInvoiceLines.SetCurrentKey("Sell-to Customer No.");
                SalesInvoiceLines.SetRange(Type, SalesInvoiceLines.Type::Item);
                SalesInvoiceLines.SetRange("No.", "BASZuordnung zu Artikelnr.PHA");
                SalesInvoiceLines.SetRange("Sell-to Customer No.", "Sell-to Customer No.");
                SalesInvoiceLines.SetRange("Document No.", BASAssignInvoicePHA);
                if SalesInvoiceLines.FindSet() then
                    CheckItemChargeInvoice(FIELDNO(BASAssignInvoicePHA), SalesInvoiceLines)
                else
                    if BASAssignInvoicePHA <> '' then
                        Error('Unzulässige Rechnungsnummer');

                if (BASAssignInvoicePHA = '') and (xRec.BASAssignInvoicePHA <> '') then
                    DeleteChargeChargeAssgnt("Document Type", "Document No.", "Line No.");
            end;
        }
        field(50013; BASShrinkSizePHA; Decimal)
        {
            CalcFormula = lookup(Item."Schrumpfgröße" where("No." = field("No.")));
            FieldClass = FlowField;
        }
        field(50014; BASAssignDatePHA; Date)
        {
        }
        field(50015; BASInlandfilterPHA; Boolean)
        {
        }
        field(50016; BASGetFromPHA; Integer)
        {
            Caption = 'Get From', comment = 'DEA="Hole von"';
            trigger OnLookup()
            var
                Item: Record Item;
                TempItemLedgerEntry: Record "Item Ledger Entry" temporary;
                ActionReturn: Action;
            begin
                if Type = Type::Item then
                    if Item.Get("No.") then begin
                        TempItemLedgerEntry."Item No." := "No.";
                        TempItemLedgerEntry.SetRange("Item No.", "No.");
                        TempItemLedgerEntry.SetRange(Open, true);
                        if "Location Code" <> '' then begin
                            TempItemLedgerEntry."Location Code" := "Location Code";
                            TempItemLedgerEntry.SetRange("Location Code", "Location Code");
                        end;

                        if (ActionReturn = ACTION::LookupOK) or (ActionReturn = ACTION::OK) then begin
                            Validate(BASLotNoPHA, TempItemLedgerEntry.BASSalesLotNoPHA);
                            BASSalesLotNoPHA := TempItemLedgerEntry.BASSalesLotNoPHA;
                            Validate(BASSubsetPHA, TempItemLedgerEntry."Remaining Quantity");

                            "Location Code" := TempItemLedgerEntry."Location Code";
                            "Bin Code" := TempItemLedgerEntry.BASBinCodeHelpFieldPHA;

                        end;
                    end;

                //+UPDATE2013
            end;
        }
        field(50506; BASArtikelgruppePHA; Code[10])
        {

            Editable = false;

        }
        field(50507; "BASStatisticCode2PHA IPHA"; Code[10])
        {

            Editable = false;
            TableRelation = BASStatisticcodePHA where(Level = const(1));
        }
        field(50508; "BASStatisticCode2PHA IIPHA"; Code[10])
        {

            Editable = false;
            TableRelation = BASStatisticcodePHA where(Level = const(2));
        }
        field(50509; "BASStatisticCode2PHA IIIPHA"; Code[10])
        {

            Editable = false;
            TableRelation = BASStatisticcodePHA where(Level = const(3));
        }
        field(50510; "BASZuordnung zu Artikelnr.PHA"; Code[20])
        {

            TableRelation = if (BASInlandfilterPHA = const(false)) Item
            else
            if (BasInlandfilterPHA = const(true)) Item where("BASCountry/Region CodePHA" = filter('<=A'));
        }
        field(50511; BASValueCorrItemLedgEntryPHA; Integer)
        {
            trigger OnValidate()
            begin
                if Type <> Type::"Charge (Item)" then
                    Error('Postenzuordnung nur bei Art=Zu/Abschlag erlaubt');
            end;
        }
        field(50512; "BASCountry/Region CodePHA"; Code[10])
        {
            Caption = 'Country/Region Code';

            TableRelation = "Country/Region";
        }
        field(50513; BASNaturalrabattmengePHA; Decimal)
        {
            DecimalPlaces = 0 : 5;


            trigger OnValidate()
            begin
                Validate(BASSubsetPHA);
                TestField("Qty. per Unit of Measure");

                if (Type <> Type::Item) and (BASNaturalrabattmengePHA <> 0) then
                    Error('FEHLENDE TEXTVARIABLE T37');

                if BASNaturalDiscAmountShippedPHA > 0 then
                    Error('FEHLENDE TEXTVARIABLE T37');
            end;
        }
        field(50514; BASNaturalDiscAmountShippedPHA; Decimal)
        {
            DecimalPlaces = 0 : 5;
        }
        field(50515; BASSalesStatisticCode2PHA; Code[10])
        {
        }
        field(50516; BASExpirationDatePHA; Date)
        {
            Caption = 'Expiration Date';
        }
        field(50517; "BASSuchtgift/PsychotropPHA"; Text[1])
        {
        }
        field(50518; "BASNaturalrabatt fakturiertPHA"; Decimal)
        {

        }
        field(50519; BASSalesLotNoPHA; Code[20])
        {
            trigger OnValidate()
            var
                Item: Record Item;
                LotNoInformation: Record "Lot No. Information";
            begin
                if "Document Type" <> "Document Type"::"Credit Memo" then
                    exit;

                TestField(Type, Type::Item);

                Item.Get("No.");
                Item.TestField("Item Tracking Code");
                if (BASSalesLotNoPHA <> xRec.BASSalesLotNoPHA) then begin
                    if BASSalesLotNoPHA <> '' then begin
                        LotNoInformation.SetCurrentKey("Item No.", "Variant Code", BASSalesLotNoPHA);
                        LotNoInformation.SetRange("Item No.", "No.");
                        LotNoInformation.SetRange("Variant Code", "Variant Code");
                        LotNoInformation.SetRange(BASSalesLotNoPHA, BASSalesLotNoPHA);
                        if LotNoInformation.FindFirst() then begin
                            BASLotNoPHA := LotNoInformation.BASSalesLotNoPHA;
                            BASSalesLotNoPHA := LotNoInformation.BASSalesLotNoPHA;
                            BASExpirationDatePHA := LotNoInformation.BASExpirationDatePHA;
                        end else
                            Message('FEHLENDE TEXTVARIABLE T37');
                    end;
                    Validate(BASLotNoPHA);
                end;
            end;
        }
        field(50522; BASEDIArtikelBemerkungPHA; Text[100])
        {
        }
        field(50600; BASHervorhebenPHA; Boolean)
        {

        }
        field(50601; BASOrderDatePHA; Date)
        {
            Caption = 'Order Date';
            trigger OnValidate()
            begin
                if (Type = Type::Item) or (Type = Type::"G/L Account") then
                    if ("Unit Price" > 0) and ("Currency Code" <> '') then
                        UpdateUnitPrice(FieldNo(BASSubsetPHA));
            end;
        }
        field(50602; BASOrigReqedDeliveryDatePHA; Date)
        {
            Caption = 'Original Requested Delivery Date';
        }
    }
    procedure FaktMengeCharge()
    // var
    //     CurrentSignFactor: Integer;
    begin
        //-LAN006
        if SuspendLotCreation then
            exit;
        if "Line No." = 0 then
            exit;
        if BASLotNoPHA = '' then
            exit;
        if Type <> Type::Item then
            exit;
        if "No." = '' then
            exit;

        // LotMgt.FaktMengeCharge(
        //   DATABASE::"Sales Line", "Document Type", "Document No.", '', 0, "Line No.", BASLotNoPHA, "Qty. to Invoice (Base)");
    end;

    procedure Bezugsberechtigung(ItemNo: Code[20]; CustNo: Code[20])
    var
        Customer: Record Customer;
        Item: Record Item;
    begin
        if Customer.Get(CustNo) then
            if Item.Get(ItemNo) then begin
                if Item.BASDrugPHA and not Customer.BASSGBezugPHA then
                    Error('Kunde %1 hat keine Suchtgiftbezugsberechtigung', Customer."No.");
                if Item.BASPsychotroperStoffPHA and not Customer.BASPSYBezugPHA then
                    Error('Kunde %1 hat keine Bezugsberechtigung für psychotrope Stoffe', Customer."No.");
            end;
    end;

    procedure SetSuspendLotCreation(NewSuspendLotCreation: Boolean)
    begin
        SuspendLotCreation := NewSuspendLotCreation;
    end;

    procedure CheckItemChargeShipment(CalledByField: Integer; var SalesShipmentLines: Record "Sales Shipment Line")
    var
        SalesItemCharge: Record "Item Charge Assignment (Sales)";
    begin
        if ("BASZuordnung zu Artikelnr.PHA" <> '') and ("Line No." <> 0) then begin
            SalesItemCharge.Init();
            SalesItemCharge."Document Type" := "Document Type";
            SalesItemCharge."Document No." := "Document No.";
            SalesItemCharge."Document Line No." := "Line No.";
            SalesItemCharge."Line No." := 10000;
            SalesItemCharge."Item Charge No." := "No.";
            SalesItemCharge."Item No." := "BASZuordnung zu Artikelnr.PHA";
            SalesItemCharge.Description := '';
            SalesItemCharge."Qty. to Assign" := Quantity;
            SalesItemCharge."Qty. Assigned" := 0;
            SalesItemCharge."Amount to Assign" := "Line Amount";
            if SalesItemCharge."Qty. to Assign" <> 0 then
                SalesItemCharge."Unit Cost" := Round(SalesItemCharge."Amount to Assign" / SalesItemCharge."Qty. to Assign", 0.00001);
            SalesItemCharge."Applies-to Doc. Type" := SalesItemCharge."Applies-to Doc. Type"::Shipment;
            SalesItemCharge."Applies-to Doc. No." := SalesShipmentLines."Document No.";
            SalesItemCharge."Applies-to Doc. Line No." := SalesShipmentLines."Line No.";
            SalesItemCharge."Applies-to Doc. Line Amount" := 0;
            if not SalesItemCharge.Insert() then
                SalesItemCharge.Modify();
        end;
    end;

    procedure CheckItemChargeInvoice(CalledByField: Integer; var SalesInvoiceLines: Record "Sales Invoice Line")
    var
        SalesItemCharge: Record "Item Charge Assignment (Sales)";
    begin
        if ("BASZuordnung zu Artikelnr.PHA" <> '') and ("Line No." <> 0) then begin
            SalesItemCharge.Init();
            SalesItemCharge."Document Type" := "Document Type";
            SalesItemCharge."Document No." := "Document No.";
            SalesItemCharge."Document Line No." := "Line No.";
            SalesItemCharge."Line No." := 10000;
            SalesItemCharge."Item Charge No." := "No.";
            SalesItemCharge."Item No." := "BASZuordnung zu Artikelnr.PHA";
            SalesItemCharge.Description := '';
            SalesItemCharge."Qty. to Assign" := Quantity;
            SalesItemCharge."Qty. Assigned" := 0;
            SalesItemCharge."Amount to Assign" := "Line Amount";
            if SalesItemCharge."Qty. to Assign" <> 0 then
                SalesItemCharge."Unit Cost" := Round(SalesItemCharge."Amount to Assign" / SalesItemCharge."Qty. to Assign", 0.00001);
            SalesItemCharge."Applies-to Doc. No." := SalesInvoiceLines."Document No.";
            SalesItemCharge."Applies-to Doc. Line No." := SalesInvoiceLines."Line No.";
            SalesItemCharge."Applies-to Doc. Line Amount" := 0;
            if not SalesItemCharge.Insert() then
                SalesItemCharge.Modify();
        end;
    end;

    procedure GetRahmenauftragPreis(BlanketOrderNo: Code[20]; BlanketLineNo: Integer; Price: Decimal; Quantity: Decimal; var ReturnOk: Boolean): Decimal
    var
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        SalesLineQuantity: Record "Sales Line";
        PriceReturn: Decimal;
        ShipmentQuantity: Decimal;
    begin
        ReturnOk := true;
        PriceReturn := Price;
        if StrLen(BlanketOrderNo) > 0 then begin
            SalesHeader.Reset();
            SalesHeader.SetRange("Document Type", SalesHeader."Document Type"::"Blanket Order");
            SalesHeader.SetRange("No.", BlanketOrderNo);
            // SalesHeader.SetRange(Auftragsstatus, SalesHeader.Auftragsstatus::Geliefert);
            if SalesHeader.IsEmpty then begin
                SalesLine.SetRange("Document Type", "Document Type"::"Blanket Order");
                SalesLine.SetRange("Document No.", BlanketOrderNo);
                SalesLine.SetRange("Line No.", BlanketLineNo);
                if SalesLine.FindFirst() then begin
                    PriceReturn := SalesLine."Unit Price";

                    if (SalesLine.Quantity - SalesLine."Quantity Shipped") < Quantity then begin
                        ReturnOk := false;
                        Message('Am Rahmenauftrag %1 sind %2 Stk offen!', BlanketOrderNo,
                          (SalesLine.Quantity - SalesLine."Quantity Shipped"));
                    end else begin
                        ShipmentQuantity := 0;
                        SalesLineQuantity.Reset();
                        SalesLineQuantity.SetRange("Document Type", "Document Type"::Order);
                        SalesLineQuantity.SetRange("Blanket Order No.", BlanketOrderNo);
                        SalesLineQuantity.SetRange("Blanket Order Line No.", BlanketLineNo);
                        if SalesLineQuantity.FindSet() then
                            repeat
                                if not ((Rec."Document Type" = SalesLineQuantity."Document Type") and
                                    (Rec."Document No." = SalesLineQuantity."Document No.") and
                                  (Rec."Line No." = SalesLineQuantity."Line No."))
                                then
                                    ShipmentQuantity += SalesLineQuantity."Qty. to Ship"
                            until SalesLineQuantity.Next() = 0;

                        if ((SalesLine.Quantity - SalesLine."Quantity Shipped") - ShipmentQuantity) < Quantity then begin
                            ReturnOk := false;
                            Message('Für den Rahmenauftrag %1 sind %2 Stk offen und %3 Stk in Aufträgen vorgesehen!',
                              BlanketOrderNo, (SalesLine.Quantity - SalesLine."Quantity Shipped"), ShipmentQuantity + Quantity);
                        end;
                    end;
                end;
            end else begin
                ReturnOk := false;
                Message('Der Rahmenauftrag %1 ist fertig geliefert!', BlanketOrderNo);
            end;
        end;

        exit(PriceReturn);
    end;

    procedure GetPackageSize(): Code[10]
    var
        Item: Record Item;
    begin
        if Type = Type::Item then
            if Item.Get("No.") then
                exit(Item.BASPackageSizePHA);
        if ((Type = Type::"G/L Account") or (Type = Type::"Charge (Item)")) then
            if Item.Get("BASZuordnung zu Artikelnr.PHA") then
                exit(Item.BASPackageSizePHA);
    end;

    procedure GetHeaderMengeZuNrBerechnung(cAuftragsNr: Code[20]): Boolean
    var
        SalesHeader: Record "Sales Header";
    begin
        // ToDo -> Field VKBetragMenge+NR
        if SalesHeader.Get(SalesHeader."Document Type"::Order, cAuftragsNr) then
            exit(true);
        // exit(SalesHeader."VKBetragMenge+NR");
    end;

    procedure CheckItemAvailableVKL(ItemNo: Code[20]; LotNo: Code[20]; RequirenmentAmount: Decimal; OrderNo: Code[20])
    var
        Item: Record Item;
        ItemLedgerEntry: Record "Item Ledger Entry";
        SalesLine: Record "Sales Line";
        Inventory: Decimal;
        QuantityInOrder: Decimal;
        VKLTxt: Label 'VKL', Locked = true;
    begin
        if Item.Get(ItemNo) then
            if (StrLen(LotNo) > 0) and (RequirenmentAmount > 0) then begin
                ItemLedgerEntry.Reset();
                ItemLedgerEntry.SetCurrentKey(
                    "Item No.", Open, "Variant Code", Positive, "Location Code", "Posting Date",
                        "Expiration Date", BASSalesLotNoPHA, "Serial No.");
                ItemLedgerEntry.SetRange(Open, true);
                ItemLedgerEntry.SetRange("Item No.", ItemNo);
                ItemLedgerEntry.SetFilter("Location Code", VKLTxt);
                ItemLedgerEntry.SetRange(BASSalesLotNoPHA, LotNo);
                if ItemLedgerEntry.FindSet() then begin
                    Inventory := 0;
                    repeat
                        Inventory += ItemLedgerEntry."Remaining Quantity";
                    until ItemLedgerEntry.Next() = 0;
                end;

                SalesLine.SetRange(Type, SalesLine.Type::Item);
                SalesLine.SetRange("No.", ItemNo);
                SalesLine.SetRange(BASLotNoPHA, LotNo);
                SalesLine.SetFilter("Document No.", '<>' + OrderNo);
                if SalesLine.FindSet() then
                    repeat
                        QuantityInOrder += SalesLine."Qty. to Ship";
                    until SalesLine.Next() = 0;

                if RequirenmentAmount > (Inventory - QuantityInOrder) then
                    Message('Keine Ausreichende Menge auf VKL der Charge %1 vorhanden!', LotNo);
            end;
    end;

    procedure SetOriginalRequestedDeliveryDate()
    var
        SalesHeader: Record "Sales Header";
    begin
        SalesHeader.Get("Document Type", "Document No.");
        if ((BASOrigReqedDeliveryDatePHA = 0D) and
             (SalesHeader."Requested Delivery Date" <> 0D) and
             (Type = Type::Item))
        then
            BASOrigReqedDeliveryDatePHA := SalesHeader."Requested Delivery Date";
    end;

    var
        SuspendLotCreation: Boolean;
}
