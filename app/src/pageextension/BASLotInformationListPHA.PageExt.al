
pageextension 50005 BASLotInformationListPHA extends "Lot No. Information List"
{
    layout
    {
        addafter("Lot No.")
        {
            field(Status; Rec.BASStatusPHA)
            {
                ApplicationArea = All;
                Editable = false;
                ToolTip = 'Chargenstatus';
                Visible = true;
            }
            field(BASSalesLotNoPHA; Rec.BASSalesLotNoPHA)
            {
                ApplicationArea = Basic, Suite;
                ToolTip = 'Verkaufschargennr.';
                Visible = true;
            }
            field(BASExpirationDatePHa; Rec.BASExpirationDatePHa)
            {
                ApplicationArea = Basic, Suite;
                ToolTip = 'Ablaufdatum';
                Visible = true;
            }
        }

        modify(Inventory)
        {
            ApplicationArea = All;
            trigger OnDrillDown()
            var
                TempItemLedgerEntry: Record "Item Ledger Entry" temporary;
            begin
                TempItemLedgerEntry."Item No." := Rec."Item No.";
                TempItemLedgerEntry.SetRange("Item No.", Rec."Item No.");
                TempItemLedgerEntry.SetRange(Open, true);

                if Rec.GetFilter("Location Filter") > '' then
                    TempItemLedgerEntry.SETFILTER("Location Code", Rec.GetFilter("Location Filter"));

                // if Page::RunModal(PAGE::TransferOrderInfo, TempItemLedgerEntry) = Action::LookupOK THEN;
            end;

        }
    }

    actions
    {
        addfirst(processing)
        {

            action(ReleaseLotNo)
            {
                ApplicationArea = All;
                Image = OpenWorksheet;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Executes the ReleaseLotNo action.';

                trigger OnAction()
                var
                    LotNoInformation: Record "Lot No. Information";
                begin
                    if LotNoInformation.Get(Rec."Item No.", Rec."Variant Code", Rec."Lot No.") then
                        OpenGLChargenfreigabe(LotNoInformation);
                end;
            }

            action(BASChangeLogEntryPHA)
            {
                ApplicationArea = All;
                Image = ChangeLog;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Executes the BASChangeLogEntry action.';

                trigger OnAction()
                var
                    ChangeLogLookup: Page BASChangeLogEntryPHA;
                begin
                    // ToDo 
                    // ChangeLogLookup.setFilterByRec('', Rec);
                    ChangeLogLookup.RunModal();
                end;
            }
        }
    }

    // ToDo
    local procedure OpenGLChargenfreigabe(var recLNI_: Record "Lot No. Information")
    begin
        clear(recLNI_);
        // CLEAR(recLotTmp);
        // recLotTmp.COPY(recLNI_);
        // recLotTmp.INSERT;
        // recLotTmp.SetRange("Item No.", recLNI_."Item No.");
        // recLotTmp.SetRange("Lot No.", recLNI_."Lot No.");
        // //Eigene Page mit TmpRecord öffnen


        // ActResult := Page::RunModal(PAGE::ReleaseLotNo, recLotTmp);
        // if ActResult in [ACTION::OK, ACTION::LookupOK] then begin

        //     //Marktfreigabepin nur bei Statusänderung prüfen
        //     //IF recLotTmp.Status <> recLNI_.Status THEN BEGIN
        //     //    CheckMarktfreigabePin();
        //     //END;

        //     //Chargenfreigebefunktion auch für direkten Aufruf von Lims
        //     GLChargenStammSpeichern(recLotTmp, recLNI_);  //recLotTmp->Neue Chargenwerte;  Rec->alte Chargenwerte

        //     //Seite neu laden
        //     CurrPage.UPDATE(false);

        // end;
    end;
}