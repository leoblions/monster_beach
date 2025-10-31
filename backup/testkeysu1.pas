unit testkeysu1;

{$mode objfpc}{$H+}

interface

uses
  TileGrid,Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls, Entity, LCLType, LCLIntf,NameOfKey,GameEnums;

type

  { TForm1 }

  TForm1 = class(TForm)
    Label1: TLabel;
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
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
    procedure SetDirection(Key:Word);
  protected
    procedure Paint; override;
  public
    Player: GEntity;
    TileGrid: TTileGrid;
    PlayerDirection: Direction;
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
  Player := GEntity.Create(Self, 0, 10, 10, 0);
  TileGrid := TTileGrid.Create(self,0,10,10,0);
  Width := 500;
  Height := 500;
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
  //playerX := 0;
  //playerY := 0;
  velX :=1;
  velY :=0;
end;

procedure TForm1.OnTimer(Sender: TObject);   // each frame
begin
  Invalidate;  // calling invalidate triggers onpaint
end;

procedure TForm1.SetDirection(Key:Word);
var
  KeyValue :Integer;
begin
  KeyValue := Ord(Key);
  case KeyValue of
  VK_UP:
    begin
      velX:=0;
      velY:=-1;

    end;
  VK_DOWN:
    begin
      velX:=0;
      velY:=1;

    end;
  VK_LEFT:
    begin
      velX:=-1;
      velY:=0;

    end;
  VK_RIGHT:
    begin
    velX:=1;
    velY:=0;

    end;


  end;



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
  Player.WorldX += velX;
  Player.WorldY += velY;
end;

procedure TForm1.Label1Click(Sender: TObject);
begin

end;

procedure TForm1.FormKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
begin
  WriteLn(Key.toString());
  WriteLn(GetKeyName(Key));
  SetDirection(Key);


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
