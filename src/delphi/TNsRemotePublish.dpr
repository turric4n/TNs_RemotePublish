program TNsRemotePublish;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  {$IFDEF MSWINDOWS}
  Winapi.Windows,
  {$ENDIF}
  {$IFNDEF FPC}
  Quick.AppService,
  {$ENDIF}
  TNsRestFramework.Application.Service,
  TNSRemotePublish.Application.HTTPControllers,
  TNsRestFramework.Infrastructure.Interfaces.Logger,
  TNsRestFramework.Infrastructure.Services.Logger;

var
  {$IFDEF MSWINDOWS}
  Msg : tagMSG;
  {$ENDIF}

procedure Process;
begin
  {$IFDEF MSWINDOWS}
  while True do
  begin
    GetMessage(Msg, 0, 0, 0);
    TranslateMessage(Msg);
    DispatchMessageA(Msg);
  end;
  {$ELSE}
  readln;
  {$ENDIF}
end;

begin
  try
    if not AppService.IsRunningAsService then
    begin
      Integer.Parse(ParamStr(1));
      TApplicationService.Init(ParamStr(1));
      Logger.SetRotation(20,False,10,'logs');
      Logger.SetLogLevel(lvALL);
      Process;
    end
    else
    begin
      AppService.ServiceName := 'RemotePublishManager';
      AppService.DisplayName := 'REST API for remote file publish';
      {TODO -oTurrican -cGeneral : Load initialization from configuration file.}
      AppService.OnStart := procedure
      begin
        TApplicationService.Init('8580');
      end;
      AppService.CheckParams;
    end;
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
