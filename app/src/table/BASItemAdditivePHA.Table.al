table 50000 BASItemAdditivePHA
{
    Caption = 'ItemAdditive';

    // version MFU,TODOPBA2

    // ------------------------------------------------------------------------------------------------------------------------------------
    // Datum      | Autor   | Status     | Beschreibung
    // ------------------------------------------------------------------------------------------------------------------------------------
    // 2013-10-15 | MFU     | Erstellt   | Zusatzinformationen zum Artikel
    // ------------------------------------------------------------------------------------------------------------------------------------
    // 2013-12-05 | MFU     | OK         | Feld "Suchtgiftgruppe" eingebaut
    // ------------------------------------------------------------------------------------------------------------------------------------
    // 2015-11-23 | MFU     | OK         | Artikelbezeichnungsfeld von 40 auf 50 Erweitert
    // ------------------------------------------------------------------------------------------------------------------------------------
    // 2016-03-16 | MFU     | OK         | KonfektionierungGruppierung eingefügt (Für Export in Produktkalkulation)
    // ------------------------------------------------------------------------------------------------------------------------------------
    // 2016-07-20 | MFU     | OK         | KundenArtikelnummer eingebaut (Koch)
    // ------------------------------------------------------------------------------------------------------------------------------------
    // 2016-07-27 | MFU     | OK         | Linie hinzugefügt (Fauland)
    // ------------------------------------------------------------------------------------------------------------------------------------
    // 2017-01-18 | MFU     | OK         | Produktionslinie hinzugefügt (Rüth)
    // ------------------------------------------------------------------------------------------------------------------------------------
    // 2017-01-26 | MFU     | OK         | Einkäufercode hinzugefügt (Mayrhofer)
    // ------------------------------------------------------------------------------------------------------------------------------------
    // 2017-04-21 | MFU     | OK         | GL001 - Suchtgiftgruppe nur mit Spezialrecht Editierbar
    // ------------------------------------------------------------------------------------------------------------------------------------
    // 2017-12-21 | MFU     | OK         | Neue Felder für Musterzug-Projekt -> MIBI,Gesamtmustermenge,Rückstellmustermenge
    // ------------------------------------------------------------------------------------------------------------------------------------
    // 2018-06-28 | MFU     | OK         | AlternativeArtikelnummer für Übertragung an MEPIS (für Tracelink notwändig)
    // ------------------------------------------------------------------------------------------------------------------------------------
    // 2018-10-23 | MFU     | OK         | WareneingangFixeMusterAnzahl eingebaut (für Rohstoffprüfbericht)
    // ------------------------------------------------------------------------------------------------------------------------------------

    DataCaptionFields = ItemDescription;
    DataClassification = ToBeClassified;
    //DrillDownPageID = 50038;
    //LookupPageID = 50038;

    fields
    {
        field(1; "ItemNo."; Code[20])
        {
            Caption = 'Artikelnr.';
            TableRelation = Item."No.";
        }
        field(2; ItemDescription; Text[100])
        {
            CalcFormula = lookup(Item.Description where("No." = field("ItemNo.")));
            Caption = 'Artikelbezeichnung';
            FieldClass = FlowField;
        }
        field(3; "Webshop-Anzeige"; Boolean)
        {
        }
        field(4; Artikelname; Text[50])
        {
        }
        field(5; Wirkstaerke; Code[10])
        {
            Caption = 'Wirkstärke';
        }
        field(6; Darreichungsform; Code[20])
        {

        }
        field(7; Teilbarkeit; Boolean)
        {
        }
        field(8; Aussehen; Code[20])
        {

        }
        field(9; Laktosefrei; Boolean)
        {
        }
        field(10; Erstanbieter; Text[30])
        {
        }
        field(11; "Dateiname Artikelbild"; Text[50])
        {
        }
        field(12; "Dateiname FI"; Text[50])
        {
        }
        field(13; "Dateiname GI"; Text[50])
        {
        }
        field(14; Suchtgiftgruppe; Code[20])
        {

        }
        field(15; KonfektionierungGruppierung; Code[10])
        {
        }
        field(16; KundenArtikelnummer; Code[20])
        {
        }
        field(17; Linie; Code[20])
        {
        }
        field(18; Produktionslinie; Text[30])
        {

        }
        field(19; "Einkäufercode"; Code[10])
        {
            TableRelation = "Salesperson/Purchaser".Code;
        }
        field(20; "CNK No."; Code[10])
        {
        }
        field(21; MIBI; Boolean)
        {
        }
        field(22; Gesamtmustermenge; Decimal)
        {
        }
        field(23; "Rückstellmustermenge"; Decimal)
        {
        }
        field(25; bRohstoffMaske; Boolean)
        {
        }
        // field(26; ItemArtikelart; Option)
        // {
        //     CalcFormula = lookup(Item.Artikelart where("No." = field("ItemNo.")));
        //     Caption = 'Item type';
        //     
        //     FieldClass = FlowField;
        //     OptionCaption = ' ,Rohstoff,Halbfabrikat,Fertigprodukt,Verpackungsstoff,Arbeitsschritt';
        //     OptionMembers = " ",Rohstoff,Halbfabrikat,Fertigprodukt,Verpackungsstoff,Arbeitsschritt;
        // }
        field(27; MIBIGramm; Text[10])
        {
        }
        field(28; AlternativeArtikelnummer; Code[20])
        {
        }
        field(29; WareneingangFixeMusterAnzahl; Integer)
        {
        }
        field(30; "Suchtgiftübergruppe"; Code[20])
        {
            //  TableRelation = Suchtgiftübergruppen.Suchtgiftübergruppe;
        }
        field(31; "LS Beginn Schenker"; Decimal)
        {
        }
        field(32; "Bestellmenge Schenker"; Decimal)
        {
        }
        field(33; "LS Beginn Lannach"; Decimal)
        {
        }
        field(34; "Bestellmenge Lannach"; Decimal)
        {
        }
        field(35; "LS Beginn Wien"; Decimal)
        {
        }
        field(36; "Bestellmenge Wien"; Decimal)
        {
        }
        field(37; "Umlagerung Schenker"; Decimal)
        {
        }
        field(38; "HM Schenker"; Decimal)
        {
        }
        field(39; "Umlagerung Lannach"; Decimal)
        {
        }
        field(40; "HM Lannach"; Decimal)
        {
        }
        field(41; "Umlagerung Wien"; Decimal)
        {
        }
        field(42; "HM Wien"; Decimal)
        {
        }
        field(43; "IM Lannach"; Decimal)
        {
        }
        field(44; "IM Schenker"; Decimal)
        {
        }
        field(45; "IM Wien"; Decimal)
        {
        }
    }

    keys
    {
        key(Key1; "ItemNo.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnModify()
    begin

        // if (Rec.Suchtgiftgruppe <> xRec.Suchtgiftgruppe) then
        //     if not NaviPharma.Berechtigung('$ARTIKELBEARBEITENSG') then
        //         Error('Fehlende Berechtigung für Änderung von Suchtgift Stammdaten!');
    end;

    // var
    //     NaviPharma: Codeunit NaviPharma
}