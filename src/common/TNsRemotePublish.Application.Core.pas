unit TNsRemotePublish.Application.Core;

interface

uses
  Quick.Logger,
  Quick.Logger.Provider.Redis,
  TNsRestFramework.Application.Service,
  TNsRestframework.Infrastructure.Config,
  TNsRestFramework.Infrastructure.Services.Logger,
  TNsRemotePublish.Infrastructure.Config;

type

  TNsRemotePublishService = class(TApplicationService)
  protected
    class procedure InitLogging; override;
    class procedure OnConfigReloaded; override;
    class procedure ApplyConfig; override;
  end;

implementation

{ TNsRemotePublishService }

class procedure TNsRemotePublishService.InitLogging;
begin
  inherited;
  Logger.Providers.Add(GlobalLogRedisProvider);
  Logger.Info('Extended logs Init');
end;

class procedure TNsRemotePublishService.ApplyConfig;
var
  redisprovider : TLogProviderBase;
begin
  inherited;
  redisprovider := Logger.GetProviderByName('TLogRedisProvider');
  if redisprovider <> nil then
  with TLogRedisProvider(redisprovider) do
  begin
    Enabled := False;
    LogLevel := MainConfig.LoggerExtended.RedisLog.LogLevel;
    Host := MainConfig.LoggerExtended.RedisLog.Host;
    Port := MainConfig.LoggerExtended.RedisLog.Port;
    LogKey := MainConfig.LoggerExtended.RedisLog.LogKey;
    DataBase := MainConfig.LoggerExtended.RedisLog.DataBase;
    Enabled := MainConfig.LoggerExtended.RedisLog.Enabled;
  end;
end;


class procedure TNsRemotePublishService.OnConfigReloaded;
begin
  inherited;
  ApplyConfig
end;

end.
