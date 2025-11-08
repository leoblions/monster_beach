unit TileGrid;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ExtCtrls, ImageUtils, LCLIntf, LCLType;

type
  TTileGrid = class


  private
    Game: TForm;
    SpriteFileName: string;

    //PNG : TPortableNetworkGraphic;
    //Image : TImage;
    TileBitmap: TBitmap;
    Images: array[0..15] of TImage;     // stores background images
    Grid: array[0..24, 1..24] of integer; // stores data for tile map


    procedure LoadImages();
    procedure CreateBlankGrid();
  public

    constructor Create(aGame: TForm; aNum, aWorldX, aWorldY, aKind: integer);
    procedure Draw();
    procedure Update();



  end;

const
  TilesX = 25;
  TilesY = 25;
  TileSize = 100;



implementation

constructor TTileGrid.Create(aGame: TForm; aNum, aWorldX, aWorldY, aKind: integer);
var
  TempBitmap: TBitmap;
begin

  Game := aGame;

  TileBitmap := GetScaledImageFromFileBMP('images/dirt_tile.png', 100, 100);
  CreateBlankGrid();

end;

procedure TTileGrid.CreateBlankGrid();
var
  x, y, Value: integer;
begin
  for y := 0 to 24 do
    for x := 0 to 24 do
      Grid[y, x] := 0;

end;

procedure TTileGrid.LoadImages();
var
  Image1: TImage;
begin

  ;
end;

procedure TTileGrid.Update();
begin
  //WorldX +=1;
end;

procedure TTileGrid.Draw();
var
  SquareSize: integer;
  Canvas: TCanvas;
  x, y, Value, ScreenX,ScreenY: integer;
begin

  //SquareSize := 20;
  Canvas := Game.Canvas;
  for y := 0 to 24 do
    for x := 0 to 24 do
    begin
      Value := Grid[y, x];
      if Assigned(TileBitmap) and (Value = 0) then
      begin
        ScreenX := x * TileSize;
        ScreenY := y * TileSize;
        Canvas.Draw(ScreenX, ScreenY, TileBitmap);
      end
      else
      begin
        WriteLn('tile BMP not assigned');
      end;
    end;

end;

end.
