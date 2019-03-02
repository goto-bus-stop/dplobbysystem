unit uLogger;

interface

uses
  Classes;

type
  TLogger = class(TObject)
  private
    FStream: TFileStream;
    FFileName: String;
  protected
    constructor Create;
    destructor Destroy; override;
    procedure Append(const Msg: String);
  public
    class procedure FreeInstances;// reintroduce;
    class function GetInstance: TLogger;
    procedure SendMessage(const Msg: String);
  end;

implementation

uses
  SysUtils, Windows;

var
  LoggerInstance: TLogger;

constructor TLogger.Create;
var
  F: TextFile;
begin
  inherited Create;
  FFileName := ChangeFileExt(ParamStr(0), '.log'); { do not localize }
  if FileExists(FFileName) then
  begin
    FStream := TFileStream.Create(FFileName, fmOpenReadWrite or fmShareDenyWrite);
    FStream.Seek(0, soFromEnd);
  end else
  begin
    AssignFile(F, FFileName);
    Rewrite(F);
    CloseFile(F);
    FStream := TFileStream.Create(FFileName, fmOpenWrite or fmShareDenyWrite);
  end;
end;

destructor TLogger.Destroy;
begin
  if Assigned(FStream) then
    FreeAndNil(FStream);
  inherited Destroy;
end;

class procedure TLogger.FreeInstances;
begin
  if Assigned(LoggerInstance) then
    LoggerInstance.Free;
end;

class function TLogger.GetInstance: TLogger;
begin
  if not Assigned(LoggerInstance) then
    LoggerInstance := TLogger.Create;
  Result := LoggerInstance;
end;

procedure TLogger.Append(const Msg: String);
var
  SStream: TStringStream;
begin
  if Assigned(FStream) then
  begin
    SStream := TStringStream.Create(Msg);
    try
      FStream.CopyFrom(SStream, 0);
    finally
      SStream.Free;
    end;
  end;
end;

procedure TLogger.SendMessage(const Msg: String);
var
  UTC: TSystemTime;
  DT: TDateTime;
begin
  GetSystemTime(UTC);
  DT := SystemTimeToDateTime(UTC);
  Append(Format('[%s] %s%s', [FormatDateTime('yyyy-mm-dd hh:nn:ss', DT), Msg, sLineBreak])); { do not localize }
end;

end.
