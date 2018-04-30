unit TNSRemotePublish.Application.DefaultController;

interface

uses
  TNSRemotePublish.Infrastructure.HTTPControllerFactory,
  TNSRemotePublish.Infrastructure.HTTPMVCRequest,
  TNSRemotePublish.Infrastructure.HTTPRouting,
  TNSRemotePublish.Infrastructure.HTTPController;

type
  TMVCDefaultController = class(TMVCController)
    public
      constructor Create;
      function ProcessRequest(Request : TMVCRequest) : Cardinal; override;
      destructor Destroy;
  end;

var
  DefaultController : IController;

implementation


{ TMVCDefaultController }

constructor TMVCDefaultController.Create;
begin
  fisdefault := True;
  froute := TMVCRoute.Create;
  froute.Name := 'default';
  froute.IsDefault := True;
  froute.RelativePath := '/';
  froute.Methods := ['GET', 'POST'];
  froute.needStaticController := False;
end;

destructor TMVCDefaultController.Destroy;
var
  llega : Boolean;
begin
  llega := True;
end;

function TMVCDefaultController.ProcessRequest(Request: TMVCRequest): Cardinal;
begin
  Request.HTTPContext.OutContent := 'Hello World';
  Result := 200;
end;

initialization
  DefaultController := TMVCDefaultController.Create;
  THTTPControllerFactory.Init;
  THTTPControllerFactory.GetInstance.Add(DefaultController);

end.



