page 50004 BASMasterLotCardPHA
{
    ApplicationArea = All;
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Card;
    SourceTable = Item;
    UsageCategory = Administration;

    layout
    {
        area(Content)
        {
            group(GroupName)
            {
                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the number of the involved entry or record, according to the specified number series.';
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies a description of the item.';
                }
                field(BASPackageSizePHA; Rec.BASPackageSizePHA)
                {
                    ToolTip = 'Specifies the value of the Packing size field.', Comment = '%';
                }
                field("Base Unit of Measure"; Rec."Base Unit of Measure")
                {
                    ToolTip = 'Specifies the base unit used to measure the item, such as piece, box, or pallet. The base unit of measure also serves as the conversion basis for alternate units of measure.';
                }
                field("Item Tracking Code"; Rec."Item Tracking Code")
                {
                    ToolTip = 'Specifies how serial or lot numbers assigned to the item are tracked in the supply chain.';
                }
                field(BASSiteBatchReleasePHA; Rec.BASSiteBatchReleasePHA)
                {
                    ToolTip = 'Specifies the value of the Standort Freigabe field.', Comment = '%';
                }
                field("Expiration Calculation"; Rec."Expiration Calculation")
                {
                    ToolTip = 'Specifies the date formula for calculating the expiration date on the item tracking line. Note: This field will be ignored if the involved item has Require Expiration Date Entry set to Yes on the Item Tracking Code page.';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(List)
            {
                ApplicationArea = all;
                Image = List;
                Promoted = true;
                PromotedIsBig = true;
                RunObject = Page BASMasterLotListPHA;
                ShortCutKey = 'F5';
                ToolTip = 'Executes the Übersicht action.';
            }
            action(ChangeLogEntry)
            {
                ApplicationArea = all;
                Image = ChangeLog;
                RunObject = Page "Change Log Entries";
                RunPageLink = "Table No." = filter(6505), "Primary Key Field 1 Value" = field("No.");
                RunPageView = sorting("Table No.", "Primary Key Field 1 Value");
                ToolTip = 'Executes the ChangeLogEntry action.';
            }
        }
    }
}