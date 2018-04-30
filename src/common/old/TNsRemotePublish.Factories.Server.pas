unit TNSRemoteProcessManager.Factories.Server;

interface

uses
  System.Generics.Collections,
  System.SysUtils, System.SyncObjs,
  Infrastructure.Repositories.HTTP.Server;

type
  THTTPServerFactory = class
    private
      fhttpserver : TAPPHTTPServer;
    public
      class function GetCurrent : TAPPHTTPServer;
      class procedure Init(Port : Integer);
  end;

implementation

var
  HTTPFactory : THTTPServerFactory;
  Lock : TCriticalSection;

class function THTTPServerFactory.GetCurrent : TAPPHTTPServer;
begin
  Lock.Acquire;
  try
    Result := HTTPFactory.fhttpserver;
  finally
    Lock.Release;
  end;
end;


class procedure THTTPServerFactory.Init(Port : Integer);
begin
  Lock.Acquire;
  Try
    if not Assigned(HTTPFactory) then
    begin
      HTTPFactory := THTTPServerFactory.Create;
      HTTPFactory.fhttpserver := TAPPHTTPServer.Create
    end;
  Finally
    Lock.Release;
  End;
end;

initialization
  Lock := TCriticalSection.Create;
  HTTPFactory := nil;

finalization
  Lock.Free;
end.