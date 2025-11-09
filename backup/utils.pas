unit Utils;

interface



uses
  Graphics, Types, Interfaces, Forms, Controls, ExtCtrls, Classes, GraphType,
  SysUtils, Dialogs, FPReadPNG, FPImage, intfgraphics;

type
  TPNGArray = array [0..30]  of TPortableNetworkGraphic;
  EMyCustomException = class(Exception); // Define a custom exception class

  function Intersects(A, B: TEntity): Boolean;


implementation

function Intersects(A, B: TEntity): Boolean;
begin
  Result := (A.X < B.X + B.Width) and
            (A.X + A.Width > B.X) and
            (A.Y < B.Y + B.Height) and
            (A.Y + A.Height > B.Y);
end;


end.
