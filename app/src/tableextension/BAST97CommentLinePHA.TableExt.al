tableextension 50059 BAST97CommentLinePHA extends "Comment Line"
{
    fields
    {
        // Meldung bei EK-Lieferung
        field(50000; "BASMeldung bei EK-LieferungPHA"; Boolean)
        {
            DataClassification = ToBeClassified;

        }
        // Meldung in VK-Auftrag anzeigen
        field(50001; "BASMeldung in VK-Auftrag anzeigenPHA"; Boolean)
        {
            DataClassification = ToBeClassified;

        }
        // Meldung in Debitorenposten anzeigen
        field(50002; "BASMeldung in Debitorenposten anzPHA"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'MFU';
        }
        // Meldung in Einkauf Rechnung anzeigen
        field(50003; "BASMeldung in Einkauf Rechnung anPHA"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'MFU';
        }
        // Meldung in FA anzeigen
        field(50004; "BASMeldung in FA anzeigenPHA"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'MFU';
        }
        // Meldung in Bestellung anzeigen
        field(50500; "BASMeldung in Bestellung anzeigenPHA"; Boolean)
        {
            DataClassification = ToBeClassified;

        }
        // Meldung bei Umlagerung
        field(50501; "BASMeldung bei UmlagerungPHA"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'PRA';
        }
    }
}
