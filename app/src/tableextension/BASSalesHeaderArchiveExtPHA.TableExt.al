tableextension 50046 BASSalesHeaderArchiveExtPHA extends "Sales Header Archive"
{
    fields
    {
        field(50000; "BASshipment copiesPHA"; Integer)
        {
            Caption = 'Shipment Copies';

        }
        field(50001; "BASPreis NullPHA"; Boolean)
        {

        }
        field(50002; "BAS100% ZeilenrabattPHA"; Boolean)
        {

        }
        field(50003; "BASinvoice copiesPHA"; Integer)
        {
            Caption = 'Invoice Copies';

        }
        field(50004; "BASPacking InformationPHA"; Integer)
        {
            //CalcFormula = Count("Packing Information" WHERE (Type=CONST('Order'),
            //                                                 "Document Type"=FIELD("Document Type"),
            //                                                 "Document No."=FIELD("No.")));
            //FieldClass = FlowField;
        }
        field(50005; BASWertgutschriftPHA; Boolean)
        {

        }
        // field(50006; "BASBill-to CodePHA"; Code[10])
        // {
        //     Caption = 'Bill-to Code';
        //     
        //     TableRelation = "Ship-to Address".Code where("Customer No." = field("Bill-to Customer No."),
        //                                                   Type = filter(<> Shipment));
        // }
        field(50007; BASVerkaufsBASStatisticCode2PHAPHA; Code[10])
        {

        }
        field(50008; BASSammelrechnungstypPHA; Option)
        {

            OptionMembers = "Pro Auftrag","Pro Tag",ProWoche,"Pro Monat";
        }
        field(50009; BASAuftragsstatusPHA; Option)
        {

            OptionMembers = " ",Freigegeben,"In Kommission",Teillieferung,Geliefert;
        }
        field(50010; BASEtikettenanzahlPHA; Decimal)
        {
            DecimalPlaces = 0 : 5;

        }
        field(50011; "BASRestmenge (Basis)PHA"; Decimal)
        {
            CalcFormula = sum("Sales Line"."Outstanding Qty. (Base)" where("Document Type" = field("Document Type"),
                                                                            "Document No." = field("No."),
                                                                            Type = const(Item)));
            FieldClass = FlowField;
        }
        field(50012; BASMusterlieferungPHA; Boolean)
        {

        }
    }
}
