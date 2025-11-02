unit FileStringUtils;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

type
  TStringArray = array of string;

// Reads all lines from a text file into a dynamic array of strings
function ReadFileToStringArray(const FileName: string): TStringArray;

// Writes a dynamic array of strings to a text file
procedure WriteStringArrayToFile(const FileName: string; const Lines: TStringArray);

implementation

function ReadFileToStringArray(const FileName: string): TStringArray;
var
  SL: TStringList;
  i: Integer;
begin
  SL := TStringList.Create;
  try
    SL.LoadFromFile(FileName);
    SetLength(Result, SL.Count);
    for i := 0 to SL.Count - 1 do
      Result[i] := SL[i];
  finally
    SL.Free;
  end;
end;

procedure WriteStringArrayToFile(const FileName: string; const Lines: TStringArray);
var
  SL: TStringList;
  i: Integer;
begin
  SL := TStringList.Create;
  try
    for i := 0 to High(Lines) do
      SL.Add(Lines[i]);
    SL.SaveToFile(FileName);
  finally
    SL.Free;
  end;
end;

end.

