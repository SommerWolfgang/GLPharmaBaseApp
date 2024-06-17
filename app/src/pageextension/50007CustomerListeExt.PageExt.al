//Task57 Task57.01          11.04.2024  MFU:  Änderungsprotokoll 

pageextension 50007 "CustomerListeExt" extends "Customer List"
{

    actions
    {
        addfirst(processing)
        {
            // >> Task57.01
            action("Änderungsprotokoll")
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    pChangeLogLookup: Page BASChangeLogEntryPHA;
                begin

                    CLEAR(pChangeLogLookup);
                    pChangeLogLookup.setFilterByRec('', Rec);
                    pChangeLogLookup.RUNMODAL;

                end;
            }
            // << Task57.01
        }

    }
}
