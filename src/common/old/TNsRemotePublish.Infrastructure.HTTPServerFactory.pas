unit TNSRemotePublish.Infrastructure.HTTPServerFactory;

interface

uses
  TNSRemotePublish.Infrastructure.HTTPControllerFactory,
  TNSRemotePublish.Infrastructure.HTTPServer,
  TNSRemotePublish.Infrastructure.LoggerFactory,
  System.SyncObjs,
  System.SysUtils,
  Winapi.ActiveX;

type
  THTTPServerFactory = class
    protected
      fserver : ICustomHTTPServer;
    public
      class procedure Init(const Port : string);
      class function GetCurrent : ICustomHTTPServer;
      destructor Destroy; override;
  end;

implementation

var
  Lock : TCriticalSection;
  HTTPServerFactory : THTTPServerFactory;

{ TMonitoringServiceFactory }

destructor THTTPServerFactory.Destroy;
begin
  fserver := nil;
  inherited;
end;

class function THTTPServerFactory.GetCurrent : ICustomHTTPServer;
begin
  if Assigned(HTTPServerFactory) and Assigned(HTTPServerFactory.fserver) then
  Result := HTTPServerFactory.fserver;
end;

class procedure THTTPServerFactory.Init(const Port : string);
begin
  if not Assigned(HTTPServerFactory) then
  begin
    HTTPServerFactory := THTTPServerFactory.Create;
    HTTPServerFactory.fserver := TCustomHTTPServer.Create(Port);
  end;
end;

initialization
  Lock := TCriticalSection.Create;
  HTTPServerFactory := nil;

finalization
  if Assigned(HTTPServerFactory) then HTTPServerFactory.Free;
  Lock.Free;
end.
