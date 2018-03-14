program httpServerApp;

uses
  httpAppU;

(* Demo locations:

http://localhost:8080/
http://localhost:8080/greet
http://localhost:8080/static/main.html

*)

var
  app: TApp;
begin
  app := TApp.Create;
  app.Run;
  app.Free;
end.

