tableextension 50050 BASFASetupExtPHA extends "FA Setup"
{
    fields
    {
        field(50000; BASKontoNrLogikPHA; Option)
        {
            Caption = '';
            DataClassification = ToBeClassified;
            OptionMembers = "5 Stellen der Anlagenr","Anlagenbuchungsgruppe des Standard Afa-Buches";

        }
    }
}
