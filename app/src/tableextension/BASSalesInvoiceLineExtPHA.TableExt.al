tableextension 50029 BASSalesInvoiceLineExtPHA extends "Sales Invoice Line"
{
    fields
    {
        field(50000; BASTeilmengePHA; Decimal)
        {
            DecimalPlaces = 0 : 5;
            Description = 'LAN1.00';
        }
        field(50005; "BASAbzug %PHA"; Decimal)
        {
            DecimalPlaces = 0 : 5;
            Description = 'LAN1.00';
        }
        field(50006; BASAbzugsbetragPHA; Decimal)
        {
            Description = 'LAN1.00';
        }
        field(50010; "BASLot No.PHA"; Code[20])
        {
            Caption = 'Lot No.';
            Description = 'LAN1.00';
            TableRelation = if (Type = const(Item)) "Lot No. Information"."Lot No." where("Item No." = field("No."),
                                                                                         "Variant Code" = field("Variant Code"));
        }
        field(50014; "Zugehörigkeitsdatum"; Date)
        {
        }
        field(50506; BASArtikelgruppePHA; Code[10])
        {
            Description = 'LAN1.00';
            Editable = false;
            //GLDE nciht benötigt TableRelation = IF (Type=const(Item)) Table50502.Field2 where (Field1=const(0));
        }
        field(50507; "BASStatistikcode IPHA"; Code[10])
        {
            Description = 'LAN1.00';
            Editable = false;
            TableRelation = BASStatisticcodePHA where(Level = const(1));
        }
        field(50508; "BASStatistikcode IIPHA"; Code[10])
        {
            Description = 'LAN1.00';
            Editable = false;
            TableRelation = BASStatisticcodePHA where(Level = const(2));
        }
        field(50509; "BASStatistikcode IIIPHA"; Code[10])
        {
            Description = 'LAN1.00';
            Editable = false;
            TableRelation = BASStatisticcodePHA where(Level = const(3));
        }
        field(50510; BASAssignToItemNoPHA; Code[20])
        {
            TableRelation = Item;
        }
        field(50511; "BASWertkorrektur zu ArtikelpostenPHA"; Integer)
        {
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
        field(50515; BASVerkaufsstatistikcodePHA; Code[10])
        {
            Description = 'LAN1.00';
            //GLDE nicht benötigt TableRelation = IF (Type=const(Item)) Table50502.Field2 where (Field1=const(3));
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