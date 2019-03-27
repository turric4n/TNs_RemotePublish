program TNsRemotePublish;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  {$IFDEF MSWINDOWS}
  Winapi.Windows,
  {$ENDIF }
  {$IFNDEF FPC}
  Quick.AppService,
  {$ENDIF }
  TNsRemoteProcessManager.Application.ProcessController in '..\common\TNsRemoteProcessManager.Application.ProcessController.pas',
  TNsRemoteProcessManager.Domain.Interfaces.ProcessFunctionality in '..\common\TNsRemoteProcessManager.Domain.Interfaces.ProcessFunctionality.pas',
  TNsRemoteProcessManager.Domain.Models.Process in '..\common\TNsRemoteProcessManager.Domain.Models.Process.pas',
  TNsRemoteProcessManager.Infrastructure.ProcessFactory in '..\common\TNsRemoteProcessManager.Infrastructure.ProcessFactory.pas',
  {$IFDEF MSWINDOWS}
  TNsRemoteProcessManager.Infrastructure.Windows.ProcessController in '..\common\TNsRemoteProcessManager.Infrastructure.Windows.ProcessController.pas',
  {$ELSE}
  TNsRemoteProcessManager.Infrastructure.UNIX.ProcessController in '..\common\TNsRemoteProcessManager.Infrastructure.UNIX.ProcessController.pas',
  {$ENDIF }
  TNsRemotePublish.Application.Core in '..\common\TNsRemotePublish.Application.Core.pas',
  TNsRemotePublish.Application.DefaultController in '..\common\TNsRemotePublish.Application.DefaultController.pas',
  TNsRemotePublish.Application.HTTPControllers in '..\common\TNsRemotePublish.Application.HTTPControllers.pas',
  TNsRemotePublish.Application.PublishController in '..\common\TNsRemotePublish.Application.PublishController.pas',
  TNsRemotePublish.Application.WarmController in '..\common\TNsRemotePublish.Application.WarmController.pas',
  TNsRemotePublish.Domain.Models.Publish in '..\common\TNsRemotePublish.Domain.Models.Publish.pas',
  TNsRemotePublish.Infrastructure.Compression.Zip in '..\common\TNsRemotePublish.Infrastructure.Compression.Zip.pas',
  TNsRemotePublish.Infrastructure.CompressionFactory in '..\common\TNsRemotePublish.Infrastructure.CompressionFactory.pas',
  TNsRemotePublish.Infrastructure.Config in '..\common\TNsRemotePublish.Infrastructure.Config.pas',
  TNSRemotePublish.Infrastructure.Interfaces.Compression in '..\common\TNSRemotePublish.Infrastructure.Interfaces.Compression.pas',
  TNSRemotePublish.Infrastructure.Interfaces.FileOperations in '..\common\TNSRemotePublish.Infrastructure.Interfaces.FileOperations.pas' {/TNsRemotePublish.Infrastructure.Models.Config in '..\common\TNsRemotePublish.Infrastructure.Models.Config.pas',},
  TNsRemotePublish.Infrastructure.Models.Config in '..\common\TNsRemotePublish.Infrastructure.Models.Config.pas';

//TNsRemotePublish.Infrastructure.Models.Config in '..\common\TNsRemotePublish.Infrastructure.Models.Config.pas',
  //TNsRemotePublish.Infrastructure.PublishFactory in '..\common\TNsRemotePublish.Infrastructure.PublishFactory.pas';

var
  {$IFDEF MSWINDOWS}
  Msg : tagMSG;
  {$ENDIF}
  ListenPort : Integer;

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
      ListenPort := 0;
      if (ParamCount > 0) then Integer.TryParse(ParamStr(1),ListenPort);
      TNsRemotePublishService.Init(ListenPort,TConfigFactory.Create);
      Process;
    end
    else
    begin
      AppService.ServiceName := 'RemotePublishManager';
      AppService.DisplayName := 'REST API for remote file publish';
      {TODO -oTurrican -cGeneral : Load initialization from configuration file.}
      AppService.OnStart := procedure
      begin
        TNsRemotePublishService.Init(8580,TConfigFactory.Create);
      end;
      AppService.CheckParams;
    end;
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
