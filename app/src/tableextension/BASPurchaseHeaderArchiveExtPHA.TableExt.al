tableextension 50048 BASPurchaseHeaderArchiveExtPHA extends "Purchase Header Archive"
{
    fields
    {
        field(50000; BASPrintSignaturePHA; Boolean)
        {

        }
        field(50001; "Auftragsbestätigung"; Date)
        {

        }
        field(50002; "BASExterne Rahmennr.PHA"; Code[20])
        {

        }
        field(50003; BASAbrufdatumPHA; Date)
        {

        }
        field(50004; BASValutadatumPHA; Date)
        {

        }
        field(50005; "BASKW verwendenPHA"; Boolean)
        {

            InitValue = true;
        }
        field(50006; BASBestellstatusPHA; Option)
        {

            OptionMembers = " ",Versendet,Eingegangen,Vorgemerkt;
        }
        field(50007; "BASBezogen auf Rechnungsnr.PHA"; Code[20])
        {

            TableRelation = "Purch. Inv. Header" where("Buy-from Vendor No." = field("Buy-from Vendor No."));
        }
        field(50008; BASSpediteurcodePHA; Code[10])
        {

            TableRelation = "Shipping Agent";
        }
        field(50009; BASWertgutschriftPHA; Boolean)
        {

        }
        field(50010; "Rücklieferung"; Boolean)
        {

        }
        field(50011; BASAbgeschlossenPHA; Boolean)
        {

        }
        field(50012; BASGesperrtPHA; Boolean)
        {

        }
        field(50013; BASGLPHA; Boolean)
        {

        }
    }
}