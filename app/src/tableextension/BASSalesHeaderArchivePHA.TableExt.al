tableextension 50046 BASSalesHeaderArchivePHA extends "Sales Header Archive"
{
    // LAN001 02.12.09 ACPSS LAN1.00
    //   New Fields: ID 50500, 50501, 50515, 50601, 50602, 51000, 52000
    // 
    // GL001 Flowfields Restmenge (Basis) und Packing Information eingebaut
    // 
    // ------------------------------------------------------------------------------------------------------------------------------------
    // Datum      | Autor   | Status     | Beschreibung
    // ------------------------------------------------------------------------------------------------------------------------------------
    // 2010-02-05 | Petsch  | ok         | Update von 3.60
    // ------------------------------------------------------------------------------------------------------------------------------------

    fields
    {
        field(50000; "BASshipment copiesPHA"; Integer)
        {
            Caption = 'Shipment Copies';
            Description = 'Petsch';
        }
        field(50001; "BASPreis NullPHA"; Boolean)
        {
            Description = 'Petsch';
        }
        field(50002; "BAS100% ZeilenrabattPHA"; Boolean)
        {
            Description = 'Petsch';
        }
        field(50003; "BASinvoice copiesPHA"; Integer)
        {
            Caption = 'Invoice Copies';
            Description = 'Petsch';
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
            Description = 'LAN1.00';
        }
        // field(50006; "BASBill-to CodePHA"; Code[10])
        // {
        //     Caption = 'Bill-to Code';
        //     Description = 'LAN1.00';
        //     TableRelation = "Ship-to Address".Code where("Customer No." = field("Bill-to Customer No."),
        //                                                   Type = filter(<> Shipment));
        // }
        field(50007; BASVerkaufsstatistikcodePHA; Code[10])
        {
            Description = 'LAN1.00';
        }
        field(50008; BASSammelrechnungstypPHA; Option)
        {
            Description = 'LAN1.00';
            OptionMembers = "Pro Auftrag","Pro Tag",ProWoche,"Pro Monat";
        }
        field(50009; BASAuftragsstatusPHA; Option)
        {
            Description = 'LAN1.00';
            OptionMembers = " ",Freigegeben,"In Kommission",Teillieferung,Geliefert;
        }
        field(50010; BASEtikettenanzahlPHA; Decimal)
        {
            DecimalPlaces = 0 : 5;
            Description = 'LAN1.00';
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
            Description = 'LAN1.00';
        }
    }
}
