
table 50010 BASLotSerialNoInformationPHA
{
    Caption = 'Lot Serial No. Information', comment = 'DEA=" Information Chargennummer"';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Item No."; Code[20])
        {
            Caption = 'Item No.', comment = 'DEA="Artikelnr."';
            NotBlank = true;
            TableRelation = Item;
        }
    }
}