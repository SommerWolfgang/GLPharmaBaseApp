tableextension 50056 BASPurchCrMmoLineExtPHA extends "Purch. Cr. Memo Line"
{
    fields
    {
        field(50000; BASPreisfaktorPHA; Decimal)
        {
            DataClassification = CustomerContent;

        }
        field(50001; BASPackmittelVersionPHA; Code[20])
        {
            DataClassification = CustomerContent;

        }
        field(50005; BASHerstellerNrPHA; Code[20])
        {
            DataClassification = CustomerContent;
            //TableRelation = "IF (Type=const(Item)) Artikel-HerstellerArtikel.HerstellerNr where (ArtikelNameZusatz=FIELD(No.), LieferantNr=FIELD(Buy-from Vendor No.))";

        }
        field(50010; "BASLot No.PHA"; Code[20])
        {
            Caption = 'Lot No.';
            DataClassification = CustomerContent;

            TableRelation = IF (Type = const(Item)) "Lot No. Information"."Lot No." where("Item No." = FIELD("No."), "Variant Code" = FIELD("Variant Code"));
        }
        field(50506; BASArtikelgruppePHA; Code[10])
        {
            DataClassification = CustomerContent;
            //TableRelation = "IF (Type=const(Item)) Table50502.Field2 where (Field1=const(0))";

            Editable = false;
        }
        field(50507; "BASStatistikcode IPHA"; Code[10])
        {
            DataClassification = CustomerContent;

            Editable = false;
            TableRelation = BASStatisticCodePHA where(Level = const(1));
        }
        field(50508; "BASStatistikcode IIPHA"; Code[10])
        {
            DataClassification = CustomerContent;

            Editable = false;
            TableRelation = BASStatisticCodePHA where(Level = const(2));
        }
        field(50509; "BASStatistikcode IIIPHA"; Code[10])
        {
            DataClassification = CustomerContent;

            Editable = false;
            TableRelation = BASStatisticCodePHA where(Level = const(3));
        }
        field(50510; "BASCountry/Region CodePHA"; Code[10])
        {
            Caption = 'Country/Region Code';
            DataClassification = CustomerContent;

            TableRelation = "Country/Region";
        }
        field(50514; "BASSuchtgift/PsychotropPHA"; Text[1])
        {
            DataClassification = CustomerContent;

        }
        field(50515; "BASDirect Unit Cost PEPHA"; Decimal)
        {
            AutoFormatType = 2;
            Caption = 'Direct Unit Cost PE';
            DataClassification = CustomerContent;

        }
        field(50526; "BASLieferantenchargennr.PHA"; Code[20])
        {
            DataClassification = CustomerContent;

        }
        field(50528; "BASVerkaufschargennr.PHA"; Code[20])
        {
            DataClassification = CustomerContent;

        }
        field(50529; "BASUrspr. MengePHA"; Decimal)
        {
            DataClassification = CustomerContent;
            DecimalPlaces = 0 : 5;

        }
        field(50530; "BASExpiration DatePHA"; Date)
        {
            Caption = 'Expiration Date';
            DataClassification = CustomerContent;

        }
        field(50550; BASGebindeanzahlPHA; Decimal)
        {
            DataClassification = CustomerContent;
            DecimalPlaces = 0 : 5;

        }
        field(50551; BASGebindeartencodePHA; Code[10])
        {
            DataClassification = CustomerContent;

        }
        field(50582; BASBuchungsdatumPHA; Date)
        {
            DataClassification = CustomerContent;

        }
        field(50583; BASAssignItemLedgerEntryPHA; Integer)
        {
            DataClassification = CustomerContent;

        }
        field(50584; "BASZuordnung zu Artikelnr.PHA"; Code[20])
        {
            DataClassification = CustomerContent;

            TableRelation = "Item";
        }
    }
}
