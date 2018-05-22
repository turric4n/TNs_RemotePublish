unit TNsRemotePublish.Application.DefaultController;

interface

uses
  TNsRestFramework.Infrastructure.HTTPControllerFactory,
  TNsRestFramework.Infrastructure.HTTPRestRequest,
  TNsRestFramework.Infrastructure.HTTPRouting,
  TNsRestFramework.Infrastructure.HTTPController;

type
  THTTPDefaultController = class(THTTPController)
    public
      constructor Create;
      function ProcessRequest(Request : THTTPRestRequest) : Cardinal; override;
  end;

var
  DefaultController : IController;

implementation


{ TMVCDefaultController }

constructor THTTPDefaultController.Create;
begin
  inherited;
  fisdefault := True;
  froute.Name := 'default';
  froute.IsDefault := True;
  froute.RelativePath := '';
  froute.AddMethod('POST');
  froute.needStaticController := False;
end;


function THTTPDefaultController.ProcessRequest(Request: THTTPRestRequest): Cardinal;
begin
  Request.ResponseInfo.ContentText := 'Hello World';
  Result := 200;
end;

initialization
  DefaultController := THTTPDefaultController.Create;
  THTTPControllerFactory.Init;
  THTTPControllerFactory.GetInstance.Add(DefaultController);

end.



