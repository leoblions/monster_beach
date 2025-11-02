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

    HealthRect, EnergyRect: TRect;
    HealthColor, EnergyColor: TColor;




  public

    constructor Create(aGame: TForm);
    procedure Draw();
    procedure Update();



  end;

const
  ScreenBorder = 50;
  BarWidth = 100;
  BarHeight = 30;
  BarSpacingY = 50;



implementation

constructor THeadsUp.Create(aGame: TForm );
var
  x,y1, y2 : Integer;
begin

  Game := aGame;
  HealthColor := clRed;
  EnergyColor := clYellow;
  x := (Game.width - ScreenBorder) - BarWidth;
  x:= 10;
  y1 := BarSpacingY;
  y2 := y1 + BarSpacingY + BarHeight;
  HealthRect := Rect(x,y1,x+BarWidth,y1+BarHeight);
  EnergyRect := Rect(x,y2,x+BarWidth,y2+BarHeight);




end;





procedure THeadsUp.Update();
begin
  //WorldX +=1;
end;

procedure THeadsUp.Draw();
var

  Canvas: TCanvas;

begin


  Canvas := Game.Canvas;
  Canvas.Brush.Color := HealthColor;
  Canvas.FillRect(HealthRect);
  Canvas.Brush.Color := EnergyColor;
  Canvas.FillRect(EnergyRect);
end;

end.
