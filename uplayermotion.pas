unit UPlayerMotion;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ExtCtrls, ImageUtils, LCLIntf, LCLType,Entity;

const
  PLAYER_WALK_SPEED = 4;
  ATTENUATE_COUNTER_RATE = 5;


type
  TPlayerMotion = class
   AttenuateCounter:Integer;

  private
    Game: TForm;
    Player:TEntity;

    procedure Attenuate(out aSpeed : Integer);

  public
    ShiftIsHeld:Bool;
    constructor Create(aGame: TForm; aPlayer: TEntity);
    procedure SetDirection(Key:Word);
    procedure KeyUp(Key:Word);
    procedure MovePlayer();
    procedure Update();



  end;

const
  TilesX = 25;
  TilesY = 25;
  TileSize = 100;



implementation

constructor TPlayerMotion.Create(aGame: TForm ; aPlayer:TEntity );
var
  TempBitmap: TBitmap;
begin

  Game := aGame;
  Player := aPlayer;
  AttenuateCounter :=0;



end;

procedure TPlayerMotion.MovePlayer();
begin

end;

procedure TPlayerMotion.SetDirection(Key:Word);
var
  KeyValue :Integer;
  CurrentSpeed : Integer;
begin
  CurrentSpeed := PLAYER_WALK_SPEED;
  if ShiftIsHeld then
     CurrentSpeed +=2;
  KeyValue := Ord(Key);
  case KeyValue of
  VK_UP:
    begin
      Player.velY:=-CurrentSpeed;
    end;
  VK_DOWN:
    begin
      Player.velY:=CurrentSpeed;
    end;
  VK_LEFT:
    begin
      Player.velX:=-CurrentSpeed;
    end;
  VK_RIGHT:
    begin
    Player.velX:=CurrentSpeed;
    end;
  end;

end;

procedure TPlayerMotion.KeyUp(Key:Word);
var
  KeyValue :Integer;
begin
  KeyValue := Ord(Key);
  case KeyValue of
  VK_UP:
    begin
      Attenuate(Player.velY);
    end;
  VK_DOWN:
    begin
      Attenuate(Player.velY);
    end;
  VK_LEFT:
    begin
      Attenuate(Player.velX);
    end;
  VK_RIGHT:
    begin
    Attenuate(Player.velX);
    end;
  end;

end;

procedure TPlayerMotion.Attenuate(out aSpeed: Integer);

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

procedure TPlayerMotion.Update();
begin
  if AttenuateCounter < ATTENUATE_COUNTER_RATE then
  begin
    AttenuateCounter +=1
  end
  else
  begin
  AttenuateCounter :=0;
  Attenuate(Player.velX);
  Attenuate(Player.velY);
  end;
end;



end.
