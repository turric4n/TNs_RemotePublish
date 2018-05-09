unit TNsRemoteProcessManager.Application.ProcessController;

interface

uses
  {$IFNDEF FPC}
  System.Classes,
  System.SysUtils,
  System.JSON,
  System.Generics.Collections,
  {$ELSE}
  sysutils,
  fgl,
  fpjson,
  {$ENDIF}
  TNsRestFramework.Infrastructure.LoggerFactory,
  TNsRestFramework.Infrastructure.HTTPControllerFactory,
  TNsRestFramework.Infrastructure.HTTPRestRequest,
  TNsRestFramework.Infrastructure.HTTPRouting,
  TNsRestFramework.Infrastructure.HTTPController,
  TNsRemoteProcessManager.Infrastructure.ProcessFactory;

type
  TProcessJSON = class
    public
      ProcessName : string; //Name of the process or service
      ProcessType : string; //Process or service
      Parameters : string; //Execution parameters
      Action : string; //Start or stop
  end;

  { THTTPProcessController }

  THTTPProcessController = class(THTTPController)
    private
      function GetJobFromJson(jsonObject : TJSONObject) : TProcessJSON;
      procedure Manage(Process : TProcessJSON);
      procedure ValidateModel(Model : TProcessJSON);
      {$IFNDEF FPC}
      function GetJobsFromJSON(const Body : string) : TObjectList<TProcessJSON>;
      {$ELSE}
      function GetJobsFromJSON(const Body : string) : TFPGObjectList<TProcessJSON>;
      {$ENDIF}
    public
      constructor Create;
      function ProcessRequest(Request : THTTPRestRequest) : Cardinal; override;
  end;

var
  ProcessController : IController;

implementation

{ THTTPProcessController }

constructor THTTPProcessController.Create;
begin
  inherited;
  fisdefault := False;
  froute.Name := 'process';
  froute.IsDefault := True;
  froute.RelativePath := 'process';
  froute.AddMethod('POST');
  froute.needStaticController := False;
end;

{$IFNDEF FPC}
function THTTPProcessController.GetJobsFromJSON(const Body : string) : TObjectList<TProcessJSON>;
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
      Result := TObjectList<TProcessJSON>.Create(True);
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

function THTTPProcessController.GetJobsFromJSON(const Body: string): TFPGObjectList<TProcessJSON>;
var
  vJSONScenario: TJSONData;
  I : integer;
begin
  Result := nil;
  vJSONScenario := GetJSON(body);
  if vJSONScenario <> nil then
  begin
    try
      Result := TFPGObjectList<TProcessJSON>.Create(True);
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

procedure THTTPProcessController.Manage(Process : TProcessJSON);
begin
  if Process.ProcessType.ToLower = 'service' then
  begin
    if Process.Action.ToLower = 'stop' then
    begin
      if not (TProcessFactory.GetInstanceFromName(Process.ProcessName).StopService(Process.ProcessName) > 0) then raise Exception.Create('Service cannot be stopped ' + Process.ProcessName)
      else  TLoggerFactory.GetFactory.GetInstance.Log('Service stopped ' + Process.ProcessName, False);
    end
    else if Process.Action.ToLower = 'start' then
    begin
      if not (TProcessFactory.GetInstanceFromName(Process.ProcessName).StartService(Process.ProcessName) > 0) then raise Exception.Create('Service cannot be started ' + Process.ProcessName)
      else  TLoggerFactory.GetFactory.GetInstance.Log('Service started ' + Process.ProcessName, False);
    end
    else raise Exception.Create('Process action unknown!');
  end
  else if Process.ProcessType.ToLower = 'process' then
  begin
    if Process.Action.ToLower = 'stop' then
    begin
      if not (TProcessFactory.GetInstanceFromName(Process.ProcessName).Kill(Process.ProcessName) > 0) then raise Exception.Create('Process can''t be terminated ' + Process.ProcessName)
      else TLoggerFactory.GetFactory.GetInstance.Log('Process terminated ' + Process.ProcessName, False);
    end
    else if Process.Action.ToLower = 'start' then
    begin
      if not TProcessFactory.GetInstanceFromName(Process.ProcessName).Execute(Process.ProcessName, Process.Parameters) then raise Exception.Create('Process can''t be started ' + Process.ProcessName)
      else TLoggerFactory.GetFactory.GetInstance.Log('Process started ' + Process.ProcessName, False);
    end
    else raise Exception.Create('Process action unknown!');
  end
  else raise Exception.Create('Process type unknown!');
