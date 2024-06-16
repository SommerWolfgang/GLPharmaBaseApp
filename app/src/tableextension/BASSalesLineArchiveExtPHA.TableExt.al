tableextension 50047 BASSalesLineArchiveExtPHA extends "Sales Line Archive"
{
    fields
    {
        field(50000; BASSubsetPHA; Decimal)
        {
            Caption = 'Subset', comment = 'DEA="Teilmenge"';
            DecimalPlaces = 0 : 5;
        }
        field(50003; BASSubsetShippedPHA; Decimal)
        {
            Caption = 'Subset shipped', comment = 'DEA="Teilmenge geliefert"';
            DecimalPlaces = 0 : 5;
        }
        field(50005; BASDiscoutProcPHA; Decimal)
        {
            Caption = 'Discount %', comment = 'DEA="Abzug %"';
            DecimalPlaces = 0 : 5;
        }
        field(50006; BASAbzugsbetragPHA; Decimal)
        {
            Caption = 'Discount Amount', comment = 'DEA="Abzugsbetrag"';
        }
        field(50010; BASLotNoPHA; Code[20])
        {
            Caption = 'Lot No.', comment = 'DEA="Serialno."';
            TableRelation = if (Type = const(Item)) "Lot No. Information".BASLotNoPHA where("Item No." = field("No."),
                                                                                         "Variant Code" = field("Variant Code"));
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
        field(50510; "BASZuordnung zu Artikelnr.PHA"; Code[20])
        {

            TableRelation = Item;
        }
        field(50511; BASValueCorrItemLedgEntryPHA; Integer)
        {
            Caption = 'Value Corr. Item Ledg. Entry', comment = 'DEA="Wertkorrektur zu Artikelposten"';

        }
        field(50512; "BASCountry/Region CodePHA"; Code[10])
        {
            Caption = 'Country/Region Code';

            TableRelation = "Country/Region";
        }
        field(50513; BASNaturalrabattmengePHA; Decimal)
        {
            DecimalPlaces = 0 : 5;

        }
        field(50514; "BASRebate in kind shippedPHA"; Decimal)
        {
            Caption = '', comment = 'DEA=" Naturalrabattmenge geliefert"';
            DecimalPlaces = 0 : 5;
        }
        field(50515; BASSalesStatisticCode2PHA; Code[10])
        {
        }
        field(50516; "BASExpiration DatePHA"; Date)
        {
            Caption = 'Expiration Date';

        }
        field(50517; "BASSuchtgift/PsychotropPHA"; Text[1])
        {

        }
        field(50519; "BASVerkaufschargennr.PHA"; Code[20])
        {

        }
        field(50600; BASHervorhebenPHA; Boolean)
        {

        }
        field(50601; "BASOrder DatePHA"; Date)
        {
            Caption = 'Order Date';

        }
    }
}
