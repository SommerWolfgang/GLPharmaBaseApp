tableextension 50055 BASPurchInvLineExtPHA extends "Purch. Inv. Line"
{
    fields
    {
        field(50000; BASPreisfaktorPHA; Decimal)
        {
            DataClassification = CustomerContent;
            Description = 'LAN1.00';
        }
        field(50001; BASPackmittelversionPHA; Code[20])
        {
            DataClassification = CustomerContent;
            Description = 'Petsch';
        }
        field(50005; BASHerstellerNrPHA; Code[20])
        {
            DataClassification = CustomerContent;
            // TableRelation = "IF (Type=const(Item)) Artikel-HerstellerArtikel.HerstellerNr where (ArtikelNameZusatz=FIELD(No.), LieferantNr=FIELD(Buy-from Vendor No.))";
            Description = 'MFU';
        }
        field(50010; "BASLot No.PHA"; Code[20])
        {
            Caption = 'Lot No.';
            DataClassification = CustomerContent;
            Description = 'LAN1.00';
            TableRelation = IF (Type = const(Item)) "Lot No. Information"."Lot No." where("Item No." = FIELD("No."), "Variant Code" = FIELD("Variant Code"));
        }
        field(50506; BASArtikelgruppePHA; Code[10])
        {
            DataClassification = CustomerContent;
            //TableRelation = IF (Type=const(Item)) Table50502.Field2 where (Field1=const(0));
            Description = 'LAN1.00';
            Editable = false;
        }
        field(50507; "BASStatistikcode IPHA"; Code[10])
        {
            DataClassification = CustomerContent;
            Description = 'LAN1.00';
            Editable = false;
            TableRelation = BASStatisticCodePHA where(Level = const(1));
        }
        field(50508; "BASStatistikcode IIPHA"; Code[10])
        {
            DataClassification = CustomerContent;
            Description = 'LAN1.00';
            Editable = false;
            TableRelation = BASStatisticCodePHA where(Level = const(2));
        }
        field(50509; "BASStatistikcode IIIPHA"; Code[10])
        {
            DataClassification = CustomerContent;
            Description = 'LAN1.00';
            Editable = false;
            TableRelation = BASStatisticCodePHA where(Level = const(3));
        }
        field(50510; "BASCountry/Region CodePHA"; Code[10])
        {
            Caption = 'Country/Region Code';
            DataClassification = CustomerContent;
            Description = 'LAN1.00';
            TableRelation = "Country/Region";
        }
        field(50514; "BASSuchtgift/PsychotropPHA"; Text[1])
        {
            DataClassification = CustomerContent;
            Description = 'LAN1.00';
        }
        field(50515; "BASDirect Unit Cost PEPHA"; Decimal)
        {
            AutoFormatType = 2;
            Caption = 'Direct Unit Cost PE';
            DataClassification = CustomerContent;
            Description = 'LAN1.00';

        }
        field(50526; "BASLieferantenchargennr.PHA"; Code[20])
        {
            DataClassification = CustomerContent;
            Description = 'LAN1.00';
        }
        field(50528; "BASVerkaufschargennr.PHA"; Code[20])
        {
            DataClassification = CustomerContent;
            Description = 'LAN1.00';
        }
        field(50529; "BASUrspr. MengePHA"; Decimal)
        {
            DataClassification = CustomerContent;
            DecimalPlaces = 0 : 5;
            Description = 'LAN1.00';
        }
        field(50530; "BASExpiration DatePHA"; Date)
        {
            Caption = 'Expiration Date';
            DataClassification = CustomerContent;
            Description = 'LAN1.00';
        }
        field(50550; BASGebindeanzahlPHA; Decimal)
        {
            DataClassification = CustomerContent;
            DecimalPlaces = 0 : 5;
            Description = 'LAN1.00';
        }
        field(50551; BASGebindeartencodePHA; Code[10])
        {
            DataClassification = CustomerContent;
            //TableRelation = "Gebindeart";
            Description = 'LAN1.00';
        }
        field(50580; "BASZuordnung zu Artikelnr.PHA"; Code[20])
        {
            DataClassification = CustomerContent;
            Description = 'LAN1.00';
        }
        field(50581; "BASZuordnung zu ArtikelpostenPHA"; Integer)
        {
            DataClassification = CustomerContent;
            Description = 'LAN1.00';
        }
        field(50582; BASBuchungsdatumPHA; Date)
        {
            DataClassification = CustomerContent;
            Description = 'LAN1.00';
        }
    }
}
