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



    /*
    procedure EingabeCharge(ForType: Option; ForSubtype: Integer; ForID: Code[20]; ForBatchName: Code[10]; ForProdOrderLine: Integer; ForRefNo: Integer; ForQtyPerUOM: Decimal; Quantity: Decimal; InvQuantity: Decimal; ForLotNo: Code[20]; ForVKLotNo: Code[20]; ForEKLotNo: Code[20]; ForEKPackmittelVersion: Code[20]; ForExpDate: Date; ForItemNo: Code[20]; ForVariant: Code[10]; ForLocation: Code[10]; ForShipDate: Date)
    var
        ReservEntry_Insert: Record "337";
    begin

        //-GL006
        ForVariant := '';
        //+GL006

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
        IF ReservEntry.FINDFIRST THEN
            LöscheCharge(ForType, ForSubtype, ForID, ForBatchName, ForProdOrderLine, ForRefNo, ForLotNo);



        CreateReservEntry.SetDates(
          0D, ForExpDate);

        //-GL002
        IF (ForType = DATABASE::"Item Journal Line") AND (ForSubtype = 4) THEN BEGIN
            CreateReservEntry.SetNewExpirationDate(ForExpDate);
        END;
        //+GL002

        CreateReservEntry.CreateEntry(
          ForItemNo,                                   //"Item No."
          ForVariant,                                  //"Variant Code"
          ForLocation,                                 //"Location Code"
          '',                                          //Description
          ForShipDate,                                 //ExpectedReceiptDate
          ForShipDate,                                 //ShipmentDate
          0,
          CurrentEntryStatus);                         //CurrentEntryStatus

        IF Quantity <> InvQuantity THEN
            FaktMengeCharge(ForType, ForSubtype, ForID, ForBatchName, ForProdOrderLine, ForRefNo, ForLotNo, InvQuantity);
        //+LAN001
    end;
    */

    procedure FaktMengeCharge(ForType: Option; ForSubtype: Integer; ForID: Code[20]; ForBatchName: Code[10]; ForProdOrderLine: Integer; ForRefNo: Integer; ForLotNo: Code[20]; InvQuantity: Decimal)
    var
        QtyToInvoiceThisLine: Decimal;
        TotalQtyToInvoice: Decimal;
        CurrentSignFactor: Integer;
    begin
        //-LAN001
        //Vorzeichen ermitteln
        ReservEntry."Source Type" := ForType;
        ReservEntry."Source Subtype" := ForSubtype;
        CurrentSignFactor := CreateReservEntry.SignFactor(ReservEntry);

        TotalQtyToInvoice := InvQuantity * CurrentSignFactor;
        //Verfolgungszeilen
        TrackingSpecification.SetRange("Source Type", ForType);
        TrackingSpecification.SetRange("Source Subtype", ForSubtype);
        TrackingSpecification.SetRange("Source ID", ForID);
        TrackingSpecification.SetRange("Source Batch Name", ForBatchName);
        TrackingSpecification.SetRange("Source Prod. Order Line", ForProdOrderLine);
        TrackingSpecification.SetRange("Source Ref. No.", ForRefNo);
        TrackingSpecification.SetRange("Lot No.", ForLotNo);
        IF TrackingSpecification.FindSet(TRUE, FALSE) THEN
            REPEAT
                IF NOT TrackingSpecification.Correction THEN BEGIN
                    QtyToInvoiceThisLine :=
                      TrackingSpecification."Quantity Handled (Base)" - TrackingSpecification."Quantity Invoiced (Base)";
                    IF ABS(QtyToInvoiceThisLine) > ABS(TotalQtyToInvoice) THEN
                        QtyToInvoiceThisLine := TotalQtyToInvoice;

                    IF TrackingSpecification."Qty. to Invoice (Base)" <> QtyToInvoiceThisLine THEN BEGIN
                        TrackingSpecification."Qty. to Invoice (Base)" := QtyToInvoiceThisLine;
                        TrackingSpecification.Modify();
                    END;

                    TotalQtyToInvoice -= QtyToInvoiceThisLine;
                END;
            UNTIL (TrackingSpecification.Next() = 0);

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
        IF ReservEntry.FindSet(TRUE, FALSE) THEN
            REPEAT
                QtyToInvoiceThisLine := ReservEntry."Quantity (Base)";

                IF ABS(QtyToInvoiceThisLine) > ABS(TotalQtyToInvoice) THEN
                    QtyToInvoiceThisLine := TotalQtyToInvoice;

                IF (ReservEntry."Qty. to Invoice (Base)" <> QtyToInvoiceThisLine) AND NOT ReservEntry.Correction THEN BEGIN
                    ReservEntry."Qty. to Invoice (Base)" := QtyToInvoiceThisLine;
                    ReservEntry.Modify();
                END;

                TotalQtyToInvoice -= QtyToInvoiceThisLine;

            UNTIL (ReservEntry.Next() = 0) OR (TotalQtyToInvoice = 0);
        //+LAN001
    end;

    procedure LiefMengeCharge(ForType: Option; ForSubtype: Integer; ForID: Code[20]; ForBatchName: Code[10]; ForProdOrderLine: Integer; ForRefNo: Integer; ForLotNo: Code[20]; InvQuantity: Decimal)
    var
        QtyToHandleThisLine: Decimal;
        TotalQtyToHandle: Decimal;
        CurrentSignFactor: Integer;
    begin
        //-LAN001

        //Vorzeichen ermitteln
        ReservEntry."Source Type" := ForType;
        ReservEntry."Source Subtype" := ForSubtype;
        CurrentSignFactor := CreateReservEntry.SignFactor(ReservEntry);

        TotalQtyToHandle := InvQuantity * CurrentSignFactor;

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
        IF ReservEntry.FindSet(TRUE, FALSE) THEN
            REPEAT
                QtyToHandleThisLine := ReservEntry."Quantity (Base)";

                IF ABS(QtyToHandleThisLine) > ABS(TotalQtyToHandle) THEN
                    QtyToHandleThisLine := TotalQtyToHandle;

                IF (ReservEntry."Qty. to Handle (Base)" <> QtyToHandleThisLine) AND NOT ReservEntry.Correction THEN BEGIN
                    ReservEntry."Qty. to Handle (Base)" := QtyToHandleThisLine;
                    ReservEntry.Modify();
                END;

                TotalQtyToHandle -= QtyToHandleThisLine;

            UNTIL (ReservEntry.Next() = 0) OR (TotalQtyToHandle = 0);
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
        Item.TESTFIELD("Item Tracking Code");

        Chargenstamm.SetRange("Item No.", recCharge."Item No.");
        Chargenstamm.SetFilter(Inventory, '>0');
        IF recCharge."Location Filter" <> '' THEN
            Chargenstamm.SetFilter("Location Filter", recCharge."Location Filter");

        IF recCharge."Bin Filter" <> '' THEN
            Chargenstamm.SetFilter(Chargenstamm."Bin Filter", recCharge."Bin Filter");

        IF recCharge.GETFILTER(Inventory) <> '' THEN
            Chargenstamm.SetFilter(Chargenstamm.Inventory, recCharge.GETFILTER(Inventory));

        Chargenstamm."Item No." := recCharge."Item No.";
        Chargenstamm."Lot No." := recCharge."Lot No.";


        //TODOPBA - 
        IF PAGE.RUNMODAL(PAGE::"Lot No. Information List", Chargenstamm) = ACTION::LookupOK THEN BEGIN
            recCharge := Chargenstamm;
            EXIT(TRUE);
            //END;

            //+LAN001
        end;
    end;

    procedure ChargenstammAnlegen(ItemJnlLine: Record "83")
    var
        Item: Record 27;
        recPurchLine: Record 39;
        Chargenstamm: Record 6505;
        cuNavipharma: Codeunit 50001;

        bCEPmandatory: Boolean;
        ItemType: Text[50];
    begin
        //-LAN001
        GLOBALLANGUAGE(3079); //damit auch bei Webserviceaufruf Datum und Option-Felder in deutsch genommen werden
        WITH ItemJnlLine DO BEGIN
            IF "Lot No." = '' THEN
                EXIT;

            IF NOT Chargenstamm.GET("Item No.", "Variant Code", "Lot No.") THEN BEGIN
                Chargenstamm.Init();
                Chargenstamm."Item No." := "Item No.";
                //-GL006
                //Chargenstamm."Variant Code" := "Variant Code";
                Chargenstamm."Variant Code" := '';
                //+GL006
                Chargenstamm."Lot No." := "Lot No.";
                Chargenstamm."Expiration Date" := "Expiration Date";
                Chargenstamm.BASSalesLotNoPHA := BASSalesLotNoPHA;
                Chargenstamm."Lief. Chargennr." := "Lieferantenchargennr.";
                Chargenstamm.Packmittelversion := Packmittelversion;
                //-GL009
                //ALT
                //Chargenstamm.Description := STRSUBSTNO('%1 %2; %3',"Entry Type","Document No.","Posting Date");
                //NEU: im Format 13.01.2017 statt 01/13/17 in Chargenstamm schreiben -> ERST NACH CHANGE AKTIVIEREN
                Chargenstamm.Description := STRSUBSTNO('%1 %2; %3', "Entry Type", "Document No.", Format("Posting Date", 0, '<day,2>.<month,2>.<year4>'));
                //+GL009

                //-GL008
                IF "Entry Type" = "Entry Type"::Purchase THEN BEGIN
                    recPurchLine.SetRange("Document No.", ItemJnlLine."Bestellnr.");
                    recPurchLine.SetRange("No.", ItemJnlLine."Item No.");
                    IF recPurchLine.FINDFIRST() THEN
                        //-GL011
                        IF StrLen(recPurchLine.HerstellerNr) > 0 THEN
                            Chargenstamm.HerstellerNr := recPurchLine.HerstellerNr;
                    //Chargenstamm.Description += '; '+recPurchLine.HerstellerNr;
                    IF StrLen(recPurchLine."CEP Nr") > 0 THEN
                        Chargenstamm."CEP Nr" := recPurchLine."CEP Nr";
                    //+GL011
                    //-GL012
                    IF recPurchLine."Expiration Date DM" <> '' THEN
                        Chargenstamm."Expiration Date DM" := recPurchLine."Expiration Date DM";
                    //+GL012
                    //-GL014
                    //END;
                END ELSE BEGIN
                    IF "Entry Type" = "Entry Type"::"Positive Adjmt." THEN  //Bei Zugangsbuchung Hersteller/CEP prüfen
                        IF (StrLen(HerstellerNr) > 0) AND (StrLen(Chargenstamm.HerstellerNr) = 0) THEN
                            Chargenstamm.HerstellerNr := HerstellerNr;
                    IF (StrLen("CEP Nr") > 0) AND (StrLen(Chargenstamm."CEP Nr") = 0) THEN
                        Chargenstamm."CEP Nr" := "CEP Nr";



                END;
                //+GL014
                //+GL008
                Chargenstamm.Open := TRUE;

                //+GL004
                //Auf Wunsch von Dr. Muster wird die Standortweiche über das Lager gestellt
                IF ("Location Code" <> '') AND (cuNavipharma.StandortWeiche('LOCATION_SITE_MANUFACTURING', "Location Code") = 'WIEN') THEN
                    IF Item.GET("Item No.") THEN Chargenstamm."Laetus-Code" := Item."Laetus-Code";
                //-GL004

                //-GL011 - Nicht verwendet - Item Journal Line Spalten wurden wieder entfernt.
                //Chargenstamm."CEP Nr" := "CEP Nr";
                //Chargenstamm.HerstellerNr := HerstellerNr;
                //+GL011

                Chargenstamm.Insert();
            END;
        END;
        //+LAN001
    end;

    procedure FaktMengeChargeAlt(ForType: Option; ForSubtype: Integer; ForID: Code[20]; ForBatchName: Code[10]; ForProdOrderLine: Integer; ForRefNo: Integer; ForLotNo: Code[20]; InvQuantity: Decimal)
    var
        CurrentSignFactor: Integer;
    begin
        //-LAN001
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
            CurrentSignFactor := CreateReservEntry.SignFactor(ReservEntry);

            ReservEntry."Qty. to Invoice (Base)" := InvQuantity * CurrentSignFactor;
            ReservEntry.Modify();
        END;
        //+LAN001
    end;

    procedure "Aktualisiere Verkaufscharge"("Artikelnr.": Code[20]; "Chargennr.": Code[20]; Option: Option BASSalesLotNoPHA,Haltbarkeitsdatum; VKCNeu: Code[20]; HBNeu: Date): Boolean
    var
        ItemLedgEntry: Record "32";
    begin
        //-LAN001
        IF Option = Option::BASSalesLotNoPHA THEN
            IF NOT Confirm(Text001, FALSE, ItemLedgEntry.FIELDCAPTION(BASSalesLotNoPHA)) THEN
                ERROR(Text000);

        IF Option = Option::Haltbarkeitsdatum THEN
            IF NOT Confirm(Text001, FALSE, ItemLedgEntry.FIELDCAPTION("Expiration Date")) THEN
                ERROR(Text000);

        ItemLedgEntry.SetCurrentKey("Item No.");
        ItemLedgEntry.SetRange("Item No.", "Artikelnr.");
        ItemLedgEntry.SetRange("Lot No.", "Chargennr.");

        IF Option = Option::BASSalesLotNoPHA THEN
            ItemLedgEntry.ModifyALL(BASSalesLotNoPHA, VKCNeu);

        IF Option = Option::Haltbarkeitsdatum THEN
            ItemLedgEntry.ModifyALL("Expiration Date", HBNeu);
        //+LAN001
    end;

    procedure "PrüfeChargenMenge"(ItemNo: Code[20]; LotNo: Code[20]; Qty: Decimal; LocationCode: Code[10]) Haltbarkeitsdatum: Date
    var
        Item: Record Item;
    begin
        //-LAN001
        Item.GET(ItemNo);
        IF Item."Item Tracking Code" <> '' THEN BEGIN
            Item.SetFilter("Lot No. Filter", LotNo);
            //-GL013
            //Item.SetFilter("Location Filter",LocationCode);
            IF LocationCode = 'VKL' THEN
                Item.SetFilter("Location Filter", 'SVKL|VKL')
            ELSE
                Item.SetFilter("Location Filter", LocationCode);
            //+GL013
            Item.CALCFIELDS(Inventory);

            IF ABS(Qty) > Item.Inventory THEN
                ERROR(Text002,
                  ItemNo, LotNo, LocationCode, Item.Inventory);
        END;
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

        IF ReservEntry.FINDFIRST() THEN BEGIN
            CLEAR(ReservEntry_Insert);
            ReservEntry_Insert.COPY(ReservEntry);
            ReservEntry_Insert."Entry No." += 1;
            ReservEntry_Insert.Positive := TRUE;
            ReservEntry_Insert."Location Code" := ForLocation;
            ReservEntry_Insert."Quantity (Base)" := (ReservEntry."Quantity (Base)" * (-1));
            ReservEntry_Insert.Quantity := (ReservEntry.Quantity * (-1));
            ReservEntry_Insert."Qty. to Handle (Base)" := (ReservEntry."Qty. to Handle (Base)" * (-1));
            ReservEntry_Insert."Qty. to Invoice (Base)" := (ReservEntry."Qty. to Invoice (Base)" * (-1));
            ReservEntry_Insert."Source Subtype" := ReservEntry_Insert."Source Subtype"::"1";
            ReservEntry_Insert."Shipment Date" := 0D;
            ReservEntry_Insert."Expected Receipt Date" := ForReceiptDate;
            IF NOT ReservEntry_Insert.Insert() THEN
                Message('Fehler beim Einfügen der Reservierungszeile %1.', ReservEntry_Insert."Entry No.");
        END;

        //+GL003
    end;

    procedure MakeChargenNr(iChargenArt: Integer; cChargennr: Code[20]; bFertigprodukt: Boolean; cItemNo: Code[20]) cReturnCharge: Code[20]
    var
        recProdOrder: Record "5405";
        LotNoInformationNoInformation: Record "6505";
        bChargeFound: Boolean;
        chAsciiZeichen: Char;
        iAsciiWert: Integer;
        iAsciiWertZusatz: Integer;
    begin
        //+017
        //MFU 01.12.2009
        //iChargenArt -> 1=Verkaufschargennummer; 2=Chargennummer
        //cChargennr -> Chargennummer "2010A001" oder Verkaufschargennr "0A001"
        //bFertigprodukt -> TRUE=Charge für Fertigprodukt FALSE=Charge für HF
        //cChargennrVk -> Wird für das erstellen der Verkaufschargennummer benötigt - Wird nur bei iChargenArt=1 benötigt!
        //Holen der nächsten freien Chargennummer für Fertigprodukte



        cReturnCharge := cChargennr; //Default Rückgabewert

        IF bFertigprodukt = TRUE THEN BEGIN

            IF iChargenArt = 2 THEN BEGIN

                iAsciiWertZusatz := 0;

                //Letzte Bulk Chargennummer in den FA oder Chargenstamm für ein Fertigprodukt
                cReturnCharge := GetLastChargeNr(cChargennr, cItemNo);
                IF cReturnCharge = '' THEN
                    cReturnCharge := cChargennr
                ELSE
                    iAsciiWertZusatz := 1;  //Charge zu einen Fertigprodukt gefunden -> nicht mehr mit A starten


                //Erstellen der fiktiven neuen Chargenummer aus möglichen alten Chargennummern -> ist für die Übergangszeit nötig
                //  (wie die derzeitige Nummer im neuen System aussehen würde)
                //2009A001 -> 2009A001A, 2009A001-1 -> 2009A001B
                IF StrLen(cReturnCharge) = 8 THEN BEGIN
                    chAsciiZeichen := 65 + iAsciiWertZusatz;
                    cReturnCharge := cReturnCharge + Format(chAsciiZeichen);
                END;
                IF StrLen(cReturnCharge) > 9 THEN BEGIN
                    //-GL007
                    //alt //EVALUATE(iAsciiWert,CopyStr(cReturnCharge,10,StrLen(cReturnCharge)-9));
                    EVALUATE(iAsciiWert, CopyStr(cReturnCharge, StrLen(cReturnCharge), 1));
                    //-GL007
                    chAsciiZeichen := 65 + iAsciiWert + iAsciiWertZusatz;  //z.B. aus den 1 ein B machen
                    cReturnCharge := CopyStr(cReturnCharge, 1, 8) + Format(chAsciiZeichen);
                END;

                //Sicherheitsabfragen
                IF StrLen(cReturnCharge) <> 9 THEN
                    ERROR('Falsche Chargennummer %1', cReturnCharge);

                //Hinaufzählen in den vorhandenen Abpackungen zu dem Artikel mit neuen Format
                cReturnCharge := GetLastChargeNrNew(cReturnCharge, cItemNo);

            END ELSE BEGIN  //Verkaufschargennummer an Chargennummer anpassen

                //Erstellen der Verkaufschargennummer aus der Chargennummer
                //2009A123A -> 9A123A
                cReturnCharge := MakeVKchargennr(cChargennr);

            END;
        END;

        //-017
    end;

    procedure MakeVKchargennr(chnr: Code[20]) vkchnr: Code[20]
    var
        ManufacturingSetup: Record "99000765";
    begin
        //Verkaufscharge zusammenstellen

        ManufacturingSetup.GET();
        IF ManufacturingSetup.Chargennummernsystem = ManufacturingSetup.Chargennummernsystem::Lannacher THEN BEGIN

            // erzeuge 1D123A aus 2001D123A (Interne CH.nr zu Verkaufschargennr.)
            // erzeuge 1D123A aus 2001D123 (Interne CH.nr zu Verkaufschargennr.)
            vkchnr := '';
            IF StrLen(chnr) = 9 THEN
                vkchnr := CopyStr(chnr, 4, 1) + CopyStr(chnr, 5, 1) + CopyStr(chnr, 6, 3) + CopyStr(chnr, 9, 1);
            IF StrLen(chnr) = 8 THEN
                vkchnr := CopyStr(chnr, 4, 1) + CopyStr(chnr, 5, 1) + CopyStr(chnr, 6, 3);
        END;
    end;



    procedure GetLastChargeNr(cChargennr: Code[20]; cItemNo: Code[20]) cReturnCharge: Code[20]
    var
        recProdOrder: Record "5405";
        LotNoInformationNoInformation: Record "6505";
        Item: Record Item;
    begin
        //+017
        //MFU 02.12.2009
        //cChargennr -> Chargennummer "2010A001"
        //Suchen der letzten alten Chargen Nummer, für den Artikel, wenn eine Bulk Charge übergeben wurde (8-stellig) ->
        //  neue Charge wird in Funktion MakeChargeNr hinaufgezählt      (Ergebniss=2009A001,2009A001-1)

        cReturnCharge := ''; //Default Wert, wenn noch keine Abpackung mit der Chargennummer und zu dem Artikel gefunden wurde

        IF StrLen(cChargennr) = 8 THEN BEGIN

            //Die größte Chargennr aus dem Chargenstamm für ein Fertigprodukt holen
            LotNoInformationNoInformation.RESET();
            LotNoInformationNoInformation.SetCurrentKey("Lot No.", "Item No.");
            LotNoInformationNoInformation.SetFilter("Lot No.", cChargennr + '*');
            LotNoInformationNoInformation.SetFilter("Item No.", cItemNo);
            IF LotNoInformationNoInformation.FindSet() THEN BEGIN
                REPEAT
                    IF StrLen(LotNoInformationNoInformation."Lot No.") < 11 THEN BEGIN    //MFU 07.10.2020
                        Item.RESET();
                        IF Item.GET(LotNoInformationNoInformation."Item No.") THEN
                            IF Item.Artikelart = Item.Artikelart::Fertigprodukt THEN
                                IF LotNoInformationNoInformation."Lot No." > cReturnCharge THEN
                                    cReturnCharge := LotNoInformationNoInformation."Lot No.";
                    END;
                UNTIL LotNoInformationNoInformation.Next() = 0;
            END;



        END;
        //-017
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
        REPEAT

            //Prüfen, ob die Chargennr schon im Chargenstamm existiert
            LotNoInformationNoInformation.RESET();
            LotNoInformationNoInformation.SetCurrentKey("Lot No.", "Item No.");
            LotNoInformationNoInformation.SetRange("Lot No.", cChargennr);
            LotNoInformationNoInformation.SetRange("Item No.", cItemNo);
            bChargeFound := LotNoInformationNoInformation.FindSet();



            //Hinaufzählen, wenn ein gleicher Eintrag gefunden wurde
            IF bChargeFound THEN BEGIN

                chAsciiZeichen := 0;
                //Ascii Wert des letzten Zeichens
                EVALUATE(chAsciiZeichen, CopyStr(cChargennr, StrLen(cChargennr), 1));
                chAsciiZeichen += 1;

                cChargennr := CopyStr(cChargennr, 1, StrLen(cChargennr) - 1);  //erster Teil der Chargennummer
                cChargennr := cChargennr + Format(chAsciiZeichen);

            END;

        UNTIL NOT bChargeFound;

        cReturnCharge := cChargennr;

        //-017
    end;

    procedure RohstoffChargenNummernkreis(Artikelnummer: Code[20]) Nummernserie: Code[20]
    var
        recInventorySetup: Record "313";
        recManufacturingSetup: Record "99000765";
        Item: Record Item;
    begin

        Item.GET(Artikelnummer);

        IF Item."Site Manufacturing" = '' THEN BEGIN  //für Genericon
            recInventorySetup.GET();
            recInventorySetup.TESTFIELD(Rohstoffchargennummern);
            Nummernserie := recInventorySetup.Rohstoffchargennummern;
            EXIT(Nummernserie);
        END;

        IF Item."Site Manufacturing" <> '' THEN BEGIN //GL-Pharma Standort Lannach/Wien
            recManufacturingSetup.GET(Item."Site Manufacturing");
            recManufacturingSetup.TESTFIELD(Rohstoffchargennummern);
            Nummernserie := recManufacturingSetup.Rohstoffchargennummern;
            EXIT(Nummernserie);
        END;
    end;


}

