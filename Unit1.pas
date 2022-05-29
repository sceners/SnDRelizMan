unit Unit1;
  {$WARN UNIT_PLATFORM OFF}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Controls, Forms,
  Dialogs, ComCtrls, IniFiles, CommDlg, ShlObj, ZipForge, ActnMan,
  ExtCtrls, Buttons, Mask, StdCtrls, Menus, Graphics, ShellAPI, ImgList,
  ActnList, XPStyleActnCtrls, ActnMenus, ToolWin, ActnCtrls,
  FileCtrl, CommCtrl, UMySettings, Clipbrd, WinInet;

type
  TfrmMain = class(TForm)
    gbReleaseInfo: TGroupBox;
    Splitter1: TSplitter;
    GroupBox2: TGroupBox;
    lblAuthor: TLabel;
    edtAuthor: TComboBox;
    Label2: TLabel;
    edtOS: TComboBox;
    Label3: TLabel;
    edtName: TEdit;
    Label4: TLabel;
    DateTimePicker1: TDateTimePicker;
    Memo1: TMemo;
    btnInstallationNotes: TBitBtn;
    btnReleaseInfo: TBitBtn;
    btnNews: TBitBtn;
    btnGreetings: TBitBtn;
    btnCrew: TBitBtn;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    Label5: TLabel;
    edtURL: TEdit;
    Label6: TLabel;
    edtReleaseType: TComboBox;
    btnContact: TBitBtn;
    TabSheet3: TTabSheet;
    GroupBox3: TGroupBox;
    SaveDialog1: TSaveDialog;
    lbAttachments: TListBox;
    btnAddAttachment: TBitBtn;
    btnRemoveAttachment: TBitBtn;
    GroupBox4: TGroupBox;
    OpenDialog1: TOpenDialog;
    Splitter2: TSplitter;
    TabSheet6: TTabSheet;
    RichEdit1: TRichEdit;
    btnOSAdd: TButton;
    btnOSRemove: TButton;
    cbIncCrew: TCheckBox;
    Image2: TImage;
    TabSheet12: TTabSheet;
    GroupBox12: TGroupBox;
    Splitter5: TSplitter;
    GroupBox13: TGroupBox;
    Edit14: TEdit;
    Label39: TLabel;
    Edit15: TEdit;
    Label40: TLabel;
    MaskEdit1: TMaskEdit;
    Label41: TLabel;
    Edit16: TEdit;
    Label42: TLabel;
    Bevel1: TBevel;
    Label43: TLabel;
    Edit17: TEdit;
    Label44: TLabel;
    Edit18: TEdit;
    Label45: TLabel;
    ComboBox5: TComboBox;
    Label46: TLabel;
    MaskEdit2: TMaskEdit;
    Label47: TLabel;
    ActionMainMenuBar1: TActionMainMenuBar;
    ActionManager1: TActionManager;
    ImageList1: TImageList;
    ActionToolBar1: TActionToolBar;
    saveRelease: TAction;
    exitApplication: TAction;
    memNFO: TMemo;
    newRelease: TAction;
    settings: TAction;
    Archiver: TZipForge;
    lbStickyAttachments: TListBox;
    btnAddStickyAttachment: TBitBtn;
    btnRemoveStickyAttachment: TBitBtn;
    btnHelpStickyAttachments: TSpeedButton;
    cbIncInstallationNotes: TCheckBox;
    cbIncReleaseInfo: TCheckBox;
    cbIncNews: TCheckBox;
    cbIncGreetings: TCheckBox;
    cbIncContact: TCheckBox;
    ImageList2: TImageList;
    btnJustify: TSpeedButton;
    Label1: TLabel;
    autoUpdate: TAction;
    procedure autoUpdateExecute(Sender: TObject);
    procedure Label1Click(Sender: TObject);
//Clipboard functions
    function GetClipBoardText: string;
