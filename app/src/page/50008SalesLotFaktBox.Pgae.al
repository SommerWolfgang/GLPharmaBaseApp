page 50008 "Sales Lot FactBox"
{
    // version CCU146

    // CCU146 CCU146.01            PBA: VK-Chargen Factbox
    // CCU146 CCU146.02 12.10.2020 PBA: record Sales Line zu Reservation Entry
    // CCU146 CCU146.03 12.10.2020 PBA: Werte zurücksetzten
    // CCU146 CCU146.04 18.01.2021 MFU: Umstellung der Page auf die Tabelle SalesLine
    // CCU416 CCU146.05 29.09.2021 PBA: Externe Chargennr. anzeigen

    Editable = false;
    PageType = CardPart;
    PopulateAllFields = true;
    RefreshOnActivate = true;
    SourceTable = "Sales Line";

    layout
    {
        area(content)
        {
            field(ItemNo; ItemNo)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Item No.';
                ColumnSpan = 4;
                Lookup = false;
                ToolTip = 'Specifies the item that is handled on the sales line.';
            }
            group(LotNr)
            {
                Caption = 'ChargenNr';
                Visible = bShow1;
                grid(grid1)
                {
                    GridLayout = Rows;
                    //group()
                    //{                        

                    field(tChargenText1; tChargenText1)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Charge 1';
                    }
                    /*
                    field(ChrNR1; cLot1)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Ch Nr1';
                    }
                    
                    field(ExtLot1; ExtLot1)
                    {
                        ApplicationArea = Basic, Suite;
                        Visible = ShowExternalLot;
                    }

                    field(HerstDat1; cCr1)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Status';
                    }
                    field(Hdatum1; cEx1)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Ablauf';
                    }
                    field(Menge1; cMenge1)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Menge';
                        Editable = false;
                        MultiLine = true;
                    }
                    */
                    //}
                }
            }
            group(LotNr2)
            {
                Caption = 'ChargenNr';
                Visible = bShow2;
                grid(grid2)
                {
                    GridLayout = Rows;

                    field(tChargenText2; tChargenText2)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Charge 2';
                    }

                }
            }

            group(LotNr3)
            {
                Caption = 'ChargenNr';
                Visible = bShow3;
                grid(grid3)
                {
                    GridLayout = Rows;

                    field(tChargenText3; tChargenText3)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Charge 3';
                    }

                }
            }
            group(LotNr4)
            {
                Caption = 'ChargenNr';
                Visible = bShow4;
                grid(grid4)
                {
                    GridLayout = Rows;

                    field(tChargenText4; tChargenText4)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Charge 4';
                    }

                }
            }
            group(LotNr5)
            {
                Caption = 'ChargenNr';
                Visible = bShow5;
                grid(grid5)
                {
                    GridLayout = Rows;

                    field(tChargenText5; tChargenText5)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Charge 5';
                    }

                }
            }
            group(LotNr6)
            {
                Caption = 'ChargenNr';
                Visible = bShow6;
                grid(grid6)
                {
                    GridLayout = Rows;

                    field(tChargenText6; tChargenText6)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Charge 6';
                    }

                }
            }
            group(LotNr7)
            {
                Caption = 'ChargenNr';
                Visible = bShow7;
                grid(grid7)
                {
                    GridLayout = Rows;

                    field(tChargenText7; tChargenText7)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Charge 7';
                    }

                }
            }
            group(LotNr8)
            {
                Caption = 'ChargenNr';
                Visible = bShow8;
                grid(grid8)
                {
                    GridLayout = Rows;

                    field(tChargenText8; tChargenText8)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Charge 8';
                    }

                }
            }
            group(LotNr9)
            {
                Caption = 'ChargenNr';
                Visible = bShow9;
                grid(grid9)
                {
                    GridLayout = Rows;

                    field(tChargenText9; tChargenText9)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Charge 9';
                    }

                }
            }
            group(LotNr10)
            {
                Caption = 'ChargenNr';
                Visible = bShow10;
                grid(grid10)
                {
                    GridLayout = Rows;

                    field(tChargenText10; tChargenText10)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Charge 10';
                    }

                }
            }

        }
    }

    actions
    {
    }



    trigger OnAfterGetRecord()
    var
        recILE: Record "32";
        recSSL: Record "111";
        recTmpResEntry: Record "337" temporary;
        recLot: Record "6505";
        iEntryNr: Integer;
    begin
        ShowExternalLot := TRUE; // >> CCU146.05

        iCounter := 0;
        cLot1 := '';
        cLot2 := '';
        cLot3 := '';
        cLot4 := '';
        cLot5 := '';
        cLot6 := '';
        cLot7 := '';
        cLot8 := '';
        cLot9 := '';
        cLot10 := '';
        cEx1 := '';
        cEx2 := '';
        cEx3 := '';
        cEx4 := '';
        cEx5 := '';
        cEx6 := '';
        cEx7 := '';
        cEx8 := '';
        cEx9 := '';
        cEx10 := '';
        cCr1 := '';
        cCr2 := '';
        cCr3 := '';
        cCr4 := '';
        cCr5 := '';
        cCr6 := '';
        cCr7 := '';
        cCr8 := '';
        cCr9 := '';
        cCr10 := '';
        cMenge1 := '';
        cMenge2 := '';
        cMenge3 := '';
        cMenge4 := '';
        cMenge5 := '';
        cMenge6 := '';
        cMenge7 := '';
        cMenge8 := '';
        cMenge9 := '';
        cMenge10 := '';
        tChargenText1 := '';
        tChargenText2 := '';
        tChargenText3 := '';
        tChargenText4 := '';
        tChargenText5 := '';
        tChargenText6 := '';
        tChargenText7 := '';
        tChargenText8 := '';
        tChargenText9 := '';
        tChargenText10 := '';



        IF Type = Type::Item THEN BEGIN

            //Summieren der Reservierungen in einer Tmp Tabelle um Chargenänderungen nicht extra in einem Bereich anzuzeigen
            CLEAR(recResEntry);
            recResEntry.SETCURRENTKEY("Item No.", "Variant Code", "Lot No.");
            recResEntry.SetRange("Item No.", "No.");
            recResEntry.SetRange("Source ID", "Document No.");
            recResEntry.SetRange("Source Ref. No.", "Line No.");
            recResEntry.SetRange("Item Tracking", recResEntry."Item Tracking"::"Lot No.");
            recResEntry.SETFILTER("Lot No.", '<>%1', '');
            iEntryNr := 1;
            IF recResEntry.FINDSET THEN BEGIN
                REPEAT

                    recTmpResEntry.SetRange("Item No.", recResEntry."Item No.");
                    recTmpResEntry.SetRange("Lot No.", recResEntry."Lot No.");
                    IF recTmpResEntry.FindFirst THEN BEGIN
                        recTmpResEntry.Quantity += ABS(recResEntry.Quantity);
                        recTmpResEntry.MODIFY;
                    END ELSE BEGIN
                        recTmpResEntry.INIT;
                        recTmpResEntry."Entry No." := iEntryNr;
                        iEntryNr += 1;
                        recTmpResEntry."Item No." := recResEntry."Item No.";
                        recTmpResEntry."Lot No." := recResEntry."Lot No.";
                        recTmpResEntry."Verkaufschargennr." := recResEntry."Verkaufschargennr.";
                        recTmpResEntry.Quantity := ABS(recResEntry.Quantity);
                        recTmpResEntry.INSERT;
                    END;
                UNTIL recResEntry.NEXT = 0;
            END;

            CLEAR(recTmpResEntry);
            recTmpResEntry.SETCURRENTKEY("Item No.", "Variant Code", "Lot No.");
            recTmpResEntry.SetRange("Item No.", "No.");
            IF recTmpResEntry.FindFirst THEN BEGIN
                REPEAT
                    IF recLot.GET(recTmpResEntry."Item No.", '', recTmpResEntry."Lot No.") THEN BEGIN     //MFU 20.08.2020 -> Ablaufdatum aus Chargenstamm holen, in Resposten nicht immer befüllt
                        ItemNo := recTmpResEntry."Item No.";
                        CASE iCounter OF
                            0:
                                BEGIN
                                    cLot1 := recTmpResEntry."Lot No.";
                                    ExtLot1 := recTmpResEntry."Verkaufschargennr."; // >> CCU146.05
                                    cEx1 := FORMAT(recLot."Expiration Date");
                                    cCr1 := FORMAT(recLot.Status);
                                    cMenge1 := FORMAT(recTmpResEntry.Quantity);
                                    tChargenText1 := cLot1 + ' ' + cEx1 + ' ' + cCr1 + ' ' + cMenge1;
                                END;
                            1:
                                BEGIN
                                    cLot2 := recTmpResEntry."Lot No.";
                                    ExtLot2 := recTmpResEntry."Verkaufschargennr."; // >> CCU146.05
                                    cEx2 := FORMAT(recLot."Expiration Date");
                                    cCr2 := FORMAT(recLot.Status);
                                    cMenge2 := FORMAT(recTmpResEntry.Quantity);
                                    tChargenText2 := cLot2 + ' ' + cEx2 + ' ' + cCr2 + ' ' + cMenge2;
                                END;
                            2:
                                BEGIN
                                    cLot3 := recTmpResEntry."Lot No.";
                                    ExtLot3 := recTmpResEntry."Verkaufschargennr."; // >> CCU146.05
                                    cEx3 := FORMAT(recLot."Expiration Date");
                                    cCr3 := FORMAT(recLot.Status);
                                    cMenge3 := FORMAT(recTmpResEntry.Quantity);
                                    tChargenText3 := cLot3 + ' ' + cEx3 + ' ' + cCr3 + ' ' + cMenge3;
                                END;
                            3:
                                BEGIN
                                    cLot4 := recTmpResEntry."Lot No.";
                                    ExtLot4 := recTmpResEntry."Verkaufschargennr."; // >> CCU146.05
                                    cEx4 := FORMAT(recLot."Expiration Date");
                                    cCr4 := FORMAT(recLot.Status);
                                    cMenge4 := FORMAT(recTmpResEntry.Quantity);
                                    tChargenText4 := cLot4 + ' ' + cEx4 + ' ' + cCr4 + ' ' + cMenge4;
                                END;
                            4:
                                BEGIN
                                    cLot5 := recTmpResEntry."Lot No.";
                                    ExtLot5 := recTmpResEntry."Verkaufschargennr."; // >> CCU146.05
                                    cEx5 := FORMAT(recLot."Expiration Date");
                                    cCr5 := FORMAT(recLot.Status);
                                    cMenge5 := FORMAT(recTmpResEntry.Quantity);
                                    tChargenText5 := cLot5 + ' ' + cEx5 + ' ' + cCr5 + ' ' + cMenge5;
                                END;
                            5:
                                BEGIN
                                    cLot6 := recTmpResEntry."Lot No.";
                                    ExtLot6 := recTmpResEntry."Verkaufschargennr."; // >> CCU146.05
                                    cEx6 := FORMAT(recLot."Expiration Date");
                                    cCr6 := FORMAT(recLot.Status);
                                    cMenge6 := FORMAT(recTmpResEntry.Quantity);
                                    tChargenText6 := cLot6 + ' ' + cEx6 + ' ' + cCr6 + ' ' + cMenge6;
                                END;
                            6:
                                BEGIN
                                    cLot7 := recTmpResEntry."Lot No.";
                                    ExtLot7 := recTmpResEntry."Verkaufschargennr."; // >> CCU146.05
                                    cEx7 := FORMAT(recLot."Expiration Date");
                                    cCr7 := FORMAT(recLot.Status);
                                    cMenge7 := FORMAT(recTmpResEntry.Quantity);
                                    tChargenText7 := cLot7 + ' ' + cEx7 + ' ' + cCr7 + ' ' + cMenge7;
                                END;
                            7:
                                BEGIN
                                    cLot8 := recTmpResEntry."Lot No.";
                                    ExtLot8 := recTmpResEntry."Verkaufschargennr."; // >> CCU146.05
                                    cEx8 := FORMAT(recLot."Expiration Date");
                                    cCr8 := FORMAT(recLot.Status);
                                    cMenge8 := FORMAT(recTmpResEntry.Quantity);
                                    tChargenText8 := cLot8 + ' ' + cEx8 + ' ' + cCr8 + ' ' + cMenge8;
                                END;
                            8:
                                BEGIN
                                    cLot9 := recTmpResEntry."Lot No.";
                                    ExtLot9 := recTmpResEntry."Verkaufschargennr."; // >> CCU146.05
                                    cEx9 := FORMAT(recLot."Expiration Date");
                                    cCr9 := FORMAT(recLot.Status);
                                    cMenge9 := FORMAT(recTmpResEntry.Quantity);
                                    tChargenText9 := cLot9 + ' ' + cEx9 + ' ' + cCr9 + ' ' + cMenge9;
                                END;
                            9:
                                BEGIN
                                    cLot10 := recTmpResEntry."Lot No.";
                                    ExtLot10 := recTmpResEntry."Verkaufschargennr."; // >> CCU146.05
                                    cEx10 := FORMAT(recLot."Expiration Date");
                                    cCr10 := FORMAT(recLot.Status);
                                    cMenge10 := FORMAT(recTmpResEntry.Quantity);
                                    tChargenText10 := cLot10 + ' ' + cEx10 + ' ' + cCr10 + ' ' + cMenge10;
                                END;
                        END;
                        iCounter := iCounter + 1;
                    END;
                UNTIL recTmpResEntry.NEXT = 0;

            END ELSE BEGIN
                // Chargeninfo aus den Artikelposten holen -> ResPosten nach dem verbuchen nicht mehr vorhanden


                recSSL.SetRange("Order No.", "Document No.");
                recSSL.SetRange("Order Line No.", "Line No.");
                IF recSSL.FindFirst THEN BEGIN
                    recILE.SetRange("Item No.", recSSL."No.");
                    recILE.SetRange("Document No.", recSSL."Document No.");
                    IF recILE.FindFirst THEN
                        REPEAT

                            IF recLot.GET(recILE."Item No.", '', recILE."Lot No.") THEN BEGIN     //MFU 20.08.2020 -> Ablaufdatum aus Chargenstamm holen, in Resposten nicht immer befüllt
                                ItemNo := recILE."Item No.";
                                CASE iCounter OF
                                    0:
                                        BEGIN
                                            cLot1 := recILE."Lot No.";
                                            cEx1 := FORMAT(recLot."Expiration Date");
                                            cCr1 := FORMAT(recLot.Status);
                                            cMenge1 := FORMAT(ABS(recILE.Quantity));
                                            tChargenText1 := cLot1 + ' ' + cEx1 + ' ' + cCr1 + ' ' + cMenge1;
                                        END;
                                    1:
                                        BEGIN
                                            cLot2 := recILE."Lot No.";
                                            cEx2 := FORMAT(recLot."Expiration Date");
                                            cCr2 := FORMAT(recLot.Status);
                                            cMenge2 := FORMAT(ABS(recILE.Quantity));
                                            tChargenText2 := cLot2 + ' ' + cEx2 + ' ' + cCr2 + ' ' + cMenge2;
                                        END;
                                    2:
                                        BEGIN
                                            cLot3 := recILE."Lot No.";
                                            cEx3 := FORMAT(recLot."Expiration Date");
                                            cCr3 := FORMAT(recLot.Produktionsdatum);
                                            cMenge3 := FORMAT(ABS(recILE.Quantity));
                                            tChargenText3 := cLot3 + ' ' + cEx3 + ' ' + cCr3 + ' ' + cMenge3;
                                        END;
                                    3:
                                        BEGIN
                                            cLot4 := recILE."Lot No.";
                                            cEx4 := FORMAT(recLot."Expiration Date");
                                            cCr4 := FORMAT(recLot.Status);
                                            cMenge4 := FORMAT(ABS(recILE.Quantity));
                                            tChargenText4 := cLot4 + ' ' + cEx4 + ' ' + cCr4 + ' ' + cMenge4;
                                        END;
                                    4:
                                        BEGIN
                                            cLot5 := recILE."Lot No.";
                                            cEx5 := FORMAT(recLot."Expiration Date");
                                            cCr5 := FORMAT(recLot.Status);
                                            cMenge5 := FORMAT(ABS(recILE.Quantity));
                                            tChargenText5 := cLot5 + ' ' + cEx5 + ' ' + cCr5 + ' ' + cMenge5;
                                        END;
                                    5:
                                        BEGIN
                                            cLot6 := recILE."Lot No.";
                                            cEx6 := FORMAT(recLot."Expiration Date");
                                            cCr6 := FORMAT(recLot.Status);
                                            cMenge6 := FORMAT(ABS(recILE.Quantity));
                                            tChargenText6 := cLot6 + ' ' + cEx6 + ' ' + cCr6 + ' ' + cMenge6;
                                        END;
                                    6:
                                        BEGIN
                                            cLot7 := recILE."Lot No.";
                                            cEx7 := FORMAT(recLot."Expiration Date");
                                            cCr7 := FORMAT(recLot.Status);
                                            cMenge7 := FORMAT(ABS(recILE.Quantity));
                                            tChargenText7 := cLot7 + ' ' + cEx7 + ' ' + cCr7 + ' ' + cMenge7;
                                        END;
                                    7:
                                        BEGIN
                                            cLot8 := recILE."Lot No.";
                                            cEx8 := FORMAT(recLot."Expiration Date");
                                            cCr8 := FORMAT(recLot.Status);
                                            cMenge8 := FORMAT(ABS(recILE.Quantity));
                                            tChargenText8 := cLot8 + ' ' + cEx8 + ' ' + cCr8 + ' ' + cMenge8;
                                        END;
                                    8:
                                        BEGIN
                                            cLot9 := recILE."Lot No.";
                                            cEx9 := FORMAT(recLot."Expiration Date");
                                            cCr9 := FORMAT(recLot.Status);
                                            cMenge9 := FORMAT(ABS(recILE.Quantity));
                                            tChargenText9 := cLot9 + ' ' + cEx9 + ' ' + cCr9 + ' ' + cMenge9;
                                        END;
                                    9:
                                        BEGIN
                                            cLot10 := recILE."Lot No.";
                                            cEx10 := FORMAT(recLot."Expiration Date");
                                            cCr10 := FORMAT(recLot.Status);
                                            cMenge10 := FORMAT(ABS(recILE.Quantity));
                                            tChargenText10 := cLot10 + ' ' + cEx10 + ' ' + cCr10 + ' ' + cMenge10;
                                        END;
                                END;
                                iCounter := iCounter + 1;
                            END;


                        UNTIL recILE.NEXT = 0;
                END;

            END;

        END;

        IF STRLEN(cLot1) > 1 THEN bShow1 := TRUE ELSE bShow1 := FALSE;
        IF STRLEN(cLot2) > 1 THEN bShow2 := TRUE ELSE bShow2 := FALSE;
        IF STRLEN(cLot3) > 1 THEN bShow3 := TRUE ELSE bShow3 := FALSE;
        IF STRLEN(cLot4) > 1 THEN bShow4 := TRUE ELSE bShow4 := FALSE;
        IF STRLEN(cLot5) > 1 THEN bShow5 := TRUE ELSE bShow5 := FALSE;
        IF STRLEN(cLot6) > 1 THEN bShow6 := TRUE ELSE bShow6 := FALSE;
        IF STRLEN(cLot7) > 1 THEN bShow7 := TRUE ELSE bShow7 := FALSE;
        IF STRLEN(cLot8) > 1 THEN bShow8 := TRUE ELSE bShow8 := FALSE;
        IF STRLEN(cLot9) > 1 THEN bShow9 := TRUE ELSE bShow9 := FALSE;
        IF STRLEN(cLot10) > 1 THEN bShow10 := TRUE ELSE bShow10 := FALSE;
    end;

    var
        recResEntry: Record "337";
        bShow1: Boolean;
        bShow2: Boolean;
        bShow3: Boolean;
        bShow4: Boolean;
        bShow5: Boolean;
        bShow6: Boolean;
        bShow7: Boolean;
        bShow8: Boolean;
        bShow9: Boolean;
        bShow10: Boolean;
        ShowExternalLot: Boolean;
        cCr1: Code[20];
        cCr2: Code[20];
        cCr3: Code[20];
        cCr4: Code[20];
        cCr5: Code[20];
        cCr6: Code[20];
        cCr7: Code[20];
        cCr8: Code[20];
        cCr9: Code[20];
        cCr10: Code[20];
        cEx1: Code[20];
        cEx2: Code[20];
        cEx3: Code[20];
        cEx4: Code[20];
        cEx5: Code[20];
        cEx6: Code[20];
        cEx7: Code[20];
        cEx8: Code[20];
        cEx9: Code[20];
        cEx10: Code[20];
        cLot1: Code[20];
        cLot2: Code[20];
        cLot3: Code[20];
        cLot4: Code[20];
        cLot5: Code[20];
        cLot6: Code[20];
        cLot7: Code[20];
        cLot8: Code[20];
        cLot9: Code[20];
        cLot10: Code[20];
        cMenge1: Code[20];
        cMenge2: Code[20];
        cMenge3: Code[20];
        cMenge4: Code[20];
        cMenge5: Code[20];
        cMenge6: Code[20];
        cMenge7: Code[20];
        cMenge8: Code[20];
        cMenge9: Code[20];
        cMenge10: Code[20];
        ExtLot1: Code[20];
        ExtLot2: Code[20];
        ExtLot3: Code[20];
        ExtLot4: Code[20];
        ExtLot5: Code[20];
        ExtLot6: Code[20];
        ExtLot7: Code[20];
        ExtLot8: Code[20];
        ExtLot9: Code[20];
        ExtLot10: Code[20];
        ItemNo: Code[20];
        iCounter: Integer;
        tChargenText1: Text[100];
        tChargenText2: Text[100];
        tChargenText3: Text[100];
        tChargenText4: Text[100];
        tChargenText5: Text[100];
        tChargenText6: Text[100];
        tChargenText7: Text[100];
        tChargenText8: Text[100];
        tChargenText9: Text[100];
        tChargenText10: Text[100];

    procedure ResetValues()
    begin
        iCounter := 0;
        cLot1 := '';
        cLot2 := '';
        cLot3 := '';
        cLot4 := '';
        cLot5 := '';
        cLot6 := '';
        cLot7 := '';
        cLot8 := '';
        cLot9 := '';
        cLot10 := '';
        cEx1 := '';
        cEx2 := '';
        cEx3 := '';
        cEx4 := '';
        cEx5 := '';
        cEx6 := '';
        cEx7 := '';
        cEx8 := '';
        cEx9 := '';
        cEx10 := '';
        cCr1 := '';
        cCr2 := '';
        cCr3 := '';
        cCr4 := '';
        cCr5 := '';
        cCr6 := '';
        cCr7 := '';
        cCr8 := '';
        cCr9 := '';
        cCr10 := '';
        cMenge1 := '';
        cMenge2 := '';
        cMenge3 := '';
        cMenge4 := '';
        cMenge5 := '';
        cMenge6 := '';
        cMenge7 := '';
        cMenge8 := '';
        cMenge9 := '';
        cMenge10 := '';

        CurrPage.UPDATE;
    end;

    procedure ShowExternalLotNo(ShowLot: Boolean)
    begin
        ShowExternalLot := ShowLot; // >> CCU146.05
    end;
}

