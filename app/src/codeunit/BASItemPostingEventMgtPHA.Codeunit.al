
codeunit 50005 BASItemPostingEventMgtPHA
{
    [EventSubscriber(ObjectType::Table, Database::"Item Journal Line", 'OnAfterCopyItemJnlLineFromSalesLine', '', false, false)]
    local procedure OnAfterCopyItemJnlLineFromSalesLine(var ItemJnlLine: Record "Item Journal Line"; SalesLine: Record "Sales Line")
    var
        Item: Record Item;
    begin
        if (SalesLine.Type = SalesLine.Type::Item) and (StrLen(SalesLine."No.") > 0) then
            if Item.Get(SalesLine."No.") then begin
                ItemJnlLine.BASStatisticCodeIIPHA := Item.BASStatisticCodeIPHA;
                ItemJnlLine.BASStatisticCodeIIPHA := Item.BASStatisticCodeIIPHA;
                ItemJnlLine.BASStatisticCodeIIIPHA := Item.BASStatisticCodeIIIPHA;
            end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Jnl.-Post Line", 'OnAfterInitItemLedgEntry', '', false, false)]
    local procedure OnAfterInitItemLedgEntry(var NewItemLedgEntry: Record "Item Ledger Entry"; ItemJournalLine: Record "Item Journal Line"; var ItemLedgEntryNo: Integer)
    var
        Item: Record Item;
    begin
        if Item.Get(NewItemLedgEntry."Item No.") then begin
            NewItemLedgEntry.BASStatisticCodeIPHA := Item.BASStatisticCodeIIPHA;
            NewItemLedgEntry.BASStatisticCodeIPHA := Item.BASStatisticCodeIIPHA;
            NewItemLedgEntry.BASStatisticCodeIIIPHA := Item.BASStatisticCodeIIIPHA;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Jnl.-Post Line", 'OnAfterInitValueEntry', '', false, false)]
    local procedure OnAfterInitValueEntry(var ValueEntry: Record "Value Entry"; ItemJournalLine: Record "Item Journal Line"; var ValueEntryNo: Integer)
    begin
        ValueEntry.BASStatisticCodeIPHA := ItemJournalLine.BASStatisticCodeIPHA;
        ValueEntry.BASStatisticCodeIIPHA := ItemJournalLine.BASStatisticCodeIIPHA;
        ValueEntry.BASStatisticCodeIIIPHA := ItemJournalLine.BASStatisticCodeIIIPHA;
    end;

    [EventSubscriber(ObjectType::Table, 83, 'OnAfterCopyItemJnlLineFromPurchLine', '', false, false)]
    local procedure T38OnAfterCopyItemJnlLineFromPurchaseHeader(var ItemJnlLine: Record "Item Journal Line"; PurchLine: Record "Purchase Line")
    var
        Item: Record Item;
    begin
        if (PurchLine.Type = PurchLine.Type::Item) and (StrLen(PurchLine."No.") > 0) then
            if Item.Get(PurchLine."No.") then begin
                ItemJnlLine.BASStatisticCodeIPHA := Item.BASStatisticCodeIPHA;
                ItemJnlLine.BASStatisticCodeIIPHA := Item.BASStatisticCodeIIPHA;
                ItemJnlLine.BASStatisticCodeIIIPHA := Item.BASStatisticCodeIIIPHA;
            end;
    end;
}