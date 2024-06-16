tableextension 50013 BASSalesLineExtPHA extends "Sales Line"
{
    fields
    {
        field(50000; BASSubsetPHA; Decimal)
        {
            DecimalPlaces = 0 : 5;


            trigger OnValidate()
            begin
                Validate(Quantity, BASsubsetPHA + Naturalrabattmenge);
                Validate(BASDiscountProcPHA);
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
                //-LAN002
                if Quantity <> 0 then
                    "Abzug %" := (Quantity - Teilmenge) * 100 / Quantity
                else
                    "Abzug %" := 100;

                //-GL037  Einbau aus 2009
                Abzugsbetrag := 0;
                if ("Document Type" <> "Document Type"::"Blanket Order") and ("Document Type" <> "Document Type"::Quote) then //MFU 15.09.2021
                                                                                                                              //+GL037
                    Abzugsbetrag :=
                    ROUND(
                      ROUND(Quantity * "Unit Price", Currency."Amount Rounding Precision") *
                      "Abzug %" / 100, Currency."Amount Rounding Precision");

                //-GL033
                if GetHeaderMengeZuNrBerechnung(Rec."Document No.") then
                    Abzugsbetrag := 0;
                //+GL033

                UpdateAmounts();

                Validate("Line Discount %");
                //+LAN002
            end;
        }
        field(50006; BASAbzugsbetragPHA; Decimal)
        {

        }
        field(50007; "BASPreis gefundenPHA"; Boolean)
        {
            Description = 'LAN1.00 Hilfsfeld f. Preisfindung, temporär befüllt';
        }
        field(50008; "Lagerbestand prüfen"; Boolean)
        {
            Description = 'LAN1.00 Hilfsfeld f. Preisfindung, temporär befüllt';
        }
        field(50010; BASLotNoPHA; Code[20])
        {
            Caption = 'Lot No.';
            TableRelation = if (Type = const(Item)) "Lot No. Information".BASLotNoPHA where("Item No." = field("No."),
                                                                                         "Variant Code" = field("Variant Code"));
            ValidateTableRelation = false;
        }
        field(50011; "BASZuordnung zu LieferungPHA"; Code[20])
        {


            trigger OnLookup()
            var
                SalesShipmentLines: Record "Sales Shipment Line";
            begin
                //ToDo !!!
                // if ("BASZuordnung zu Artikelnr.PHA" <> '') and (Type = Type::"Charge (Item)") then begin
                //     SalesShipmentLines.SetCurrentKey("Sell-to Customer No.");
                //     SalesShipmentLines.SetRange(Type, SalesShipmentLines.Type::Item);
                //     SalesShipmentLines.SetRange("No.", "BASZuordnung zu Artikelnr.PHA");
                //     SalesShipmentLines.SetRange("Sell-to Customer No.", "Sell-to Customer No.");
                // end;
            end;

            trigger OnValidate()
            var
                SalesShipmentLines: Record "111";
            begin
                if Type <> Type::"Charge (Item)" then
                    Error('Zuordnung zu Lieferung ist nur bei Art = Zu/Abschlag möglich');
                if "BASZuordnung zu Artikelnr.PHA" = '' then
                    Error('Bitte zuerst Zuweisung zu Artikel setzen');
                if "BASZuordnung zu RechnungPHA" <> '' then
                    Error('Zuordnung zu Rechnung darf nicht gleichzeitig ausgefüllt sein!');


                SalesShipmentLines.SetCurrentKey("Sell-to Customer No.");
                SalesShipmentLines.SetRange(Type, SalesShipmentLines.Type::Item);
                SalesShipmentLines.SetRange("No.", "BASZuordnung zu Artikelnr.PHA");
                SalesShipmentLines.SetRange("Sell-to Customer No.", "Sell-to Customer No.");
                SalesShipmentLines.SetRange("Document No.", "BASZuordnung zu LieferungPHA");
                if SalesShipmentLines.FindSet() then
                    CheckItemChargeShipment(FIELDNO("BASZuordnung zu LieferungPHA"), SalesShipmentLines)
                else
                    if "BASZuordnung zu LieferungPHA" <> '' then
                        Error('Unzulässige Liefernummer');

                if ("BASZuordnung zu LieferungPHA" = '') and (xRec."BASZuordnung zu LieferungPHA" <> '') then begin
                    DeleteChargeChargeAssgnt("Document Type", "Document No.", "Line No.");
                end;
            end;
        }
        field(50012; "BASZuordnung zu RechnungPHA"; Code[20])
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
                    //TODOPBA IF PAGE.RUNMODAL(PAGE::Page50072, SalesInvoiceLines) = ACTION::LookupOK THEN BEGIN
                    //    Validate("BASZuordnung zu RechnungPHA", SalesInvoiceLines."Document No.");
                    //END;
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
                if "BASZuordnung zu LieferungPHA" <> '' then
                    Error('Zuordnung zu Lieferung darf nicht gleichzeitig ausgefüllt sein!');

                SalesInvoiceLines.SetCurrentKey("Sell-to Customer No.");
                SalesInvoiceLines.SetRange(Type, SalesInvoiceLines.Type::Item);
                SalesInvoiceLines.SetRange("No.", "BASZuordnung zu Artikelnr.PHA");
                SalesInvoiceLines.SetRange("Sell-to Customer No.", "Sell-to Customer No.");
                SalesInvoiceLines.SetRange("Document No.", "BASZuordnung zu RechnungPHA");
                if SalesInvoiceLines.FindSet() then
                    CheckItemChargeInvoice(FIELDNO("BASZuordnung zu RechnungPHA"), SalesInvoiceLines)
                else
                    if "BASZuordnung zu RechnungPHA" <> '' then
                        Error('Unzulässige Rechnungsnummer');

                if ("BASZuordnung zu RechnungPHA" = '') and (xRec."BASZuordnung zu RechnungPHA" <> '') then
                    DeleteChargeChargeAssgnt("Document Type", "Document No.", "Line No.");
            end;
        }
        field(50013; "Schrumpfgröße"; Decimal)
        {
            CalcFormula = lookup(Item."Schrumpfgröße" where("No." = field("No.")));
            FieldClass = FlowField;
        }
        field(50014; "Zugehörigkeitsdatum"; Date)
        {
            Description = 'MFU für Wertgutschriften';
        }
        field(50015; BASInlandfilterPHA; Boolean)
        {
        }
        field(50016; "BASHole VonPHA"; Integer)
        {

            trigger OnLookup()
            var
                recItem: Record Item;
                tempRecItemLedgerEntry: Record "Item Ledger Entry" temporary;
                ActionReturn: Action;
            begin

                //-UPDATE2013
                if Type = Type::Item then
                    if recItem.Get("No.") then begin
                        //TestField("Item No.");
                        tempRecItemLedgerEntry."Item No." := "No.";
                        tempRecItemLedgerEntry.SetRange("Item No.", "No.");
                        tempRecItemLedgerEntry.SetRange(Open, true);
                        if "Location Code" <> '' then begin
                            tempRecItemLedgerEntry."Location Code" := "Location Code";
                            tempRecItemLedgerEntry.SetRange("Location Code", "Location Code");
                        end;

                        //TODOPBA ActionReturn := PAGE.RUNMODAL(PAGE::Page50169, tempRecItemLedgerEntry);
                        if (ActionReturn = ACTION::LookupOK) or (ActionReturn = ACTION::OK) then begin

                            Validate(BASLotNoPHA, tempRecItemLedgerEntry.BASLotNoPHA);
                            "Verkaufschargennr." := tempRecItemLedgerEntry."Verkaufschargennr.";
                            //IF "Entry Type" = "Entry Type"::Transfer THEN
                            Validate(Teilmenge, tempRecItemLedgerEntry."Remaining Quantity");

                            "Location Code" := tempRecItemLedgerEntry."Location Code";
                            "Bin Code" := tempRecItemLedgerEntry.Lagerplatzhilfsfeld;

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

            TableRelation = if (Inlandfilter = const(false)) Item
            else
            if (Inlandfilter = const(true)) Item where("Country/Region Code" = filter('<=A'));
        }
        field(50511; "BASWertkorrektur zu ArtikelpostenPHA"; Integer)
        {


            trigger OnLookup()
            var
                ItemChargeAssgntSales: Record "5809";
                ShipmentLines: Page "5824";
            begin
            end;

            trigger OnValidate()
            begin
                if Type <> Type::"Charge (Item)" then
                    Error('Postenzuordnung nur bei Art=Zu/Abschlag erlaubt');
                //schreibe zu/abschlag
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
                //-LAN002
                Validate(Teilmenge);
                TestField("Qty. per Unit of Measure");

                if (Type <> Type::Item) and (Naturalrabattmenge <> 0) then
                    Error('FEHLENDE TEXTVARIABLE T37');

                if "Naturalrabattmenge geliefert" > 0 then
                    Error('FEHLENDE TEXTVARIABLE T37');
                //+LAN002
            end;
        }
        field(50514; "BASNaturalrabattmenge geliefertPHA"; Decimal)
        {
            DecimalPlaces = 0 : 5;

        }
        field(50515; BASVerkaufsBASStatisticCode2PHA; Code[10])
        {


        }
        field(50516; "BASExpiration DatePHA"; Date)
        {
            Caption = 'Expiration Date';


            trigger OnValidate()
            begin
                //-LAN006
                if "Document Type" = "Document Type"::"Credit Memo" then begin
                    if ("Expiration Date" <> xRec."Expiration Date") then begin
                        "LöscheCharge"();
                        EingabeCharge();
                    end;
                end;
                //+LAN006
            end;
        }
        field(50517; "BASSuchtgift/PsychotropPHA"; Text[1])
        {

        }
        field(50518; "BASNaturalrabatt fakturiertPHA"; Decimal)
        {
            Description = 'xx';
        }
        field(50519; "BASVerkaufschargennr.PHA"; Code[20])
        {


            trigger OnLookup()
            begin
                //-LAN006
                HoleCharge();
                "LöscheCharge"();
                EingabeCharge();
                //+LAN006
            end;

            trigger OnValidate()
            var
                recItem: Record Item;
                recLotNoInformation: Record "Lot No. Information";
            begin
                //-LAN006
                if "Document Type" <> "Document Type"::"Credit Memo" then begin
                    "Chargenprüfung"();
                end else begin
                    TestField(Type, Type::Item);
                    recItem.Get("No.");
                    recItem.TestField("Item Tracking Code");
                    if ("Verkaufschargennr." <> xRec."Verkaufschargennr.") then begin
                        if "Verkaufschargennr." <> '' then begin
                            recLotNoInformation.SetCurrentKey("Item No.", "Variant Code", "Verkaufschargennr.");
                            recLotNoInformation.SetRange("Item No.", "No.");
                            recLotNoInformation.SetRange("Variant Code", "Variant Code");
                            recLotNoInformation.SetRange("Verkaufschargennr.", "Verkaufschargennr.");
                            if recLotNoInformation.FindSet() then begin
                                BASLotNoPHA := recLotNoInformation.BASLotNoPHA;
                                "Verkaufschargennr." := recLotNoInformation."Verkaufschargennr.";
                                "Expiration Date" := recLotNoInformation."Expiration Date";
                                "LöscheCharge"();
                                EingabeCharge();
                            end else begin
                                Message('FEHLENDE TEXTVARIABLE T37');
                                "LöscheCharge"();
                                EingabeCharge();
                            end;
                        end;
                        Validate(BASLotNoPHA);
                    end;
                end;
                //+LAN006
            end;
        }
        field(50522; BASEDIArtikelBemerkungPHA; Text[100])
        {
        }
        field(50600; BASHervorhebenPHA; Boolean)
        {

        }
        field(50601; "BASOrder DatePHA"; Date)
        {
            Caption = 'Order Date';


            trigger OnValidate()
            begin

                //-GL046
                if (Type = Type::Item) or (Type = Type::"G/L Account") then
                    if ("Unit Price" > 0) and ("Currency Code" <> '') then
                        UpdateUnitPrice(FIELDNO(Teilmenge));
                //+GL046
            end;
        }
        field(50602; BASOriginalRequestedDeliveryDatePHA; Date)
        {
            Caption = 'Original Requested Delivery Date';
        }
    }
    procedure EingabeCharge()

    begin
        //Chargeneingabe in VK-Zeile nicht mehr machen!  MFU 12.04.2024
        /*
        //-LAN006
        IF SuspendLotCreation THEN
            exit;
        IF "Line No." = 0 THEN
            exit;
        IF BASLotNoPHA = '' THEN
            exit;
        IF Type <> Type::Item THEN
            exit;
        IF "No." = '' THEN
            exit;
        TestField("Quantity Shipped", 0);

        cuChargenverwaltung.EingabeCharge(
          DATABASE::"Sales Line", "Document Type", "Document No.", '', 0, "Line No.",
          "Qty. per Unit of Measure", "Quantity (Base)", "Qty. to Invoice (Base)", BASLotNoPHA,
          "Verkaufschargennr.", '', '', "Expiration Date", "No.", "Variant Code", "Location Code", "Shipment Date");
        //+LAN006
        */
    end;

    procedure "LöscheCharge"()
    begin
        //Chargeneingabe in VK-Zeile nicht mehr machen!  MFU 12.04.2024
        /*
        //-LAN006
        IF SuspendLotCreation THEN
            exit;
        IF "Line No." = 0 THEN
            exit;
        IF Type <> Type::Item THEN
            exit;

        cuChargenverwaltung.LöscheCharge(
          DATABASE::"Sales Line", "Document Type", "Document No.", '', 0, "Line No.", BASLotNoPHA);
        //+LAN006
        */
    end;

    procedure FaktMengeCharge()
    var
        CurrentSignFactor: Integer;
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

        LotMgt.FaktMengeCharge(
          DATABASE::"Sales Line", "Document Type", "Document No.", '', 0, "Line No.", BASLotNoPHA, "Qty. to Invoice (Base)");
        //+LAN006
    end;

    procedure HoleCharge()
    var
        ActionReturn: Action;
    begin
        /*
        //-UPDATE2013
        Item.Get("No.");
        Item.TestField("Item Tracking Code");
        //Chargenstamm."Item No." := "No.";
        //Chargenstamm."Variant Code" := "Variant Code";
        //Chargenstamm.BASLotNoPHA := BASLotNoPHA;
        
        CLEAR(Chargenstamm);   //GL036
        
        Chargenstamm.SetRange("Item No.","No.");
        //Gutschriften: Zugriff auch auf Chargen mit Lagerstand null
        IF "Document Type" <> "Document Type"::"Credit Memo" THEN BEGIN
          IF "Location Code" <> '' THEN
            Chargenstamm.SETFILTER("Location Filter","Location Code");
          IF "Bin Code" <> '' THEN
            Chargenstamm.SETFILTER("Bin Filter","Bin Code");
          Chargenstamm.SETFILTER(Inventory,'<>0');
          Chargenstamm.SetRange(Open,TRUE);
        
        //-GL036
          IF STRLEN(BASLotNoPHA)>0 THEN
            Chargenstamm.SetRange(BASLotNoPHA,BASLotNoPHA);
          Chargenstamm."Item No." := "No.";
        //+GL036
        END;
        
        //CLEAR(pChargenUebersicht);
        //pChargenUebersicht.SETTABLEVIEW(Chargenstamm);
        //pChargenUebersicht.SETRECORD(Chargenstamm);
        ActionReturn := PAGE.RUNMODAL(PAGE::Page50512,Chargenstamm);
        IF (ActionReturn = ACTION::LookupOK) OR (ActionReturn = ACTION::OK) THEN BEGIN  //Bei OK wird erste Zeile geliefert
          BASLotNoPHA := Chargenstamm.BASLotNoPHA;
          "Verkaufschargennr." := Chargenstamm."Verkaufschargennr.";
          "Expiration Date" := Chargenstamm."Expiration Date";
          IF Item.Artikelart = Item.Artikelart::Fertigprodukt THEN
            TestField("Verkaufschargennr.");
          Validate(BASLotNoPHA);
        END;
        //+UPDATE2013
        
        
        
        {!!!!!!!!!!!!!!1
        //-LAN006
        Item.Get("No.");
        Item.TestField("Item Tracking Code");
        Chargenstamm."Item No." := "No.";
        Chargenstamm."Variant Code" := "Variant Code";
        Chargenstamm.BASLotNoPHA := BASLotNoPHA;
        IF "Document Type" <> "Document Type"::"Credit Memo" THEN BEGIN
          Chargenstamm."Location Filter" := "Location Code";
          Chargenstamm."Bin Filter" := "Bin Code";
          Chargenstamm.SETFILTER(Inventory, '<>0');
          IF LotMgt.Chargenpostenwählen(Chargenstamm) THEN BEGIN
            BASLotNoPHA := Chargenstamm.BASLotNoPHA;
            "Verkaufschargennr." := Chargenstamm."Verkaufschargennr.";
            "Expiration Date" := Chargenstamm."Expiration Date";
            IF Item.Artikelart = Item.Artikelart::Fertigprodukt THEN
              TestField("Verkaufschargennr.");
            Validate(BASLotNoPHA);
          END;
        END ELSE BEGIN  //Gutschriften: Zugriff auch auf Chargen mit Lagerstand null
          recCharge.SetRange("Item No.",Chargenstamm."Item No.");
          recCharge."Item No." := Chargenstamm."Item No.";
          recCharge.BASLotNoPHA := Chargenstamm.BASLotNoPHA;
          recCharge."Variant Code" := Chargenstamm."Variant Code";
          IF PAGE.RUNMODAL(PAGE::"Chargenstamm Übersicht",recCharge)=ACTION::LookupOK THEN BEGIN
            BASLotNoPHA := recCharge.BASLotNoPHA;
            "Verkaufschargennr." := recCharge."Verkaufschargennr.";
            "Expiration Date" := recCharge."Expiration Date";
            IF Item.Artikelart = Item.Artikelart::Fertigprodukt THEN
              TestField("Verkaufschargennr.");
            Validate(BASLotNoPHA);
          END;
        END;
        //+LAN006
        }
        */

    end;

    procedure "Chargenprüfung"()
    begin
    end;

    procedure Bezugsberechtigung(Artikelnr: Code[20]; Kundennr: Code[20])
    var
        recCustomer: Record "18";
        recItem: Record Item;
    begin
        //-GL011
        if recCustomer.Get(Kundennr) then
            if recItem.Get(Artikelnr) then begin
                if (recItem.Suchtgift) and (recCustomer."SG-Bezug" = false) then
                    Error('Kunde %1 hat keine Suchtgiftbezugsberechtigung', recCustomer."No.");
                if (recItem."Psychotroper Stoff") and (recCustomer."PSY-Bezug" = false) then
                    Error('Kunde %1 hat keine Bezugsberechtigung für psychotrope Stoffe', recCustomer."No.");
            end;
        //+GL011
    end;

    procedure SetSuspendLotCreation(NewSuspendLotCreation: Boolean)
    begin
        //-LAN006
        SuspendLotCreation := NewSuspendLotCreation;
        //+LAN006
    end;

    procedure CheckItemChargeShipment(CalledByField: Integer; var SalesShipmentLines: Record "111")
    var
        SalesItemCharge: Record "5809";
    begin
        //-GL013
        if ("BASZuordnung zu Artikelnr.PHA" <> '') and ("Line No." <> 0) then begin
            SalesItemCharge.INIT();
            SalesItemCharge."Document Type" := "Document Type";
            SalesItemCharge."Document No." := "Document No.";
            SalesItemCharge."Document Line No." := "Line No.";
            SalesItemCharge."Line No." := 10000;
            SalesItemCharge."Item Charge No." := "No.";
            SalesItemCharge."Item No." := "BASZuordnung zu Artikelnr.PHA";
            SalesItemCharge.Description := '';
            SalesItemCharge."Qty. to Assign" := Quantity;
            SalesItemCharge."Qty. Assigned" := 0;
            //SalesItemCharge."Amount to Assign" := ABS("Line Amount"-"Line Discount Amount");
            SalesItemCharge."Amount to Assign" := "Line Amount";
            if SalesItemCharge."Qty. to Assign" <> 0 then
                SalesItemCharge."Unit Cost" := ROUND(SalesItemCharge."Amount to Assign" / SalesItemCharge."Qty. to Assign", 0.00001);
            SalesItemCharge."Applies-to Doc. Type" := SalesItemCharge."Applies-to Doc. Type"::Shipment;
            SalesItemCharge."Applies-to Doc. No." := SalesShipmentLines."Document No.";
            SalesItemCharge."Applies-to Doc. Line No." := SalesShipmentLines."Line No.";
            SalesItemCharge."Applies-to Doc. Line Amount" := 0;
            if not SalesItemCharge.INSERT() then
                SalesItemCharge.modify();
        end;
        //+GL013
    end;

    procedure CheckItemChargeInvoice(CalledByField: Integer; var SalesInvoiceLines: Record "Sales Invoice Line")
    var
        SalesItemCharge: Record "5809";
    begin
        //-GL013
        if ("BASZuordnung zu Artikelnr.PHA" <> '') and ("Line No." <> 0) then begin
            SalesItemCharge.INIT();
            SalesItemCharge."Document Type" := "Document Type";
            SalesItemCharge."Document No." := "Document No.";
            SalesItemCharge."Document Line No." := "Line No.";
            SalesItemCharge."Line No." := 10000;
            SalesItemCharge."Item Charge No." := "No.";
            SalesItemCharge."Item No." := "BASZuordnung zu Artikelnr.PHA";
            SalesItemCharge.Description := '';
            SalesItemCharge."Qty. to Assign" := Quantity;
            SalesItemCharge."Qty. Assigned" := 0;
            //SalesItemCharge."Amount to Assign" := ABS("Line Amount"-"Line Discount Amount");
            SalesItemCharge."Amount to Assign" := "Line Amount";
            if SalesItemCharge."Qty. to Assign" <> 0 then
                SalesItemCharge."Unit Cost" := ROUND(SalesItemCharge."Amount to Assign" / SalesItemCharge."Qty. to Assign", 0.00001);
            //TODOPBA SalesItemCharge."Applies-to Doc. Type" := SalesItemCharge."Applies-to Doc. Type"::;
            SalesItemCharge."Applies-to Doc. No." := SalesInvoiceLines."Document No.";
            SalesItemCharge."Applies-to Doc. Line No." := SalesInvoiceLines."Line No.";
            SalesItemCharge."Applies-to Doc. Line Amount" := 0;
            if not SalesItemCharge.INSERT() then
                SalesItemCharge.modify();
        end;
        //+GL013
    end;

    procedure GetRahmenauftragPreis(cRahmenNr: Code[20]; iRahmenLineNr: Integer; dPreis: Decimal; dMenge: Decimal; var bReturnOK: Boolean) dPreisReturn: Decimal
    var
        SalesHeader: Record "Sales Header";
        RSalesLine: Record "Sales Line";
        SalesLineQuantity: Record "Sales Line";
        ShipmentQuantity: Decimal;
    begin
        bReturnOK := true;  //GL028
        dPreisReturn := dPreis;
        if STRLEN(cRahmenNr) > 0 then begin

            //-GL029
            //Ist der Rahmenauftrag noch offen?
            CLEAR(SalesHeader);
            SalesHeader.SetRange("Document Type", SalesHeader."Document Type"::"Blanket Order");
            SalesHeader.SetRange("No.", cRahmenNr);
            SalesHeader.SetRange(Auftragsstatus, SalesHeader.Auftragsstatus::Geliefert);
            if not SalesHeader.FINDSET() then begin
                //+GL029

                //Rahmenauftragszeile holen
                CLEAR(RSalesLine);
                RSalesLine.SetRange("Document Type", "Document Type"::"Blanket Order");
                RSalesLine.SetRange("Document No.", cRahmenNr);
                RSalesLine.SetRange("Line No.", iRahmenLineNr);
                if RSalesLine.FINDSET() then begin
                    dPreisReturn := RSalesLine."Unit Price";

                    //Prüfen, ob noch genügend Stück am Rahmenauftrag offen sind
                    if (RSalesLine.Quantity - RSalesLine."Quantity Shipped") < dMenge then begin
                        bReturnOK := false;   //GL028
                        Message('Am Rahmenauftrag %1 sind %2 Stk offen!', cRahmenNr,
                          (RSalesLine.Quantity - RSalesLine."Quantity Shipped"));

                    end else begin
                        //Mengen "Zu Liefern" in den Aufträgen zu dem Rahmenauftrag summieren
                        ShipmentQuantity := 0;
                        CLEAR(SalesLineQuantity);
                        SalesLineQuantity.SetRange("Document Type", "Document Type"::Order);
                        SalesLineQuantity.SetRange("Blanket Order No.", cRahmenNr);
                        SalesLineQuantity.SetRange("Blanket Order Line No.", iRahmenLineNr);
                        if SalesLineQuantity.FINDSET() then
                            repeat
                                //Aktuelle Zeile ausnehmen
                                if not ((Rec."Document Type" = SalesLineQuantity."Document Type")
                                  and (Rec."Document No." = SalesLineQuantity."Document No.")
                                  and (Rec."Line No." = SalesLineQuantity."Line No.")) then
                                    ShipmentQuantity += SalesLineQuantity."Qty. to Ship"
                            until SalesLineQuantity.NEXT() = 0;

                        //Ist die offene Menge und die Menge in den Aufträgen kleiner als die Angefordete Menge, dann Meldung
                        if ((RSalesLine.Quantity - RSalesLine."Quantity Shipped") - ShipmentQuantity) < dMenge then begin
                            bReturnOK := false;   //GL028
                            Message('Für den Rahmenauftrag %1 sind %2 Stk offen und %3 Stk in Aufträgen vorgesehen!',
                              cRahmenNr, (RSalesLine.Quantity - RSalesLine."Quantity Shipped"), ShipmentQuantity + dMenge);
                        end;
                    end;

                end;

                //-GL029
            end else begin
                bReturnOK := false;
                Message('Der Rahmenauftrag %1 ist fertig geliefert!', cRahmenNr);
            end;
            //+GL029

        end;
        //+GL027
    end;

    procedure Packungsgroesse() cPackungsgroesse: Code[10]
    var
        recItem: Record Item;
    begin
        //-GL035
        cPackungsgroesse := '';
        if Type = Type::Item then
            if recItem.Get("No.") then
                cPackungsgroesse := recItem.BASPackageSizePHA;

        if ((Type = Type::"G/L Account") or (Type = Type::"Charge (Item)")) then
            if recItem.Get("BASZuordnung zu Artikelnr.PHA") then
                cPackungsgroesse := recItem.BASPackageSizePHA;
        //+GL035
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

    procedure "CheckArtikelVerfügbarkeitVKL"(cItemNo: Code[20]; cLotNo: Code[20]; dMengeBedarf: Decimal; cAuftragNr: Code[20])
    var
        Item: Record Item;
        ItemLedgerEntry: Record "Item Ledger Entry";
        SalesLine: Record "Sales Line";
        Inventory: Decimal;
        QuantityInOrder: Decimal;
    begin
        if Item.Get(cItemNo) then begin
            if (STRLEN(cLotNo) > 0) and (dMengeBedarf > 0) then begin

                //Lagerstand auf VKL ermitteln
                CLEAR(ItemLedgerEntry);
                ItemLedgerEntry.SetCurrentKey("Item No.", Open, "Variant Code", Positive, "Location Code", "Posting Date",
                  "Expiration Date", BASLotNoPHA, "Serial No.");
                ItemLedgerEntry.SetRange(Open, true);
                ItemLedgerEntry.SetRange("Item No.", cItemNo);
                ItemLedgerEntry.SETFILTER("Location Code", 'VKL');
                ItemLedgerEntry.SetRange(BASLotNoPHA, cLotNo);
                if ItemLedgerEntry.FindFirst() then begin
                    Inventory := 0;
                    repeat
                        Inventory += ItemLedgerEntry."Remaining Quantity";
                    until ItemLedgerEntry.NEXT() = 0;
                end;

                //Menge in Aufträge, nicht geliefert, ermitteln
                SalesLine.SetRange(Type, SalesLine.Type::Item);
                SalesLine.SetRange("No.", cItemNo);
                SalesLine.SetRange(BASLotNoPHA, cLotNo);
                SalesLine.SETFILTER("Document No.", '<>' + cAuftragNr);      //Eigenen Auftrag ausnehmen
                if SalesLine.FindFirst() then
                    repeat
                        QuantityInOrder += SalesLine."Qty. to Ship";
                    until SalesLine.NEXT() = 0;
                //Eigenen Auftrag nicht mitnehmen


                //Genug offene Menge vorhanden?
                if dMengeBedarf > (Inventory - QuantityInOrder) then
                    Message('Keine Ausreichende Menge auf VKL der Charge %1 vorhanden!', cLotNo);

            end;
        end;
        //+GL040
    end;

    procedure SetOriginalRequestedDeliveryDate()
    var
        SalesHeader: Record "Sales Header";
    begin
        // >> GL048
        SalesHeader.Get("Document Type", "Document No.");
        if ((OriginalRequestedDeliveryDate = 0D) and
             (SalesHeader."Requested Delivery Date" <> 0D) and
             (Type = Type::Item)) then begin
            OriginalRequestedDeliveryDate := SalesHeader."Requested Delivery Date";
        end;
        // << GL048
    end;

    var
        LotMgt: Codeunit 50002;
        cuChargenverwaltung: Codeunit ChargenverwaltungPageApp;
        SuspendLotCreation: Boolean;
}
