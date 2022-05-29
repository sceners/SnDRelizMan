unit Unit2;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ComCtrls;

type
  TForm2 = class(TForm)
    ListView1: TListView;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
    BitBtn4: TBitBtn;
    UpDown1: TUpDown;
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure BitBtn5Click(Sender: TObject);
    procedure BitBtn4Click(Sender: TObject);
    procedure BitBtn6Click(Sender: TObject);
    procedure UpDown1Click(Sender: TObject; Button: TUDBtnType);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation

{$R *.dfm}

uses Unit1;

procedure TForm2.BitBtn1Click(Sender: TObject);
var
  str: string;
  item: TListItem;
begin
  str := InputBox('Cracker name :', 'Enter name :', '');
  if str = '' then begin
    MessageBox(Application.Handle, 'You must enter cracker name!', 'Error !', MB_ICONERROR);
    Exit;
  end;
  item := ListView1.Items.Add;
  item.Caption := str;
  str := InputBox('Cracker status :', '', '');
  item.SubItems.Add(str);
end;

procedure TForm2.BitBtn2Click(Sender: TObject);
begin
  if ListView1.SelCount = 0 then Exit;
  ListView1.Items.Delete(ListView1.Selected.Index);
end;

procedure TForm2.BitBtn3Click(Sender: TObject);
var
  item: TListItem;
  str: string;
begin
  if ListView1.SelCount = 0 then Exit;
  item := ListView1.Selected;
  str := InputBox('Cracker name :', 'Enter name :', '');
  if str <> '' then item.Caption := str;
  str := InputBox('Cracker status :', '', '');
  if str <> '' then item.SubItems.Strings[0] := str;
  ListView1.SetFocus;
end;

procedure TForm2.BitBtn5Click(Sender: TObject);
var
  str1, str2: string;
  i: Integer;
begin
  if ListView1.SelCount = 0 then Exit;
  if ListView1.Selected.Index = 0 then Exit;
  i := ListView1.Selected.Index;
  str1 := ListView1.Selected.Caption;
  str2 := ListView1.Items.Item[i - 1].Caption;
  ListView1.Items.Item[i - 1].Caption := str1;
  ListView1.Items.Item[i].Caption := str2;
  str1 := ListView1.Selected.SubItems[0];
  str2 := ListView1.Items.Item[i - 1].SubItems[0];
  with ListView1.Items do begin
    Item[i - 1].SubItems[0] := str1;
    Item[i].SubItems[0] := str2;
    Item[i - 1].Selected := True;
    Item[i].Selected := False;
  end;
end;

procedure TForm2.BitBtn4Click(Sender: TObject);
var
  i: Integer;
  pom: string;
begin
  pom := frmMain.edtAuthor.Text;
  SetLength(Unit1.Crker, ListView1.Items.Count);
  for i := 0 to ListView1.Items.Count - 1 do begin
    Unit1.Crker[i].name := ListView1.Items.Item[i].Caption;
    Unit1.Crker[i].status := ListView1.Items.Item[i].SubItems[0];
  end;
  frmMain.edtAuthor.Clear;
  for i := 0 to Length(Unit1.Crker) - 1 do
    frmMain.edtAuthor.Items.Add(Crker[i].name);
  frmMain.edtAuthor.Text := pom;
  Form2.Close;
end;

procedure TForm2.BitBtn6Click(Sender: TObject);
var
  str1, str2: string;
  i: Integer;
begin
  if ListView1.SelCount = 0 then Exit;
  if ListView1.Selected.Index = ListView1.Items.Count - 1 then Exit;
  i := ListView1.Selected.Index;
  str1 := ListView1.Selected.Caption;
  str2 := ListView1.Items.Item[i + 1].Caption;
  ListView1.Items.Item[i + 1].Caption := str1;
  ListView1.Items.Item[i].Caption := str2;
  str1 := ListView1.Selected.SubItems[0];
  str2 := ListView1.Items.Item[i + 1].SubItems[0];
  ListView1.Items.Item[i + 1].SubItems[0] := str1;
  ListView1.Items.Item[i].SubItems[0] := str2;
  ListView1.Items.Item[i].Selected := False;
  ListView1.Items.Item[i + 1].Selected := True;
end;

procedure TForm2.UpDown1Click(Sender: TObject; Button: TUDBtnType);
var
  str1, str2: string;
  i: Integer;
begin
  if Button = btNext then begin
//showmessage('up');
    if ListView1.SelCount = 0 then Exit;
    if ListView1.Selected.Index = 0 then Exit;
    i := ListView1.Selected.Index;
    str1 := ListView1.Selected.Caption;
    str2 := ListView1.Items.Item[i - 1].Caption;
    ListView1.Items.Item[i - 1].Caption := str1;
    ListView1.Items.Item[i].Caption := str2;
    str1 := ListView1.Selected.SubItems[0];
    str2 := ListView1.Items.Item[i - 1].SubItems[0];
    with ListView1.Items do begin
      Item[i - 1].SubItems[0] := str1;
      Item[i].SubItems[0] := str2;
      Item[i - 1].Selected := True;
      Item[i].Selected := False;
    end;
  end
  else if Button = btPrev then begin
//showmessage('DWON');
    if ListView1.SelCount = 0 then Exit;
    if ListView1.Selected.Index = ListView1.Items.Count - 1 then Exit;
    i := ListView1.Selected.Index;
    str1 := ListView1.Selected.Caption;
    str2 := ListView1.Items.Item[i + 1].Caption;
    ListView1.Items.Item[i + 1].Caption := str1;
    ListView1.Items.Item[i].Caption := str2;
    str1 := ListView1.Selected.SubItems[0];
    str2 := ListView1.Items.Item[i + 1].SubItems[0];
    ListView1.Items.Item[i + 1].SubItems[0] := str1;
    ListView1.Items.Item[i].SubItems[0] := str2;
    ListView1.Items.Item[i].Selected := False;
    ListView1.Items.Item[i + 1].Selected := True;
  end;
end;

end.
