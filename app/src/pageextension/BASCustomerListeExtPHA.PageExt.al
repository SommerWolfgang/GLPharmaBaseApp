pageextension 50007 BASCustomerListeExtPHA extends "Customer List"
{
    actions
    {
        addfirst(processing)
        {
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
}