end;

function THTTPProcessController.GetJobFromJson(jsonObject: TJSONObject): TProcessJSON;
begin
  Result := TProcessJSON.Create;
  {$IFNDEF FPC}
  if jsonObject.GetValue('processname') as TJSONString <> nil then
    Result.ProcessName := TJSONString(jsonObject.GetValue('processname')).ToString.Replace('"','');
  if jsonObject.GetValue('processtype') as TJSONString <> nil then
    Result.ProcessType := TJSONString(jsonObject.GetValue('processtype')).ToString.Replace('"','');
  if jsonObject.GetValue('parameters') as TJSONString <> nil then
    Result.Parameters := TJSONString(jsonObject.GetValue('parameters')).ToString.Replace('"','');
  if jsonObject.GetValue('action') as TJSONString <> nil then
    Result.Action := TJSONString(jsonObject.GetValue('action')).ToString.Replace('"','');
  {$ELSE}
  if jsonObject.Get('processname') <> '' then
    Result.ProcessName := string(jsonObject.Get('processname')).Replace('"','');
  if jsonObject.Get('processtype') <> '' then
    Result.ProcessType := string(jsonObject.Get('processtype')).Replace('"','');
  if jsonObject.Get('parameters') <> '' then
    Result.Parameters := string(jsonObject.Get('parameters')).Replace('"','');
  if jsonObject.Get('action') <> '' then
    Result.Action := string(jsonObject.Get('action')).Replace('"','');
  {$ENDIF}
end;

procedure THTTPProcessController.ValidateModel(Model: TProcessJSON);
begin
  //
end;

function THTTPProcessController.ProcessRequest(Request: THTTPRestRequest): Cardinal;
var
  {$IFNDEF FPC}
  jobs : TObjectList<TProcessJSON>;
  {$ELSE}
  jobs : TFPGObjectList<TProcessJSON>;
  {$ENDIF}
  job : TProcessJSON;

begin
  TLoggerFactory.GetInstance.Log(Request.InContent, False);
  if not (Request.RequestInfo.ContentType = 'application/json') then Result := 400
  else
  begin
    try
      jobs := GetJobsFromJson(Request.InContent);
      if jobs <> nil then
      begin
        try
          for job in jobs do
          begin
            try
              TLoggerFactory.GetFactory.GetInstance.Log('New JOB added', False);
              TLoggerFactory.GetFactory.GetInstance.Log(job.ProcessName + ' ' + job.ProcessType + ' ' + job.Parameters + ' ' + job.Parameters, False);
              Manage(job);
              Result := 200;
              Request.ResponseInfo.ContentText := job.ProcessName + ' Service Started';
            except
              on e : Exception do
              begin
                TLoggerFactory.GetFactory.GetInstance.Log(e.Message, True);
                Result := 500;
              end;
            end;
          end;
        finally
          jobs.Free;
        end;
      end
      else raise Exception.Create('No valid jobs to parse');
    except
      on e : Exception do
      begin
        Request.ResponseInfo.ContentText := 'Invalid JSON Request ' + e.Message;
        Result := 500;
      end;
    end;
  end;
end;

initialization
  ProcessController := THTTPProcessController.Create;
  THTTPControllerFactory.Init;
  THTTPControllerFactory.GetInstance.Add(ProcessController);

end.



