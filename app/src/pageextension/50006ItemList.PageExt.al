
//Task57 Task57.01          11.04.2024  MFU:  Änderungsprotokoll 

pageextension 50006 "ItemListExt" extends "Item List"
{

    layout
    {
        addafter(InventoryField)
        {
            //Lagerstand mit öffner der Lagerstand Anzeige GL
            field(Lagerstand; dLagerstand)
            {
                ApplicationArea = all;
                Editable = false;
                //Enabled = false;

                trigger OnDrillDown()
                var
                    tempRecItemLedgerEntry: Record "Item Ledger Entry" temporary;
                begin

                    // >> CCU
                    //Aufrufen der Lagerstand Seite und nicht die Artikelposten
                    tempRecItemLedgerEntry."Item No." := "No.";
                    tempRecItemLedgerEntry.SetRange("Item No.", "No.");
                    tempRecItemLedgerEntry.SetRange(Open, true);

                    if Rec.GetFilter("Location Filter") > '' then
                        tempRecItemLedgerEntry.SETFILTER("Location Code", Rec.GetFilter("Location Filter"));

                    if Page::RunModal(PAGE::TransferOrderInfo, tempRecItemLedgerEntry) = Action::LookupOK THEN;
                    // << CCU

                end;

            }

            field("Packungsgröße"; "Packungsgröße")
            {
                ApplicationArea = all;
            }
            field("Statistikcode I"; "Statistikcode I")
            {
                ApplicationArea = all;
            }
            field("Statistikcode II"; "Statistikcode II")
            {
                ApplicationArea = all;
            }
            field("Statistikcode III"; "Statistikcode III")
            {
                ApplicationArea = all;
            }

        }

        //Ausblenden der oroginal Lagerstand Spalte auf der Artikelliste
        modify(InventoryField)
        {
            Visible = false;
        }


    }

    actions
    {
        addfirst(processing)
        {
            // >> Task57.01
            action("Änderungsprotokoll")
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    pChangeLogLookup: Page BASChangeLogEntryPHA;
                begin

                    CLEAR(pChangeLogLookup);
                    pChangeLogLookup.setFilterByRec('', Rec);
                    pChangeLogLookup.RUNMODAL;

                end;
            }
            // << Task57.01
        }

    }

    var
        dLagerstand: Decimal;

    trigger OnAfterGetRecord()
    begin
        Rec.CalcFields(Inventory);
        dLagerstand := Rec.Inventory;
    end;

}
