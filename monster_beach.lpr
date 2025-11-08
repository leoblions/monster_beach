program monster_beach;



{$mode objfpc}{$H+}

//uses
//  Classes, SysUtils, Forms, Controls, ExtCtrls, StdCtrls, Graphics, Interfaces;
uses
  TileGrid, Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ExtCtrls, Player, LCLType, LCLIntf, Interfaces, NameOfKey, GameEnums,
  Generics.Collections, UHeadsUp, Entity;
const
     FPS = 60;
     TPS = 15;


type
   // used to store settings
  TStrIntDictionary = specialize TDictionary<string, Integer >;
  TStrStrDictionary = specialize TDictionary<string, string >;
  { TMainForm }
  TMainForm = class(TForm)
    procedure OnKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure OnKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
  private

    //Timer: TTimer;
    PlayerImage: TPortableNetworkGraphic;
    FrameTimer: TTimer; // drawing
    TickTimer: TTimer;  // update or tick game logic

    procedure OnTimer(Sender: TObject);
    procedure Tick(Sender: TObject);
    procedure PanelPaint(Sender: TObject);
    //procedure TimerTick(Sender: TObject);
  protected
    //procedure Paint; override;

  public
    Panel: TPanel;
    Player: TPlayer;
    HeadsUp: THeadsUp;
    TileGrid: TTileGrid;
    Frame:Integer;
    //PlayerMotion:TPlayerMotion;
    PlayerDirection: TDirection;
    constructor Create(TheOwner: TComponent); override;
    destructor Destroy; override;
  end;
var
  Game: TMainForm;

{ TMainForm }

constructor TMainForm.Create(TheOwner: TComponent);
begin
  inherited Create(TheOwner);
  // components
  Player := TPlayer.Create(Self,  10, 10, 0);
  TileGrid := TTileGrid.Create(self,0,10,10,0);
  HeadsUp := THeadsUp.Create(Self);
  // window setup
  Caption := 'I SCREAM';
  Position := poScreenCenter;
  Width := 500;
  Height := 500;
  DoubleBuffered := True;

  // Create panel
  Panel := TPanel.Create(Self);
  Panel.Parent := Self;
  Panel.Align := alClient;
  Panel.OnPaint := @PanelPaint;

  // Load PNG image with alpha channel
  PlayerImage := TPortableNetworkGraphic.Create;
  PlayerImage.LoadFromFile(ExtractFilePath(ParamStr(0)) +
                           'images' + DirectorySeparator + 'player.png');

  // Create timer (about 60 FPS)
  //Timer := TTimer.Create(Self);
  //Timer.Interval := 1000 div FPS;
  //Timer.OnTimer := @TimerTick;
  //Timer.Enabled := True;

  // frame loop
  FrameTimer := TTimer.Create(Self);
  FrameTimer.Interval := 1000 div FPS;
  FrameTimer.OnTimer := @Self.OnTimer;
  // game loop
  TickTimer := TTimer.Create(Self);
  TickTimer.Interval := 1000 div TPS;
  TickTimer.OnTimer := @Self.Tick;

  Panel.OnKeyDown:= @OnKeyDown;
  Panel.OnKeyUp:= @OnKeyUp;
end;

destructor TMainForm.Destroy;
begin
  PlayerImage.Free;
  inherited Destroy;
end;

procedure TMainForm.OnKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState
  );
begin
  Self.Player.HandleKey(Key,True);
  //writeln(key.tostring);

end;

procedure TMainForm.OnKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState
  );
begin
  Self.Player.HandleKey(Key,False);
  writeln(key.tostring);

end;

procedure TMainForm.PanelPaint(Sender: TObject);
var
  R: TRect;
  X, Y: Integer;
begin
  // Clear background
  Panel.Canvas.Brush.Color := clWhite;
  Panel.Canvas.FillRect(Panel.ClientRect);

  // Draw a red square in the middle
  Panel.Canvas.Brush.Color := clRed;
  Panel.Canvas.Pen.Color := clRed;

  R.Left := (Panel.Width div 2) - 50;
  R.Top := (Panel.Height div 2) - 50;
  R.Right := R.Left + 100;
  R.Bottom := R.Top + 100;
  Panel.Canvas.Rectangle(R);

  // Draw the PNG image centered over the square
  X := (Panel.Width div 2) - (PlayerImage.Width div 2);
  Y := (Panel.Height div 2) - (PlayerImage.Height div 2);

  Panel.Canvas.Draw(X, Y, PlayerImage);
  Canvas.Brush.Color := clWhite;
  Canvas.FillRect(ClientRect);

  TileGrid.Draw(Panel);
  HeadsUp.Draw();
  Player.Draw(Panel);
end;

procedure TMainForm.Tick(Sender: TObject);
var
  Sender1: TObject;
begin


  TileGrid.Update;
  Player.Update;
  HeadsUp.Update();
end;



procedure TMainForm.OnTimer(Sender: TObject);
begin
  Panel.Invalidate;
end;

var
  MainForm: TMainForm;



begin
  Application.Initialize;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.




