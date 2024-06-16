tableextension 50054 BASSalesLineDiscountExtPHA extends "Sales Line Discount"
{
    // LAN001 02.12.09 ACPSS LAN1.00
    //   New Fields: ID 50000 - 50003
    // 
    // GL001 Artikeltext(), Kundentext()
    // 
    // Datum      | Autor   | Status     | Beschreibung
    // ------------------------------------------------------------------------------------------------------------------------------------
    // 2010-02-01 | Petsch  | ok         | Update von 360
    // ------------------------------------------------------------------------------------------------------------------------------------
    // 2014-06-30 | Petsch  | ok         | Update 2009 auf 2013R2
    // ------------------------------------------------------------------------------------------------------------------------------------

    fields
    {
        field(50001; BASBemerkungPHA; Text[100])
        {
            Description = 'LAN1.00';
        }
        field(50002; BASAnzeigenPHA; Boolean)
        {
            Description = 'LAN1.00';
        }
        field(50003; "Packungsgröße"; Text[30])
        {
            Description = 'LAN1.00';
        }
    }
    procedure ArtikelText() ArtikelText: Text[50]
    var
        item: Record 27;
        ItemDiscGr: Record 341;
        tArtikeltextTemp: Text[100];
    begin
        //-GL001
        IF Type = Type::Item THEN
            IF item.GET(Code) THEN BEGIN
                tArtikeltextTemp := item.Description + ' ' + item."Packungsgröße";
                IF STRLEN(tArtikeltextTemp) > 50 THEN    //MFU 19.05.2020  Längenüberschreitung abfangen
                    tArtikeltextTemp := COPYSTR(tArtikeltextTemp, 1, 49);
                ArtikelText := tArtikeltextTemp;
            END;
        IF Type = Type::"Item Disc. Group" THEN
            IF ItemDiscGr.GET(Code) THEN
                ArtikelText := ItemDiscGr.Description;
        //+GL001
    end;

    procedure KundenText() KundenText: Text[50]
    var
        cust: Record "18";
        CustDiscGr: Record "340";
    begin
        //-GL001
        IF "Sales Type" = "Sales Type"::Customer THEN
            IF cust.GET("Sales Code") THEN
                KundenText := cust.Name;
        IF "Sales Type" = "Sales Type"::"Customer Disc. Group" THEN
            IF CustDiscGr.GET("Sales Code") THEN
                KundenText := CustDiscGr.Description;
        //+GL001
    end;
}
