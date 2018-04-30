program TNsRemotePublish;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

{$APPTYPE CONSOLE}

{$R *.res}

uses
{$IFnDEF FPC}
  System.SysUtils,
{$ELSE}
  {$IFDEF LINUX}
  cthreads,
  cwstring,
  {$ENDIF}
  SysUtils,
{$ENDIF}
  TNsRestFramework.Application.Service,
  TNsRestFramework.Infrastructure.LoggerFactory,
  TNsRemotePublish.Application.HTTPControllers;

var
  port : string;

begin
  try
    {$IFDEF DEBUG}
    TApplicationService.Init('9000');
    {$ELSE}
    Integer.Parse(ParamStr(1));
    TApplicationService.Init(ParamStr(1));
    {$ENDIF}
    TLoggerFactory.GetInstance.Log('HTTP Server is listening. Press a Key to stop service ' + ParamStr(1), False);
    Readln;
    TLoggerFactory.GetInstance.Log('Exit', False);
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
