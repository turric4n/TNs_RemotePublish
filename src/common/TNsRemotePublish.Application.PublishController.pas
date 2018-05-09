unit TNsRemotePublish.Application.PublishController;

interface

uses
  {$IFNDEF FPC}
  System.Classes,
  System.SysUtils,
  System.JSON,
  System.Generics.Collections,
  System.NetEncoding,
  {$ELSE}
  Classes,
  sysutils,
  jsonparser,
  fpjson,
  fgl,
  base64,
  {$ENDIF}
  TNsRemotePublish.Infrastructure.CompressionFactory,
  TNSRemotePublish.Infrastructure.Interfaces.Compression,
  TNsRestFramework.Infrastructure.LoggerFactory,
  TNsRestFramework.Infrastructure.HTTPControllerFactory,
  TNsRestFramework.Infrastructure.HTTPRestRequest,
  TNsRestFramework.Infrastructure.HTTPRouting,
  TNsRestFramework.Infrastructure.HTTPController;

type
  TPublishJSON = class
    private
      FPublishFile: string;
      FDestination: string;
      FAction: string;
      FFileType : string;
      procedure SetPublishFile(const Value: string);
      procedure SetAction(const Value: string);
      procedure SetDestination(const Value: string);
    public
      property FileType : string read FFileType write FFileType;
      property PublishFile : string read FPublishFile write SetPublishFile;
      property Destination : string read FDestination write SetDestination;
      property Action : string read FAction write SetAction;
  end;

  { THTTPPublishController }

  THTTPPublishController = class(THTTPController)
    private
      procedure OnExtractFile(Sender : TObject; const Filename : string; Position: Int64);
      procedure PublishJob(Job : TPublishJSON);
      function GetJobFromJson(jsonObject : TJSONObject) : TPublishJSON;
      {$IFNDEF FPC}
      function GetJobsFromJSON(const Body : string) : TObjectList<TPublishJSON>;
      {$ELSE}
      function GetJobsFromJSON(const Body : string) : TFPGObjectList<TPublishJSON>;
      {$ENDIF}
    public
      constructor Create;
      function ProcessRequest(Request : THTTPRestRequest) : Cardinal; override;
  end;

var
  PublishController : IController;

implementation


{ TMVCDefaultController }

constructor THTTPPublishController.Create;
begin
  inherited;
  fisdefault := False;
  froute.Name := 'default';
  froute.IsDefault := True;
  froute.RelativePath := 'publish';
  froute.AddMethod('POST');
  froute.needStaticController := False;
end;

function THTTPPublishController.GetJobFromJson(jsonObject: TJSONObject): TPublishJSON;
begin
  Result := TPublishJSON.Create;
  {$IFNDEF FPC}
  if jsonObject.GetValue('file') as TJSONString <> nil then
    Result.FPublishFile := TJSONString(jsonObject.GetValue('file')).ToString.Replace('"','');
  if jsonObject.GetValue('destination') as TJSONString <> nil then
    Result.FDestination := TJSONString(jsonObject.GetValue('destination')).ToString.Replace('"','');
  if jsonObject.GetValue('action') as TJSONString <> nil then
    Result.FAction := TJSONString(jsonObject.GetValue('action')).ToString.Replace('"','');
  if jsonObject.GetValue('filetype') as TJSONString <> nil then
    Result.FFileType := TJSONString(jsonObject.GetValue('filetype')).ToString.Replace('"','');
  {$ELSE}
  if jsonObject.Get('file') <> '' then
    Result.FPublishFile := string(jsonObject.Get('file')).Replace('"','');
  if jsonObject.Get('destination') <> '' then
    Result.FDestination := string(jsonObject.Get('destination')).Replace('"','');
  if jsonObject.Get('action') <> '' then
    Result.FAction := string(jsonObject.Get('action')).Replace('"','');
  if jsonObject.Get('filetype') <> '' then
    Result.FFileType := string(jsonObject.Get('filetype')).Replace('"','');
  {$ENDIF}
end;



{$IFNDEF FPC}
function THTTPPublishController.GetJobsFromJSON(const Body : string) : TObjectList<TPublishJSON>;
var
  vJSONScenario: TJSONValue;
  vJSONValue: TJSONValue;
  vJSONPair : TJSONPair;
