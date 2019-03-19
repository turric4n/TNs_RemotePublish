unit TNsRemoteProcessManager.Application.StartController;

interface

uses

  System.Classes,
  System.SysUtils,
  System.JSON,
  System.Generics.Collections,
  TNsRemoteProcessManager.Infrastructure.HTTPControllerFactory,
  TNsRemoteProcessManager.Infrastructure.HTTPMVCRequest,
  TNsRemoteProcessManager.Infrastructure.HTTPRouting,
  TNSRemoteProcessManager.Infrastructure.LoggerFactory,
  TNSRemoteProcessManager.Infrastructure.ProcessFactory,
  TNsRemoteProcessManager.Infrastructure.HTTPController;

type
  TProcessJSON = class
    public
      ProcessName : string;
      ProcessType : string;
      Parameters : string;
  end;

  TMVCStartController = class(TMVCController)
    private
      function StartTask(Process : TProcessJSON) : Boolean;
      function GetJobFromJson(jsonObject : TJSONObject) : TProcessJSON;
      function GetJobsFromJSON(const Body : string) : TObjectList<TProcessJSON>;
    public
      constructor Create;
      function ProcessRequest(Request : TMVCRequest) : Cardinal; override;
  end;

var
  StartController : IController;

implementation

{ TMVCDefaultController }

constructor TMVCStartController.Create;
begin
  fisdefault := True;
  froute := TMVCRoute.Create;
  froute.Name := 'start';
  froute.IsDefault := False;
  froute.RelativePath := 'start';
  froute.Methods := ['POST'];
  froute.needStaticController := False;
end;

function TMVCStartController.GetJobsFromJSON(const Body : string) : TObjectList<TProcessJSON>;
var
  vJSONScenario: TJSONValue;
  vJSONValue: TJSONValue;
  vJSONPair : TJSONPair;
begin
  try
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
            begin
              try
                if TJSONObject(vJSONValue).GetValue('JOB') <> nil then
                Result.Add(GetJobFromJson(TJSONObject(vJSONValue).GetValue('JOB') as TJSONObject));
              except
                on e : Exception do
              end;
            end;
          end;
        end
        else if vJSONScenario is TJSONObject then Result.Add(GetJobFromJson(TJSONObject(vJSONValue).GetValue('JOB') as TJSONObject));
      finally
        vJSONScenario.Free;
      end;
    end;
  except
    on e : Exception do
  end;
end;

function TMVCStartController.StartTask(Process : TProcessJSON) : Boolean;
begin
  if Process.ProcessType.ToLower = 'service' then
  begin
    if not (TProcessFactory.GetInstanceFromName(Process.ProcessName).StartService(Process.ProcessName) > 0) then raise Exception.Create('Service cannot be started ' + Process.ProcessName)
    else TLoggerFactory.GetFactory.GetInstance.Log('Service started ' + Process.ProcessName, False);
  end
  else
  begin
    if not TProcessFactory.GetInstanceFromName(Process.ProcessName).Execute(Process.ProcessName, Process.Parameters)then raise Exception.Create('Process can''t be started ' + Process.ProcessName + ' ' + Process.Parameters)
    else  TLoggerFactory.GetFactory.GetInstance.Log('Process started ' + Process.ProcessName, False);
  end;
  Result := True;
end;

function TMVCStartController.GetJobFromJson(jsonObject: TJSONObject): TProcessJSON;
begin
  Result := TProcessJSON.Create;
  if jsonObject.GetValue('ProcessName') as TJSONString <> nil then
    Result.ProcessName := TJSONString(jsonObject.GetValue('ProcessName')).ToString.Replace('"','');
  if jsonObject.GetValue('ProcessType') as TJSONString <> nil then
    Result.ProcessType := TJSONString(jsonObject.GetValue('ProcessType')).ToString.Replace('"','');
  if jsonObject.GetValue('Parameters') as TJSONString <> nil then
    Result.Parameters := TJSONString(jsonObject.GetValue('Parameters')).ToString.Replace('"','');
end;

function TMVCStartController.ProcessRequest(Request: TMVCRequest): Cardinal;
var
  jobs : TObjectList<TProcessJSON>;
  job : TProcessJSON;
begin
  //TLoggerFactory.GetInstance.Log(Request.HTTPContext.InContent, False);
  if not (Request.HTTPContext.InContentType = 'application/json') then Result := 400
  else
  begin
    try
      jobs := GetJobsFromJson(Request.HTTPContext.InContent);
      if jobs <> nil then
      begin
        try
          for job in jobs do
          begin
            try
              TLoggerFactory.GetFactory.GetInstance.Log('New JOB added start ' + job.ProcessType + ' ' + job.ProcessName, False);
              if StartTask(job) then
              begin
                Result := 200;
                Request.HTTPContext.OutContent := job.ProcessName + ' Service Started';
              end;
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
      end;
    except
      on e : Exception do
      begin
        Request.HTTPContext.OutContent := 'Invalid JSON Request';
      end;
    end;
  end;
end;

initialization
  StartController := TMVCStartController.Create;
  THTTPControllerFactory.Init;
  THTTPControllerFactory.GetInstance.Add(StartController);

end.



