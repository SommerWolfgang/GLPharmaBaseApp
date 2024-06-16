tableextension 50053 BASSalesPriceExtPHA extends "Sales Price"
{   // LAN001 02.12.09 ACPSS LAN1.00
    //   New Fields: ID 50000 - 50002
    // 
    // GL001 Funktionen: Artikeltext(), Kundentext()
    // GL002 InitValue "Allow Line Disc." bei Deb.-Artikelpreisen auf NEIN
    // 
    // Datum      | Autor   | Status     | Beschreibung
    // ------------------------------------------------------------------------------------------------------------------------------------
    // 2010-02-01 | Petsch  | ok         | Update von 360
    // ------------------------------------------------------------------------------------------------------------------------------------
    // 2014-06-30 | Petsch  | ok         | Update 2009 auf 2013R2
    // ------------------------------------------------------------------------------------------------------------------------------------
    // 2018-04-25 | DKO     | ok         | ArtikelText() - ReturnValue Max Size auf 60 erhöht weil ItemDesc [50] + ItemPackSize[10]  = 60
    // ------------------------------------------------------------------------------------------------------------------------------------
    fields
    {
        field(50000; BASBemerkungPHA; Text[100])
        {
        }
        field(50001; "Packungsgröße"; Text[30])
        {
        }
        field(50002; BASAnzeigenPHA; Boolean)
        {
        }
    }
    trigger OnAfterInsert()
    begin
        //-GL002
        IF "Sales Type" = "Sales Type"::Customer THEN
            "Allow Line Disc." := FALSE;
        //+GL002
    end;

    procedure ArtikelText() ArtikelText: Text[60]
    var
        Item: Record 27;
    begin
        //-GL001
        IF Item.GET("Item No.") THEN
            ArtikelText := CopyStr(Item.Description + ' ' + Item.BASPackageSizePHA, 1, 60);
        //+GL001
    end;

    procedure KundenText() KundenText: Text[50]
    var
        Cust: Record 18;
        CustDiscGr: Record 340;
    begin
        //-GL001
        IF "Sales Type" = "Sales Type"::Customer THEN
            IF Cust.GET("Sales Code") THEN
                KundenText := CopyStr(Cust.Name, 1, 50);
        IF "Sales Type" = "Sales Type"::"Customer Price Group" THEN
            IF CustDiscGr.GET("Sales Code") THEN
                KundenText := CopyStr(CustDiscGr.Description, 1, 50);
        ;
        //+GL001
    end;
}
