tableextension 50040 BASPurchCrMemoHdrExtPHA extends "Purch. Cr. Memo Hdr."
{ // LAN001 25.11.09 ACPSS LAN1.00
    //   New Fields: ID 50502, 50506, 50507
    // 
    // 
    fields
    {
        field(50502; BASValutadatumPHA; Date)
        {

        }
        field(50506; BASSpediteurcodePHA; Code[10])
        {

            TableRelation = "Shipping Agent";
        }
        field(50507; BASWertgutschriftPHA; Boolean)
        {

        }
        field(50508; BASStornoMitBelegNrPHA; Code[20])
        {

        }
    }
}
