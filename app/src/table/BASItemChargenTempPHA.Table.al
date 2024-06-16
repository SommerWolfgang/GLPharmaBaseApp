table 50012 BASItemChargenTempPHA
{
    Caption = 'ItemChargenTemp', comment = 'DEA="Artikelchargen Temp"';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "User ID"; Code[50])
        {
            Caption = 'User ID', comment = 'DEA="Benutzer ID"';
            DataClassification = EndUserIdentifiableInformation;
            TableRelation = User."User Name";
        }
        field(2; "Item No."; Code[20])
        {
            Caption = 'Item No.', comment = 'DEA="Artikelnr."';
            TableRelation = Item;
        }
        field(3; BASLotNoPHA; Code[20])
        {
            Caption = 'Lot No.', comment = 'DEA="Chargennr."';
        }
        field(4; "Item Type"; Enum BASItemTypePHA)
        {
            Caption = 'Item Type', comment = 'DEA="Artikelart"';
        }
        // field(5; "BASStatisticCode2PHA I"; Code[10])
        // {
        //     TableRelation = BASStatisticCode2PHA.Code where(Level = const(1));
        // }
        // field(6; "BASStatisticCode2PHA II"; Code[10])
        // {
        //     TableRelation = BASStatisticCode2PHA.Code where(Level = const(2));
        // }
        // field(7; "BASStatisticCode2PHA III"; Code[10])
        // {
        //     TableRelation = BASStatisticCode2PHA.Code where(Level = const(3));
        // }
        field(8; "SG/PSY"; Boolean)
        {
        }
        field(9; Produktbuchungsgruppe; Code[10])
        {
            TableRelation = "Gen. Product Posting Group";
            ValidateTableRelation = false;
        }
        field(10; "Item Description"; Text[100])
        {
            Caption = 'Item Description', comment = 'DEA="Artikelbeschreibung"';
        }
        field(11; "Item blocked"; Boolean)
        {
            Caption = 'Item blocked', comment = 'DEA="Artikel gesperrt"';
        }
        field(12; bHideEntry; Boolean)
        {
            Caption = 'Artikel/Chargen Mit Lagerstand';
        }
        field(13; "Inventory Posting Group"; Code[10])
        {
            Caption = 'Inventory Posting Group', comment = 'DEA="Lagerbuchungssgruppe"';
            TableRelation = "Inventory Posting Group";
            ValidateTableRelation = false;
        }
    }

    keys
    {
        key(Key1; "User ID", "Item No.", BASLotNoPHA)
        {
        }
    }
}