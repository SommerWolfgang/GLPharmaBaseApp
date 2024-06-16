tableextension 50037 BASSalesCrMemoLineExtPHA extends "Sales Cr.Memo Line"
{
    fields
    {
        field(50000; BASTeilmengePHA; Decimal)
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

            TableRelation = if (Type = const(Item)) "Lot No. Information"."Lot No."
                where("Item No." = field("No."), "Variant Code" = field("Variant Code"));
        }
        field(50011; BASAssignShipmentPHA; Code[20])
        {
        }
        field(50014; BASAssignDatePHA; Date)
        {
        }
        field(50506; BASArtikelgruppePHA; Code[10])
        {
            Editable = false;
        }
        field(50507; "BASStatistikcode IPHA"; Code[10])
        {
            Editable = false;
            TableRelation = BASStatisticCodePHA where(Level = const(1));
        }
        field(50508; "BASStatistikcode IIPHA"; Code[10])
        {
            Editable = false;
            TableRelation = BASStatisticCodePHA where(Level = const(2));
        }
        field(50509; "BASStatistikcode IIIPHA"; Code[10])
        {
            Editable = false;
            TableRelation = BASStatisticCodePHA where(Level = const(3));
        }
        field(50510; "BASZuordnung zu Artikelnr.PHA"; Code[20])
        {
            TableRelation = Item;
        }
        field(50511; BASValueCorItemLedgEntryPHA; Integer)
        {
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
        field(50515; BASVerkaufsstatistikcodePHA; Code[10])
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
    }
}