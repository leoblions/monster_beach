unit Enemy;

{$MODE OBJFPC} //directive to be used for creating classes
{$M+} //directive that allows class constructors and destructors

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls, ImageUtils, LCLIntf, LCLType, GameEnums, Entity;
const
  FRAME_CHANGE_MAX = 5;
  PL_HEIGHT = 100;
  PL_WIDTH = 100;
  WALK_SPEED = 2;
  STOP_CHASE_DISTANCE = 25;
  ATTENUATE_COUNTER_RATE = 5;
  SPRITES_PER_ROW = 6;
  FRAME_SEQ_MAX = 3;

var
  AttenuateCounter:Integer;
  CurrentImages,Enemy0LW, Enemy0RW, Enemy0UW,Enemy0DW,Enemy0AW,Enemy0SW:TPNGArray;
type

  TEnemy = class(TEntity)


  private
   Game:TForm;
   SpriteFileName : string;
   State : TState;
   CurrentImage: TPortableNetworkGraphic;
   PlayerImages : TPNGArray;
   PlayerImagesLeft : TPNGArray;
   PlayerImagesRight : TPNGArray;
   PlayerX,PlayerY:Integer;

   MoveFlags: array[0..7] of boolean;



   FrameChangeCount : Integer;
   PlayerPNG : TPortableNetworkGraphic;
   Image : TImage;
   //motion
   ShiftIsHeld:Bool;
    Up,Down,Left,Right: Bool;
    //constructor Create(aGame: TForm; aPlayer: TEntity);
    procedure Attenuate(out aSpeed : Integer);


    procedure DoAtenuate();


   procedure LoadImages();
  protected
  House:real;
    //procedure Paint; override;
  public
   //FVelX, FVelY: Integer;
    Direction:Char;
    //Height, Width: Integer;
    Kind, TState, Frame: Integer;

    constructor  Create(aGame:TForm;  aWorldX, aWorldY, aKind : Integer); override;
    procedure Draw(Panel:TPanel); override;
    procedure Update(); override;
    procedure UpdateMoveFlags();
    procedure ChooseDirection();
    procedure SetPlayerTargetPosition(aPlayerX,aPlayerY:Integer);




  end;



const
  DefaultWidth = 20;
  DefaultHeight = 20;
  ImagePath0 =   'images/enemy1cut.png';
  ImagePath1 =   'images/monster3_walk.png';



implementation

{ GEntity }

constructor TEnemy.Create(aGame:TForm;  aWorldX, aWorldY, aKind : Integer);
var
  i : Integer;
//  TempBitmap:TBitmap;

begin
  //inherited CreateNew(AOwner, Num);  //constructor calls the base class constructor using the inherited keyword
  for i :=0 to High(MoveFlags) do MoveFlags[i] := false;
  Game := aGame;
  X := aWorldX;
  Y := aWorldY;
  PlayerX :=0;
  PlayerY :=0;
  Frame := 0;
  FrameChangeCount := 0;
  FVelX:=0;
  FVelY:=0;
  Width := DefaultWidth;
  Height := DefaultHeight;
  Kind := aKind;
  Health := 100;
  EntityKind := 'e';
  LoadImages();
  Direction := 'r';
  // init image arrays



end;

procedure TEnemy.SetPlayerTargetPosition(aPlayerX,aPlayerY:Integer);
begin
  PlayerX := aPlayerX;
  PlayerY := aPlayerY;
end;

procedure TEnemy.LoadImages();
var
  Image1: TImage;
  PNGTemp: TPortableNetworkGraphic;
  i: Integer;
begin

  //Image := TImage.Create(Game);
  //Image.Parent := Game;
  //Image.SetBounds(X, Y, 100, 100);
  //Image.Stretch := True;
  //Image.Proportional := True;
  //
  //PlayerPNG := TPortableNetworkGraphic.Create;
  //try
  //  PlayerPNG.LoadFromFile(PlayerSheetPath);
  //
  //
  //  PlayerPNG:= ExtractTransparentSubPNG(PlayerPNG,0,0,150,200);
  //
  //
  //  Image.Picture.Assign(PlayerPNG);
  //
    // spritesheet
  try
    PNGTemp := TPortableNetworkGraphic.Create;
    PNGTemp.LoadFromFile(ImagePath0);

    //PlayerImagesLeft := cutSpritesheetPNG( PNGTemp,4,1,150,100);
    //PNGTemp :=  FlipXPNG(PNGTemp);
    //PlayerImagesRight := cutSpritesheetPNG( PNGTemp,4,1,100,100);
    //PlayerImages := PlayerImagesRight;


  except
    on E: Exception do
    begin
      ShowMessage('Failed to load PNG: ' + E.Message);
    end;
  end;

  ////PNGTemp :=  TPortableNetworkGraphic.Create;
  //PNGTemp.LoadFromFile('images/hero2cut.png');
  //WriteLn('sheet height ', PNGTemp.Height);
  // cut images from sprite sheet
  // walk left
  Enemy0LW := GetRowPNG(PNGTemp,0,0,100,100,SPRITES_PER_ROW);
  // walk right
  Enemy0RW := FlipXRowPNG(Enemy0LW);
  // walk up
  Enemy0UW := GetRowPNG(PNGTemp,0,500,100,100,SPRITES_PER_ROW);
  // walk down
  Enemy0DW := GetRowPNG(PNGTemp,0,400,100,100,SPRITES_PER_ROW);
  Enemy0AW := GetRowPNG(PNGTemp,0,400,100,100,SPRITES_PER_ROW);
  Enemy0SW := GetRowPNG(PNGTemp,0,300,100,100,SPRITES_PER_ROW);


  CurrentImages := Enemy0LW;




