tableextension 50036 BAST91UserSetupPHA extends "User Setup"
{
    fields
    {
        field(50000; BASWaagePinPHA; Text[10])
        {
            trigger OnValidate()
            var
            // cuNaviPharma: Codeunit NaviPharma;
            begin
                GetManufactoringSetup();
                // if ManufacturingSetup..WaagePinVerschlüsselung > 0 then
                //     WaagePin := cuNaviPharma.StrCrypt(WaagePin, recManufacturingSetup.WaagePinVerschlüsselung, true);
            end;
        }
        field(50001; BASWiegeUserLevelPHA; Integer)
        {
        }
        field(50002; BASWiegeSuperVisorLevelPHA; Integer)
        {
        }
        field(50003; BASTelefonnummerPHA; Text[30])
        {

        }
        field(50004; BASFaxnummerPHA; Text[30])
        {

        }
        field(50005; BASeMailPHA; Text[30])
        {

        }
        field(50006; BASNaviWeighPHA; Boolean)
        {

        }
        field(50007; BASAblaufdatumPHA; Date)
        {

        }
        field(50010; "BASSite ManufacturingPHA"; Code[20])
        {
            Caption = 'Standort Herstellung';


        }
        field(50011; BASWartung_StandortPHA; Code[10])
        {
        }
        field(50012; BASWartung_BereichPHA; Code[10])
        {
        }
        field(50013; BASSchulung_ZuordnungPHA; Code[10])
        {

        }
        field(50014; BASWartung_ZuordnungPHA; Code[20])
        {
            Description = 'MFU';

        }
        field(50015; BASBenutzerEinstellungenPHA; Code[10])
        {
        }
        field(50016; BASAbsatzplanungBenachrichtigungPHA; Option)
        {
            OptionMembers = " ",Mail,InfoCenter,MailErweitert;
        }
        field(50017; BASMarktfreigabePinPHA; Text[10])
        {
            Description = 'MFU';

            trigger OnValidate()
            // var
            //     cuNaviPharma: Codeunit NaviPharma;
            begin
                ManufacturingSetup.Get();
                // if recManufacturingSetup.WaagePinVerschlüsselung > 0 then
                //     MarktfreigabePin := cuNaviPharma.StrCrypt(MarktfreigabePin, recManufacturingSetup.WaagePinVerschlüsselung, true);
            end;
        }
        field(50018; BASLagerHandheldPinPHA; Text[10])
        {
            Description = 'MFU';

            trigger OnValidate()
            // cuNaviPharma: Codeunit NaviPharma;
            begin

                ManufacturingSetup.Get();
                // if ManufacturingSetup.WaagePinVerschlüsselung > 0 then
                //     LagerHandheldPin := cuNaviPharma.StrCrypt(LagerHandheldPin, ManufacturingSetup.WaagePinVerschlüsselung, true);
            end;
        }
        field(50019; BASCommissionLocationFilterPHA; Text[10])
        {
            Caption = 'Kommissionierung Lagerort Filter';
            TableRelation = Location.Code;
        }
        field(50021; BASSiteAssignmentPHA; Code[20])
        {
            Caption = 'Site Assignment', comment = 'DEA="Standort Zuordnung"';
        }
        field(50022; "BASDefault LocationPHA"; Code[10])
        {
            Caption = 'Standard Lagerort';
            Description = 'CCU12';
            TableRelation = if (BASSiteAssignmentPHA = filter('WIEN')) Location.Code where(City = filter('WIEN' | ''))
            else
            if (BASSiteAssignmentPHA = filter('LANNACH')) Location.Code where(City = filter('LANNACH' | ''))
            else
            if (BASSiteAssignmentPHA = filter('')) Location.Code;
        }
        field(50023; "BASDefault BinPHA"; Code[20])
        {
            Caption = 'Standard Lagerplatz';
            Description = 'CCU12';
            TableRelation = if ("Default Location" = filter(<> '')) Bin.Code where("Location Code" = field("Default Location"));
        }
    }

    var
        ManufacturingSetup: Record "Manufacturing Setup";
        IsManufacturingSetup: Boolean;

    procedure SetUserSetup("User ID": Code[50]; Pos: Integer; ch: Code[1])
    var
        Value: Code[10];
    begin
        if (Pos > 0) and (Pos <= 10) then
            if Rec.Get("User ID") then begin
                Value := Rec.BASBenutzerEinstellungenPHA;
                Value[Pos] := ch[1];
                Rec.BASBenutzerEinstellungenPHA := Value;
                Rec.Modify();
            end;
    end;

    procedure GetBenutzerEinstellung("User ID": Code[50]; Pos: Integer): Code[1]
    begin
        if (Pos > 0) and (Pos <= 10) then
            if Rec.Get("User ID") then
                exit(CopyStr(Rec.BASBenutzerEinstellungenPHA, Pos, 1));
    end;

    procedure GetManufactoringSetup()
    begin
        if not IsManufacturingSetup then begin
            ManufacturingSetup.Get();
            IsManufacturingSetup := true;
        end;
    end;
}