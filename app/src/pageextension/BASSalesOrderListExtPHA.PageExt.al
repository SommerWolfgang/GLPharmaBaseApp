pageextension 50012 BASSalesOrderListExtPHA extends "Sales Order List"
{
    actions
    {
        addlast(processing)
        {
            action(BASPSPharmaOrderImportPHA)
            {
                ApplicationArea = all;
                Caption = 'PSPharma Auftragsimport';
                Image = Import;
                ToolTip = 'Executes the PSPharma Auftragsimport action.';

                trigger OnAction()
                var
                    pPSImport: Page BASPSOrderImportPHA;
                begin
                    pPSImport.Run();
                end;

            }
        }
    }
}