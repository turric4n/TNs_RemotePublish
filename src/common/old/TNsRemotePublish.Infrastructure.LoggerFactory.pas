unit TNSRemotePublish.Infrastructure.LoggerFactory;

interface

uses
  TNSRemotePublish.Infrastructure.Logger,
  System.SyncObjs,
  System.SysUtils,
  Winapi.ActiveX;

type
  TLoggerFactory = class
    protected
      flogger : ILogger;
    public
      class procedure Init;
      class function GetFactory : TLoggerFactory;
      class function GetInstance : ILogger;
      constructor Create;
      destructor Destroy; override;
  end;

implementation

var
  Lock : TCriticalSection;
  LoggerFactory : TLoggerFactory;

{ TMonitoringServiceFactory }

constructor TLoggerFactory.Create;
begin
  flogger := TLogger.Create;
end;

destructor TLoggerFactory.Destroy;
begin
  flogger := nil;
  inherited;
end;

class function TLoggerFactory.GetFactory: TLoggerFactory;
begin
  if Assigned(LoggerFactory) then Result := LoggerFactory;
end;

class function TLoggerFactory.GetInstance : ILogger;
begin
  if Assigned(LoggerFactory) then Result := LoggerFactory.flogger;
end;

class procedure TLoggerFactory.Init;
begin
  if not Assigned(LoggerFactory) then  LoggerFactory := TLoggerFactory.Create;
end;

initialization
  Lock := TCriticalSection.Create;
  LoggerFactory := nil;

finalization
  if Assigned(LoggerFactory) then LoggerFactory.Free;
  Lock.Free;
end.

