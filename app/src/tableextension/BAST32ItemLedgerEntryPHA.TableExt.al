tableextension 50011 BAST32ItemLedgerEntryPHA extends "Item Ledger Entry"
{ // version NAVW114.31,TODOPBA

    // LAN001 12.11.09 ACPSS LAN1.00
    //   New Fields: ID 50500, 50501, 50506 - 50509, 50512 - 50517, 50521, 50522, 50529, 50550 - 50552, 50600, 50601
    //   Code bei LookUp Chargennr. gelöscht.
    // LAN002 14.12.09 ACPSS LAN1.00
    //   New Key: "Item No.,Lot No."
    // 
    // GL001 Funktion Wiegeposten(), (flowfield würde bei nichtfa-posten fehlmeldungen machen)
    // GL002 Einstandspreis()
    // GL003 SetItemLedgerEntryKundenFilter() (für Page 50070)
    // GL004 Key (Entry Type,Nonstock,Item No.,Posting Date) aktiviert
    // GL005 Key (Document No.,Posting Date) hinzugefügt für R50064
    // 
    // Flowfields EK-Betrag (erw.) und EK-Betrag (tats.): derzeit nicht eingebaut, ev. umstellen auf Standardfelder: Petsch, 10.2.2010
    // 
    // 
    // Datum      | Autor   | Status     | Beschreibung
    // --------------------------------------------------------------------------------------------------------
    // 2010-02-25 | Fuerbass  | ok       | Update von 360
    // --------------------------------------------------------------------------------------------------------
    // 2010-03-24 | Petsch    | ok       | Feld Lagerplatzhilfsfeld für HoleVon-Maske eingebaut, wird nur in Temp-Tabelle befüllt
    //                                     an Key: "Item No.,Lot No.,Open,Positive,Location Code, Lagerplatzhilfsfeld" angehängt
    // --------------------------------------------------------------------------------------------------------
    // 2013-06-19 | Fuerbass  | ok       | Feld Laetus Code Lookub für Maurer eingebaut
    // --------------------------------------------------------------------------------------------------------
    // 2015-10-28 | Fuerbass  | ok       | Feld Entwicklungsprojekt für Buchhaltung eingebaut  (Für Postenausschluss in R50013)
    // --------------------------------------------------------------------------------------------------------
    // 2016-04-29 | Fuerbass  | ok       | Feld VernichtungNachverrechnung für Buchhaltung eingebaut (Erkennung von Vernichtungen die Nachverrechnet wurden)
    // --------------------------------------------------------------------------------------------------------
    // 2017-05-08 | Fuerbass  | ok       | Key für FA-Dispoliste eingebaut
    // --------------------------------------------------------------------------------------------------------
    // 2019-12-10 | Fuerbass  | ok       | Neues FlowField "ArtikelStandortHerstellung" für Bericht Lieferantenstatistic quer
    // --------------------------------------------------------------------------------------------------------
    // 
    // 
    // 
    // 
    // Untenstehende Keys je nach Bedarf einbauen:
    // 
    // Alte Doku
    // Neuer Key: "Location Code,Bin Code,Open"
    // Neuer Key: "Item No.,Lot No.,Open,Positive,Location Code, Bin Code"
    // 2004-08-30 | Petsch  | ok         | Key: "Item No.,Lot No.,Open,Positive,Location Code, um "Bin Code" erweitert für Umlag.Info
    // Key "Source Type,Source No.,Entry Type,Item No.,Variant Code,Posting Date" Enable = JA
    // Neuer Key: "Item No., Lot No., Posting Date"
    // Neues Feld: "TreeViewStatus_Temp" für Umlagerinfo Baumansicht
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
            Description = 'LAN1.00';
        }
        field(50501; BASAbrufdatumPHA; Date)
        {
            Description = 'LAN1.00';
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
            Description = 'LAN1.00';
            Editable = false;
        }
        field(50507; "BASStatistikcode IPHA"; Code[10])
        {
            Editable = false;
            TableRelation = BASStatisticcode2PHA where(Level = const(1));
        }
        field(50508; "BASStatistikcode IIPHA"; Code[10])
        {
            Description = 'LAN1.00';
            Editable = false;
            TableRelation = BASStatisticcode2PHA where(Level = const(2));
        }
        field(50509; "BASStatistikcode IIIPHA"; Code[10])
        {
            Description = 'LAN1.00';
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
            Description = 'LAN1.00';
        }
        field(50513; BASBestelldatumPHA; Date)
        {
            Description = 'LAN1.00';
        }
        field(50514; "BASWertgutschriftsnr.PHA"; Code[20])
        {
            Description = 'LAN1.00';
        }
        field(50515; "Ländercode"; Code[10])
        {
            Description = 'LAN1.00';
            TableRelation = "Country/Region";
        }
        field(50516; BASNaturalrabattmengePHA; Decimal)
        {
            DecimalPlaces = 0 : 5;
            Description = 'LAN1.00';
        }
        field(50517; BASVerkaufsstatistikcodePHA; Code[10])
        {
            Description = 'LAN1.00';
        }
        field(50521; "BASSuchtgift/PsychotropPHA"; Text[1])
        {
            Description = 'LAN1.00';
        }
        field(50522; "BASVerkaufschargennr.PHA"; Code[20])
        {
            Description = 'LAN1.00';
        }
        field(50529; "BASUrspr. MengePHA"; Decimal)
        {
            DecimalPlaces = 0 : 5;
            Description = 'LAN1.00';
        }
        field(50550; BASGebindeanzahlPHA; Decimal)
        {
            DecimalPlaces = 0 : 5;
            Description = 'LAN1.00';
        }
        field(50551; BASGebindeartencodePHA; Code[10])
        {
            Description = 'LAN1.00';
        }
        field(50552; BASMusterlieferungPHA; Boolean)
        {
            Description = 'LAN1.00';
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