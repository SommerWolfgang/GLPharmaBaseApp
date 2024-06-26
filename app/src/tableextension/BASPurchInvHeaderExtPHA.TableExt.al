tableextension 50039 BASPurchInvHeaderExtPHA extends "Purch. Inv. Header"
{// LAN001 25.11.09 ACPSS LAN1.00
    //   New Fields: ID 50000 - 50003, 50005, 50006, 51075
    // 
    // 
    // Datum      | Autor   | Status     | Beschreibung
    // --------------------------------------------------------------------------------------------------------
    // 2017-08-25 | MFU     | ok         | "Transportversicherung" angelegt
    // --------------------------------------------------------------------------------------------------------
    // 2017-09-07 | MFU     | ok         | "StornoMitBelegNr" angelegt
    // --------------------------------------------------------------------------------------------------------
    fields
    {
        //MFU 29.03.2024 -> Entfernen der Felder, da Fehler beim Buchen dadurch
        /*
        field(50000; "BASExterne Rahmennr.PHA"; Code[20])
        {
            
        }
        field(50001; BASAbrufdatumPHA; Date)
        {
            
        }
        field(50002; BASValutadatumPHA; Date)
        {
            
        }
        field(50003; "BASKW verwendenPHA"; Boolean)
        {
            
        }
        field(50005; "BASBezogen auf Rechnungsnr.PHA"; Code[20])
        {
            
            TableRelation = "Purch. Inv. Header" where("Buy-from Vendor No." = field("Buy-from Vendor No."));
        }
        field(50006; BASSpediteurcodePHA; Code[10])
        {
            
            TableRelation = "Shipping Agent";
        }
        field(50008; BASStornoMitBelegNrPHA; Code[20])
        {
            
        }
        field(50011; BASTransportversicherungPHA; Boolean)
        {
            
        }
        field(51075; "Rücklieferung"; Boolean)
        {
            
        }
        */
    }
}
