unit Hamachi;

interface

{ Hamachi routines }
function IsHamachiRunning: Boolean;
function GetHamachiIP: String;
function GetHamachiPath: String;
function GetProgramFilesPath: String;
procedure LaunchHamachi(const HamachiPath: String);

implementation

uses
  Windows, SysUtils, Classes, StrUtils, TlHelp32, SHFolder, Registry, ShellApi;

function ProcessExists(ExeFileName: String): Boolean;
var
  ContinueLoop: BOOL;
  FSnapshotHandle: THandle;
  FProcessEntry32: TProcessEntry32;
begin
  FSnapshotHandle := CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
  FProcessEntry32.dwSize := SizeOf(FProcessEntry32);
  ContinueLoop := Process32First(FSnapshotHandle, FProcessEntry32);
  Result := False;
  while (Integer(ContinueLoop) <> 0) do
  begin
    if ((UpperCase(ExtractFileName(FProcessEntry32.szExeFile)) =
      UpperCase(ExeFileName)) or (UpperCase(FProcessEntry32.szExeFile) =
      UpperCase(ExeFileName))) then
    begin
      Result := True;
    end;
    ContinueLoop := Process32Next(FSnapshotHandle, FProcessEntry32);
  end;
  CloseHandle(FSnapshotHandle);
end;

function IsHamachiRunning: Boolean;
const
  HamachiProcess = 'hamachi.exe'; { do not localize }
begin
  Result := ProcessExists(HamachiProcess);
end;

function GetUserAppDataPath: String;
const
  SHGFP_TYPE_CURRENT = 0;
var
  Path: array[0..MAX_PATH] of Char;
begin
  if SUCCEEDED(SHGetFolderPath(0, CSIDL_APPDATA, 0, SHGFP_TYPE_CURRENT, @Path[0])) then
    Result := Path
  else
    Result := '';
end;

function GetProgramFilesPath: String;
const
  SHGFP_TYPE_CURRENT = 0;
var
  Path: array[0..MAX_PATH] of Char;
begin
  if SUCCEEDED(SHGetFolderPath(0, CSIDL_PROGRAM_FILES, 0, SHGFP_TYPE_CURRENT, @Path[0])) then
    Result := Path
  else
    Result := '';
end;

function GetHamachiIP: String;
const
  AppDataDir = 'Hamachi'; { do not localize }
  AppFile = 'hamachi.ini'; { do not localize }
var
  Path, FileName: String;
  i, j: Integer;
begin
  Result := '';
  Path := GetUserAppDataPath;
  if (Path = '') then
    Exit;
  Path := IncludeTrailingPathDelimiter(IncludeTrailingPathDelimiter(Path) + AppDataDir);
  if not DirectoryExists(Path) then
    Exit;
  FileName := Path + AppFile;
  if not FileExists(FileName) then
    Exit;
  try
    with TFileStream.Create(FileName, fmOpenRead or fmShareDenyNone) do
      try
        SetLength(Result, Size);
        ReadBuffer(Pointer(Result)^, Size);
        i := Pos('[', Result); { do not localize }
        j := Pos(']', Result); { do not localize }
        if (i <> 0) and (j <> 0) and (i < j) then
          Result := Copy(Result, i + 1, j - i - 1);
      except
        Result := '';
        Free;
      end;
  except
    //
  end;
end;

function GetHamachiPath: String;
const
  HamachiKey = '\Hamachi\shell\open\command'; { do not localize }
var
  i , j: Integer;
begin
  Result := '';
  with TRegistry.Create do
    try
      try
        Access := KEY_READ;
        RootKey := HKEY_CLASSES_ROOT;
        if KeyExists(HamachiKey) and OpenKeyReadOnly(HamachiKey) and ValueExists('') then
        begin
          Result := ReadString('');
          if (Result <> '') then
          begin
            i := Pos('"', Result);
            j := PosEx('"', Result, i + 1);
            if (i <> 0) and (j <> 0) then
              Result := Copy(Result, i + 1, j - i - 1);
          end;
        end;
      except
        //
      end;
    finally
      Free;
    end;
end;

procedure LaunchHamachi(const HamachiPath: String);
begin
  if (HamachiPath <> '') then
    ShellExecute(0, 'open', PAnsiChar(HamachiPath), nil, nil, SW_SHOWNORMAL); { do not localize }
end;

end.
