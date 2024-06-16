tableextension 50009 BASItemExtPHA extends Item
{
    fields
    {
        field(50000; "Schrumpfgröße"; Decimal)
        {
            DecimalPlaces = 0 : 3;

        }
        field(50001; "BASJod-grammPHA"; Decimal)
        {

        }
        field(50002; "BASJod-mlPHA"; Decimal)
        {

        }
        field(50003; "BASModified byPHA"; Code[50])
        {
            Caption = 'Modified by';

            Editable = false;
        }
        field(50004; BASKreditornamePHA; Text[100])
        {
            CalcFormula = lookup(Vendor.Name where("No." = field("Vendor No.")));
            Caption = 'Vendor Name';

            FieldClass = FlowField;

        }
        field(50005; BASAnlieferlagerPHA; Code[10])
        {

            TableRelation = Location;
        }
        // field(50006; BASAnlieferlagerplatzPHA; Code[20])
        // {
        //     
        //     TableRelation = Bin.Code where("Location Code" = field(Anlieferlager));
        // }
        field(50007; "BASAnzahl je TrayPHA"; Decimal)
        {
            DecimalPlaces = 0 : 3;

        }
        field(50008; "BASAnzahl je KartonPHA"; Decimal)
        {
            DecimalPlaces = 0 : 3;

        }
        field(50009; BASLagerungsartPHA; Code[20])
        {

        }
        field(50010; BASLogistikbewertungPHA; Code[10])
        {

        }
        field(50011; "BASAnzahl je GitterboxPHA"; Decimal)
        {
            DecimalPlaces = 0 : 3;

        }
        field(50012; BASBetriebskennzeichenPHA; Code[10])
        {

        }
        field(50013; BASDruckFreigabePflichtigPHA; Boolean)
        {

        }
        field(50014; "BASARA-KennzeichenPHA"; Code[10])
        {

        }
        field(50015; "BASBeigestellt Artikel Nr.PHA"; Code[20])
        {

            TableRelation = "Item" where("No." = field("No."));
        }
        field(50016; "BASBeigestellt MengePHA"; Decimal)
        {
            DecimalPlaces = 8 : 8;

        }
        field(50017; BASlengthPHA; Decimal)
        {
            Caption = 'Length';

        }
        field(50018; BASwidthPHA; Decimal)
        {
            Caption = 'width';

        }
        field(50019; BASheightPHA; Decimal)
        {
            Caption = 'Height';

        }
        field(50020; BAScolorPHA; Text[30])
        {
            Caption = 'Color';

        }
        field(50021; "Trayhöhe"; Decimal)
        {

        }
        field(50022; "Länge-Umverpackung"; Decimal)
        {

        }
        field(50023; "BASBreite-UmverpackungPHA"; Decimal)
        {

        }
        field(50024; "Höhe-Umverpackung"; Decimal)
        {

        }
        field(50025; BASAblaufdatumformatPHA; Text[60])
        {

        }
        field(50026; "BASEinstandspreis (neuester)PHA"; Decimal)
        {

        }
        field(50027; "BASKlischee Nr.PHA"; Text[30])
        {

        }
        field(50028; BASFertigungsformatPHA; Code[10])
        {

        }
        field(50029; BASKalkulationszusatz1PHA; Text[40])
        {

        }
        field(50030; BASKalkulationszusatz1WertPHA; Decimal)
        {
            DecimalPlaces = 2 : 6;

        }
        field(50031; BASKalkulationszusatz2PHA; Text[40])
        {

        }
        field(50032; BASKalkulationszusatz2WertPHA; Decimal)
        {
            DecimalPlaces = 2 : 6;

        }
        field(50033; BASKalkulationszusatz3PHA; Text[40])
        {

        }
        field(50034; BASKalkulationszusatz3WertPHA; Decimal)
        {
            DecimalPlaces = 2 : 6;

        }
        field(50035; "Kalkulationszusatz1Übernahme"; Boolean)
        {

        }
        field(50036; BASKalkIncludeItemItselfPHA; Boolean)
        {

        }
        field(50037; BASForceConcentrationPHA; Boolean)
        {
            Caption = 'Wirkstoffgehalt notwendig';

        }
        field(50038; BASEntrySumPHA; Integer)
        {
            CalcFormula = count("Item Ledger Entry" where("Item No." = field("No.")));
            FieldClass = FlowField;
        }
        field(50039; BASSimulationWorkPlanNoPHA; Code[20])
        {
            TableRelation = "Routing Header";
        }
        field(50040; BASSimulationAssemblyNoPHA; Code[20])
        {
            TableRelation = "Production BOM Header";
        }
        field(50041; BASSimulationLotSizePHA; Decimal)
        {
            DecimalPlaces = 0 : 5;
            MinValue = 0;
        }
        field(50042; "BASSimulation-Schwund %PHA"; Decimal)
        {
        }
        field(50043; "BASVKChargennr nicht berechnenPHA"; Boolean)
        {
        }
        field(50044; BASWirkstoffPHA; Text[50])
        {
        }
        field(50045; BASArtikel_Hersteller_AnlegenPHA; Boolean)
        {

        }
        field(50046; "BASBestellmenge aus RahmenPHA"; Decimal)
        {
            CalcFormula = sum("Purchase Line"."Outstanding Qty. (Base)" where("Document Type" = const(Order),
                                                                               Type = const(Item),
                                                                               "No." = field("No."),
                                                                               "Shortcut Dimension 1 Code" = field("Global Dimension 1 Filter"),
                                                                               "Shortcut Dimension 2 Code" = field("Global Dimension 2 Filter"),
                                                                               "Location Code" = field("Location Filter"),
                                                                               "Drop Shipment" = field("Drop Shipment Filter"),
                                                                               "Variant Code" = field("Variant Filter"),
                                                                               "Expected Receipt Date" = field("Date Filter"),
                                                                               "Blanket Order No." = filter(> '')));
            Caption = 'Qty. on Purch. Order';
            DecimalPlaces = 0 : 5;
            Editable = false;
            FieldClass = FlowField;

        }
        field(50048; BASTablettenformPHA; Option)
        {
            OptionMembers = " ",rund,oblong,oval,kapsel,"kapselförmig",eliptisch;
        }
        field(50049; "BASMindestrestlaufzeit %PHA"; Integer)
        {
        }
        field(50050; BASSerialisierungVorhandenPHA; Boolean)
        {
            FieldClass = FlowField;


        }
        field(50051; "BASAnzahl je TrommelPHA"; Decimal)
        {
            DecimalPlaces = 0 : 3;

        }
        field(50052; "BASPatentschutz bisPHA"; Date)
        {

        }
        field(50053; "Vermarktungsexklusivität bis"; Date)
        {

        }
        field(50054; "Protokoll-Änderung vorgesehen"; Boolean)
        {

        }
        field(50055; BASProbendurchlaufzeitPHA; DateFormula)
        {

        }
        field(50056; BASAnlagedatumPHA; Date)
        {
        }
        field(50057; BASInNAVBCUebernommenPHA; Boolean)
        {

        }
        field(50075; BASLIMS_VollerProbenumfangPHA; Boolean)
        {
        }
        field(50200; "BASRegdat ConnectionPHA"; Boolean)
        {
        }
        field(50500; BASPharmaCentralNoPHA; Code[20])
        {
        }
        field(50501; BASHaltbarkeitsinfoPHA; Code[4])
        {
            DateFormula = true;

        }
        field(50502; BASDescription1ByEPPHA; Text[150])
        {
            Caption = 'Description 1 by EP', comment = 'DEA="Beschreibung 1 lt. Arzneibuch"';
        }
        field(50503; BASDescription2ByEPPHA; Text[150])
        {
            Caption = 'Description 2 by EP', comment = 'DEA="Beschreibung 2 lt. Arzneibuch"';
        }
        field(50504; BASDrugPHA; Boolean)
        {
            Caption = 'Drug', comment = 'DEA="Suchgift"';
            trigger OnValidate()
            begin
                BASPsychotroperStoffPHA := BASDrugBasePHA <> 0;
            end;
        }
        field(50505; BASPsychotroperStoffPHA; Boolean)
        {
            trigger OnValidate()
            begin
                BASDrugPHA := not BASPsychotroperStoffPHA;
            end;
        }
        field(50506; BASStatisticCodeGroupPHA; Code[10])
        {
        }
        field(50507; BASStatisticCodeIPHA; Code[10])
        {
            TableRelation = BASStatisticcodePHA.Code where(Level = const(1));
        }
        field(50508; BASStatisticCodeIIPHA; Code[10])
        {
            TableRelation = BASStatisticcodePHA.Code where(Level = const(2));
        }
        field(50509; BASStatisticCodeIIIPHA; Code[10])
        {
            TableRelation = BASStatisticcodePHA.Code where(Level = const(3));
        }
        field(50510; BASInventurbewertungPHA; Decimal)
        {

        }
        field(50511; "BASCountry/Region CodePHA"; Code[10])
        {
            Caption = 'Country/Region Code';

            TableRelation = "Country/Region";
        }
        field(50512; BASPackageSizePHA; Text[10])
        {
            Caption = 'Packing size';
        }
        field(50513; BASEANCodePHA; Text[13])
        {
        }
        field(50514; BASLaetusCodePHA; Text[10])
        {
        }
        field(50515; BASSchwund_BeschreibungPHA; Text[50])
        {
            Caption = 'Schwund Beschreibung';

        }
        field(50516; BASItemTypePHA; enum BASItemTypePHA)
        {
            Caption = 'Item type';

            trigger OnValidate()
            var
                Text50000: Label 'Achtung!\Die BASItemTypePHA hat Auswirkung auf Chargenerstellung und Kommissionierung!\Ist die Festlegung von BASItemTypePHA %1 korrekt?';
            begin
                //-LAN001
                if xRec.BASItemTypePHA = BASItemTypePHA then
                    exit;

                if not Confirm(Text50000, false, BASItemTypePHA) then
                    BASItemTypePHA := xRec.BASItemTypePHA;
                //+LAN001
            end;
        }
        field(50517; BASSonderkonditionengruppePHA; Code[10])
        {

        }
        field(50518; BASItemVendorShipMethodCodePHA; Code[10])
        {
            TableRelation = "Shipment Method";
        }
        field(50520; "BASMatGemeinkosten%7EPPHA"; Decimal)
        {
        }
        field(50521; BASItemVendPaymentTermsCodePHA; Code[10])
        {
            TableRelation = "Payment Terms";
        }
        field(50522; BASVollkostenPHA; Decimal)
        {

        }
        field(50523; BASAmountBlanketOrderPHA; Decimal)
        {
            CalcFormula = sum("Purchase Line"."Outstanding Qty. (Base)"
                where("Document Type" = const("Blanket Order"), Type = const(Item),
                    "No." = field("No."), "Shortcut Dimension 1 Code" = field("Global Dimension 1 Filter")));
            FieldClass = FlowField;
        }
        field(50524; BASVollkosten2000PHA; Decimal)
        {
        }
        field(50525; BASDrugNoPHA; Code[20])
        {
            Caption = 'Drug No.', comment = 'DEA="Suchtgift Nr."';
        }
        field(50526; BASSuchtgiftgehaltPHA; Decimal)
        {
            DecimalPlaces = 0 : 5;
        }
        field(50527; BASDrugBasePHA; Decimal)
        {
            DecimalPlaces = 0 : 5;
        }
        field(50528; "BASMat.-Gemeinkosten %PHA"; Decimal)
        {
            DecimalPlaces = 0 : 5;
        }
        field(50529; "BASPreis f. KalkulationPHA"; Decimal)
        {
        }
        field(50530; "Lösungsmittel"; Boolean)
        {
        }
        field(50531; BASDurchschnittsgehaltPHA; Decimal)
        {
        }
        field(50532; "BASSchwund %PHA"; Decimal)
        {
            DecimalPlaces = 0 : 5;
        }
        field(50533; "Güterlistencode"; Code[20])
        {
        }
        field(50534; "BASMat.-Gemeinkosten % 2PHA"; Decimal)
        {
            DecimalPlaces = 0 : 5;
        }
        field(50535; "Nicht prüfpflichtig"; Boolean)
        {

        }
        field(50536; "Überfüllung %"; Decimal)
        {

        }
        field(50537; "Als Unterstufe nicht prüfen"; Boolean)
        {

        }
        field(50538; BASKalkFloorPreisPHA; Decimal)
        {

        }
        field(50539; BASKalkProzentZuFAPPHA; Decimal)
        {

        }
        field(50541; "BASNumber of UnitsPHA"; Integer)
        {

        }
        field(50542; "BASContents of UnitPHA"; Integer)
        {

        }
        field(50543; "BASMeasure of ContentsPHA"; Code[10])
        {

            TableRelation = "Unit of Measure".Code;
        }
        field(50544; BASConcentrationPHA; Decimal)
        {
            DecimalPlaces = 0 : 5;

        }
        field(50545; "BASMeasure of ConcentrationPHA"; Code[10])
        {

            TableRelation = "Unit of Measure".Code;
        }
        field(50546; BASShapePHA; Code[10])
        {


        }
        field(50547; BASKalkProzentZuFertigArtikelFAPPHA; Decimal)
        {

        }
        field(50549; "BASProduct Type CodePHA"; Code[15])
        {
            Caption = 'Produktart Code';


        }
        field(50550; "BASGewicht VP KartonPHA"; Decimal)
        {
            DecimalPlaces = 5 : 5;

        }
        field(50551; "BASGewicht VP Kunststoffhohlk.PHA"; Decimal)
        {
            DecimalPlaces = 5 : 5;

        }
        field(50552; BASWeightVPPlasticSheetPHA; Decimal)
        {
            Caption = 'Weight VP Plastic Sheet', comment = 'DEA="Gewicht VP Kunststofffolie"';
            DecimalPlaces = 5 : 5;
        }
        field(50553; BASWeightVPMetalicPHA; Decimal)
        {
            Caption = 'Weight VP Metalic', comment = 'DEA="Gewicht VP Metall"';
            DecimalPlaces = 5 : 5;
        }
        // ToDo hardcoded!!! Source No.
        // field(50554; "BASSales (Qty.) Deb FilterPHA"; Decimal)
        // {
        //     CalcFormula = - sum("Item Ledger Entry"."Invoiced Quantity" where("Entry Type" = const(Sale),
        //                                                                       "Item No." = field("No."),
        //                                                                       "Global Dimension 1 Code" = field("Global Dimension 1 Filter"),
        //                                                                       "Global Dimension 2 Code" = field("Global Dimension 2 Filter"),
        //                                                                       "Location Code" = field("Location Filter"),
        //                                                                       "Drop Shipment" = field("Drop Shipment Filter"),
        //                                                                       "Variant Code" = field("Variant Filter"),
        //                                                                       "Posting Date" = field("Date Filter"),
        //                                                                       BASLotNoPHA = field("Lot No. Filter"),
        //                                                                       "Serial No." = field("Serial No. Filter"),
        //                                                                       "Source No." = filter(< 50004)));
        //     Caption = 'Verkauf (Menge) Kunden Filter';
        //     
        //     FieldClass = FlowField;
        // }
        field(50555; "BASSales (LCY) Deb FilterPHA"; Decimal)
        {
            CalcFormula = sum("Value Entry"."Sales Amount (Actual)" where("Item Ledger Entry Type" = const(Sale),
                                                                           "Item No." = field("No."),
                                                                           "Global Dimension 1 Code" = field("Global Dimension 1 Filter"),
                                                                           "Global Dimension 2 Code" = field("Global Dimension 2 Filter"),
                                                                           "Location Code" = field("Location Filter"),
                                                                            "Drop Shipment" = field("Drop Shipment Filter"),
                                                                            "Variant Code" = field("Variant Filter"),
                                                                            "Posting Date" = field("Date Filter"),
                                                                            "Source No." = filter(< 50004)));
            Caption = 'Verkauf (MW) Kunden Filter';

            FieldClass = FlowField;

        }
        field(50556; BASKalkPreisFuerTransportPHA; Decimal)
        {

        }
        field(50559; BASSiteAssignmentPHA; Code[20])
        {
            Caption = 'Standort Zuordnung';
        }
        field(50560; "BASManufacturing AreaPHA"; Code[20])
        {
            Caption = 'Herstellungsbereich';
        }
        field(50561; BASSiteManufacturingPHA; Code[20])
        {
            Caption = 'Site Manufacturing', comment = 'DEA="Standort Herstellung"';
        }
        field(50562; BASSiteBatchReleasePHA; Code[20])
        {
            Caption = 'Standort Freigabe';
        }
        field(50563; BASSiteAnalysesPHA; Code[20])
        {
            Caption = 'Standort Analysen';
        }
        field(50564; BASSiteSamplesPHA; Code[20])
        {
            Caption = 'Standort Rückstellmuster';
        }
        field(50565; BASSiteStabilitiesPHA; Code[20])
        {
            Caption = 'Standort Stabilitäten';
        }
        field(50566; BASRegistrationCompanyPHA; Code[20])
        {
            Caption = 'Zulassungsinhaber';
        }
        field(50567; BASManufacturingForPHA; Code[20])
        {
            Caption = 'Contract Manufacturing for';

        }
        field(50568; BASTypeForecastPHA; Option)
        {
            FieldClass = FlowFilter;
            OptionMembers = " ",Verkauf,Kolo,Muster,Planungsauftrag,Forecast;
        }
        field(50569; BASStorageConditionPHA; Option)
        {
            Caption = 'Lagerbedingung';

            OptionMembers = " ",Raum,"Kühl";
        }
        field(50570; BASOhneSchwundBerechnungPHA; Boolean)
        {
        }
        field(50571; BASVerkehrszweigPHA; Code[10])
        {

            TableRelation = "Transport Method".Code;
        }

        field(65800; "Übertrag Suchtgiftliste"; Decimal)
        {

            Editable = false;
        }
        field(65801; BASSeiteDrugListPHA; Integer)
        {
            Editable = false;
        }
    }
    keys
    {
        key(Key17; BASPharmaCentralNoPHA)
        {
        }
        key(Key18; BASItemTypePHA, BASStatisticCodeIPHA, BASStatisticCodeIIPHA, BASStatisticCodeIIIPHA)
        {
        }
    }

    var

    var
        SalesPrice: Record "Sales Price";

    procedure LagerstandVorOrt(itemno: Code[20]) lagerstand: Decimal
    var
        item: Record Item;
        ManufacturingSetup: Record "Manufacturing Setup";
    begin
        if item.Get(itemno) then begin
            if ManufacturingSetup.Get(item.BASSiteManufacturingPHA) then;
            // item.SetFilter("Location Filter", ManufacturingSetup."Lagerbestand vor Ort Filter");
            item.CalcFields(item.Inventory);
            lagerstand := item.Inventory;
        end;
    end;

    procedure LagerstandLannach(itemno: Code[20]) lagerstand: Decimal
    var
        Item: Record Item;
        recManufacturingSetup: Record "Manufacturing Setup";
    begin
        //-GL001
        if Item.Get(itemno) then begin
            if recManufacturingSetup.Get('LANNACH') then;
            // Item.SetFilter("Location Filter", recManufacturingSetup."Lagerbestand vor Ort Filter");
            Item.CalcFields(Item.Inventory);
            lagerstand := Item.Inventory;
        end;
        //+GL001
    end;

    // ToDo -> one function for all functions !!!!!!!!!!!!!!!!!!!!!!!
    // ToDo -> complete redesign all over the code 
    procedure InventoryVienna(itemNo: Code[20]): Decimal
    var
        Item: Record Item;
        ManufacturingSetup: Record "Manufacturing Setup";
    begin
        if Item.Get(itemNo) then begin
            if ManufacturingSetup.Get('WIEN') then;
            // Item.SetFilter("Location Filter", recManufacturingSetup."Lagerbestand vor Ort Filter");
            Item.CalcFields(Item.Inventory);
            exit(Item.Inventory);
        end;
    end;

    procedure HK(ItemNo: Code[20]): Decimal
    begin
        // ToDo -> hardcoded!!!
        SalesPrice.SetFilter("Item No.", ItemNo);
        SalesPrice.SetRange("Sales Type", SalesPrice."Sales Type"::"Customer Price Group");
        SalesPrice.SetFilter("Sales Code", '9HK');
        SalesPrice.SetRange("Currency Code", '');
        if FindLast() then
            exit(SalesPrice."Unit Price");
    end;

    procedure FAP(artikelnummer: Code[20]): Decimal
    var
        CurrencyExchangeRate: Record "Currency Exchange Rate";
        UnitPrice: Decimal;
    begin
        SalesPrice.SetFilter("Item No.", artikelnummer);
        SalesPrice.SetRange("Sales Type", SalesPrice."Sales Type"::"Customer Price Group");
        SalesPrice.SetFilter("Sales Code", '1FAP');
        SalesPrice.SetFilter("Starting Date", '..' + Format(TODAY));
        SalesPrice.SetFilter("Ending Date", '(' + Format(TODAY) + '..)|''''');
        if SalesPrice.FindLast() then
            SalesPrice.SetRange("Starting Date", SalesPrice."Starting Date");

        if SalesPrice.FindLast() then
            if SalesPrice.Count = 1 then begin
                UnitPrice := SalesPrice."Unit Price";

                if SalesPrice."Currency Code" <> '' then begin
                    CurrencyExchangeRate.Reset();
                    CurrencyExchangeRate.SetRange("Currency Code", SalesPrice."Currency Code");
                    if CurrencyExchangeRate.FindLast() then
                        UnitPrice := Round("Unit Price" / CurrencyExchangeRate."Exchange Rate Amount", 0.00001);
                end;
            end;
        exit(UnitPrice);
    end;

    procedure GetStatisticCode(CodeLevel: Integer): Text[30]
    var
        StatisticCode: Record BASStatisticcodePHA;
    begin
        case CodeLevel of
            1:
                if StatisticCode.Get(BASStatisticCodeIPHA, 1) then
                    exit(StatisticCode.Description);
            2:
                if StatisticCode.Get(BASStatisticCodeIIPHA, 2) then
                    exit(StatisticCode.Description);
            3:
                if StatisticCode.Get(BASStatisticCodeIIIPHA, 3) then
                    exit(StatisticCode.Description);
        end;
    end;

    procedure HKDatum(ItemNo: Code[20]; CalculationDate: Date): Decimal
    begin
        SalesPrice.SetFilter("Item No.", ItemNo);
        SalesPrice.SetRange("Sales Type", SalesPrice."Sales Type"::"Customer Price Group");
        SalesPrice.SetFilter("Sales Code", '9HK');
        SalesPrice.SetFilter("Starting Date", '<' + Format(CalculationDate));
        SalesPrice.SetRange("Currency Code", '');
        if SalesPrice.FindLast() then
            exit(SalesPrice."Unit Price");
    end;

    procedure FAPWaehrung(ItemNo: Code[20]; var CurrencyCode: Code[10]): Decimal
    begin
        // ToDo -> hardcoded
        SalesPrice.SetFilter("Item No.", ItemNo);
        SalesPrice.SetRange("Sales Type", SalesPrice."Sales Type"::"Customer Price Group");
        SalesPrice.SetFilter("Sales Code", '1FAP');
        SalesPrice.SetFilter("Starting Date", '..' + Format(TODAY));
        SalesPrice.SetFilter("Ending Date", '(' + Format(TODAY) + '..)|''''');
        if SalesPrice.FindLast() then begin
            SalesPrice.SetRange("Starting Date", SalesPrice."Starting Date");
            if SalesPrice.FindLast() then
                if SalesPrice.Count = 1 then begin   //GL011  Nur Wert liefern, wenn nur ein Preis aktiv ist
                    CurrencyCode := SalesPrice."Currency Code";
                    exit(SalesPrice."Unit Price");
                end;
        end;
    end;

    // Hmmmm -> code is not good!!!!!!
    procedure FAPDatum(ItemNo: Code[20]; CalculateDate: Date): Decimal
    var
        UnitPrice: Decimal;
    begin
        SalesPrice.SetFilter("Item No.", ItemNo);
        SalesPrice.SetRange("Sales Type", SalesPrice."Sales Type"::"Customer Price Group");
        SalesPrice.SetFilter("Sales Code", '1FAP');
        SalesPrice.SetFilter("Starting Date", '..' + Format(CalculateDate));
        if SalesPrice.FindLast() then
            UnitPrice := SalesPrice."Unit Price"
        else begin
            SalesPrice.SetRange("Starting Date");
            if SalesPrice.FindLast() then
                UnitPrice := SalesPrice."Unit Price";
        end;

        // ToDo -> check this
        // if SalesPrice.IsEmpty() then
        //     if SalesPrice."Currency Code" <> '' then begin
        //         CurrencyExchangeRate.SetRange("Currency Code", SalesPrice."Currency Code");
        //         CurrencyExchangeRate.SetFilter("Starting Date", '..' + Format(CalculateDate));
        //         if CurrencyExchangeRate.FindLast() then
        //             UnitPrice := Round(
        //                 "Unit Price" / CurrencyExchangeRate."Exchange Rate Amount", 0.00001);
        //     end;

        exit(UnitPrice);
    end;

    procedure HKLosgroesse(ItemNo: Code[20]): Decimal
    begin
        SalesPrice.SetFilter("Item No.", ItemNo);
        SalesPrice.SetRange("Sales Type", SalesPrice."Sales Type"::"Customer Price Group");
        SalesPrice.SetFilter("Sales Code", '9HK');
        if SalesPrice.FindLast() then
            exit(SalesPrice."Minimum Quantity");
    end;

    procedure GK(ItemNo: Code[20]): Decimal
    begin
        // ToDo -> hardcoded!!!
        SalesPrice.SetFilter("Item No.", ItemNo);
        SalesPrice.SetRange("Sales Type", SalesPrice."Sales Type"::"Customer Price Group");
        SalesPrice.SetFilter("Sales Code", '8GK');
        SalesPrice.SetRange("Currency Code", '');
        if SalesPrice.FindLast() then
            exit(SalesPrice."Unit Price");
    end;

    procedure CreateDim(ItemNo: Code[20])
    var
        DefaultDimension: Record "Default Dimension";
    begin
        // ToDo -> hardcoded !!!
        if CompanyName = 'GL-PHARMA' then begin
            CLEAR(DefaultDimension);
            DefaultDimension.SetRange("Table ID", Database::Item);
            DefaultDimension.SetRange("No.", ItemNo);
            DefaultDimension.SetRange("Dimension Code", 'TYP');
            DefaultDimension.SetRange("Dimension Value Code", 'ARTIKEL');
            if DefaultDimension.IsEmpty then begin
                DefaultDimension.Init();
                DefaultDimension."Table ID" := Database::Item;
                DefaultDimension."No." := ItemNo;
                DefaultDimension."Dimension Code" := 'TYP';
                DefaultDimension."Dimension Value Code" := 'ARTIKEL';
                if DefaultDimension.Insert(true) = false then
                    Message('Dimension Zuweisung %1 konnte nicht angelegt werden!', ItemNo);
            end;
        end;
    end;

    procedure DeleteDim(ItemNo: Code[20])
    var
        DefaultDimension: Record "Default Dimension";
        AssignDimensionTxt: Label 'Could not delete dimension assign %1', comment = 'DEA="Dimension Zuweisung %1 konnte nicht gelöscht werden!"', Locked = true;
    begin
        // ToDo -> not hardcoded!!!
        if CompanyName = 'GL-PHARMA' then begin
            DefaultDimension.SetRange("Table ID", Database::Item);
            DefaultDimension.SetRange("No.", ItemNo);
            // DefaultDimension.SetRange("Dimension Code", 'TYP');
            // DefaultDimension.SetRange("Dimension Value Code", 'ARTIKEL');
            if DefaultDimension.FindFirst() then
                if not DefaultDimension.Delete() then
                    Message(AssignDimensionTxt, ItemNo);
        end;
    end;

    procedure LagerstandProduktionVorOrt(itemNo: Code[20]): Decimal
    var
        Item: Record Item;
    // ManufacturingSetup: Record "Manufacturing Setup";
    begin
        if Item.Get(itemNo) then begin
            // if ManufacturingSetup.Get(Item."Site Manufacturing") then;
            // Item.SetFilter("Location Filter", ManufacturingSetup.LagerbestandProduktionVorOrt);
            Item.CalcFields(Item.Inventory);
            exit(Item.Inventory);
        end;
    end;
}