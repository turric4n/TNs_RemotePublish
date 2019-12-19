unit TNsRemotePublish.Infrastructure.Interfaces.Compression;

interface

uses
  {$IFNDEF FPC}
  System.Classes,
  System.SysUtils;
  {$ELSE}
  Classes,
  sysutils;
  {$ENDIF}

type
  TOnProcessEvent = procedure(Sender : TObject; const Filename : string; Position: Int64; Failure : Boolean = False) of object;

  ICompression = interface['{06475E05-906E-473F-8928-4A15B50955DE}']
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

end.
