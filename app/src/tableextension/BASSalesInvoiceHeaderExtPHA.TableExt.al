tableextension 50021 BASSalesInvoiceHeaderExtPHA extends "Sales Invoice Header"
{

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
    //   New Fields: ID 50501, 50601
    // 
    // GL001 Belegwahl je nach Einstellung im Bericht
    //       Feld Firmenkopf
    // 
    // Datum      | Autor   | Status     | Beschreibung
    // --------------------------------------------------------------------------------------------------------
    // 2010-02-09 | Petsch  | ok         | Update von 3.60
    // ---------------------------------------------------------------------------------------------------------
    // 2012-03-15 | Petsch  | ok         | Valeant: WriteInternalEDI
    // ---------------------------------------------------------------------------------------------------------
    // 2012-03-29 | MFU     | ok         | GL003 - Buchungsdatum mit in die Datenübernahme -> Damit Valeant das gleiche Buchungsdatum hat
    // ---------------------------------------------------------------------------------------------------------
    // 2013-03-21 | MFU     | ok         | Feld "PDFDruck" Boolean und "Bill-to E-Mail" eingebaut
    // ---------------------------------------------------------------------------------------------------------
    // 2015-01-07 | MFU     | ok         | "Your Reference" von 35 auf 50 Zeichen erweitert
    // ------------------------------------------------------------------------------------------------------------------------------------
    // 2015-09-18 | MFU     | ok         | Feld "VKBetragMenge+NR" eingebaut (Nebel NR Berechnung)
    // ------------------------------------------------------------------------------------------------------------------------------------
    // 2016-06-13 | MFU     | ok         | GL004 - WriteInternalEDI upgedatet
    // ------------------------------------------------------------------------------------------------------------------------------------
    // 2016-12-05 | MFU     | ok         | EinAusFuhrBewilligungsNr Spalte eingebaut
    // --------------------------------------------------------------------------------------------------------
    // 2017-01-12 | MFU     | ok         | Lieferungstext * Spalten eingebaut
    // --------------------------------------------------------------------------------------------------------
    // 2018-05-07 | MFU     | ok         | WindreamPDF hinzugefügt
    // --------------------------------------------------------------------------------------------------------
    // 2018-08-16 | DKO     | ok         | CmrVorhanden, CmrErforderlich Spalten hinzugefügt.
    // --------------------------------------------------------------------------------------------------------
    // 2018-10-29 | DKO     | ok         | GL005 - Bei Rechnungsnachdruck nicht mehr in WD ablegen.
    //                                   |         Funktion:IstNachdruck
    // --------------------------------------------------------------------------------------------------------
    // 2018-11-07 | MFU     | ok         | Feld Address 3 eingebaut
    // --------------------------------------------------------------------------------------------------------
    // 2019-01-09 | MFU     | ok         | GL045 -> Ein / Ausfuhrbew. Nr erweitert
    // --------------------------------------------------------------------------------------------------------
    // 2019-12-20 | MFU     | ok         | Betriebsnummern für SG-Abrechnung mitspeichern
    // --------------------------------------------------------------------------------------------------------
    // 
    // 
    // 
    // 
    // 9.4.2014 upgedated
    // 
    // WD001 13.02.07 ACPWF
    //   Windream Archivierung
    //   Coded added in Function: "PrintRecords"
    fields
    {
        /*
        field(50003; "BASinvoice copiesPHA"; Integer)
        {
            Caption = 'Invoice Copies';
            
        }
        field(50005; BASFirmenkopfPHA; Code[10])
        {
            
        }
        field(50007; BASTransportversicherungPHA; Boolean)
        {
            
        }
        */
        field(50014; "Zugehörigkeitsdatum"; Date)
        {

        }
        field(50015; "BASShip-to Customer No.PHA"; Code[20])
        {
            Caption = 'Lief. an Deb.-Nr.';

        }
        /*
        field(50016; BASLieferdatumPHA; Text[30])
        {
            
        }
        field(50017; BASPDFDruckPHA; Boolean)
        {
        }
        field(50018; "VKBetragMenge+NR"; Boolean)
        {
        }
        field(50019; "BASLieferungstext 1PHA"; Text[50])
        {
            
        }
        field(50020; "BASLieferungstext 2PHA"; Text[50])
        {
            
        }
        */
        field(50021; BASWindreamPDFPHA; Boolean)
        {
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
        /*
        field(50026; BASKundenBetriebsnummerPHA; Code[10])
        {
            
        }
        field(50027; BASGLBetriebsnummerPHA; Code[10])
        {
            
        }
        field(50028; BASKundenBetriebsnummerGHPHA; Code[10])
        {
            
        }
        field(50501; "BASBill-to CodePHA"; Code[10])
        {
            Caption = 'Bill-to Code';
            
            TableRelation = "Ship-to Address".Code where("Customer No." = FIELD("Bill-to Customer No."));
        }
        field(50503; "BASBill-to E-MailPHA"; Text[80])
        {
        }
        field(50506; BASEinFuhrBewilligungsNrPHA; Text[150])
        {
            
        }
        field(50507; BASAusFuhrBewilligungsNrPHA; Text[150])
        {
            
        }
        field(50601; BASSammelrechnungstypPHA; Option)
        {
            
            OptionMembers = "Pro Auftrag","Pro Tag",ProWoche,"Pro Monat";
        }
        field(50603; BASCmrVorhandenPHA; Boolean)
        {
            
            Editable = false;
        }
        field(50604; BASCmrErforderlichPHA; Boolean)
        {
        }
        */
    }
}