
pageextension 50008 BASItemJournalExtPHA extends "Item Journal"
{
    layout
    {
        addafter("Item No.")
        {
            // ToDo -> Field??
            // field(PackageSize; Rec.BASPackageSizePHA)
            // {
            //     ApplicationArea = All;
            // }
            field(BASSalesLotNoPHa; Rec.BASSalesLotNoPHa)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the BASSalesLotNoPHA field.';
            }
            field(Chargenstatus; GetChargenStatus(Rec."Item No.", Rec."Lot No."))
            {
                ApplicationArea = All;
                Caption = 'Lot Status', comment = 'DEA="Chargenstatus"';
                ToolTip = 'Specifies the value of the Item No., Rec.Lot No.) field.';
                Visible = false;
            }
            field("BASHole vonPHA"; Rec."BASHole vonPHA")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the BASHole vonPHA field.', Comment = '%';
            }
        }

        modify("Item No.")
        {
            ApplicationArea = All;
            trigger OnAfterValidate()
            begin
                CurrPage.Update();
            end;
        }

        modify("Lot No.")
        {
            ApplicationArea = All;
            Editable = true;
            Visible = true;
            trigger OnLookup(var Text: Text): Boolean
            begin
                Rec.HoleCharge();
            end;
        }

        modify("Expiration Date")
        {
            ApplicationArea = All;
            Editable = true;
            Visible = true;
        }
    }
    trigger OnAfterGetRecord()
    var
        ReservationEntry: Record "Reservation Entry";
    begin
        if Rec."Lot No." = '' then begin
            ReservationEntry.SetRange("Item No.", Rec."Item No.");
            ReservationEntry.SetRange("Location Code", Rec."Location Code");
            ReservationEntry.SetRange("Source ID", 'ARTIKEL');
            ReservationEntry.SetRange("Source Batch Name", Rec."Journal Batch Name");
            ReservationEntry.SetRange("Source Ref. No.", Rec."Line No.");
            if ReservationEntry.FindFirst() then begin
                Rec."Lot No." := ReservationEntry."Lot No.";
                Rec.BASSalesLotNoPHA := ReservationEntry.BASSalesLotNoPHA;
                Rec."Expiration Date" := ReservationEntry."Expiration Date";
            end;
        end;
    end;

    procedure GetChargenStatus(ItemNo: Code[20]; LotNo: Code[50]): Code[50]
    var
        LotNoInformation: Record "Lot No. Information";
    begin
        if (StrLen(ItemNo) > 0) and (StrLen(LotNo) > 0) then
            if LotNoInformation.Get(ItemNo, '', LotNo) then
                exit(Format(LotNoInformation.BASStatusPHA));
    end;
}