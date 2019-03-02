unit Language;

interface

uses
  Classes;

type
  TLanguage = class
  private
    FList: TStringList;
  public
    constructor Create;
    destructor Destroy; override;
    procedure LoadFromFile(const FileName: String);
    function GetValue(const Name: String): String;
    function GetValueFmt(const Name: String; const Args: array of const): String;
  end;

implementation

uses
  SysUtils;

{ TLanguage }

constructor TLanguage.Create;
begin
  FList := TStringList.Create;
end;

destructor TLanguage.Destroy;
begin
  FList.Free;
end;

procedure TLanguage.LoadFromFile(const FileName: String);
begin
  FList.LoadFromFile(FileName);
end;

function TLanguage.GetValue(const Name: String): String;
begin
  Result := FList.Values[Name];
end;

function TLanguage.GetValueFmt(const Name: String; const Args: array of const): String;
begin
  Result := Format(FList.Values[Name], Args);
end;

end.
