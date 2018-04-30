unit TNsRemotePublish.Infrastructure.CompressionFactory;

interface

uses
  TNsRemotePublish.Infrastructure.Interfaces.Compression,
  TNsRemotePublish.Infrastructure.Compression.Zip,
  {$IFNDEF FPC}
  System.Classes,
  System.SyncObjs,
  System.SysUtils;
  {$ELSE}
  Classes,
  sysutils;
  {$ENDIF}

type
  TCompressionFactory = class
    public
      class function GetInstance(ClassType : string) : ICompression;
  end;

implementation

{ TProcessFactory }

class function TCompressionFactory.GetInstance(ClassType : string) : ICompression;
begin
  if ClassType = 'zip' then Result := TZipCompression.Create;
end;


end.
