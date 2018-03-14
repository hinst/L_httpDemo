unit httpAppU;

interface

uses
  Classes, SysUtils, fphttpapp, fpwebfile, fpHttp, httpDefs;

type

  { TApp }

  TApp = class
  private
    function GetClientFileDir: string;
  public
    procedure Run;
    property ClientFileDir: string read GetClientFileDir;
  end;

  { TGreeter }

  TGreeter = class(TCustomHTTPModule)
  private
    function GetTemplate: string;
  public
    property Template: string read GetTemplate;
    procedure HandleRequest(aRequest : TRequest; aResponse : TResponse); override;
  end;

implementation

{ TApp }

function TApp.GetClientFileDir: string;
begin
  result := ExtractFilePath(Application.ExeName) + 'clientFiles';
end;

procedure TApp.Run;
begin
  MimeTypesFile := ExtractFilePath(Application.ExeName) + 'mimeTypes.txt';
  Application.Initialize;
  RegisterFileLocation('static', ClientFileDir);
  RegisterHTTPModule('greet', TGreeter, True);
  RegisterHTTPModule('', TGreeter, True);
  Application.Port := 8080;
  Application.Run;
end;

{ TGreeter }

function TGreeter.GetTemplate: string;
var
  f: TFileStream;
begin
  f := TFileStream.Create(ExtractFilePath(Application.ExeName) + 'clientFiles\main.html', fmOpenRead);
  SetLength(result, f.Size);
  f.Read(result[1], f.Size);
  f.Free;
end;

// Обработчик запроса
procedure TGreeter.HandleRequest(aRequest: TRequest; aResponse: TResponse);
var
  who: string;
  response: string;
begin
  who := aRequest.QueryFields.Values['who'];
  if who = '' then
    who := 'unknown';
  response := StringReplace(Template, '$value', who, [rfReplaceAll]);
  aResponse.Content := response;
end;

end.

