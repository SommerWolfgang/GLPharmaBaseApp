tableextension 50048 "T5109PurchaseHeaderArchive" extends "Purchase Header Archive"
{   // LAN001 02.12.09 ACPSS LAN1.00
    //   New Fields
    // 
    // ------------------------------------------------------------------------------------------------------------------------------------
    // Datum      | Autor   | Status     | Beschreibung
    // ------------------------------------------------------------------------------------------------------------------------------------
    // 2010-02-05 | Petsch  | ok         | Update von 3.60
    // ------------------------------------------------------------------------------------------------------------------------------------
    fields
    {
        field(50000; BASPrintSignaturePHA; Boolean)
        {
            Description = 'Petsch';
        }
        field(50001; "Auftragsbestätigung"; Date)
        {
            Description = 'Petsch';
        }
        field(50002; "BASExterne Rahmennr.PHA"; Code[20])
        {
            Description = 'LAN1.00';
        }
        field(50003; BASAbrufdatumPHA; Date)
        {
            Description = 'LAN1.00';
        }
        field(50004; BASValutadatumPHA; Date)
        {
            Description = 'LAN1.00';
        }
        field(50005; "BASKW verwendenPHA"; Boolean)
        {
            Description = 'LAN1.00';
            InitValue = true;
        }
        field(50006; BASBestellstatusPHA; Option)
        {
            Description = 'LAN1.00';
            OptionMembers = " ",Versendet,Eingegangen,Vorgemerkt;
        }
        field(50007; "BASBezogen auf Rechnungsnr.PHA"; Code[20])
        {
            Description = 'LAN1.00';
            TableRelation = "Purch. Inv. Header" where("Buy-from Vendor No." = field("Buy-from Vendor No."));
        }
        field(50008; BASSpediteurcodePHA; Code[10])
        {
            Description = 'LAN1.00';
            TableRelation = "Shipping Agent";
        }
        field(50009; BASWertgutschriftPHA; Boolean)
        {
            Description = 'LAN1.00';
        }
        field(50010; "Rücklieferung"; Boolean)
        {
            Description = 'LAN1.00';
        }
        field(50011; BASAbgeschlossenPHA; Boolean)
        {
            Description = 'Petsch';
        }
        field(50012; BASGesperrtPHA; Boolean)
        {
            Description = 'Petsch';
        }
        field(50013; BASGLPHA; Boolean)
        {
            Description = 'Petsch';
        }
    }
}
