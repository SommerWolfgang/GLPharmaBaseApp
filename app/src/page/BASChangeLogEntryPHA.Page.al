page 50007 BASChangeLogEntryPHA
{
    Caption = 'Change Log', comment = 'DEA="Änderungsprotokoll';
    Editable = false;
    PageType = List;
    SourceTable = "Change Log Entry";

    // ToDo -> all
    layout
    {
        area(content)
        {
            // repeater(General)
            // {
            //     field(DateAndTime; Rec."Date and Time")
            //     {
            //         ApplicationArea = All;
            //     }
            //     field(Time; Rec.Time)
            //     {
            //         ApplicationArea = All;
            //     }
            //     field(UserId; Rec."User ID")
            //     {
            //         ApplicationArea = All;
            //     }
            //     field("Table No."; "Table No.")
            //     {
            //         ApplicationArea = All;
            //     }
            //     field("Table Caption"; "Table Caption")
            //     {
            //         ApplicationArea = All;
            //     }
            //     field("Field No."; "Field No.")
            //     {
            //         ApplicationArea = All;
            //     }
            //     field("Field Caption"; "Field Caption")
            //     {
            //         ApplicationArea = All;
            //     }
            //     field("Type of Change"; "Type of Change")
            //     {
            //         ApplicationArea = All;
            //     }
            //     field("Old Value"; "Old Value")
            //     {
            //         ApplicationArea = All;
            //     }
            //     field("Old Value Local"; GetLocalOldValue)
            //     {
            //         ApplicationArea = All;
            //         Caption = 'Old Value (Local)';
            //     }
            //     field("New Value"; "New Value")
            //     {
            //         ApplicationArea = All;
            //     }
            //     field("New Value Local"; GetLocalNewValue)
            //     {
            //         ApplicationArea = All;
            //         Caption = 'New Value (Local)';
            //     }
            //     field("Primary Key"; "Primary Key")
            //     {
            //         ApplicationArea = All;
            //     }
            //     field("Primary Key Field 1 No."; "Primary Key Field 1 No.")
            //     {
            //         ApplicationArea = All;
            //     }
            //     field("Primary Key Field 1 Caption"; "Primary Key Field 1 Caption")
            //     {
            //         ApplicationArea = All;
            //     }
            //     field("Primary Key Field 1 Value"; "Primary Key Field 1 Value")
            //     {
            //         ApplicationArea = All;
            //     }
            //     field("Primary Key Field 2 No."; "Primary Key Field 2 No.")
            //     {
            //         ApplicationArea = All;
            //     }
            //     field("Primary Key Field 2 Caption"; "Primary Key Field 2 Caption")
            //     {
            //         ApplicationArea = All;
            //     }
            //     field("Primary Key Field 2 Value"; "Primary Key Field 2 Value")
            //     {
            //         ApplicationArea = All;
            //     }
            //     field("Primary Key Field 3 No."; "Primary Key Field 3 No.")
            //     {
            //         ApplicationArea = All;
            //     }
            //     field("Primary Key Field 3 Caption"; "Primary Key Field 3 Caption")
            //     {
            //         ApplicationArea = All;
            //     }
            //     field("Primary Key Field 3 Value"; "Primary Key Field 3 Value")
            //     {
            //         ApplicationArea = All;
            //     }
            // }
        }
    }

    // trigger OnOpenPage()
    // begin
    //     IF sFilterCode <> '' THEN
    //         Rec.SETFILTER("Primary Key Field 1 Value", sFilterCode);
    //     IF sFilterUser <> '' THEN
    //         Rec.SETFILTER("User ID", sFilterUser);
    //     IF sFilterTable <> '' THEN
    //         Rec.SETFILTER("Table Caption", sFilterTable);
    //     IF sFilterTableNo <> '' THEN
    //         Rec.SETFILTER("Table No.", sFilterTableNo);
    //     IF sFilterCode2 > '' THEN
    //         Rec.SETFILTER("Primary Key Field 2 Value", sFilterCode2);
    //     IF sFilterCode3 > '' THEN
    //         Rec.SETFILTER("Primary Key Field 3 Value", sFilterCode3);
    // end;


    // var
    //     sFilterCode: Code[20];
    //     sFilterCode2: Code[20];
    //     sFilterCode3: Code[20];
    //     sFilterTableNo: Text;
    //     sFilterField: Text[30];
    //     sFilterTable: Text[30];
    //     sFilterUser: Text[30];


    // procedure setFilter(sUser: Text[30]; sTable: Text[50]; sCode: Code[20])
    // begin
    //     sFilterUser := sUser;
    //     sFilterTable := sTable;
    //     sFilterCode := sCode;  // GL001
    //     //  sFilterField:= sField;
    // end;

    // procedure setFilterArtikelHersteller(sUser: Text[30]; sTable: Text[50]; sCode: Code[20]; sCode2: Code[20]; sCode3: Code[20])
    // begin
    //     //-GL003
    //     sFilterUser := sUser;
    //     sFilterTable := sTable;
    //     sFilterCode := sCode;
    //     sFilterCode2 := sCode2;
    //     sFilterCode3 := sCode3;
    //     //+GL003
    // end;

    // procedure setFilterChargenstamm(sUser: Text[30]; sTable: Text[50]; sCode: Code[20]; sCode2: Code[20])
    // begin
    //     sFilterUser := sUser;
    //     sFilterTable := sTable;
    //     sFilterCode := sCode;
    //     sFilterCode2 := '';
    //     sFilterCode3 := sCode2;
    // end;

    // procedure setFilterByRec(sUser: Text[30]; Source: Variant): Boolean
    // var
    //     cuDataTypeMgmt: Codeunit "Data Type Management";
    //     rRef: RecordRef;
    //     fRef: FieldRef;
    //     i: Integer;
    //     maxKey: Integer;
    //     myInt: Integer;
    //     refKey: KeyRef;
    //     KeyValArr: array[3] of Text;

    // begin
    //     IF NOT cuDataTypeMgmt.GetRecordRef(Source, rRef) THEN
    //         EXIT(FALSE);

    //     refKey := rRef.KEYINDEX(1);
    //     maxKey := refKey.FIELDCOUNT();
    //     IF maxKey > 3 THEN
    //         maxKey := 3;
    //     FOR i := 1 TO maxKey DO BEGIN
    //         fRef := refKey.FIELDINDEX(i);
    //         KeyValArr[i] := fRef.VALUE;
    //         //KeyNoArr[i] := fRef.NUMBER;
    //     END;

    //     sFilterUser := sUser;
    //     sFilterTableNo := FORMAT(rRef.NUMBER);
    //     sFilterCode := KeyValArr[1];
    //     sFilterCode2 := KeyValArr[2];
    //     sFilterCode3 := KeyValArr[3];
    //     EXIT(TRUE);

    // end;
}
