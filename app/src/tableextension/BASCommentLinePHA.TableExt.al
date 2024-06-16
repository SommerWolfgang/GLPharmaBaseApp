tableextension 50059 BASCommentLinePHA extends "Comment Line"
{
    fields
    {
        field(50000; "BASMeldung bei EK-LieferungPHA"; Boolean)
        {
            DataClassification = CustomerContent;

        }
        field(50001; BASShowMsgInSalesOrderPHA; Boolean)
        {
            DataClassification = CustomerContent;
        }
        // Meldung in Debitorenposten anzeigen
        field(50002; "BASMeldung in Debitorenposten anzPHA"; Boolean)
        {
            DataClassification = CustomerContent;
            Description = 'MFU';
        }
        // Meldung in Einkauf Rechnung anzeigen
        field(50003; "BASMeldung in Einkauf Rechnung anPHA"; Boolean)
        {
            DataClassification = CustomerContent;
            Description = 'MFU';
        }
        // Meldung in FA anzeigen
        field(50004; "BASMeldung in FA anzeigenPHA"; Boolean)
        {
            DataClassification = CustomerContent;
            Description = 'MFU';
        }
        // Meldung in Bestellung anzeigen
        field(50500; "BASMeldung in Bestellung anzeigenPHA"; Boolean)
        {
            DataClassification = CustomerContent;

        }
        // Meldung bei Umlagerung
        field(50501; "BASMeldung bei UmlagerungPHA"; Boolean)
        {
            DataClassification = CustomerContent;
            Description = 'PRA';
        }
    }
}
