unit UMySettings;

interface

uses
  SysUtils, Classes;

type
  TStrSetting = record
    name:   string;
    value:  string;
  end;

  TStringListSetting = record
    name:   string;
    value:  TStrings;
  end;  
  
  TIntSetting = record
    name:   string;
    value:  Integer;
  end;

  TBoolSetting = record
    name:   string;
    value:  Boolean;
  end;

  TMySettings = class
    fileName: string;
    constructor Create(); overload;
    //Alternate constructor
    constructor Create(fileName2: string); overload;
    //Destructor. Free lists
    destructor Destroy(); override;
    //Free all lists
    procedure Clear();
    //Save settings to filename
    function saveSettings(): Boolean;
    //Load settings from filename
    function loadSettings(): Boolean;
    //Returns index of a setting or -1 if not found
    function strIndex(name: string): Integer;
    function strListIndex(name: string): Integer;
    function intIndex(name: string): Integer;
    function boolIndex(name: string): Integer;
    //Number of settings
    function strCount(): Integer;
    function strListCount(): Integer;
    function intCount(): Integer;
    function boolCount(): Integer;
//Set/Get setting from appropriate list
    //set/get string
    procedure setString(name: string; value: string);
    procedure getString(name: string; var value: string); overload;
    function  getString(name: string): string; overload;
    //getfirst/getnext. Also rewind/getnext possible
    function getStringFirst(var name: string; var value: string): Boolean;
    procedure rewindStr();
    function getStringNext(var name: string; var value: string): Boolean;
//Set/get STRING LIST
    procedure setStringList(name: string; value: TStrings);
    function  getStringList(name: string): TStrings; overload;
    procedure  getStringList(name: string; Result: TStrings); overload;//Needed for ListBoxes. You have to call like getStringList('lb1', lb1.Items);
    //getfirst/getnext. Also rewind/getnext possible
    function getStringListFirst(var name: string; value: TStrings): Boolean;
    procedure rewindStrList();
    function getStringListNext(var name: string; value: TStrings): Boolean;
//Set/get INT
    procedure setInt(name: string; value: Integer);
    procedure getInt(name: string; var value: Integer); overload;
    function  getInt(name: string): Integer; overload;
    //getfirst/getnext. Also rewind/getnext possible
    function getIntFirst(var name: string; var value: Integer): Boolean;
    procedure rewindInt();
    function getIntNext(var name: string; var value: Integer): Boolean;
//Set/get BOOL
    procedure setBool(name: string; value: Boolean);
    procedure getBool(name: string; var value: Boolean); overload;
    function  getBool(name: string): Boolean; overload;
    //getfirst/getnext. Also rewind/getnext possible
    function getBoolFirst(var name: string; var value: Boolean): Boolean;
    procedure rewindBool();
    function getBoolNext(var name: string; var value: Boolean): Boolean;
  private
    f:        file of Byte;
    strings:  array of TStrSetting;
    stringLists: array of TStringListSetting;
    ints:     array of TIntSetting;
    bools:    array of TBoolSetting;
    stri, strListi, inti, booli: Integer;
  end;

