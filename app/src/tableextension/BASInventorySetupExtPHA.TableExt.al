tableextension 50031 BASInventorySetupExtPHA extends "Inventory Setup"
{// LAN001 25.11.09 ACPSS LAN1.00
    //   New Fields: ID 50500 - 50504
    // 
    // Felder: Etikettenanzahl, EK-kein Art.lief.preis-Warnung,
    //         Konsignationslagerortcode, -fach, Etikettendrucker
    //         "Kommschein": welcher Bericht soll gedruckt werden
    //         "LS Kopie bei Kommiss."
    //                   Falls eine zusätzliche Kopie des Lieferscheins aus Kommissionierung gewünscht ist, kann hier
    //                   der Bericht angegeben werden.
    //         "Bereitstellungslagerortcode":
    //                    Wird hier ein Lager eingetragen, holt die Bereitstellung nur von dort Chargen
    //         Lagerbestand vor Ort Filter
    //         Etikettendrucker: Option Thermotransferdrucker eingefügt
    // 
    // 
    // ------------------------------------------------------------------------------------------------------------------------------------
    // Datum      | Autor   | Status     | Beschreibung
    // ------------------------------------------------------------------------------------------------------------------------------------
    // 2010-02-05 | Petsch  | ok         | Update von 3.60
    // ------------------------------------------------------------------------------------------------------------------------------------
    // 2020-01-14 | MFU     | ok         | Bereitstellungslagerort ohne Table Relation
    // ------------------------------------------------------------------------------------------------------------------------------------
    fields
    {
        field(50000; "BASSortierung KommissionierungPHA"; Option)
        {
            OptionCaption = 'Lagerzone-Artikelnr.,Artikelnr.,Lagerzone-Artikelname,Artikelname';
            OptionMembers = "Lagerzone-Artikelnr.","Artikelnr.","Lagerzone-Artikelname",Artikelname;
        }
        field(50001; BASEtikettendruckPHA; Option)
        {
            Caption = 'Label Printing';
            Description = 'Petsch';
            OptionCaption = 'at shipment,at picking-list';
            OptionMembers = "bei Lieferschein","bei Kommissionierschein";
        }
        field(50002; BASEtikettenstilPHA; Option)
        {
            Description = 'Petsch';
            OptionCaption = 'with company-header,without company header';
            OptionMembers = "mit Firmenkopf","ohne Firmenkopf";
        }
        field(50003; BASEtikettenanzahlPHA; Integer)
        {
            Description = 'Petsch';
        }
        field(50004; "BASEK-Warnung kein Art.lief.preisPHA"; Boolean)
        {
            Description = 'Petsch';
        }
        field(50005; BASEtikettendruckerPHA; Option)
        {
            Description = 'Petsch';
            OptionMembers = Matrixdrucker,Laserdrucker,Thermotransferdrucker;
        }
        field(50006; "BASPacking List Nos.PHA"; Code[10])
        {
            Description = 'Petsch';
            TableRelation = "No. Series";
        }
        field(50500; BASSuchtgiftlagerortcodePHA; Code[10])
        {
            Description = 'LAN1.00';
            TableRelation = Location;
        }
        field(50501; BASVerkaufslagerortcodePHA; Code[10])
        {
            Description = 'LAN1.00';
            TableRelation = Location;
        }
        field(50502; BASRohstoffchargennummernPHA; Code[10])
        {
            Description = 'LAN1.00';
            TableRelation = "No. Series";
        }
        field(50503; BASKonsignationslagerortcodePHA; Code[10])
        {
            Description = 'LAN1.00';
            TableRelation = Location;
        }
        field(50504; BASKonsignationslagerfachcodePHA; Code[10])
        {
            Description = 'LAN1.00';
            TableRelation = Bin.Code where("Location Code" = FIELD(Konsignationslagerortcode));
        }
        field(50505; "BASLagerbestand vor Ort FilterPHA"; Code[20])
        {
            Description = 'Petsch';
        }
        field(50506; "BASLS Kopie bei Kommiss.PHA"; Integer)
        {
            Description = 'Petsch';
            InitValue = 0;
            TableRelation = AllObj."Object ID" where("Object Type" = const(Report));
        }
        field(50507; BASBereitstellungslagerortcodePHA; Code[10])
        {
            Description = 'Petsch';
        }
        field(50508; BASKommscheinPHA; Integer)
        {
            Caption = 'KommscheinObjekt';
            Description = 'Petsch';
            InitValue = 0;
            TableRelation = AllObj."Object ID" where("Object Type" = const("Report"));
        }
    }
}