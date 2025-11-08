unit Player;

{$MODE OBJFPC} //directive to be used for creating classes
{$M+} //directive that allows class constructors and destructors

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls, ImageUtils, LCLIntf, LCLType, GameEnums, Entity;
const
  FRAME_CHANGE_MAX = 5;
  PL_HEIGHT = 100;
  PL_WIDTH = 100;
  PLAYER_WALK_SPEED = 4;
  ATTENUATE_COUNTER_RATE = 5;
var
  AttenuateCounter:Integer;
type

  TPlayer = class(TEntity)


  private
   Game:TForm;
   SpriteFileName : string;
   State : TState;
   PlayerImage: TPortableNetworkGraphic;
   PlayerImages : TPNGArray;
   PlayerImagesLeft : TPNGArray;
   PlayerImagesRight : TPNGArray;

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
    WorldX, WorldY, FVelX, FVelY: Integer;
    Height, Width: Integer;
    Kind, TState, Frame: Integer;
    constructor  Create(aGame:TForm;  aWorldX, aWorldY, aKind : Integer); override;
    procedure Draw(Panel:TPanel); override;
    procedure Update(); override;
    procedure UpdateMoveFlags();
    procedure HandleKey(Key:Word; isDown: bool);



  end;
var
  Amount:Integer;
const
  PlayerWidth = 20;
  PlayerHeight = 20;
  PlayerImagePath =   'images/lizard_monster.png';
  PlayerSheetPath =   'images/monster3_walk.png';
  TilesX = 25;
  TilesY = 25;
  TileSize = 100;

implementation

{ GEntity }

constructor TPlayer.Create(aGame:TForm;  aWorldX, aWorldY, aKind : Integer);
var
  i : Integer;
//  TempBitmap:TBitmap;

begin
  //inherited CreateNew(AOwner, Num);  //constructor calls the base class constructor using the inherited keyword
  for i :=0 to High(MoveFlags) do MoveFlags[i] := false;
  Game := aGame;
  WorldX := aWorldX;
  WorldY := aWorldY;
  Frame := 0;
  FrameChangeCount := 0;
  FVelX:=0;
  FVelY:=0;
  Width := 20;
  Height := 20;
  Kind := aKind;
  LoadImages();


end;

procedure TPlayer.LoadImages();
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
    PNGTemp := ResizePNG(PNGTemp,300,300);
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


procedure TPlayer.Update();

begin
  UpdateMoveFlags;

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


  WorldX += FVelX;
  WorldY += FVelY;

  if FVelX > 0 then
   PlayerImages := PlayerImagesRight
   else if FVelX < 0 then
    PlayerImages := PlayerImagesLeft;

end;

procedure TPlayer.Draw(Panel:TPanel);
var
  SquareSize: integer;
  Canvas: TCanvas;
  TempPNG : TPortableNetworkGraphic;


begin

  SquareSize := 20;
  Canvas := Panel.Canvas;
  Canvas.Brush.Color := clRed;
  Canvas.FillRect(Rect(WorldX, WorldY, WorldX + SquareSize, WorldY + SquareSize));
  PlayerImage :=  PlayerImages[Frame];

  Canvas.Draw(WorldX, WorldY, PlayerImage);

  //update TImage control properties
  TempPNG := PlayerImages[Frame];





end;

procedure TPlayer.HandleKey(Key:Word; isDown: bool);
var
  KeyValue :Integer;
  DirectionIndexPart:Integer;
  StopStartPart,InvertPart:Integer;
begin
  if iSDown then
  begin StopStartPart := 0;
  InvertPart :=4
  end
  else
  begin
  StopStartpart := 4;
  InvertPart :=0
  end;

  KeyValue := Ord(Key);
  case KeyValue of
  VK_UP,VK_W:
    begin
      DirectionIndexPart:=0;
    end;
  VK_DOWN,VK_S:
    begin
     DirectionIndexPart:=1;
    end;
  VK_LEFT,VK_A:
    begin
      DirectionIndexPart:=2;
    end;
  VK_RIGHT,VK_D:
    begin
    DirectionIndexPart:=3;
    end;
  end;

  if isDown then
    begin
      MoveFlags[DirectionIndexPart + 0] := True;
      MoveFlags[DirectionIndexPart + 4] := False
    end
  else
      begin
      writeln('stop ', DirectionIndexPart + 0);
         MoveFlags[DirectionIndexPart + 4] := True;
         MoveFlags[DirectionIndexPart + 0] := False
      end
end;



procedure TPlayer.Attenuate(out aSpeed: Integer);

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

procedure TPlayer.DoAtenuate();
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

procedure TPlayer.UpdateMoveFlags();
var
  i:Integer;
begin


  if MoveFlags[0] and not MoveFlags[4] then
  begin
    Self.FvelY := -PLAYER_WALK_SPEED;
    Down := False;
  end;

  if MoveFlags[1] and not MoveFlags[5] then
  begin
    Self.FvelY := PLAYER_WALK_SPEED;
    Up := False;
  end;

  if MoveFlags[2] and not MoveFlags[6] then
  begin
    Self.FvelX := -PLAYER_WALK_SPEED;
    Right := False;
  end;

  if MoveFlags[3] and not MoveFlags[7] then
  begin
    Self.FvelX := PLAYER_WALK_SPEED;
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

