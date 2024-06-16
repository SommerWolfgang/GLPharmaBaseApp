page 50006 "StatistikcodeList"
{
    Caption = 'Statistikcode Liste';
    PageType = List;
    SourceTable = Statistikcode2;
    UsageCategory = Lists;
    ApplicationArea = all;

    layout
    {
        area(content)
        {

            repeater(Inhalt)
            {
                field(Code; Rec.Code)
                {
                    ApplicationArea = all;
                }
                field(Bezeichnung; Rec.Bezeichnung)
                {
                    ApplicationArea = all;
                }

            }

        }
    }

    var
        tTest: Text;


}
