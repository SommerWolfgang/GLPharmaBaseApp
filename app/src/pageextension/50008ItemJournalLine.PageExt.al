
//Task58 Task58.01    11.04.2024  MFU: Anpassungen Artikelbuchblatt   

pageextension 50008 "ItemJournalExt" extends "Item Journal"
{

    layout
    {
        addafter("Item No.")
        {
            field("Packungsgröße"; "Packungsgröße")
            {
                ApplicationArea = All;
            }


            field("Verkaufschargennr."; "Verkaufschargennr.")
            {
                ApplicationArea = All;
                /*
                trigger OnValidate()
                var
                    myInt: Integer;
                begin
                    //VK Charge in Artikelverfolgung übertragen
                    if (Rec."Entry Type" = Rec."Entry Type"::"Positive Adjmt.") and (Rec."Verkaufschargennr." <> xRec."Verkaufschargennr.") then begin
                        LöscheCharge();
                        EingabeCharge();
                    end;
                end;
                */
            }

            field(Chargenstatus; GetChargenStatus("Item No.", "Lot No."))
            {
                ApplicationArea = All;
                Visible = false;
            }
            field("Hole von"; "Hole von")
            {
                ApplicationArea = All;
                DrillDown = false;   //Deaktivieren, damit die DrillDown Punkte auf die Artikelposten weg sind
                //Editable = false;
            }

        }


        modify("Item No.")
        {
            ApplicationArea = All;

            trigger OnAfterValidate()
            var
                myInt: Integer;
            begin
                //Damit Flowfields wie PKG aktualisiert werden
                CurrPage.Update();
            end;
        }

        //Bestehendes "Lot No." Feld abändern
        modify("Lot No.")
        {
            ApplicationArea = All;
            Editable = true;
            Visible = true;

            trigger OnLookup(var Text: Text): Boolean
            var
                myInt: Integer;
            begin
                Rec.HoleCharge();
                //CurrPage.Update();  //MFUTEST -> Nötig?
            end;
        }

        modify("Expiration Date")
        {
            //Ablaufdatum in Buchblattzeile editierbar machen
            ApplicationArea = All;
            Editable = true;
            Visible = true;
        }

        /*
            modify(Quantity)
            {
                ApplicationArea = All;

                trigger OnAfterValidate()
                var
                    vergleich: Decimal;
                begin

                    //Artikelverfolgung anpassen   
                    // >> Task58.01
                    //Nach Mengenänderung in Buchblatt, bei Chargenpflichtigen Artikel die Artikelverfolgung auch Anpassen
                    vergleich := xRec.Quantity;
                    IF "Line No." = 0 THEN
                        vergleich := 0;
                    IF (Quantity <> vergleich) THEN BEGIN
                        LöscheCharge();
                        IF (Rec."Journal Template Name" = 'INVENTUR') AND (Rec."Entry Type" = Rec."Entry Type"::"Negative Adjmt.")
                            AND (Rec."Lot No." = '') AND (xRec."Lot No." > '') THEN
                            Rec."Lot No." := xRec."Lot No.";
                        EingabeCharge();
                    END;
                    // << Task58.01 

                end;

            }
        */

    }


    trigger OnAfterGetRecord()
    var
        recRes: Record "Reservation Entry";
        cutest: Codeunit "Item Jnl.-Post";
    begin

        //Chargen Info von Artikelverfolung holen, wenn leer
        IF Rec."Lot No." = '' then begin
            recRes.SetRange("Item No.", Rec."Item No.");
            recRes.SetRange("Location Code", Rec."Location Code");
            recRes.SetRange("Source ID", 'ARTIKEL');
            recRes.SetRange("Source Batch Name", "Journal Batch Name");
            recRes.SetRange("Source Ref. No.", "Line No.");
            IF recRes.FindFirst THEN BEGIN
                Rec."Lot No." := recRes."Lot No.";
                Rec."Verkaufschargennr." := recRes."Verkaufschargennr.";
                Rec."Expiration Date" := recRes."Expiration Date";
            END;
        end;
    end;



    procedure GetChargenStatus(cItemNo: Code[20]; cLotNo: Code[20]) tChargenStatus: Text[20]
    var
        recLot: Record "Lot No. Information";
    begin
        tChargenStatus := '';
        IF (STRLEN(cItemNo) > 0) AND (STRLEN(cLotNo) > 0) THEN
            IF recLot.GET(cItemNo, '', cLotNo) THEN
                tChargenStatus := FORMAT(recLot.Status);
    end;

}
