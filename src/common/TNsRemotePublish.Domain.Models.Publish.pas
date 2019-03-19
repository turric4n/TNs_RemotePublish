unit TNsRemotePublish.Domain.Models.Publish;

interface

type
  TPublish = class(TInterfacedObject)
    private
      fpublishpath : string;
      fprojectname : string;
      fartifactname : string;
      fslotname : string;
      fslotpath : string;
      fservername : string;
      freleasename : string;
      fisawebsite : Boolean;
    public
      property PublishPath : string read fpublishpath write fpublishpath;
      property ProjectName : string read fprojectname write fprojectname;
      property ArtifactName : string read fartifactname write fartifactname;
      property SlotName : string read fslotname write fslotname;
      property SlotPath : string read fslotpath write fslotpath;
      property ServerName : string read fservername write fservername;
      property ReleaseName : string read freleasename write freleasename;
      property IsAWebsite : Boolean read fisawebsite write fisawebsite;
  end;

implementation

end.
