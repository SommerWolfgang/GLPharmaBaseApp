

table 50001 BASStatTempPHA
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; artikelnr; Code[20])
        {
        }
        field(2; menge; Decimal)
        {
        }
        field(3; betrag; Decimal)
        {
        }
        field(4; mengenr; Decimal)
        {
        }
        field(5; mengegw; Decimal)
        {
        }
        field(6; Kmenge; Decimal)
        {
        }
        field(7; KBetrag; Decimal)
        {
        }
        field(8; KMengeNR; Decimal)
        {
        }
        field(9; KMengeGW; Decimal)
        {
        }
        field(10; VMenge; Decimal)
        {
        }
        field(11; VBetrag; Decimal)
        {
        }
        field(12; VMengeNR; Decimal)
        {
        }
        field(13; VMengeGW; Decimal)
        {
        }
        field(14; rabatt; Decimal)
        {
        }
        field(15; kRabatt; Decimal)
        {
        }
        field(16; vrabatt; Decimal)
        {
        }
        field(17; KVMenge; Decimal)
        {
        }
        field(18; KVBetrag; Decimal)
        {
        }
        field(19; KVRabatt; Decimal)
        {
        }
        field(20; KVMengeNR; Decimal)
        {
        }
        field(21; KVMengeGW; Decimal)
        {
        }
        field(22; benutzerID; Code[20])
        {
        }
        field(23; Land; Code[10])
        {
        }
        field(24; MengeAemu; Decimal)
        {
        }
        field(25; EntryDate; Date)
        {
        }
        field(26; EntryNumber; Text[30])
        {
        }
        field(27; LotNr; Text[30])
        {
        }
        field(28; FW; Text[30])
        {
        }
        field(29; ID; Integer)
        {
        }
        field(30; "BASStatisticCode2PHA III"; Code[10])
        {
        }
        field(31; "Global Dimension 1 Code"; Code[20])
        {
        }
        field(33; VJMenge; Decimal)
        {
        }
        field(34; VJBetrag; Decimal)
        {
        }
        field(35; VJMengeNR; Decimal)
        {
        }
        field(36; VJMengeGW; Decimal)
        {
        }
        field(37; VJKMenge; Decimal)
        {
        }
        field(38; VJKBetrag; Decimal)
        {
        }
        field(39; VJKMengeNR; Decimal)
        {
        }
        field(40; VJKMengeGW; Decimal)
        {
        }
        field(41; HKBetrag; Decimal)
        {
        }
        field(42; "BASStatisticCode2PHA III Text"; Text[30])
        {
        }
        field(43; "Global Dimension 1 Text"; Text[50])
        {
        }
        field(44; "Manufacturing For"; Code[20])
        {
        }
        field(45; Wertgutschrift; Boolean)
        {
        }
    }


    keys
    {
        key(Key1; benutzerID, artikelnr, Land, ID)
        {
        }
        key(Key2; benutzerID, Land, artikelnr, ID)
        {
        }
        key(Key3; artikelnr, EntryNumber, LotNr, benutzerID, Land)
        {
        }
        key(Key4; ID)
        {
        }
        key(Key5; benutzerID, artikelnr, EntryDate, ID)
        {
        }
        key(Key6; benutzerID, artikelnr, "BASStatisticCode2PHA III", "Global Dimension 1 Code")
        {
        }
        key(Key7; benutzerID, "BASStatisticCode2PHA III", "Global Dimension 1 Code", artikelnr)
        {
        }
        key(Key8; benutzerID, "Global Dimension 1 Code", "BASStatisticCode2PHA III", artikelnr)
        {
        }
        key(Key9; benutzerID, "BASStatisticCode2PHA III Text", "Global Dimension 1 Text", artikelnr)
        {
        }
        key(Key10; benutzerID, "Global Dimension 1 Text", "BASStatisticCode2PHA III Text", artikelnr)
        {
        }
        key(Key11; benutzerID, "Manufacturing For", "BASStatisticCode2PHA III Text", artikelnr)
        {
        }
        key(Key12; benutzerID, "BASStatisticCode2PHA III Text", artikelnr, "Global Dimension 1 Text")
        {
        }
        key(Key13; benutzerID, "Global Dimension 1 Text", artikelnr, "BASStatisticCode2PHA III Text")
        {
        }
    }

}


