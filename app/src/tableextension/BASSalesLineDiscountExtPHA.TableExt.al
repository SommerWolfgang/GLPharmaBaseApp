tableextension 50054 BASSalesLineDiscountExtPHA extends "Sales Line Discount"
{
    fields
    {
        field(50000; BASCommentPHA; Text[100])
        {
            Caption = '', comment = 'DEA="Kommentar"';
        }
        field(50001; PackageSize; Text[30])
        {
            Caption = '', comment = 'DEA="Packetgröße"';
        }
        field(50002; BASShowPHA; Boolean)
        {
            Caption = '', comment = 'DEA="Anzeigen"';
        }
    }
    procedure ItemText(): Text
    var
        item: Record Item;
        ItemDiscGr: Record "Item Discount Group";
        DummyItemText: Text;
    begin
        if Type = Type::Item then
            if item.Get(Code) then begin
                DummyItemText := item.Description + ' ' + item.BASPackageSizePHA;
                if StrLen(DummyItemText) > 50 then
                    DummyItemText := CopyStr(DummyItemText, 1, 49);
                exit(DummyItemText);
            end;

        if Type = Type::"Item Disc. Group" then
            if ItemDiscGr.Get(Code) then
                exit(ItemDiscGr.Description);
    end;

    procedure CustomerText(): Text[50]
    var
        Cust: Record Customer;
        CustDiscGr: Record "Customer Discount Group";
    begin
        if "Sales Type" = "Sales Type"::Customer then
            if Cust.Get("Sales Code") then
                exit(CopyStr(Cust.Name, 1, 50));
        if "Sales Type" = "Sales Type"::"Customer Disc. Group" then
            if CustDiscGr.Get("Sales Code") then
                exit(CopyStr(CustDiscGr.Description, 1, 50));
    end;
}