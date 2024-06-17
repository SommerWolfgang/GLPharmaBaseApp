page 50018 BASPSOrderImportPHA
{
    layout
    {
        area(content)
        {
            field(OrderDate; OrderDate)
            {
                ApplicationArea = All;
                Caption = 'Order Date', comment = 'DEA="Auftragsdatum"';
                ToolTip = 'Specifies the value of the Datum field.';
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(ImportPSOrders)
            {
                ApplicationArea = All;
                Image = Import;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ToolTip = 'Executes the ImportPSOrders action.';

                trigger OnAction()
                begin
                    ImportPSPharmaCSVOrder(FileName);
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        Check();

        OrderDate := TODAY;
    end;

    var
        TempItem: Record Item temporary;
        OrderDate: Date;
        FileName: Text;

    procedure ShowOrderInfo(CustNo: Code[20])
    var
        CommentLine: Record "Comment Line";
        sb: Codeunit DotNet_StringBuilder;
    begin
        sb.InitStringBuilder('');

        CommentLine.Reset();
        CommentLine.SetRange("Table Name", CommentLine."Table Name"::Customer);
        CommentLine.SetRange("No.", CustNo);
        CommentLine.SetRange(BASShowNoteOrderPHA, true);
        if CommentLine.FindSet() then
            repeat
                sb.Append(CommentLine.Comment);
            // ToDo
            // if StrLen(s + CommentLine.Comment) > 250 then
            //     sb.AppendLine(' ...->');
            // else
            // s := s + CommentLine.Comment + '\';  //der backslash ersetzt #13
            until CommentLine.Next() = 0;
        if sb.ToString() <> '' then
            Message(sb.ToString());
    end;

    procedure GetSubstituteItem(ItemNo: Code[20]): Code[20]
    var
        Item: Record Item;
        ItemSubstitution: Record "Item Substitution";
    begin
        if Item.Get(ItemNo) then begin
            Item.CalcFields("Substitutes Exist");
            if Item."Substitutes Exist" then begin
                ItemSubstitution.SetRange("No.", Item."No.");
                if ItemSubstitution.FindFirst() then
                    exit(ItemSubstitution."Substitute No.");
            end;
        end;
    end;

    procedure InsertExtendedText(SalesLine: Record "Sales Line"; Unconditionally: Boolean)
    var
        TransferExtendedText: Codeunit "Transfer Extended Text";
    begin
        if TransferExtendedText.SalesCheckIfAnyExtText(SalesLine, Unconditionally) then begin
            CurrPage.SaveRecord();
            Commit();
            TransferExtendedText.InsertSalesExtText(SalesLine);
        end;
    end;

    procedure ImportPSPharmaCSVOrder(Path: Text)
    var
        CodeCollection: Codeunit BASCodeCollectionPHA;
    begin
        CodeCollection.ImportPSPharmaCSVOrder(Path);
    end;

    local procedure Check()
    begin
        if not TempItem.IsTemporary then
            Error('Variable nicht Temporär!');

        if (UserId <> 'FUERBASST1') and (UserId <> 'FUERBASS') then
            Error('Funktion nicht Freigegeben!');
    end;
}