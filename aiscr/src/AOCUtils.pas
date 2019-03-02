unit AOCUtils;

interface

uses
  Windows;

{ Registry routines }
function SetAOCRegistry(const WSPatch: String): Boolean; overload;
function GetAOCRegistryPath: String;
function GetAOCSpecificPath(const Dir: String): String;
{ Get AOC play time routine }
function GetElapsedTime: DWORD;

implementation

uses
  SysUtils, Registry;

const
  DPAPPS_KEY = '\SOFTWARE\Microsoft\DirectPlay\Applications\';
  AOC_KEY = 'Age of Empires II - The Conquerors Expansion';
  AOC_WINDOW_NAME = 'Age of Empires II: The Conquerors';

function GetAOCSpecificPath(const Dir: String): String;
begin
  Result := '';
  with TRegistry.Create do
    try
      Access := KEY_READ;
      RootKey := HKEY_LOCAL_MACHINE;
      if OpenKeyReadOnly(DPAPPS_KEY + AOC_KEY) then
        Result := ReadString('CurrentDirectory');
      if (Result <> '') then
        Result := IncludeTrailingPathDelimiter(IncludeTrailingPathDelimiter(Result) + Dir);
    finally
      Free;
    end;
end;

function GetSaveGamePath: String;
begin
  Result := GetAOCSpecificPath('SaveGame');
end;

function GetAOCPath: String;
var
  Reg: TRegistry;
begin
  Result := '';
  Reg := TRegistry.Create;
  with Reg do
    try
      Access := KEY_READ;
      RootKey := HKEY_LOCAL_MACHINE;
      if OpenKeyReadOnly(DPAPPS_KEY + AOC_KEY) then
        Result := Reg.ReadString('Path');
    finally
      Reg.Free;
    end;
end;

function GetAOCLauncher: String;
begin
  Result := '';
  with TRegistry.Create do
    try
      Access := KEY_READ;
      RootKey := HKEY_LOCAL_MACHINE;
      if OpenKeyReadOnly(DPAPPS_KEY + AOC_KEY) then
        Result := ReadString('Launcher');
    finally
      Free;
    end;
end;

function GetAOCRegistryPath: String;
begin
  Result := '';
  with TRegistry.Create do
    try
      Access := KEY_READ;
      RootKey := HKEY_LOCAL_MACHINE;
      if OpenKeyReadOnly(DPAPPS_KEY + AOC_KEY) then
        Result := ReadString('Path') + ReadString('Launcher');
    finally
      Free;
    end;
end;

function SetAOCRegistry(const Path, Launcher: String): Boolean; overload;
begin
  Result := False;
  with TRegistry.Create do
    try
      try
        Access := KEY_WRITE;
        RootKey := HKEY_LOCAL_MACHINE;
        if OpenKey(DPAPPS_KEY + AOC_KEY, False) then
        begin
          WriteString('Path', ExcludeTrailingPathDelimiter(Path));
          WriteString('Launcher',  '\' + Launcher);
          Result := True;
        end;
      except
        //
      end;
    finally
      Free;
    end;
end;

function SetAOCRegistry(const WSPatch: String): Boolean; overload;
var
  Path, Launcher: String;
begin
  if (WSPatch = '') then
  begin
    Result := False;
    Exit;
  end;
  Path := ExtractFilePath(WSPatch);
  Launcher := ExtractFileName(WSPatch);
  Result := SetAOCRegistry(Path, Launcher);
end;

function GetElapsedTime: DWORD;
var
  hProcess: THandle;
  lpNumberOfBytesRead: Cardinal;
  dwAddr: DWORD;
  hAOCWnd: HWND;
  dwProcessId: DWORD;
  i: Integer;
const
  baseAddr = $0400000;
  dwOffsets: array[0..2] of DWORD = ($002B7668, $70, $0104);
begin
  Result := 0;
  hAOCWnd := FindWindow(nil, AOC_WINDOW_NAME);
  if (hAOCWnd = 0) then
    Exit;
  dwProcessId := 0;
  GetWindowThreadProcessId(hAOCWnd, dwProcessId);
  if (dwProcessId = 0) then
    Exit;
  hProcess := OpenProcess(PROCESS_VM_READ, False, dwProcessId);
  if (hProcess <> INVALID_HANDLE_VALUE) then
  try
    dwAddr := baseAddr;
    for i := Low(dwOffsets) to High(dwOffsets) do
    begin
      dwAddr := dwAddr + dwOffsets[i];
      if not ReadProcessMemory(hProcess, PDWORD(dwAddr), @dwAddr, SizeOf(DWORD), lpNumberOfBytesRead) then
      begin
        dwAddr := 0;
        Break;
      end;
    end;
    Result := dwAddr;
  finally
    CloseHandle(hProcess);
  end;
end;

end.
