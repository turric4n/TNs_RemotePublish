unit TNsRemotePublish.Application.WarmController;

interface

uses
  System.SysUtils,
  System.Net.HttpClient,
  System.JSON,
  TNsRestFramework.Infrastructure.Services.Logger,
  TNsRestFramework.Infrastructure.HTTPControllerFactory,
  TNsRestFramework.Infrastructure.HTTPRestRequest,
  TNsRestFramework.Infrastructure.HTTPRouting,
  TNsRestFramework.Infrastructure.HTTPController;

type

TURLJSON = class
public
  Urls : array of string;
end;

THTTPWarmController = class(THTTPController)
private
  function CallURL(const URL : string) : Cardinal;
public
  constructor Create;
  function ProcessRequest(Request : THTTPRestRequest) : Cardinal; override;
end;



var
  WarmController : IController;

implementation

{ TMVCDefaultController }

function THTTPWarmController.CallURL(const URL : string) : Cardinal;
var
  client : THTTPClient;
begin
  client := THTTPClient.Create;
  try
    Logger.Info('Warm "%s" called',[URL]);
    if client.Get(URL).StatusCode <> 200 then raise Exception.Create('Server returned error code')
    else Result := 200;
  finally
    client.Free;
  end;
end;

constructor THTTPWarmController.Create;
begin
  inherited;
  fisdefault := False;
  froute.Name := 'warm';
  froute.IsDefault := False;
  froute.RelativePath := 'warm';
  froute.AddMethod('POST');
  froute.needStaticController := False;
end;

{TODO -oOwner -cGeneral : Implement from JSON method}
//function THTTPWarmController.GetURLSFromJSON(const Body: string): TURLJSON;
//var
//  vJSONScenario: TJSONValue;
//  vJSONValue: TJSONValue;
//  vval2 : TJSONValue;
//begin
//  Result := nil;
//  vJSONScenario := TJSONObject.ParseJSONValue(Body, False);
//  if vJSONScenario <> nil then
//  begin
//    try
//      Result := TURLJSON.Create;
//      if vJSONScenario is TJSONObject then
//      begin
//        if (TJSONObject(vJSONScenario) as TJSONObject).GetValue('URLS') as TJSONArray <> nil then
//        begin
//          for vJSONValue in vJSONScenario as TJSONArray do
//          begin
//            if vJSONValue is TJSONObject then
//            Result.Add(GetJobFromJson(TJSONObject(vJSONValue) as TJSONObject));
//          end;
//          for vval2 in (TJSONObject(vJSONScenario) as TJSONObject).GetValue('URLS') do
//          begin
//            Result.Urls := Result.Urls + [string(vval2)];
//          end;
//        end;
//      end;
//    finally
//      vJSONScenario.Free;
//    end;
//  end;
//end;

function THTTPWarmController.ProcessRequest(Request: THTTPRestRequest): Cardinal;
var
  url : string;
begin
  if Request.Method = 'POST' then
  begin
    Logger.Info('Warm method called');
    for url in Request.InContent.Split([',']) do Result := CallURL(url);
  end
  else Result := 400;
end;

initialization
  WarmController := THTTPWarmController.Create;
  THTTPControllerFactory.Init;
  THTTPControllerFactory.GetInstance.Add(WarmController);


end.