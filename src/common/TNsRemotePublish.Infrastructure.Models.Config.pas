unit TNsRemotePublish.Infrastructure.Models.Config;

interface

uses
  Quick.Logger;

type

  TRedisLogConfig = record
    Host : string;
    Port : Integer;
    LogLevel : TLogLevel;
    LogKey : string;
    DataBase : Integer;
    Enabled : Boolean;
  end;

  TLoggerConfig = record
    RedisLog : TRedisLogConfig;
  end;



implementation



end.