end;


procedure TEnemy.Update();

begin
  UpdateMoveFlags;

   if (FrameChangeCount > FRAME_CHANGE_MAX) then
    begin

      FrameChangeCount :=0;

      if(Frame >=  FRAME_SEQ_MAX) then
          Frame := 0
      else
          Frame += 1 ;

      end
    else
        begin
          FrameChangeCount +=1;
        end;


  Self.FX += FVelX;
  Self.FY += FVelY;

  if FVelX > 0 then
   begin
   PlayerImages := Enemy0RW;
   Self.Direction := 'r';
   end
   else if FVelX < 0 then
    begin
      PlayerImages := Enemy0LW;
      Direction := 'l';
    end;

  if FVelY < 0 then
   begin
       PlayerImages := Enemy0UW ;
       Direction := 'u';
   end
   else if  FVelY > 0 then
    begin
         PlayerImages :=  Enemy0DW ;
          Direction := 'd';
    end;

end;

procedure TEnemy.Draw(Panel:TPanel);
var
  SquareSize: integer;
  Canvas: TCanvas;
  TempPNG : TPortableNetworkGraphic;



begin
  SquareSize := 20;
  Canvas := Panel.Canvas;
  ////Canvas.Brush.Color := clBlue;
  //Canvas.FillRect(Rect(FX, FY, FX + SquareSize, FY + SquareSize));
  CurrentImage :=  CurrentImages[Frame];

  Canvas.Draw(FX, FY, CurrentImage);

  //update TImage control properties
  TempPNG := PlayerImages[Frame];





end;

procedure TEnemy.ChooseDirection();
var
  KeyValue :Integer;
  DirectionIndexPart:Integer;
  StopStartPart,InvertPart:Integer;
  //PlayerX, PlayerY:Integer;
begin
  // reset flags
   MoveFlags[ 0] := False;
   MoveFlags[ 1] := False;
   MoveFlags[ 2] := False;
   MoveFlags[ 3] := False;
   // get player location



end;



procedure TEnemy.Attenuate(out aSpeed: Integer);

begin
   if (aSpeed > 0) and (aSpeed >=1) then
   begin
     aSpeed -=1
   end
   else if  (aSpeed < 0) and (aSpeed <=-1) then
   begin
     aSpeed +=1
     end
   else
   begin
   aSpeed :=0
   end;


end;

procedure TEnemy.DoAtenuate();
begin
if AttenuateCounter < ATTENUATE_COUNTER_RATE then
  begin
    AttenuateCounter +=1
  end
  else
  begin
  AttenuateCounter :=0;
  Attenuate(Self.FVelX);
  Attenuate(Self.FVelY);
  end;
end;

procedure TEnemy.UpdateMoveFlags();
var
  i:Integer;
begin


  if PlayerY < FY +STOP_CHASE_DISTANCE then
  begin
    Self.FvelY := -WALK_SPEED;
    Down := False;
  end;

  if PlayerY > FY -STOP_CHASE_DISTANCE then
  begin
    Self.FvelY := WALK_SPEED;
    Up := False;
  end;

  if PlayerX < FX +STOP_CHASE_DISTANCE then
  begin
    Self.FvelX := -WALK_SPEED;
    Right := False;
  end;

  if PlayerX > FX -STOP_CHASE_DISTANCE then
  begin
    Self.FvelX := WALK_SPEED;
    Left := False;
  end;

  //stop flags

    if not MoveFlags[0] and MoveFlags[4] then
  begin
    Self.FvelY := -0;
    Down := False;
  end;

  if not MoveFlags[1] and MoveFlags[5] then
  begin
    Self.FvelY := 0;
    Up := False;
  end;

  if not MoveFlags[2] and MoveFlags[6] then
  begin
    Self.FvelX := -0;
    Right := False;
  end;

  if not MoveFlags[3] and MoveFlags[7] then
  begin
    Self.FvelX := 0;
    Left := False;
  end;

  for i :=0 to High(MoveFlags) do MoveFlags[i] := false;

end;

end.

