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
            var
                Chargenstamm: Record "Lot No. Information";
            begin
                //-LAN005
                Chargenstamm.SetRange("Item No.", "No.");
                Chargenstamm.SetRange("Variant Code", "Variant Code");
                Chargenstamm.SetRange("Lot No.", "Lot No.");
                if Chargenstamm.FINDFIRST() then begin
                    Packmittelversion := Chargenstamm.Packmittelversion;
                    MESSAGE('Keine Textvariable T39', "No.", FieldCaption(Packmittelversion), Packmittelversion);
                end;

                Validate("Lot No.");
                //+LAN005
            end;
        }
        field(50002; "DruckUnterlagenPrüfung"; Option)
        {

            OptionMembers = " ",offen,erledigt;
        }
        field(50003; "Einkäufercode"; Code[20])
        {
            CalcFormula = lookup("Purchase Header"."Purchaser Code" where("Document Type" = field("Document Type"),
                                                                           "No." = field("Document No.")));
            FieldClass = FlowField;
        }
        field(50004; BASBestelldatumPHA; Date)
        {
            CalcFormula = lookup("Purchase Header"."Order Date" where("Document Type" = field("Document Type"),
                                                                       "No." = field("Document No.")));
            FieldClass = FlowField;
        }
        field(50005; BASHerstellerNrPHA; Code[20])
        {

        }
        field(50006; "BASCEP NrPHA"; Code[50])
        {

        }
        field(50010; "BASLot No.PHA"; Code[20])
        {
            Caption = 'Lot No.';

            TableRelation = if (Type = const(Item)) "Lot No. Information"."Lot No." where("Item No." = field("No."),
                                                                                         "Variant Code" = field("Variant Code"));
            ValidateTableRelation = false;
        }
        field(50500; "BASOff. Gesamtmenge in BestellungPHA"; Decimal)
        {
            CalcFormula = sum("Purchase Line"."Outstanding Qty. (Base)" where("Document Type" = const("Order"),
                                                                               Type = const(Item),
                                                                               "No." = field("No.")));
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
            TableRelation = BASStatisticCode2PHA where(Level = const(1));
        }
        field(50508; "BASStatisticCode2PHA IIPHA"; Code[10])
        {

            Editable = false;
            TableRelation = BASStatisticCode2PHA where(Level = const(2));
        }
        field(50509; "BASStatisticCode2PHA IIIPHA"; Code[10])
        {

            Editable = false;
            TableRelation = BASStatisticCode2PHA where(Level = const(3));
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


            trigger OnValidate()
            var
                Chargenstamm: Record "6505";
                Artikel: Record Item;
            begin
            end;
        }
        field(50528; "BASVerkaufschargennr.PHA"; Code[20])
        {


            trigger OnValidate()
            var
                Chargenstamm: Record "6505";
                Artikel: Record Item;
            begin
                //-LAN005
                Artikel.Get("No.");
                Chargenstamm.SetRange("Item No.", "No.");
                Chargenstamm.SetRange("Variant Code", "Variant Code");
                Chargenstamm.SetRange("Lot No.", "Lot No.");
                if Chargenstamm.FINDFIRST() then begin
                    "Verkaufschargennr." := Chargenstamm."Verkaufschargennr.";
                    MESSAGE('KEINE TEXTVARIABLE T39', "No.", FieldCaption("Verkaufschargennr."), "Verkaufschargennr.");
                end;

                Validate("Lot No.");
                //+LAN005
            end;
        }
        field(50529; "BASUrspr. MengePHA"; Decimal)
        {
            DecimalPlaces = 0 : 5;

        }
        field(50530; "BASExpiration DatePHA"; Date)
        {
            Caption = 'Expiration Date';


            trigger OnValidate()
            var
                chargenstamm: Record "6505";
                artikel: Record Item;
            begin


                artikel.Get("No.");
                chargenstamm.SetRange("Item No.", "No.");
                chargenstamm.SetRange("Variant Code", "Variant Code");
                chargenstamm.SetRange("Lot No.", "Lot No.");
                if chargenstamm.FINDFIRST() then begin
                    "Expiration Date" := chargenstamm."Expiration Date";
                    MESSAGE('KEINE TEXTVARIABLE T39', "No.", FieldCaption("Expiration Date"), "Expiration Date");
                end;

                Validate("Lot No.");

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
        field(50583; "BASWertkorrektur zu ArtikelpostenPHA"; Integer)
        {

        }
        field(50584; "BASZuordnung zu Artikelnr.PHA"; Code[20])
        {

            TableRelation = Item;

            trigger OnValidate()
            begin
                //-LAN010
                "Wertkorrektur zu Artikelposten" := 0;
                Wertgutschrift();
                //+LAN010
            end;
        }
        field(50585; BASBeschreibungLangPHA; BLOB)
        {
            Description = 'MFU';
        }

        field(50587; "BASExpiration Date DMPHA"; Text[6])
        {
            Description = 'GL015,EUHUB';
            Numeric = true;
            Width = 6;

            trigger OnValidate()
            begin
                CheckExpDate(); //GL015
            end;
        }
    }
    var
        Chargenstamm: Record "Lot No. Information";
        PurchHeader: Record "Purchase Header";
        Codesammlung: Codeunit "50000";
        cuNaviPharma: Codeunit "50001";
        LotMgt: Codeunit "50002";
        "BemerkungsmeldungUnterdrücken": Boolean;
        bFFAAactive: Boolean;
        SpeichernGefragt: Boolean;

    procedure FaktMengeCharge()
    begin
        if "Line No." = 0 then
            exit;
        if "Lot No." = '' then
            exit;
        if Type <> Type::Item then
            exit;
        if "No." = '' then
            exit;

        LotMgt.FaktMengeCharge(
          DATABASE::"Purchase Line", "Document Type", "Document No.", '', 0, "Line No.", "Lot No.", "Qty. to Invoice (Base)");
    end;

    procedure LiefMengeCharge()
    var
        CurrentSignFactor: Integer;
    begin
        //-LAN005
        if "Line No." = 0 then
            exit;
        if "Lot No." = '' then
            exit;
        if Type <> Type::Item then
            exit;
        if "No." = '' then
            exit;

        LotMgt.LiefMengeCharge(
          DATABASE::"Purchase Line", "Document Type", "Document No.", '', 0, "Line No.", "Lot No.", "Qty. to Receive (Base)");
        //+LAN005
    end;

    procedure HoleCharge()
    begin
    end;

    procedure NeueCharge(): Boolean
    begin
        //-LAN005
        if not Chargenstamm.Get("No.", "Variant Code", "Lot No.") then
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
        if PurchHeader.Bestellstatus = PurchHeader.Bestellstatus::Versendet then begin
            if ("Line No." = 0) then
                MsgText := STRSUBSTNO('Bestellstatus ist %1!. Wollen Sie trotzdem neue Zeilen erfassen?', PurchHeader.Bestellstatus)
            else
                MsgText := STRSUBSTNO('Bestellstatus ist %1!. Wollen Sie Ihre Änderung trotzdem speichern?', PurchHeader.Bestellstatus);
        end else
            exit;

        SpeichernGefragt := true;

        if not CONFIRM(MsgText, true) then
            Error('Änderungen wurden nicht gespeichert');
        //+LAN007
    end;

    procedure Wertgutschrift()
    var
        localRecItem: Record Item;
        localRecPurchaseLine: Record "Purchase Line";
    begin

        "Wertkorrektur zu Artikelposten" := 0;


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
                cPackungsgroesse := recItem."Packungsgröße";
    end;

    procedure LotNoCheck()
    var
        recLotNoInfo: Record "6505";
        recItem: Record Item;
    begin

        recItem.Get("No.");
        if recItem.Artikelart in [recItem.Artikelart::Rohstoff, recItem.Artikelart::Verpackungsstoff] then begin
            recLotNoInfo.SetCurrentKey("Lot No.");
            recLotNoInfo.SetRange("Lot No.", "Lot No.");
            if recLotNoInfo.FINDFIRST() then
                if recLotNoInfo."Item No." <> "No." then
                    Error('Rohstoffcharge wurde schon zu anderer Artikelnummer vergeben!');
        end;

    end;

    procedure UrspMenge(nMengeBisher: Decimal)
    begin

        if ("Document Type" in ["Document Type"::Order, "Document Type"::Invoice, "Document Type"::"Blanket Order"]) and
          (nMengeBisher <> 0) and (Type = Type::Item) then begin

            if STRMENU(STRSUBSTNO('Ursprüngliche Menge auf %1 setzen?', CONVERTSTR(FORMAT(nMengeBisher), ',', '.')), 1) = 1 then
                "Urspr. Menge" := nMengeBisher;

        end;
    end;

    procedure CheckProjektArtikel(cItemNo: Code[20]; cJobNo: Code[20])
    var
        recItem: Record Item;
    begin

        if (STRLEN(cItemNo) > 1) and (STRLEN(cJobNo) > 1) then
            if recItem.Get(cItemNo) then
                if recItem."Inventory Value Zero" = false then
                    Error('Eine Projektnummer ist nicht zulässig, wenn ein Artikel mit Lagerwert Bestellt wird!');
    end;


    local procedure CheckExpDate()
    var
        iDayHelp: Integer;
        iMonHelp: Integer;
        tMonHelp: Text[2];
        tMonHelpDM: Text[2];
        tYearHelp: Text[4];
        tYearHelpDM: Text[4];
    begin
        //-GL015
        if ("Expiration Date DM" <> '') then begin
            if STRLEN("Expiration Date DM") < 6 then
                Error('DataMatrix Ablaufdatum muss Format JJMMTT (YYMMDD) haben!');

            if EVALUATE(iMonHelp, CopyStr("Expiration Date DM", 3, 2)) then begin
                if (iMonHelp < 1) or (iMonHelp > 12) then
                    Error('DataMatrix Ablaufdatum muss Format JJMMTT (YYMMDD) haben!');
            end else
                Error('DataMatrix Ablaufdatum muss Format JJMMTT (YYMMDD) haben!');

            if EVALUATE(iDayHelp, CopyStr("Expiration Date DM", 5, 2)) then begin
                if (iDayHelp < 0) or (iDayHelp > 31) then
                    Error('DataMatrix Ablaufdatum muss Format JJMMTT (YYMMDD) haben!');
            end else
                Error('DataMatrix Ablaufdatum muss Format JJMMTT (YYMMDD) haben!');

            if ("Expiration Date" <> 0D) then begin
                tYearHelp := FORMAT(DATE2DMY("Expiration Date", 3));
                tYearHelpDM := '20' + CopyStr("Expiration Date DM", 1, 2);
                tMonHelp := Codesammlung.TextAuffuellen(FORMAT(DATE2DMY("Expiration Date", 2)), 2, '0');
                tMonHelpDM := CopyStr("Expiration Date DM", 3, 2);
                if (tYearHelp <> tYearHelpDM) or (tMonHelp <> tMonHelpDM) then
                    if not CONFIRM('DataMatrix Ablaufdatum: %1-%2 weicht von Ablaufdatum: %3-%4 ab. Trotzdem übernehmen?', false, tMonHelp, tYearHelp, tMonHelpDM, tYearHelpDM) then
                        Error('Abgebrochen: DataMatrix Ablaufdatum weicht ab!');
            end;
        end;
        //+GL015
    end;
}



