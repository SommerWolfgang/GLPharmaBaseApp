tableextension 50009 "BAST27 ItemPHA" extends Item
{
    fields
    {
        field(50000; "Schrumpfgröße"; Decimal)
        {
            DecimalPlaces = 0 : 3;
            Description = 'Petsch';
        }
        field(50001; "BASJod-grammPHA"; Decimal)
        {
            Description = 'x';
        }
        field(50002; "BASJod-mlPHA"; Decimal)
        {
            Description = 'x';
        }
        field(50003; "BASModified byPHA"; Code[50])
        {
            Caption = 'Modified by';
            Description = 'Petsch';
            Editable = false;
        }
        field(50004; BASKreditornamePHA; Text[50])
        {
            CalcFormula = lookup(Vendor.Name where("No." = field("Vendor No.")));
            Caption = 'Vendor Name';
            Description = 'GL';
            FieldClass = FlowField;

        }
        field(50005; BASAnlieferlagerPHA; Code[10])
        {
            Description = 'Petsch';
            TableRelation = Location;
        }
        // field(50006; BASAnlieferlagerplatzPHA; Code[20])
        // {
        //     Description = 'Petsch';
        //     TableRelation = Bin.Code where("Location Code" = field(Anlieferlager));
        // }
        field(50007; "BASAnzahl je TrayPHA"; Decimal)
        {
            DecimalPlaces = 0 : 3;
            Description = 'Petsch';
        }
        field(50008; "BASAnzahl je KartonPHA"; Decimal)
        {
            DecimalPlaces = 0 : 3;
            Description = 'Petsch';
        }
        field(50009; BASLagerungsartPHA; Code[20])
        {
            Description = 'Petsch';
        }
        field(50010; BASLogistikbewertungPHA; Code[10])
        {
            Description = 'Petsch';
        }
        field(50011; "BASAnzahl je GitterboxPHA"; Decimal)
        {
            DecimalPlaces = 0 : 3;
            Description = 'Petsch';
        }
        field(50012; BASBetriebskennzeichenPHA; Code[10])
        {
            Description = 'Petsch';
        }
        field(50013; BASDruckFreigabePflichtigPHA; Boolean)
        {
            Description = 'Petsch';
        }
        field(50014; "BASARA-KennzeichenPHA"; Code[10])
        {
            Description = 'Petsch';
        }
        field(50015; "BASBeigestellt Artikel Nr.PHA"; Code[20])
        {
            Description = 'Rieder';
            TableRelation = "Item" where("No." = field("No."));
        }
        field(50016; "BASBeigestellt MengePHA"; Decimal)
        {
            DecimalPlaces = 8 : 8;
            Description = 'Rieder';
        }
        field(50017; BASlengthPHA; Decimal)
        {
            Caption = 'Length';
            Description = 'Petsch';
        }
        field(50018; BASwidthPHA; Decimal)
        {
            Caption = 'width';
            Description = 'Petsch';
        }
        field(50019; BASheightPHA; Decimal)
        {
            Caption = 'Height';
            Description = 'Petsch';
        }
        field(50020; BAScolorPHA; Text[30])
        {
            Caption = 'Color';
            Description = 'Petsch';
        }
        field(50021; "Trayhöhe"; Decimal)
        {
            Description = 'Petsch';
        }
        field(50022; "Länge-Umverpackung"; Decimal)
        {
            Description = 'Petsch';
        }
        field(50023; "BASBreite-UmverpackungPHA"; Decimal)
        {
            Description = 'Petsch';
        }
        field(50024; "Höhe-Umverpackung"; Decimal)
        {
            Description = 'Petsch';
        }
        field(50025; BASAblaufdatumformatPHA; Text[60])
        {
            Description = 'Petsch';
        }
        field(50026; "BASEinstandspreis (neuester)PHA"; Decimal)
        {
            Description = 'Petsch';
        }
        field(50027; "BASKlischee Nr.PHA"; Text[30])
        {
            Description = 'Petsch';
        }
        field(50028; BASFertigungsformatPHA; Code[10])
        {
            Description = 'Rieder';
        }
        field(50029; BASKalkulationszusatz1PHA; Text[40])
        {
            Description = 'Petsch';
        }
        field(50030; BASKalkulationszusatz1WertPHA; Decimal)
        {
            DecimalPlaces = 2 : 6;
            Description = 'Petsch';
        }
        field(50031; BASKalkulationszusatz2PHA; Text[40])
        {
            Description = 'Petsch';
        }
        field(50032; BASKalkulationszusatz2WertPHA; Decimal)
        {
            DecimalPlaces = 2 : 6;
            Description = 'Petsch';
        }
        field(50033; BASKalkulationszusatz3PHA; Text[40])
        {
            Description = 'Petsch';
        }
        field(50034; BASKalkulationszusatz3WertPHA; Decimal)
        {
            DecimalPlaces = 2 : 6;
            Description = 'Petsch';
        }
        field(50035; "Kalkulationszusatz1Übernahme"; Boolean)
        {
            Description = 'Petsch';
        }
        field(50036; BASKalkIncludeItemItselfPHA; Boolean)
        {
            Description = 'Petsch';
        }
        field(50037; "BASForce ConcentrationPHA"; Boolean)
        {
            Caption = 'Wirkstoffgehalt notwendig';
            Description = 'Rieder';
        }
        field(50038; BASPostenAnzahlPHA; Integer)
        {
            CalcFormula = count("Item Ledger Entry" where("Item No." = field("No.")));
            Description = 'MFU';
            FieldClass = FlowField;

        }
        field(50039; "BASSimulation-Arbeitsplannr.PHA"; Code[20])
        {
            TableRelation = "Routing Header";
        }
        field(50040; "BASSimulation-Stuecklistenr.PHA"; Code[20])
        {
            TableRelation = "Production BOM Header";
        }
        field(50041; "BASSimulation-Lot SizePHA"; Decimal)
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
            Description = 'MFU';
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
            Description = 'DKO';
        }
        field(50052; "BASPatentschutz bisPHA"; Date)
        {
            Description = 'MFU';
        }
        field(50053; "Vermarktungsexklusivität bis"; Date)
        {
            Description = 'DKO';
        }
        field(50054; "Protokoll-Änderung vorgesehen"; Boolean)
        {
            Description = 'GL021';
        }
        field(50055; BASProbendurchlaufzeitPHA; DateFormula)
        {
            Description = 'GL022';
        }
        field(50056; BASAnlagedatumPHA; Date)
        {
        }
        field(50057; BASInNAVBCUebernommenPHA; Boolean)
        {
            Description = 'MFU';
        }
        field(50075; BASLIMS_VollerProbenumfangPHA; Boolean)
        {
            Description = 'LIMS';
        }
        field(50200; "BASRegdat ConnectionPHA"; Boolean)
        {
            Description = 'Regdat';
        }
        field(50500; "BASPharmazentralnr.PHA"; Code[20])
        {
            Description = 'LAN1.00';
        }
        field(50501; BASHaltbarkeitsinfoPHA; Code[4])
        {
            DateFormula = true;
            Description = 'LAN1.00';
        }
        field(50502; "BASBeschreibung 1 lt. ArzneibuchPHA"; Text[150])
        {
            Description = 'LAN1.00';
        }
        field(50503; "BASBeschreibung 2 lt. ArzneibuchPHA"; Text[150])
        {
            Description = 'LAN1.00';
        }
        field(50504; BASSuchtgiftPHA; Boolean)
        {
            Description = 'LAN1.00';

            trigger OnValidate()
            begin
                "BASPsychotroper StoffPHA" := BASSuchtgiftbasePHA <> 0;
            end;
        }
        field(50505; "BASPsychotroper StoffPHA"; Boolean)
        {
            Description = 'LAN1.00';

            trigger OnValidate()
            begin
                BASSuchtgiftPHA := not "BASPsychotroper StoffPHA";
            end;
        }
        field(50506; "BASArtikel StatistikgruppePHA"; Code[10])
        {
            Description = 'LAN1.00';

        }
        field(50507; "BASStatistikcode IPHA"; Code[10])
        {
            TableRelation = BASStatisticcode2PHA.Code where(Level = const(1));
        }
        field(50508; "BASStatistikcode IIPHA"; Code[10])
        {
            Description = 'LAN1.00';
            TableRelation = BASStatisticcode2PHA.Code where(Level = const(2));
        }
        field(50509; "BASStatistikcode IIIPHA"; Code[10])
        {
            TableRelation = BASStatisticcode2PHA.Code where(Level = const(3));
        }
        field(50510; BASInventurbewertungPHA; Decimal)
        {
            Description = 'LAN1.00';
        }
        field(50511; "BASCountry/Region CodePHA"; Code[10])
        {
            Caption = 'Country/Region Code';
            Description = 'LAN1.00';
            TableRelation = "Country/Region";
        }
        field(50512; "Packungsgröße"; Text[10])
        {
            Caption = 'Packing size';
            Description = 'LAN1.00';
        }
        field(50513; "BASEAN CodePHA"; Text[13])
        {
            Description = 'LAN1.00';
        }
        field(50514; "BASLaetus-CodePHA"; Text[10])
        {
            Description = 'LAN1.00';
        }
        field(50515; BASSchwund_BeschreibungPHA; Text[50])
        {
            Caption = 'Schwund Beschreibung';
            Description = 'MFU';
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

                if not CONFIRM(Text50000, false, BASItemTypePHA) then
                    BASItemTypePHA := xRec.BASItemTypePHA;
                //+LAN001
            end;
        }
        field(50517; BASSonderkonditionengruppePHA; Code[10])
        {
            Description = 'LAN1.00';
        }
        field(50518; "BASItemKred ShipmentMethodCodePHA"; Code[10])
        {
            Description = 'MFU';
            TableRelation = "Shipment Method";
        }
        field(50520; "BASMatGemeinkosten%7EPPHA"; Decimal)
        {
        }
        field(50521; "BASItemKred PaymentTermsCodePHA"; Code[10])
        {
            Description = 'MFU';
            TableRelation = "Payment Terms";
        }
        field(50522; BASVollkostenPHA; Decimal)
        {
            Description = 'Petsch';
        }
        field(50523; "BASMenge in RahmenbestellungPHA"; Decimal)
        {
            CalcFormula = sum("Purchase Line"."Outstanding Qty. (Base)" where("Document Type" = const("Blanket Order"),
                                                                               Type = const(Item),
                                                                               "No." = field("No."),
                                                                               "Shortcut Dimension 1 Code" = field("Global Dimension 1 Filter")));
            Description = 'GL';
            FieldClass = FlowField;

        }
        field(50524; "BASVollkosten 2000PHA"; Decimal)
        {
            Description = 'Petsch';
        }
        field(50525; "BASSuchtgiftnr.PHA"; Code[20])
        {
            Description = 'Petsch';
        }
        field(50526; BASSuchtgiftgehaltPHA; Decimal)
        {
            DecimalPlaces = 0 : 5;
            Description = 'Petsch';
        }
        field(50527; BASSuchtgiftbasePHA; Decimal)
        {
            DecimalPlaces = 0 : 5;
            Description = 'Petsch';
        }
        field(50528; "BASMat.-Gemeinkosten %PHA"; Decimal)
        {
            DecimalPlaces = 0 : 5;
            Description = 'Petsch';
        }
        field(50529; "BASPreis f. KalkulationPHA"; Decimal)
        {
            Description = 'Petsch';
        }
        field(50530; "Lösungsmittel"; Boolean)
        {
            Description = 'Petsch';
        }
        field(50531; BASDurchschnittsgehaltPHA; Decimal)
        {
            Description = 'Petsch';
        }
        field(50532; "BASSchwund %PHA"; Decimal)
        {
            DecimalPlaces = 0 : 5;
            Description = 'Petsch';
        }
        field(50533; "Güterlistencode"; Code[20])
        {
            Description = 'Petsch';
        }
        field(50534; "BASMat.-Gemeinkosten % 2PHA"; Decimal)
        {
            DecimalPlaces = 0 : 5;
            Description = 'Petsch';
        }
        field(50535; "Nicht prüfpflichtig"; Boolean)
        {
            Description = 'LAN1.00';
        }
        field(50536; "Überfüllung %"; Decimal)
        {
            Description = 'Petsch';
        }
        field(50537; "Als Unterstufe nicht prüfen"; Boolean)
        {
            Description = 'Rieder';
        }
        field(50538; BASKalkFloorPreisPHA; Decimal)
        {
            Description = 'MFU';
        }
        field(50539; BASKalkProzentZuFAPPHA; Decimal)
        {
            Description = 'MFU';
        }
        field(50540; "BASItem TypePHA"; Code[15])
        {
            Description = 'Rieder';

        }
        field(50541; "BASNumber of UnitsPHA"; Integer)
        {
            Description = 'Petsch';
        }
        field(50542; "BASContents of UnitPHA"; Integer)
        {
            Description = 'Petsch';
        }
        field(50543; "BASMeasure of ContentsPHA"; Code[10])
        {
            Description = 'Petsch';
            TableRelation = "Unit of Measure".Code;
        }
        field(50544; BASConcentrationPHA; Decimal)
        {
            DecimalPlaces = 0 : 5;
            Description = 'Petsch';
        }
        field(50545; "BASMeasure of ConcentrationPHA"; Code[10])
        {
            Description = 'Petsch';
            TableRelation = "Unit of Measure".Code;
        }
        field(50546; BASShapePHA; Code[10])
        {
            Description = 'Petsch';

        }
        field(50547; BASKalkProzentZuFertigArtikelFAPPHA; Decimal)
        {
            Description = 'MFU';
        }
        field(50549; "BASProduct Type CodePHA"; Code[15])
        {
            Caption = 'Produktart Code';
            Description = 'Rieder';

        }
        field(50550; "BASGewicht VP KartonPHA"; Decimal)
        {
            DecimalPlaces = 5 : 5;
            Description = 'Petsch';
        }
        field(50551; "BASGewicht VP Kunststoffhohlk.PHA"; Decimal)
        {
            DecimalPlaces = 5 : 5;
            Description = 'Petsch';
        }
        field(50552; "BASGewicht VP KunststofffoliePHA"; Decimal)
        {
            DecimalPlaces = 5 : 5;
            Description = 'Petsch';
        }
        field(50553; "BASGewicht VP MetallPHA"; Decimal)
        {
            DecimalPlaces = 5 : 5;
            Description = 'Petsch';
        }
        field(50554; "BASSales (Qty.) Deb FilterPHA"; Decimal)
        {
            CalcFormula = - sum("Item Ledger Entry"."Invoiced Quantity" where("Entry Type" = const(Sale),
                                                                              "Item No." = field("No."),
                                                                              "Global Dimension 1 Code" = field("Global Dimension 1 Filter"),
                                                                              "Global Dimension 2 Code" = field("Global Dimension 2 Filter"),
                                                                              "Location Code" = field("Location Filter"),
                                                                              "Drop Shipment" = field("Drop Shipment Filter"),
                                                                              "Variant Code" = field("Variant Filter"),
                                                                              "Posting Date" = field("Date Filter"),
                                                                              "Lot No." = field("Lot No. Filter"),
                                                                              "Serial No." = field("Serial No. Filter"),
                                                                              "Source No." = filter(< 50004)));
            Caption = 'Verkauf (Menge) Kunden Filter';
            Description = 'GL';
            FieldClass = FlowField;

        }
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
            Description = 'GL';
            FieldClass = FlowField;

        }
        field(50556; BASKalkPreisFuerTransportPHA; Decimal)
        {
            Description = 'MFU';
        }
        field(50559; "BASSite AssignmentPHA"; Code[20])
        {
            Caption = 'Standort Zuordnung';
            Description = 'Rieder';

        }
        field(50560; "BASManufacturing AreaPHA"; Code[20])
        {
            Caption = 'Herstellungsbereich';
            Description = 'Rieder';

        }
        field(50561; "BASSite ManufacturingPHA"; Code[20])
        {
            Caption = 'Standort Herstellung';
            Description = 'Rieder';

        }
        field(50562; "BASSite Batch ReleasePHA"; Code[20])
        {
            Caption = 'Standort Freigabe';
            Description = 'Rieder';

        }
        field(50563; "BASSite AnalysesPHA"; Code[20])
        {
            Caption = 'Standort Analysen';
            Description = 'Rieder';

        }
        field(50564; "BASSite SamplesPHA"; Code[20])
        {
            Caption = 'Standort Rückstellmuster';
            Description = 'Rieder';

        }
        field(50565; "BASSite StabilitiesPHA"; Code[20])
        {
            Caption = 'Standort Stabilitäten';
            Description = 'Rieder';

        }
        field(50566; "BASRegistration CompanyPHA"; Code[20])
        {
            Caption = 'Zulassungsinhaber';
            Description = 'Rieder';

        }
        field(50567; "BASManufacturing ForPHA"; Code[20])
        {
            Caption = 'Contract Manufacturing for';
            Description = 'GL';

        }
        field(50568; "BASType ForecastPHA"; Option)
        {
            FieldClass = FlowFilter;
            OptionMembers = " ",Verkauf,Kolo,Muster,Planungsauftrag,Forecast;
        }
        field(50569; "BASStorage ConditionPHA"; Option)
        {
            Caption = 'Lagerbedingung';
            Description = 'Rieder';
            OptionMembers = " ",Raum,"Kühl";
        }
        field(50570; BASOhneSchwundBerechnungPHA; Boolean)
        {
        }
        field(50571; BASVerkehrszweigPHA; Code[10])
        {
            Description = 'MFU';
            TableRelation = "Transport Method".Code;
        }

        field(65800; "Übertrag Suchtgiftliste"; Decimal)
        {
            Description = 'LAN1.00';
            Editable = false;
        }
        field(65801; "BASSeite SuchtgiftlistePHA"; Integer)
        {
            Description = 'LAN1.00';
            Editable = false;
        }
    }
    keys
    {
        key(Key17; "BASPharmazentralnr.PHA")
        {
        }
        key(Key18; BASItemTypePHA, "BASStatistikcode IPHA", "BASStatistikcode IIPHA", "BASStatistikcode IIIPHA")
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
        //-GL001
        if item.GET(itemno) then begin
            if ManufacturingSetup.GET(item."BASSite ManufacturingPHA") then;
            // item.SetFilter("Location Filter", ManufacturingSetup."Lagerbestand vor Ort Filter");
            item.CalcFields(item.Inventory);
            lagerstand := item.Inventory;
        end;
        //+GL001
    end;

    procedure LagerstandLannach(itemno: Code[20]) lagerstand: Decimal
    var
        recitem: Record Item;
        recManufacturingSetup: Record "Manufacturing Setup";
    begin
        //-GL001
        if recitem.GET(itemno) then begin
            if recManufacturingSetup.GET('LANNACH') then;
            // recitem.SetFilter("Location Filter", recManufacturingSetup."Lagerbestand vor Ort Filter");
            recitem.CalcFields(recitem.Inventory);
            lagerstand := recitem.Inventory;
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
        if Item.GET(itemNo) then begin
            if ManufacturingSetup.GET('WIEN') then;
            // recitem.SetFilter("Location Filter", recManufacturingSetup."Lagerbestand vor Ort Filter");
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
        SalesPrice.SetFilter("Starting Date", '..' + FORMAT(TODAY));
        SalesPrice.SetFilter("Ending Date", '(' + FORMAT(TODAY) + '..)|''''');
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
        StatisticCode: Record BASStatisticcode2PHA;
    begin
        case CodeLevel of
            1:
                if StatisticCode.GET("BASStatistikcode IPHA", 1) then
                    exit(StatisticCode.Description);
            2:
                if StatisticCode.GET("BASStatistikcode IIPHA", 2) then
                    exit(StatisticCode.Description);
            3:
                if StatisticCode.GET("BASStatistikcode IIIPHA", 3) then
                    exit(StatisticCode.Description);
        end;
    end;

    procedure HKDatum(ItemNo: Code[20]; CalculationDate: Date): Decimal
    begin
        SalesPrice.SetFilter("Item No.", ItemNo);
        SalesPrice.SetRange("Sales Type", SalesPrice."Sales Type"::"Customer Price Group");
        SalesPrice.SetFilter("Sales Code", '9HK');
        SalesPrice.SetFilter("Starting Date", '<' + FORMAT(CalculationDate));
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
        SalesPrice.SetFilter("Starting Date", '..' + FORMAT(TODAY));
        SalesPrice.SetFilter("Ending Date", '(' + FORMAT(TODAY) + '..)|''''');
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
        SalesPrice.SetFilter("Starting Date", '..' + FORMAT(CalculateDate));
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
        //         CurrencyExchangeRate.SetFilter("Starting Date", '..' + FORMAT(CalculateDate));
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
                    MESSAGE('Dimension Zuweisung %1 konnte nicht angelegt werden!', ItemNo);
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
                    MESSAGE(AssignDimensionTxt, ItemNo);
        end;
    end;

    procedure LagerstandProduktionVorOrt(itemNo: Code[20]): Decimal
    var
        Item: Record Item;
    // ManufacturingSetup: Record "Manufacturing Setup";
    begin
        if Item.GET(itemNo) then begin
            // if ManufacturingSetup.GET(Item."Site Manufacturing") then;
            // Item.SetFilter("Location Filter", ManufacturingSetup.LagerbestandProduktionVorOrt);
            Item.CalcFields(Item.Inventory);
            exit(Item.Inventory);
        end;
    end;
}