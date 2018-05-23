unit TNsRemoteProcessManager.Infrastructure.ProcessFactory;

interface

uses
  TNsRemoteProcessManager.Domain.Interfaces.ProcessFunctionality,
  {$IFDEF LINUX}
  TNsRemoteProcessManager.Infrastructure.UNIX.ProcessController,
  {$ELSE}
  TNsRemoteProcessManager.Infrastructure.Windows.ProcessController,
  {$ENDIF}
  {$IFNDEF FPC}
  System.SysUtils;
  {$ELSE}
  sysutils;
  {$ENDIF}

type
  TProcessFactory = class
    public
      class function GetInstanceFromName(const ProcessName : string) : IProcessFunctionality;
  end;

implementation

{ TProcessFactory }

class function TProcessFactory.GetInstanceFromName(const ProcessName : string) : IProcessFunctionality;
begin
  Result := TNSRemotePMProcess.Create(ProcessName);
end;


end.

