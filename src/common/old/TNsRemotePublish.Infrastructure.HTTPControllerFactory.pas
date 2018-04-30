unit TNSRemotePublish.Infrastructure.HTTPControllerFactory;

interface

uses
  System.SysUtils,
  TNSRemotePublish.Infrastructure.HTTPController,
  TNSRemotePublish.Infrastructure.HTTPRouting,
  TNSRemotePublish.Infrastructure.HTTPMVCRequest,
  System.Generics.Collections,
  System.SyncObjs,
  Winapi.ActiveX;

type

  IHTTPControllerHandler = interface
    function GetControllers : TList<IController>;
    function GetCurrentController(Request : TMVCRequest) : IController;
    procedure Add(Controller : IController);
    procedure Remove(Controller : IController);
  end;

  THTTPControllerHandler = class(TInterfacedObject, IHTTPControllerHandler)
    private
      fcontrollers : TList<IController>;
    public
      constructor Create;
      destructor Destroy;
      function GetCurrentController(Request : TMVCRequest) : IController;
      function GetControllers : TList<IController>;
      procedure Add(Controller : IController);
      procedure Remove(Controller : IController);
  end;

  THTTPControllerFactory = class
    private
      fhttpcontrollerhandler : IHTTPControllerHandler;
      constructor Create;
      destructor Destroy;
    public
      class procedure Init;
      class function GetFactory : THTTPControllerFactory;
      class function GetInstance : IHTTPControllerHandler;
  end;

implementation

var
  Lock : TCriticalSection;
  HTTPControllerFactory : THTTPControllerFactory;

constructor THTTPControllerFactory.Create;
begin
  fhttpcontrollerhandler := THTTPControllerHandler.Create;
end;

destructor THTTPControllerFactory.Destroy;
var
  llega : Boolean;
begin
  llega := True;
end;

class function THTTPControllerFactory.GetFactory: THTTPControllerFactory;
begin
  if Assigned(HTTPControllerFactory) then
  Result := HTTPControllerFactory;
end;

class function THTTPControllerFactory.GetInstance : IHTTPControllerHandler;
begin
  if Assigned(HTTPControllerFactory) then
  Result := HTTPControllerFactory.fhttpcontrollerhandler;
end;

class procedure THTTPControllerFactory.Init;
begin
  if not Assigned(HTTPControllerFactory) then
  HTTPControllerFactory := THTTPControllerFactory.Create;
end;

{ THTTPControllerHandler }

procedure THTTPControllerHandler.Add(Controller: IController);
begin
  fcontrollers.Add(Controller);
end;

constructor THTTPControllerHandler.Create;
begin
  fcontrollers := TList<IController>.Create;
end;

destructor THTTPControllerHandler.Destroy;
var
  llega : Boolean;
begin
  llega := True;
end;

function THTTPControllerHandler.GetControllers: TList<IController>;
begin
  Result := fcontrollers;
end;

function THTTPControllerHandler.GetCurrentController(Request : TMVCRequest) : IController;
var
  controller : IController;
  defaultcontroller : IController;
  route : TMVCRoute;
  methodurl : string;
begin
  result := nil;
  defaultcontroller := nil;
  for controller in fcontrollers do
  begin
    route := controller.GetRoute;
    if controller.IsDefaultController then defaultcontroller := controller;
    if (route.RelativePath = '/') and (Request.Parameters[0] = '/') and (route.isValidMethod(Request.Method)) then
    begin
      Result := controller;
      Exit;
    end
    // Si el controlador se come / hay que mirar si puede servir esa extensión
    else if (controller.IsStaticHandler) and (controller.CanIHandleThis(Request.Parameters[0])) and (route.isValidMethod(Request.Method)) then
    begin
      Result := controller;
      Exit;
    end
    else
    begin
      if (Request.Parameters[0] = route.RelativePath) and (route.isValidMethod(Request.Method)) then
      begin
        Result := Controller;
        Exit;
      end;
    end;
  end;
  if Result = nil then
  begin
    if defaultcontroller <> nil then Result := defaultcontroller
    else Result := nil;
  end;
end;

procedure THTTPControllerHandler.Remove(Controller: IController);
begin
  fcontrollers.Remove(Controller);
end;

initialization
  Lock := TCriticalSection.Create;
  HTTPControllerFactory := nil;

finalization
  if Assigned(HTTPControllerFactory) then HTTPControllerFactory.Free;
  Lock.Free;
end.