begin
  Result := nil;
  vJSONScenario := TJSONObject.ParseJSONValue(Body, False);
  if vJSONScenario <> nil then
  begin
    try
      Result := TObjectList<TPublishJSON>.Create(True);
      if vJSONScenario is TJSONArray then
      begin
        TLoggerFactory.GetFactory.GetInstance.Log('JSON is an Array', False);
        for vJSONValue in vJSONScenario as TJSONArray do
        begin
          if vJSONValue is TJSONObject then
          Result.Add(GetJobFromJson(TJSONObject(vJSONValue) as TJSONObject));
        end;
      end
      else if vJSONScenario is TJSONObject then Result.Add(GetJobFromJson(TJSONObject(vJSONScenario) as TJSONObject));
    finally
      vJSONScenario.Free;
    end;
  end;
end;

{$ELSE}

function THTTPPublishController.GetJobsFromJSON(const Body: string): TFPGObjectList<TPublishJSON>;
var
  vJSONScenario: TJSONData;
  I : integer;
begin
  Result := nil;
  vJSONScenario := GetJSON(body);
  if vJSONScenario <> nil then
  begin
    try
      Result := TFPGObjectList<TPublishJSON>.Create(True);
      case vJSONScenario.JSONType of
       jtArray :
         begin
           TLoggerFactory.GetFactory.GetInstance.Log('JSON is an Array', False);
           for I:=0 to vJSONScenario.Count -1 do
           begin
             Result.Add(GetJobFromJson(TJSONObject(vJSONScenario) as TJSONObject));
           end;
         end;
       jtObject :
         begin
           Result.Add(GetJobFromJson(TJSONObject(vJSONScenario) as TJSONObject));
         end;
      end;
    finally
      vJSONScenario.Free;
    end;
  end;
end;
{$ENDIF}

procedure THTTPPublishController.OnExtractFile(Sender: TObject;
  const Filename: string; Position: Int64);
begin
  TLoggerFactory.GetInstance.Log('Deflating : ' + Filename, False);
end;

function THTTPPublishController.ProcessRequest(Request: THTTPRestRequest): Cardinal;
var
  job : TPublishJSON;
  {$IFNDEF FPC}
  jobs : TObjectList<TPublishJSON>;
  {$ELSE}
  jobs : TFPGObjectList<TPublishJSON>;
  {$ENDIF}
begin
  if Request.RequestInfo.ContentType = 'application/json' then
  begin
    try
      jobs := GetJobsFromJSON(Request.InContent);
      try
        for job in jobs do PublishJob(job);
      except
        on e : Exception do
        begin
          TLoggerFactory.GetInstance.Log(e.message, True);
          Result := 500;
        end;
      end;
    finally
      if jobs <> nil then jobs.Free;
    end;
  end;
  Result := 200;
end;

procedure THTTPPublishController.PublishJob(Job: TPublishJSON);
var
  strstream : TStringStream;
  dest : string;
  compressor : ICompression;
begin
  //Base 64 to stream
  {$IFNDEF FPC}
  strstream := TStringStream.Create(TNetEncoding.Base64.DecodeStringToBytes(Job.FPublishFile));
  {$ELSE}
  strstream := TStringStream.Create(base64.DecodeStringBase64(Job.FPublishFile));
  {$ENDIF}
  try
    if Job.FFileType = 'zip' then compressor := TCompressionFactory.GetInstance('zip')
    else raise Exception.Create('Filetype ' + Job.FFileType + ' Not supported ');
    compressor.SubscribeOnProcess(OnExtractFile);
    for dest in job.FDestination.Split([',']) do
    begin
      compressor.ExtractFromStreamToDisk(strstream, dest);
    end;
  finally
    strstream.Free;
  end;
end;

{ TPublishJSON }

procedure TPublishJSON.SetAction(const Value: string);
begin
  FAction := Value;
end;

procedure TPublishJSON.SetDestination(const Value: string);
begin
  FDestination := Value;
end;

procedure TPublishJSON.SetPublishFile(const Value: string);
begin
  FPublishFile := Value;
end;

initialization
  PublishController := THTTPPublishController.Create;
  THTTPControllerFactory.Init;
  THTTPControllerFactory.GetInstance.Add(PublishController);

end.



