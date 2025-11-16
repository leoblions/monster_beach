unit CSVUtils;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, StrUtils;

// Define a type for our 2D dynamic integer array
type
  TIntegerArray2D = array of array of Integer;

// Function to read a CSV file into a 2D integer array
function ReadCSVToIntegerArray(const FileName: string; const Delimiter: Char = ','): TIntegerArray2D;

// Procedure to write a 2D integer array to a CSV file (overwrites existing file)
procedure WriteIntegerArrayToCSV(const FileName: string; const Data: TIntegerArray2D; const Delimiter: Char = ',');

implementation

function ReadCSVToIntegerArray(const FileName: string; const Delimiter: Char): TIntegerArray2D;
var
  SL: TStringList;
  RowIndex, ColIndex, RowCount, ColCount: Integer;
  Line, CellStr: string;
  Cells: TStringArray;
begin
  Result := nil;
  SL := nil;

  if not FileExists(FileName) then
    WriteLn('Can''t find the file', FileName);
    Exit;

  try
    // Load the entire file into a StringList (one line per entry)
    SL := TStringList.Create;
    SL.LoadFromFile(FileName);

    RowCount := SL.Count;
    if RowCount = 0 then Exit;

    // Determine the number of columns from the first row
    Cells := SplitString(SL[0], Delimiter);
    ColCount := Length(Cells);

    // Initialize the 2D dynamic array
    SetLength(Result, RowCount, ColCount);

    // Iterate through all rows and columns to populate the array
    for RowIndex := 0 to RowCount - 1 do
    begin
      Line := SL[RowIndex];
      Cells := SplitString(Line, Delimiter);

      // Handle cases where some rows might have fewer columns (fill with 0 or handle error as needed)
      if Length(Cells) < ColCount then
        SetLength(Cells, ColCount);

      for ColIndex := 0 to ColCount - 1 do
      begin
        CellStr := Trim(Cells[ColIndex]);
        try
          // Attempt to convert the string cell value to an integer
          Result[RowIndex, ColIndex] := StrToInt(CellStr);
        except
          // Handle non-numeric data (e.g., set to 0 or raise an exception)
          on E: Exception do
          begin
            Writeln(Format('Warning: Non-integer value found at Row %d, Col %d. Value: "%s". Error: %s',
              [RowIndex, ColIndex, CellStr, E.Message]));
            Result[RowIndex, ColIndex] := 0; // Default to 0 on error
          end;
        end;
      end;
    end;

  finally
    if Assigned(SL) then
      SL.Free;
  end;
end;

procedure WriteIntegerArrayToCSV(const FileName: string; const Data: TIntegerArray2D; const Delimiter: Char);
var
  SL: TStringList;
  RowIndex, ColIndex: Integer;
  CurrentRowStrings: TStringList;
  RowString: string;
  RowCount, ColCount: Integer;
begin
  // Get dimensions of the input array
  RowCount := Length(Data);
  if RowCount = 0 then Exit;
  // Assumes all rows have the same length as the first row
  ColCount := Length(Data[0]);

  SL := TStringList.Create;
  CurrentRowStrings := TStringList.Create;
  try
    for RowIndex := 0 to RowCount - 1 do
    begin
      CurrentRowStrings.Clear;
      // Convert each integer in the row back to a string
      for ColIndex := 0 to ColCount - 1 do
      begin
        CurrentRowStrings.Add(IntToStr(Data[RowIndex, ColIndex]));
      end;
      // Join the strings with the delimiter
      RowString := CurrentRowStrings.DelimitedText;
      CurrentRowStrings.Delimiter := Delimiter; // Ensure Delimiter is used for joining
      RowString := CurrentRowStrings.DelimitedText; // This is a slightly verbose way to use DelimitedText for joining

      // A more direct way to join with a specific delimiter:
      RowString := '';
      for ColIndex := 0 to ColCount - 1 do
      begin
          RowString := RowString + IntToStr(Data[RowIndex, ColIndex]);
          if ColIndex < ColCount - 1 then
              RowString := RowString + Delimiter;
      end;

      SL.Add(RowString);
    end;

    // Save the StringList to the file.
    // This action overwrites the file if it exists, which matches the requirement.
    SL.SaveToFile(FileName);

  finally
    if Assigned(SL) then
      SL.Free;
    if Assigned(CurrentRowStrings) then
      CurrentRowStrings.Free;
  end;
end;

end.

