unit UHeadsUp;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ExtCtrls, ImageUtils, LCLIntf, LCLType;

type
  THeadsUp = class


  private
    Game: TForm;
    EnergyPixels,HealthPixels:Integer;
    HealthRect, EnergyRect: TRect;
    HealthColor, EnergyColor: TColor;




  public

    constructor Create(aGame: TForm);
    procedure Draw(aCanvas: TCanvas);
    procedure Update();
    procedure SetHealthPercent(Percent: integer);
    procedure SetEnergyPercent(Percent: integer);



  end;

const
  ScreenBorder = 50;
  BarWidth = 100;
  BarHeight = 10;
  BarSpacingY = 20;




implementation

constructor THeadsUp.Create(aGame: TForm);
var
  x, y1, y2: integer;
begin

  Game := aGame;
  HealthColor := clRed;
  EnergyColor := clYellow;
  EnergyPixels := 100;
  HealthPixels := 100;
  x := (Game.Width - ScreenBorder) - BarWidth;
  x := 10;
  y1 := BarSpacingY;
  y2 := y1 + BarSpacingY + BarHeight;
  HealthRect := Rect(x, y1, x + BarWidth, y1 + BarHeight);
  EnergyRect := Rect(x, y2, x + BarWidth, y2 + BarHeight);

end;


procedure THeadsUp.SetHealthPercent(Percent: Integer);
var
  RPixelsFilled: Real;
begin
  //Writeln(Percent);
  RPixelsFilled := (Real(Percent) / Real(100.0)) * Real(BarWidth);
  Self.HealthPixels := Round(RPixelsFilled);
  HealthRect.Width:=Self.HealthPixels;

end;

procedure THeadsUp.SetEnergyPercent(Percent: integer);
var
  RPixelsFilled: Double;
begin
  RPixelsFilled := (Real(Percent) / 100.0) * Real(BarWidth);
  Self.EnergyPixels := Round(RPixelsFilled);
  Self.EnergyRect.Width:=Self.EnergyPixels;
end;

procedure THeadsUp.Update();
begin
  //WorldX +=1;
end;

procedure THeadsUp.Draw(aCanvas: TCanvas);
var

  Canvas: TCanvas;
begin

  //Canvas := Game.Canvas;
  aCanvas.Brush.Color := HealthColor;
  aCanvas.FillRect(HealthRect);
  aCanvas.Brush.Color := EnergyColor;
  aCanvas.FillRect(EnergyRect);
end;

end.
