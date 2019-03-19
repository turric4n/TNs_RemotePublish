unit TNsRemotePublish.Infrastructure.PublishFactory;

interface

uses
  TNSRemotePublish.Domain.Interfaces.PublishFunctionality,
  {$IFDEF LINUX}
  TNSRemotePublish.Infrastructure.UNIX.PublishFunctionality,
  {$ELSE}
  TNSRemotePublish.Infrastructure.Windows.PublishFunctionality,
  {$ENDIF}
  System.Classes,
  System.SyncObjs,
  System.SysUtils;

type
  TPublishFactory = class
    public
      class function GetInstance(Stream : TMemoryStream) : IPublishFunctionality;
  end;

implementation

{ TProcessFactory }

class function TPublishFactory.GetInstance(Stream : TMemoryStream) : IPublishFunctionality;
begin
  Result := TNSRemotePMPublish.Create(Stream);
end;


end.

