
page 50013 BASRangeList3090PHA
{
    ApplicationArea = Basic, Suite;
    PageType = List;
    Permissions =
        tabledata "Bin Content" = R,
        tabledata "Item Ledger Entry" = R,
        tabledata Location = R,
        tabledata "Lot No. Information" = R,
        tabledata BASInvoiceMailSentPHA = R,
        tabledata Item = RIMD;
    SaveValues = false;
    SourceTable = Item;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            group(Setup)
            {
            }
        }
    }
}