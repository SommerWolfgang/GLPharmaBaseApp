tableextension 50000 BASCustomerExtensionPHA extends Customer
{
    fields
    {
        field(50001; BASCountryRegionShipmentPHA; Code[10])
        {
            Caption = 'Country/Region Code Shipment', comment = 'DEA="Lieferländercode"';
            TableRelation = "Country/Region";
        }
        field(50002; BASSalespersonCode2PHA; Code[10])
        {
            Caption = 'Salesperson Code 2', comment = 'DEA="Verkäufercode 2"';
            TableRelation = "Salesperson/Purchaser";
        }
        field(50003; BASSGBezugPHA; Boolean)
        {
        }
        field(50004; BASPSYBezugPHA; Boolean)
        {
            Description = 'Pranter';
        }
        field(50005; BASShipmentCopiesPHA; Integer)
        {
            Caption = 'Shipment Copies', comment = 'DEA="Lieferung Kopien"';
        }
        field(50006; BASModifiedByPHA; Code[50])
        {
            Caption = 'Modified by', comment = 'DEA="Korrigiert durch"';
            Editable = false;
            TableRelation = User."User Name";
        }
        // field(50007; BASAssociationPHA; Code[10])
        // {
        //     Caption = 'Verband';
        //     TableRelation = DropDownContent.ID where(Tabelle = const(18), Feld = filter('ASSOCIATION'));
        // }
        field(50008; BASInternerDatenaustauschPHA; Boolean)
        {
            Description = 'Petsch';
        }
        field(50009; BASEDIZielNrPHA; Code[20])
        {
            Description = 'Petsch';
        }
        field(50010; "BASARA-entpflichtetPHA"; Boolean)
        {
            Description = 'Petsch';
        }
        field(50011; "BASNo. 2PHA"; Code[20])
        {
            Description = 'Petsch';
        }
        field(50012; "Verkäufercode 3"; Code[10])
        {
            Caption = 'Salesperson Code 3';
            Description = 'MFU';
            TableRelation = "Salesperson/Purchaser";
        }
        field(50013; BASBetriebsnummerPHA; Code[10])
        {
        }
        field(50014; BASPDFRechnungPHA; Boolean)
        {
            Description = 'MFU';
        }
        field(50015; BASRechnungspreisformat1000PHA; Boolean)
        {
            Description = 'MFU';
        }
        field(50016; "Verkäufercode 4"; Code[10])
        {
            Caption = 'Salesperson Code 3';
            Description = 'MFU';
            TableRelation = "Salesperson/Purchaser";
        }
        field(50017; BASMailBestellAdressePHA; Text[50])
        {
            Description = 'MFU';
        }
        field(50018; "Verkäufercode 5"; Code[10])
        {
            Caption = 'Verkäufercode SOU';
            TableRelation = "Salesperson/Purchaser";
        }
        field(50019; "BASBTM No.PHA"; Code[10])
        {
            Caption = 'BtM-Nummer';
            Description = 'PRA';
        }
        field(50023; "BASAddress 3PHA"; Text[50])
        {
            Caption = 'Adresse 3';
            Description = 'MFU';
        }
        field(50024; "BASSN deaktivierenPHA"; Boolean)
        {
        }
        field(50601; BASSammelrechnungstypPHA; Option)
        {
            Description = 'LAN1.00';
            OptionMembers = "Pro Auftrag","Pro Tag",ProWoche,"Pro Monat";
        }
        // field(50602; "BASCustomer Group CodePHA"; Code[10])
        // {
        //     Caption = 'Customer Group Code';
        //     Description = 'LAN1.00';
        //     TableRelation = CCUGroups.Gruppe where(Typ = const(Debitor));
        // }
        field(50603; "BASLieferungstext 1PHA"; Text[80])
        {
            Description = 'LAN1.00';
        }
        field(50604; "BASLieferungstext 2PHA"; Text[80])
        {
            Description = 'LAN1.00';
        }
        field(50605; "BASCarry off goodsPHA"; Boolean)
        {
            Caption = 'Ware abtragen';
            Description = 'Rieder';
        }
        field(50606; BASAbstellgenehmigungPHA; Boolean)
        {
            Description = 'Petsch';
        }
        field(50607; BASAbstellortPHA; Text[30])
        {
            Description = 'Petsch';
        }
    }
    trigger OnInsert()
    begin
        AssignValuesStandardTrigger();
    end;

    trigger OnModify()
    begin
        AssignValuesStandardTrigger();
    end;

    local procedure AssignValuesStandardTrigger()
    begin
        "Last Date Modified" := TODAY;
        Evaluate(BASModifiedByPHA, UserId);
    end;
}