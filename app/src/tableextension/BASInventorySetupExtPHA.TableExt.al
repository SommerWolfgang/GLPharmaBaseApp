tableextension 50031 BASInventorySetupExtPHA extends "Inventory Setup"
{
    fields
    {
        // ToDo Enum SortingCommission
        field(50000; BASSortingCommissionPHA; Option)
        {
            OptionCaption = 'Lagerzone-Artikelnr.,Artikelnr.,Lagerzone-Artikelname,Artikelname';
            OptionMembers = "Lagerzone-Artikelnr.","Artikelnr.","Lagerzone-Artikelname",Artikelname;
        }
        field(50001; BASEtikettendruckPHA; Option)
        {
            Caption = 'Label Printing';

            OptionCaption = 'at shipment,at picking-list';
            OptionMembers = "bei Lieferschein","bei Kommissionierschein";
        }
        field(50002; BASEtikettenstilPHA; Option)
        {

            OptionCaption = 'with company-header,without company header';
            OptionMembers = "mit Firmenkopf","ohne Firmenkopf";
        }
        field(50003; BASEtikettenanzahlPHA; Integer)
        {

        }
        field(50004; BASPuWarningtemShippricePHA; Boolean) //EK-Warnung kein Art.lief.preis
        {
            Caption = 'Purch-Warning missing Item Ship price';
        }
        // ToDo Enum
        field(50005; BASEtikettendruckerPHA; Option)
        {
            OptionMembers = Matrixdrucker,Laserdrucker,Thermotransferdrucker;
        }
        field(50006; "BASPacking List Nos.PHA"; Code[10])
        {
            TableRelation = "No. Series";
        }
        field(50500; BASSuchtgiftlagerortcodePHA; Code[10])
        {

            TableRelation = Location;
        }
        field(50501; BASVerkaufslagerortcodePHA; Code[10])
        {

            TableRelation = Location;
        }
        field(50502; BASRohstoffchargennummernPHA; Code[10])
        {

            TableRelation = "No. Series";
        }
        field(50503; BASConslagerortcodePHA; Code[10])
        {
            Caption = '', comment = 'DEA="YourLanguageText"';
            TableRelation = Location;
        }
        field(50504; BASConsLocationCodePHA; Code[10]) //Konsignationslagerfachcode
        {
            TableRelation = Bin.Code where("Location Code" = field(BASConslagerortcodePHA));
        }
        field(50505; BASSiteInventoryFilterPHA; Code[20]) //Lagerbestand vor Ort Filter
        {
        }
        field(50506; BASCopyByCommissionPHA; Integer) //LS Kopie bei Kommiss.
        {
            InitValue = 0;
            TableRelation = AllObj."Object ID" where("Object Type" = const(Report));
        }
        field(50507; BASAllocationCodePHA; Code[10]) //Bereitstellungslagerortcode
        {
        }
        field(50508; BASKommscheinPHA; Integer)
        {
            Caption = 'KommscheinObjekt';

            InitValue = 0;
            TableRelation = AllObj."Object ID" where("Object Type" = const("Report"));
        }
    }
}
