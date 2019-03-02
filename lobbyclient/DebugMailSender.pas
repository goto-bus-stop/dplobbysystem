unit DebugMailSender;

interface

uses
  Classes, SysUtils;

type
  TThreadException = procedure(Sender: TObject; Exception: Exception) of object;

  TSMTPSendThread = class(TThread)
  private
    FBody: String;
    FStream: TMemoryStream;
    FFileName: String;
    FSent: Boolean;
    FException: Exception;
    FOnException: TThreadException;
  protected
    procedure Execute; override;
    procedure HandleThreadException;
  public
    constructor Create(const Body: String; Stream: TStream; const FileName: String);
    destructor Destroy; override;
  published
    property OnException: TThreadException read FOnException write FOnException;
    property Sent: Boolean read FSent;
  end;

  TDebugMailSender = class(TObject)
  private
    FThreadRefCount: Integer;
    FOnSMTPSendException: TThreadException;
    FOnSent: TNotifyEvent;
    function HasThreads: Boolean;
    procedure HandleSMTPSendTerminate(Sender: TObject);
    procedure HandleSMTPSendException(Sender: TObject; Exception: Exception);
  public
    constructor Create;
    procedure SendMail(const Body: String; Stream: TStream; const FileName: String);
    property HasActiveThreads: Boolean read HasThreads;
    property OnSMTPSendException: TThreadException read FOnSMTPSendException write FOnSMTPSendException;
    property OnSent: TNotifyEvent read FOnSent write FOnSent;
  end;

implementation

uses
  IdSMTP, IdMessage, IdMessageCoder{$IFDEF AGE4GREEKS}, Windows{$ENDIF};

const
  SMTP_HOST = 'mail.gmx.com';
  SMTP_PORT = 587;
  SMTP_USERNAME = '@gmx.com';
  SMTP_PASSWORD = '';
  MAIL_SENDER = SMTP_USERNAME;
  MAIL_RECIPIENT = '';
  MAIL_SUBJECT = 'dplobbysystem-debug';
{$IFDEF AGE4GREEKS}
var
  SmtpUserName, SmtpPassword, MailRecipient: String;
{$ENDIF}
type
  TAttachmentType = (atFile, atStream);
  TIdAttachmentEx = class(TIdAttachment)
  protected
    FAttachmentType: TAttachmentType;
    FStream: TStream;
  public
    procedure Assign(Source: TPersistent); override;
    procedure Encode(ADest: TStream); override; { TIdAttachement has to be virtual! }
    property AttachmentType: TAttachmentType read FAttachmentType write FAttachmentType;
    property Stream: TStream read FStream write FStream;
  end;

{ TIdAttachmentEx }

procedure TIdAttachmentEx.Assign(Source: TPersistent);
var
  mp: TIdAttachment;
begin
  if ClassType <> Source.ClassType then
  begin
    inherited;
  end else
  begin
    mp := TIdAttachment(Source);
    ContentTransfer := mp.ContentTransfer;
    ContentType := mp.ContentType;
    ExtraHeaders.Assign(mp.ExtraHeaders);
    ContentDisposition := mp.ContentDisposition;
    FileName := mp.FileName;
  end;
end;

procedure TIdAttachmentEx.Encode(ADest: TStream);
begin
  with TIdMessageEncoderInfo(TIdMessageParts(Collection).MessageEncoderInfo).MessageEncoderClass
    .Create(nil) do try
    Filename := Self.Filename;
    if AttachmentType = atFile then
      Encode(Self.StoredPathName, ADest)
    else
      Encode(Stream, ADest);
    finally Free; end;
end;

{ THttpRequestThread }

constructor TSMTPSendThread.Create(const Body: String; Stream: TStream; const FileName: String);
begin
  inherited Create(True);
  FreeOnTerminate := True;
  FBody := Body;
  FFileName := FileName;
  FStream := TMemoryStream.Create;
  try
    if Assigned(Stream) and (Stream.Size > 0) then
      FStream.CopyFrom(Stream, 0);
  except
  end;
  FSent := False;
  FException := nil;
  FOnException := nil;
end;

