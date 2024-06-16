tableextension 50014 BASPurchaseHeaderExtPHA extends "Purchase Header"
{
    fields
    {
        field(50000; BASPrintSignaturePHA; Boolean)
        {
            Caption = 'PrintSignature';

        }
        field(50001; "Auftragsbestätigung"; Date)
        {

        }
        field(50002; "BASAuftragsbest. andruckenPHA"; Boolean)
        {
            Caption = 'Print order Confirmation';

        }
        field(50500; "BASExterne Rahmennr.PHA"; Code[20])
        {

        }
        field(50501; BASAbrufdatumPHA; Date)
        {

        }
        field(50502; BASValutadatumPHA; Date)
        {


            trigger OnValidate()
            begin
                //-LAN001
                Validate("Payment Terms Code");
                //+LAN001
            end;
        }
        field(50503; "BASKW verwendenPHA"; Boolean)
        {

            InitValue = true;
        }
        field(50504; BASBestellstatusPHA; Option)
        {

            OptionMembers = " ",Versendet,Eingegangen;

            // trigger OnValidate()
            // //ToDo
            // // codesammlung: Codeunit "50000";
            // begin
            //     if Rec.Bestellstatus = Rec.Bestellstatus::Eingegangen then
            //         if xRec.Bestellstatus <> Rec.Bestellstatus then
            //             codesammlung.EKLiefBemerkungsmeldung(Rec);
            // end;
        }
        field(50505; "BASBezogen auf Rechnungsnr.PHA"; Code[20])
        {

            TableRelation = "Purch. Inv. Header" where("Buy-from Vendor No." = field("Buy-from Vendor No."));
        }
        field(50506; BASSpediteurcodePHA; Code[10])
        {

            TableRelation = "Shipping Agent";
        }
        field(50507; BASWertgutschriftPHA; Boolean)
        {

        }
        field(50509; BASEinAusFuhrBewilligungsNrPHA; Text[100])
        {

        }
        field(50510; BASSMVerwendungszweckPHA; Option)
        {

            OptionMembers = " ","Import für Inlandsverbrauch","Import für Wiederausfuhr";
        }
        field(50511; BASTransportversicherungPHA; Boolean)
        {
        }
        field(50512; BASMengeOffenPHA; Decimal)
        {
            CalcFormula = sum("Purchase Line"."Qty. to Receive" where("Document Type" = field("Document Type"),
                                                                       "Document No." = field("No.")));
            FieldClass = FlowField;
        }
        field(51075; "Rücklieferung"; Boolean)
        {

        }
        field(51076; BASAbgeschlossenPHA; Boolean)
        {

        }
        field(51077; BASGesperrtPHA; Boolean)
        {

        }
        field(51078; BASGLPHA; Boolean)
        {

        }
    }
    procedure HoleLieferwoche() Kalenderwoche: Integer
    begin
        //-LAN005
        if "Expected Receipt Date" <> 0D then
            Kalenderwoche := DATE2DWY("Expected Receipt Date", 2);
        //+LAN005
    end;

    procedure HoleGewuenschteLieferwoche() Kalenderwoche: Integer
    begin
        //-GL015
        if "Requested Receipt Date" <> 0D then
            Kalenderwoche := DATE2DWY("Requested Receipt Date", 2);
        //+GL015
    end;

}
