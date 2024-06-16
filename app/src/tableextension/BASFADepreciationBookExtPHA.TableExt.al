tableextension 50052 BASFADepreciationBookExtPHA extends "FA Depreciation Book"
{
    // Petsch: FlowField: Kst-Aufteilungen
    // 
    // Datum      | Autor   | Status     | Beschreibung
    // ---------------------------------------------------------------------------------------------------------
    // 2005-11-14 | Petsch  | ok         | Änderung des Startdatums soll nicht Nutzungsdauer, sondern Enddatum mitändern!
    // ---------------------------------------------------------------------------------------------------------
    // 2006-03-06 | Petsch  | ok         | Flowfield Förderung eingebaut
    // ---------------------------------------------------------------------------------------------------------
    // 2006-10-19 | Petsch  | ok         | Flowfield Inbetriebnahmedatum eingebaut
    // ---------------------------------------------------------------------------------------------------------
    // 2009-12-29 | MFU     | ok         | Update 2009
    // 1) Tabellenspalten übernahme
    // 2) Sourcecode 001 - Feld Kontonr der Anlage je nach Auswahl befüllen
    // ---------------------------------------------------------------------------------------------------------
    // 2012-03-06 | MFU     | ok         | Flowfield Kostenstelle eingebaut - Wunsch Knieli
    // ---------------------------------------------------------------------------------------------------------
    fields
    {
        Modify("FA Posting Group")
        {
            trigger OnAfterValidate()
            var
                FASetup: Record "FA Setup";
                FixedAsset: Record "Fixed Asset";
            begin
                FASetup.Get();
                if FASetup.BASKontoNrLogikPHA = FASetup.BASKontoNrLogikPHA::"Anlagenbuchungsgruppe des Standard Afa-Buches" then
                    if "Depreciation Book Code" = FASetup."Default Depr. Book" then begin
                        FixedAsset.Get("FA No.");
                        FixedAsset.BASAccountNoPHA := CopyStr("FA Posting Group", 1, 10);
                        FixedAsset.Modify();
                    end;
            end;
        }
        field(50000; "BASKst-AufteilungenPHA"; Integer)
        {
        }
        field(50001; "Förderung"; Text[30])
        {
            CalcFormula = lookup("Fixed Asset".BASAdvancementPHA where("No." = field("FA No.")));
            FieldClass = FlowField;
        }
        field(50002; BASInbetriebnahmedatumPHA; Date)
        {
        }
        field(50003; BASAnlagenbezeichnungPHA; Text[100])
        {
            CalcFormula = lookup("Fixed Asset".Description where("No." = field("FA No.")));
            FieldClass = FlowField;
        }
        field(50004; BASAnlagenkostenstellePHA; Code[20])
        {
            CalcFormula = lookup("Fixed Asset"."Global Dimension 1 Code" where("No." = field("FA No.")));
            FieldClass = FlowField;
        }
        field(50005; BASBlockedPHA; Boolean)
        {
            CalcFormula = lookup("Fixed Asset".Blocked where("No." = field("FA No.")));
            Caption = 'Blocked', comment = 'DEA="Gesperrt"';
            FieldClass = FlowField;
        }
        field(50006; BASInactivePHA; Boolean)
        {
            CalcFormula = lookup("Fixed Asset".Inactive where("No." = field("FA No.")));
            Caption = 'Inactive', comment = 'DEA="Inaktiv"';
            FieldClass = FlowField;
        }
    }
}