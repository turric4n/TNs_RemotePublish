unit TNSRemotePublish.Infrastructure.HTTPMVCRequest;

interface

uses
  System.SysUtils,
  SynCommons,
  SynCrtSock,
  mORMot,
  TNSRemotePublish.Infrastructure.HTTPRequest;

type
  TMVCRequest = class(TRequest)
    private
      fcontext : THttpServerRequest;
    public
      constructor Create(HTTPServerRequest : THttpServerRequest);
      destructor Destroy;
      property HTTPContext : THttpServerRequest read fcontext write fcontext;
  end;

implementation

{ TIRespository }

constructor TMVCRequest.Create(HTTPServerRequest : THttpServerRequest);
begin
  fcontext := HTTPServerRequest;
  fparameters := string(fcontext.URL).Substring(1).Split(['/']);
  if Length(fparameters) = 0 then
  begin
    SetLength(fparameters, 1);
    fparameters[0] := '/';
  end;
  fmethod := fcontext.Method;
  BruteURL := fcontext.URL;
end;

destructor TMVCRequest.Destroy;
begin
  inherited;
end;

end.

