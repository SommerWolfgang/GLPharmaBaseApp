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
            Description = 'Petsch';
        }
        field(50005; BASFirmenkopfPHA; Code[10])
        {
            Description = 'Fürbaß';
        }
        field(50007; BASTransportversicherungPHA; Boolean)
        {
            Description = 'MFU';
        }
        */
        field(50014; "Zugehörigkeitsdatum"; Date)
        {
            Description = 'Fürbaß';
        }
        field(50015; "BASShip-to Customer No.PHA"; Code[20])
        {
            Caption = 'Lief. an Deb.-Nr.';
            Description = 'Fürbaß';
        }
        /*
        field(50016; BASLieferdatumPHA; Text[30])
        {
            Description = 'Fürbaß';
        }
        field(50017; BASPDFDruckPHA; Boolean)
        {
        }
        field(50018; "VKBetragMenge+NR"; Boolean)
        {
        }
        field(50019; "BASLieferungstext 1PHA"; Text[50])
        {
            Description = 'MFU';
        }
        field(50020; "BASLieferungstext 2PHA"; Text[50])
        {
            Description = 'MFU';
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
        field(50501; "BASBill-to CodePHA"; Code[10])
        {
            Caption = 'Bill-to Code';
            Description = 'LAN1.00';
            TableRelation = "Ship-to Address".Code WHERE("Customer No." = FIELD("Bill-to Customer No."));
        }
        field(50503; "BASBill-to E-MailPHA"; Text[80])
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
        field(50601; BASSammelrechnungstypPHA; Option)
        {
            Description = 'LAN1.00';
            OptionMembers = "Pro Auftrag","Pro Tag",ProWoche,"Pro Monat";
        }
        field(50603; BASCmrVorhandenPHA; Boolean)
        {
            Description = 'DKO, WD';
            Editable = false;
        }
        field(50604; BASCmrErforderlichPHA; Boolean)
        {
        }
        */
    }
    procedure WriteInternalEDI()
    var
        recCustomer: Record "18";
        recCompanyInfo: Record "79";
        recSalesInvoiceLine: Record "113";
        recDatenAustausch: Record "50010";
    begin
        /*
        //-002
        recCompanyInfo.GET;
        recSalesInvoiceLine.SETRANGE("Document No.", "No.");
        recSalesInvoiceLine.SETRANGE(Type, recSalesInvoiceLine.Type::Item);
        recSalesInvoiceLine.SETFILTER(Quantity, '<>0');
        IF recSalesInvoiceLine.FindSet() THEN
            REPEAT
                recDatenAustausch.INIT;
                recDatenAustausch.Quelle := COMPANYNAME;
                recDatenAustausch.Ziel := 'GL-DE';     //GL004
                recDatenAustausch.Eintragsdatum := TODAY;
                recDatenAustausch.Eintragsuhrzeit := TIME;
                recDatenAustausch.QuellBenutzer := USERID;
                recDatenAustausch.Geschäftsfall := 'VKRECH->EKBESTELL';
                recDatenAustausch.QuellEDIReferenz := "Sell-to Customer No.";
                recCustomer.GET("Sell-to Customer No.");
                recDatenAustausch.ZielEDIReferenz := "Sell-to Contact";
                recDatenAustausch.Quellbelegnr := "No.";
                recDatenAustausch.Quellzeilennr := recSalesInvoiceLine."Line No.";
                recDatenAustausch.Artikelnr := recSalesInvoiceLine."No.";
                recDatenAustausch.Artikelname := recSalesInvoiceLine.Description;
                recDatenAustausch.Menge := recSalesInvoiceLine.Quantity;
                recDatenAustausch.Einheit := recSalesInvoiceLine."Unit of Measure";
                recDatenAustausch.Einzelpreis := recSalesInvoiceLine."Unit Price";
                recDatenAustausch.Rabatt := ROUND(recSalesInvoiceLine."Line Discount %" * recSalesInvoiceLine."Unit Price" / 100, 0.01);
                recDatenAustausch.Gesamtpreis := ROUND((recSalesInvoiceLine."Unit Price" * recSalesInvoiceLine.Quantity) -
                                                 recDatenAustausch.Rabatt, 0.01);
                recDatenAustausch.Chargennr := recSalesInvoiceLine."Lot No.";
                recDatenAustausch.Verkaufschargennr := recSalesInvoiceLine."Verkaufschargennr.";
                recDatenAustausch.Ablaufdatum := recSalesInvoiceLine."Expiration Date";
                recDatenAustausch.ExterneBelegnummer := "External Document No.";
                recDatenAustausch.Status := recDatenAustausch.Status::angelegt;
                //-GL003
                recDatenAustausch.Buchungsdatum := "Posting Date";
                //+GL003
                recDatenAustausch.INSERT;

            UNTIL recSalesInvoiceLine.NEXT = 0;

        //+002
        */
    end;

    procedure SetIstNachdruck(IstNachdruck: Boolean)
    begin
        //-GL005
        bIstNachdruck := IstNachdruck;
        //+GL005
    end;

    var
        bIstNachdruck: Boolean;
}
