
//TASK46  13.03.2024  MFU:  Artikel Zusatzinfo Subpage  -> Subpage Anzeige nicht aktiviert, da nicht nötig!


pageextension 50001 ItemPageExt extends "Item Card"
{
    //Subpage dazugeben
    layout
    {

        addafter("Description 2")
        {
            field("Packungsgröße"; "Packungsgröße")
            {
                ApplicationArea = All;
                Caption = 'Packungsgröße';
            }

            field("Statistikcode I"; "Statistikcode I")
            {
                ApplicationArea = All;
                //LookupPageId = StatistikcodeList;
                //Lookup = true;
                //TableRelation = Statistikcode;
            }
            field("Statistikcode II"; "Statistikcode II")
            {
                ApplicationArea = All;
            }
            field("Statistikcode III"; "Statistikcode III")
            {
                ApplicationArea = All;
            }

        }

        addafter(Inventory)
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
                    tempRecItemLedgerEntry.SetRange(Open, TRUE);

                    IF Rec.GETFILTER("Location Filter") > '' THEN
                        tempRecItemLedgerEntry.SETFILTER("Location Code", Rec.GETFILTER("Location Filter"));

                    IF PAGE.RUNMODAL(PAGE::UmlagerInfoNeu, tempRecItemLedgerEntry) = ACTION::LookupOK THEN;
                    // << CCU

                end;

            }

        }

        //Ausblenden des ursprünglichen Lagerstand -> Funkt nicht !!!!!
        modify(Inventory)
        {
            Visible = false;
        }


        // >> TASK46
        /*
        addafter(Warehouse)
        {
            part(ItemAdditive; ItemAdditiveSubpage)
            {
                ApplicationArea = All;
                //Editable = IsSalesLinesEditable;
                //Enabled = IsSalesLinesEditable;
                SubPageLink = "ItemNo." = field("No.");
                //UpdatePropagation = Both;
            }
        }
        */
        // << TASK46


    }

    var
        dLagerstand: Decimal;

    trigger OnAfterGetRecord()
    begin
        Rec.CalcFields(Inventory);
        dLagerstand := Rec.Inventory;
    end;
}
