// ToDo -> All (ReDesign -> List or Array!! .........)
// BASSalesLotFactBoxPHA, BASPurchaseLotFactBoxPHA, BASSalesInvLotFactBoxPHA
page 50008 BASSalesLotFactBoxPHA
{
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
    //     ItemLedgerEntry: Record "Item Ledger Entry";
    //     LotNoInformation: Record "Lot No. Information";
    //     TempReservationEntry: Record "Reservation Entry" temporary;
    //     SalesShipmentLine: Record "Sales Shipment Line";
    //     EntryNo: Integer;
    begin
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


        // if Rec.Type = Rec.Type::Item then begin

        //     ReservationEntry.SETCURRENTKEY("Item No.", "Variant Code", "Lot No.");
        //     ReservationEntry.SetRange("Item No.", Rec."No.");
        //     ReservationEntry.SetRange("Source ID", Rec."Document No.");
        //     ReservationEntry.SetRange("Source Ref. No.", Rec."Line No.");
        //     ReservationEntry.SetRange("Item Tracking", ReservationEntry."Item Tracking"::"Lot No.");
        //     ReservationEntry.SETFILTER("Lot No.", '<>%1', '');
        //     EntryNo := 1;
        //     if ReservationEntry.FINDSET() then
        //         repeat

        //             TempReservationEntry.SetRange("Item No.", ReservationEntry."Item No.");
        //             TempReservationEntry.SetRange("Lot No.", ReservationEntry."Lot No.");
        //             if TempReservationEntry.FindFirst() then begin
        //                 TempReservationEntry.Quantity += ABS(ReservationEntry.Quantity);
        //                 TempReservationEntry.MODIFY();
        //             end else begin
        //                 TempReservationEntry.INIT();
        //                 TempReservationEntry."Entry No." := EntryNo;
        //                 EntryNo += 1;
        //                 TempReservationEntry."Item No." := ReservationEntry."Item No.";
        //                 TempReservationEntry."Lot No." := ReservationEntry."Lot No.";
        //                 TempReservationEntry."Verkaufschargennr." := ReservationEntry."Verkaufschargennr.";
        //                 TempReservationEntry.Quantity := ABS(ReservationEntry.Quantity);
        //                 TempReservationEntry.INSERT();
        //             end;
        //         until ReservationEntry.NEXT() = 0;

        //     TempReservationEntry.SETCURRENTKEY("Item No.", "Variant Code", "Lot No.");
        //     TempReservationEntry.SetRange("Item No.", Rec."No.");
        //     if TempReservationEntry.FindSet() then
        //         repeat
        //             if LotNoInformation.Get(TempReservationEntry."Item No.", '', TempReservationEntry."Lot No.") then begin     //MFU 20.08.2020 -> Ablaufdatum aus Chargenstamm holen, in Resposten nicht immer befüllt
        //                 ItemNo := TempReservationEntry."Item No.";
        //                 case iCounter of
        //                     0:
        //                         begin
        //                             cLot1 := TempReservationEntry."Lot No.";
        //                             ExtLot1 := TempReservationEntry."Verkaufschargennr."; // >> CCU146.05
        //                             cEx1 := FORMAT(LotNoInformation."Expiration Date");
        //                             cCr1 := FORMAT(LotNoInformation.Status);
        //                             cMenge1 := FORMAT(TempReservationEntry.Quantity);
        //                             tChargenText1 := cLot1 + ' ' + cEx1 + ' ' + cCr1 + ' ' + cMenge1;
        //                         end;
        //                     1:
        //                         begin
        //                             cLot2 := TempReservationEntry."Lot No.";
        //                             ExtLot2 := TempReservationEntry."Verkaufschargennr."; // >> CCU146.05
        //                             cEx2 := FORMAT(LotNoInformation."Expiration Date");
        //                             cCr2 := FORMAT(LotNoInformation.Status);
        //                             cMenge2 := FORMAT(TempReservationEntry.Quantity);
        //                             tChargenText2 := cLot2 + ' ' + cEx2 + ' ' + cCr2 + ' ' + cMenge2;
        //                         end;
        //                     2:
        //                         begin
        //                             cLot3 := TempReservationEntry."Lot No.";
        //                             ExtLot3 := TempReservationEntry."Verkaufschargennr."; // >> CCU146.05
        //                             cEx3 := FORMAT(LotNoInformation."Expiration Date");
        //                             cCr3 := FORMAT(LotNoInformation.Status);
        //                             cMenge3 := FORMAT(TempReservationEntry.Quantity);
        //                             tChargenText3 := cLot3 + ' ' + cEx3 + ' ' + cCr3 + ' ' + cMenge3;
        //                         end;
        //                     3:
        //                         begin
        //                             cLot4 := TempReservationEntry."Lot No.";
        //                             ExtLot4 := TempReservationEntry."Verkaufschargennr."; // >> CCU146.05
        //                             cEx4 := FORMAT(LotNoInformation."Expiration Date");
        //                             cCr4 := FORMAT(LotNoInformation.Status);
        //                             cMenge4 := FORMAT(TempReservationEntry.Quantity);
        //                             tChargenText4 := cLot4 + ' ' + cEx4 + ' ' + cCr4 + ' ' + cMenge4;
        //                         end;
        //                     4:
        //                         begin
        //                             cLot5 := TempReservationEntry."Lot No.";
        //                             ExtLot5 := TempReservationEntry."Verkaufschargennr."; // >> CCU146.05
        //                             cEx5 := FORMAT(LotNoInformation."Expiration Date");
        //                             cCr5 := FORMAT(LotNoInformation.Status);
        //                             cMenge5 := FORMAT(TempReservationEntry.Quantity);
        //                             tChargenText5 := cLot5 + ' ' + cEx5 + ' ' + cCr5 + ' ' + cMenge5;
        //                         end;
        //                     5:
        //                         begin
        //                             cLot6 := TempReservationEntry."Lot No.";
        //                             ExtLot6 := TempReservationEntry."Verkaufschargennr."; // >> CCU146.05
        //                             cEx6 := FORMAT(LotNoInformation."Expiration Date");
        //                             cCr6 := FORMAT(LotNoInformation.Status);
        //                             cMenge6 := FORMAT(TempReservationEntry.Quantity);
        //                             tChargenText6 := cLot6 + ' ' + cEx6 + ' ' + cCr6 + ' ' + cMenge6;
        //                         end;
        //                     6:
        //                         begin
        //                             cLot7 := TempReservationEntry."Lot No.";
        //                             ExtLot7 := TempReservationEntry."Verkaufschargennr."; // >> CCU146.05
        //                             cEx7 := FORMAT(LotNoInformation."Expiration Date");
        //                             cCr7 := FORMAT(LotNoInformation.Status);
        //                             cMenge7 := FORMAT(TempReservationEntry.Quantity);
        //                             tChargenText7 := cLot7 + ' ' + cEx7 + ' ' + cCr7 + ' ' + cMenge7;
        //                         end;
        //                     7:
        //                         begin
        //                             cLot8 := TempReservationEntry."Lot No.";
        //                             ExtLot8 := TempReservationEntry."Verkaufschargennr."; // >> CCU146.05
        //                             cEx8 := FORMAT(LotNoInformation."Expiration Date");
        //                             cCr8 := FORMAT(LotNoInformation.Status);
        //                             cMenge8 := FORMAT(TempReservationEntry.Quantity);
        //                             tChargenText8 := cLot8 + ' ' + cEx8 + ' ' + cCr8 + ' ' + cMenge8;
        //                         end;
        //                     8:
        //                         begin
        //                             cLot9 := TempReservationEntry."Lot No.";
        //                             ExtLot9 := TempReservationEntry."Verkaufschargennr."; // >> CCU146.05
        //                             cEx9 := FORMAT(LotNoInformation."Expiration Date");
        //                             cCr9 := FORMAT(LotNoInformation.Status);
        //                             cMenge9 := FORMAT(TempReservationEntry.Quantity);
        //                             tChargenText9 := cLot9 + ' ' + cEx9 + ' ' + cCr9 + ' ' + cMenge9;
        //                         end;
        //                     9:
        //                         begin
        //                             cLot10 := TempReservationEntry."Lot No.";
        //                             ExtLot10 := TempReservationEntry."Verkaufschargennr."; // >> CCU146.05
        //                             cEx10 := FORMAT(LotNoInformation."Expiration Date");
        //                             cCr10 := FORMAT(LotNoInformation.Status);
        //                             cMenge10 := FORMAT(TempReservationEntry.Quantity);
        //                             tChargenText10 := cLot10 + ' ' + cEx10 + ' ' + cCr10 + ' ' + cMenge10;
        //                         end;
        //                 end;
        //                 iCounter := iCounter + 1;
        //             end;
        //         until TempReservationEntry.NEXT() = 0;

        // end else begin
        //     // Chargeninfo aus den Artikelposten holen -> ResPosten nach dem verbuchen nicht mehr vorhanden


        //     SalesShipmentLine.SetRange("Order No.", Rec."Document No.");
        //     SalesShipmentLine.SetRange("Order Line No.", Rec."Line No.");
        //     if SalesShipmentLine.FindFirst() then begin
        //         ItemLedgerEntry.SetRange("Item No.", SalesShipmentLine."No.");
        //         ItemLedgerEntry.SetRange("Document No.", SalesShipmentLine."Document No.");
        //         if ItemLedgerEntry.FindSet() then
        //             repeat
        //                 if LotNoInformation.Get(ItemLedgerEntry."Item No.", '', ItemLedgerEntry."Lot No.") then begin
        //                     ItemNo := ItemLedgerEntry."Item No.";
        //                     case iCounter of
        //                         0:
        //                             begin
        //                                 cLot1 := ItemLedgerEntry."Lot No.";
        //                                 cEx1 := FORMAT(LotNoInformation.BASExpirationDatePHA);
        //                                 cCr1 := FORMAT(LotNoInformation.Status);
        //                                 cMenge1 := FORMAT(ABS(ItemLedgerEntry.Quantity));
        //                                 tChargenText1 := cLot1 + ' ' + cEx1 + ' ' + cCr1 + ' ' + cMenge1;
        //                             end;
        //                         1:
        //                             begin
        //                                 cLot2 := ItemLedgerEntry."Lot No.";
        //                                 cEx2 := FORMAT(LotNoInformation.BASExpirationDatePHA);
        //                                 cCr2 := FORMAT(LotNoInformation.Status);
        //                                 cMenge2 := FORMAT(ABS(ItemLedgerEntry.Quantity));
        //                                 tChargenText2 := cLot2 + ' ' + cEx2 + ' ' + cCr2 + ' ' + cMenge2;
        //                             end;
        //                         2:
        //                             begin
        //                                 cLot3 := ItemLedgerEntry."Lot No.";
        //                                 cEx3 := FORMAT(LotNoInformation.BASExpirationDatePHA);
        //                                 cCr3 := FORMAT(LotNoInformation.Produktionsdatum);
        //                                 cMenge3 := FORMAT(ABS(ItemLedgerEntry.Quantity));
        //                                 tChargenText3 := cLot3 + ' ' + cEx3 + ' ' + cCr3 + ' ' + cMenge3;
        //                             end;
        //                         3:
        //                             begin
        //                                 cLot4 := ItemLedgerEntry."Lot No.";
        //                                 cEx4 := FORMAT(LotNoInformation.BASExpirationDatePHA);
        //                                 cCr4 := FORMAT(LotNoInformation.Status);
        //                                 cMenge4 := FORMAT(ABS(ItemLedgerEntry.Quantity));
        //                                 tChargenText4 := cLot4 + ' ' + cEx4 + ' ' + cCr4 + ' ' + cMenge4;
        //                             end;
        //                         4:
        //                             begin
        //                                 cLot5 := ItemLedgerEntry."Lot No.";
        //                                 cEx5 := FORMAT(LotNoInformation.BASExpirationDatePHA);
        //                                 cCr5 := FORMAT(LotNoInformation.Status);
        //                                 cMenge5 := FORMAT(ABS(ItemLedgerEntry.Quantity));
        //                                 tChargenText5 := cLot5 + ' ' + cEx5 + ' ' + cCr5 + ' ' + cMenge5;
        //                             end;
        //                         5:
        //                             begin
        //                                 cLot6 := ItemLedgerEntry."Lot No.";
        //                                 cEx6 := FORMAT(LotNoInformation.BASExpirationDatePHA);
        //                                 cCr6 := FORMAT(LotNoInformation.Status);
        //                                 cMenge6 := FORMAT(ABS(ItemLedgerEntry.Quantity));
        //                                 tChargenText6 := cLot6 + ' ' + cEx6 + ' ' + cCr6 + ' ' + cMenge6;
        //                             end;
        //                         6:
        //                             begin
        //                                 cLot7 := ItemLedgerEntry."Lot No.";
        //                                 cEx7 := FORMAT(LotNoInformation.BASExpirationDatePHA);
        //                                 cCr7 := FORMAT(LotNoInformation.Status);
        //                                 cMenge7 := FORMAT(ABS(ItemLedgerEntry.Quantity));
        //                                 tChargenText7 := cLot7 + ' ' + cEx7 + ' ' + cCr7 + ' ' + cMenge7;
        //                             end;
        //                         7:
        //                             begin
        //                                 cLot8 := ItemLedgerEntry."Lot No.";
        //                                 cEx8 := FORMAT(LotNoInformation.BASExpirationDatePHA);
        //                                 cCr8 := FORMAT(LotNoInformation.Status);
        //                                 cMenge8 := FORMAT(ABS(ItemLedgerEntry.Quantity));
        //                                 tChargenText8 := cLot8 + ' ' + cEx8 + ' ' + cCr8 + ' ' + cMenge8;
        //                             end;
        //                         8:
        //                             begin
        //                                 cLot9 := ItemLedgerEntry."Lot No.";
        //                                 cEx9 := FORMAT(LotNoInformation.BASExpirationDatePHA);
        //                                 cCr9 := FORMAT(LotNoInformation.Status);
        //                                 cMenge9 := FORMAT(ABS(ItemLedgerEntry.Quantity));
        //                                 tChargenText9 := cLot9 + ' ' + cEx9 + ' ' + cCr9 + ' ' + cMenge9;
        //                             end;
        //                         9:
        //                             begin
        //                                 cLot10 := ItemLedgerEntry."Lot No.";
        //                                 cEx10 := FORMAT(LotNoInformation.BASExpirationDatePHA);
        //                                 cCr10 := FORMAT(LotNoInformation.Status);
        //                                 cMenge10 := FORMAT(ABS(ItemLedgerEntry.Quantity));
        //                                 tChargenText10 := cLot10 + ' ' + cEx10 + ' ' + cCr10 + ' ' + cMenge10;
        //                             end;
        //                     end;
        //                     iCounter += 1;
        //                 end;
        //             until ItemLedgerEntry.Next() = 0;
        //     end;
        // end;

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
        // ReservationEntry: Record "Reservation Entry";
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
        // cCr1: Code[20];
        // cCr2: Code[20];
        // cCr3: Code[20];
        // cCr4: Code[20];
        // cCr5: Code[20];
        // cCr6: Code[20];
        // cCr7: Code[20];
        // cCr8: Code[20];
        // cCr9: Code[20];
        // cCr10: Code[20];
        // cEx1: Code[20];
        // cEx2: Code[20];
        // cEx3: Code[20];
        // cEx4: Code[20];
        // cEx5: Code[20];
        // cEx6: Code[20];
        // cEx7: Code[20];
        // cEx8: Code[20];
        // cEx9: Code[20];
        // cEx10: Code[20];
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
        // cMenge1: Code[20];
        // cMenge2: Code[20];
        // cMenge3: Code[20];
        // cMenge4: Code[20];
        // cMenge5: Code[20];
        // cMenge6: Code[20];
        // cMenge7: Code[20];
        // cMenge8: Code[20];
        // cMenge9: Code[20];
        // cMenge10: Code[20];
        // ExtLot1: Code[20];
        // ExtLot2: Code[20];
        // ExtLot3: Code[20];
        // ExtLot4: Code[20];
        // ExtLot5: Code[20];
        // ExtLot6: Code[20];
        // ExtLot7: Code[20];
        // ExtLot8: Code[20];
        // ExtLot9: Code[20];
        // ExtLot10: Code[20];
        ItemNo: Code[20];
        // iCounter: Integer;
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
        // iCounter := 0;
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

        CurrPage.Update();
    end;
}