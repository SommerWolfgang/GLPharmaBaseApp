
//TASK50 TASK50.01 (CCU40)  15.03.2024  MFU:  Artikelstammfelder in Artikelposten, Wertposten mitbuchen 

codeunit 50005 EventArtikelBuchen
{

    [EventSubscriber(ObjectType::Table, 83, 'OnAfterCopyItemJnlLineFromSalesLine', '', false, false)]
    local procedure T83OnAfterCopyItemJnlLineFromSalesLine(var ItemJnlLine: Record "Item Journal Line"; SalesLine: Record "Sales Line")
    var
        recItem: Record Item;
        recSH: Record "Sales Header";
    begin

        // >> TASK50.01
        //Stammdaten aus Artikelstamm mitbuchen
        IF (SalesLine.Type = SalesLine.Type::Item) AND (StrLen(SalesLine."No.") > 0) THEN
            IF recItem.GET(SalesLine."No.") THEN BEGIN
                ItemJnlLine."Statistikcode I" := recItem."Statistikcode I";
                ItemJnlLine."Statistikcode II" := recItem."Statistikcode II";
                ItemJnlLine."Statistikcode III" := recItem."Statistikcode III";
            END;
        // << TASK50.01


    end;


    [EventSubscriber(ObjectType::Codeunit, 22, 'OnAfterInitItemLedgEntry', '', false, false)]
    local procedure CU22OnAfterInitItemLedgEntry(var NewItemLedgEntry: Record "Item Ledger Entry"; ItemJournalLine: Record "Item Journal Line"; var ItemLedgEntryNo: Integer)
    var
        recItem: Record Item;
    begin

        WITH ItemJournalLine DO BEGIN

            // >> TASK50.01          
            IF recItem.GET("Item No.") THEN BEGIN
                NewItemLedgEntry."Statistikcode I" := recItem."Statistikcode I";
                NewItemLedgEntry."Statistikcode II" := recItem."Statistikcode II";
                NewItemLedgEntry."Statistikcode III" := recItem."Statistikcode III";
            END;
            // << TASK50.01

        END;
    end;


    [EventSubscriber(ObjectType::Codeunit, 22, 'OnAfterInitValueEntry', '', false, false)]
    local procedure CU22OnAfterInitValueEntry(var ValueEntry: Record "Value Entry"; ItemJournalLine: Record "Item Journal Line"; var ValueEntryNo: Integer)
    begin

        WITH ItemJournalLine DO BEGIN

            // >> TASK50.01
            ValueEntry."Statistikcode I" := "Statistikcode I";
            ValueEntry."Statistikcode II" := "Statistikcode II";
            ValueEntry."Statistikcode III" := "Statistikcode III";
            // << TASK50.01

        END;
    end;

    [EventSubscriber(ObjectType::Table, 83, 'OnAfterCopyItemJnlLineFromPurchLine', '', false, false)]
    local procedure T38OnAfterCopyItemJnlLineFromPurchaseHeader(var ItemJnlLine: Record "Item Journal Line"; PurchLine: Record "Purchase Line")
    var
        recItem: Record Item;
    begin
        // >> TASK50.01
        IF (PurchLine.Type = PurchLine.Type::Item) AND (StrLen(PurchLine."No.") > 0) THEN
            IF recItem.GET(PurchLine."No.") THEN BEGIN
                ItemJnlLine."Statistikcode I" := recItem."Statistikcode I";
                ItemJnlLine."Statistikcode II" := recItem."Statistikcode II";
                ItemJnlLine."Statistikcode III" := recItem."Statistikcode III";
            END;
        // << TASK50.01
    end;



}
