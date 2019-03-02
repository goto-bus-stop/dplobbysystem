unit AOCRegistry;

interface

{ Registry routines }
function SetAOCRegistry(const WSPatch: String): Boolean; overload;
function GetAOCRegistryPath: String;
function GetAOCSpecificPath(const Dir: String): String;

implementation

uses
  Windows, SysUtils, Classes, StrUtils, TlHelp32, SHFolder, Registry, ShellApi;

const
  DPAPPS_KEY = '\SOFTWARE\Microsoft\DirectPlay\Applications\';
  AOC_KEY = 'Age of Empires II - The Conquerors Expansion';

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

end.
