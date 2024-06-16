tableextension 50045 BASReservationEntryExtPHA extends "Reservation Entry"
{
    // LAN001 02.12.09 ACPSS LAN1.00
    //   New Fields: ID 50000, 50001
    // 
    // GL001
    // Feld Lot No 5400: Table Relation:
    //                   "Lot No. Information"."Lot No." where (Item No.=field(Item No.),Variant Code=field(Variant Code))
    //                   ValidateTableRelation: No
    // 
    // GL: Key erweitert
    // 
    // 
    // ------------------------------------------------------------------------------------------------------------------------------------
    // Datum      | Autor   | Status     | Beschreibung
    // ------------------------------------------------------------------------------------------------------------------------------------
    // 2010-02-05 | Petsch  | ok         | Update von 3.60
    // ------------------------------------------------------------------------------------------------------------------------------------
    fields
    {
        field(50000; BASSalesLotNoPHA; Code[20])
        {
        }
        field(50001; "BASLieferantenchargennr.PHA"; Code[20])
        {
        }
        field(50002; BASPackmittelversionPHA; Code[20])
        {
        }
    }
}
