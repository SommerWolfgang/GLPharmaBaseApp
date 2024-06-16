tableextension 50033 BASManufacturingSetupExtPHA extends "Manufacturing Setup"
{// GL001 Felder
    // Feld "Backend Due Date" eingefügt. Komponentenfälligkeit wird dann der Fälligkeit des zu fertigenden Produkts gleichgesetzt.
    // GL002: Primärschlüssel editable, DataCaption (für Setup-Record je Standort)
    // 
    // Datum      | Autor   | Status     | Beschreibung
    // --------------------------------------------------------------------------------------------------------
    // 2010-01-15 | Petsch  | OK         | Update von 3.60
    // --------------------------------------------------------------------------------------------------------
    // 2010-09-14 | Petsch  | OK         | GL002: Primärschlüssel editable, DataCaption (für Setup-Record je Standort)
    // --------------------------------------------------------------------------------------------------------
    // 2010-10-22 | MFU     | OK         | Spate "dtWartungAngelegt" für Wartungsaufträge erstellen angelegt (Nur 1x pro Tag)
    // --------------------------------------------------------------------------------------------------------
    // 2010-12-03 | Petsch  | OK         | Feld Rohstoffchargennummern, PfadProbenEtiketten
    // --------------------------------------------------------------------------------------------------------
    // 2011-01-28 | Petsch  | OK         | Feld ProbenEtikettenDrucker, Probenetikettenpreview
    // --------------------------------------------------------------------------------------------------------
    // 2011-02-08 | Petsch  | OK         | Feld Lagerbestand vor Ort Filter
    // --------------------------------------------------------------------------------------------------------
    // 2012-04-11 | MFU     | OK         | Spate "dtWartungPruefmittelAngelegt" für Wartungsaufträge erstellen angelegt (Nur 1x pro Tag)
    // --------------------------------------------------------------------------------------------------------
    // 2013-02-05 | MFU     | OK         | Spate "PfadUmpackprotokoll" angelegt (Für eigene FA-Art)
    // --------------------------------------------------------------------------------------------------------
    // 2014-04-23 | Petsch  | ok         | Update von 2009 auf 2013R2
    // ------------------------------------------------------------------------------------------------------------------------------------
    // 2015-11-20 | MFU     | ok         | ChargenFreigabeLegende für Legende in Chargenfreigebe
    // ------------------------------------------------------------------------------------------------------------------------------------
    // 2016-09-16 | MFU     | ok         | Spalte "Materialgemeinkosten3_7EPMGK" eingebaut
    // ------------------------------------------------------------------------------------------------------------------------------------
    // 2017-04-10 | MFU     | ok         | Spalte "PfadPalettenetiketten" eingebaut
    // ------------------------------------------------------------------------------------------------------------------------------------
    // 2017-06-14 | MFU     | ok         | Spalte "LagerbestandProduktionVorOrt" eingebaut
    // ------------------------------------------------------------------------------------------------------------------------------------
    // 2018-08-17 | DKO     | ok         | Spalte "CmrLastUpdate" hinzugefügt.
    // ------------------------------------------------------------------------------------------------------------------------------------
    // 2019-01-14 | MFU     | ok         | 3 Spalten "var Gemainkosten" dazu.
    // ------------------------------------------------------------------------------------------------------------------------------------
    fields
    {
        field(50010; BASVorratslagerPHA; Text[30])
        {
        }
        field(50011; BASProduktionslagerPHA; Text[30])
        {
            Description = 'Petsch';
            TableRelation = Location.Code;
        }
        field(50014; BASMaterialgemeinkostensatzPHA; Decimal)
        {
            Description = 'Petsch';
        }
        field(50015; BASFertigungsgemeinkostensatzPHA; Decimal)
        {
            Description = 'Petsch';
        }
        field(50016; BASSchwundBulkPHA; Decimal)
        {
            Description = 'Petsch';
        }
        field(50017; BASSchwundFertigwarePHA; Decimal)
        {
            Description = 'Petsch';
        }
        field(50018; BASVerpackungsgemeinkostenPHA; Decimal)
        {
            Description = 'Petsch';
        }
        field(50019; BASPfadHerstellprotokollPHA; Text[150])
        {
            Description = 'Petsch';
        }
        field(50020; "BASBelegnr. ist Ch-Nr.PHA"; Boolean)
        {
            Description = 'Petsch';
        }
        field(50021; BASPfadKonfektionierungsprotokollPHA; Text[150])
        {
            Description = 'Petsch';
        }
        field(50022; BASHerstellprotokollDirektDruckenPHA; Boolean)
        {
            Description = 'Petsch';
        }
        field(50023; BASMaterialgemeinkosten2PHA; Decimal)
        {
            Description = 'Petsch';
        }
        field(50024; BASFertigungsgemeinkosten2PHA; Decimal)
        {
            Description = 'Petsch';
        }
        field(50025; BASVerpackungsgemeinkosten2PHA; Decimal)
        {
            Description = 'Petsch';
        }
        field(50026; BASLetzteChargenNrPHA; Integer)
        {
            Description = 'Petsch';
            MaxValue = 999;
            MinValue = 0;
        }
        field(50027; BASChargennummernsystemPHA; Option)
        {
            Description = 'Petsch';
            OptionMembers = Lannacher,Gerot;
        }
        field(50028; "BASVerp.-Schwundklasse 1PHA"; Decimal)
        {
            Description = 'Petsch';
        }
        field(50029; "BASVerp.-Schwundklasse 1 vonPHA"; Decimal)
        {
            Description = 'Petsch';
        }
        field(50030; "BASVerp.-Schwundklasse 1 bisPHA"; Decimal)
        {
            Description = 'Petsch';
        }
        field(50031; "BASVerp.-Schwundklasse 2PHA"; Decimal)
        {
            Description = 'Petsch';
        }
        field(50032; "BASVerp.-Schwundklasse 2 vonPHA"; Decimal)
        {
            Description = 'Petsch';
        }
        field(50033; "BASVerp.-Schwundklasse 2 bisPHA"; Decimal)
        {
            Description = 'Petsch';
        }
        field(50034; "BASVerp.-Schwundklasse 3PHA"; Decimal)
        {
            Description = 'Petsch';
        }
        field(50035; "BASVerp.-Schwundklasse 3 vonPHA"; Decimal)
        {
            Description = 'Petsch';
        }
        field(50036; "BASVerp.-Schwundklasse 3 bisPHA"; Decimal)
        {
            Description = 'Petsch';
        }
        field(50037; "BASVerp.-Bulk-Schwundklasse 1PHA"; Decimal)
        {
            Description = 'Petsch';
        }
        field(50038; "BASVerp.-Bulk-Schwundklasse 1 vonPHA"; Decimal)
        {
            Description = 'Petsch';
        }
        field(50039; "BASVerp.-Bulk-Schwundklasse 1 bisPHA"; Decimal)
        {
            Description = 'Petsch';
        }
        field(50040; "BASVerp.-Bulk-Schwundklasse 2PHA"; Decimal)
        {
            Description = 'Petsch';
        }
        field(50041; "BASVerp.-Bulk-Schwundklasse 2 vonPHA"; Decimal)
        {
            Description = 'Petsch';
        }
        field(50042; "BASVerp.-Bulk-Schwundklasse 2 bisPHA"; Decimal)
        {
            Description = 'Petsch';
        }
        field(50043; "BASVerp.-Bulk-Schwundklasse 3PHA"; Decimal)
        {
            Description = 'Petsch';
        }
        field(50044; "BASVerp.-Bulk-Schwundklasse 3 vonPHA"; Decimal)
        {
            Description = 'Petsch';
        }
        field(50045; "BASVerp.-Bulk-Schwundklasse 3 bisPHA"; Decimal)
        {
            Description = 'Petsch';
        }
        field(50050; "WaagePinVerschlüsselung"; Integer)
        {
            Description = 'Petsch';
            InitValue = 0;
            MaxValue = 10;
            MinValue = 0;
        }
        field(50051; "BASBackend Due DatePHA"; Boolean)
        {
            Caption = 'Komponentenfälligkeit ist FA-Enddatum';
            Description = 'Petsch';
        }
        field(50052; BASPlanungsauftragsnummerPHA; Code[10])
        {
            Description = 'Petsch';
            TableRelation = "No. Series";
            ValidateTableRelation = false;
        }
        field(50053; "BASVerp.-Schwundklasse 4PHA"; Decimal)
        {
            Description = 'Petsch';
        }
        field(50054; "BASVerp.-Schwundklasse 4 vonPHA"; Decimal)
        {
            Description = 'Petsch';
        }
        field(50055; "BASVerp.-Schwundklasse 4 bisPHA"; Decimal)
        {
            Description = 'Petsch';
        }
        field(50056; "BASVerp.-Schwundklasse 5PHA"; Decimal)
        {
            Description = 'Petsch';
        }
        field(50057; "BASVerp.-Schwundklasse 5 vonPHA"; Decimal)
        {
            Description = 'Petsch';
        }
        field(50058; "BASVerp.-Schwundklasse 5 bisPHA"; Decimal)
        {
            Description = 'Petsch';
        }
        field(50059; BASFremdChargenNrPHA; Code[20])
        {
            Description = 'Petsch';
            TableRelation = "No. Series".Code;
        }
        field(50060; BASFremdChNrProdBuchGruppePHA; Code[20])
        {
            Description = 'Petsch';
            TableRelation = "Gen. Product Posting Group".Code;
        }
        field(50061; BASPfadKartonetikettenPHA; Text[150])
        {
            Description = 'Petsch';
        }
        field(50062; "BASVerp.-Bulk-Schwundklasse 4PHA"; Decimal)
        {
            Description = 'Petsch';
        }
        field(50063; "BASVerp.-Bulk-Schwundklasse 4 vonPHA"; Decimal)
        {
            Description = 'Petsch';
        }
        field(50064; "BASVerp.-Bulk-Schwundklasse 4 bisPHA"; Decimal)
        {
            Description = 'Petsch';
        }
        field(50065; "BASVerp.-Bulk-Schwundklasse 5PHA"; Decimal)
        {
            Description = 'Petsch';
        }
        field(50066; "BASVerp.-Bulk-Schwundklasse 5 vonPHA"; Decimal)
        {
            Description = 'Petsch';
        }
        field(50067; "BASVerp.-Bulk-Schwundklasse 5 bisPHA"; Decimal)
        {
            Description = 'Petsch';
        }
        field(50068; BASdtWartungAngelegtPHA; Date)
        {
            Description = 'MFU';
        }
        field(50069; BASRohstoffchargennummernPHA; Code[10])
        {
            TableRelation = "No. Series";
        }
        field(50070; BASPfadProbenEtikettenPHA; Text[150])
        {
        }
        field(50071; BASProbenetikettenDruckerPHA; Text[150])
        {
        }
        field(50072; BASProbenetikettenPreviewPHA; Boolean)
        {
        }
        field(50073; BASInventorySiteFilterPHA; Code[50])
        {
        }
        field(50074; BASdtWartungPruefmittelAngelegtPHA; Date)
        {
            Description = 'MFU';
        }
        field(50075; BASPfadKonfektionierungsFuellkontPHA; Text[200])
        {
            Description = 'Petsch';
        }
        field(50076; BASPfadUmpackprotokollPHA; Text[200])
        {
            Description = 'MFU';
        }
        field(50077; BASPfadRohstoffPruefBerichtPHA; Text[200])
        {
        }
        field(50078; BASChargenFreigabeLegendePHA; BLOB)
        {
            SubType = Bitmap;
        }
        field(50079; BASMaterialgemeinkosten3_7EPMGKPHA; Decimal)
        {
            Description = 'MFU';
        }
        field(50080; BASPfadPalettenetikettenPHA; Text[200])
        {
            Description = 'MFU';
        }
        field(50081; BASLagerbestandProduktionVorOrtPHA; Code[40])
        {
            Description = 'MFU';
        }
        field(50082; BASCmrLastUpdatePHA; DateTime)
        {
        }
        field(50083; "BASVariable-8GK HW-MGKPHA"; Decimal)
        {
        }
        field(50084; "BASVariable-7EP HW-MGKPHA"; Decimal)
        {
        }
        field(50085; "BASVariable-9HK HW-MGKPHA"; Decimal)
        {
        }
    }
}
