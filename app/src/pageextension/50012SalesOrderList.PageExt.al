//TASK29.01     07.05.2024   MFU: Auftrag Imort PS Pharma

pageextension 50012 "SalesOrderListPageExt" extends "Sales Order List"
{
    //Auftrag Import von PS Pharma 
    actions
    {
        addlast(processing)   //Creation
        {


            // >> TASK29.01  
            action("PSPharmaAuftragsimport")
            {

                ApplicationArea = all;
                Caption = 'PSPharma Auftragsimport';

                trigger OnAction()
                var
                    pPSImport: Page PS_Auftrag_Import;
                begin
                    pPSImport.Run();
                end;

            }
            // << TASK29.01

        }
    }



}
