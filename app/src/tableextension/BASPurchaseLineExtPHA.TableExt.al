tableextension 50015 BASPurchaseLineExtPHA extends "Purchase Line"
{
    fields
    {
        field(50000; BASPreisfaktorPHA; Decimal)
        {
        }
        field(50001; BASPackmittelversionPHA; Code[20])
        {
            TableRelation = if (Type = const(Item)) "Item Variant".Code where("Item No." = field("No."));
            trigger OnValidate()
            begin
                LotNoInformation.Reset();
                LotNoInformation.SetRange("Item No.", "No.");
                LotNoInformation.SetRange("Variant Code", "Variant Code");
                LotNoInformation.SetRange(BASSalesLotNoPHA, BASLotNoPHA);
                if LotNoInformation.FindFirst() then begin
                    BASPackmittelversionPHA := LotNoInformation.BASPackmittelversionPHA;
                    Message('Keine Textvariable T39', "No.", FieldCaption(BASPackmittelversionPHA), BASPackmittelversionPHA);
                end;

                Validate(BASLotNoPHA);
            end;
        }
        field(50002; "DruckUnterlagenPrüfung"; Option)
        {
            OptionMembers = " ",offen,erledigt;
        }
        field(50003; "Einkäufercode"; Code[20])
        {
            CalcFormula = lookup("Purchase Header"."Purchaser Code" where("Document Type" = field("Document Type"), "No." = field("Document No.")));
            FieldClass = FlowField;
        }
        field(50004; BASBestelldatumPHA; Date)
        {
            CalcFormula = lookup("Purchase Header"."Order Date" where("Document Type" = field("Document Type"), "No." = field("Document No.")));
            FieldClass = FlowField;
        }
        field(50005; BASHerstellerNrPHA; Code[20])
        {

        }
        field(50006; BASCEPNoPHA; Code[50])
        {
        }
        field(50010; BASLotNoPHA; Code[20])
        {
            Caption = 'Lot No.';

            // ToDo
            // TableRelation = if (Type = const(Item)) BASLotSerialNoInformationPHA.BASLotNoPHA where("Item No." = field("No."),
            //                                                                              "Variant Code" = field("Variant Code"));
            // ValidateTableRelation = false;
        }
        field(50500; BASTotalQuantityInOrderPHA; Decimal)
        {
            CalcFormula = sum("Purchase Line"."Outstanding Qty. (Base)"
                where("Document Type" = const("Order"), Type = const(Item), "No." = field("No.")));
            DecimalPlaces = 0 : 5;

            Editable = false;
            FieldClass = FlowField;
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
        field(50510; "BASCountry/Region CodePHA"; Code[10])
        {
            Caption = 'Country/Region Code';

            TableRelation = "Country/Region";
        }
        field(50511; "BASOpt. MengePHA"; Text[20])
        {

        }
        field(50514; "BASSuchtgift/PsychotropPHA"; Text[1])
        {

        }
        field(50515; "BASDirect Unit Cost PEPHA"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 2;
            Caption = 'Direct Unit Cost PE';

        }
        field(50516; "BASMengeninfo MengenstaffelPHA"; Decimal)
        {
            DecimalPlaces = 0 : 5;

            Editable = false;
        }
        field(50526; "BASLieferantenchargennr.PHA"; Code[20])
        {
        }
        field(50528; BASSalesChargePHA; Code[20])
        {
            trigger OnValidate()
            begin
                Item.Get("No.");
                LotNoInformation.Reset();
                LotNoInformation.SetRange("Item No.", "No.");
                LotNoInformation.SetRange("Variant Code", "Variant Code");
                // LotNoInformation.SetRange(BASSalesChargePHA, BASLotNoPHA);
                // if LotNoInformation.FindFirst() then begin
                //     BASSalesChargePHA := LotNoInformation.BASSalesLotNoPHA;
                //     Message('KEINE TEXTVARIABLE T39', "No.", FieldCaption(BASSalesChargePHA), BASLotNoPHA);
                // end;

                Validate(BASLotNoPHA);
            end;
        }
        field(50529; BASQuantityPHA; Decimal)
        {
            DecimalPlaces = 0 : 5;
        }
        field(50530; "BASExpiration DatePHA"; Date)
        {
            Caption = 'Expiration Date';
            trigger OnValidate()
            begin
                Item := GetItem();
                LotNoInformation.SetRange("Item No.", "No.");
                LotNoInformation.SetRange("Variant Code", "Variant Code");
                // LotNoInformation.SetRange(BASLotNoPHA, BASLotNoPHA);
                // if LotNoInformation.FindFirst() then begin
                // ToDo
                // BASExpirationDateDMPHA := LotNoInformation.BASExpirationDateDMPHA;
                // Message('KEINE TEXTVARIABLE T39', "No.", FieldCaption(BASExpirationDateDMPHA), BASExpirationDateDMPHA);
                // end;

                Validate(BASLotNoPHA);
            end;
        }
        field(50550; BASGebindeanzahlPHA; Decimal)
        {
            DecimalPlaces = 0 : 5;

        }
        field(50551; BASGebindeartencodePHA; Code[10])
        {

            //TableRelation = Gebindeart;
        }
        field(50552; "BASAbruf BestellmengePHA"; Decimal)
        {
            CalcFormula = sum("Purchase Line"."Outstanding Quantity" where("Document Type" = const("Order"),
                                                                            "Blanket Order No." = field("Document No."),
                                                                            "Blanket Order Line No." = field("Line No.")));
            DecimalPlaces = 0 : 5;

            Editable = false;
            FieldClass = FlowField;
        }
        field(50553; BASPalettenanzahlPHA; Integer)
        {
        }
        field(50580; "BASBezug Artikelnr.PHA"; Code[20])
        {

            TableRelation = Item;
        }
        field(50581; "BASBezug Art.PostenPHA"; Integer)
        {

        }
        field(50583; BASValueCorrItemLedgEntryPHA; Integer)
        {
        }
        field(50584; BASAssignItemNoPHA; Code[20])
        {
            TableRelation = Item;
            trigger OnValidate()
            begin
                Wertgutschrift();
            end;
        }
        field(50585; BASBeschreibungLangPHA; BLOB)
        {

        }

        field(50587; BASExpirationDateDMPHA; Text[6])
        {
            Numeric = true;
            Width = 6;
            trigger OnValidate()
            begin
                CheckExpDate();
            end;
        }
    }
    var
        Item: record Item;
        LotNoInformation: Record "Lot No. Information";
        PurchHeader: Record "Purchase Header";
        // Codesammlung: Codeunit "50000";
        // cuNaviPharma: Codeunit "50001";
        // LotMgt: Codeunit "50002";
        "BemerkungsmeldungUnterdrücken": Boolean;
        SpeichernGefragt: Boolean;

    procedure FaktMengeCharge()
    begin
        if "Line No." = 0 then
            exit;
        if BASLotNoPHA = '' then
            exit;
        if Type <> Type::Item then
            exit;
        if "No." = '' then
            exit;

        // LotMgt.FaktMengeCharge(
        //   DATABASE::"Purchase Line", "Document Type", "Document No.", '', 0, "Line No.", BASLotNoPHA, "Qty. to Invoice (Base)");
    end;

    procedure LiefMengeCharge()
    // var
    //     CurrentSignFactor: Integer;
    begin
        //-LAN005
        if "Line No." = 0 then
            exit;
        if BASLotNoPHA = '' then
            exit;
        if Type <> Type::Item then
            exit;
        if "No." = '' then
            exit;

        // LotMgt.LiefMengeCharge(
        //   DATABASE::"Purchase Line", "Document Type", "Document No.", '', 0, "Line No.", BASLotNoPHA, "Qty. to Receive (Base)");
        //+LAN005
    end;

    procedure HoleCharge()
    begin
    end;

    procedure NeueCharge(): Boolean
    begin
        //-LAN005
        if not LotNoInformation.Get("No.", "Variant Code", BASLotNoPHA) then
            exit(true);
        //+LAN005
    end;

    procedure "Änderungsabfrage"()
    var
        MsgText: Text[250];
    begin


        //-LAN007
        if SpeichernGefragt then
            exit;

        Rec.GetPurchHeader();
        if PurchHeader.BASBestellstatusPHA = PurchHeader.BASBestellstatusPHA::Versendet then begin
            if ("Line No." = 0) then
                MsgText := STRSUBSTNO('Bestellstatus ist %1!. Wollen Sie trotzdem neue Zeilen erfassen?', PurchHeader.BASBestellstatusPHA)
            else
                MsgText := STRSUBSTNO('Bestellstatus ist %1!. Wollen Sie Ihre Änderung trotzdem speichern?', PurchHeader.BASBestellstatusPHA);
        end else
            exit;

        SpeichernGefragt := true;

        if not Confirm(MsgText, true) then
            Error('Änderungen wurden nicht gespeichert');
    end;

    procedure Wertgutschrift()
    var
    begin
        // "Wertkorrektur zu Artikelposten" := 0;
    end;

    procedure BlockeBemerkungsmeldung(newSetzeBemerkungsMeldung: Boolean)
    begin
        BemerkungsmeldungUnterdrücken := newSetzeBemerkungsMeldung;
    end;

    procedure Packungsgroesse() cPackungsgroesse: Text[20]
    var
        recItem: Record Item;
    begin
        if Type = Type::Item then
            if recItem.Get("No.") then
                cPackungsgroesse := recItem.BASPackageSizePHA;
    end;

    procedure LotNoCheck()
    var
        Item2: Record Item;
    begin
        Item2 := GetItem();
        Item2.Get("No.");
        if Item2.BASItemTypePHA in [Item2.BASItemTypePHA::"Row Material", Item2.BASItemTypePHA::"Package Material"] then begin
            LotNoInformation.SetCurrentKey(BASSalesLotNoPHA);
            LotNoInformation.SetRange(BASSalesLotNoPHA, BASLotNoPHA);
            if LotNoInformation.FindFirst() then
                if LotNoInformation."Item No." <> "No." then
                    Error('Rohstoffcharge wurde schon zu anderer Artikelnummer vergeben!');
        end;
    end;

    procedure UrspMenge(PreviousQuantity: Decimal)
    begin

        if ("Document Type" in ["Document Type"::Order, "Document Type"::Invoice, "Document Type"::"Blanket Order"]) and
          (PreviousQuantity <> 0) and (Type = Type::Item) then
            if StrMenu(StrSubstNo('Ursprüngliche Menge auf %1 setzen?', CONVERTSTR(FORMAT(PreviousQuantity), ',', '.')), 1) = 1 then
                BASQuantityPHA := PreviousQuantity;

    end;

    procedure CheckProjektArtikel(ItemNo: Code[20]; JobNo: Code[20])
    begin
        GetItem();
        if (StrLen(ItemNo) > 1) and (StrLen(JobNo) > 1) then
            if Item.Get(ItemNo) then
                if Item."Inventory Value Zero" = false then
                    Error('Eine Projektnummer ist nicht zulässig, wenn ein Artikel mit Lagerwert Bestellt wird!');
    end;


    // ToDo all
    local procedure CheckExpDate()
    // var
    //     iDayHelp: Integer;
    //     iMonHelp: Integer;
    //     tMonHelp: Text[2];
    //     tMonHelpDM: Text[2];
    //     tYearHelp: Text[4];
    //     tYearHelpDM: Text[4];
    begin
        // if ("Expiration Date DM" <> '') then begin
        //     if StrLen("Expiration Date DM") < 6 then
        //         Error('DataMatrix Ablaufdatum muss Format JJMMTT (YYMMDD) haben!');

        //     if Evaluate(iMonHelp, CopyStr("Expiration Date DM", 3, 2)) then begin
        //         if (iMonHelp < 1) or (iMonHelp > 12) then
        //             Error('DataMatrix Ablaufdatum muss Format JJMMTT (YYMMDD) haben!');
        //     end else
        //         Error('DataMatrix Ablaufdatum muss Format JJMMTT (YYMMDD) haben!');

        //     if Evaluate(iDayHelp, CopyStr("Expiration Date DM", 5, 2)) then begin
        //         if (iDayHelp < 0) or (iDayHelp > 31) then
        //             Error('DataMatrix Ablaufdatum muss Format JJMMTT (YYMMDD) haben!');
        //     end else
        //         Error('DataMatrix Ablaufdatum muss Format JJMMTT (YYMMDD) haben!');

        //     if Rec.BASExpirationDateDMPHA <> '' then begin
        //         tYearHelp := FORMAT(DATE2DMY(BASExpirationDateDMPHA, 3));
        //         tYearHelpDM := '20' + CopyStr("Expiration Date DM", 1, 2);
        //         tMonHelp := Codesammlung.TextAuffuellen(FORMAT(DATE2DMY(BASExpirationDateDMPHA, 2)), 2, '0');
        //         tMonHelpDM := CopyStr("Expiration Date DM", 3, 2);
        //         if (tYearHelp <> tYearHelpDM) or (tMonHelp <> tMonHelpDM) then
        //             if not Confirm('DataMatrix Ablaufdatum: %1-%2 weicht von Ablaufdatum: %3-%4 ab. Trotzdem übernehmen?', false, tMonHelp, tYearHelp, tMonHelpDM, tYearHelpDM) then
        //                 Error('Abgebrochen: DataMatrix Ablaufdatum weicht ab!');
        //     end;
        // end;
    end;
}