/*
table 50020 StatTemp
{
    // version petsch

    // 
    // Datum      | Autor   | Status   | Beschreibung
    // --------------------------------------------------------------------------------------
    // 2010-02-09 | MFU     | ok       | Update von 360
    // --------------------------------------------------------------------------------------
    // 2012-02-01 | MFU     | ok       | Spalten und Keys eingefügt
    // --------------------------------------------------------------------------------------
    // 2012-10-03 | MFU     | ok       | Spalte "Manufactoring For" eingefügt
    // --------------------------------------------------------------------------------------
    // 2014-11-10 | MFU     | ok       | Spalte "Wertgutschrift" eingefügt (Update2013 für R50031)
    // --------------------------------------------------------------------------------------
    // 2017-04-05 | MFU     | ok       | Spalte "artikelnr" von 10 auf 20 Zeichen erweitert
    // --------------------------------------------------------------------------------------


    fields
    {
        field(1; artikelnr; Code[20])
        {
        }
        field(2; menge; Decimal)
        {
        }
        field(3; betrag; Decimal)
        {
        }
        field(4; mengenr; Decimal)
        {
        }
        field(5; mengegw; Decimal)
        {
        }
        field(6; Kmenge; Decimal)
        {
        }
        field(7; KBetrag; Decimal)
        {
        }
        field(8; KMengeNR; Decimal)
        {
        }
        field(9; KMengeGW; Decimal)
        {
        }
        field(10; VMenge; Decimal)
        {
        }
        field(11; VBetrag; Decimal)
        {
        }
        field(12; VMengeNR; Decimal)
        {
        }
        field(13; VMengeGW; Decimal)
        {
        }
        field(14; rabatt; Decimal)
        {
        }
        field(15; kRabatt; Decimal)
        {
        }
        field(16; vrabatt; Decimal)
        {
        }
        field(17; KVMenge; Decimal)
        {
        }
        field(18; KVBetrag; Decimal)
        {
        }
        field(19; KVRabatt; Decimal)
        {
        }
        field(20; KVMengeNR; Decimal)
        {
        }
        field(21; KVMengeGW; Decimal)
        {
        }
        field(22; benutzerID; Code[20])
        {
        }
        field(23; Land; Code[10])
        {
        }
        field(24; MengeAemu; Decimal)
        {
        }
        field(25; EntryDate; Date)
        {
        }
        field(26; EntryNumber; Text[30])
        {
        }
        field(27; LotNr; Text[30])
        {
        }
        field(28; FW; Text[30])
        {
        }
        field(29; ID; Integer)
        {
        }
        field(30; "BASStatisticCode2PHA III"; Code[10])
        {
        }
        field(31; "Global Dimension 1 Code"; Code[20])
        {
        }
        field(33; VJMenge; Decimal)
        {
        }
        field(34; VJBetrag; Decimal)
        {
        }
        field(35; VJMengeNR; Decimal)
        {
        }
        field(36; VJMengeGW; Decimal)
        {
        }
        field(37; VJKMenge; Decimal)
        {
        }
        field(38; VJKBetrag; Decimal)
        {
        }
        field(39; VJKMengeNR; Decimal)
        {
        }
        field(40; VJKMengeGW; Decimal)
        {
        }
        field(41; HKBetrag; Decimal)
        {
        }
        field(42; "BASStatisticCode2PHA III Text"; Text[30])
        {
        }
        field(43; "Global Dimension 1 Text"; Text[50])
        {
        }
        field(44; "Manufacturing For"; Code[20])
        {
        }
        field(45; Wertgutschrift; Boolean)
        {
        }
    }

    keys
    {
        key(Key1; benutzerID, artikelnr, Land, ID)
        {
        }
        key(Key2; benutzerID, Land, artikelnr, ID)
        {
        }
        key(Key3; artikelnr, EntryNumber, LotNr, benutzerID, Land)
        {
        }
        key(Key4; ID)
        {
        }
        key(Key5; benutzerID, artikelnr, EntryDate, ID)
        {
        }
        key(Key6; benutzerID, artikelnr, "BASStatisticCode2PHA III", "Global Dimension 1 Code")
        {
        }
        key(Key7; benutzerID, "BASStatisticCode2PHA III", "Global Dimension 1 Code", artikelnr)
        {
        }
        key(Key8; benutzerID, "Global Dimension 1 Code", "BASStatisticCode2PHA III", artikelnr)
        {
        }
        key(Key9; benutzerID, "BASStatisticCode2PHA III Text", "Global Dimension 1 Text", artikelnr)
        {
        }
        key(Key10; benutzerID, "Global Dimension 1 Text", "BASStatisticCode2PHA III Text", artikelnr)
        {
        }
        key(Key11; benutzerID, "Manufacturing For", "BASStatisticCode2PHA III Text", artikelnr)
        {
        }
        key(Key12; benutzerID, "BASStatisticCode2PHA III Text", artikelnr, "Global Dimension 1 Text")
        {
        }
        key(Key13; benutzerID, "Global Dimension 1 Text", artikelnr, "BASStatisticCode2PHA III Text")
        {
        }
    }

    fieldgroups
    {
    }
}
*/

