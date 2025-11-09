unit Projectile;

{$MODE OBJFPC}//directive to be used for creating classes
{$M+}//directive that allows class constructors and destructors

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ExtCtrls, ImageUtils, LCLIntf, LCLType, GameEnums, Entity;

const
  FRAME_CHANGE_MAX = 5;
  PL_HEIGHT = 100;
  PL_WIDTH = 100;
  PLAYER_WALK_SPEED = 4;
  ATTENUATE_COUNTER_RATE = 5;
  FRAME_SEQ_MAX = 3;



type

  TProjectile = class(TEntity)


  private
    Game: TForm;
    SpriteFileName: string;
    State: TState;
    AttenuateCounter: integer;
    PlayerImage: TPortableNetworkGraphic;
    PlayerImages: TPNGArray;
    PlayerImagesLeft: TPNGArray;
    PlayerImagesRight: TPNGArray;

    MoveFlags: array[0..7] of boolean;



    FrameChangeCount: integer;
    PlayerPNG: TPortableNetworkGraphic;
    Image: TImage;
    //motion
    ShiftIsHeld: Bool;
    Up, Down, Left, Right: Bool;
    procedure Attenuate(out aSpeed: integer);
    procedure DoAtenuate();
    procedure LoadImages();
  protected
    House: real;
    //procedure Paint; override;
  public
    //Height, Width: Integer;
    Kind, TState, Frame: integer;
    constructor Create(aGame: TForm; aWorldX, aWorldY, aKind: integer); override;
    procedure Draw(aCanvas:TCanvas); override;
    procedure Update(); override;
    procedure SetVelocity(aVelX, aVelY: integer);




  end;



const
  PlayerWidth = 20;
  PlayerHeight = 20;
  TilesX = 25;
  TilesY = 25;
  TileSize = 100;

implementation


constructor TProjectile.Create(aGame: TForm; aWorldX, aWorldY, aKind: integer);
var
  i: integer;
begin
  //inherited CreateNew(AOwner, Num);  //constructor calls the base class constructor using the inherited keyword
  for i := 0 to High(MoveFlags) do MoveFlags[i] := False;
  Game := aGame;
  FX := aWorldX;
  FY := aWorldY;
  Frame := 0;
  FrameChangeCount := 0;
  FVelX := 0;
  FVelY := 0;
  Width := 7;
  Height := 7;
  Kind := aKind;
  EntityKind := 'r';
  Health := 25;
  LoadImages();
  // init image arrays

end;

procedure TProjectile.SetVelocity(aVelX, aVelY: integer);
begin
  WriteLn('set pro ', aVelX);
  Self.VelX := aVelX;
  Self.VelY := aVelY;

end;

procedure TProjectile.LoadImages();
begin

end;


procedure TProjectile.Update();
begin

  // WriteLn('update pro ',FVelX);
  FX += FVelX;
  FY += FVelY;
  if Health > 0 then
    Health := Health - 1;

end;

procedure TProjectile.Draw(aCanvas:TCanvas);
var
  SquareSize: integer;
  //Canvas: TCanvas;
  TempPNG: TPortableNetworkGraphic;
begin

  SquareSize := 20;
  aCanvas := Panel.Canvas;
  aCanvas.Brush.Color := clRed;
  aCanvas.FillRect(Rect(FX, FY, FX + Width, FY + Height));

end;




procedure TProjectile.Attenuate(out aSpeed: integer);
begin
  if (aSpeed > 0) and (aSpeed >= 1) then
  begin
    aSpeed -= 1;
  end
  else if (aSpeed < 0) and (aSpeed <= -1) then
  begin
    aSpeed += 1;
  end
  else
  begin
    aSpeed := 0;
  end;

end;

procedure TProjectile.DoAtenuate();
begin
  if AttenuateCounter < ATTENUATE_COUNTER_RATE then
  begin
    AttenuateCounter += 1;
  end
  else
  begin
    AttenuateCounter := 0;
    Attenuate(Self.FVelX);
    Attenuate(Self.FVelY);
  end;
end;


end.
