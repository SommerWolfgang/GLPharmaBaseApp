
page 50000 BASItemAdditiveSubpagePHA
{
    Caption = 'Item Additional Info', comment = 'DEA="Artikel Zusatzinfo"';
    PageType = CardPart;
    SourceTable = BASItemAdditivePHA;

    layout
    {
        area(content)
        {
            group(Zusatzinfo)
            {
                Caption = 'Item', comment = 'DEA="Artikel"';
                field("Wirkstärke"; Rec.Wirkstaerke)
                {
                    ApplicationArea = All;
                    Importance = Standard;
                    ToolTip = 'Wirkstärke';
                    //ToolTip = 'Specifies the number of the involved entry or record, according to the specified number series.';
                    //Visible = NoFieldVisible;
                }
                field(Darreichungsform; Rec.Darreichungsform)
                {
                    ApplicationArea = All;
                    Importance = Standard;
                    ToolTip = 'Darreichungsform';
                    //ToolTip = 'Specifies the number of the involved entry or record, according to the specified number series.';
                    //Visible = NoFieldVisible;
                }
            }
        }
    }
}