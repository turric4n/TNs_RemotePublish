unit TNSRemotePublish.Infrastructure.HTTPController;

interface

uses
  SynCommons,
  SynCrtSock,
  System.IOUtils,
  System.SysUtils,
  TNSRemotePublish.Infrastructure.HTTPMVCRequest,
  TNSRemotePublish.Infrastructure.HTTPRequest,
  TNSRemotePublish.Infrastructure.HTTPRouting;

type
  IController = interface
    function CanIHandleThis(const Filename : String) : Boolean;
    function GetRoute : TMVCRoute;
    function ProcessRequest(Request : TMVCRequest) : Cardinal;
    function IsDefaultController : Boolean;
    function IsStaticHandler : Boolean;
  end;

  [JsonSerialize(TJsonMemberSerialization.&Public)]
  TMVCController = class(TInterfacedObject, IController)
    protected
      fisdefault : Boolean;
      fstatichandler : Boolean;
      frequest : TMVCRequest;
      froute : TMVCRoute;
    public
      function CanIHandleThis(const Filename : String) : Boolean;
      function IsStaticHandler : Boolean;
      function ProcessRequest(Request : TMVCRequest) : Cardinal; virtual; abstract;
      function GetRoute : TMVCRoute;
      function IsDefaultController : Boolean;
  end;

implementation

{ TMVCController }

function TMVCController.CanIHandleTHis(const Filename : String): Boolean;
var
  extension : string;
begin
  Result := False;
end;

function TMVCController.GetRoute: TMVCRoute;
begin
  Result := froute;
end;

function TMVCController.IsDefaultController: Boolean;
begin
  Result := fisdefault;
end;

function TMVCController.IsStaticHandler: Boolean;
begin
  Result := fstatichandler;
end;

end.
