unit TNSRemotePublish.Infrastructure.HTTPServer;

interface

uses
  System.SysUtils,
  SynCrtSock,
  TNSRemotePublish.Infrastructure.HTTPControllerFactory,
  TNSRemotePublish.Infrastructure.HTTPController,
  TNSRemotePublish.Infrastructure.LoggerFactory,
  TNSRemotePublish.Infrastructure.HTTPMVCRequest,
  SynCommons;

type
  ICustomHTTPServer = interface
    procedure Start;
    procedure Stop;
    procedure ChangeListeningPort(const Port : string);
  end;

  TCustomHTTPServer = class(TInterfacedObject, ICustomHTTPServer)
    private
      fhttpserver : THttpServer;
      function ProcessRequest(Ctxt: THttpServerRequest) : Cardinal;
    public
      procedure Start;
      procedure Stop;
      procedure ChangeListeningPort(const Port : string);
      constructor Create(const Port : string);
      destructor Destroy;
  end;

implementation

{ TCustomHTTPServer }


procedure TCustomHTTPServer.ChangeListeningPort(const Port : string);
begin
  //
end;

constructor TCustomHTTPServer.Create(const Port : string);
begin
  fhttpserver := THttpServer.Create(Port, nil, nil, 'CDI', 32);
  fhttpserver.OnRequest := ProcessRequest;
end;

destructor TCustomHTTPServer.Destroy;
begin
  fhttpserver.Free;
end;

function TCustomHTTPServer.ProcessRequest(Ctxt: THttpServerRequest): Cardinal;
var
  controller : IController;
  request : TMVCRequest;
begin
  request := TMVCRequest.Create(Ctxt);
  try
    try
      Result := THTTPControllerFactory.GetInstance.GetCurrentController(request).ProcessRequest(request);
    except
      on e : Exception do
      begin
        TLoggerFactory.GetInstance.Log('Error while loading controllers or not default controller defined... ' + e.Message, True);
        Ctxt.OutContent := 'Error while loading controllers ' + e.Message;
        Result := 404;
      end;
    end;
  finally
    request.Free;
  end;
end;

procedure TCustomHTTPServer.Start;
begin
  //
end;

procedure TCustomHTTPServer.Stop;
begin
  //
end;

end.
