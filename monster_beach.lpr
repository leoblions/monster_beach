program monster_beach;



{$mode objfpc}{$H+}

//uses
//  Classes, SysUtils, Forms, Controls, ExtCtrls, StdCtrls, Graphics, Interfaces;
uses
  TileGrid,
  Classes,
  SysUtils,
  Forms,
  Controls,
  Graphics,
  Dialogs,
  StdCtrls,
  ExtCtrls,
  Player,
  LCLType,
  LCLIntf,
  Interfaces,
  NameOfKey,
  GameEnums,
  Generics.Collections,
  UHeadsUp,
  Entity,
  Projectile,
  Utils,
  GameEngine,
  ResourceManager,
  Enemy;

const
  FPS = 60;
  TPS = 15;


type
  // used to store settings
  TStrIntDictionary = specialize TDictionary<string, integer>;
  TStrStrDictionary = specialize TDictionary<string, string>;
  { TMainForm }
  TMainForm = class(TForm)
    procedure OnKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
    procedure OnKeyUp(Sender: TObject; var Key: word; Shift: TShiftState);
  private

    //Timer: TTimer;
    BGImage: TPortableNetworkGraphic;
    FrameTimer: TTimer; // drawing
    TickTimer: TTimer;  // update or tick game logic
    FBackBuffer: TBitmap; // For manual double buffering
    procedure OnTimer(Sender: TObject);
    procedure Tick(Sender: TObject);
    procedure PanelPaint(Sender: TObject);
    procedure  FormResize(Sender: TObject);
    //procedure TimerTick(Sender: TObject);
  protected
    //procedure Paint; override;

  public
    Panel: TPanel;
    Player: TPlayer;
    HeadsUp: THeadsUp;
    TileGrid: TTileGrid;
    GameEngine: TGameEngine;
    Frame: integer;
    //PlayerMotion:TPlayerMotion;
    PlayerDirection: TDirection;
    constructor Create(TheOwner: TComponent); override;
    destructor Destroy; override;
  end;


  { TMainForm }

  constructor TMainForm.Create(TheOwner: TComponent);
  begin
    inherited Create(TheOwner);
    // components
    Player := TPlayer.Create(Self, 200, 200, 0);
    TileGrid := TTileGrid.Create(self, 0, 10, 10, 0);
    HeadsUp := THeadsUp.Create(Self);

    // window setup
    Caption := 'I SCREAM';
    Position := poScreenCenter;
    Width := 500;
    Height := 500;
    DoubleBuffered := True;

    // BackBuffer
    // Initialize the back buffer for double buffering
    FBackBuffer := TBitmap.Create;
    // Set the initial size of the buffer to the panel size


    //FBackBuffer.SetSize(Panel.Width,Panel.Height);
    FBackBuffer.Width := 500;
    FBackBuffer.Height := 500;


    // Create panel
    Panel := TPanel.Create(Self);
    Panel.Parent := Self;
    Panel.Align := alClient; //so it resizes with the form.
    Panel.OnPaint := @PanelPaint;

    // game engine setup
    GameEngine := TGameEngine.Create(Self, Panel);
    GameEngine.AddEntity(Player);
    GameEngine.AddEnemy(300, 300, 0);

    // Load PNG image with alpha channel
    BGImage := TPortableNetworkGraphic.Create;
    BGImage.LoadFromFile(ExtractFilePath(ParamStr(0)) +
      'images' + DirectorySeparator + 'top_down_beach.png');



    // frame loop
    FrameTimer := TTimer.Create(Self);
    FrameTimer.Interval := 1000 div FPS;
    FrameTimer.OnTimer := @Self.OnTimer;
    // game loop
    TickTimer := TTimer.Create(Self);
    TickTimer.Interval := 1000 div TPS;
    TickTimer.OnTimer := @Self.Tick;

    Panel.OnKeyDown := @OnKeyDown;
    Panel.OnKeyUp := @OnKeyUp;
  end;

  destructor TMainForm.Destroy;
  begin
    BGImage.Free;
    inherited Destroy;
  end;

  procedure TMainForm.FormResize(Sender: TObject);
  begin
    // Print new dimensions to the console when the window is resized
    Writeln('Window resized to: ', Width, 'x', Height);

     //Resize the back buffer to match the panel's new dimensions
    if Assigned(FBackBuffer) then
    begin
      FBackBuffer.Width := Panel.Width;
      FBackBuffer.Height := Panel.Height;
    end;
  end;

  procedure TMainForm.OnKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
  begin
    Self.Player.HandleKey(Key, True);
    Self.GameEngine.OnKeyDown(Sender, Key, Shift);
    //writeln(key.tostring);

  end;

  procedure TMainForm.OnKeyUp(Sender: TObject; var Key: word; Shift: TShiftState);
  begin
    Self.Player.HandleKey(Key, False);
    Self.GameEngine.OnKeyUp(Sender, Key, Shift);
    writeln(key.tostring);

  end;







  procedure TMainForm.PanelPaint(Sender: TObject);
  var
    R: TRect;
    X, Y, i: integer;
    Entity: TEntity;
    CBuffer, CDraw:TCanvas;

  begin
    CDraw :=  Panel.Canvas;
    CBuffer := FBackBuffer.Canvas;

    // Clear background
    CBuffer.Brush.Color := clWhite;
    CBuffer.FillRect(Panel.ClientRect);

    CBuffer.Draw(0, 0, BGImage);


    //TileGrid.Draw(CBuffer);
    for i := 0 to High(GameEngine.Entities) do
    begin
      if not Assigned(FBackBuffer) then Exit;

      Entity := GameEngine.Entities[i];
      if (nil <> Entity) and (Entity.IsAlive()) then
      begin
        Entity.Draw(CBuffer);
      end;

    end;
    HeadsUp.Draw();

    CDraw.Draw(0, 0, FBackBuffer);
    // flip the image from buffer to panel
  end;







  procedure TMainForm.Tick(Sender: TObject);
  var
    Sender1: TObject;
    i: integer;
    Entity: TEntity;
  begin

    TileGrid.Update;
    //Player.Update;
    GameEngine.Update;
    for i := 0 to High(GameEngine.Entities) do
    begin
      Entity := GameEngine.Entities[i];
      if (nil <> Entity) and (Entity.IsAlive()) then
      begin
        Entity.Update;
      end;

    end;
    HeadsUp.Update();

  end;



  procedure TMainForm.OnTimer(Sender: TObject);
  begin
    Panel.Invalidate;
  end;

var
  MainForm: TMainForm;



begin
  Application.Scaled := True;
  Application.Initialize;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
