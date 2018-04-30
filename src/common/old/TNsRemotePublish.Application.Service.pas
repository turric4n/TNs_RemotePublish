unit TNSRemotePublish.Application.Service;

interface

uses
  Quick.Commons,
  System.SysUtils, System.Types,
  TNSRemotePublish.Infrastructure.TaskFactory,
  TNSRemotePublish.Infrastructure.HTTPServerFactory,
  TNSRemotePublish.Infrastructure.HTTPControllerFactory,
  TNSRemotePublish.Infrastructure.LoggerFactory;

type
  TApplicationService = class
    private
      class procedure AliveTask(Sender : TSynBackground; Event : TWaitResult; const Msg : TSynBackgroudString);
      class procedure InitBrokers;
      class procedure InitLogging;
      class procedure InitControllers;
      class procedure InitServer;
      class procedure Log(const msg : string; errror : Boolean);
    public
      class procedure Init;
      class procedure Stop;
      class procedure Start;
      class procedure OnStart;
  end;

implementation

{ TApplicationService }

class procedure TApplicationService.InitBrokers;
begin
  TTaskFactory.Init;
end;

class procedure TApplicationService.InitControllers;
begin
  THTTPControllerFactory.Init;
end;

class procedure TApplicationService.AliveTask(Sender: TSynBackground;
  Event: TWaitResult; const Msg: TSynBackgroudString);
begin
  Log('Application check... Is alive.', False);
end;

class procedure TApplicationService.Init;
begin
  //Init
  InitLogging;
  InitBrokers;
  InitControllers;
  InitServer;
end;

class procedure TApplicationService.InitLogging;
begin
  TLoggerFactory.Init;
  Log('TNs Publish Manager server init', False);
end;

class procedure TApplicationService.InitServer;
begin
  THTTPServerFactory.Init('8589');
end;

class procedure TApplicationService.Log(const msg : string; errror: Boolean);
begin
  TLoggerFactory.GetInstance.Log(msg, errror);
end;

class procedure TApplicationService.OnStart;
begin
  //On Start
end;

class procedure TApplicationService.Start;
begin
  //Start
end;

class procedure TApplicationService.Stop;
begin
  Log('Service Stopped', False);
end;

end.