page 50003 BASGLReleaseLotPHA
{
    Caption = 'GL Batch release', comment = 'DEA="GL Chargenfreigabe';
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Worksheet;
    SourceTable = "Lot No. Information";

    layout
    {
        area(content)
        {
            group(General)
            {
                group(test)
                {
                    Caption = 'General', comment = 'DEA="Allgemein"';

                    field(Chargennr; Rec."Lot No.")
                    {
                        ApplicationArea = All;
                        Editable = bEditable and bEditableStatusAblaufDatum;
                        Style = StandardAccent;
                        StyleExpr = ColorLotNo;
                        ToolTip = 'Specifies the value of the Lot No. field.';

                        trigger OnValidate()
                        begin
                            if xRec."Lot No." <> Rec."Lot No." then
                                if not CONFIRM(TextLotChangeTxt, false, xRec."Lot No.", Rec."Lot No.") then
                                    ERROR('Chargennummer wurde nicht umbenannt');

                            Rec.FilterGroup(2);
                            REc.SetRange("Lot No.", Rec."Lot No.");
                            Rec.FilterGroup(0);

                            SetChangeStatusColors();
                        end;
                    }
                    field(SalesLotNo; Rec.BASSalesLotNoPHA)
                    {
                        ApplicationArea = All;
                        Editable = bEditable;
                        ToolTip = 'Specifies the value of the Verkaufschargennr. field.';

                    }
                    field(ExpiredDate; Rec.BASExpirationDatePHA)
                    {
                        ApplicationArea = All;
                        Editable = bEditable and bEditableStatusAblaufDatum;
                        ToolTip = 'Specifies the value of the Expiration Date field.';

                        trigger OnValidate()
                        begin
                            if not cuCodsammlung.BelivableExpiredDate(Rec."Item No.", Rec.BASExpirationDatePHA) then
                                ERROR('Ablaufdatum %1 ist nicht Plausibel', FORMAT(Rec.BASExpirationDatePHA));

                            SetChangeStatusColors();
                        end;
                    }

                    field(Status; Status)
                    {
                        ApplicationArea = All;
                        Caption = 'Status', comment = 'DEA="Status"';
                        Editable = bEditableStatusAblaufDatum;
                        ToolTip = 'Specifies the value of the optGLStatus field.';
                        trigger OnValidate()
                        begin
                            SetStatusColor();
                        end;
                    }
                    field(ReleaseDate; Rec.BASReleaseDatePHA)
                    {
                        ApplicationArea = All;
                        Editable = false;
                        ToolTip = 'Specifies the value of the Freigabedatum field.';
                    }
                    field(Freigabename; Rec.BASReleaseNamePHA)
                    {
                        ApplicationArea = All;
                        Editable = false;
                        ToolTip = 'Specifies the value of the Freigabename field.';
                    }
                    field(Inventory; Rec.Inventory)
                    {
                        ApplicationArea = All;
                        Editable = false;
                        ToolTip = 'Specifies the value of the Lagerstand field.';

                        trigger OnLookup(var Text: Text): Boolean
                        var
                            TempItemLedgerEntry: Record "Item Ledger Entry" temporary;
                        begin
                            TempItemLedgerEntry."Item No." := Rec."Item No.";
                            TempItemLedgerEntry.SetRange("Item No.", Rec."Item No.");
                            TempItemLedgerEntry.SetRange(Open, true);
                            // ToDo
                            //if Page.RunModal(PAGE::TransferOrderInfo, TempItemLedgerEntry) = Action::LookupOK then;
                        end;
                    }
                    field(Description; Rec.Description)
                    {
                        ApplicationArea = All;
                        Editable = bEditable;
                        ToolTip = 'Specifies the value of the Description field.';
                    }
                }
            }
        }
    }

    var
        cuCodsammlung: Codeunit BASCodeCollectionGLDEPHA;
        bEditable: Boolean;
        bEditableStatusAblaufDatum: Boolean;
        Status: enum BASStatusLotNoInformationPHA;
        StatusOld: enum BASStatusLotNoInformationPHA;
        TextLotChangeTxt: label 'Would you change Lot from %1 to %2?', comment = 'DEA="Wollen Sie die Chargennummer von %1 in %2 umbenennen?';
        AccessControlRoleID: List of [Code[20]];
        ColorExpiredDate: Text;
        ColorLabComment: Text;
        ColorLotNo: Text;
        ColorShipCh: Text;
        ColorStatus: Text;
        ColorVKCh: Text;
        FarbeGehalt: Text;
        FarbePackmittelVersion: Text;
        StatusColor: Text;
        TestEnvironment: Text[50];

    trigger OnOpenPage()
    begin
        CheckTestEnvironment();
        InsertAccessControlRoleID();
    end;

    trigger OnAfterGetRecord()
    var
        Item: Record Item;
    begin
        Item.Get(Rec."Item No.");

        SetStatusColor();
        SetChangeStatusColors();

        bEditableStatusAblaufDatum := false;
        bEditable := false;

        bEditable := cuCodsammlung.Permission(AccessControlRoleID.Get(0));

        Rec.SetAutoCalcFields(BASItemTypePHA);

        if bEditable then
            if Rec.BASItemTypePHA = Rec.BASItemTypePHA::"Finished Product" then begin
                bEditableStatusAblaufDatum := (Rec.BASStatusPHA = Rec.BASStatusPHa::Quarantine) and (cuCodsammlung.Permission(AccessControlRoleID.Get(1)));
                bEditableStatusAblaufDatum := cuCodsammlung.Permission(AccessControlRoleID.Get(2));
            end else
                bEditableStatusAblaufDatum := (cuCodsammlung.Permission(AccessControlRoleID.Get(1))) or (cuCodsammlung.Permission(AccessControlRoleID.Get(2)));

        Status := Rec.BASStatusPHA;
        StatusOld := Status;
    end;

    local procedure SetStatusColor();
    begin
        StatusColor := 'Standard';
        if Rec.BASStatusPHA = Rec.BASStatusPHA::Blocked then
            StatusColor := 'Attention';
        if Rec.BASStatusPHA = Rec.BASStatusPHA::Free then
            StatusColor := 'Favorable';
    end;

    local procedure SetChangeStatusColors();
    begin
        ColorLotNo := 'Standard';
        ColorShipCh := 'Standard';
        ColorExpiredDate := 'Standard';
        ColorVKCh := 'Standard';
        FarbeGehalt := 'Standard';
        ColorLabComment := 'Standard';
        ColorStatus := 'Standard';
        FarbePackmittelVersion := 'Standard';
    end;

    local procedure InsertAccessControlRoleID()
    begin
        AccessControlRoleID.Add('GL_CHARGEBEARBEITEN');
        AccessControlRoleID.Add('$CHARGENFREIGABE');
        AccessControlRoleID.Add('$MARKTFREIGABE');
        AccessControlRoleID.Add('$CHARGENFREIGABE');
    end;

    local procedure CheckTestEnvironment()
    begin
        if cuCodsammlung.IsTestEnvironment() then
            TestEnvironment := 'Testumgebung';
    end;
}