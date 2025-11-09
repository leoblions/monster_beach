// Entity.pas
unit Entity;
interface
uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls, ImageUtils, LCLIntf, LCLType, GameEnums;
type
  TEntity = class
  protected
    FVelX, FVelY: Integer;  // velocity
    FX, FY: Integer;    // position
    FWidth, FHeight: Integer;
    FActive: Boolean;
    FForm : TForm;
    FHealth:Integer;

  public
    EntityKind: char;
    constructor Create(aGame:TForm;  aWorldX, aWorldY, aKind : Integer);  virtual;
    destructor Destroy; override;
    procedure Update(DeltaTime: Single); virtual; abstract;
    procedure Update(); virtual; abstract;
    procedure Draw(aPanel: TPanel); virtual; abstract;
    procedure Collide(Other: TEntity); virtual; abstract;
    function IsAlive(): boolean;
    property X: Integer read FX write FX;
    property Y: Integer read FY write FY;
    property VelX: Single read FVelX write FVelX;
    property VelY: Single read FVelY write FVelY;
    property Width: Integer read FWidth write FWidth;
    property Height: Integer read FHeight write FHeight;
    property Active: Boolean read FActive write FActive;
    property Health: Integer read FHealth write FHealth;
  end;


implementation
constructor TEntity.Create(aGame:TForm;  aWorldX, aWorldY, aKind : Integer);


begin
  FX:= aWorldX;
  FY:=aWorldY;
  FForm := aGame;
  EntityKind := 'g';


end;

destructor TEntity.Destroy();

begin



end;

function TEntity.IsAlive():boolean;
begin
    Result := Self.FHealth > 0;
end;

end.

//In Pascal, single refers to a single-precision floating-point number type,
//  a 32-bit data type for storing real numbers. It uses 1 bit for the sign,
//    8 bits for the exponent, and 23 bits for the mantissa, offering about 7 digits of precision.
//    The single type is often the fastest floating-point type and has the lowest
//    storage requirement among floating-point types

