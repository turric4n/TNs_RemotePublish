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
  TNsRestFramework.Infrastructure.Services.Logger,
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
    Logger.Info('HTTP Server is listening on port %s. Press a Key to stop service ',[ParamStr(1)]);
    while True do
    begin
      Sleep(100);
    end;
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
