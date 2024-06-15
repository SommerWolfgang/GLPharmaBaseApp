tableextension 50009 "BAST27 ItemPHA" extends Item
{// version NAVW114.44,TODOPBA

    // LAN001 12.11.09 ACPSS LAN1.00
    //   New Fields: ID 50500 - 50514, 50516, 50517, 50535, 65800, 65801
    //   New Key: "Statistikcode I,Statistikcode II,Statistikcode III,No."
    //   Fields ID 3, 4: Length 30 -> 40
    //   Div. Anpassungen
    // 
    // GL001 LagerstandVorOrt()
    // GL002 Funktionen HK() und FAP() eingefügt
    // GL003 Inventory-OnLookup() -> Anzeige der Posten ohne Lagerorteinschränkung
    //        Lookup-Feld auf Inventory, damit nur Restmengen-Artikelposten gezeigt werden
    // GL004 Namensumbenennung benennt auch Stücklistenzeilennamen mit um
    // GL005 Bei Kopieren eines Artikels die Felder Ablaufdatumsformel nur bei Berechtigung mitkopieren
    //        Beim Satz kopieren die QK Felder ignorieren
    // GL006 Key für R50031 eingefügt (Country/Region Code,No.)
    // 
    // ------------------------------------------------------------------------------------------------------------------------------------
    // Datum      | Autor   | Status  | Beschreibung
    // ------------------------------------------------------------------------------------------------------------------------------------
    // 2010-02-09 | MFU     | ok      | Update von 360
    // ------------------------------------------------------------------------------------------------------------------------------------
    // 2010-04-12 | Petsch  | ok      | Feld Inventory-Onlookup: Neues Umlagerungsinfoform (Änderung GL003)
    // ------------------------------------------------------------------------------------------------------------------------------------
    // 2010-06-22 | Rieder  | ok      | Felder eingefügt: Site Assignment, Site Manufacturing, Site Batch Release, Site Analyses,
    //                                                    Site Samples, Site Stabilities, Registration Company
    // ------------------------------------------------------------------------------------------------------------------------------------
    // 2010-07-13 | Rieder  | ok      | Felder umgebaut: Site Assignment, Site Manufacturing, Site Batch Release, Site Analyses,
    //                                                   Site Samples, Site Stabilities, Registration Company
    //                                                   (alle Felder referenzieren auf DropDownContent)
    // ------------------------------------------------------------------------------------------------------------------------------------
    // 2010-07-13 | Rieder  | ok      | Feld "Force Concentration". Soll die Eingabe einer Gehaltsangabe im Chargenstamm erzwingen
    // ------------------------------------------------------------------------------------------------------------------------------------
    // 2010-07-13 | Petsch  | ok      | Feld Manufacturing Area
    // ------------------------------------------------------------------------------------------------------------------------------------
    // 2011-02-08 | Petsch  | ok      | LagerstandVorOrt() auf Manufacturing Setup umgestellt
    // ------------------------------------------------------------------------------------------------------------------------------------
    // 2011-03-15 | MFU     | ok      | Felder "Beschreibung 1/2 lt. Arzneibuch" auf 150 Zeichen erweitert. Wunsch Engelbogen
    // ------------------------------------------------------------------------------------------------------------------------------------
    // 2011-05-07 | Rieder  | ok      | Feld "Als Unterstufe nicht prüfen" eingefügt (log)
    // ------------------------------------------------------------------------------------------------------------------------------------
    // 2011-05-31 | MFU     | ok      | Feld "Type Forecast" eingefügt (für Absatzplanung)
    // ------------------------------------------------------------------------------------------------------------------------------------
    // 2011-09-14 | MFU     | ok      | Feld "Posten vorhanden" eingefügt (zum erkennen nicht genutzer Artikel)
    // ------------------------------------------------------------------------------------------------------------------------------------
    // 2011-10-25 | MFU     | ok      | Felder für Kalkulation Simulation eingefügt
    // ------------------------------------------------------------------------------------------------------------------------------------
    // 2011-11-27 | Rieder  | ok      | Feld "Product Type Code" eingefügt. Für Artikelartkürzel Wien
    // ------------------------------------------------------------------------------------------------------------------------------------
    // 2012-02-01 | MFU     | ok      | Key eingefügt für Bericht "Artikel-Verkauf-Kumuliert"
    // ------------------------------------------------------------------------------------------------------------------------------------
    // 2012-03-03 | Rieder  | ok      | Feld "Storage Condition" eingefügt. (QS Anforderung Kühlware festzulegen)
    // ------------------------------------------------------------------------------------------------------------------------------------
    // 2012-05-15 | MFU     | ok      | GL007 - Beim Löschen von Artikeln auch die Absatzplanung mit prüfen
    // ------------------------------------------------------------------------------------------------------------------------------------
    // 2012-05-29 | Petsch  | ok      | Feld VKChargennr nicht berechnen, löst die alte FWFREMD Automatikunterdrückung bei FA ab
    // ------------------------------------------------------------------------------------------------------------------------------------
    // 2012-07-20 | MFU     | ok      | GL008 - Funktion FAP() mit Fremdwährung Berechnung
    // ------------------------------------------------------------------------------------------------------------------------------------
    // 2012-08-02 | MFU     | ok      | Feld "Beigestellt Artikel Nr." von Code 10 auf Code 20 erweitert
    // ------------------------------------------------------------------------------------------------------------------------------------
    // 2012-11-14 | MFU     | ok      | GL009 - Bei Artikellöschen auch die Historiendaten abfragen
    //                                       Neues Feld "Wirkstoff" eingebaut
    // ------------------------------------------------------------------------------------------------------------------------------------
    // 2013-01-14 | MFU     | ok      | Feld "Artikel_Hersteller_Anlegen" eingebaut.
    //                                  Wenn TRUE dann nicht mit dem Bericht "ArtikelHersteller_ItemAnlage" automatisch anlegen
    // ------------------------------------------------------------------------------------------------------------------------------------
    // 2013-01-24 | MFU     | ok      | Spalte "Bestellmenge aus Rahmen" hinzugefügt
    // ------------------------------------------------------------------------------------------------------------------------------------
    // 2013-05-08 | MFU     | ok      | GL010 - Bei Artikel Umbenennen auch die Artikelnummern in der AnalyseDB mit ändern
    // ------------------------------------------------------------------------------------------------------------------------------------
    // 2015-01-19 | MFU     | ok      | UPDATE2013 Spalte "ItemKred ShipmentMethodCode" für Einkauf eingebaut
    // ------------------------------------------------------------------------------------------------------------------------------------
    // 2015-03-30 | MFU     | ok      | Spalte "Schwund_Beschreibung" für Kaltukation (Schulter) eingefügt
    // ------------------------------------------------------------------------------------------------------------------------------------
    // 2015-06-10 | MFU     | ok      | offen: keys bei Bedarf erweitern
    // ------------------------------------------------------------------------------------------------------------------------------------
    // 2015-08-20 | MFU     | ok      | Fehlende Objektänderungen aus NAV2009 eingebaut:
    //                                   GL011 - Bei mehreren gültigen FAP's gar keinen zurückgeben (Wunsch Schmer)
    //                                   GL012 - Bei Artikellöschen auf auch Artikelbudgetposten prüfen
    // ------------------------------------------------------------------------------------------------------------------------------------
    // 2015-08-21 | MFU     | ok      | Table Relation zu "Artikel Statistikgruppe" hinzugefügt
    // ------------------------------------------------------------------------------------------------------------------------------------
    // 2015-10-13 | MFU     | ok      | Spalte "Tablettenform" für Kaltukation (Schulter/Zechner) eingefügt
    // ------------------------------------------------------------------------------------------------------------------------------------
    // 2015-11-12 | MFU     | ok      | Lookup auf DropDownContent in Spalte "Kalkulationszusatz2" (Wunsch Humpel)
    // ------------------------------------------------------------------------------------------------------------------------------------
    // 2015-11-24 | MFU     | ok      | Bei Feld "Forecast Type" den Typ Planungsauftrag dazugegeben
    // ------------------------------------------------------------------------------------------------------------------------------------
    // 2015-12-21 | MFU     | ok      | GL013 - Funktion FAPDatum für R50078 eingebaut
    // ------------------------------------------------------------------------------------------------------------------------------------
    // 2016-01-22 | Petsch  | ok      | Key: Artikelart, Statistikcode I-III, Blocked eingebaut, weil oft lange Anfragezeiten im SQL-Monitor sichtbar
    // ------------------------------------------------------------------------------------------------------------------------------------
    // 2016-03-07 | MFU     | ok      | GL014 - Funktion HKLosgroesse() eingebaut
    // ------------------------------------------------------------------------------------------------------------------------------------
    // 2016-07-20 | MFU     | ok      | Lookupfeld "KundenArtikelnummer" eingebaut (Anzeige in Artikelliste Detail)
    // ------------------------------------------------------------------------------------------------------------------------------------
    // 2016-08-01 | MFU     | ok      | "Mindestrestlaufzeit %" eingebaut (Rieder)
    // ------------------------------------------------------------------------------------------------------------------------------------
    // 2016-09-07 | MFU     | ok      | "OhneSchwundBerechnung" eingebaut (Für Produktkalkulation)
    // ------------------------------------------------------------------------------------------------------------------------------------
    // 2016-09-19 | MFU     | ok      | GL015 - Funktion GK() eingebaut (Kopie von HK für Produktkalkulation RÄG2015)
    //                                          Feld "MatGemeinkosten%7EP" eingebaut
    // ------------------------------------------------------------------------------------------------------------------------------------
    // 2016-12-20 | MFU     | ok      | Lookup "SerialisierungVorhanden" eingebaut (Filter in Artikelliste)
    // ------------------------------------------------------------------------------------------------------------------------------------
    // 2017-03-06 | MFU     | ok      | GL016 - Dimension handling
    // ------------------------------------------------------------------------------------------------------------------------------------
    // 2017-06-14 | MFU     | ok      | GL017 - Funktion LagerstandProduktionVorOrt() dazu (für FADispoCheck())
    // ------------------------------------------------------------------------------------------------------------------------------------
    // 2017-07-04 | MFU     | ok      | GL018 - Suchtgiftrelevante Felder sollen nur mit Spezialrecht bearbeitbar sein
    // ------------------------------------------------------------------------------------------------------------------------------------
    // 2017-08-01 | MFU     | ok      | GTIN aus Artikelstamm entfernt (Jetzt in Serialisierungsdaten)
    // ------------------------------------------------------------------------------------------------------------------------------------
    // 2017-08-07 | MFU     | ok      | Lookupfeld "Kreditorenname" von 40 auf 50 Zeichen erhöht
    // ------------------------------------------------------------------------------------------------------------------------------------
    // 2017-09-04 | MFU     | ok      | Nettogewicht auf 6 Kommastellen erweitert
    //                                  Verkehrszweig dazu  (Für Intrastatauswertung)
    // ------------------------------------------------------------------------------------------------------------------------------------
    // 2017-09-21 | MFU     | ok      | "ItemKred PaymentTermsCode" für Transportversicherung eingebaut -> (Wird an Bestellung übertragen)
    // ------------------------------------------------------------------------------------------------------------------------------------
    // 2017-09-21 | MFU     | ok      | GL019 - Serialisierungsstammdaten auslesen
    // ------------------------------------------------------------------------------------------------------------------------------------
    // 2017-10-06 | MFU     | ok      | GL020 - Artikel-Herstellerinfos auslesen
    // ------------------------------------------------------------------------------------------------------------------------------------
    // 2017-11-14 | MFU     | ok      | "Patentschutz bis" eingebaut (Info kommt dann bei Fertigartikelfreigabe)
    // ------------------------------------------------------------------------------------------------------------------------------------
    // 2018-12-14 | MFU     | ok      | "KalkFloorPreis" "KalkProzentZuFAP" "KalkProzentZuFertigArtikelFAP" für Produktkalkulation eingebaut
    //                                  "KalkPreisFuerTransport"
    // ------------------------------------------------------------------------------------------------------------------------------------
    // 2019-02-28 | DKO     | ok      | GL021 - "Protokoll-Änderung vorgesehen" Spalte auf Wunsch von Mayrhofer hinzugefügt
    //                                        - Bei Umstellung auf NAV BC -> Notizen per SQL übertragen
    // ------------------------------------------------------------------------------------------------------------------------------------
    // 2019-03-13 | DKO     | ok      | GL022 - "Probendurchlaufzeit" für LIMS
    // ------------------------------------------------------------------------------------------------------------------------------------
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
            TableRelation = BASStatistikcode2PHA.Code where(Level = const(1));
        }
        field(50508; "BASStatistikcode IIPHA"; Code[10])
        {
            Description = 'LAN1.00';
            TableRelation = BASStatistikcode2PHA.Code where(Level = const(2));
        }
        field(50509; "BASStatistikcode IIIPHA"; Code[10])
        {
            TableRelation = BASStatistikcode2PHA.Code where(Level = const(3));
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
        field(50516; BASArtikelartPHA; Option)
        {
            Caption = 'Item type';
            Description = 'LAN1.00';
            OptionCaption = ' ,Rohstoff,Halbfabrikat,Fertigprodukt,Verpackungsstoff,Arbeitsschritt';
            OptionMembers = " ",Rohstoff,Halbfabrikat,Fertigprodukt,Verpackungsstoff,Arbeitsschritt;

            trigger OnValidate()
            var
                Text50000: Label 'Achtung!\Die Artikelart hat Auswirkung auf Chargenerstellung und Kommissionierung!\Ist die Festlegung von Artikelart %1 korrekt?';
            begin
                //-LAN001
                if xRec.Artikelart = Artikelart then
                    exit;

                if not CONFIRM(Text50000, false, Artikelart) then
                    Artikelart := xRec.Artikelart;
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
        key(Key18; BASArtikelartPHA, "BASStatistikcode IPHA", "BASStatistikcode IIPHA", "BASStatistikcode IIIPHA")
        {
        }
    }
    procedure LagerstandVorOrt(itemno: Code[20]) lagerstand: Decimal
    var
        item: Record Item;
        ManufacturingSetup: Record "Manufacturing Setup";
    begin
        //-GL001
        if item.GET(itemno) then begin
            if ManufacturingSetup.GET(item."BASSite ManufacturingPHA") then;
            // item.SETFILTER("Location Filter", ManufacturingSetup."Lagerbestand vor Ort Filter");
            item.CALCFIELDS(item.Inventory);
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
            // recitem.SETFILTER("Location Filter", recManufacturingSetup."Lagerbestand vor Ort Filter");
            recitem.CALCFIELDS(recitem.Inventory);
            lagerstand := recitem.Inventory;
        end;
        //+GL001
    end;

    procedure LagerstandWien(itemno: Code[20]) lagerstand: Decimal
    var
        recitem: Record Item;
        recManufacturingSetup: Record "Manufacturing Setup";
    begin
        //-GL001
        if recitem.GET(itemno) then begin
            if recManufacturingSetup.GET('WIEN') then;
            // recitem.SETFILTER("Location Filter", recManufacturingSetup."Lagerbestand vor Ort Filter");
            recitem.CALCFIELDS(recitem.Inventory);
            lagerstand := recitem.Inventory;
        end;
        //+GL001
    end;

    procedure HK(artikelnummer: Code[20]) hk: Decimal
    var
        ArtVKPreis: Record "Price List Line";
    begin
        //-GL002
        hk := 0;
        CLEAR(ArtVKPreis);
        with ArtVKPreis do begin
            SETFILTER("Item No.", artikelnummer);
            SETRANGE("Sales Type", ArtVKPreis."Sales Type"::"Customer Price Group");
            SETFILTER("Sales Code", '9HK');
            SETRANGE("Currency Code", '');
            if FIND('+') then begin
                hk := "Unit Price";
            end else begin
                SETRANGE("Currency Code", 'ATS');
                if FIND('+') then
                    hk := ROUND("Unit Price" / 13.7603, 0.00001);
            end;
        end;
        //+GL002
    end;

    procedure FAP(artikelnummer: Code[20]) fap: Decimal
    var
        recCurrencyExchangeRate: Record "330";
        ArtVKPreis: Record "7002";
    begin
        //-GL002
        fap := 0;
        CLEAR(ArtVKPreis);
        with ArtVKPreis do begin
            SETFILTER("Item No.", artikelnummer);
            SETRANGE("Sales Type", ArtVKPreis."Sales Type"::"Customer Price Group");
            SETFILTER("Sales Code", '1FAP');

            //-GL011
            SETFILTER("Starting Date", '..' + FORMAT(TODAY));
            SETFILTER("Ending Date", '(' + FORMAT(TODAY) + '..)|''''');
            //+GL011

            //SETRANGE("Currency Code",'');  //GL008
            if FIND('+') then

                //Sind mehrere Preise aktiv (gleiche Startdatum wie letzter aktiver Preis)?
                SETRANGE("Starting Date", "Starting Date");
            if FIND('+') then begin
                if COUNT = 1 then begin   //GL011 Nur Wert liefern, wenn nur ein Preis aktiv ist
                    fap := "Unit Price";
                    //-GL008
                    if "Currency Code" <> '' then begin
                        CLEAR(recCurrencyExchangeRate);
                        recCurrencyExchangeRate.SETRANGE("Currency Code", "Currency Code");
                        if recCurrencyExchangeRate.FINDLAST then
                            fap := ROUND("Unit Price" / recCurrencyExchangeRate."Exchange Rate Amount", 0.00001);  //Mit Tageskurs in EUR umrechnen
                    end;
                    //+GL008
                end;
            end;
        end;
        //+GL002
    end;

    procedure HoleStatCode(CodeLevel: Integer) cText: Text[30]
    var
        statistikcodes: Record Statistikcode2;
    begin
        //-100
        cText := '';
        case CodeLevel of
            1:
                if statistikcodes.GET("Statistikcode I", 1) then
                    cText := statistikcodes.Bezeichnung;
            2:
                if statistikcodes.GET("Statistikcode II", 2) then
                    cText := statistikcodes.Bezeichnung;
            3:
                if statistikcodes.GET("Statistikcode III", 3) then
                    cText := statistikcodes.Bezeichnung;
        end;
        //+100
    end;

    procedure HKDatum(artikelnummer: Code[20]; KalkDatum: Date) hk: Decimal
    var
        ArtVKPreis: Record "7002";
    begin
        //-100
        hk := 0;
        CLEAR(ArtVKPreis);
        with ArtVKPreis do begin
            SETFILTER("Item No.", artikelnummer);
            SETRANGE("Sales Type", ArtVKPreis."Sales Type"::"Customer Price Group");
            SETFILTER("Sales Code", '9HK');
            SETFILTER("Starting Date", '<' + FORMAT(KalkDatum));
            SETRANGE("Currency Code", '');
            if FIND('+') then begin
                hk := "Unit Price";
            end else begin
                SETRANGE("Currency Code", 'ATS');
                if FIND('+') then
                    hk := ROUND("Unit Price" / 13.7603, 0.00001);
            end;
        end;
        //+100
    end;

    procedure FAPWaehrung(artikelnummer: Code[20]; var cWaehrung: Code[10]) fap: Decimal
    var
        recCurrencyExchangeRate: Record "330";
        ArtVKPreis: Record "7002";
    begin

        //-GL008
        //Denn aktuellen FAP mit Währung zurückgeben (Währung egal)
        cWaehrung := '';
        fap := 0;
        CLEAR(ArtVKPreis);
        with ArtVKPreis do begin
            SETFILTER("Item No.", artikelnummer);
            SETRANGE("Sales Type", ArtVKPreis."Sales Type"::"Customer Price Group");
            SETFILTER("Sales Code", '1FAP');

            //-GL011
            SETFILTER("Starting Date", '..' + FORMAT(TODAY));
            SETFILTER("Ending Date", '(' + FORMAT(TODAY) + '..)|''''');
            //+GL011

            if FINDLAST then begin
                //Sind mehrere Preise aktiv (gleiche Startdatum wie letzter aktiver Preis)?
                SETRANGE("Starting Date", "Starting Date");
                if FINDLAST then
                    if COUNT = 1 then begin   //GL011  Nur Wert liefern, wenn nur ein Preis aktiv ist
                        fap := "Unit Price";
                        cWaehrung := "Currency Code";
                    end;
            end;
        end;
        //+GL008
    end;

    procedure FAPDatum(artikelnummer: Code[20]; KalkDatum: Date) dFAP: Decimal
    var
        recCurrencyExchangeRate: Record "330";
        ArtVKPreis: Record "7002";
    begin
        //-GL013

        dFAP := 0;
        CLEAR(ArtVKPreis);
        with ArtVKPreis do begin

            SETFILTER("Item No.", artikelnummer);
            SETRANGE("Sales Type", ArtVKPreis."Sales Type"::"Customer Price Group");
            SETFILTER("Sales Code", '1FAP');
            SETFILTER("Starting Date", '..' + FORMAT(KalkDatum));
            if FINDLAST then
                dFAP := "Unit Price"   //aktiven Preis zum Datum gefunden
            else begin
                //Keinen Preis gefunden, alternativ den ältesten nehmen
                SETRANGE("Starting Date");
                if FINDFIRST then
                    dFAP := "Unit Price"
            end;

            if COUNT > 0 then begin
                if "Currency Code" <> '' then begin
                    CLEAR(recCurrencyExchangeRate);
                    recCurrencyExchangeRate.SETRANGE("Currency Code", "Currency Code");
                    recCurrencyExchangeRate.SETFILTER("Starting Date", '..' + FORMAT(KalkDatum));
                    if recCurrencyExchangeRate.FINDLAST then
                        dFAP := ROUND("Unit Price" / recCurrencyExchangeRate."Exchange Rate Amount", 0.00001);  //Mit Tageskurs des Kalkulationsdatums in EUR umrechnen
                end;
            end;

        end;

        //+GL013
    end;

    procedure HKLosgroesse(artikelnummer: Code[20]) Losgroesse: Decimal
    var
        ArtVKPreis: Record "7002";
    begin
        //-GL014
        Losgroesse := 0;
        CLEAR(ArtVKPreis);
        with ArtVKPreis do begin
            SETFILTER("Item No.", artikelnummer);
            SETRANGE("Sales Type", ArtVKPreis."Sales Type"::"Customer Price Group");
            SETFILTER("Sales Code", '9HK');
            if FINDLAST then begin
                Losgroesse := "Minimum Quantity";  //Mindestmenge bei 9HK als Losgrößenfeld benutzen
            end;
        end;
        //+GL014
    end;

    procedure GK(artikelnummer: Code[20]) hk: Decimal
    var
        ArtVKPreis: Record "7002";
    begin
        //-GL015
        hk := 0;
        CLEAR(ArtVKPreis);
        with ArtVKPreis do begin
            SETFILTER("Item No.", artikelnummer);
            SETRANGE("Sales Type", ArtVKPreis."Sales Type"::"Customer Price Group");
            SETFILTER("Sales Code", '8GK');
            SETRANGE("Currency Code", '');
            if FIND('+') then
                hk := "Unit Price";

            //ATS umrechnung nicht mehr notwendig
            /*
            END ELSE BEGIN
              SETRANGE("Currency Code",'ATS');
              IF FIND('+') THEN
                hk := ROUND("Unit Price" / 13.7603,0.00001);
            END;
            */

        end;
        //+GL015

    end;

    procedure CreateDim(cNo: Code[20])
    var
        recDim: Record "349";
        recVorgabeDim: Record "352";
    begin

        //-GL016
        //Dimension  zuweisen      (Dimension muss vorhanden sein!)
        if COMPANYNAME = 'GL-PHARMA' then begin
            CLEAR(recVorgabeDim);
            recVorgabeDim.SETRANGE("Table ID", 27);
            recVorgabeDim.SETRANGE("No.", cNo);
            recVorgabeDim.SETRANGE("Dimension Code", 'TYP');
            recVorgabeDim.SETRANGE("Dimension Value Code", 'ARTIKEL');
            if not recVorgabeDim.FINDFIRST then begin
                //Noch keine zuweisung Vorhanden
                CLEAR(recVorgabeDim);
                recVorgabeDim.INIT;
                recVorgabeDim."Table ID" := 27;
                recVorgabeDim."No." := cNo;
                recVorgabeDim."Dimension Code" := 'TYP';
                recVorgabeDim."Dimension Value Code" := 'ARTIKEL';
                if recVorgabeDim.INSERT(true) = false then
                    MESSAGE('Dimension Zuweisung %1 konnte nicht angelegt werden!', cNo);
            end;
        end;
        //+GL016
    end;

    procedure DeleteDim(cNo: Code[20])
    var
        recDim: Record "349";
        recVorgabeDim: Record "352";
    begin

        //-GL016
        //Dimension löschen
        if COMPANYNAME = 'GL-PHARMA' then begin
            CLEAR(recVorgabeDim);
            recVorgabeDim.SETRANGE("Table ID", 27);
            recVorgabeDim.SETRANGE("No.", cNo);
            recVorgabeDim.SETRANGE("Dimension Code", 'TYP');
            recVorgabeDim.SETRANGE("Dimension Value Code", 'ARTIKEL');
            if recVorgabeDim.FINDFIRST then begin
                if recVorgabeDim.DELETE = false then
                    MESSAGE('Dimension Zuweisung %1 konnte nicht gelöscht werden!', cNo);
            end;
        end;
        //+GL016
    end;

    procedure LagerstandProduktionVorOrt(itemno: Code[20]) lagerstand: Decimal
    var
        recitem: Record "27";
        recManufacturingSetup: Record "99000765";
    begin
        //-GL017
        if recitem.GET(itemno) then begin
            if recManufacturingSetup.GET(recitem."Site Manufacturing") then;
            recitem.SETFILTER("Location Filter", recManufacturingSetup.LagerbestandProduktionVorOrt);
            recitem.CALCFIELDS(recitem.Inventory);
            lagerstand := recitem.Inventory;
        end;
        //+GL017
    end;

    /*procedure GetSerialisierungsdaten(var bSerialization: Boolean; var bDM2dCode: Boolean; var bPrint: Boolean)
    var
        recSeri: Record "50025";
        recBOMLine: Record "99000772";
        recBOMHeader: Record "99000771";
        recItem: Record "27";
        bBreak: Boolean;
    begin
        //-GL019
        //Ermitteln von Serialisierungsdaten zu Fertigartikel und Stücklistenartikeln

        CLEAR(recSeri);


        //Defaultwerte
        bSerialization := FALSE;
        bDM2dCode := FALSE;
        bPrint := FALSE;
        bBreak := FALSE;


        //Fertigartikel
        IF Artikelart = Artikelart::Fertigprodukt THEN
            IF recSeri.GET("No.") THEN
                IF recSeri.Status = recSeri.Status::Zertifiziert THEN BEGIN
                    bSerialization := recSeri.serialization;
                    bDM2dCode := recSeri."2d";
                    bPrint := recSeri.print;
                END;


        //Faltschachteln
        IF (Artikelart = Artikelart::Verpackungsstoff) AND ("Statistikcode II" = '1040') THEN BEGIN
            //Zertifizierte Stücklisten mit dieser FS suchen
            CLEAR(recBOMLine);
            CLEAR(recBOMHeader);
            recBOMLine.SETRANGE(Type, recBOMLine.Type::Item);
            recBOMLine.SETRANGE("No.", Rec."No.");
            IF recBOMLine.FINDFIRST THEN
                REPEAT
                    IF recBOMHeader.GET(recBOMLine."Production BOM No.") THEN
                        IF recBOMHeader.Status = recBOMHeader.Status::Certified THEN BEGIN
                            //Artikeln mit dieser Stückliste suchen
                            recItem.SETRANGE("Production BOM No.", recBOMHeader."No.");
                            recItem.SETRANGE(Blocked, FALSE);
                            IF recItem.FINDFIRST THEN
                                REPEAT
                                    IF recSeri.GET(recItem."No.") THEN
                                        IF recSeri.Status = recSeri.Status::Zertifiziert THEN BEGIN
                                            //Wenn schon einmal ein Typ gesetzt ist, nicht mehr abhaken lassen (Bei mehreren Artikeln reicht z.B. wenn einer Serialisiert wird)
                                            IF recSeri.serialization = TRUE THEN bSerialization := recSeri.serialization;
                                            IF recSeri."2d" = TRUE THEN bDM2dCode := recSeri."2d";
                                            IF recSeri.print = TRUE THEN bPrint := recSeri.print;
                                            IF bSerialization AND bDM2dCode AND bPrint THEN bBreak := TRUE;  //Mehr gesetzt kann nicht werden
                                        END;
                                UNTIL (recItem.NEXT = 0) OR (bBreak = TRUE);
                        END;
                UNTIL (recBOMLine.NEXT = 0) OR (bBreak = TRUE);
        END;

        //+GL019
    end;

   
    procedure GetArtikelHersteller() tReturnHersteller: Text
    var
        recAHK: Record "50093";
        tHelp: Text;
        cuCodesammlung: Codeunit "50500";
    begin
        //-GL020
        //Hersteller in der Artikel/Herstellerkarte in einen Text zusammensetzen und zurückliefern
        tReturnHersteller := '';
        tHelp := '';


        CLEAR(recAHK);
        recAHK.SETRANGE(Artikelnr, Rec."No.");
        recAHK.SETRANGE(Status, recAHK.Status::Frei);
        IF recAHK.FINDFIRST THEN
            REPEAT
                IF recAHK.HerstellerNr > '' THEN
                    IF cuCodesammlung.IsTextInTextTeil(tHelp, ';', recAHK.HerstellerNr) = FALSE THEN BEGIN   //Hersteller nicht doppelt eintragen
                        tReturnHersteller += recAHK.HerstellerNr + ', ';
                        tHelp += recAHK.HerstellerNr + ';';
                    END;
            UNTIL recAHK.NEXT = 0;

        IF STRLEN(tReturnHersteller) > 0 THEN
            tReturnHersteller := COPYSTR(tReturnHersteller, 1, STRLEN(tReturnHersteller) - 2);
        //+GL020
    end;
    */


}

