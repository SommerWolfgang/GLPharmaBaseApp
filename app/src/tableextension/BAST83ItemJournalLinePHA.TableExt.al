
tableextension 50017 BASItemJournalLinePHA extends "Item Journal Line"
{
    fields
    {
        modify(BASLotNoPHA)
        {
            trigger OnAfterValidate()
            var
                LotNo: code[50];
            begin
                LotNo := xRec.BASLotNoPHA;
                if "Line No." = 0 then
                    LotNo := '';

                if BASLotNoPHA <> LotNo then begin
                    Item.Get("Item No.");
                    if Item."Item Tracking Code" = '' then
                        Error(Text50000);

                    "BASVerkaufschargennr.PHA" := '';
                    "Expiration Date" := 0D;
                    "BASLieferantenchargennr.PHA" := '';

                    DeleteCharge();

                    if BASLotNoPHA <> '' then
                        if not LotNoInformation.Get("Item No.", "Variant Code", BASLotNoPHA) then begin
                            if "Entry Type" in [1, 3, 4, 5] then
                                Error(Text50002, BASLotNoPHA)
                            else
                                if ("Order Type" <> "Order Type"::Production) and ("Order No." = '') then begin
                                    CheckLotNo();
                                    Message(Text50003, BASLotNoPHA);
                                    "BASVerkaufschargennr.PHA" := BASLotNoPHA;
                                    "Expiration Date" := 0D;

                                end;
                        end else begin
                            BASLotNoPHA := LotNoInformation.BASLotNoPHA;
                            ;
                            // ToDo Chargenstamm?
                            // "BASVerkaufschargennr.PHA" := Chargenstamm."BASVerkaufschargennr.PHA";
                            // "Expiration Date" := Chargenstamm."Expiration Date";

                        end;
                end;
            end;
        }
        modify("Expiration Date")
        {
            trigger OnAfterValidate()
            begin

                if (xRec."Expiration Date" <> Rec."Expiration Date") then
                    if (Rec."Entry Type" = Rec."Entry Type"::"Positive Adjmt.") or (Rec."Entry Type" = Rec."Entry Type"::Purchase) then
                        DeleteCharge();
            end;
        }

        modify(Quantity)
        {
            trigger OnBeforeValidate()
            var
                Quantity: Decimal;
            begin
                Quantity := xRec.Quantity;
                if "Line No." = 0 then
                    Quantity := 0;

                if (Quantity <> Quantity) then begin
                    DeleteCharge();

                    if (Rec."Journal Template Name" = 'INVENTUR') and (Rec."Entry Type" = Rec."Entry Type"::"Negative Adjmt.")
                        and (Rec.BASLotNoPHA = '') and (xRec.BASLotNoPHA > '')
                    then
                        Rec.BASLotNoPHA := xRec.BASLotNoPHA;
                end;
            end;
        }
        field(50000; BASLagerstandPHA; Decimal)
        {
            CalcFormula = sum("Item Ledger Entry"."Remaining Quantity" where("Item No." = field("Item No."),
                                                                              "Location Code" = field("Location Code")));
            FieldClass = FlowField;

            trigger OnLookup()
            var
                tempRecItemLedgerEntry: Record 32 temporary;
            begin
                // ToDo -> hardcoded!!!
                if "Journal Template Name" = 'FAVERB' then begin
                    TestField("Item No.");
                    tempRecItemLedgerEntry."Item No." := "Item No.";
                    tempRecItemLedgerEntry.SetRange("Item No.", "Item No.");
                    tempRecItemLedgerEntry.SetRange(Open, true);
                end;
            end;
        }
        field(50001; "Packungsgröße"; Text[10])
        {
            CalcFormula = lookup(Item."Packungsgröße" where("No." = field("Item No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(50002; BASSortierungPHA; Text[30])
        {
        }
        field(50003; BASRegalnummerPHA; Text[30])
        {
            CalcFormula = lookup(Item."Shelf No." where("No." = field("Item No.")));
            FieldClass = FlowField;
        }
        field(50041; "BASUser IDPHA"; Code[50])
        {
        }
        field(50102; "BASCEP NrPHA"; Code[50])
        {
        }
        field(50103; BASHerstellerNrPHA; Code[20])
        {
        }
        field(50500; "BASExterne Rahmennr.PHA"; Code[20])
        {
        }
        field(50501; BASAbrufdatumPHA; Date)
        {
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
        field(50510; "BASBestellnr.PHA"; Code[20])
        {

        }
        field(50511; BASBestelldatumPHA; Date)
        {

        }
        field(50512; "Ländercode"; Code[10])
        {

            TableRelation = "Country/Region";
        }
        field(50513; BASNaturalrabattmengePHA; Decimal)
        {
            DecimalPlaces = 0 : 5;

        }
        field(50514; BASSalesStatisticCode2PHA; Code[10])
        {
        }
        field(50515; "Währungsfaktor"; Decimal)
        {
        }
        field(50524; "BASSuchtgift/PsychotropPHA"; Text[1])
        {
        }
        field(50525; "BASVerkaufschargennr.PHA"; Code[50])
        {
            trigger OnLookup()
            begin
                if "Entry Type" <> "Entry Type"::Output then
                    HoleCharge();
            end;

            trigger OnValidate()
            var
                Item: Record Item;
                vergleich: Code[50];
            begin
                vergleich := xRec."BASVerkaufschargennr.PHA";

                if "Line No." = 0 then
                    vergleich := '';
                if ("BASVerkaufschargennr.PHA" <> vergleich) then begin
                    Item.Get("Item No.");
                    if Item."Item Tracking Code" = '' then begin
                        "BASVerkaufschargennr.PHA" := '';
                        Message('Artikel ist nicht chargenpflichtig!');
                    end;
                end;

                // ToDo -> Cargenstamm?
                // if BASLotNoPHA <> '' then
                //     if not NeueCharge() then
                //         if Chargenstamm."BASVerkaufschargennr.PHA" <> "BASVerkaufschargennr.PHA" then
                //             Error('Bestehende Charge %1 kann nicht verändert werden!', BASLotNoPHA);

                DeleteCharge();
            end;
        }
        field(50528; "BASUrspr. MengePHA"; Decimal)
        {
            DecimalPlaces = 0 : 5;

        }
        field(50550; BASGebindeanzahlPHA; Decimal)
        {
            DecimalPlaces = 0 : 5;

        }
        field(50551; BASGebindeartencodePHA; Code[10])
        {

        }
        field(50552; BASMusterlieferungPHA; Boolean)
        {

        }
        field(50553; "BASHole vonPHA"; Decimal)
        {

            CalcFormula = sum("Item Ledger Entry"."Remaining Quantity" where("Item No." = field("Item No."),
                                                                              "Location Code" = field("Location Code"),
                                                                              Open = const(true)));
            // Caption = 'Hole Von', comment = '"DEA = 'Get from';

            DecimalPlaces = 0 : 5;
            //Editable = false;   //Mit Editable false funktioniert das OnLookup nicht!
            FieldClass = FlowField;


            trigger OnLookup()
            var
                tempRecItemLedgerEntry: Record "Item Ledger Entry" temporary;
                ActionReturn: Action;
            begin

                TestField("Item No.");
                tempRecItemLedgerEntry."Item No." := "Item No.";
                tempRecItemLedgerEntry.SetRange("Item No.", "Item No.");
                tempRecItemLedgerEntry.SetRange(Open, true);
                if "Location Code" <> '' then begin
                    tempRecItemLedgerEntry."Location Code" := "Location Code";
                    tempRecItemLedgerEntry.SetRange("Location Code", "Location Code");
                end;

                ActionReturn := PAGE.RUNMODAL(PAGE::UmlagerInfoNeu, tempRecItemLedgerEntry);
                if (ActionReturn = ACTION::LookupOK) or (ActionReturn = ACTION::OK) then begin
                    "Location Code" := tempRecItemLedgerEntry."Location Code";
                    "Bin Code" := tempRecItemLedgerEntry.Lagerplatzhilfsfeld;

                    if "Entry Type" in ["Entry Type"::Transfer, "Entry Type"::"Negative Adjmt."] then begin
                        if ("Entry Type" = "Entry Type"::"Negative Adjmt.") then
                            Validate(Quantity, tempRecItemLedgerEntry."Remaining Quantity");

                        Validate(BASLotNoPHA, tempRecItemLedgerEntry.BASLotNoPHA);

                        //Wird mit dem Validate der LotNo schon befüllt  "BASVerkaufschargennr.PHA" := tempRecItemLedgerEntry."BASVerkaufschargennr.PHA";
                        if ("Entry Type" = "Entry Type"::Transfer) then
                            Validate(Quantity, tempRecItemLedgerEntry."Remaining Quantity");

                    end;
                end;

            end;

            trigger OnValidate()
            var
                tTest: Text[10];
            begin
                tTest := '';
            end;
        }
        field(50554; "BASLieferantenchargennr.PHA"; Code[20])
        {
            trigger OnValidate()
            begin
                //-LAN004
                if ("Entry Type" <> "Entry Type"::Purchase) and ("Entry Type" <> "Entry Type"::"Positive Adjmt.") then
                    FieldError("Entry Type", 'FEHLENDE VARIABLE T83');
                if BASLotNoPHA <> '' then
                    if not NewCharge() then
                        if LotNoInformation."Lief. Chargennr." <> "Lieferantenchargennr." then //GL023
                            Error('FEHLENDE VARIABLE T83', FieldCaption("Lieferantenchargennr."), BASLotNoPHA);
            end;
        }
        field(50555; BASPackmittelversionPHA; Code[20])
        {


            trigger OnValidate()
            begin
                if ("Entry Type" <> "Entry Type"::Purchase) and ("Entry Type" <> "Entry Type"::"Positive Adjmt.") then
                    FieldError("Entry Type", 'FEHLENDE VARIABLE T83');
                if BASLotNoPHA <> '' then
                    if not NewCharge() then
                        if LotNoInformation.BASPackmittelversionPHA <> BASPackmittelversionPHA then //GL023
                            Error('FEHLENDE VARIABLE T83', FieldCaption(BASPackmittelversionPHA), BASLotNoPHA);
            end;
        }
    }

    var
        Item: Record Item;
        LotNoInformation: Record "Lot No. Information";
    // ToDo
    // LotMgt: Codeunit "50002";
    // cuChargenVerwaltung: Codeunit ChargenverwaltungPageApp;
    procedure DeleteCharge()
    begin
        if "Line No." = 0 then
            exit;

        // cuChargenVerwaltung.LöscheCharge(
        //   DATABASE::"Item Journal Line", "Entry Type", "Journal Template Name", "Journal Batch Name",
        //              0, "Line No.", BASLotNoPHA);
    end;

    // ToDo -> new function
    procedure HoleCharge()
    begin
        //-LAN004
        Item.Get("Item No.");
        if Item."Item Tracking Code" = '' then
            Error('FEHLENDE VARIABLE T83');
        LotNoInformation."Item No." := "Item No.";
        LotNoInformation."Variant Code" := "Variant Code";
        LotNoInformation.BASLotNoPHA := BASLotNoPHA;
        LotNoInformation."Location Filter" := "Location Code";
        LotNoInformation."Bin Filter" := "Bin Code";

        // if LotMgt.Chargenpostenwählen(LotNoInformation) then begin
        //     BASLotNoPHA := LotNoInformation.BASLotNoPHA;
        //     "BASVerkaufschargennr.PHA" := LotNoInformation.."BASVerkaufschargennr.PHA";
        //     "Expiration Date" := LotNoInformation."Expiration Date";
        //     if Item.BASItemTypePHA = Item.BASItemTypePHA::"Finished Product" then
        //         TestField("BASVerkaufschargennr.PHA");
        //     Validate(BASLotNoPHA, LotNoInformation.BASLotNoPHA);
        // end;
    end;

    procedure NewCharge(): Boolean
    begin
        exit(not LotNoInformation.Get("Item No.", "Variant Code", BASLotNoPHA));
    end;

    procedure CheckLotNo()
    var
        Item2: Record Item;
        RowMaterialChargeExistsErr: label 'Rohstoffcharge wurde schon zu anderer Artikelnummer vergeben!', comment = 'DEA="Rohstoffcharge wurde schon zu anderer Artikelnummer vergeben!"';
    begin
        Item2 := getI
        Item.Get("Item No.");
        if Item.BASItemTypePHA in [BASItemTypePHA::"Row Material", BASItemTypePHA::"Package Material"] then begin
            LotNoInformation.SetCurrentKey(BASLotNoPHA);
            LotNoInformation.SetRange(BASLotNoPHA, BASLotNoPHA);
            if LotNoInformation.FindFirst() then
                if LotNoInformation."Item No." <> "Item No." then
                    Error(RowMaterialChargeExistsErr);
        end;
    end;
}