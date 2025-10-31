unit GameEnums;



{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils;

type
    Direction = (Up, Down, Left,Right,None);
    State = (Attack,Walk,Die,Hit,Follow,Stand);
    EntityKind = (Player,Troglodyte,Rat,Wolf,Dragon);




implementation

end.

