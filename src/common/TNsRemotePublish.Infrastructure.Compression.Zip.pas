unit TNsRemotePublish.Infrastructure.Compression.Zip;

interface

uses
  TNSRemotePublish.Infrastructure.Interfaces.Compression,
  {$IFDEF  FPC}
  Classes,
  SysUtils,
  {$ELSE}
  System.Classes,
  System.SysUtils,
  {$ENDIF}
  AbZipper,
  AbUtils,
  AbArcTyp,
  AbBase,
  AbUnzper;

type

  { TZipCompression }

  TZipCompression = class(TInterfacedObject, ICompression)
    private
      fonprocessevent : TOnProcessEvent;
      fcanceloperation : Boolean;
      fCurrentFile : string;
      procedure OnZipProcessSelf(Sender : TObject; Item : TAbArchiveItem; Progress : Byte; var Abort : Boolean);
      procedure OnCompressionItemFail(Sender : TObject; Item : TAbArchiveItem; ProcessType : TAbProcessType; ErrorClass : TAbErrorClass; ErrorCode : Integer);
    public
      function AddFileToCompressionBytesFromBytes(CompressionBytes : TBytes; FileBytes : TBytes) : TBytes;
      function AddFileToCompressionBytesFromDisk(const Path : string; CompressionBytes : TBytes) : TBytes;
      function AddDiskDirectoryToBytes(const Path : string) : TBytes;
      procedure AddDiskDirectoryToCompressionDisk(const Path: string; FilenamePath : string);
      function StreamCompressToBytes(Stream : TStream): TBytes;
      function StreamCompressToStream(Stream : TStream) : TStream;
      function StringCompressToBytes(const str : string): TBytes;
      function StringCompressToString(const str : string) : string;
      function ExtractFromDiskToBytes(const Path : string) : TBytes;
      function ExtractFromDiskToStream(const Path : string) : TStream;
      procedure ExtractFromStreamToDisk(Stream : TStream; const Destination : string);
      procedure ExtractFromBytesToDisk(CompressionBytes : TBytes; const Path : string);
      procedure ExtractFromDiskToDisk(const Source, Destination : string);
      procedure SubscribeOnProcess(Event: TOnProcessEvent);
      procedure CancelCurrentOperation;
  end;

const
  IORETRIES = 5;


implementation

{ TZipCompression }

function TZipCompression.AddDiskDirectoryToBytes(const Path: string): TBytes;
begin
  raise ENotImplemented.Create('TZipCompression.AddDiskDirectoryToBytes(const Path: string) is Not implemented yet!');
end;

procedure TZipCompression.AddDiskDirectoryToCompressionDisk(const Path: string; FilenamePath: string);
begin
  raise ENotImplemented.Create('TZipCompression.AddDiskDirectoryToCompressionDisk(const Path: string; FilenamePath: string) is Not implemented yet FPC!');
end;

function TZipCompression.AddFileToCompressionBytesFromBytes(
  CompressionBytes: TBytes; FileBytes: TBytes): TBytes;
begin
  raise ENotImplemented.Create('TZipCompression.AddFileToCompressionBytesFromBytes(CompressionBytes, FileBytes: TBytes): TBytes; is Not implemented yet!');
end;

function TZipCompression.AddFileToCompressionBytesFromDisk(const Path: string;CompressionBytes: TBytes): TBytes;
begin
  raise ENotImplemented.Create('TZipCompression.AddFileToCompressionBytesFromDisk(const Path: string;CompressionBytes: TBytes): TBytes; is Not implemented yet!');
end;

procedure TZipCompression.CancelCurrentOperation;
begin
  fcanceloperation := True;
end;

procedure TZipCompression.ExtractFromBytesToDisk(CompressionBytes: TBytes; const Path: string);
begin
  raise ENotImplemented.Create(' TZipCompression.ExtractFromBytesToDisk(CompressionBytes: TBytes; const Path: string is Not implemented yet!');
end;

function TZipCompression.ExtractFromDiskToBytes(const Path: string): TBytes;
begin

end;

procedure TZipCompression.ExtractFromDiskToDisk(const Source,Destination: string);
begin
  //
end;

function TZipCompression.ExtractFromDiskToStream(const Path: string): TStream;
begin
  raise ENotImplemented.Create('TZipCompression.ExtractFromDiskToStream(const Path: string): TStream; is Not implemented yet!');
end;

procedure TZipCompression.ExtractFromStreamToDisk(Stream : TStream; const Destination : string);
var
  abunziper : TAbUnZipper;
begin
  if not DirectoryExists(destination) then
  begin
    try
      ForceDirectories(destination);
    except
      on e : Exception do raise Exception.Create(e.Message);
    end;
  end;
  abunziper := TAbUnZipper.Create(nil);
  try
    try
      abunziper.OnProcessItemFailure := OnCompressionItemFail;
      abunziper.OnArchiveItemProgress:= OnZipProcessSelf;
      abunziper.ExtractOptions:=[eoCreateDirs,eoRestorePath];
      abunziper.BaseDirectory := Destination;
      abunziper.Stream := stream;
      abunziper.ExtractFiles('*.*');
    except
      on e : Exception do raise Exception.Create(e.Message);
    end;
  finally
    abunziper.Free;
  end;
end;

procedure TZipCompression.OnCompressionItemFail(Sender: TObject; Item: TAbArchiveItem; ProcessType: TAbProcessType; ErrorClass: TAbErrorClass; ErrorCode: Integer);
begin
  if Assigned(fonprocessevent) and (fCurrentFile <> Item.FileName) then
  begin
    fCurrentFile := Item.FileName; //send only one event per file
    fonprocessevent(Self, Item.FileName, 0, True);
  end;
end;

procedure TZipCompression.OnZipProcessSelf(Sender : TObject; Item : TAbArchiveItem; Progress : Byte; var Abort : Boolean);
begin
  abort := fcanceloperation;
  if Assigned(fonprocessevent) and (fCurrentFile <> Item.FileName) then
  begin
    fCurrentFile := Item.FileName; //send only one event per file
    fonprocessevent(Self, Item.FileName, 0);
  end;
end;

function TZipCompression.StreamCompressToBytes(Stream: TStream): TBytes;
begin
  raise ENotImplemented.Create('TZipCompression.StreamCompressToBytes(Stream: TStream): TBytes; is Not implemented yet!');
end;

function TZipCompression.StreamCompressToStream(Stream: TStream): TStream;
begin
  raise ENotImplemented.Create('TZipCompression.StreamCompressToStream(Stream: TStream): TStream; is Not implemented yet!');
end;

function TZipCompression.StringCompressToBytes(const str: string): TBytes;
begin
  raise ENotImplemented.Create('TZipCompression.StringCompressToBytes(const str: string): TBytes; is Not implemented yet!');
end;

function TZipCompression.StringCompressToString(const str: string): string;
begin
  raise ENotImplemented.Create('TZipCompression.StringCompressToString(const str: string): string; is Not implemented yet!');
end;

procedure TZipCompression.SubscribeOnProcess(Event: TOnProcessEvent);
begin
  fonprocessevent := Event;
end;

end.
