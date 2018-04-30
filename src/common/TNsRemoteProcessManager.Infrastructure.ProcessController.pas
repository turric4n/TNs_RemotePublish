unit TNsRemoteProcessManager.Infrastructure.ProcessController;

interface

uses
  TNsRemoteProcessManager.Domain.Interfaces.ProcessFunctionality,
  TNsRemoteProcessManager.Infrastructure.Logger,
  System.Classes;

type
  TNSRemotePMWindowsProcess = class(IProcessFunctionality)
    private
      flogger : ILogger;
    public
      procedure GetList(var List : TStringList);
      procedure Kill(const Name : string); overload;
      procedure Kill(PID : Integer);
      procedure SendCommand(const Command : string; PID : Integer);
      procedure Execute(const Path : string);
      constructor Create(Logger : ILogger);
      destructor Destroy; override;
  end;

implementation

{ TNSRemotePMWebServer }


{ TNSRemotePMWebServer }

constructor TNSRemotePMWindowsProcess.Create(Logger : ILogger);
begin
  if Assigned(Logger) then flogger := Logger;  
end;

destructor TNSRemotePMWindowsProcess.Destroy;
begin
  flogger := nil;  
  inherited;
end;

procedure TNSRemotePMWindowsProcess.Execute(const Path: string);
begin
  //
end;

procedure TNSRemotePMWindowsProcess.GetList(var List: TStringList);
begin
  //
end;

procedure TNSRemotePMWindowsProcess.Kill(PID: Integer);
begin
  //
end;

procedure TNSRemotePMWindowsProcess.Kill(const Name: string);
begin
  //
end;

procedure TNSRemotePMWindowsProcess.SendCommand(const Command: string; PID: Integer);
begin
  //
end;

end.
