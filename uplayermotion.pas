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
    MoveFlags: array[0..7] of boolean;

    procedure Attenuate(out aSpeed : Integer);

  public
    ShiftIsHeld:Bool;
    Up,Down,Left,Right: Bool;
    constructor Create(aGame: TForm; aPlayer: TEntity);
    procedure HandleKey(Key:Word; isDown: bool);
    procedure MovePlayer();
    procedure Update();
    procedure DoAtenuate();



  end;

const
  TilesX = 25;
  TilesY = 25;
  TileSize = 100;




implementation

constructor TPlayerMotion.Create(aGame: TForm ; aPlayer:TEntity );
var
  TempBitmap: TBitmap;
  i:Integer;
begin

  Game := aGame;
  Player := aPlayer;
  AttenuateCounter :=0;

  for i :=0 to High(MoveFlags) do MoveFlags[i] := false;



end;

procedure TPlayerMotion.MovePlayer();
begin

end;



procedure TPlayerMotion.HandleKey(Key:Word; isDown: bool);
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

procedure TPlayerMotion.DoAtenuate();
begin
if AttenuateCounter < ATTENUATE_COUNTER_RATE then
  begin
    AttenuateCounter +=1
  end
  else
  begin
  AttenuateCounter :=0;
  Attenuate(Player.VelX);
  Attenuate(Player.VelY);
  end;
end;

procedure TPlayerMotion.Update();
var
  i:Integer;
begin


  if MoveFlags[0] and not MoveFlags[4] then
  begin
    Player.FvelY := -PLAYER_WALK_SPEED;
    Down := False;
  end;

  if MoveFlags[1] and not MoveFlags[5] then
  begin
    Player.FvelY := PLAYER_WALK_SPEED;
    Up := False;
  end;

  if MoveFlags[2] and not MoveFlags[6] then
  begin
    Player.FvelX := -PLAYER_WALK_SPEED;
    Right := False;
  end;

  if MoveFlags[3] and not MoveFlags[7] then
  begin
    Player.FvelX := PLAYER_WALK_SPEED;
    Left := False;
  end;

  //stop flags

    if not MoveFlags[0] and MoveFlags[4] then
  begin
    Player.FvelY := -0;
    Down := False;
  end;

  if not MoveFlags[1] and MoveFlags[5] then
  begin
    Player.FvelY := 0;
    Up := False;
  end;

  if not MoveFlags[2] and MoveFlags[6] then
  begin
    Player.FvelX := -0;
    Right := False;
  end;

  if not MoveFlags[3] and MoveFlags[7] then
  begin
    Player.FvelX := 0;
    Left := False;
  end;

  for i :=0 to High(MoveFlags) do MoveFlags[i] := false;

end;



end.
