program pascalgui;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}
  cthreads,
  {$ENDIF}
  {$IFDEF HASAMIGA}
  athreads,
  {$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms,Entity, NameOfKey, GameEnums, testkeysu1, TileGrid
  { you can add units after this };

{$R *.res}

begin
  RequireDerivedFormResource:=True;
  //Application.Scaled:=True;
  //{$PUSH}{$WARN 5044 OFF}
  //Application.MainFormOnTaskbar:=True;
  //{$POP}
  Application.Initialize;
  Application.CreateForm(  TForm1, Game);
  Application.Run;
end.

