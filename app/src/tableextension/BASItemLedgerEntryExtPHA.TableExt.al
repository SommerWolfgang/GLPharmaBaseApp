tableextension 50011 BASItemLedgerEntryExtPHA extends "Item Ledger Entry"
{
    fields
    {
        // field(50000; "BASEK-Betrag (tats.)PHA"; Decimal)
        // {
        //     CalcFormula = sum("Value Entry"."EK-Betrag (tats.)" where("Item Ledger Entry No." = field("Entry No.")));
        //     FieldClass = FlowField;

        // }
        // field(50001; "BASEK-Betrag (erw.)PHA"; Decimal)
        // {
        //     CalcFormula = sum("Value Entry"."EK-Betrag (erw.)" where("Item Ledger Entry No." = field("Entry No.")));
        //     FieldClass = FlowField;
        // }
        field(50002; BASLagerplatzpostenPHA; Integer)
        {
            CalcFormula = count("Warehouse Entry" where("Location Code" = field("Location Code"),
                                                         "Item No." = field("Item No."),
                                                         "Variant Code" = field("Variant Code"),
                                                         "Lot No." = field("Lot No.")));
            FieldClass = FlowField;
        }
        field(50003; BASLagerplatzhilfsfeldPHA; Code[20])
        {
        }
        // field(50004; BASChargen_LaetusCodePHA; Text[15])
        // {
        //     CalcFormula = lookup("Lot No. Information"."Laetus-Code" where("Item No." = field("Item No."),
        //                                                                   "Lot No." = field("Lot No.")));
        //     FieldClass = FlowField;
        // }
        field(50500; "BASExterne Rahmennr.PHA"; Code[20])
        {

        }
        field(50501; BASAbrufdatumPHA; Date)
        {

        }
        field(50502; BASTreeViewStatus_TempPHA; Integer)
        {
        }
        field(50503; BASEntwicklungsprojektPHA; Boolean)
        {
            Description = 'MFU';
        }
        field(50506; BASArtikelgruppePHA; Code[10])
        {

            Editable = false;
        }
        field(50507; "BASStatisticCode2PHA IPHA"; Code[10])
        {
            Editable = false;
            TableRelation = BASStatisticcode2PHA where(Level = const(1));
        }
        field(50508; "BASStatisticCode2PHA IIPHA"; Code[10])
        {

            Editable = false;
            TableRelation = BASStatisticcode2PHA where(Level = const(2));
        }
        field(50509; "BASStatisticCode2PHA IIIPHA"; Code[10])
        {

            Editable = false;
            TableRelation = BASStatisticcode2PHA where(Level = const(3));
        }
        // field(50510; BASArtikelStandortHerstellungPHA; Code[20])
        // {
        //     CalcFormula = lookup(Item."Site Manufacturing" where("No." = field("Item No.")));
        //     Description = 'MFU';
        //     FieldClass = FlowField;
        // }
        field(50512; "BASBestellnr.PHA"; Code[20])
        {

        }
        field(50513; BASBestelldatumPHA; Date)
        {

        }
        field(50514; "BASWertgutschriftsnr.PHA"; Code[20])
        {

        }
        field(50515; "Ländercode"; Code[10])
        {

            TableRelation = "Country/Region";
        }
        field(50516; BASNaturalrabattmengePHA; Decimal)
        {
            DecimalPlaces = 0 : 5;

        }
        field(50517; BASVerkaufsBASStatisticCode2PHAPHA; Code[10])
        {

        }
        field(50521; "BASSuchtgift/PsychotropPHA"; Text[1])
        {

        }
        field(50522; "BASVerkaufschargennr.PHA"; Code[20])
        {

        }
        field(50529; "BASUrspr. MengePHA"; Decimal)
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
        field(50553; BASGetFromPHA; Decimal)
        {
            CalcFormula = sum("Item Ledger Entry"."Remaining Quantity" where("Item No." = field("Item No."), "Location Code" = field("Location Code"), Open = const(true)));
            Caption = '', comment = 'DEA="Hole vom"';
            FieldClass = FlowField;
        }
        field(50600; BASCorrectionGLEntryPHA; Decimal)
        {
            Caption = 'Correction G/L Entry', comment = 'DEA="Sachposten Korrektur"';
        }
        field(50601; BASCrMemoCorrectionAmountPHA; Decimal)
        {
            Caption = 'CrMemo Correction Amount', comment = 'DEA="Wertgutschrift Korrekturbetrag"';
        }
        field(50602; BASRUELLagerplatzStandortPHA; Code[20])
        {
            // ToDo -> hardcoded !!!
            CalcFormula = lookup(
                "Warehouse Entry"."Bin Code"
                    where("Location Code" = const('RÜL'),
                        "Item No." = field("Item No."), "Variant Code" = field("Variant Code"), "Lot No." = field("Lot No."),
                            "Registering Date" = field("Posting Date"), "Location Code" = field("Location Code"), Quantity = field(Quantity)));
            FieldClass = FlowField;

        }
        field(50603; "KeineLagerstandÜbernahme"; Boolean)
        {
        }
    }

    procedure GetCostAmount(): Decimal
    begin
        if "Invoiced Quantity" <> 0 then begin
            CalcFields("Cost Amount (Actual)");
            exit("Cost Amount (Actual)" / "Invoiced Quantity");
        end;
    end;

    procedure SetItemLedgerEntryCustomerFilter(var ItemLedgerEntry: Record "Item Ledger Entry")
    var
        SourceNoFilter: Text;
    begin
        SourceNoFilter := ItemLedgerEntry.GetFilter("Source No.");

        if StrLen(SourceNoFilter) > 0 then
            SourceNoFilter += ' & ';
        SourceNoFilter += '< 50004';

        ItemLedgerEntry.SetFilter("Source No.", SourceNoFilter);
    end;
}