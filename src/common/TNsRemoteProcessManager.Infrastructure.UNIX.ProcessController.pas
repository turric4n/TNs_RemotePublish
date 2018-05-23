unit TNsRemoteProcessManager.Infrastructure.UNIX.ProcessController;

interface

uses
  TNsRemoteProcessManager.Domain.Interfaces.ProcessFunctionality,
  TNsRestFramework.Infrastructure.Services.Logger,
  TNsRemoteProcessManager.Domain.Models.Process,
  {$IFNDEF FPC}
    System.Classes;
  {$ELSE}
    Process,
    Classes,
    sysutils;
  {$ENDIF}

type

  { TNSRemotePMProcess }

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
  end;

implementation


{ TNSRemotePMProcess }

constructor TNSRemotePMProcess.Create(const ProcessName: string);
begin
  process := ProcessName;
end;

function TNSRemotePMProcess.Execute(const Path, Params: string): Boolean;
begin
  Result := ExecuteProcess(Path, Params) > 0;
end;


function TNSRemotePMProcess.Kill(const ProcessName: string): Cardinal;
var
  s : TStringList;
begin
  try
    with TProcess.Create(nil) do
    begin
      CommandLine := 'ps -C' + ProcessName;
      Options := [poUsePipes, poWaitOnExit];
      Execute;
      s := TStringList.Create;
      try
        s.LoadFromStream(Output);
        if Pos(ProcessName, s.Text) = 0 then raise Exception.Create('Process not found!')
        else
        begin
          CommandLine :=  'pkill ' + ProcessName;
          Execute;
          Result := 1;
        end;
      finally
        s.Free;
      end;
    end;
  finally
    Free;
  end;
end;

function TNSRemotePMProcess.Kill: Cardinal;
begin
  Result := Kill(Self.process);
end;

function TNSRemotePMProcess.Kill(PID: Integer): Cardinal;
begin
  raise ENotImplemented.Create('Not implemented');
end;

function TNSRemotePMProcess.StopService(const ServiceName: string): Cardinal;
begin
    ExecuteProcess('/usr/bin/sudo', '/bin/systemctl stop ' + Servicename);
end;

function TNSRemotePMProcess.StartService(const ServiceName: string): Cardinal;
begin
     ExecuteProcess('/usr/bin/sudo', '/bin/systemctl start ' + Servicename);
end;

procedure TNSRemotePMProcess.SendCommand(const Command: string; PID: Integer);
begin
  raise ENotImplemented.Create('Not implemented');
end;

end.
