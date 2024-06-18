page 50002 BASMasterLotListPHA
{
    ApplicationArea = All;
    Caption = 'Master Lot List', comment = 'DEA="Chargenstamm Übersicht"';
    PageType = List;
    SourceTable = "Lot No. Information";
    UsageCategory = Administration;

    layout
    {
        area(Content)
        {
            repeater(Control1)
            {
                field("ArtikelPackungsgröße"; Rec."ArtikelPackungsgröße")
                {
                    ToolTip = 'Specifies the value of the ArtikelPackungsgröße field.', Comment = '%';
                }
                field("BASCEP NrPHA"; Rec."BASCEP NrPHA")
                {
                    ToolTip = 'Specifies the value of the BASCEP NrPHA field.', Comment = '%';
                }
                field(BASChangeStatusPHA; Rec.BASChangeStatusPHA)
                {
                    ToolTip = 'Specifies the value of the Change Status field.', Comment = '%DEA="Änderungsstatus"';
                }
                field(BASEntryDatePHA; Rec.BASEntryDatePHA)
                {
                    ToolTip = 'Specifies the value of the Zugangsdatum field.', Comment = '%';
                }
                field(BASErstablaufdatumPHA; Rec.BASErstablaufdatumPHA)
                {
                    ToolTip = 'Specifies the value of the BASErstablaufdatumPHA field.', Comment = '%';
                }
                field(BASExpirationDateDMPHA; Rec.BASExpirationDateDMPHA)
                {
                    ToolTip = 'Specifies the value of the BASExpirationDateDMPHA field.', Comment = '%';
                }
                field(BASExpirationDatePHA; Rec.BASExpirationDatePHA)
                {
                    ToolTip = 'Specifies the value of the Expiration Date field.';
                }
                field(BASFABeschreibung2PHA; Rec.BASFABeschreibung2PHA)
                {
                    ToolTip = 'Specifies the value of the BASFABeschreibung2PHA field.', Comment = '%';
                }
                field(BASGehaltPHA; Rec.BASGehaltPHA)
                {
                    ToolTip = 'Specifies the value of the BASGehaltPHA field.', Comment = '%';
                }
                field(BASHFCommentPHA; Rec.BASHFCommentPHA)
                {
                    ToolTip = 'Specifies the value of the BASHFCommentPHA field.', Comment = '%';
                }
                field(BASItemBlockedPHA; Rec.BASItemBlockedPHA)
                {
                    ToolTip = 'Specifies the value of the Artikel gesperrt field.', Comment = '%';
                }
                field(BASItemDescriptionPHA; Rec.BASItemDescriptionPHA)
                {
                    ToolTip = 'Specifies the value of the BASItemDescriptionPHA field.', Comment = '%';
                }
                field(BASItemTypePHA; Rec.BASItemTypePHA)
                {
                    ToolTip = 'Specifies the value of the BASItemTypePHA field.', Comment = '%';
                }
                field(BASLaborkommentarPHA; Rec.BASLaborkommentarPHA)
                {
                    ToolTip = 'Specifies the value of the BASLaborkommentarPHA field.', Comment = '%';
                }
                field(BASLaetusCodePHA; Rec.BASLaetusCodePHA)
                {
                    ToolTip = 'Specifies the value of the BASLaetusCodePHA field.', Comment = '%';
                }
                field(BASLimsBacklogEntriesPHA; Rec.BASLimsBacklogEntriesPHA)
                {
                    ToolTip = 'Specifies the value of the BASLimsBacklogEntriesPHA field.', Comment = '%';
                }
                field(BASLimsImportInProgressPHA; Rec.BASLimsImportInProgressPHA)
                {
                    ToolTip = 'Specifies the value of the BASLimsImportInProgressPHA field.', Comment = '%';
                }
                field(BASLimsStatusPHA; Rec.BASLimsStatusPHA)
                {
                    ToolTip = 'Specifies the value of the BASLimsStatusPHA field.', Comment = '%';
                }
                field(BASManufaturingNoPHA; Rec.BASManufaturingNoPHA)
                {
                    ToolTip = 'Specifies the value of the Manufacturing No. field.', Comment = '%DEA="Herstellernr."';
                }
                field(BASMIBIPHA; Rec.BASMIBIPHA)
                {
                    ToolTip = 'Specifies the value of the BASMIBIPHA field.', Comment = '%';
                }
                field(BASOpenPHA; Rec.BASOpenPHA)
                {
                    ToolTip = 'Specifies the value of the Open field.', Comment = '%DEA="Offen"';
                }
                field(BASPackmittelversionPHA; Rec.BASPackmittelversionPHA)
                {
                    ToolTip = 'Specifies the value of the BASPackmittelversionPHA field.', Comment = '%';
                }
                field(BASProduktionsdatumPHA; Rec.BASProduktionsdatumPHA)
                {
                    ToolTip = 'Specifies the value of the BASProduktionsdatumPHA field.', Comment = '%';
                }
                field(BASReleaseDatePHA; Rec.BASReleaseDatePHA)
                {
                    ToolTip = 'Specifies the value of the Freigabedatum field.';
                }
                field(BASReleaseNamePHA; Rec.BASReleaseNamePHA)
                {
                    ToolTip = 'Specifies the value of the Freigabename field.';
                }
                field(BASSalesLotNoPHA; Rec.BASSalesLotNoPHA)
                {
                    ToolTip = 'Specifies the value of the Verkaufschargennr. field.';
                }
                field(BASShipmentFinishedDatePHA; Rec.BASShipmentFinishedDatePHA)
                {
                    ToolTip = 'Specifies the value of the BASShipmentFinishedDatePHA field.', Comment = '%';
                }
                field(BASShipmentLotNoPHA; Rec.BASShipmentLotNoPHA)
                {
                    ToolTip = 'Specifies the value of the BASShipmentLotNoPHA field.', Comment = '%';
                }
                field(BASStatisticCodeIIIPHA; Rec.BASStatisticCodeIIIPHA)
                {
                    ToolTip = 'Specifies the value of the BASStatisticCodeIIIPHA field.', Comment = '%';
                }
                field(BASStatisticCodeIIPHA; Rec.BASStatisticCodeIIPHA)
                {
                    ToolTip = 'Specifies the value of the BASStatisticCodeIIPHA field.', Comment = '%';
                }
                field(BASStatisticCodeIPHA; Rec.BASStatisticCodeIPHA)
                {
                    ToolTip = 'Specifies the value of the BASStatisticCodeIPHA field.', Comment = '%';
                }
                field(BASStatusPHA; Rec.BASStatusPHA)
                {
                    ToolTip = 'Chargenstatus';
                }
                field(Blocked; Rec.Blocked)
                {
                    ToolTip = 'Specifies that the related record is blocked from being posted in transactions, for example a customer that is declared insolvent or an item that is placed in quarantine.';
                }
                field("Certificate Number"; Rec."Certificate Number")
                {
                    ToolTip = 'Specifies the number provided by the supplier to indicate that the batch or lot meets the specified requirements.';
                }
                field(Comment; Rec.Comment)
                {
                    ToolTip = 'Specifies that a comment has been recorded for the lot number.';
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.';
                }
                field("Expired Inventory"; Rec."Expired Inventory")
                {
                    ToolTip = 'Specifies the inventory of the lot number with an expiration date before the posting date on the associated document.';
                }
                field(Inventory; Rec.Inventory)
                {
                    ToolTip = 'Specifies the value of the Lagerstand field.';
                }
                field("Item No."; Rec."Item No.")
                {
                    ToolTip = 'Specifies this number from the Tracking Specification table when a lot number information record is created.';
                }
                field("Lot No."; Rec."Lot No.")
                {
                    ToolTip = 'Specifies the value of the Lot No. field.';
                }
                field("Rückstellmuster"; Rec."Rückstellmuster")
                {
                    ToolTip = 'Specifies the value of the Rückstellmuster field.', Comment = '%';
                }
                field("Test Quality"; Rec."Test Quality")
                {
                    ToolTip = 'Specifies the quality of a given lot if you have inspected the items.';
                }
                field("Variant Code"; Rec."Variant Code")
                {
                    ToolTip = 'Specifies the variant of the item on the line.';
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Line")
            {
                Caption = '&Line';
                Image = Line;
                action(Card)
                {
                    Caption = 'Card';
                    Image = EditLines;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedOnly = true;
                    ShortCutKey = 'Return';
                    ToolTip = 'Executes the Card action.';

                    trigger OnAction()
                    var
                        Item: Record Item;
                        MasterLotCard: Page BASMasterLotCardPHA;
                    begin
                        Item.SetRange("No.", Rec."Item No.");
                        MasterLotCard.SetTableView(Item);
                        MasterLotCard.Run();
                    end;
                }
                action(ItemLedgerEntries)
                {
                    Image = ItemLines;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Item Ledger Entries";
                    RunPageLink = "Item No." = field("Item No.");
                    RunPageView = sorting("Entry No.")
                                  order(descending);
                    ToolTip = 'Executes the Artikelposten action.';
                }
                action(Chargenfreigabe)
                {
                    Image = CheckList;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ToolTip = 'Executes the Chargenfreigabe action.';
                    Visible = true; // ToDo

                    trigger OnAction()
                    var
                        LotNoInformation: Record "Lot No. Information";
                        CodeCollectionGLDE: Codeunit BASCodeCollectionGLDEPHA;
                        ReleaseLot: Page BASGLReleaseLotPHA;
                        RoleIdTxt: Label '$MARKTFREIGABE', Locked = true;
                    begin
                        LotNoInformation.Reset();
                        LotNoInformation.FilterGroup(2);
                        LotNoInformation.SetRange("Item No.", Rec."Item No.");
                        LotNoInformation.SetRange("Lot No.", Rec."Lot No.");
                        LotNoInformation.FilterGroup(0);
                        ReleaseLot.SetTableView(LotNoInformation);
                        ReleaseLot.SetRecord(LotNoInformation);
                        Rec.CalcFields(BASItemTypePHA);

                        if not ((Rec.BASItemTypePHA = Rec.BASItemTypePHA::"Finished Product") and not CodeCollectionGLDE.Permission(RoleIdTxt)) then
                            Message('Keine Marktfreigaberechte vorhanden!');
                    end;
                }
            }
            action(LotTestPointsAnnualReview)
            {
                Caption = 'Chargen Prüfpunkte Annual Review';
                Image = AgreementQuote;
                ToolTip = 'Executes the Chargen Prüfpunkte Annual Review action.';
                trigger OnAction()
                begin
                    // ToDo
                    ;//Rec.ChargenPruefpunkteShowAR();
                end;
            }
            action(Artikelablaufverfolgung)
            {
                Image = Track;
                ToolTip = 'Executes the Artikelablaufverfolgung action.';

                trigger OnAction()
                var
                    ItemTracingBuffer: Record "Item Tracing Buffer";
                    ItemTracking: Page "Item Tracing";
                begin
                    ItemTracingBuffer.Reset();
                    ItemTracingBuffer.SetRange("Item No.", Rec."Item No.");
                    ItemTracingBuffer.SetRange("Lot No.", Rec."Lot No.");
                    ItemTracking.InitFilters(ItemTracingBuffer);
                    ItemTracking.Run();
                end;
            }
        }
    }
}