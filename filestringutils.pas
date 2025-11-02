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

// Appends a single string as a new line to the given file
procedure AppendLineToFile(const FileName: string; const Line: string);

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

procedure AppendLineToFile(const FileName: string; const Line: string);
var
  SL: TStringList;
begin
  SL := TStringList.Create;
  try
    // If file exists, load it first
    if FileExists(FileName) then
      SL.LoadFromFile(FileName);
    // Add the new line
    SL.Add(Line);
    // Save back
    SL.SaveToFile(FileName);
  finally
    SL.Free;
  end;
end;

end.

