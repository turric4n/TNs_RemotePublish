unit TNSRemotePublish.Infrastructure.Interfaces.FileOperations;

interface

type

  IFileOperations = interface
    procedure Copy(const src, dst : string);
    procedure Move(const src, dst : string);
    procedure Delete(const src : string);
    procedure Touch(const src : string);
  end;

implementation

end.
