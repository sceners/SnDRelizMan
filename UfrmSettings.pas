unit UfrmSettings;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, Buttons, ExtCtrls, StdCtrls;

type
  TfrmSettings = class(TForm)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    lbReleaseTypes: TListBox;
    memInstallNotes: TMemo;
    Splitter1: TSplitter;
    Panel1: TPanel;
    btnRelTypesInstNotesHelp: TSpeedButton;
    btnSave: TBitBtn;
    btnCancel: TBitBtn;
    cbClearReleaseName: TCheckBox;
    cbClearURL: TCheckBox;
    cbClearType: TCheckBox;
    cbClearAttachments: TCheckBox;
    gbClearOnNewRelease: TGroupBox;
    gbRequiredAttachment: TGroupBox;
    lbRequiredAttachmentsRelTypes: TListBox;
    lbRequiredAttachments: TListBox;
    btnRequiredAttachmentsHelp: TSpeedButton;
    btnAddRequiredAttachment: TBitBtn;
    btnRemoveRequiredAttachment: TBitBtn;
    btnClearOnNewReleaseHelp: TSpeedButton;
    btnJustify: TSpeedButton;
    procedure btnJustifyClick(Sender: TObject);
    procedure btnClearOnNewReleaseHelpClick(Sender: TObject);
    procedure btnRequiredAttachmentsHelpClick(Sender: TObject);
    procedure btnRemoveRequiredAttachmentClick(Sender: TObject);
    procedure btnAddRequiredAttachmentClick(Sender: TObject);
    procedure lbRequiredAttachmentsExit(Sender: TObject);
    procedure lbRequiredAttachmentsRelTypesClick(Sender: TObject);
    procedure memInstallNotesExit(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnCancelClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure lbReleaseTypesEnter(Sender: TObject);
    procedure lbReleaseTypesClick(Sender: TObject);
    procedure btnRelTypesInstNotesHelpClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmSettings: TfrmSettings;

implementation

uses
  Unit1, UMySettings;

var
  localcfg: TMySettings;

{$R *.dfm}

procedure TfrmSettings.btnAddRequiredAttachmentClick(Sender: TObject);
var
  str: string;
begin
  if lbRequiredAttachmentsRelTypes.ItemIndex=-1 then begin
    MessageBox(Handle, 'Please select release type first.', 'Information', MB_OK or MB_ICONINFORMATION);
    Exit;
  end;
  if not InputQuery('Query', 'Please type in file mask.', str) then Exit;
  str := Trim(str);
  if Length(str)<>0 then
    lbRequiredAttachments.Items.Add(str);
  lbRequiredAttachmentsExit(nil);
end;

procedure TfrmSettings.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
  Close;
end;

procedure TfrmSettings.btnClearOnNewReleaseHelpClick(Sender: TObject);
begin
  MessageBox(Handle, 'Choose fields you want to be deleted'#13'when you start packing new release.', 'Help', MB_OK or MB_ICONINFORMATION);
end;

procedure TfrmSettings.btnJustifyClick(Sender: TObject);
var
  lista: TStrings;
  duzina: Integer;
  s: string;
begin
  duzina := 69;
{  if GroupBox2.Tag = 1 then duzina := 48
  else if GroupBox2.Tag = 2 then duzina := 51
    else if GroupBox2.Tag = 3 then duzina := 57
      else if GroupBox2.Tag = 4 then duzina := 54
        else if GroupBox2.Tag = 5 then duzina := 52;
        }
  if memInstallNotes.SelLength = 0 then Exit;
  lista := TStringList.Create;
  NLBR2TStrings(memInstallNotes.SelText, lista);
  SrediStrListu(lista, duzina);
  s := TStrings2NLBR(lista);
  memInstallNotes.SelText := s;
  lista.Free;
end;

procedure TfrmSettings.btnRelTypesInstNotesHelpClick(Sender: TObject);
begin
  MessageBox(Handle, 'Set installation notes for release types here.'#13'Every time you change release type in main window,'#13'installation notes are changed too.'#13'You don''t have to type everything manually anymore.', 'Help', MB_OK or MB_ICONINFORMATION);
end;

procedure TfrmSettings.btnRemoveRequiredAttachmentClick(Sender: TObject);
begin
  if lbRequiredAttachmentsRelTypes.ItemIndex=-1 then begin
    MessageBox(Handle, 'Please select release type first.', 'Information', MB_OK or MB_ICONINFORMATION);
    Exit;
  end;
  if lbRequiredAttachments.ItemIndex<>-1 then
    lbRequiredAttachments.Items.Delete(lbRequiredAttachments.ItemIndex);
end;

procedure TfrmSettings.btnRequiredAttachmentsHelpClick(Sender: TObject);
begin
  MessageBox(Handle, 'For each release type you can specify wildcards for files that should be'#13'among attachments. When you try to save release that doesn''t have'#13'proper files you will be warned but you will be able to save it.', 'Help', MB_OK or MB_ICONINFORMATION);
end;

procedure TfrmSettings.btnSaveClick(Sender: TObject);
var
  name, sval: string;
  slval: TStrings;
  ival: Integer;
  bval: Boolean;
begin
  //Save currently editing setting
  if lbReleaseTypes.ItemIndex<>-1 then
    localcfg.setStringList('installNote-'+lbReleaseTypes.Items[lbReleaseTypes.ItemIndex], memInstallNotes.Lines);
  //Save strings
  localcfg.rewindStr;
  while localcfg.getStringNext(name, sval) do
    frmMain.cfg.setString(name, sval);
  //Save string lists
  localcfg.rewindStrList;
  slval := TStringList.Create;
  while localcfg.getStringListNext(name, slval) do
    frmMain.cfg.setStringList(name, slval);
  slval.Free;
  //Save integers
  localcfg.rewindInt;
  while localcfg.getIntNext(name, ival) do
    frmMain.cfg.setInt(name, ival);
  //Save bools
  localcfg.rewindBool;
  while localcfg.getBoolNext(name, bval) do
    frmMain.cfg.setBool(name, bval);
  ModalResult := mrOk;
  Close;
  //Save Clear fields options
  with frmMain.cfg do begin
    setBool('clearReleaseName', cbClearReleaseName.Checked);
    setBool('clearURL', cbClearURL.Checked);
    setBool('clearReleaseType', cbClearType.Checked);
    setBool('clearAttachments', cbClearAttachments.Checked);
  end;
end;

procedure TfrmSettings.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  memInstallNotes.Clear;
  lbReleaseTypes.ItemIndex := -1;
end;

procedure TfrmSettings.FormCreate(Sender: TObject);
begin
  localcfg := TMySettings.Create();
  lbReleaseTypes.Items.Clear;
  lbReleaseTypes.Items.AddStrings(frmMain.edtReleaseType.Items);
  lbRequiredAttachmentsRelTypes.Items.AddStrings(frmMain.edtReleaseType.Items);
end;

procedure TfrmSettings.FormShow(Sender: TObject);
var
  name, sval: string;
  slval: TStrings;
  ival: Integer;
  bval: Boolean;
begin
  PageControl1.ActivePageIndex := 0;
  localcfg.Clear;
  //Load strings
  frmMain.cfg.rewindStr;
  while frmMain.cfg.getStringNext(name, sval) do
    localcfg.setString(name, sval);
  //Load string lists
  frmMain.cfg.rewindStrList;
  slval := TStringList.Create;
  while frmMain.cfg.getStringListNext(name, slval) do
    localcfg.setStringList(name, slval);
  slval.Free;
  //Load integers
  frmMain.cfg.rewindInt;
  while frmMain.cfg.getIntNext(name, ival) do
    localcfg.setInt(name, ival);
  //Load bools
  frmMain.cfg.rewindBool;
  while frmMain.cfg.getBoolNext(name, bval) do
    localcfg.setBool(name, bval);
  //Load Clear fields options
  with frmMain.cfg do begin
    cbClearReleaseName.Checked := getBool('clearReleaseName');
    cbClearURL.Checked := getBool('clearURL');
    cbClearType.Checked := getBool('clearReleaseType');
    cbClearAttachments.Checked := getBool('clearAttachments');
  end;
end;

procedure TfrmSettings.lbReleaseTypesClick(Sender: TObject);
begin
  if lbReleaseTypes.ItemIndex=-1 then Exit;
  localcfg.getStringList('installNote-'+lbReleaseTypes.Items[lbReleaseTypes.ItemIndex], memInstallNotes.Lines);
end;

procedure TfrmSettings.lbReleaseTypesEnter(Sender: TObject);
begin
  if lbReleaseTypes.ItemIndex=-1 then Exit;
  localcfg.setStringList('installNote-'+lbReleaseTypes.Items[lbReleaseTypes.ItemIndex], memInstallNotes.Lines);
end;

procedure TfrmSettings.lbRequiredAttachmentsExit(Sender: TObject);
begin
  if lbRequiredAttachmentsRelTypes.ItemIndex=-1 then Exit;
  localcfg.setStringList('requiredAttachments-'+lbRequiredAttachmentsRelTypes.Items[lbRequiredAttachmentsRelTypes.ItemIndex], lbRequiredAttachments.Items);
end;

procedure TfrmSettings.lbRequiredAttachmentsRelTypesClick(Sender: TObject);
begin
  if lbRequiredAttachmentsRelTypes.ItemIndex=-1 then Exit;
  localcfg.getStringList('requiredAttachments-'+lbRequiredAttachmentsRelTypes.Items[lbRequiredAttachmentsRelTypes.ItemIndex], lbRequiredAttachments.Items);
end;

procedure TfrmSettings.memInstallNotesExit(Sender: TObject);
begin
  if lbReleaseTypes.ItemIndex=-1 then Exit;
  localcfg.setStringList('installNote-'+lbReleaseTypes.Items[lbReleaseTypes.ItemIndex], memInstallNotes.Lines);
end;

end.
