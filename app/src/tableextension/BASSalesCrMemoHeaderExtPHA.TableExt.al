tableextension 50022 BASSalesCrMemoHeaderExtPHA extends "Sales Cr.Memo Header"
{// version NAVW114.45,TODOPBA

    // -----------------------------------------------------
    // (c) gbedv, OPplus, All rights reserved
    // 
    // No.  Date       changed
    // -----------------------------------------------------
    // OPP  01.05.12   OPplus Granules
    //                 - New Field added
    // -----------------------------------------------------
    // 
    // 
    // LAN001 12.11.09 ACPSS LAN1.00
    //   New Fields: ID 50500, 50501, 50601
    // 
    // GL001 Belegwahl je nach Einstellung im Bericht
    //       Feld Firmenkopf
    // 
    // Datum      | Autor   | Status     | Beschreibung
    // --------------------------------------------------------------------------------------------------------
    // 2010-02-09 | Petsch  | ok         | Update von 3.60
    // ---------------------------------------------------------------------------------------------------------
    // 2010-04-29 | MFU     | ok         | Spalte Zugehörigkeitsdatum für Wertgutschriften einbauen
    // ---------------------------------------------------------------------------------------------------------
    // 2013-03-22 | MFU     | ok         | Spalte PDF-Druck einbauen für Druck von nur Rechnungskopie
    // ---------------------------------------------------------------------------------------------------------
    // 2013-05-06 | MFU     | ok         | Feld "StornoMitRechNr" eingebaut zur Erkennung von Stornos für Suchtgiftliste
    // ---------------------------------------------------------------------------------------------------------
    // 2015-01-07 | MFU     | ok         | "Your Reference" von 35 auf 50 Zeichen erweitert
    // ------------------------------------------------------------------------------------------------------------------------------------
    // 2017-09-07 | MFU     | ok         | "EinFuhrBewilligungsNr", "AusFuhrBewilligungsNr" eingebaut
    // ------------------------------------------------------------------------------------------------------------------------------------
    // 2017-09-26 | MFU     | ok         | Spalte "Export_Mengenimport" für Suchtgiftabrechnung eingebaut
    // --------------------------------------------------------------------------------------------------------
    // 2018-05-07 | MFU     | ok         | Spalte "WindreamPDF" eingebaut
    // --------------------------------------------------------------------------------------------------------
    // 2018-08-07 | MFU     | ok         | Feld Korrekturgrund_ZSMOPL eingebaut
    // --------------------------------------------------------------------------------------------------------
    // 2018-11-07 | MFU     | ok         | Feld Address 3 eingebaut
    // --------------------------------------------------------------------------------------------------------
    // 2019-01-09 | MFU     | ok         | GL045 -> Ein / Ausfuhrbew. Nr erweitert
    // --------------------------------------------------------------------------------------------------------
    // 2019-12-20 | MFU     | ok         | Betriebsnummern für SG-Abrechnung mitspeichern
    // --------------------------------------------------------------------------------------------------------
    fields
    {
        field(50003; "BASinvoice copiesPHA"; Integer)
        {
            Caption = 'Invoice Copies';
            Description = 'Petsch';
        }
        field(50004; BASAuftragsnummerPHA; Code[20])
        {
            Description = 'MFU';
        }
        field(50005; BASFirmenkopfPHA; Code[10])
        {
            Description = 'Fürbaß';
        }
        field(50006; BASPDFDruckPHA; Boolean)
        {
        }
        field(50007; BASTransportversicherungPHA; Boolean)
        {
        }
        field(50014; "Zugehörigkeitsdatum"; Date)
        {
            Caption = 'Posting Date';
        }
        field(50021; BASWindreamPDFPHA; Boolean)
        {
        }
        field(50022; BASKorrekturgrund_ZSMOPLPHA; Text[30])
        {
            Description = 'MFU';
        }
        field(50023; "BASSell-to Address 3PHA"; Text[50])
        {
            Caption = 'Verk. an Adresse 3';
        }
        field(50024; "BASShip-to Address 3PHA"; Text[50])
        {
            Caption = 'Lief. an Adresse 3';
        }
        field(50025; "BASBill-to Address 3PHA"; Text[50])
        {
            Caption = 'Rech. an Adresse 3';
        }
        field(50026; BASKundenBetriebsnummerPHA; Code[10])
        {
            Description = 'MFU';
        }
        field(50027; BASGLBetriebsnummerPHA; Code[10])
        {
            Description = 'MFU';
        }
        field(50028; BASKundenBetriebsnummerGHPHA; Code[10])
        {
            Description = 'MFU';
        }
        field(50500; BASWertgutschriftPHA; Boolean)
        {
            Description = 'LAN1.00';
        }
        field(50501; "BASBill-to CodePHA"; Code[10])
        {
            Caption = 'Bill-to Code';
            Description = 'LAN1.00';
            TableRelation = "Ship-to Address".Code WHERE("Customer No." = FIELD("Bill-to Customer No."));
        }
        field(50504; BASStornoMitRechNrPHA; Code[150])
        {
        }
        field(50506; BASEinFuhrBewilligungsNrPHA; Text[150])
        {
            Description = 'MFU';
        }
        field(50507; BASAusFuhrBewilligungsNrPHA; Text[150])
        {
            Description = 'MFU';
        }
        field(50508; BASExport_MengenimportPHA; Boolean)
        {
            Description = 'MFU';
        }
        field(50601; BASSammelrechnungstypPHA; Option)
        {
            Description = 'LAN1.00';
            OptionMembers = "Pro Auftrag","Pro Tag",ProWoche,"Pro Monat";
        }
    }
}
