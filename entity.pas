unit Entity;

{$MODE OBJFPC} //directive to be used for creating classes
{$M+} //directive that allows class constructors and destructors

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls, ImageUtils, LCLIntf, LCLType, GameEnums;
const
  FRAME_CHANGE_MAX = 5;
type
  TEntity = class


  private
   Game:TForm;
   SpriteFileName : string;
   State : TState;
   PlayerImage: TImage;
   PlayerImages : TPNGArray;
   PlayerImagesLeft : TPNGArray;
   PlayerImagesRight : TPNGArray;

   FrameChangeCount : Integer;
   PlayerPNG : TPortableNetworkGraphic;
   Image : TImage;


   procedure LoadImages();
  protected
  House:real;
    //procedure Paint; override;
  public
    WorldX, WorldY, VelX, VelY: Integer;
    Height, Width: Integer;
    Kind, TState, Frame: Integer;
    constructor Create(aGame:TForm; aNum , aWorldX, aWorldY, aKind : Integer);
    procedure Draw();
    procedure Update();



  end;
var
  Amount:Integer;
const
  PlayerWidth = 20;
  PlayerHeight = 20;
  PlayerImagePath =   'images/lizard_monster.png';
  PlayerSheetPath =   'images/monster3_walk.png';

implementation

{ GEntity }

constructor TEntity.Create(aGame:TForm; aNum , aWorldX, aWorldY, aKind : Integer);
var
  TempBitmap:TBitmap;

begin
  //inherited CreateNew(AOwner, Num);  //constructor calls the base class constructor using the inherited keyword

  Game := aGame;
  WorldX := aWorldX;
  WorldY := aWorldY;
  Frame := 0;
  FrameChangeCount := 0;
  VelX:=0;
  VelY:=0;
  Width := 20;
  Height := 20;
  Kind := aKind;
  LoadImages();


end;

procedure TEntity.LoadImages();
var
  Image1: TImage;
  PNGTemp: TPortableNetworkGraphic;
  i: Integer;
begin

  Image := TImage.Create(Game);
  Image.Parent := Game;
  Image.SetBounds(WorldX, WorldY, 100, 100);
  Image.Stretch := True;
  Image.Proportional := True;

  PlayerPNG := TPortableNetworkGraphic.Create;
  try
    PlayerPNG.LoadFromFile(PlayerSheetPath);
    WriteLn('PNG height ',  PlayerPNG.height);
    //PlayerPNG:= GetSubimagePNG2(PlayerPNG,200,300,100,100);
    PlayerPNG:= ExtractTransparentSubPNG(PlayerPNG,0,0,150,200);
     //PlayerPNG:= ExtractTransparentSubPNG(PlayerPNG,150,200,0,0);

    Image.Picture.Assign(PlayerPNG);

    // spritesheet
    PNGTemp := TPortableNetworkGraphic.Create;
    PNGTemp.LoadFromFile(PlayerSheetPath);
    PlayerImagesLeft := cutSpritesheetPNG( PNGTemp,4,1,150,200);
    PNGTemp :=  FlipXPNG(PNGTemp);
    PlayerImagesRight := cutSpritesheetPNG( PNGTemp,4,1,150,200);
    PlayerImages := PlayerImagesRight;
    //for i := 0 to High(PlayerImages) do
    //begin
    //  PlayerImages[i] :=  FlipXPNG(PlayerImages[i]);
    //end;
    //PlayerPNG :=   PlayerImages[0];

  except
    on E: Exception do
      ShowMessage('Failed to load PNG: ' + E.Message);

  end;


end;


procedure TEntity.Update();

begin

   if (FrameChangeCount > FRAME_CHANGE_MAX) then
    begin

      FrameChangeCount :=0;

      if(Frame >  3) then
          Frame := 0
      else
          Frame += 1 ;
      end
    else
        begin
          FrameChangeCount +=1;
        end;


  WorldX += velX;
  WorldY += velY;

  if velX > 0 then
   PlayerImages := PlayerImagesRight
   else if velX < 0 then
    PlayerImages := PlayerImagesLeft;

end;

procedure TEntity.Draw();
var
  SquareSize: integer;
  Canvas: TCanvas;
  TempPNG : TPortableNetworkGraphic;

begin

  SquareSize := 20;
  Canvas := Game.Canvas;
  Canvas.Brush.Color := clRed;
  Canvas.FillRect(Rect(WorldX, WorldY, WorldX + SquareSize, WorldY + SquareSize));

  //update TImage control properties
  TempPNG := PlayerImages[Frame];

  Image.Picture.Assign(PlayerImages[Frame]);
  if Assigned(Image) then
     begin
        Image.SetBounds(WorldX, WorldY, 100, 100);
         //Image.Free;
         //Image := nil;

     end;



end;

     end.

