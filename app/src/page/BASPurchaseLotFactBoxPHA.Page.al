// ToDo -> All (ReDesign -> List or Array!! .........)
// BASSalesLotFactBoxPHA, BASPurchaseLotFactBoxPHA, BASSalesInvLotFactBoxPHA
page 50010 BASPurchaseLotFactBoxPHA
{
    Editable = false;
    PageType = CardPart;
    PopulateAllFields = true;
    RefreshOnActivate = true;
    SourceTable = "Purchase Line";

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
                        ToolTip = 'Specifies the value of the Charge 1 field.';
                    }
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
                        ToolTip = 'Specifies the value of the Charge 2 field.';
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
                        ToolTip = 'Specifies the value of the Charge 3 field.';
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
                        ToolTip = 'Specifies the value of the Charge 4 field.';
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
                        ToolTip = 'Specifies the value of the Charge 5 field.';
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
                        ToolTip = 'Specifies the value of the Charge 6 field.';
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
                        ToolTip = 'Specifies the value of the Charge 7 field.';
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
                        ToolTip = 'Specifies the value of the Charge 8 field.';
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
                        ToolTip = 'Specifies the value of the Charge 9 field.';
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
                        ToolTip = 'Specifies the value of the Charge 10 field.';
                    }

                }
            }

        }
    }

    trigger OnAfterGetRecord()
    // var
    //     recILE: Record "32";
    //     recTmpResEntry: Record "337" temporary;
    //     recLot: Record "6505";
    //     recSRL: Record "Purch. Rcpt. Line";
    //     iEntryNr: Integer;
    begin
        // ShowExternalLot := true; // >> CCU146.05

        // iCounter := 0;
        // cLot1 := '';
        // cLot2 := '';
        // cLot3 := '';
        // cLot4 := '';
        // cLot5 := '';
        // cLot6 := '';
        // cLot7 := '';
        // cLot8 := '';
        // cLot9 := '';
        // cLot10 := '';
        // cEx1 := '';
        // cEx2 := '';
        // cEx3 := '';
        // cEx4 := '';
        // cEx5 := '';
        // cEx6 := '';
        // cEx7 := '';
        // cEx8 := '';
        // cEx9 := '';
        // cEx10 := '';
        // cCr1 := '';
        // cCr2 := '';
        // cCr3 := '';
        // cCr4 := '';
        // cCr5 := '';
        // cCr6 := '';
        // cCr7 := '';
        // cCr8 := '';
        // cCr9 := '';
        // cCr10 := '';
        // cMenge1 := '';
        // cMenge2 := '';
        // cMenge3 := '';
        // cMenge4 := '';
        // cMenge5 := '';
        // cMenge6 := '';
        // cMenge7 := '';
        // cMenge8 := '';
        // cMenge9 := '';
        // cMenge10 := '';
        // tChargenText1 := '';
        // tChargenText2 := '';
        // tChargenText3 := '';
        // tChargenText4 := '';
        // tChargenText5 := '';
        // tChargenText6 := '';
        // tChargenText7 := '';
        // tChargenText8 := '';
        // tChargenText9 := '';
        // tChargenText10 := '';



        // if Type = Type::Item then begin

        //     //Summieren der Reservierungen in einer Tmp Tabelle um Chargenänderungen nicht extra in einem Bereich anzuzeigen
        //     CLEAR(recResEntry);
        //     recResEntry.SETCURRENTKEY("Item No.", "Variant Code", "Lot No.");
        //     recResEntry.SetRange("Item No.", "No.");
        //     recResEntry.SetRange("Source ID", "Document No.");
        //     recResEntry.SetRange("Source Ref. No.", "Line No.");
        //     recResEntry.SetRange("Item Tracking", recResEntry."Item Tracking"::"Lot No.");
        //     recResEntry.SETFILTER("Lot No.", '<>%1', '');
        //     iEntryNr := 1;
        //     if recResEntry.FINDSET then begin
        //         repeat

        //             recTmpResEntry.SetRange("Item No.", recResEntry."Item No.");
        //             recTmpResEntry.SetRange("Lot No.", recResEntry."Lot No.");
        //             if recTmpResEntry.FindFirst then begin
        //                 recTmpResEntry.Quantity += ABS(recResEntry.Quantity);
        //                 recTmpResEntry.MODIFY;
        //             end else begin
        //                 recTmpResEntry.INIT;
        //                 recTmpResEntry."Entry No." := iEntryNr;
        //                 iEntryNr += 1;
        //                 recTmpResEntry."Item No." := recResEntry."Item No.";
        //                 recTmpResEntry."Lot No." := recResEntry."Lot No.";
        //                 recTmpResEntry."Verkaufschargennr." := recResEntry."Verkaufschargennr.";
        //                 recTmpResEntry.Quantity := ABS(recResEntry.Quantity);
        //                 recTmpResEntry.INSERT;
        //             end;
        //         until recResEntry.NEXT = 0;
        //     end;

        //     CLEAR(recTmpResEntry);
        //     recTmpResEntry.SETCURRENTKEY("Item No.", "Variant Code", "Lot No.");
        //     recTmpResEntry.SetRange("Item No.", "No.");
        //     if recTmpResEntry.FindSet() then begin
        //         repeat
        //             if recLot.Get(recTmpResEntry."Item No.", '', recTmpResEntry."Lot No.") then begin     //MFU 20.08.2020 -> Ablaufdatum aus Chargenstamm holen, in Resposten nicht immer befüllt
        //                 ItemNo := recTmpResEntry."Item No.";
        //                 case iCounter of
        //                     0:
        //                         begin
        //                             cLot1 := recTmpResEntry."Lot No.";
        //                             ExtLot1 := recTmpResEntry."Verkaufschargennr."; // >> CCU146.05
        //                             cEx1 := FORMAT(recLot."Expiration Date");
        //                             cCr1 := FORMAT(recLot.Status);
        //                             cMenge1 := FORMAT(recTmpResEntry.Quantity);
        //                             tChargenText1 := cLot1 + ' ' + cEx1 + ' ' + cCr1 + ' ' + cMenge1;
        //                         end;
        //                     1:
        //                         begin
        //                             cLot2 := recTmpResEntry."Lot No.";
        //                             ExtLot2 := recTmpResEntry."Verkaufschargennr."; // >> CCU146.05
        //                             cEx2 := FORMAT(recLot."Expiration Date");
        //                             cCr2 := FORMAT(recLot.Status);
        //                             cMenge2 := FORMAT(recTmpResEntry.Quantity);
        //                             tChargenText2 := cLot2 + ' ' + cEx2 + ' ' + cCr2 + ' ' + cMenge2;
        //                         end;
        //                     2:
        //                         begin
        //                             cLot3 := recTmpResEntry."Lot No.";
        //                             ExtLot3 := recTmpResEntry."Verkaufschargennr."; // >> CCU146.05
        //                             cEx3 := FORMAT(recLot."Expiration Date");
        //                             cCr3 := FORMAT(recLot.Status);
        //                             cMenge3 := FORMAT(recTmpResEntry.Quantity);
        //                             tChargenText3 := cLot3 + ' ' + cEx3 + ' ' + cCr3 + ' ' + cMenge3;
        //                         end;
        //                     3:
        //                         begin
        //                             cLot4 := recTmpResEntry."Lot No.";
        //                             ExtLot4 := recTmpResEntry."Verkaufschargennr."; // >> CCU146.05
        //                             cEx4 := FORMAT(recLot."Expiration Date");
        //                             cCr4 := FORMAT(recLot.Status);
        //                             cMenge4 := FORMAT(recTmpResEntry.Quantity);
        //                             tChargenText4 := cLot4 + ' ' + cEx4 + ' ' + cCr4 + ' ' + cMenge4;
        //                         end;
        //                     4:
        //                         begin
        //                             cLot5 := recTmpResEntry."Lot No.";
        //                             ExtLot5 := recTmpResEntry."Verkaufschargennr."; // >> CCU146.05
        //                             cEx5 := FORMAT(recLot."Expiration Date");
        //                             cCr5 := FORMAT(recLot.Status);
        //                             cMenge5 := FORMAT(recTmpResEntry.Quantity);
        //                             tChargenText5 := cLot5 + ' ' + cEx5 + ' ' + cCr5 + ' ' + cMenge5;
        //                         end;
        //                     5:
        //                         begin
        //                             cLot6 := recTmpResEntry."Lot No.";
        //                             ExtLot6 := recTmpResEntry."Verkaufschargennr."; // >> CCU146.05
        //                             cEx6 := FORMAT(recLot."Expiration Date");
        //                             cCr6 := FORMAT(recLot.Status);
        //                             cMenge6 := FORMAT(recTmpResEntry.Quantity);
        //                             tChargenText6 := cLot6 + ' ' + cEx6 + ' ' + cCr6 + ' ' + cMenge6;
        //                         end;
        //                     6:
        //                         begin
        //                             cLot7 := recTmpResEntry."Lot No.";
        //                             ExtLot7 := recTmpResEntry."Verkaufschargennr."; // >> CCU146.05
        //                             cEx7 := FORMAT(recLot."Expiration Date");
        //                             cCr7 := FORMAT(recLot.Status);
        //                             cMenge7 := FORMAT(recTmpResEntry.Quantity);
        //                             tChargenText7 := cLot7 + ' ' + cEx7 + ' ' + cCr7 + ' ' + cMenge7;
        //                         end;
        //                     7:
        //                         begin
        //                             cLot8 := recTmpResEntry."Lot No.";
        //                             ExtLot8 := recTmpResEntry."Verkaufschargennr."; // >> CCU146.05
        //                             cEx8 := FORMAT(recLot."Expiration Date");
        //                             cCr8 := FORMAT(recLot.Status);
        //                             cMenge8 := FORMAT(recTmpResEntry.Quantity);
        //                             tChargenText8 := cLot8 + ' ' + cEx8 + ' ' + cCr8 + ' ' + cMenge8;
        //                         end;
        //                     8:
        //                         begin
        //                             cLot9 := recTmpResEntry."Lot No.";
        //                             ExtLot9 := recTmpResEntry."Verkaufschargennr."; // >> CCU146.05
        //                             cEx9 := FORMAT(recLot."Expiration Date");
        //                             cCr9 := FORMAT(recLot.Status);
        //                             cMenge9 := FORMAT(recTmpResEntry.Quantity);
        //                             tChargenText9 := cLot9 + ' ' + cEx9 + ' ' + cCr9 + ' ' + cMenge9;
        //                         end;
        //                     9:
        //                         begin
        //                             cLot10 := recTmpResEntry."Lot No.";
        //                             ExtLot10 := recTmpResEntry."Verkaufschargennr."; // >> CCU146.05
        //                             cEx10 := FORMAT(recLot."Expiration Date");
        //                             cCr10 := FORMAT(recLot.Status);
        //                             cMenge10 := FORMAT(recTmpResEntry.Quantity);
        //                             tChargenText10 := cLot10 + ' ' + cEx10 + ' ' + cCr10 + ' ' + cMenge10;
        //                         end;
        //                 end;
        //             end else begin
        //                 //Chargenstamm Eintrag ist noch nicht vorhanden
        //                 case iCounter of
        //                     0:
        //                         begin
        //                             cLot1 := recTmpResEntry."Lot No.";
        //                             tChargenText1 := recTmpResEntry."Lot No." + ' ' + FORMAT(ABS(recTmpResEntry.Quantity));
        //                         end;
        //                     1:
        //                         begin
        //                             cLot2 := recTmpResEntry."Lot No.";
        //                             tChargenText2 := recTmpResEntry."Lot No." + ' ' + FORMAT(ABS(recTmpResEntry.Quantity));
        //                         end;
        //                     2:
        //                         begin
        //                             cLot3 := recTmpResEntry."Lot No.";
        //                             tChargenText3 := recTmpResEntry."Lot No." + ' ' + FORMAT(ABS(recTmpResEntry.Quantity));
        //                         end;
        //                     3:
        //                         begin
        //                             cLot4 := recTmpResEntry."Lot No.";
        //                             tChargenText4 := recTmpResEntry."Lot No." + ' ' + FORMAT(ABS(recTmpResEntry.Quantity));
        //                         end;
        //                     4:
        //                         begin
        //                             cLot5 := recTmpResEntry."Lot No.";
        //                             tChargenText5 := recTmpResEntry."Lot No." + ' ' + FORMAT(ABS(recTmpResEntry.Quantity));
        //                         end;
        //                     5:
        //                         begin
        //                             cLot6 := recTmpResEntry."Lot No.";
        //                             tChargenText6 := recTmpResEntry."Lot No." + ' ' + FORMAT(ABS(recTmpResEntry.Quantity));
        //                         end;
        //                     6:
        //                         begin
        //                             cLot7 := recTmpResEntry."Lot No.";
        //                             tChargenText7 := recTmpResEntry."Lot No." + ' ' + FORMAT(ABS(recTmpResEntry.Quantity));
        //                         end;
        //                     7:
        //                         begin
        //                             cLot8 := recTmpResEntry."Lot No.";
        //                             tChargenText8 := recTmpResEntry."Lot No." + ' ' + FORMAT(ABS(recTmpResEntry.Quantity));
        //                         end;
        //                     8:
        //                         begin
        //                             cLot9 := recTmpResEntry."Lot No.";
        //                             tChargenText9 := recTmpResEntry."Lot No." + ' ' + FORMAT(ABS(recTmpResEntry.Quantity));
        //                         end;
        //                     9:
        //                         begin
        //                             cLot10 := recTmpResEntry."Lot No.";
        //                             tChargenText10 := recTmpResEntry."Lot No." + ' ' + FORMAT(ABS(recTmpResEntry.Quantity));
        //                         end;
        //                 end;
        //             end;

        //             iCounter := iCounter + 1;
        //         until recTmpResEntry.NEXT = 0;

        //     end else begin
        //         // Chargeninfo aus den Artikelposten holen -> ResPosten nach dem verbuchen nicht mehr vorhanden


        //         recSRL.SetRange("Order No.", "Document No.");
        //         recSRL.SetRange("Order Line No.", "Line No.");
        //         if recSRL.FindFirst then begin
        //             recILE.SetRange("Item No.", recSRL."No.");
        //             recILE.SetRange("Document No.", recSRL."Document No.");
        //             if recILE.FindFirst then
        //                 repeat

        //                     ItemNo := recILE."Item No.";
        //                     if recLot.Get(recILE."Item No.", '', recILE."Lot No.") then begin     //MFU 20.08.2020 -> Ablaufdatum aus Chargenstamm holen, in Resposten nicht immer befüllt

        //                         case iCounter of
        //                             0:
        //                                 begin
        //                                     cLot1 := recILE."Lot No.";
        //                                     cEx1 := FORMAT(recLot."Expiration Date");
        //                                     cCr1 := FORMAT(recLot.Status);
        //                                     cMenge1 := FORMAT(ABS(recILE.Quantity));
        //                                     tChargenText1 := cLot1 + ' ' + cEx1 + ' ' + cCr1 + ' ' + cMenge1;
        //                                 end;
        //                             1:
        //                                 begin
        //                                     cLot2 := recILE."Lot No.";
        //                                     cEx2 := FORMAT(recLot."Expiration Date");
        //                                     cCr2 := FORMAT(recLot.Status);
        //                                     cMenge2 := FORMAT(ABS(recILE.Quantity));
        //                                     tChargenText2 := cLot2 + ' ' + cEx2 + ' ' + cCr2 + ' ' + cMenge2;
        //                                 end;
        //                             2:
        //                                 begin
        //                                     cLot3 := recILE."Lot No.";
        //                                     cEx3 := FORMAT(recLot."Expiration Date");
        //                                     cCr3 := FORMAT(recLot.Produktionsdatum);
        //                                     cMenge3 := FORMAT(ABS(recILE.Quantity));
        //                                     tChargenText3 := cLot3 + ' ' + cEx3 + ' ' + cCr3 + ' ' + cMenge3;
        //                                 end;
        //                             3:
        //                                 begin
        //                                     cLot4 := recILE."Lot No.";
        //                                     cEx4 := FORMAT(recLot."Expiration Date");
        //                                     cCr4 := FORMAT(recLot.Status);
        //                                     cMenge4 := FORMAT(ABS(recILE.Quantity));
        //                                     tChargenText4 := cLot4 + ' ' + cEx4 + ' ' + cCr4 + ' ' + cMenge4;
        //                                 end;
        //                             4:
        //                                 begin
        //                                     cLot5 := recILE."Lot No.";
        //                                     cEx5 := FORMAT(recLot."Expiration Date");
        //                                     cCr5 := FORMAT(recLot.Status);
        //                                     cMenge5 := FORMAT(ABS(recILE.Quantity));
        //                                     tChargenText5 := cLot5 + ' ' + cEx5 + ' ' + cCr5 + ' ' + cMenge5;
        //                                 end;
        //                             5:
        //                                 begin
        //                                     cLot6 := recILE."Lot No.";
        //                                     cEx6 := FORMAT(recLot."Expiration Date");
        //                                     cCr6 := FORMAT(recLot.Status);
        //                                     cMenge6 := FORMAT(ABS(recILE.Quantity));
        //                                     tChargenText6 := cLot6 + ' ' + cEx6 + ' ' + cCr6 + ' ' + cMenge6;
        //                                 end;
        //                             6:
        //                                 begin
        //                                     cLot7 := recILE."Lot No.";
        //                                     cEx7 := FORMAT(recLot."Expiration Date");
        //                                     cCr7 := FORMAT(recLot.Status);
        //                                     cMenge7 := FORMAT(ABS(recILE.Quantity));
        //                                     tChargenText7 := cLot7 + ' ' + cEx7 + ' ' + cCr7 + ' ' + cMenge7;
        //                                 end;
        //                             7:
        //                                 begin
        //                                     cLot8 := recILE."Lot No.";
        //                                     cEx8 := FORMAT(recLot."Expiration Date");
        //                                     cCr8 := FORMAT(recLot.Status);
        //                                     cMenge8 := FORMAT(ABS(recILE.Quantity));
        //                                     tChargenText8 := cLot8 + ' ' + cEx8 + ' ' + cCr8 + ' ' + cMenge8;
        //                                 end;
        //                             8:
        //                                 begin
        //                                     cLot9 := recILE."Lot No.";
        //                                     cEx9 := FORMAT(recLot."Expiration Date");
        //                                     cCr9 := FORMAT(recLot.Status);
        //                                     cMenge9 := FORMAT(ABS(recILE.Quantity));
        //                                     tChargenText9 := cLot9 + ' ' + cEx9 + ' ' + cCr9 + ' ' + cMenge9;
        //                                 end;
        //                             9:
        //                                 begin
        //                                     cLot10 := recILE."Lot No.";
        //                                     cEx10 := FORMAT(recLot."Expiration Date");
        //                                     cCr10 := FORMAT(recLot.Status);
        //                                     cMenge10 := FORMAT(ABS(recILE.Quantity));
        //                                     tChargenText10 := cLot10 + ' ' + cEx10 + ' ' + cCr10 + ' ' + cMenge10;
        //                                 end;
        //                         end;
        //                         iCounter := iCounter + 1;
        //                     end;


        //                 until recILE.NEXT = 0;
        //         end;

        //     end;


        if StrLen(cLot1) > 1 then bShow1 := true else bShow1 := false;
        if StrLen(cLot2) > 1 then bShow2 := true else bShow2 := false;
        if StrLen(cLot3) > 1 then bShow3 := true else bShow3 := false;
        if StrLen(cLot4) > 1 then bShow4 := true else bShow4 := false;
        if StrLen(cLot5) > 1 then bShow5 := true else bShow5 := false;
        if StrLen(cLot6) > 1 then bShow6 := true else bShow6 := false;
        if StrLen(cLot7) > 1 then bShow7 := true else bShow7 := false;
        if StrLen(cLot8) > 1 then bShow8 := true else bShow8 := false;
        if StrLen(cLot9) > 1 then bShow9 := true else bShow9 := false;
        if StrLen(cLot10) > 1 then bShow10 := true else bShow10 := false;

    end;

    var
        // recResEntry: Record "337";
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

        CurrPage.Update();
    end;

    procedure ShowExternalLotNo(ShowLot: Boolean)
    begin
        ShowExternalLot := ShowLot; // >> CCU146.05
    end;
}

