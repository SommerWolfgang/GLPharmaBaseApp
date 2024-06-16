tableextension 50053 BASSalesPriceExtPHA extends "Sales Price"
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
    trigger OnAfterInsert()
    begin
        "Allow Line Disc." := not ("Sales Type" = "Sales Type"::Customer);
    end;

    procedure ArtikelText(): Text[60]
    var
        Item: Record Item;
    begin
        if Item.Get("Item No.") then
            exit(CopyStr(Item.Description + ' ' + Item.BASPackageSizePHA, 1, 60));
    end;

    procedure CustomerText(): Text[50]
    var
        Cust: Record Customer;
        CustDiscGr: Record "Customer Discount Group";
    begin
        if "Sales Type" = "Sales Type"::Customer then
            if Cust.Get("Sales Code") then
                exit(CopyStr(Cust.Name, 1, 50));
        if "Sales Type" = "Sales Type"::"Customer Price Group" then
            if CustDiscGr.Get("Sales Code") then
                exit(CopyStr(CustDiscGr.Description, 1, 50));
    end;
}