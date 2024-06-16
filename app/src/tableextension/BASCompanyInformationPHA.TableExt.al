tableextension 50028 BASCompanyInformationPHA extends "Company Information"
{
    fields
    {
        field(50000; "BASBankkonto ZusatztextPHA"; Text[100])
        {

        }
        field(50001; "BASBankkonto 2PHA"; Text[115])
        {

        }
        field(50002; "BASBankkonto 3PHA"; Text[115])
        {

        }
        field(50003; "BASBelegtext 1PHA"; Text[200])
        {

        }
        field(50004; "BASBelegtext 2PHA"; Text[200])
        {

        }
        field(50005; "BASARA-LizenznrPHA"; Text[30])
        {

        }
        field(50006; BASGerichtsstandPHA; Text[30])
        {

        }
        field(50007; "BASFax-EKPHA"; Text[30])
        {

        }
        field(50008; "BASFax-VKPHA"; Text[30])
        {

        }
        field(50009; BASVertriebsmandantPHA; Text[30])
        {

            TableRelation = Company.Name;
        }
        field(50010; BASProduktionsmandantPHA; Text[30])
        {

            TableRelation = Company.Name;
        }
        field(50011; BASFirmensitzPHA; Text[250])
        {

        }
        field(50012; "BASGen. Bus. Posting GroupPHA"; Code[10])
        {
        }
        field(50013; BASEORIPHA; Code[20])
        {
        }
    }
}