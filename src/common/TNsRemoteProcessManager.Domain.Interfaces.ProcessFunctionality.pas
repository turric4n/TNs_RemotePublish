unit TNsRemoteProcessManager.Domain.Interfaces.ProcessFunctionality;

interface

type
  IProcessFunctionality = interface['{E7733EEE-DC9B-4BBB-AD6C-6A347EAE7297}']
      function Kill(const ProcessName : string) : Cardinal; overload;
      function Kill : Cardinal; overload;
      function Kill(PID : Integer) : Cardinal; overload;
      function StartService(const ServiceName : string) : Cardinal;
      function StopService(const ServiceName : string) : Cardinal; overload;
      procedure SendCommand(const Command : string; PID : Integer);
      function Execute(const Path, Params : string) : Boolean;
  end;

implementation

end.
