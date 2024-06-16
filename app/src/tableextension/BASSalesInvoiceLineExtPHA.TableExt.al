tableextension 50029 BASSalesInvoiceLineExtPHA extends "Sales Invoice Line"
{
    fields
    {
        field(50000; BASSubSetQuantityPHA; Decimal)
        {
            DecimalPlaces = 0 : 5;
        }
        field(50005; BASDiscountProcPHA; Decimal)
        {
            DecimalPlaces = 0 : 5;
        }
        field(50006; BASDiscountAmountPHA; Decimal)
        {
        }
        field(50010; BASLotNoPHA; Code[20])
        {
            Caption = 'Lot No.';
            TableRelation = if (Type = const(Item)) "Lot No. Information"."Lot No." where("Item No." = field("No."),
                                                                                         "Variant Code" = field("Variant Code"));
        }
        field(50014; BASAssignDatePHA; Date)
        {
        }
        field(50506; BASItemGroupPHA; Code[10])
        {
            Editable = false;
        }
        field(50507; BASStatistikcodeIPHA; Code[10])
        {
            Editable = false;
            TableRelation = BASStatisticcodePHA where(Level = const(1));
        }
        field(50508; BASStatistikcodeIIPHA; Code[10])
        {

            Editable = false;
            TableRelation = BASStatisticcodePHA where(Level = const(2));
        }
        field(50509; BASStatistikcodeIIIPHA; Code[10])
        {

            Editable = false;
            TableRelation = BASStatisticcodePHA where(Level = const(3));
        }
        field(50510; BASAssignToItemNoPHA; Code[20])
        {
            TableRelation = Item;
        }
        field(50511; BASValueCorrItemLedgEntryPHA; Integer)
        {

        }
        field(50512; BASCountryRegionCodePHA; Code[10])
        {
            Caption = 'Country/Region Code';
            TableRelation = "Country/Region";
        }
        field(50513; BASNaturalrabattmengePHA; Decimal)
        {
            DecimalPlaces = 0 : 5;
        }
        field(50515; BASSalesStatisticCodePHA; Code[10])
        {
        }
        field(50516; BASExpirationDatePHA; Date)
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
    keys
    {
        key(Key8; BASAssignToItemNoPHA)
        {
        }
    }
    procedure GetPackageSize(): Code[10]
    var
        Item: Record Item;
    begin
        case Type of
            Type::Item:
                if Item.Get("No.") then
                    exit(Item.BASPackageSizePHA);
            Type::"G/L Account",
            Type::"Charge (Item)":
                if Item.Get(BASAssignToItemNoPHA) then
                    exit(Item.BASPackageSizePHA);
        end;
    end;
}