tableextension 50041 BASExtendedTextHeaderExtPHA extends "Extended Text Header"
{// GL001 Felder: Transfer Order
    //       Feld "Table Name" um Option Purchase Text erweitert (für $Einkaufstexte)
    //       Form: drill down form gesetzt, flow-field: TextLines
    // GL002 Last Date Modified, modified by (weil ja alle Firmenbereiche auf die Textbausteine zugreifen)
    // 
    // Datum      | Autor   | Status     | Beschreibung
    // --------------------------------------------------------------------------------------------------------
    // 2010-01-26 | Petsch  | ok         | Update von 3.60
    // --------------------------------------------------------------------------------------------------------
    // 2016-07-25 | MFU     | ok         | Option in Spalte "Table Name" um "Purchase Text" erweitert
    // --------------------------------------------------------------------------------------------------------
    fields
    {
        field(50000; "BASTransfer OrderPHA"; Boolean)
        {
            Caption = 'Transfer Order';

        }
        field(50001; "BASLast Date ModifiedPHA"; Date)
        {
            Caption = 'Last Date Modified';

            Editable = false;
        }
        field(50002; "BASModified byPHA"; Text[20])
        {

            Editable = false;
        }
        field(50003; BASTextLinesPHA; Integer)
        {
            CalcFormula = Count("Extended Text Line" where("Table Name" = field("Table Name"),
                                                            "No." = field("No."),
                                                            "Language Code" = field("Language Code"),
                                                            "Text No." = field("Text No.")));

            FieldClass = FlowField;
        }
        field(50004; BASMusterzugbemerkungPHA; Boolean)
        {

            InitValue = false;
        }
    }
}