//---
    procedure WMHotKey(var Msg: TWMHotKey); message WM_HOTKEY;
    procedure newReleaseExecute(Sender: TObject);
    function  InformationEntered(): Boolean;
    function  RequiredAttachmentsOK(): Boolean;
    procedure edtReleaseTypeChange(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure settingsExecute(Sender: TObject);
    procedure lbStickyAttachmentsMeasureItem(Control: TWinControl;
      Index: Integer; var Height: Integer);
    procedure lbStickyAttachmentsDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure lbAttachmentsMeasureItem(Control: TWinControl; Index: Integer;
      var Height: Integer);
    procedure drawFileIcon(Name: String; canvas: TCanvas; x, y: Integer);
    procedure lbAttachmentsDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure addAttachment(s: string);
    procedure addStickyAttachment(s: string);
    procedure lbAttachmentsProc(var Msg: TMessage) ;
    procedure lbAttachmentsFileDrop(var Msg: TWMDROPFILES) ;
    procedure lbStickyAttachmentsProc(var Msg: TMessage) ;
    procedure lbStickyAttachmentsFileDrop(var Msg: TWMDROPFILES) ;
    procedure btnRemoveStickyAttachmentClick(Sender: TObject);
    procedure btnAddStickyAttachmentClick(Sender: TObject);
    procedure btnHelpStickyAttachmentsClick(Sender: TObject);
    procedure saveReleaseExecute(Sender: TObject);
    procedure exitApplicationExecute(Sender: TObject);
    procedure TabSheet2Show(Sender: TObject);
    procedure tcSettingsChange(Sender: TObject);
    procedure loadSettings;
    procedure saveSettings;
    procedure LoadText(koji: string);
    procedure SaveText(koji: string);
    function  CompileNFO: TStringList;
    function  CompileNFO2: string;
    procedure btnInstallationNotesClick(Sender: TObject);
    procedure MemoChanged;
    procedure FormCreate(Sender: TObject);
    procedure btnCrewClick(Sender: TObject);
    procedure btnAddAttachmentClick(Sender: TObject);
    procedure btnRemoveAttachmentClick(Sender: TObject);
    procedure PageControl1Change(Sender: TObject);
    procedure btnOSAddClick(Sender: TObject);
    procedure btnOSRemoveClick(Sender: TObject);
    procedure ListView1ColumnClick(Sender: TObject; Column: TListColumn);
    procedure ListView1Compare(Sender: TObject; Item1, Item2: TListItem;
      Data: Integer; var Compare: Integer);
    function fileName(): string;
    procedure btnJustifyClick(Sender: TObject);
  private
    { Private declarations }
    originalLbAttachmentsWindowProc,
    originalLbStickyAttachmentsWindowProc: TWndMethod;
    hotkeyReleaseName, hotkeyReleaseInfo, hotkeyURL: Integer;
    clipboard: TClipboard;
  public
    { Public declarations }
    cfg: TMySettings;
  end;

type TCracker = record
       name, status: string;
     end;
     TCrew = array of TCracker;


var
  frmMain: TfrmMain;
  saveToDir: string; // This is directory where all files are saved to
  CrkNotes, PrgInfo, News, Greetz, Contact: TStrings;
  CrkNotesN, PrgInfoN, NewsN, GreetzN, ContactN: TStrings;
//sluze da odreda da li treba da se radi Justify texta kad 1)s-snima ako def. 2)n-stavlja text u NFO
  Crker: TCrew;
  ColumnToSort: Integer;
  ComponentTag: Integer = 0;
  ProgPutanja: string;
  StartFolder: string; //Used for BrowseForFolder callback

function mkstr(chr: string; num: integer): string;
procedure NLBR2TStrings(s: string; sl: TStrings);
function TStrings2NLBR(sl: TStrings): string;
procedure SrediStrListu(var lista: TStrings; duz: Integer);

implementation

uses
  Unit2, UfrmSettings;


  {$R *.dfm}

function mkstr(chr: string; num: integer): string;
var
  i: Integer;
begin
  result := '';
  for i := 1 to num do result := result + chr;
end;


function BrowseForFolderCallBack(Wnd: HWND; uMsg: UINT; lParam, lpData: LPARAM): Integer stdcall;
begin
  if uMsg = BFFM_INITIALIZED then
     SendMessage(Wnd,BFFM_SETSELECTION, 1, Integer(@StartFolder[1]));
  result := 0;
end;

// Transform TShortCut to use for RegisterHotKey
// TShortCut fur RegisterHotKey umwandeln
procedure ShortCutToHotKey(HotKey: TShortCut; var Key : Word; var Modifiers: Uint);
var
  Shift: TShiftState;
begin
  ShortCutToKey(HotKey, Key, Shift);
  Modifiers := 0;
  if (ssShift in Shift) then
  Modifiers := Modifiers or MOD_SHIFT;
  if (ssAlt in Shift) then
  Modifiers := Modifiers or MOD_ALT;
  if (ssCtrl in Shift) then
  Modifiers := Modifiers or MOD_CONTROL;
end;


function BrowseForFolder(const browseTitle: String; const initialFolder: String =''): String;
var
  browse_info: TBrowseInfo;
  folder: array[0..MAX_PATH] of char;
  find_context: PItemIDList;
begin
  FillChar(browse_info, SizeOf(browse_info), #0);
  StartFolder := initialFolder;
  browse_info.pszDisplayName := @folder[0];
  browse_info.lpszTitle := PChar(browseTitle);
  browse_info.ulFlags := BIF_RETURNONLYFSDIRS or BIF_USENEWUI or $40;
  browse_info.hwndOwner := Application.Handle;

  if initialFolder <> '' then
     browse_info.lpfn := BrowseForFolderCallBack;
  find_context := SHBrowseForFolder(browse_info);
  if Assigned(find_context) then
  begin
    if SHGetPathFromIDList(find_context,folder) then
      result := folder
    else
      result := '';
    GlobalFreePtr(find_context);
  end
  else
    result := '';
end;

{*************************************************************}
{*************************************************************}

function RunProcess(const AppPath:String;  AppParams: string=''; Dir: string=''; MustWait: Boolean=FALSE;
 Visibility: Word=SW_SHOWNORMAL):DWORD;
var
 SI: TStartupInfo;
 PI: TProcessInformation;
 Proc: THandle;
 zFileName, zParams: array[0..79] of Char;
begin
 FillChar(SI, SizeOf(SI), 0);
 SI.cb := SizeOf(SI);
 SI.wShowWindow := Visibility;
 if not CreateProcess(StrPCopy(zFileName, AppPath), StrPCopy(zParams, AppParams),
  nil, nil, false, Normal_Priority_Class, nil, PChar(dir), SI, PI) then
   raise Exception.CreateFmt('Failed to execute program ' + AppPath + '. Error Code %d', [GetLastError]);

 Proc := PI.hProcess;
 CloseHandle(PI.hThread);

 if MustWait then
  if WaitForSingleObject(Proc, Infinite) <> Wait_Failed then
   GetExitCodeProcess(Proc, Result);

 CloseHandle(Proc);
end;

{*************************************************************}
{*************************************************************}

function IzbrojZnakove(ch, str: string): Integer;
//izbroji broj pojavljivanja ch u str
var
  i: Integer;
begin
  i := 0;
  while Pos(ch, str) <> 0 do begin
    i := i + 1;
    Delete(str, Pos(ch, str), 1);
  end;
  Result := i;
end;

{*************************************************************}
{*************************************************************}

procedure NLBR2TStrings(s: string; sl: TStrings);
var
  p: Integer;
begin
  sl.Clear;
  p := Pos(#13, s);
  while p<>0 do begin
    sl.Add(Copy(s, 1, p-1));
    Delete(s, 1, p);
    if s[1]=#10 then
      Delete(s, 1, 1);
    p := Pos(#13, s);
  end;
  if Length(s)<>0 then
    sl.Add(s);
end;

{*************************************************************}
{*************************************************************}

function TStrings2NLBR(sl: TStrings): string;
var
  i: Integer;
begin
  if sl.Count=0 then Exit;
  for i := 0 to sl.Count - 2 do
    Result := Result + sl.Strings[i] + #13#10;
  Result := Result + sl.Strings[sl.Count-1];
end;

{*************************************************************}
{*************************************************************}

//function DownloadFile(
//    const url: string;
//    const destinationFileName: string): boolean;
//var
//  hInet: HINTERNET;
//  hFile: HINTERNET;
//  localFile: File;
//  buffer: array[1..1024] of byte;
//  bytesRead: DWORD;
//begin
//  result := False;
//  hInet := InternetOpen(PChar(application.title),
//    INTERNET_OPEN_TYPE_PRECONFIG,nil,nil,0);
//  hFile := InternetOpenURL(hInet,PChar(url),nil,0,0,0);
//  if Assigned(hFile) then
//  begin
//    AssignFile(localFile,destinationFileName);
//    Rewrite(localFile,1);
//    repeat
//      InternetReadFile(hFile,@buffer,SizeOf(buffer),bytesRead);
//      BlockWrite(localFile,buffer,bytesRead);
//    until bytesRead = 0;
//    CloseFile(localFile);
//    result := true;
//    InternetCloseHandle(hFile);
//  end;
//  InternetCloseHandle(hInet);
//end;

function DownloadFile(
    const url: string;
    var res: string): boolean;
var
  hInet: HINTERNET;
  hFile: HINTERNET;
  buffer: array[1..1024] of Char;
  bytesRead: DWORD;
begin
  result := False;
  res := '';
  hInet := InternetOpen(PChar(application.title),
    INTERNET_OPEN_TYPE_PRECONFIG,nil,nil,0);
  hFile := InternetOpenURL(hInet,PChar(url),nil,0,0,0);
  if Assigned(hFile) then
  begin
    repeat
      InternetReadFile(hFile,@buffer,SizeOf(buffer),bytesRead);
      res := res + Copy(string(buffer), 1, bytesRead);
    until bytesRead = 0;
    result := true;
    InternetCloseHandle(hFile);
  end;
  InternetCloseHandle(hInet);
end;

{*************************************************************}
{*************************************************************}

procedure TfrmMain.drawFileIcon(Name: String; canvas: TCanvas; x, y: Integer);
var
  FileInfo: TSHFileInfo;
  ImageListHandle: THandle;
  aIcon: TIcon;
begin
  FillChar(FileInfo, SizeOf(FileInfo), #0);
  ImageListHandle := SHGetFileInfo(
    PChar(Name), 0, FileInfo, SizeOf(FileInfo),
    SHGFI_ICON or SHGFI_SMALLICON
  );
  try
    aIcon := TIcon.Create;
    aIcon.Handle := FileInfo.hIcon;
    aIcon.Transparent := True;
    Application.ProcessMessages;
    Canvas.Draw(x, y, aIcon);
    FreeAndNil(aIcon);
  finally
    DestroyIcon(FileInfo.hIcon);
    ImageList_Destroy(ImageListHandle);
  end;
end;

{*************************************************************}
{*************************************************************}

function WildComp(FileWild,FileIs: string): boolean;
var
  NameW,NameI: string;
  ExtW,ExtI: string;
  c: byte;

  function WComp(var WildS,IstS: string): boolean;
  var
    i, j, l, p : Byte;
  begin
    i := 1;
    j := 1;
    while (i<=length(WildS)) do
    begin
      if WildS[i]='*' then
      begin
        if i = length(WildS) then
        begin
          WComp := true;
          exit
        end
        else
        begin
          { we need to synchronize }
          l := i+1;
          while (l < length(WildS)) and (WildS[l+1] <> '*') do
            inc (l);
          p := pos (copy (WildS, i+1, l-i), IstS);
          if p > 0 then
          begin
            j := p-1;
          end
          else
          begin
            WComp := false;
            exit;
          end;
        end;
      end
      else
      if (WildS[i]<>'?') and ((length(IstS) < i)
	  	  or (WildS[i]<>IstS[j])) then
      begin
        WComp := false;
       	Exit
      end;

      inc (i);
      inc (j);
    end;
    WComp := (j > length(IstS));
  end;

begin
  c:=pos('.',FileWild);
  if c=0 then
  begin { automatically append .* }
    NameW := FileWild;
    ExtW  := '*';
  end
  else
  begin
    NameW := copy(FileWild,1,c-1);
    ExtW  := copy(FileWild,c+1,255);
  end;

  c:=pos('.',FileIs);
  if c=0 then
    c:=length(FileIs)+1;
  NameI := copy(FileIs,1,c-1);
  ExtI  := copy(FileIs,c+1,255);
  WildComp := WComp(NameW,NameI) and WComp(ExtW,ExtI);
end;

{*************************************************************}
{*************************************************************}

function TfrmMain.GetClipBoardText: string;
var
  Data: THandle;
begin
  clipboard.Open;
  Data := GetClipboardData(CF_TEXT);
  try
    if Data <> 0 then
      Result := PChar(GlobalLock(Data))
    else
      Result := '';
  finally
    if Data <> 0 then GlobalUnlock(Data);
    clipboard.Close;
  end;
end;

{*************************************************************}
{*************************************************************}

procedure TfrmMain.WMHotKey(var Msg: TWMHotKey);
begin
  if Msg.HotKey = hotkeyReleaseName then edtName.Text := GetClipBoardText()
  else if Msg.HotKey = hotkeyURL then edtURL.Text := GetClipBoardText()
  else if Msg.HotKey = hotkeyReleaseInfo then begin
    NLBR2TStrings(GetClipBoardText, PrgInfoN);
    if GroupBox2.Tag=2 then begin
      Memo1.Clear;
      Memo1.Lines.AddStrings(PrgInfoN);
    end;
  end;
end;

{*************************************************************}
{*************************************************************}

function TfrmMain.InformationEntered(): Boolean;
begin
  Result := False;
  edtAuthor.Text := Trim(edtAuthor.Text);
  edtName.Text := Trim(edtName.Text);
  edtOS.Text := Trim(edtOS.Text);
  edtURL.Text := Trim(edtURL.Text);
  if (edtAuthor.Text='') or (edtOS.Text='') or (edtName.Text='') or (edtURL.Text='') then begin
    MessageBox(Handle, 'You didn''t enter all required information.'#13'(author, release name, url, OS)', 'Error', MB_OK or MB_ICONERROR);
    Exit;
  end;
  Result := True;  
end;

procedure TfrmMain.Label1Click(Sender: TObject);
begin
  MessageBox(Handle,
              'Now you can quickly paste release name and URL to Release Packer.'#13'Global hotkeys are added so while you''re in readme.txt'#13'or other file, you can copy text you want and paste directly to:'#13#13'Ctrl+Q: Release name'#13'Ctrl+W: URL'#13'Ctrl+E: Release info',
              'Help',
              MB_OK or MB_ICONINFORMATION);
end;

{*************************************************************}
{*************************************************************}

function TfrmMain.RequiredAttachmentsOK(): Boolean;
var
  required: TStrings;
  i, j: Integer;
  ok: Boolean;
begin
  Result := False;
  if edtReleaseType.Text='' then begin
    MessageBox(Handle, 'You have to choose release type.', 'Information', MB_OK or MB_ICONINFORMATION);
    Exit;
  end;
  required := cfg.getStringList('requiredAttachments-'+edtReleaseType.Text);
  ok := False;
  for i := 0 to required.Count - 1 do begin
    for j := 0 to lbAttachments.Items.Count - 1 do
      if WildComp(required[i], ExtractFileName(lbAttachments.Items[j])) then
        ok := True;
//    for j := 0 to lbStickyAttachments.Items.Count - 1 do
//      if WildComp(required[i], lbStickyAttachments.Items[j]) then
//        ok := True;
    if not ok then begin
      if MessageBox(Handle, PChar('This release type requires some attachments.'#13'Following wildcard didn''t match any files: '#13 + required[i] + #13#13'Continue?'), 'Warning', MB_YESNO or MB_ICONWARNING)=mrNo then Exit;
    end;
  end;
  Result := True;
end;

{*************************************************************}
{*************************************************************}

procedure TfrmMain.addAttachment(s: string);
begin
  if lbAttachments.Items.IndexOf(s)=-1 then
    if lbStickyAttachments.Items.IndexOf(s)=-1 then
      lbAttachments.Items.Add(s)
    else
      MessageBox(handle, PChar('File ' + ExtractFileName(s) + ' is already a sticky attachment!'), 'Information', MB_OK or MB_ICONINFORMATION);
end;

{*************************************************************}
{*************************************************************}

procedure TfrmMain.addStickyAttachment(s: string);
begin
  if lbStickyAttachments.Items.IndexOf(s)=-1 then
    if lbAttachments.Items.IndexOf(s)=-1 then
      lbStickyAttachments.Items.Add(s)
    else
      MessageBox(handle, PChar('File ' + ExtractFileName(s) + ' is already a regular attachment!'), 'Information', MB_OK or MB_ICONINFORMATION);
end;

{*************************************************************}
{*************************************************************}
            
procedure TfrmMain.autoUpdateExecute(Sender: TObject);
begin
  
end;

{*************************************************************}
{*************************************************************}

procedure SrediStrListu(var lista: TStrings; duz: Integer);
//ova procedura radi JUSTIFY za listu
//duzina reda u novoj listi je duz
var
  pom, pom2: string;
  i, j, k: Integer;
begin
  if lista.Count = 0 then Exit;
  pom := '';
  for i := 0 to lista.Count - 1 do pom := pom + lista.Strings[i] + ' ';
  //izbrisi sve ' ' sa kraja
  while pom[Length(pom)] = ' ' do Delete(pom, Length(pom), 1);
  lista.Clear;
  //uzmi jednu rec
  pom2 := Copy(pom, 1, Pos(' ', pom) - 1); // -1 da bi uzeo bez ' '
  Delete(pom, 1, Pos(' ', pom));
  //dodaj u listu
  i := lista.Add(pom2);
  while Pos(' ', pom) > 0 do begin
    //izbrisi ' '
    pom := Trim(pom);
    pom2 := Copy(pom, 1, Pos(' ', pom) - 1);
    Delete(pom, 1, Pos(' ', pom));
    //ako je ukupno veci od max duzine napravi novi red
    if (Length(pom2) + Length(lista.Strings[i]) + 1) > duz then i := lista.Add(pom2)
    //ako ne dodaj na stari
    else lista.Strings[i] := lista.Strings[i] + ' ' + pom2;
  end;
  //dodaj na kraj preostalo
  if (Length(pom) + Length(lista.Strings[i]) + 1) > duz then lista.Add(pom)
  else lista.Strings[i] := lista.Strings[i] + ' ' + pom;
  //JUSTIFY
  for i := 0 to lista.Count - 2 do begin //-2 da ne bi sredjivao poslednji red
  //stavi trenutni red u pom
    pom := lista.Strings[i];
    //ako nije ceo red jedna rec ubaci ' 'ove
    if Pos(' ', pom) <> 0 then begin
      //j := broj potrebnih ' '
      j := duz - Length(pom);
      //dodaj ' 'ove
      k := 0;
      while j > 0 do begin
        if pom[k] = ' ' then begin
          Insert(' ', pom, k);
          k := k + 1;
          j := j - 1;
        end;
        k := k + 1;
        if k = Length(pom) then k := 0;
      end;
      lista.Strings[i] := pom;
    end;
  end;
  for i := Length(lista.Strings[lista.Count - 1]) to duz - 1 do lista.Strings[lista.Count - 1] := lista.Strings[lista.Count - 1] + ' ';
end;

{*************************************************************}
{*************************************************************}

procedure TfrmMain.loadSettings;
var
  l1, l2: TStrings;
  i: Integer;
begin
  if not cfg.loadSettings() then
    MessageBoxA(Handle, 'Can''t load settings!', 'Error', MB_OK or MB_ICONERROR);
//Texts
  cfg.getStringList('stickyAttachments', lbStickyAttachments.Items);
  cfg.getStringList('installNotes', CrkNotes);
  cfg.getStringList('releaseInfo', PrgInfo);
  cfg.getStringList('news', News);
  cfg.getStringList('greetings', Greetz);
  cfg.getStringList('contact', Contact);
  CrkNotesN.Clear;
  CrkNotesN.AddStrings(CrkNotes);
  PrgInfoN.Clear;
  PrgInfoN.AddStrings(PrgInfo);
  NewsN.AddStrings(News);
  GreetzN.AddStrings(Greetz);
  ContactN.AddStrings(Contact);
//Misc
  cfg.getStringList('OSes', edtOS.Items);
  saveToDir := cfg.getString('saveToDir');
//Crew
  l1 := cfg.getStringList('crewNames'); l2 := cfg.getStringList('crewTitles');
  if (l1.Count <> l2.Count) then
    MessageBox(Handle, 'Couldn''t load crew members data!', 'Error', MB_OK or MB_ICONERROR)
  else begin
    SetLength(Crker, l1.Count);
    for i := 0 to l1.Count - 1 do begin
      Crker[i].name := l1.Strings[i];
      Crker[i].status := l2.Strings[i];
    end;
    edtAuthor.Clear;
    edtAuthor.Items.AddStrings(l1);
  end;
  l1.Free; l2.Free;
//Window settings
//WindowPos
  with cfg do begin
    frmMain.Top := getInt('frmMain.Top');
    frmMain.Left := getInt('frmMain.Left');
    frmMain.Height := getInt('frmMain.Height');
    frmMain.Width := getInt('frmMain.Width');
//GroupBox dimensions
    gbReleaseInfo.Width := getInt('gbReleaseInfo.Width');
    gbReleaseInfo.Height := getInt('gbReleaseInfo.Height');
//Include in NFO
    cbIncInstallationNotes.Checked := getBool('cbIncInstallationNotes.Checked');
    cbIncCrew.Checked := getBool('cbIncCrew.Checked');
    cbIncReleaseInfo.Checked := getBool('cbIncReleaseInfo.Checked');
    cbIncGreetings.Checked := getBool('cbIncGreetings.Checked');
    cbIncContact.Checked := getBool('cbIncContact.Checked');
    cbIncNews.Checked := getBool('cbIncNews.Checked');
//History
    edtAuthor.Text := getString('edtAuthor');
    edtOS.Text := getString('edtOS');
  end;

end;

{*************************************************************}
{*************************************************************}

procedure TfrmMain.saveSettings;
var
  l1, l2: TStrings;
  i: Integer;
begin
  cfg.setStringList('stickyAttachments', lbStickyAttachments.Items);
  MemoChanged();
//Texts
  cfg.setStringList('installNotes', CrkNotesN);
  cfg.setStringList('releaseInfo', PrgInfoN);
  cfg.setStringList('news', NewsN);
  cfg.setStringList('greetings', GreetzN);
  cfg.setStringList('contact', ContactN);
//Misc
  cfg.setStringList('OSes', edtOS.Items);
  cfg.setString('saveToDir', saveToDir);
//Crew
  l1 := TStringList.Create; l2 := TStringList.Create;
  for i := 0 to Length(Crker) - 1 do begin
    l1.Add(Crker[i].name);
    l2.Add(Crker[i].status);
  end;
  cfg.setStringList('crewNames', l1); cfg.setStringList('crewTitles', l2);
  l1.Free; l2.Free;
//Window settings
//WindowPos
  cfg.setInt('frmMain.Top', frmMain.Top);
  cfg.setInt('frmMain.Left', frmMain.Left);
  cfg.setInt('frmMain.Height', frmMain.Height);
  cfg.setInt('frmMain.Width', frmMain.Width);
//GroupBox dimensions
  cfg.setInt('gbReleaseInfo.Width', gbReleaseInfo.Width);
  cfg.setInt('gbReleaseInfo.Height', gbReleaseInfo.Height);
//Include in NFO
  cfg.setBool('cbIncInstallationNotes.Checked', cbIncInstallationNotes.Checked);
  cfg.setBool('cbIncCrew.Checked', cbIncCrew.Checked);
  cfg.setBool('cbIncReleaseInfo.Checked', cbIncReleaseInfo.Checked);
  cfg.setBool('cbIncGreetings.Checked', cbIncGreetings.Checked);
  cfg.setBool('cbIncContact.Checked', cbIncContact.Checked);
  cfg.setBool('cbIncNews.Checked', cbIncNews.Checked);
//History
  cfg.setString('edtAuthor', edtAuthor.Text);
  cfg.setString('edtOS', edtOS.Text);
//----------------------
  if not cfg.saveSettings() then
    MessageBoxA(Handle, 'Can''t save settings!', 'Error', MB_OK or MB_ICONERROR);
end;

{*************************************************************}
{*************************************************************}

procedure TfrmMain.LoadText(koji: string);
//ucitava text koji je zadnji bio kad su ovi podaci bili menjani
//npr. ako je bio Crack notes pa ga izmenis pa promenis na
//Greetz pa se vratis na CrackNotes onda vrati text onakav
//kako si ga izmenio
begin
  if koji = 'crknts' then begin
    Memo1.Clear;
    Memo1.Lines.AddStrings(CrkNotesN); end
  else if koji = 'prginfo' then begin
    Memo1.Clear;
    Memo1.Lines.AddStrings(PrgInfoN); end
  else if koji = 'news' then begin
    Memo1.Clear;
    Memo1.Lines.AddStrings(NewsN); end
  else if koji = 'greetz' then begin
    Memo1.Clear;
    Memo1.Lines.AddStrings(GreetzN); end
  else if koji = 'contact' then begin
    Memo1.Clear;
    Memo1.Lines.AddStrings(ContactN); end;
end;

{*************************************************************}
{*************************************************************}

procedure TfrmMain.SaveText(koji: string);
//snima text u listu. pogledaj gore
begin
  if koji = 'crknts' then begin
    CrkNotesN.Clear;
    CrkNotesN.AddStrings(Memo1.Lines); end
  else if koji = 'prginfo' then begin
    PrgInfoN.Clear;
    PrgInfoN.AddStrings(Memo1.Lines); end
  else if koji = 'news' then begin
     NewsN.Clear;
     NewsN.AddStrings(Memo1.Lines); end
  else if koji = 'greetz' then begin
    GreetzN.Clear;
    GreetzN.AddStrings(Memo1.Lines); end
  else if koji = 'contact' then begin
    ContactN.Clear;
    ContactN.AddStrings(Memo1.Lines); end;
end;

procedure TfrmMain.settingsExecute(Sender: TObject);
begin
  frmSettings.ShowModal;
end;

{*************************************************************}
{*************************************************************}

function TfrmMain.CompileNFO(): TStringList;
//Sastavlja NFO od datih podatake
var
  str, pom: string;
  i, j: Integer;
  rezultat: TStringList;
begin
  rezultat := TStringList.Create;
//Zaglavlje
  with rezultat do begin
    Clear;
    Add('    ∞∞        .               ﬂ€≤∞≤€ﬂ       ˙             .');
    Add('   ∞  .               ˙        ﬂ€≤∞≤€                          ˙       ‹‹‹');
    Add('  ∞                            . €≤∞≤€ ‹‹                           ‹€€ﬂﬂﬂﬂﬂ‹');
    Add(' ∞            ˙         ˙         €≤∞≤€≤≤≤≤‹         ˙             €€≤');
    Add(' ∞    ˙            .            ‹‹±€≤±±±≤±≤≤›                     ﬁ€€›  ˙');
    Add('∞         .                    ﬁ≤≤±±∞∞∞∞ ±±≤€                 ˙   ﬁ€€›     .');
    Add('∞             ‹‹‹‹‹‹‹‹‹‹‹‹     €≤±±∞∞ ‹≤‹±≤≤ﬂ  .    ‹‹‹‹‹‹‹‹‹‹‹‹   ≤€€');
    Add('  ˙           ›          ﬁ      ﬂ±±±∞€≤±± ≤‹        ›          ﬁ    ﬂ≤≤‹‹‹‹‹ﬂ');
    Add('              › ∞˛˛∞∞∞∞˛ ﬁ‹‹‹‹‹  ‹≤≤±∞ﬂ≤‹∞∞≤≤‹±≤‹   › ˛∞∞∞∞˛˛∞ ﬁ       ﬂﬂﬂ');
    Add('   .       ˙  › ˛˛∞∞˛˛˛∞ ﬁﬁ     €≤±∞∞±∞∞∞ ∞‹∞±±±≤€  › ∞˛˛˛∞∞˛˛ ﬁ  ˙');
    Add('              › ˛∞∞∞˛∞∞∞ ﬁﬁ ˛˛∞ €≤±±∞∞‹≤≤‹∞∞∞∞≤≤≤ﬂ  › ∞∞∞˛∞∞∞˛ ﬁ              ˙');
    Add('˙  ‹‹‹‹‹‹‹‹‹‹ › ˛˛˛∞∞˛˛˛ ﬁﬁ ˛∞˛˛ ﬂ±≤±€≤≤±±∞ ∞‹‹ﬂ±≤‹   ˛˛˛∞∞˛˛˛ ﬁ ‹‹‹‹‹‹‹‹‹‹');
    Add('   ﬁ        › ›  ˛∞∞˛˛∞∞ ﬁﬁ ∞˛∞∞∞  ﬂﬂ €≤≤±±∞∞∞∞∞±±≤€  ∞∞˛˛∞∞˛∞ ﬁ ﬁ        ›');
    Add('   ﬁ ˛∞∞˛∞˛ › › ˛˛˛ ∞∞∞˛ ﬁﬁ ˛˛˛˛∞∞˛∞∞  €≤≤≤±∞∞∞‹‹±≤≤› ˛∞∞∞∞˛˛˛ ﬁ ﬁ ˛∞˛∞∞˛ ›   .');
    Add('   ﬁ ∞˛∞˛∞∞ › › ˛  ˛ ˛∞˛ ﬁﬁ  ˛∞˛˛∞˛∞∞∞  ﬂ≤‹‹∞∞∞±ﬁ≤≤€ﬁ‹  ˛ ˛∞∞˛ ﬁ ﬁ ∞∞˛∞˛∞ ›');
    Add('‹‹‹ﬁ ˛˛˛∞∞˛ › › ˛ ˛ ˛˛∞˛ ﬁﬁ ˛ ˛˛˛˛ ∞˛∞  ‹≤≤≤ﬂ∞∞∞ €ﬂ∞±≤€  ˛ ˛∞˛ ﬁ ﬁ ˛∞∞˛˛˛ ›‹‹‹‹');
    Add('   ﬁ ∞˛∞∞∞∞ › ›  ˛ ˛  ˛∞ ﬁﬁ ˛˛˛     ∞∞ €≤≤±±±∞‹‹∞≤≤±±≤≤€  ˛ ˛ ‹‹≤› ∞∞∞∞˛∞ ›');
    Add('˛∞ ﬁ ˛∞∞∞∞˛ › › ˛˛˛   ∞˛ ﬁﬁ  ˛˛  ˛˛  ˛  ﬂ≤≤±±∞∞    ‹‹≤≤€€‹‹‹≤≤≤≤€ﬁ ˛ ∞∞∞˛ › ˛˛∞');
    Add('˛∞ ﬁ  ˛ ˛∞∞ › ›  ˛˛ ˛  ∞ ﬁﬁ ˛˛˛      ∞∞∞  ﬂﬂ±‹≤ ‹ﬂﬂ   ﬂ≤€€ﬂ≤≤≤€€›ﬁ   ˛ ˛∞ › ∞˛˛');
    Add(' ∞ ﬁ      ∞ ﬂﬂﬂ ˛   ˛ ˛˛  ﬁ  ˛ ˛  ‹‹‹  ˛∞∞∞    ﬁ›       ≤€€ ﬂ≤€€   ˛ ˛˛ ∞ › ˛ ∞');
    Add('˛˛ ﬁ hX!  ‹‹‹ ≤  ˛ ˛  ˛∞  ﬁ ˛ ˛   ﬁ€€› ∞∞   ‹‹≤≤≤€       ﬂ€€  ﬂ‹   ˛  ˛ ˛ › ˛ ˛');
    Add('         €€  ﬂ€                   ﬁ€€     ﬂ€≤≤≤≤€€€        ﬂ›   ﬂ‹');
    Add('∞∞∞∞∞∞∞∞ ﬁ€› ‹‹‹‹ ∞ ‹‹‹ ∞∞  ‹‹‹ ∞  €≤‹‹‹ ∞  ﬂﬂ≤≤≤€€€           ≤‹ ﬂ‹ ∞∞∞∞∞∞∞∞∞∞');
    Add('∞∞∞∞∞     ﬂ€€ﬂﬂ€€› €ﬂﬂ≤›∞  €ﬂﬂ≤›∞∞ €€ﬂﬂ≤› ∞∞∞   ﬂﬂ€€€    ≤  ≤‹‹‹≤‹  ﬂ‹ ∞∞∞∞∞∞∞∞');
    Add('∞∞∞  ‹€€€€€€€‹ ﬁ€€ﬁ€› € ‹‹€€› € ‹‹‹€› ﬁ€‹  ∞∞∞∞∞    ﬂ€    ﬂ  ≤‹  ≤‹   ﬂ‹ ∞∞∞∞∞∞');
    Add('∞∞  ﬂ  ﬂ≤≤≤€≤€›ﬁ≤≤ ≤≤ﬂﬁ≤≤≤›≤≤ﬂﬁ≤≤≤›≤≤‹ﬂﬂ≤≤ ∞∞∞∞∞ ˛ ∞  €       ≤‹  ‹‹‹‹‹≤≤‹ ∞∞∞∞');
    Add('∞∞ ﬂ ∞∞ €€€€€€›€€€›ﬁ€› €€€ ﬁ€› €€€ﬁ€€   ﬁ€› ∞∞∞∞∞ ﬂ ∞  €      ‹‹€≤≤≤≤€€€€€€‹ ∞∞');
    Add('∞∞∞ ˛ ∞ﬁ€€€€€€‹€€€€ ≤€‹‹€€  ≤€‹‹€€ﬁ€€ ∞ €€€‹  ∞∞∞ ‹ ∞∞  €   ‹≤≤≤≤≤€€€€€€€€€€€ ∞');
    Add('∞∞∞∞ ∞ ﬂﬂﬂ      ﬂﬂﬂ‹ﬂﬂ   ﬂﬂ‹ﬂﬂ   ﬂ≤€ﬂﬂ ‹€€€€€‹   ‹  ∞∞∞  € €≤≤≤≤≤€€€€€€€€€€€€›');
    Add('∞∞∞∞∞∞∞∞∞∞    ∞∞∞∞    ∞∞∞∞    ∞∞∞          ﬂﬂﬂﬂﬂﬂ  ∞∞∞∞∞  €≤≤≤≤≤€€€€€€€€€€€€€€');
    Add('∞∞∞∞∞∞∞∞∞∞ ∞∞ ∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞ ∞∞ ∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞ ﬂ€≤≤≤≤€€€€€€€€€€€€€›');
    Add('           ±±                         ±±                     ﬂ€≤≤≤≤€€€€€€€€€€€›');
    Add('∞∞∞∞∞∞∞∞∞∞ ≤≤ ∞∞∞∞∞∞∞∞∞∞∞∞  ‹≤≤ ∞∞∞∞∞ ≤≤ ∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞  ﬂﬂ€≤≤≤€€€€€€€€€');
    Add('±±±±±±±±±± €€ ±±±±±±±±±±±  €≤ﬂ  ±±±±± €€ ±±±±±±±±±±±±±±±±±±±±±±±   ﬂﬂﬂﬂ≤≤≤≤≤ﬂ');
    Add('∞          €€             €€          €€      ∞∞');
    Add('∞ €€€€€€€≤ €€ ≤€€€€€€€€€€ €€€€€€€€€€≤±≤€€≤ ≤≤   ‹‹€€€≤ ≤≤€€€€€€€€€ €€€≤  ∞∞ ≤≤');
    Add('∞ ≤€       €€ €€       ≤€          ≤€ €€   €€ ‹€ﬂﬂ  €€ ‹‹       ≤€ €≤    ∞∞ €€');
    Add('±  €€  ±±± €€ €€ ±±±± ≤€  ≤≤ ±±±  ≤€  €€ ± €€€≤   ± ≤≤ €€ ±±±  ≤€   €≤  ±±± €€');
    Add('∞∞  €€  ∞∞ €€ €€ ∞∞  €€   €€ ∞∞  €€ ∞ €€ ∞ €€≤  ∞∞∞    €€ ∞∞  €€ ∞∞  €€  ∞∞ €€');
    Add('     ﬂ€‹‹  €€ €€  ‹‹€ﬂ    €€  ‹‹€ﬂ    €€   €€          €€  ‹‹€ﬂ       ﬂ€‹‹  €€');
    Add('∞∞∞∞∞  ﬂﬂ€€€≤ ≤€€€€€€€€€≤ ≤€€€ﬂﬂ  ∞∞∞ ≤€€≤ ≤€ ∞∞∞∞∞∞∞∞ ≤€€€ﬂﬂ  ∞∞∞∞∞∞∞  ﬂﬂ€€€€');
    Add('                                                                            €€');
    Add('                                                                            €€');
    Add('∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞ ≤≤');
    Add('                                                                            ±±');

    pom := '';
    for i := 1 to ((76-Length(edtName.Text)) div 2) do pom := pom + ' ';
    pom := pom + edtName.Text;
    for i := 1 to 76-Length(pom) do pom := pom + ' ';
    pom := pom + '∞∞';
    Add(pom);
//    Add('       infofile designed by haliphax of remorse productions (c) 1981        ∞∞');

    Add('');
    Add('‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹');
    Add('±±±±±±±±±±±±±±∞∞±±±∞∞±±∞∞±∞∞∞±∞∞∞∞∞ ±∞∞∞∞∞∞∞ ∞∞∞ ∞∞ ∞  ∞   ∞      ∞         ∞');
    Add('±±±±±±±±±±±±±   ±±∞∞±±∞∞    ±∞∞∞    ∞∞∞∞∞∞∞∞ ∞∞∞ ∞€ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ€');
    Add('±±±±±±±±± ‹‹‹ ≤ ±∞    ∞± ‹‹      ‹‹ ∞∞∞∞∞∞∞∞ ∞∞∞ ∞€   release information   €±±');
    Add('±±±±±±±± €€  ﬂ€ ∞∞ ﬂ€‹‹   €€€€ﬂ ≤≤€‹ ∞∞∞∞∞∞∞ ∞∞∞ ∞€‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹€±±');
    Add('±±±±±±±± ﬁ€› ‹‹‹‹ ± ﬁ€€€‹ﬁ≤€€€  ﬁ€€€≤ ∞∞∞∞∞∞ ∞∞∞ ∞∞ ±±±±±±±±±±±±±±±±±±±±±±±±±±±');
    Add('±±±±±     ﬂ€€ﬂﬂ€€›∞∞ €€ﬂ€›≤€€› ±ﬁ€≤ﬂ€€‹ ∞∞∞∞ ∞∞∞ ∞∞ ∞  ∞   ∞      ∞         ∞');
    Add('±±±  ‹€€€€€€€‹ ﬁ€€ ± €€›ﬁ€‹€€›±±ﬁ€€› ﬂ≤€‹ ±± ±±± ±± ±  ±   ±      ±         ±');
    Add('‹‹  ﬂ  ﬂ≤≤≤€≤€›ﬁ≤≤ ‹ ≤≤› ≤≤≤≤›‹ ≤≤≤›‹‹ ﬁ€€ ‹‹‹‹‹‹‹‹‹ ‹‹‹‹‹‹‹‹‹ ‹‹‹‹ ‹‹‹ ‹‹ ‹  ‹');
    Add('   ﬂ    €€€€€€›€€€› ﬁ€€€ ﬁ€€€€  €€€     ≤€›');
    Add('±±± ˛ ∞ﬁ€€€€€€‹€€€€ €€€€‹ €€€€›ﬁ€€€‹‹‹‹≤€ﬂ ∞ ∞∞∞ ∞∞ ∞  ∞   ∞      ∞         ∞');
    Add('±±±± ∞ ﬂﬂﬂ      ﬂﬂﬂ‹ﬂﬂﬂ  ﬂﬂﬂ≤≤≤ﬂﬂﬂﬂﬂﬂﬂﬂ   ∞∞ ∞∞∞ ∞∞ ∞  ∞   ∞      ∞         ∞');
    Add('±±±∞∞±±±∞∞±±∞∞±∞     ∞∞∞±∞∞     ∞∞∞ ∞∞∞∞∞∞∞∞ ∞∞∞ ∞∞ ∞  ∞   ∞      ∞         ∞');
    Add('±±∞∞±±±∞∞±±∞∞±∞∞∞±∞∞∞∞∞±∞∞∞∞∞∞∞∞∞∞∞ ∞∞∞∞∞∞∞∞ ∞∞∞ ∞∞ ∞  ∞   ∞      ∞         ∞');
    Add('ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ');
    Add('');

    Add('     Program name ' + mkstr('.', 56-Length(edtName.Text)-1) + ' ' + edtName.Text);
    Add('     Rls type ' + mkstr('.', 60-Length(edtReleaseType.Text)-1) + ' ' + edtReleaseType.Text);
    Add('     Releaser ' + mkstr('.', 60-Length(edtAuthor.Text)-1) + ' ' + edtAuthor.Text);
    Add('     URL ' + mkstr('.', 65-Length(edtURL.Text)-1) + ' ' + edtURL.Text);
    str := FormatDateTime('yyyy mm dd', DateTimePicker1.DateTime);
    Add('     Date ' + mkstr('.', 64-Length(str)-1) + ' ' + str);
    Add('     OS ' + mkstr('.', 66-Length(edtOS.Text)-1) + ' ' + edtOS.Text);
    //rlser

//    pom := '     Releaser ' + mkstr('.', 24-Length(edtAuthor.Text)-1) + ' ' + edtAuthor.Text;
    //rel type
//    pom := pom + '   Rls type ' + mkstr('.', 24-Length(edtReleaseType.Text)-1) + ' ' + edtReleaseType.Text;
//    Add(pom);
    //Date
//    str := FormatDateTime('yyyy mm dd', DateTimePicker1.DateTime);
//    pom := '     Date ' + mkstr('.', 28-Length(str)-1) + ' ' + str;
    //OS
//    pom := pom + '   OS ' + mkstr('.', 30-Length(edtOS.Text)-1) + ' ' + edtOS.Text;
//    Add(pom);
    Add('');
  if cbIncReleaseInfo.Checked then begin
    Add('');
    Add('‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹');
    Add('±±±±±±±±±±±±±±∞∞±±±∞∞±±∞∞±∞∞∞±∞∞∞∞∞ ±∞∞∞∞∞∞∞ ∞∞∞ ∞∞ ∞  ∞   ∞      ∞         ∞');
    Add('±±±±±±±±±±±±±   ±±∞∞±±∞∞    ±∞∞∞    ∞∞∞∞∞∞∞∞ ∞∞∞ ∞€ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ€');
    Add('±±±±±±±±± ‹‹‹ ≤ ±∞    ∞± ‹‹      ‹‹ ∞∞∞∞∞∞∞∞ ∞∞∞ ∞€      release notes      €±±');
    Add('±±±±±±±± €€  ﬂ€ ∞∞ ﬂ€‹‹   €€€€ﬂ ≤≤€‹ ∞∞∞∞∞∞∞ ∞∞∞ ∞€‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹€±±');
    Add('±±±±±±±± ﬁ€› ‹‹‹‹ ± ﬁ€€€‹ﬁ≤€€€  ﬁ€€€≤ ∞∞∞∞∞∞ ∞∞∞ ∞∞ ±±±±±±±±±±±±±±±±±±±±±±±±±±±');
    Add('±±±±±     ﬂ€€ﬂﬂ€€›∞∞ €€ﬂ€›≤€€› ±ﬁ€≤ﬂ€€‹ ∞∞∞∞ ∞∞∞ ∞∞ ∞  ∞   ∞      ∞         ∞');
    Add('±±±  ‹€€€€€€€‹ ﬁ€€ ± €€›ﬁ€‹€€›±±ﬁ€€› ﬂ≤€‹ ±± ±±± ±± ±  ±   ±      ±         ±');
    Add('‹‹  ﬂ  ﬂ≤≤≤€≤€›ﬁ≤≤ ‹ ≤≤› ≤≤≤≤›‹ ≤≤≤›‹‹ ﬁ€€ ‹‹‹‹‹‹‹‹‹ ‹‹‹‹‹‹‹‹‹ ‹‹‹‹ ‹‹‹ ‹‹ ‹  ‹');
    Add('   ﬂ    €€€€€€›€€€› ﬁ€€€ ﬁ€€€€  €€€     ≤€›');
    Add('±±± ˛ ∞ﬁ€€€€€€‹€€€€ €€€€‹ €€€€›ﬁ€€€‹‹‹‹≤€ﬂ ∞ ∞∞∞ ∞∞ ∞  ∞   ∞      ∞         ∞');
    Add('±±±± ∞ ﬂﬂﬂ      ﬂﬂﬂ‹ﬂﬂﬂ  ﬂﬂﬂ≤≤≤ﬂﬂﬂﬂﬂﬂﬂﬂ   ∞∞ ∞∞∞ ∞∞ ∞  ∞   ∞      ∞         ∞');
    Add('±±±∞∞±±±∞∞±±∞∞±∞     ∞∞∞±∞∞     ∞∞∞ ∞∞∞∞∞∞∞∞ ∞∞∞ ∞∞ ∞  ∞   ∞      ∞         ∞');
    Add('±±∞∞±±±∞∞±±∞∞±∞∞∞±∞∞∞∞∞±∞∞∞∞∞∞∞∞∞∞∞ ∞∞∞∞∞∞∞∞ ∞∞∞ ∞∞ ∞  ∞   ∞      ∞         ∞');
    Add('ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ');
    Add('');
    for i := 0 to PrgInfoN.Count-1 do Add('     '+PrgInfoN.Strings[i]);
    Add('');
  end;

  if cbIncInstallationNotes.Checked then begin
    Add('');
    Add('‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹');
    Add('±±±±±±±±±±±±±±∞∞±±±∞∞±±∞∞±∞∞∞±∞∞∞∞∞ ±∞∞∞∞∞∞∞ ∞∞∞ ∞∞ ∞  ∞   ∞      ∞         ∞');
    Add('±±±±±±±±±±±±±   ±±∞∞±±∞∞    ±∞∞∞    ∞∞∞∞∞∞∞∞ ∞∞∞ ∞€ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ€');
    Add('±±±±±±±±± ‹‹‹ ≤ ±∞    ∞± ‹‹      ‹‹ ∞∞∞∞∞∞∞∞ ∞∞∞ ∞€      install notes      €±±');
    Add('±±±±±±±± €€  ﬂ€ ∞∞ ﬂ€‹‹   €€€€ﬂ ≤≤€‹ ∞∞∞∞∞∞∞ ∞∞∞ ∞€‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹€±±');
    Add('±±±±±±±± ﬁ€› ‹‹‹‹ ± ﬁ€€€‹ﬁ≤€€€  ﬁ€€€≤ ∞∞∞∞∞∞ ∞∞∞ ∞∞ ±±±±±±±±±±±±±±±±±±±±±±±±±±±');
    Add('±±±±±     ﬂ€€ﬂﬂ€€›∞∞ €€ﬂ€›≤€€› ±ﬁ€≤ﬂ€€‹ ∞∞∞∞ ∞∞∞ ∞∞ ∞  ∞   ∞      ∞         ∞');
    Add('±±±  ‹€€€€€€€‹ ﬁ€€ ± €€›ﬁ€‹€€›±±ﬁ€€› ﬂ≤€‹ ±± ±±± ±± ±  ±   ±      ±         ±');
    Add('‹‹  ﬂ  ﬂ≤≤≤€≤€›ﬁ≤≤ ‹ ≤≤› ≤≤≤≤›‹ ≤≤≤›‹‹ ﬁ€€ ‹‹‹‹‹‹‹‹‹ ‹‹‹‹‹‹‹‹‹ ‹‹‹‹ ‹‹‹ ‹‹ ‹  ‹');
    Add('   ﬂ    €€€€€€›€€€› ﬁ€€€ ﬁ€€€€  €€€     ≤€›');
    Add('±±± ˛ ∞ﬁ€€€€€€‹€€€€ €€€€‹ €€€€›ﬁ€€€‹‹‹‹≤€ﬂ ∞ ∞∞∞ ∞∞ ∞  ∞   ∞      ∞         ∞');
    Add('±±±± ∞ ﬂﬂﬂ      ﬂﬂﬂ‹ﬂﬂﬂ  ﬂﬂﬂ≤≤≤ﬂﬂﬂﬂﬂﬂﬂﬂ   ∞∞ ∞∞∞ ∞∞ ∞  ∞   ∞      ∞         ∞');
    Add('±±±∞∞±±±∞∞±±∞∞±∞     ∞∞∞±∞∞     ∞∞∞ ∞∞∞∞∞∞∞∞ ∞∞∞ ∞∞ ∞  ∞   ∞      ∞         ∞');
    Add('±±∞∞±±±∞∞±±∞∞±∞∞∞±∞∞∞∞∞±∞∞∞∞∞∞∞∞∞∞∞ ∞∞∞∞∞∞∞∞ ∞∞∞ ∞∞ ∞  ∞   ∞      ∞         ∞');
    Add('ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ');
    Add('');
    for i := 0 to CrkNotesN.Count-1 do Add('     '+CrkNotesN.Strings[i]);
    Add('');
  end;

  if cbIncCrew.Checked then begin
    Add('');
    Add('‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹');
    Add('±±±±±±±±±±±±±±∞∞±±±∞∞±±∞∞±∞∞∞±∞∞∞∞∞ ±∞∞∞∞∞∞∞ ∞∞∞ ∞∞ ∞  ∞   ∞      ∞         ∞');
    Add('±±±±±±±±±±±±±   ±±∞∞±±∞∞    ±∞∞∞    ∞∞∞∞∞∞∞∞ ∞∞∞ ∞€ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ€');
    Add('±±±±±±±±± ‹‹‹ ≤ ±∞    ∞± ‹‹      ‹‹ ∞∞∞∞∞∞∞∞ ∞∞∞ ∞€           crew          €±±');
    Add('±±±±±±±± €€  ﬂ€ ∞∞ ﬂ€‹‹   €€€€ﬂ ≤≤€‹ ∞∞∞∞∞∞∞ ∞∞∞ ∞€‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹€±±');
    Add('±±±±±±±± ﬁ€› ‹‹‹‹ ± ﬁ€€€‹ﬁ≤€€€  ﬁ€€€≤ ∞∞∞∞∞∞ ∞∞∞ ∞∞ ±±±±±±±±±±±±±±±±±±±±±±±±±±±');
    Add('±±±±±     ﬂ€€ﬂﬂ€€›∞∞ €€ﬂ€›≤€€› ±ﬁ€≤ﬂ€€‹ ∞∞∞∞ ∞∞∞ ∞∞ ∞  ∞   ∞      ∞         ∞');
    Add('±±±  ‹€€€€€€€‹ ﬁ€€ ± €€›ﬁ€‹€€›±±ﬁ€€› ﬂ≤€‹ ±± ±±± ±± ±  ±   ±      ±         ±');
    Add('‹‹  ﬂ  ﬂ≤≤≤€≤€›ﬁ≤≤ ‹ ≤≤› ≤≤≤≤›‹ ≤≤≤›‹‹ ﬁ€€ ‹‹‹‹‹‹‹‹‹ ‹‹‹‹‹‹‹‹‹ ‹‹‹‹ ‹‹‹ ‹‹ ‹  ‹');
    Add('   ﬂ    €€€€€€›€€€› ﬁ€€€ ﬁ€€€€  €€€     ≤€›');
    Add('±±± ˛ ∞ﬁ€€€€€€‹€€€€ €€€€‹ €€€€›ﬁ€€€‹‹‹‹≤€ﬂ ∞ ∞∞∞ ∞∞ ∞  ∞   ∞      ∞         ∞');
    Add('±±±± ∞ ﬂﬂﬂ      ﬂﬂﬂ‹ﬂﬂﬂ  ﬂﬂﬂ≤≤≤ﬂﬂﬂﬂﬂﬂﬂﬂ   ∞∞ ∞∞∞ ∞∞ ∞  ∞   ∞      ∞         ∞');
    Add('±±±∞∞±±±∞∞±±∞∞±∞     ∞∞∞±∞∞     ∞∞∞ ∞∞∞∞∞∞∞∞ ∞∞∞ ∞∞ ∞  ∞   ∞      ∞         ∞');
    Add('±±∞∞±±±∞∞±±∞∞±∞∞∞±∞∞∞∞∞±∞∞∞∞∞∞∞∞∞∞∞ ∞∞∞∞∞∞∞∞ ∞∞∞ ∞∞ ∞  ∞   ∞      ∞         ∞');
    Add('ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ');
    Add('');
    for i := 0 to Length(crker) - 1 do begin
      pom := '     [ ' + crker[i].name;
      for j := 1 to 68-Length(crker[i].name)-Length(crker[i].status)-4 do pom := pom + '.';
      pom := pom + crker[i].status + ' ]';
      Add(pom);
    end;
    Add('');
  end;

  if cbIncNews.Checked then begin
    Add('');
    Add('‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹');
    Add('±±±±±±±±±±±±±±∞∞±±±∞∞±±∞∞±∞∞∞±∞∞∞∞∞ ±∞∞∞∞∞∞∞ ∞∞∞ ∞∞ ∞  ∞   ∞      ∞         ∞');
    Add('±±±±±±±±±±±±±   ±±∞∞±±∞∞    ±∞∞∞    ∞∞∞∞∞∞∞∞ ∞∞∞ ∞€ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ€');
    Add('±±±±±±±±± ‹‹‹ ≤ ±∞    ∞± ‹‹      ‹‹ ∞∞∞∞∞∞∞∞ ∞∞∞ ∞€           news          €±±');
    Add('±±±±±±±± €€  ﬂ€ ∞∞ ﬂ€‹‹   €€€€ﬂ ≤≤€‹ ∞∞∞∞∞∞∞ ∞∞∞ ∞€‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹€±±');
    Add('±±±±±±±± ﬁ€› ‹‹‹‹ ± ﬁ€€€‹ﬁ≤€€€  ﬁ€€€≤ ∞∞∞∞∞∞ ∞∞∞ ∞∞ ±±±±±±±±±±±±±±±±±±±±±±±±±±±');
    Add('±±±±±     ﬂ€€ﬂﬂ€€›∞∞ €€ﬂ€›≤€€› ±ﬁ€≤ﬂ€€‹ ∞∞∞∞ ∞∞∞ ∞∞ ∞  ∞   ∞      ∞         ∞');
    Add('±±±  ‹€€€€€€€‹ ﬁ€€ ± €€›ﬁ€‹€€›±±ﬁ€€› ﬂ≤€‹ ±± ±±± ±± ±  ±   ±      ±         ±');
    Add('‹‹  ﬂ  ﬂ≤≤≤€≤€›ﬁ≤≤ ‹ ≤≤› ≤≤≤≤›‹ ≤≤≤›‹‹ ﬁ€€ ‹‹‹‹‹‹‹‹‹ ‹‹‹‹‹‹‹‹‹ ‹‹‹‹ ‹‹‹ ‹‹ ‹  ‹');
    Add('   ﬂ    €€€€€€›€€€› ﬁ€€€ ﬁ€€€€  €€€     ≤€›');
    Add('±±± ˛ ∞ﬁ€€€€€€‹€€€€ €€€€‹ €€€€›ﬁ€€€‹‹‹‹≤€ﬂ ∞ ∞∞∞ ∞∞ ∞  ∞   ∞      ∞         ∞');
    Add('±±±± ∞ ﬂﬂﬂ      ﬂﬂﬂ‹ﬂﬂﬂ  ﬂﬂﬂ≤≤≤ﬂﬂﬂﬂﬂﬂﬂﬂ   ∞∞ ∞∞∞ ∞∞ ∞  ∞   ∞      ∞         ∞');
    Add('±±±∞∞±±±∞∞±±∞∞±∞     ∞∞∞±∞∞     ∞∞∞ ∞∞∞∞∞∞∞∞ ∞∞∞ ∞∞ ∞  ∞   ∞      ∞         ∞');
    Add('±±∞∞±±±∞∞±±∞∞±∞∞∞±∞∞∞∞∞±∞∞∞∞∞∞∞∞∞∞∞ ∞∞∞∞∞∞∞∞ ∞∞∞ ∞∞ ∞  ∞   ∞      ∞         ∞');
    Add('ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ');
    Add('');
    for i := 0 to NewsN.Count-1 do Add('     '+NewsN.Strings[i]);
    Add('');
  end;

  if cbIncGreetings.Checked then begin
    Add('');
    Add('‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹');
    Add('±±±±±±±±±±±±±±∞∞±±±∞∞±±∞∞±∞∞∞±∞∞∞∞∞ ±∞∞∞∞∞∞∞ ∞∞∞ ∞∞ ∞  ∞   ∞      ∞         ∞');
    Add('±±±±±±±±±±±±±   ±±∞∞±±∞∞    ±∞∞∞    ∞∞∞∞∞∞∞∞ ∞∞∞ ∞€ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ€');
    Add('±±±±±±±±± ‹‹‹ ≤ ±∞    ∞± ‹‹      ‹‹ ∞∞∞∞∞∞∞∞ ∞∞∞ ∞€        greetings        €±±');
    Add('±±±±±±±± €€  ﬂ€ ∞∞ ﬂ€‹‹   €€€€ﬂ ≤≤€‹ ∞∞∞∞∞∞∞ ∞∞∞ ∞€‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹€±±');
    Add('±±±±±±±± ﬁ€› ‹‹‹‹ ± ﬁ€€€‹ﬁ≤€€€  ﬁ€€€≤ ∞∞∞∞∞∞ ∞∞∞ ∞∞ ±±±±±±±±±±±±±±±±±±±±±±±±±±±');
    Add('±±±±±     ﬂ€€ﬂﬂ€€›∞∞ €€ﬂ€›≤€€› ±ﬁ€≤ﬂ€€‹ ∞∞∞∞ ∞∞∞ ∞∞ ∞  ∞   ∞      ∞         ∞');
    Add('±±±  ‹€€€€€€€‹ ﬁ€€ ± €€›ﬁ€‹€€›±±ﬁ€€› ﬂ≤€‹ ±± ±±± ±± ±  ±   ±      ±         ±');
    Add('‹‹  ﬂ  ﬂ≤≤≤€≤€›ﬁ≤≤ ‹ ≤≤› ≤≤≤≤›‹ ≤≤≤›‹‹ ﬁ€€ ‹‹‹‹‹‹‹‹‹ ‹‹‹‹‹‹‹‹‹ ‹‹‹‹ ‹‹‹ ‹‹ ‹  ‹');
    Add('   ﬂ    €€€€€€›€€€› ﬁ€€€ ﬁ€€€€  €€€     ≤€›');
    Add('±±± ˛ ∞ﬁ€€€€€€‹€€€€ €€€€‹ €€€€›ﬁ€€€‹‹‹‹≤€ﬂ ∞ ∞∞∞ ∞∞ ∞  ∞   ∞      ∞         ∞');
    Add('±±±± ∞ ﬂﬂﬂ      ﬂﬂﬂ‹ﬂﬂﬂ  ﬂﬂﬂ≤≤≤ﬂﬂﬂﬂﬂﬂﬂﬂ   ∞∞ ∞∞∞ ∞∞ ∞  ∞   ∞      ∞         ∞');
    Add('±±±∞∞±±±∞∞±±∞∞±∞     ∞∞∞±∞∞     ∞∞∞ ∞∞∞∞∞∞∞∞ ∞∞∞ ∞∞ ∞  ∞   ∞      ∞         ∞');
    Add('±±∞∞±±±∞∞±±∞∞±∞∞∞±∞∞∞∞∞±∞∞∞∞∞∞∞∞∞∞∞ ∞∞∞∞∞∞∞∞ ∞∞∞ ∞∞ ∞  ∞   ∞      ∞         ∞');
    Add('ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ');
    Add('');
    for i := 0 to GreetzN.Count-1 do Add('     '+GreetzN.Strings[i]);
    Add('');
  end;

  if cbIncGreetings.Checked then begin
    Add('');
    Add('‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹');
    Add('±±±±±±±±±±±±±±∞∞±±±∞∞±±∞∞±∞∞∞±∞∞∞∞∞ ±∞∞∞∞∞∞∞ ∞∞∞ ∞∞ ∞  ∞   ∞      ∞         ∞');
    Add('±±±±±±±±±±±±±   ±±∞∞±±∞∞    ±∞∞∞    ∞∞∞∞∞∞∞∞ ∞∞∞ ∞€ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ€');
    Add('±±±±±±±±± ‹‹‹ ≤ ±∞    ∞± ‹‹      ‹‹ ∞∞∞∞∞∞∞∞ ∞∞∞ ∞€         contact         €±±');
    Add('±±±±±±±± €€  ﬂ€ ∞∞ ﬂ€‹‹   €€€€ﬂ ≤≤€‹ ∞∞∞∞∞∞∞ ∞∞∞ ∞€‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹€±±');
    Add('±±±±±±±± ﬁ€› ‹‹‹‹ ± ﬁ€€€‹ﬁ≤€€€  ﬁ€€€≤ ∞∞∞∞∞∞ ∞∞∞ ∞∞ ±±±±±±±±±±±±±±±±±±±±±±±±±±±');
    Add('±±±±±     ﬂ€€ﬂﬂ€€›∞∞ €€ﬂ€›≤€€› ±ﬁ€≤ﬂ€€‹ ∞∞∞∞ ∞∞∞ ∞∞ ∞  ∞   ∞      ∞         ∞');
    Add('±±±  ‹€€€€€€€‹ ﬁ€€ ± €€›ﬁ€‹€€›±±ﬁ€€› ﬂ≤€‹ ±± ±±± ±± ±  ±   ±      ±         ±');
    Add('‹‹  ﬂ  ﬂ≤≤≤€≤€›ﬁ≤≤ ‹ ≤≤› ≤≤≤≤›‹ ≤≤≤›‹‹ ﬁ€€ ‹‹‹‹‹‹‹‹‹ ‹‹‹‹‹‹‹‹‹ ‹‹‹‹ ‹‹‹ ‹‹ ‹  ‹');
    Add('   ﬂ    €€€€€€›€€€› ﬁ€€€ ﬁ€€€€  €€€     ≤€›');
    Add('±±± ˛ ∞ﬁ€€€€€€‹€€€€ €€€€‹ €€€€›ﬁ€€€‹‹‹‹≤€ﬂ ∞ ∞∞∞ ∞∞ ∞  ∞   ∞      ∞         ∞');
    Add('±±±± ∞ ﬂﬂﬂ      ﬂﬂﬂ‹ﬂﬂﬂ  ﬂﬂﬂ≤≤≤ﬂﬂﬂﬂﬂﬂﬂﬂ   ∞∞ ∞∞∞ ∞∞ ∞  ∞   ∞      ∞         ∞');
    Add('±±±∞∞±±±∞∞±±∞∞±∞     ∞∞∞±∞∞     ∞∞∞ ∞∞∞∞∞∞∞∞ ∞∞∞ ∞∞ ∞  ∞   ∞      ∞         ∞');
    Add('±±∞∞±±±∞∞±±∞∞±∞∞∞±∞∞∞∞∞±∞∞∞∞∞∞∞∞∞∞∞ ∞∞∞∞∞∞∞∞ ∞∞∞ ∞∞ ∞  ∞   ∞      ∞         ∞');
    Add('ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ');
    Add('');
    for i := 0 to ContactN.Count-1 do Add('     '+ContactN.Strings[i]);
    Add('');
  end;
    Add('');
    Add('‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹');
    Add('±±±±±±±±±±±±±±∞∞±±±∞∞±±∞∞±∞∞∞±∞∞∞∞∞ ±∞∞∞∞∞∞∞ ∞∞∞ ∞∞ ∞  ∞   ∞      ∞         ∞');
    Add('±±±±±±±±±±±±±   ±±∞∞±±∞∞    ±∞∞∞    ∞∞∞∞∞∞∞∞ ∞∞∞ ∞∞ ∞  ∞   ∞      ∞         ∞');
    Add('±±±±±±±±± ‹‹‹ ≤ ±∞    ∞± ‹‹      ‹‹ ∞∞∞∞∞∞∞∞ ∞∞∞ ∞∞ ∞  ∞   ∞      ∞         ∞');
    Add('±±±±±±±± €€  ﬂ€ ∞∞ ﬂ€‹‹   €€€€ﬂ ≤≤€‹ ∞∞∞∞∞∞∞ ∞∞∞ ∞∞ ∞  ∞   ∞      ∞         ∞');
    Add('±±±±±±±± ﬁ€› ‹‹‹‹ ± ﬁ€€€‹ﬁ≤€€€  ﬁ€€€≤ ∞∞∞∞∞∞ ∞∞∞ ∞∞ ∞  ∞   ∞      ∞         ∞');
    Add('±±±±±     ﬂ€€ﬂﬂ€€›∞∞ €€ﬂ€›≤€€› ±ﬁ€≤ﬂ€€‹ ∞∞∞∞ ∞∞∞ ∞∞ ∞  ∞   ∞      ∞         ∞');
    Add('±±±  ‹€€€€€€€‹ ﬁ€€ ± €€›ﬁ€‹€€›±±ﬁ€€› ﬂ≤€‹ ±± ±±± ±± ±  ±   ±      ±         ±');
    Add('‹‹  ﬂ  ﬂ≤≤≤€≤€›ﬁ≤≤ ‹ ≤≤› ≤≤≤≤›‹ ≤≤≤›‹‹ ﬁ€€ ‹‹‹‹‹‹‹‹‹ ‹‹‹‹‹‹‹‹‹ ‹‹‹‹ ‹‹‹ ‹‹ ‹  ‹');
    Add('   ﬂ    €€€€€€›€€€› ﬁ€€€ ﬁ€€€€  €€€     ≤€›');
    Add('±±± ˛ ∞ﬁ€€€€€€‹€€€€ €€€€‹ €€€€›ﬁ€€€‹‹‹‹≤€ﬂ ∞ ∞∞∞ ∞∞ ∞  ∞   ∞      ∞         ∞');
    Add('±±±± ∞ ﬂﬂﬂ      ﬂﬂﬂ‹ﬂﬂﬂ  ﬂﬂﬂ≤≤≤ﬂﬂﬂﬂﬂﬂﬂﬂ   ∞∞ ∞∞∞ ∞∞ ∞  ∞   ∞      ∞         ∞');
    Add('±±±∞∞±±±∞∞±±∞∞±∞     ∞∞∞±∞∞     ∞∞∞ ∞∞∞∞∞∞∞∞ ∞∞∞ ∞∞ ∞  ∞   ∞      ∞         ∞');
    Add('±±∞∞±±±∞∞±±∞∞±∞∞∞±∞∞∞∞∞±∞∞∞∞∞∞∞∞∞∞∞ ∞∞∞∞∞∞∞∞ ∞∞∞ ∞∞ ∞  ∞   ∞      ∞         ∞');
    Add('ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ');
    Add('');
    Add('       infofile designed by haliphax of remorse productions (c) 1981        ');
  end;
  Result := rezultat;
end;

{*************************************************************}
{*************************************************************}

function TfrmMain.CompileNFO2(): string;
var
  list: TStrings;
  res: string;
  i: Integer;
begin
  res := '';
  list := CompileNFO();
  for i := 0 to list.Count - 1 do
    res := res + list.Strings[i] + #13#10;
  list.Free();
  result := res;
end;

{*************************************************************}
{*************************************************************}

procedure TfrmMain.btnInstallationNotesClick(Sender: TObject);
begin
//Snimi sadrzaj Memoa
  MemoChanged;
//menja sadrzaj memoa
  if (sender as TComponent).Tag = 1 then begin
    GroupBox2.Caption := 'Crack notes :';
    GroupBox2.Tag := 1;
    LoadText('crknts'); end
  else if (sender as TComponent).Tag = 2 then begin
    GroupBox2.Caption := 'Program info :';
    GroupBox2.Tag := 2;
    LoadText('prginfo'); end
  else if (sender as TComponent).Tag = 3 then begin
    GroupBox2.Caption := 'News :';
    GroupBox2.Tag := 3;
    LoadText('news'); end
  else if (sender as TComponent).Tag = 4 then begin
    GroupBox2.Caption := 'Greetz :';
    GroupBox2.Tag := 4;
    LoadText('greetz'); end
  else if (sender as TComponent).Tag = 5 then begin
    GroupBox2.Caption := 'Contact :';
    GroupBox2.Tag := 5;
    LoadText('contact'); end;
end;

{*************************************************************}
{*************************************************************}

procedure TfrmMain.MemoChanged;
//Snimi trenutni sadrzaj memoa u na odgovarajuce mesto
begin
  if GroupBox2.Tag = 1 then
    SaveText('crknts')
  else if GroupBox2.Tag = 2 then
    SaveText('prginfo')
  else if GroupBox2.Tag = 3 then
    SaveText('news')
  else if GroupBox2.Tag = 4 then
    SaveText('greetz')
  else if GroupBox2.Tag = 5 then
    SaveText('contact');
end;

procedure TfrmMain.newReleaseExecute(Sender: TObject);
begin
  if cfg.getBool('clearURL') then
    edtURL.Text := '';
  if cfg.getBool('clearReleaseName') then
    edtName.Text := '';
  if cfg.getBool('clearReleaseType') then
    edtReleaseType.ItemIndex := -1;
  if cfg.getBool('clearAttachments') then
    lbAttachments.Clear;
end;

{*************************************************************}
{*************************************************************}

procedure TfrmMain.lbAttachmentsProc(var Msg: TMessage) ;
begin
   if Msg.Msg = WM_DROPFILES then
     lbAttachmentsFileDrop(TWMDROPFILES(Msg))
   else
     originalLbAttachmentsWindowProc(Msg);
end;

{*************************************************************}
{*************************************************************}

procedure TfrmMain.lbAttachmentsDrawItem(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);
begin
  with lbAttachments.Canvas do
  begin
    FillRect(Rect);
    drawFileIcon(lbAttachments.Items[Index], lbAttachments.Canvas, Rect.Left+1, Rect.Top+1);
    TextOut(Rect.Left+18, Rect.Top+2, lbAttachments.Items[Index]);
  end;
end;

procedure TfrmMain.lbAttachmentsFileDrop(var Msg: TWMDROPFILES) ;
var
   numFiles : longInt;
   buffer : array[0..MAX_PATH] of char;
  i: Integer;
begin
  numFiles := DragQueryFile(Msg.Drop, $FFFFFFFF, nil, 0) ;
  for i := 0 to numFiles - 1 do begin
    DragQueryFile(Msg.Drop, i, @buffer, sizeof(buffer)) ;
    addAttachment(buffer);
  end;
end;

{*************************************************************}
{*************************************************************}

procedure TfrmMain.lbAttachmentsMeasureItem(Control: TWinControl;
  Index: Integer; var Height: Integer);
begin
  Height := 18;
end;

{*************************************************************}
{*************************************************************}

procedure TfrmMain.lbStickyAttachmentsProc(var Msg: TMessage) ;
begin
   if Msg.Msg = WM_DROPFILES then
     lbStickyAttachmentsFileDrop(TWMDROPFILES(Msg))
   else
     originalLbStickyAttachmentsWindowProc(Msg);
end;

{*************************************************************}
{*************************************************************}

procedure TfrmMain.lbStickyAttachmentsFileDrop(var Msg: TWMDROPFILES) ;
var
   numFiles : longInt;
   buffer : array[0..MAX_PATH] of char;
  i: Integer;
begin
  numFiles := DragQueryFile(Msg.Drop, $FFFFFFFF, nil, 0) ;
  for i := 0 to numFiles - 1 do begin
    DragQueryFile(Msg.Drop, i, @buffer, sizeof(buffer)) ;
    addStickyAttachment(buffer);
  end;
end;

{*************************************************************}
{*************************************************************}

procedure TfrmMain.lbStickyAttachmentsDrawItem(Control: TWinControl;
  Index: Integer; Rect: TRect; State: TOwnerDrawState);
begin
  with lbStickyAttachments.Canvas do
  begin
    FillRect(Rect);
    drawFileIcon(lbStickyAttachments.Items[Index], lbStickyAttachments.Canvas, Rect.Left+1, Rect.Top+1);
    TextOut(Rect.Left+18, Rect.Top+2, lbStickyAttachments.Items[Index]);
  end;
end;

{*************************************************************}
{*************************************************************}

procedure TfrmMain.lbStickyAttachmentsMeasureItem(Control: TWinControl;
  Index: Integer; var Height: Integer);
begin
  Height := 18;
end;

{*************************************************************}
{*************************************************************}

procedure TfrmMain.FormCreate(Sender: TObject);
begin
//Register hotkeys
  hotkeyReleaseName := GlobalAddAtom('SNDPacker_ReleaseName');
  RegisterHotKey(Handle, hotkeyReleaseName, MOD_CONTROL, VkKeyScan('q'));
  hotkeyReleaseInfo := GlobalAddAtom('SNDPacker_ReleaseInfo');
  RegisterHotKey(Handle, hotkeyReleaseInfo, MOD_CONTROL, VkKeyScan('e'));
  hotkeyURL := GlobalAddAtom('SNDPacker_URL');
  RegisterHotKey(Handle, hotkeyURL, MOD_CONTROL, VkKeyScan('w'));

  clipboard := TClipboard.Create;
  Label1.Hint := 'Click to read..'#13#13'Now you can quickly paste release name and URL to Release Packer.'#13'Global hotkeys are added so while you''re in readme.txt'#13'or other file, you can copy text you want and paste directly to:'#13#13'Ctrl+Q:Release name'#13'Ctrl+W:URL'#13'Ctrl+E:Release info';

  CrkNotes := TStringList.Create;
  PrgInfo := TStringList.Create;
  News := TStringList.Create;
  Greetz := TStringList.Create;
  Contact := TStringList.Create;
  CrkNotesN := TStringList.Create;
  PrgInfoN := TStringList.Create;
  NewsN := TStringList.Create;
  GreetzN := TStringList.Create;
  ContactN := TStringList.Create;

  cfg := TMySettings.Create(IncludeTrailingPathDelimiter(ExtractFilePath(Application.ExeName))+'settings.dat');
  cfg.loadSettings();
  loadSettings;


//Load data
  DateTimePicker1.Date := Now;
  Memo1.Lines.AddStrings(CrkNotes);
  GroupBox2.Caption := 'Crack notes:';
  GroupBox2.Tag := 1;
  ProgPutanja := ExcludeTrailingPathDelimiter(ExtractFilePath(Application.ExeName));
//Set up drag&drop for lbAttachments
  originalLbAttachmentsWindowProc := lbAttachments.WindowProc;
  lbAttachments.WindowProc := lbAttachmentsProc;
  DragAcceptFiles(lbAttachments.Handle, True);
//Set up drag&drop for lbStickyAttachments
  originalLbStickyAttachmentsWindowProc := lbStickyAttachments.WindowProc;
  lbStickyAttachments.WindowProc := lbStickyAttachmentsProc;
  DragAcceptFiles(lbStickyAttachments.Handle, True);
end;

{*************************************************************}
{*************************************************************}

procedure TfrmMain.FormDestroy(Sender: TObject);
begin
//Unregister hotkeys
  UnRegisterHotKey(Handle, hotkeyReleaseName);
  GlobalDeleteAtom(hotkeyReleaseName);
  UnRegisterHotKey(Handle, hotkeyReleaseInfo);
  GlobalDeleteAtom(hotkeyReleaseInfo);
  UnRegisterHotKey(Handle, hotkeyURL);
  GlobalDeleteAtom(hotkeyURL);
//Save settings
  saveSettings();
  cfg.Free;
end;

{*************************************************************}
{*************************************************************}

procedure TfrmMain.btnCrewClick(Sender: TObject);
//Forma2. Lista crackera
var
  i: Integer;
begin
  Form2.ListView1.Items.Clear;
  for i := 1 to Length(Crker) do begin
    Form2.ListView1.Items.Add;
    Form2.ListView1.Items.Item[i - 1].Caption := Crker[i - 1].name;
    Form2.ListView1.Items.Item[i - 1].SubItems.Add(Crker[i - 1].status);
  end;
  Form2.ShowModal;
end;

{*************************************************************}
{*************************************************************}

procedure TfrmMain.btnHelpStickyAttachmentsClick(Sender: TObject);
begin
  MessageBox(Handle, 'Attachments you set here are remembered for all sessions of Release Packager.'#13'It''s convinient for files such as NFO Viewer, your personal files etc.',
              'Information', MB_OK or MB_ICONINFORMATION);
end;

{*************************************************************}
{*************************************************************}

procedure TfrmMain.btnAddAttachmentClick(Sender: TObject);
var
  i: Integer;
begin
  OpenDialog1.Options := [ofHideReadOnly, ofAllowMultiSelect, ofPathMustExist, ofFileMustExist, ofEnableSizing];
  if not OpenDialog1.Execute then Exit;
  for i := 0 to OpenDialog1.Files.Count - 1 do
    addAttachment(OpenDialog1.Files.Strings[i]);
end;

procedure TfrmMain.btnAddStickyAttachmentClick(Sender: TObject);
var
  i: Integer;
begin
  OpenDialog1.Options := [ofHideReadOnly, ofAllowMultiSelect, ofPathMustExist, ofFileMustExist, ofEnableSizing];
  if not OpenDialog1.Execute then Exit;
  for i := 0 to OpenDialog1.Files.Count - 1 do
    addStickyAttachment(OpenDialog1.Files.Strings[i]);
end;

{*************************************************************}
{*************************************************************}

procedure TfrmMain.btnRemoveAttachmentClick(Sender: TObject);
var
  i: Integer;
begin
  i := 0;
  while i < lbAttachments.Count do begin
    if lbAttachments.Selected[i] then begin
      lbAttachments.Items.Delete(i);
      i := i - 1;
    end;
    i := i + 1;
  end;
end;

{*************************************************************}
{*************************************************************}

procedure TfrmMain.btnRemoveStickyAttachmentClick(Sender: TObject);
var
  i: Integer;
begin
  i := 0;
  while i < lbStickyAttachments.Count do begin
    if lbStickyAttachments.Selected[i] then begin
      lbStickyAttachments.Items.Delete(i);
      i := i - 1;
    end;
    i := i + 1;
  end;
end;

{*************************************************************}
{*************************************************************}

procedure TfrmMain.TabSheet2Show(Sender: TObject);
begin
  memNFO.Clear;
  memNFO.Lines.AddStrings(CompileNFO());
end;

{*************************************************************}
{*************************************************************}

procedure TfrmMain.PageControl1Change(Sender: TObject);
begin
  MemoChanged;
end;

procedure TfrmMain.tcSettingsChange(Sender: TObject);
begin

end;

{*************************************************************}
{*************************************************************}

procedure TfrmMain.btnOSAddClick(Sender: TObject);
var
  i: Integer;
  pom: Boolean;
begin
  pom := False;
  for i := 0 to edtOS.Items.Count - 1 do
    if LowerCase(edtOS.Items.Strings[i]) = LowerCase(edtOS.Text) then pom := True;
  if not pom then edtOS.Items.Add(edtOS.Text);
end;

{*************************************************************}
{*************************************************************}

procedure TfrmMain.btnOSRemoveClick(Sender: TObject);
var
  i: Integer;
begin
  for i := 0 to edtOS.Items.Count - 1 do
    if LowerCase(edtOS.Items.Strings[i]) = LowerCase(edtOS.Text) then edtOS.Items.Delete(i);
  edtOS.Text := edtOS.Items.Strings[0];
end;

{*************************************************************}
{*************************************************************}

procedure TfrmMain.ListView1ColumnClick(Sender: TObject;
  Column: TListColumn);
begin
  ColumnToSort := Column.Index;
  (Sender as TCustomListView).AlphaSort;
end;

{*************************************************************}
{*************************************************************}

procedure TfrmMain.ListView1Compare(Sender: TObject; Item1, Item2: TListItem;
  Data: Integer; var Compare: Integer);
var
  ix: Integer;
begin
  if ColumnToSort = 0 then
    Compare := CompareText(Item1.Caption,Item2.Caption)
  else begin
   ix := ColumnToSort - 1;
   Compare := CompareText(Item1.SubItems[ix],Item2.SubItems[ix]);
  end;
end;

{*************************************************************}
{*************************************************************}

function TfrmMain.fileName(): string;
var
  res: string;
  i: Integer;
begin
  res := edtName.Text;
  for i := 1 to Length(res) do
    if res[i]=' ' then res[i]:='.';
  res := res + '.' + edtReleaseType.Text + '-SND.zip';
  result := '';
  for i := 1 to Length(res) do
    if Pos(res[i], '\/<>"*?|:')=0 then
      result := result + res[i];
  result := res;
end;

{*************************************************************}
{*************************************************************}

procedure TfrmMain.saveReleaseExecute(Sender: TObject);
var
  fn, str: string;
  i: Integer;
begin
  if not InformationEntered() then Exit;
  if not RequiredAttachmentsOK() then Exit;
  SaveDialog1.InitialDir := saveToDir;
  SaveDialog1.FileName := fileName();
  if SaveDialog1.Execute(Handle) then
    fn := SaveDialog1.FileName
  else
    Exit;
  saveToDir := IncludeTrailingPathDelimiter(ExtractFilePath(fn));
  frmMain.Enabled := False;
  str := frmMain.Caption;
  try
    with Archiver do begin
     FileName := fn;
     OpenArchive(fmCreate);
     AddFromString('snd.nfo', CompileNFO2);
     for i := 0 to lbAttachments.Count - 1 do begin
       Application.ProcessMessages;
       BaseDir := ExtractFilePath(lbAttachments.Items[i]);
       AddFiles(ExtractFileName(lbAttachments.Items[i]));
     end;
     for i := 0 to lbStickyAttachments.Count - 1 do begin
       Application.ProcessMessages;
       BaseDir := ExtractFilePath(lbStickyAttachments.Items[i]);
       AddFiles(ExtractFileName(lbStickyAttachments.Items[i]));
     end;
     CloseArchive;
    end;
  finally
    frmMain.Caption := str;
    frmMain.Enabled := True;
  end;
  MessageBox(Handle, 'Release sucessfully saved!', 'Information', MB_ICONINFORMATION);
end;


procedure TfrmMain.edtReleaseTypeChange(Sender: TObject);
begin
  cfg.getStringList('installNote-'+edtReleaseType.Text, CrkNotes);
  cfg.getStringList('installNote-'+edtReleaseType.Text, CrkNotesN);
  if GroupBox2.Tag=1 then begin
    Memo1.Clear;
    Memo1.Lines.AddStrings(CrkNotes);
  end;
end;

procedure TfrmMain.exitApplicationExecute(Sender: TObject);
begin
  Application.Terminate;
end;

procedure TfrmMain.btnJustifyClick(Sender: TObject);
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
  if Memo1.SelLength = 0 then Exit;
  lista := TStringList.Create;
  NLBR2TStrings(Memo1.SelText, lista);
  SrediStrListu(lista, duzina);
  s := TStrings2NLBR(lista);
  Memo1.SelText := s;
  lista.Free;
end;

end.
