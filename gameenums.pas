unit GameEnums;



{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils;

type
    TDirection = (Up, Down, Left,Right,None);
    TState = (Attack,Walk,Die,Hit,Follow,Stand);
    TEntityKind = (Player,Troglodyte,Rat,Wolf,Dragon);




implementation

end.