implementation

  function strEqualCaseless(s1, s2: string): Boolean;
  begin
    Result := False;
    if LowerCase(s1)=LowerCase(s2) then Result := True;    
  end;

  constructor TMySettings.Create();
  begin
    inherited Create;
  end;

  constructor TMySettings.Create(fileName2: string);
  begin
    fileName := fileName2;
    inherited Create;
  end;

  destructor TMySettings.Destroy;
  begin
    Clear();
    inherited Destroy;
  end;

  procedure TMySettings.Clear();
  begin
    Finalize(strings);  
    Finalize(stringLists);
    Finalize(ints);
    Finalize(bools);
  end;
  
  function TMySettings.saveSettings(): Boolean;
  var
    i, j, tmp, tmp2: Integer;
    tmpstr: string;
  begin
    Result := False;
    AssignFile(f, filename);
    {$I-}
    Rewrite(f);
    if IOResult<>0 then Exit;
    //WRITING STRING LIST    
    //write number of entries
    tmp := Length(strings);
    BlockWrite(f, tmp, SizeOf(tmp));
    for i := 0 to Length(strings)-1 do begin
      //write each entrys name and value
      tmp := Length(strings[i].name);
      BlockWrite(f, tmp, SizeOf(tmp));
      BlockWrite(f, strings[i].name[1], tmp);
      tmp := Length(strings[i].value);
      BlockWrite(f, tmp, SizeOf(tmp));
      BlockWrite(f, strings[i].value[1], tmp);
      if IOResult<>0 then begin
        CloseFile(f);
        Exit;
      end;
    end;
    //WRITING STRINGLISTS LIST    
    //write number of entries
    tmp := Length(stringLists);
    BlockWrite(f, tmp, SizeOf(tmp));
    for i := 0 to Length(stringLists)-1 do begin
      //write each entrys name and value
      tmp := Length(stringLists[i].name);//Get name len
      BlockWrite(f, tmp, SizeOf(tmp));//Write name len
      BlockWrite(f, stringLists[i].name[1], tmp);//Write name
      tmp := stringLists[i].value.Count;//Get list len
      BlockWrite(f, tmp, SizeOf(tmp));//Write list len
      for j := 0 to tmp - 1 do begin
        tmpstr := stringLists[i].value.Strings[j];
        tmp2 := Length(tmpstr);
        BlockWrite(f, tmp2, SizeOf(tmp2));
        BlockWrite(f, tmpstr[1], tmp2);
        if IOResult<>0 then begin
          CloseFile(f);
          Exit;
        end;
      end;
    end;
    //WRITING INTEGER LIST    
    //write number of entries
    tmp := Length(ints);
    BlockWrite(f, tmp, SizeOf(tmp));
    for i := 0 to Length(ints)-1 do begin
      //write each entrys name and value
      tmp := Length(ints[i].name);
      BlockWrite(f, tmp, SizeOf(tmp));
      BlockWrite(f, ints[i].name[1], tmp);
      BlockWrite(f, ints[i].value, SizeOf(ints[i].value));
      if IOResult<>0 then begin
        CloseFile(f);
        Exit;
      end;
    end;
    //WRITING BOOLEAN LIST    
    //write number of entries
    tmp := Length(bools);
    BlockWrite(f, tmp, SizeOf(tmp));
    for I := 0 to Length(bools)-1 do begin
      //write each entrys name and value
      tmp := Length(bools[i].name);
      BlockWrite(f, tmp, SizeOf(tmp));
      BlockWrite(f, bools[i].name[1], tmp);
      BlockWrite(f, bools[i].value, SizeOf(bools[i].value));
      if IOResult<>0 then begin
        CloseFile(f);
        Exit;
      end;
    end;
    CloseFile(f);
    Result := True;
    {$I+}
  end;

  function TMySettings.loadSettings(): Boolean;
  var
    i, j, tmp, tmp2: Integer;
    tmpstr: string;
  begin
    Clear;
    Result := False;
    AssignFile(f, filename);
    {$I-}
    Reset(f);
    if IOResult<>0 then Exit;
    //READING STRING LIST    
    //write number of entries
    BlockRead(f, tmp, SizeOf(tmp));
    SetLength(strings, tmp);
    for I := 0 to Length(strings)-1 do begin
      //read each entrys name and value
      BlockRead(f, tmp, SizeOf(tmp));//read NAME len
      SetLength(strings[i].name, tmp);//set NAME len
      BlockRead(f, strings[i].name[1], tmp);//read NAME
      BlockRead(f, tmp, SizeOf(tmp));//read VALUE len
      SetLength(strings[i].value, tmp);//set VALUE len
      BlockRead(f, strings[i].value[1], tmp);//read VALUE
      if IOResult<>0 then begin
        CloseFile(f);
        Exit;
      end;
    end;
    //READING STRINGLISTS LIST    
    //read number of entries
    BlockRead(f, tmp, SizeOf(tmp));
    SetLength(stringLists, tmp);
    for i := 0 to Length(stringLists)-1 do begin
      //read each entrys name and value
      BlockRead(f, tmp, SizeOf(tmp));//Read name len
      SetLength(stringLists[i].name, tmp);//Set name len
      BlockRead(f, stringLists[i].name[1], tmp);//Read name
      BlockRead(f, tmp, SizeOf(tmp));//Read list len
      stringLists[i].value := TStringList.Create;
      for j := 0 to tmp - 1 do begin
        BlockRead(f, tmp2, SizeOf(tmp2));
        SetLength(tmpstr, tmp2);
        BlockRead(f, tmpstr[1], tmp2);
        stringLists[i].value.Add(tmpstr);
        if IOResult<>0 then begin
          CloseFile(f);
          Exit;
        end;
      end;
    end;    
    //READING INTEGER LIST    
    //read number of entries
    BlockRead(f, tmp, SizeOf(tmp));
    SetLength(ints, tmp);
    for I := 0 to Length(ints)-1 do begin
      //write each entrys name and value
      BlockRead(f, tmp, SizeOf(tmp));
      SetLength(ints[i].name, tmp);
      BlockRead(f, ints[i].name[1], tmp);
      BlockRead(f, ints[i].value, SizeOf(ints[i].value));
      if IOResult<>0 then begin
        CloseFile(f);
        Exit;
      end;
    end;
    //READING BOOLEAN LIST    
    //read number of entries
    BlockRead(f, tmp, SizeOf(tmp));
    SetLength(bools, tmp);
    for I := 0 to Length(bools)-1 do begin
      //read each entrys name and value
      BlockRead(f, tmp, SizeOf(tmp));
      SetLength(bools[i].name, tmp);
      BlockRead(f, bools[i].name[1], tmp);
      BlockRead(f, bools[i].value, SizeOf(bools[i].value));
      if IOResult<>0 then begin
        CloseFile(f);
        Exit;
      end;
    end;
    CloseFile(f);
    Result := True;
    {$I+}
  end;

  function TMySettings.strIndex(name: string): Integer;
  var
    i: Integer;
  begin
    Result := -1;
    for i := 0 to Length(strings) - 1 do
      if strEqualCaseless(strings[i].name, name) then begin
        Result := i;
        Exit;
      end;
  end;

  function TMySettings.strListIndex(name: string): Integer;
  var
    i: Integer;
  begin
    Result := -1;
    for i := 0 to Length(stringLists) - 1 do
      if strEqualCaseless(stringLists[i].name, name) then begin
        Result := i;
        Exit;
      end;
  end;
 
  
  function TMySettings.intIndex(name: string): Integer;
  var
    i: Integer;
  begin
    Result := -1;
    for i := 0 to Length(ints) - 1 do
      if strEqualCaseless(ints[i].name, name) then begin
        Result := i;
        Exit;
      end;
  end;

  function TMySettings.boolIndex(name: string): Integer;
  var
    i: Integer;
  begin
    Result := -1;
    for i := 0 to Length(bools) - 1 do
      if strEqualCaseless(bools[i].name, name) then begin
        Result := i;
        Exit;
      end;
  end;

  function TMySettings.strCount(): Integer;
  begin
    Result := Length(strings);
  end;

  function TMySettings.strListCount(): Integer;
  begin
    Result := Length(stringLists);
  end;

  function TMySettings.intCount(): Integer;
  begin
    Result := Length(ints);
  end;

  function TMySettings.boolCount(): Integer;
  begin
    Result := Length(bools);
  end;



  procedure TMySettings.setString(name: string; value: string);
  var
    idx: Integer;
    len: Integer;
  begin
    idx := strIndex(name);
    if idx=-1 then begin
      len := Length(strings);
      SetLength(strings, len+1);
      strings[len].name := name;
      strings[len].value := value;
    end else
      strings[idx].value := value;
  end;

  procedure TMySettings.getString(name: string; var value: string);
  var
    idx: Integer;
  begin
    idx := strIndex(name);
    value := '';
    if idx<>-1 then
      value := strings[idx].value;
  end;

  function  TMySettings.getString(name: string): string;
  var
    idx: Integer;
  begin
    idx := strIndex(name);
    Result := '';
    if idx<>-1 then
      Result := strings[idx].value;
  end;

  function TMySettings.getStringFirst(var name: string; var value: string): Boolean;
  begin
    stri := 0;
    Result := False;
    if stri>=Length(strings) then Exit;
    name := strings[0].name;
    value := strings[0].value;
    stri := stri + 1;
    Result := True;
  end;

  procedure TMySettings.rewindStr();
  begin
    stri := 0;
  end;

  function TMySettings.getStringNext(var name: string; var value: string): Boolean;
  begin
    Result := False;
    if stri>=Length(strings) then Exit;
    name := strings[stri].name;
    value := strings[stri].value;
    stri := stri + 1;
    Result := True;
  end;


  procedure TMySettings.setStringList(name: string; value: TStrings);
  var
    idx: Integer;
    len: Integer;
  begin
    idx := strListIndex(name);
    if idx=-1 then begin
      len := Length(stringLists);
      SetLength(stringLists, len+1);
      stringLists[len].value := TStringList.Create;
      stringLists[len].name := name;
      stringLists[len].value.AddStrings(value);
    end else begin
      stringLists[idx].value.Clear;
      stringLists[idx].value.AddStrings(value);
    end;
  end;

  function  TMySettings.getStringList(name: string): TStrings;
  var
    idx: Integer;
  begin
    idx := strListIndex(name);
    Result := TStringList.Create;
    if idx<>-1 then
      Result.AddStrings(stringLists[idx].value);
  end;

  procedure  TMySettings.getStringList(name: string; Result: TStrings);
  var
    idx: Integer;
  begin
    idx := strListIndex(name);
    Result.Clear;
    if idx=-1 then Exit;
    Result.AddStrings(stringLists[strListIndex(name)].value);
  end;

  function TMySettings.getStringListFirst(var name: string; value: TStrings): Boolean;
  begin
    strListi := 0;
    Result := False;
    value.Clear;
    if Length(stringLists)<=strListi then Exit;
    name := stringLists[strListi].name;
    value.AddStrings(stringLists[strListi].value);
    strListi := strListi + 1;
    Result := True;
  end;

  procedure TMySettings.rewindStrList();
  begin
    strListi := 0;
  end;


  function TMySettings.getStringListNext(var name: string; value: TStrings): Boolean;
  begin
    Result := False;
    value.Clear;
    if Length(stringLists)<=strListi then Exit;
    name := stringLists[strListi].name;
    value.AddStrings(stringLists[strListi].value);
    strListi := strListi + 1;
    Result := True;
  end;

  procedure TMySettings.setInt(name: string; value: Integer);
  var
    idx: Integer;
    len: Integer;
  begin
    idx := intIndex(name);
    if idx=-1 then begin
      len := Length(ints);
      SetLength(ints, len+1);
      ints[len].name := name;
      ints[len].value := value;
    end else
      ints[idx].value := value;
  end;

  procedure TMySettings.getInt(name: string; var value: Integer);
  var
    idx: Integer;
  begin
    idx := intIndex(name);
    value := 0;
    if idx<>-1 then
      value := ints[idx].value;
  end;

  function TMySettings.getInt(name: string): Integer;
  var
    idx: Integer;
  begin
    idx := intIndex(name);
    Result := 0;
    if idx<>-1 then
      Result := ints[idx].value;
  end;

  function TMySettings.getIntFirst(var name: string; var value: Integer): Boolean;
  begin
    inti := 0;
    Result := False;
    if Length(ints)<=inti then Exit;
    name := ints[inti].name;
    value := ints[inti].value;
    inti := inti + 1;
    Result := True;
  end;

  procedure TMySettings.rewindInt();
  begin
    inti := 0;
  end;

  function TMySettings.getIntNext(var name: string; var value: Integer): Boolean;
  begin
    Result := False;
    if Length(ints)<=inti then Exit;
    name := ints[inti].name;
    value := ints[inti].value;
    inti := inti + 1;
    Result := True;
  end;

  procedure TMySettings.setBool(name: string; value: Boolean);
  var
    idx: Integer;
    len: Integer;
  begin
    idx := boolIndex(name);
    if idx=-1 then begin
      len := Length(bools);
      SetLength(bools, len+1);
      bools[len].name := name;
      bools[len].value := value;
    end else
      bools[idx].value := value;
  end;

  procedure TMySettings.getBool(name: string; var value: Boolean);
  var
    idx: Integer;
  begin
    idx := boolIndex(name);
    value := False;
    if idx<>-1 then
      value := bools[idx].value;
  end;

  function  TMySettings.getBool(name: string): Boolean;
  var
    idx: Integer;
  begin
    idx := boolIndex(name);
    Result := False;
    if idx<>-1 then
      Result := bools[idx].value;
  end;

  function TMySettings.getBoolFirst(var name: string; var value: Boolean): Boolean;
  begin
    booli := 0;
    Result := False;
    if Length(bools)<=booli then Exit;
    name := bools[booli].name;
    value := bools[booli].value;
    booli := booli + 1;
    Result := True;
  end;

  procedure TMySettings.rewindBool();
  begin
    booli := 0;
  end;

  function TMySettings.getBoolNext(var name: string; var value: Boolean): Boolean;
  begin
    Result := False;
    if Length(bools)<=booli then Exit;
    name := bools[booli].name;
    value := bools[booli].value;
    booli := booli + 1;
    Result := True;
  end;

  
end.
