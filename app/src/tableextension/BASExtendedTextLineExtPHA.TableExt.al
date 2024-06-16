tableextension 50042 BASExtendedTextLineExtPHA extends "Extended Text Line"
{  // GL001 Last date modified und modified by
    //       Feld "Table Name" um Option Purchase Text erweitert
    //       Form: lookup-form und drill down form gesetzt
    // 
    // Datum      | Autor   | Status   | Beschreibung
    // --------------------------------------------------------------------------------------------------------
    // 2010-01-26 | Petsch  | ok       | Update von 3.60
    // --------------------------------------------------------------------------------------------------------
    // 2015-03-02 | MFU     | ok       | GL002 - Bei Verpackungsartikel nur Benutzer mit spezialrecht sollen ändern können (Wunsch Maurer)
    // --------------------------------------------------------------------------------------------------------
    fields
    {
        field(50000; "BASLast Date modifiedPHA"; Date)
        {
        }
        field(50001; "BASmodified byPHA"; Text[20])
        {
        }
    }

    procedure CheckPMRecht(cItemNo: Code[20])
    var
        recItem: Record Item;
        NaviPharma: Codeunit NaviPharma;
    begin

        //-GL002
        IF recItem.GET(cItemNo) THEN
            IF recItem.Artikelart = recItem.Artikelart::Verpackungsstoff THEN
                IF NOT NaviPharma.Berechtigung('$TEXTBAUSTEINE_PM') THEN
                    ERROR('Keine Rechte zum bearbeiten von Verpackungsstoffen vorhanden!');
        //+GL002
    end;
}
