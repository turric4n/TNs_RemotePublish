unit TNsRemoteProcessManager.Domain.Models.Process;

interface

type
  TProcess = class(TInterfacedObject)
    private
      fisservice : Boolean;
      fname : string;
    public
      property IsService : Boolean read fisservice write fisservice;
      property Name : string read fname write fname;
  end;

implementation

end.
