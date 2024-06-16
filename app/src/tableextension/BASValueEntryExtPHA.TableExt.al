tableextension 50032 BASValueEntryExtPHA extends "Value Entry"
{
    fields
    {
        field(50000; "BASLot No.PHA"; Code[50])
        {
            CalcFormula = lookup("Item Ledger Entry"."Lot No." where("Entry No." = field("Item Ledger Entry No.")));
            Caption = 'Lot No.';
            FieldClass = FlowField;
        }
        field(50001; "BASEK-Betrag (tats.)PHA"; Decimal)
        {
            Description = 'Petsch';
        }
        field(50002; "BASEK-Betrag (erw.)PHA"; Decimal)
        {
            Description = 'Petsch';
        }
        field(50506; BASArtikelgruppePHA; Code[10])
        {
            Description = 'LAN1.00';
            Editable = false;
        }
        field(50507; "BASStatistikcode IPHA"; Code[10])
        {
            Description = 'LAN1.00';
            Editable = false;
            TableRelation = BASStatisticCodePHA where(Level = const(1));
        }
        field(50508; "BASStatistikcode IIPHA"; Code[10])
        {
            Description = 'LAN1.00';
            Editable = false;
            TableRelation = BASStatisticCodePHA where(Level = const(2));
        }
        field(50509; "BASStatistikcode IIIPHA"; Code[10])
        {
            Description = 'LAN1.00';
            Editable = false;
            TableRelation = BASStatisticCodePHA where(Level = const(3));
        }
        field(50510; "Fremdwährung"; Code[10])
        {
            Description = 'LAN1.00';
        }
        field(50511; "BASBetrag (FW)PHA"; Decimal)
        {
            Description = 'LAN1.00';
        }
        field(50512; "BASBestellnr.PHA"; Code[20])
        {
            Description = 'LAN1.00';
        }
        field(50513; BASBestelldatumPHA; Date)
        {
            Description = 'LAN1.00';
        }
        field(50514; BASVerkaufsstatistikcodePHA; Code[10])
        {
            Description = 'LAN1.00';
        }
        field(50515; "BASCountry/Region CodePHA"; Code[10])
        {
            Caption = 'Country/Region Code';
            Description = 'LAN1.00';
            TableRelation = "Country/Region";
        }
        field(50516; BASNaturalrabattmengePHA; Decimal)
        {
            DecimalPlaces = 0 : 5;
            Description = 'LAN1.00';
        }
        field(50552; BASDraftShipmentPHA; Boolean)
        {
        }
        field(50553; BASDrugNoPHA; Code[20])
        {
            CalcFormula = lookup(Item.BASDrugNoPHA where("No." = field("Item No.")));
            FieldClass = FlowField;
        }
    }
    procedure SetValueEntryCustomerFilter(var ValueEntry: Record "Value Entry")
    var
        sFilter: Text[100];
    begin
        Evaluate(sFilter, ValueEntry.GetFilter("Source No."));

        if StrLen(sFilter) > 0 then
            Evaluate(sFilter, '(' + sFilter + ') & ');
        sFilter += '<50004';

        ValueEntry.SetFilter("Source No.", sFilter);
    end;
}