tableextension 50026 BASExcelBufferExtPHA extends "Excel Buffer"
{ // LAN001 02.12.09 ACPSS LAN1.00
    //   New Field: ID 50000
    //   Vertikale Darstellung
    // 
    // ------------------------------------------------------------------------------------------------------------------------------------
    // Datum      | Autor   | Status     | Beschreibung
    // ------------------------------------------------------------------------------------------------------------------------------------
    // 2013-04-24 | MFU     | ok         | GL001 Excel auch in mehreren Tabellenblätter schreiben möglich machen
    // ------------------------------------------------------------------------------------------------------------------------------------
    // 2008-02-26 | Rieder  | ok         | GL002 Funktion UpdateScreen() eingefügt
    //                                   |       Funktion SaveBook() eingefügt
    //                                   |       Funktion CloseBook() eingefügt
    // ------------------------------------------------------------------------------------------------------------------------------------
    // 2014-06-04 | MFU     | ok         | UPDATE 2013
    //                                     Funktion SaveAs() noch nicht Upgedaten -> bei Bedarf
    //                                     Primär Key um Worksheet Name erweitern auf Worksheet Name,Row No.,Column No.
    // ------------------------------------------------------------------------------------------------------------------------------------
    fields
    {
        field(50000; BASVerticalPHA; Boolean)
        {
        }
        field(50001; "BASWorksheet NamePHA"; Text[150])
        {
        }
    }
}
