tableextension 50042 BASExtendedTextLineExtPHA extends "Extended Text Line"
{
    fields
    {
        field(50000; BASLastDateModifiedPHA; Date)
        {
            Caption = 'Last Date Modified', comment = 'DEA="Änderungsdatum"';
            Editable = false;
        }
        field(50001; BASModifiedByPHA; Code[50])
        {
            Caption = 'Modified by', comment = 'DEA="Geändert von"';
            Editable = false;
            TableRelation = User."User Name";
        }
    }

    procedure CheckPermissionPM(ItemNo: Code[20]): Boolean
    var
        Item: Record Item;
        NaviPharma: Codeunit BASNaviPharmaPHA;
        NoPermissionErr: Label '', comment = 'DEA="Keine Rechte zum Bearbeiten von Verpackungsstoffen vorhanden!', Locked = true;
        PermissionPMTxt: Label '$TEXTBAUSTEINE_PM', Locked = true;
    begin
        if Item.Get(ItemNo) then
            if Item.BASItemTypePHA = Item.BASItemTypePHA::"Package Material" then
                if not NaviPharma.Permission(PermissionPMTxt) then
                    Error(NoPermissionErr);
    end;
}