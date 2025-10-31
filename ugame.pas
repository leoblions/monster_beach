unit UGame;

{$mode objfpc}{$H+}

interface



uses
  TileGrid,Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ExtCtrls, Entity, LCLType, LCLIntf,NameOfKey,GameEnums,UPlayerMotion;
const
     FRAME_MAX = 60;
type

  { TForm1 }

  TForm1 = class(TForm)
    Label1: TLabel;
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
    procedure FormKeyUp(Sender: TObject; var Key: word; Shift: TShiftState);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: integer);
    procedure FormMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: integer);
    procedure FormResize(Sender: TObject);
    procedure Label1Click(Sender: TObject);

  private
    FrameTimer: TTimer; // drawing
    TickTimer: TTimer;  // update or tick game logic

    procedure OnTimer(Sender: TObject);
    procedure Tick(Sender: TObject);

  protected
    procedure Paint; override;
  public
    Player: TEntity;
    TileGrid: TTileGrid;
    Frame:Integer;
    PlayerMotion:TPlayerMotion;
    PlayerDirection: TDirection;
    constructor CreateNew(Aowner: TComponent; Num: integer = 0); override;


  end;

var
  Game: TForm1;
  playerX, playerY: integer;
  velX,velY:Integer;


implementation

{$R *.lfm}

{ TForm1 }

constructor TForm1.CreateNew(Aowner: TComponent; Num: integer);
begin
  inherited CreateNew(AOwner, Num);
  Player := TEntity.Create(Self, 0, 10, 10, 0);
  TileGrid := TTileGrid.Create(self,0,10,10,0);
  PlayerMotion := TPlayerMotion.Create(Self,Self.Player);
  Width := 500;
  Height := 500;
  Frame := 0;
  Caption := 'A1 IMPALER';
  DoubleBuffered := True;
  // frame loop
  FrameTimer := TTimer.Create(Self);
  FrameTimer.Interval := 1000 div 60;
  FrameTimer.OnTimer := @Self.OnTimer;
  // game loop
  TickTimer := TTimer.Create(Self);
  TickTimer.Interval := 1000 div 15;
  TickTimer.OnTimer := @Self.Tick;

end;

procedure TForm1.OnTimer(Sender: TObject);   // each frame
begin
  Invalidate;  // calling invalidate triggers onpaint
end;







procedure TForm1.Paint;
var
  SquareSize, X, Y: integer;
begin
  Canvas.Brush.Color := clWhite;
  Canvas.FillRect(ClientRect);
 // SquareSize := 20;
 // X := (ClientWidth - SquareSize) div 2;
 // Y := (ClientHeight - SquareSize) div 2;
 // Canvas.Brush.Color := clRed;
 // Canvas.FillRect(Rect(Player.WorldX, Player.WorldY, Player.WorldX + SquareSize, Player.WorldY + SquareSize));
 TileGrid.Draw();
  Player.Draw();

end;

procedure TForm1.Tick(Sender: TObject);
var
  Sender1: TObject;
begin


  TileGrid.Update;
  Player.Update;
  PlayerMotion.Update();
end;

procedure TForm1.Label1Click(Sender: TObject);
begin

end;

procedure TForm1.FormKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
begin
  WriteLn(Key.toString());
  WriteLn(GetKeyName(Key));
  if TShiftStateEnum.ssLeft in Shift then
     PlayerMotion.ShiftIsHeld := True
  else
      PlayerMotion.ShiftIsHeld := False;
  PlayerMotion.SetDirection(Key);


end;

procedure TForm1.FormKeyUp(Sender: TObject; var Key: word; Shift: TShiftState);
begin
  if TShiftStateEnum.ssLeft in Shift then
     PlayerMotion.ShiftIsHeld := True
  else
      PlayerMotion.ShiftIsHeld := False ;
  PlayerMotion.KeyUp(Key);


end;

procedure TForm1.FormMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: integer);
begin

end;

procedure TForm1.FormMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: integer);
begin

end;

procedure TForm1.FormResize(Sender: TObject);
begin

end;

procedure TForm1.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin

end;

end.
