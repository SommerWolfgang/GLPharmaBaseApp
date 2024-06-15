tableextension 50047 BASSalesLineArchivePHA extends "Sales Line Archive"
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
            TableRelation = if (Type = const(Item)) "Lot No. Information"."Lot No." where("Item No." = field("No."),
                                                                                         "Variant Code" = field("Variant Code"));
        }
        field(50506; BASArtikelgruppePHA; Code[10])
        {
            Editable = false;
        }
        field(50507; "BASStatistikcode IPHA"; Code[10])
        {
            Editable = false;
            TableRelation = BASStatistikcode2PHA where(Level = const(1));
        }
        field(50508; "BASStatistikcode IIPHA"; Code[10])
        {
            Editable = false;
            TableRelation = BASStatistikcode2PHA where(Level = const(2));
        }
        field(50509; "BASStatistikcode IIIPHA"; Code[10])
        {
            Editable = false;
            TableRelation = BASStatistikcode2PHA where(Level = const(3));
        }
        field(50510; "BASZuordnung zu Artikelnr.PHA"; Code[20])
        {
            Description = 'LAN1.00';
            TableRelation = Item;
        }
        field(50511; "Value Corr. Item Ledg. Entry"; Integer)
        {
            Caption = 'Value Corr. Item Ledg. Entry', comment = 'DEA="Wertkorrektur zu Artikelposten"';
            Description = 'LAN1.00';
        }
        field(50512; "BASCountry/Region CodePHA"; Code[10])
        {
            Caption = 'Country/Region Code';
            Description = 'LAN1.00';
            TableRelation = "Country/Region";
        }
        field(50513; BASNaturalrabattmengePHA; Decimal)
        {
            DecimalPlaces = 0 : 5;
            Description = 'LAN1.00';
        }
        field(50514; "Rebate in kind shipped"; Decimal)
        {
            Caption = '', comment = 'DEA=" Naturalrabattmenge geliefert"';
            DecimalPlaces = 0 : 5;
        }
        field(50515; BASVerkaufsstatistikcodePHA; Code[10])
        {
            Description = 'LAN1.00';
        }
        field(50516; "BASExpiration DatePHA"; Date)
        {
            Caption = 'Expiration Date';
            Description = 'LAN1.00';
        }
        field(50517; "BASSuchtgift/PsychotropPHA"; Text[1])
        {
            Description = 'LAN1.00';
        }
        field(50519; "BASVerkaufschargennr.PHA"; Code[20])
        {
            Description = 'LAN1.00';
        }
        field(50600; BASHervorhebenPHA; Boolean)
        {
            Description = 'LAN1.00';
        }
        field(50601; "BASOrder DatePHA"; Date)
        {
            Caption = 'Order Date';
            Description = 'LAN1.00';
        }
    }
}
