unit TNsRemotePublish.Infrastructure.Compression.Zip;

interface

uses
  TNSRemotePublish.Infrastructure.Interfaces.Compression,
  {$IFNDEF FPC}
  System.Classes, System.Zip, System.SysUtils;
  {$ELSE}
  Classes,
  sysutils,
  AbZipper,
  AbArcTyp,
  AbBase,
  AbUnzper;
  {$ENDIF}

type

  { TZipCompression }

  TZipCompression = class(TInterfacedObject, ICompression)
    private
      fonprocessevent : TOnProcessEvent;
      fcanceloperation : Boolean;
      {$IFNDEF FPC}
      procedure OnZipProcessSelf(Sender: TObject; FileName: string; Header: TZipHeader; Position: Int64);
      {$ELSE}
      procedure OnZipProcessSelf(Sender : TObject; Item : TAbArchiveItem; Progress : Byte; var Abort : Boolean);
      {$ENDIF}
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


implementation

{ TZipCompression }

function TZipCompression.AddDiskDirectoryToBytes(const Path: string): TBytes;
begin
  raise ENotImplemented.Create('TZipCompression.AddDiskDirectoryToBytes(const Path: string) is Not implemented yet!');
end;

procedure TZipCompression.AddDiskDirectoryToCompressionDisk(const Path: string; FilenamePath: string);
begin
  {$IFNDEF FPC}
  TZipFile.ZipDirectoryContents(FilenamePath, Path, zcDeflate, OnZipProcessSelf);
  {$ELSE}
  raise ENotImplemented.Create('TZipCompression.AddDiskDirectoryToCompressionDisk(const Path: string; FilenamePath: string) is Not implemented yet FPC!');
  {$ENDIF}
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
  {$IFNDEF FPC}
  with TZipFile.Create do
  begin
    try
      Open(Path, TZipMode.zmRead);
      Read(Path, Result);
    finally
      Close;
      Free;
    end;
  end;
  {$ELSE}
  //
  {$ENDIF}
end;

procedure TZipCompression.ExtractFromDiskToDisk(const Source,Destination: string);
begin
  {$IFNDEF FPC}
  with TZipFile.Create do
  begin
    try
      Open(Source, TZipMode.zmRead);
      OnProgress := OnZipProcessSelf;
      ExtractAll(Destination);;
    finally
      Close;
      Free;
    end;
  end;
  {$ELSE}
  //
  {$ENDIF}
end;

function TZipCompression.ExtractFromDiskToStream(const Path: string): TStream;
begin
  raise ENotImplemented.Create('TZipCompression.ExtractFromDiskToStream(const Path: string): TStream; is Not implemented yet!');
end;

procedure TZipCompression.ExtractFromStreamToDisk(Stream : TStream; const Destination : string);
  {$IFDEF FPC}
  var
  abunziper : TAbUnZipper;
  {$ENDIF}
begin
  {$IFNDEF FPC}
  with TZipFile.Create do
  begin
    try
      Open(Stream, TZipMode.zmRead);
      OnProgress := OnZipProcessSelf;
      ExtractAll(Destination);
    finally
      Close;
      Free;
    end;
  end;
  {$ELSE}
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
  {$ENDIF}
end;

{$IFNDEF FPC}
procedure TZipCompression.OnZipProcessSelf(Sender: TObject; FileName: string; Header: TZipHeader; Position: Int64);
begin
  if fcanceloperation then
  begin
    fcanceloperation := False;
    // do something with cancellation
  end
  else
  if Assigned(fonprocessevent) then fonprocessevent(Self, FileName, Position);
end;
{$ELSE}
procedure TZipCompression.OnZipProcessSelf(Sender : TObject; Item : TAbArchiveItem; Progress : Byte; var Abort : Boolean);
begin
  abort := fcanceloperation;
  if Assigned(fonprocessevent) then fonprocessevent(Self, Item.FileName, 0);
end;

{$ENDIF}

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
