unit TNsRemoteProcessManager.Infrastructure.Windows.ProcessController;

interface

uses
  TNSRemoteProcessManager.Domain.Interfaces.ProcessFunctionality,
  TNsRestFramework.Infrastructure.LoggerFactory,
  TNSRemoteProcessManager.Domain.Models.Process,
  {$IFNDEF FPC}
  QuickServices,
  Winapi.Windows,
  Winapi.ShellAPI,
  System.SysUtils,
  System.Generics.Collections,
  System.Classes;
  {$ELSE}
  Windows,
  ShellApi,
  sysutils,
  Classes;
  {$ENDIF}


type
  TInternalProcess = class
    public
      Handle : THandle;
      PID : Cardinal;
      Name : string;
  end;

  TNSRemotePMProcess = class(TProcess, IProcessFunctionality)
    private
      process : string;
      procedure GetProcesses;
    public
      function Kill(const ProcessName : string) : Cardinal; overload;
      function Kill : Cardinal; overload;
      function Kill(PID : Integer) : Cardinal; overload;
      function StopService(const ServiceName : string) : Cardinal; overload;
      function StartService(const ServiceName : string) : Cardinal; overload;
      procedure SendCommand(const Command : string; PID : Integer);
      function Execute(const Path, Params : string) : Boolean;
      constructor Create(const ProcessName : string);
      destructor Destroy;
  end;

implementation

{TNSRemotePMProcess}

constructor TNSRemotePMProcess.Create;
begin
  process := ProcessName;
end;

destructor TNSRemotePMProcess.Destroy;
begin
  //fpinstances.Free;
  inherited;
end;

function TNSRemotePMProcess.Execute(const Path, Params: string): Boolean;
begin
  Result := Boolean(ShellExecute(0, 'open', PWideChar(Path), PWideChar(Params), nil, SW_SHOWNORMAL));
end;

procedure TNSRemotePMProcess.GetProcesses;
begin

end;

function TNSRemotePMProcess.Kill(PID: Integer): Cardinal;
begin
  //
end;

function TNSRemotePMProcess.Kill(const ProcessName: string): Cardinal;
begin

end;

function TNSRemotePMProcess.Kill : Cardinal;
begin
  //
end;


procedure TNSRemotePMProcess.SendCommand(const Command: string; PID: Integer);
begin
  //
end;

function TNSRemotePMProcess.StartService(const ServiceName: string): Cardinal;
begin
  //Result := Cardinal(ServiceStart('localhost', ServiceName));
end;

function TNSRemotePMProcess.StopService(const ServiceName: string): Cardinal;
begin
  //Result := Cardinal(ServiceStop('localhost', ServiceName));
end;

end.
