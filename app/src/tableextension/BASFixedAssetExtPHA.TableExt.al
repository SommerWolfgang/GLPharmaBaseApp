tableextension 50049 BASFixedAssetExtPHA extends "Fixed Asset"
{
    fields
    {
        Modify("No.")
        {
            trigger OnAfterValidate()
            var
                FASetup: Record "FA Setup";
            begin
                FASetup.Get();
                if FASetup.BASKontoNrLogikPHA = FASetup.BASKontoNrLogikPHA::"5 Stellen der Anlagenr" then
                    BASAccountNoPHA := CopyStr("No.", 1, 5);
            end;
        }
        field(50001; BASQuantityPHA; Decimal)
        {
            Caption = 'Quantity', comment = 'DEA="Menge"';
        }
        field(50002; BASAccountNoPHA; Text[10])
        {
            Caption = 'Account No.', comment = 'DEA="Konto Nr."';
        }
        field(50005; BASRentPHA; Boolean)
        {
            Caption = 'Rent', comment = 'DEA="Miete"';
        }
        field(50006; BASAdvancementPHA; Text[30])
        {
            Caption = 'Advancement', comment = 'DEA="Förderung"';
        }
        field(50007; BASRoomBookPHA; Text[30])
        {
            Caption = 'Room Book No.', comment = 'DEA="Raumbuch Nr."';
        }
        field(50008; "BASRaumnr.PHA"; Text[30])
        {
        }
        field(50009; BASBeschkostenSteuerlichPHA; Decimal)
        {
            CalcFormula = sum("FA Ledger Entry".Amount
                where("FA Posting Type" = const("Acquisition Cost"), "FA No." = field("No."), "Depreciation Book Code" = const('STEUERLICH')));
            FieldClass = FlowField;
        }

        // ToDo -> hardcoded!!!
        field(50010; BASBeschKostenBetriebePHA; Decimal)
        {
            CalcFormula = sum("FA Ledger Entry".Amount
                where("FA Posting Type" = const("Acquisition Cost"), "FA No." = field("No."), "Depreciation Book Code" = const('BETRIEB')));
            FieldClass = FlowField;
        }
        field(50011; BASNutzungsdauerSteuerlichPHA; Decimal)
        {
            CalcFormula = lookup("FA Depreciation Book"."No. of Depreciation Years"
                where("FA No." = field("No."), "Depreciation Book Code" = const('STEUERLICH')));
            FieldClass = FlowField;
        }
        field(50012; BASNutzungsdauerBetriebPHA; Decimal)
        {
            CalcFormula = lookup("FA Depreciation Book"."No. of Depreciation Years"
                where("FA No." = field("No."), "Depreciation Book Code" = const('BETRIEB')));
            FieldClass = FlowField;
        }
        field(50013; BASFAPostingGroupLinePHA; Code[20])
        {
            CalcFormula = lookup("FA Depreciation Book"."FA Posting Group" where("FA No." = field("No.")));
            Caption = 'FA Posting Group Line', comment = 'DEA="Anlagenbuchungsgruppe"';
            FieldClass = FlowField;
        }
    }
}