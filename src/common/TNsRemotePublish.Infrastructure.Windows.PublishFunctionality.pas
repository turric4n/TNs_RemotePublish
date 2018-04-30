unit TNsRemotePublish.Infrastructure.Windows.PublishFunctionality;

interface

uses
  TNSRemotePublish.Domain.Interfaces.PublishFunctionality,
  TNSRemotePublish.Infrastructure.LoggerFactory,
  TNSRemotePublish.Domain.Models.Publish,
  System.SysUtils,
  System.Generics.Collections,
  System.Classes;

type
  TNSRemotePMPublish = class(TPublish, IPublishFunctionality)
    private
      fartifact : TStream;
    public
      constructor Create(Stream : TStream);
      destructor Destroy;
      function Extract : Boolean;
      function Copy : Boolean;
      function Move : Boolean;
      function Rename : Boolean;
  end;

implementation

{TNSRemotePMProcess}

function TNSRemotePMPublish.Copy: Boolean;
begin
  raise ENotImplemented.Create('Not implemented');
end;

constructor TNSRemotePMPublish.Create(Stream : TStream);
begin
  fartifact := Stream;
end;

destructor TNSRemotePMPublish.Destroy;
begin
  inherited;
end;


function TNSRemotePMPublish.Extract: Boolean;
begin
  with TZipFile.Create do
  begin
    try
      for dest in job.FDestination.Split([',']) do
      begin
        Open(zipfile, TZipMode.zmRead);
        OnProgress := OnUnpackProgress;
        ExtractAll(dest);
      end;
    finally
      Free;
      zipfile.Free;
    end;
  end;
end;

function TNSRemotePMPublish.Move: Boolean;
begin
  raise ENotImplemented.Create('Not implemented');
end;

function TNSRemotePMPublish.Rename: Boolean;
begin
  raise ENotImplemented.Create('Not implemented');
end;

end.
