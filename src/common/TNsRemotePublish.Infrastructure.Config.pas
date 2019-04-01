unit TNsRemotePublish.Infrastructure.Config;

interface

uses
  {$IFNDEF FPC}
  System.IOUtils,
  {$ELSE}
  Quick.Files
  {$ENDIF}
  Quick.Logger,
  TNsRestFramework.Infrastructure.Config,
  TNsRemotePublish.Infrastructure.Models.Config;

type

  TMainConfig = class(TNsBaseConfig)
  private
    fDebugMode : Boolean;
    fLoggerExtended : TLoggerConfig;
  public
    procedure DefaultValues; override;
  published
    property DebugMode : Boolean read fDebugMode write fDebugMode;
    property LoggerExtended : TLoggerConfig read fLoggerExtended write fLoggerExtended;
  end;


  TConfigFactory = class
    class function Create : TMainConfig;
  end;

var
  MainConfig : TMainConfig;


implementation

{ TConfigFactory }

class function TConfigFactory.Create: TMainConfig;
begin
  if MainConfig = nil then MainConfig := TMainConfig.Create(TPath.ChangeExtension(ParamStr(0),'config'),False);
  Result := MainConfig;
end;

{ TMainConfig }

procedure TMainConfig.DefaultValues;
begin
  inherited;
  fLoggerExtended.RedisLog.Host := 'localhost';
  fLoggerExtended.RedisLog.LogLevel := LOG_ALL;
  fLoggerExtended.RedisLog.Port := 6379;
  fLoggerExtended.RedisLog.LogKey := 'logger';
  fLoggerExtended.RedisLog.DataBase := 0;
  fLoggerExtended.RedisLog.Enabled := False;
end;

end.
