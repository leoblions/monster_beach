unit GameEngine;

{$mode ObjFPC}{$H+}



interface

uses
  Classes, SysUtils, Entity, TileGrid, Forms, Controls, Graphics, Projectile, Player,
  Dialogs, StdCtrls, LCLType, LCLIntf, ExtCtrls, Enemy,Utils;

const
  MAX_ENTITIES = 10;
  INVALID_SLOT = -1;
  PLAYER_KIND = 'p';
  ENEMY_KIND = 'e';
  PROJECTILE_SPEED_1 = 10;
  PROJECTILE_SPEED_2 = 13;


type
  EntityArray = array [0..MAX_ENTITIES] of TEntity;

  TGameEngine = class
  private

    function GetUnusedIndex(): integer;
  public
    Form: TForm;
    Panel: TPanel;
    Entities: EntityArray;
    Player: TPlayer;
    constructor Create(aForm: TForm; aPanel: TPanel);
    procedure AddEntity(aEntity: TEntity);
    procedure AddEnemy(aWorldX, aWorldY, aEnemyKind: integer);
    procedure Update();
    procedure OnKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
    procedure OnKeyUp(Sender: TObject; var Key: word; Shift: TShiftState);
    procedure FireProjectile();

  end;

implementation

constructor TGameEngine.Create(aForm: TForm; aPanel: TPanel);
var
  i: integer;
begin
  for i := 0 to High(Entities) do
    Entities[i] := nil;

  Self.Form := aForm;
  Self.Panel := aPanel;
end;




{
 add an entity to the array, created somewhere else
}
procedure TGameEngine.AddEntity(aEntity: TEntity);
var
  NewSlot: integer;
begin
  NewSlot := GetUnusedIndex();
  if (INVALID_SLOT <> NewSlot) then
  begin
    Self.Entities[NewSlot] := aEntity;
    if aEntity.EntityKind = PLAYER_KIND then
    begin

      Self.Player := TPlayer(aEntity);

      WriteLn('Added Player to slot ', NewSlot);
    end;

    if aEntity.EntityKind = 'e' then
    begin

      WriteLn('Added Enemy to slot ', NewSlot);
    end;

    //Self.Player := TPlayer(aEntity);
    ;
  end
  else
    writeln('failed to add entity in gameengine');

end;

{
 add an enemy to the array by kind
}
procedure TGameEngine.AddEnemy(aWorldX, aWorldY, aEnemyKind: integer);
var
  NewSlot: integer;
  Enemy: TEnemy;
begin
  Enemy := TEnemy.Create(Self.Form, aWorldX, aWorldY, aEnemyKind);
  NewSlot := GetUnusedIndex();
  if (INVALID_SLOT <> NewSlot) then
  begin
    Self.Entities[NewSlot] := Enemy;


    if Enemy.EntityKind = 'e' then
    begin

      WriteLn('Added Enemy to slot ', NewSlot);
    end;

    ;
  end
  else
    writeln('failed to add enemy in gameengine');

end;

procedure TGameEngine.FireProjectile();
var
  Projectile: TProjectile;
  x, y, w, h: integer;
  VelX, VelY: longint;
begin

  VelX := 0;
  VelY := 0;
  x := 0;
  y := 0;
  w := 5;
  h := 5;
  case Self.Player.Direction of
    'u':
    begin
      VelY := (-PROJECTILE_SPEED_1);
      x += 25;
      y -= 20;
      h += 20;
    end;

    'd':
    begin
      VelY := (PROJECTILE_SPEED_1);
      x += 25;
      y += 100;
      h += 20;
    end;
    'l':
    begin
      VelX := (-PROJECTILE_SPEED_1);
      x -= 20;
      y += 50;
      w += 20;
    end;

    'r':
    begin
      VelX := (PROJECTILE_SPEED_1);
      x += 60;
      y += 50;
      w += 20;
    end;

  end;
  Projectile := TProjectile.Create(Form, Player.X + x, Player.Y + y, 0);
  Projectile.SetVelocity(longint(VelX), longint(VelY));
  Projectile.Width := w;
  Projectile.Height := h;

  AddEntity(Projectile);

end;

function TGameEngine.GetUnusedIndex(): integer;
var
  i: integer;
  CurrEntity: TEntity;
begin
  for i := 0 to High(Self.Entities) do
  begin
    CurrEntity := Self.Entities[i];
    if (nil = CurrEntity) then
    begin
      Result := i;
      Exit;
    end;
    if (CurrEntity.IsAlive() = False) and (CurrEntity.EntityKind <> PLAYER_KIND) then
    begin
      CurrEntity.Destroy();
      Self.Entities[i] := nil;
      Result := i;
      Exit;

    end;
  end;

  WriteLn('GameEngine failed to find open slot for Entity');
  Result := INVALID_SLOT;
end;



{
Enemy motion and collision update
}
procedure TGameEngine.Update();
var
  i, j: integer;
  collided : boolean;
  PlayerX, PlayerY: integer;
  EntityA, EntityB: TEntity;
begin
  PlayerX := Player.X;
  PlayerY := Player.Y;
  //first entity
  for i := 0 to High(Self.Entities) do
  begin
    EntityA := Self.Entities[i];
    if (EntityA.EntityKind = ENEMY_KIND) then
    TEnemy(EntityA).SetPlayerTargetPosition(PlayerX,PlayerY);
    if (nil <> EntityA) and (EntityA.IsAlive()) then
    begin
      //second entity
      for j := 0 to High(Self.Entities) do
      begin
        EntityB := Self.Entities[j];
        if (nil <> EntityB) and (EntityB <> EntityA) and (EntityB.IsAlive()) then
        begin
           collided := Intersects(EntityA,EntityB);
           if(collided) then
           Writeln('Collide entities');

        end;

      end;

    end;

  end;

end;


procedure TGameEngine.OnKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
var
  KeyValue: integer;
begin
  KeyValue := Ord(Key);
  case KeyValue of
    VK_F, VK_SPACE:
    begin
      FireProjectile();
      WriteLn('fire pressed');
    end;
    VK_E:
    begin
      WriteLn('action pressed');
    end;
    otherwise
      Exit;
  end;

end;

procedure TGameEngine.OnKeyUp(Sender: TObject; var Key: word; Shift: TShiftState);
begin
  //Self.Player.HandleKey(Key,False);
  //writeln(key.tostring);

end;

end.