destructor TSMTPSendThread.Destroy;
begin
  FStream.Free;
  inherited Destroy;
end;

procedure TSMTPSendThread.Execute;
var
  IdSMTP: TIdSMTP;
  IdMessage: TIdMessage;
  Attachment: TIdAttachmentEx;
begin
  FSent := False;
  IdSMTP := TIdSMTP.Create(nil);
  IdMessage := TIdMessage.Create(nil);
  with IdSMTP do
  begin
    Host := SMTP_HOST;
    Port := SMTP_PORT;
    AuthenticationType := atLogin;
    Username := {$IFDEF AGE4GREEKS}SmtpUserName{$ELSE}SMTP_USERNAME{$ENDIF};
    Password := {$IFDEF AGE4GREEKS}SmtpPassword{$ELSE}SMTP_PASSWORD{$ENDIF};
  end;
  with IdMessage do
  begin
    From.Address := MAIL_SENDER;
    Recipients.EMailAddresses := {$IFDEF AGE4GREEKS}MailRecipient{$ELSE}MAIL_RECIPIENT{$ENDIF};
    Subject := MAIL_SUBJECT;
    Body.Text := FBody;
  end;
  try
    try
      if (FStream.Size > 0) then
      begin
        Attachment := TIdAttachmentEx.Create(IdMessage.MessageParts, FFileName);
        Attachment.AttachmentType := atStream;
        Attachment.Stream := FStream;
      end;
      IdSMTP.Connect(1000);
      if IdSMTP.Connected then
        IdSMTP.Send(IdMessage);
      FSent := True;
    except
      if not(ExceptObject is EAbort) then
      begin
        FException := Exception(ExceptObject);
        Synchronize(HandleThreadException);
      end;
    end;
  finally
    FStream.Clear;
    if IdSMTP.Connected then
      IdSMTP.Disconnect;
    FreeAndNil(IdSMTP);
    FreeANdNil(IdMessage);
  end;
end;

procedure TSMTPSendThread.HandleThreadException;
begin
  try
    if Assigned(FOnException) then
      FOnException(Self, FException);
  finally
    FException := nil;
  end;
end;

{ TDebugMailSender }

constructor TDebugMailSender.Create;
begin
  FThreadRefCount := 0;
  FOnSMTPSendException := nil;
  FOnSent := nil;
end;

function TDebugMailSender.HasThreads: Boolean;
begin
  Result := (FThreadRefCount > 0);
end;

procedure TDebugMailSender.HandleSMTPSendTerminate(Sender: TObject);
var
  T: TSMTPSendThread;
begin
  Dec(FThreadRefCount);
  T := Sender as TSMTPSendThread;
  if T.Sent and Assigned(FOnSent) then
    FOnSent(Self);
end;

procedure TDebugMailSender.HandleSMTPSendException(Sender: TObject; Exception: Exception);
begin
  if Assigned(FOnSMTPSendException) then
    OnSMTPSendException(Self, Exception);
end;

procedure TDebugMailSender.SendMail(const Body: String; Stream: TStream; const FileName: String);
var
  SMTPSendThread: TSMTPSendThread;
begin
  SMTPSendThread := TSMTPSendThread.Create(Body, Stream, FileName);
  SMTPSendThread.OnTerminate := HandleSMTPSendTerminate;
  SMTPSendThread.OnException := HandleSMTPSendException;
  Inc(FThreadRefCount);
  SMTPSendThread.Resume;
end;
{$IFDEF AGE4GREEKS}
function GetResource(const ResName: String): String;
var
  ResStream: TResourceStream;
begin
  ResStream := TResourceStream.Create(hInstance, ResName, RT_RCDATA);
  try
    SetString(Result, nil, ResStream.Size);
    ResStream.Read(Pointer(Result)^, ResStream.Size);
  finally
    ResStream.Free;
  end;
end;

initialization
  SmtpUserName := GetResource('SMTP_USERNAME'); { do not localize }
  SmtpPassword := GetResource('SMTP_PASSWORD'); { do not localize }
  MailRecipient := GetResource('MAIL_RECIPIENT'); { do not localize }
{$ENDIF}

end.
