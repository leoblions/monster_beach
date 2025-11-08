unit ImageUtils;

interface



uses
  Graphics, Types, Interfaces, Forms, Controls, ExtCtrls, Classes, GraphType,
  SysUtils, Dialogs, FPReadPNG, FPImage, intfgraphics;

type
  TPNGArray = array [0..30] of TPortableNetworkGraphic;

function GetSubImage(SourceBitmap: TBitmap; const SubRect: TRect): TBitmap;
function GetScaledImageFromFile(URL: string; aNewWidth, aNewHeight: integer): TBitmap;
function GetScaledImageFromFileBMP(URL: string; aNewWidth, aNewHeight: integer): TBitmap;
function GetScaledImageFromFilePNG(URL: string;
  aNewWidth, aNewHeight: integer): TPortableNetworkGraphic;
function getSubimagePNG(inputPNG: TPortableNetworkGraphic;
  aStartX, aStartY, aNewWidth, aNewHeight: integer): TPortableNetworkGraphic;
function getSubimagePNG2(inputPNG: TPortableNetworkGraphic;
  aStartX, aStartY, aNewWidth, aNewHeight: integer): TPortableNetworkGraphic;
function cutSpritesheetPNG(inputPNG: TPortableNetworkGraphic;
  aCols, aRows, aWidth, aHeight: integer): TPNGArray;
function ExtractTransparentSubPNG(Source: TPortableNetworkGraphic;
  startX, startY, Width, Height: integer): TPortableNetworkGraphic;
function FlipXPNG(Source: TPortableNetworkGraphic): TPortableNetworkGraphic;
function ResizePNG(Source: TPortableNetworkGraphic; aNewWidth, aNewHeight:Integer): TPortableNetworkGraphic;

implementation

function GetSubImage(SourceBitmap: TBitmap; const SubRect: TRect): TBitmap;
var
  DestBitmap: TBitmap;
begin
  // Create a new bitmap for the subimage.
  DestBitmap := TBitmap.Create;
  try
    // Set the new bitmap's size to match the dimensions of the sub-rectangle.
    DestBitmap.SetSize(SubRect.Width, SubRect.Height);

    // Copy the specified rectangular area from the source bitmap's canvas
    // to the destination bitmap's canvas.
    // The Draw method automatically handles the copying.
    DestBitmap.Canvas.CopyRect(
      Rect(0, 0, SubRect.Width, SubRect.Height), // Destination rectangle
      SourceBitmap.Canvas,                        // Source canvas
      SubRect                                     // Source rectangle
      );

    // Return the newly created bitmap.
    Result := DestBitmap;
  except
    // If an error occurs, free the bitmap to prevent a memory leak.
    DestBitmap.Free;
    raise;
  end;
end;



function GetScaledImageFromFile(URL: string; aNewWidth, aNewHeight: integer): TBitmap;
var
  Original: TBitmap;
  Scaled: TBitmap;
  Image: TImage;
  //Result := nil;
begin
  Result := nil;
  try
    //Image := TImage.Create(nil);
    Original := TBitmap.Create;
    Scaled := TBitmap.Create;
    try
      Original.LoadFromFile(URL);
      Scaled.SetSize(aNewWidth, aNewHeight);
      Scaled.Canvas.StretchDraw(Rect(0, 0, aNewWidth, aNewHeight), Original);

      //Image.Picture.Assign(Scaled);
      //Image.AutoSize := True;
      //Image.Visible := True;
      Result := Scaled;
    finally
      Original.Free;
      Scaled.Free;
    end;
  except
    on E: Exception do
      ShowMessage('Failed to load or scale image: ' + E.Message);
  end;
  //Result := Scaled;
end;


function GetScaledImageFromFileBMP(URL: string; aNewWidth, aNewHeight: integer): TBitmap;
var
  Original: TBitmap;

  Image: TImage;
  PNG: TPortableNetworkGraphic;
  ScaledBitmap: TBitmap;
begin
  Result := nil;
  try

    Original := TBitmap.Create;

    try
      PNG := TPortableNetworkGraphic.Create;
      ScaledBitmap := TBitmap.Create;

      PNG.LoadFromFile(URL);
      ScaledBitmap.SetSize(100, 100);
      ScaledBitmap.Canvas.StretchDraw(Rect(0, 0, aNewWidth, aNewHeight), PNG);

      Result := ScaledBitmap;
    finally

      PNG.Free;
    end;
  except
    on E: Exception do
      ShowMessage('Failed to load or scale image: ' + E.Message);
  end;
  //Result := Scaled;
end;

(*

Provided a URL to a PNG file.   It creates 2 png objects.
*)


function GetScaledImageFromFilePNG(URL: string;
  aNewWidth, aNewHeight: integer): TPortableNetworkGraphic;
var

  OriginalPNG: TPortableNetworkGraphic;
  ScaledPNG: TPortableNetworkGraphic;
begin
  Result := nil;
  OriginalPNG := TPortableNetworkGraphic.Create;
  ScaledPNG := TPortableNetworkGraphic.Create;
  try



    OriginalPNG.LoadFromFile(URL);

    ScaledPNG := TPortableNetworkGraphic.Create;
    ScaledPNG.Assign(OriginalPNG);
    ScaledPNG.SetSize(aNewWidth, aNewHeight);
    ScaledPNG.Canvas.StretchDraw(Rect(0, 0, aNewWidth, aNewHeight), OriginalPNG);

    Result := ScaledPNG;

  finally

    OriginalPNG.Free;
  end;

end;

function GetSubimagePNG(InputPNG: TPortableNetworkGraphic;
  aStartX, aStartY, aNewWidth, aNewHeight: integer): TPortableNetworkGraphic;
var

  SubImage: TPortableNetworkGraphic;
  SourceRect, SubRect: TRect;
begin
  Result := TPortableNetworkGraphic.Create;
  // Clear destination canvas with transparency

  SubRect := Rect(aStartX, aStartY, aStartX + aNewWidth, aStartY + aNewHeight);
  Result.SetSize(SubRect.Width, SubRect.Height);
  Result.Canvas.Brush.Style := bsClear;
  Result.Canvas.FillRect(0, 0, SubRect.Width, SubRect.Height);
  // Copy the subimage region
  Result.Canvas.CopyRect(
    Rect(0, 0, SubRect.Width, SubRect.Height),
    InputPNG.Canvas,
    SubRect
    );

end;

function GetSubimagePNG2(InputPNG: TPortableNetworkGraphic;
  aStartX, aStartY, aNewWidth, aNewHeight: integer): TPortableNetworkGraphic;
var
  SourceRect: TRect;
  ImageControl: TImage;
  //FullImage: TPortableNetworkGraphic;
  SubImage: TPortableNetworkGraphic;
begin
  Result := nil;
  //FullImage := TPortableNetworkGraphic.Create;
  SubImage := TPortableNetworkGraphic.Create;
  //FullImage.Assign(InputPNG);
  SourceRect := Rect(aStartX, aStartY, aStartX + aNewWidth, aStartY + aNewHeight);
  SubImage.SetSize(SourceRect.Width, SourceRect.Height);
  SubImage.Canvas.CopyRect(
    Rect(0, 0, SourceRect.Width, SourceRect.Height),
    InputPNG.Canvas,
    SourceRect
    );
  Result := SubImage;

end;



function cutSpritesheetPNG(inputPNG: TPortableNetworkGraphic;
  aCols, aRows, aWidth, aHeight: integer): TPNGArray;
var
  x, y, CounterOP: integer;
  StartX, StartY: integer;
  OutputArray: TPNGArray;
  CutPNG: TPortableNetworkGraphic;
  SubRect: TRect;
begin
  //Result := OutputArray;
  CounterOP := 0;
  //OutputArray = array[0..(aRows*aCols)] of  TPortableNetworkGraphic ;
  for y := 0 to aRows do
    for x := 0 to aCols do
    begin
      StartX := x * aWidth;
      StartY := y * aHeight;
      CutPNG := ExtractTransparentSubPNG(InputPNG, StartX, StartY, aWidth, aHeight);
      //SubRect := Rect(StartX, StartY, aWidth, aHeight);
      //CutPNG := ExtractTransparentSubPNG(InputPNG,StartX, StartY, aWidth, aHeight) ;

      OutputArray[CounterOP] := CutPNG;
      CounterOP += 1;
    end;
  Result := OutputArray;

end;

function ExtractTransparentSubPNG_ORIG(Source: TPortableNetworkGraphic;
  startX, startY, Width, Height: integer): TPortableNetworkGraphic;
var
  endX, endY, x, y: integer;
  outputX, outputY: integer;
  Red, Green, Blue, Alpha: byte;
  ImgOriginal, ImgOutput: TLazIntfImage;
  Bitmap: TBitmap;
  PixelPtr: PLongWord;
  Color: TColor;
  PNG: TPortableNetworkGraphic;
begin
  // create editable bitmap
  Bitmap := TBitmap.Create;
  Bitmap.Assign(PNG);
  ImgOriginal := TLazIntfImage.Create(0, 0);
  ImgOriginal.LoadFromBitmap(Bitmap.Handle, Bitmap.MaskHandle);
  endY := startY + Height;
  endX := startY + Width;



  // Copy pixels manually to preserve alpha
  for y := startY to endY - 1 do
    for x := startX to endX - 1 do
    begin
      //PixelPtr := ImgOriginal.GetDataLine(y);
      //Color := PixelPtr[x];
      //Color := ImgOriginal.TColors[x,y];
      PixelPtr := ImgOriginal.GetDataLineStart(y);
      Color := PixelPtr[x];
      Alpha := (Color shr 24) and $FF;
      Color := (128 shl 24) or (Color and $00FFFFFF);
      PixelPtr[x] := Color;
    end;

  // Assign raw image to result
  //Bitmap.Handle := ImgOriginal.CreateBitmapHandle;
  PNG.Assign(Bitmap);
  //Result.LoadFromIntfImage(DestBitmap);

  Bitmap.Free;
  Result := PNG;

end;

{
  Returns a subimage from a TPortableNetworkGraphic object.

  @param Source The original larger image or spritesheet.
  @param startX Where to start copying pixels in original from left side.
  @param startY Where to start copying pixels in original from the top side.
  @param width How many pixels to copy in x direction.
  @param height THow many pixels to copy in y direction.
  @return smaller subimage
}
function ExtractTransparentSubPNG(Source: TPortableNetworkGraphic;
  startX, startY, Width, Height: integer): TPortableNetworkGraphic;
var
  SrcImg, DstImg: TLazIntfImage;
  x, y: integer;
  MyTFPColor: TFPColor;
  CopiedPNG: TPortableNetworkGraphic;
  MyColor: TFPColor;
begin
  // Create source interface image from original PNG
  SrcImg := TLazIntfImage.Create(0, 0);
  SrcImg.LoadFromBitmap(Source.Handle, Source.MaskHandle);

  // Create destination interface image with same dimensions and pixel format

  DstImg := TLazIntfImage.Create(0, 0, [riqfRGB, riqfAlpha]);
  DstImg.DataDescription := SrcImg.DataDescription;
  DstImg.SetSize(Width, Height);
  //writeln('Source png w ',source.width);
  //writeln('Source png h ',source.height);

  // Copy each pixel's ARGB value
  // x and y will refer to pixel in dest image
  for y := 0 to Height - 1 do
  begin

    for x := 0 to Width - 1 do
    begin
      if ((y + startY >= SrcImg.Height) or (x + startX >= SrcImg.Width)) then
        continue;

      MyTFPColor := SrcImg.Colors[x + startX, y + startY];
      MyColor.red := MyTFPColor.Red;
      MyColor.green := MyTFPColor.green;
      MyColor.blue := MyTFPColor.blue;
      MyColor.alpha := MyTFPColor.alpha;

      DstImg.Colors[x, y] := MyColor;

    end;

  end;


  // Create the output PNG and assign the copied bitmap

  CopiedPNG := TPortableNetworkGraphic.Create;
  CopiedPNG.LoadFromIntfImage(DstImg);

  // Clean up
  SrcImg.Free;
  DstImg.Free;

  Result := CopiedPNG;

end;


function FlipXPNG(Source: TPortableNetworkGraphic): TPortableNetworkGraphic;
var
  SrcImg, DstImg: TLazIntfImage;
  SrcX, SrcY, DestX, DestY, Width, Height: integer;
  MyTFPColor: TFPColor;
  CopiedPNG: TPortableNetworkGraphic;
  MyColor: TFPColor;
begin
  // Create source interface image from original PNG
  SrcImg := TLazIntfImage.Create(0, 0);
  //writeln('handle allocated ',Source.HandleAllocated);

  SrcImg.LoadFromBitmap(Source.Handle, Source.MaskHandle);

  // Create destination interface image with same dimensions and pixel format

  DstImg := TLazIntfImage.Create(0, 0, [riqfRGB, riqfAlpha]);
  DstImg.DataDescription := SrcImg.DataDescription;
  Width := Source.Width;
  Height := Source.Height;
  DstImg.SetSize(Width, Height);


  // Copy each pixel's ARGB value

  for SrcY := 0 to Height - 1 do
  begin

    for SrcX := 0 to Width - 1 do
    begin
      //if ((y+startY >= SrcImg.Height) or (x+startX >= SrcImg.width)) then
      //  continue;
      DestX := Width - SrcX -1;
      DestY := SrcY;
      MyTFPColor := SrcImg.Colors[SrcX, SrcY];
      MyColor.red := MyTFPColor.Red;
      MyColor.green := MyTFPColor.green;
      MyColor.blue := MyTFPColor.blue;
      MyColor.alpha := MyTFPColor.alpha;
      DstImg.Colors[DestX, DestY] := MyColor;
    end;
  end;


  // Create the output PNG and assign the copied bitmap

  CopiedPNG := TPortableNetworkGraphic.Create;
  CopiedPNG.LoadFromIntfImage(DstImg);

  // Clean up
  SrcImg.Free;
  DstImg.Free;

  Result := CopiedPNG;

end;

function ResizePNG(Source: TPortableNetworkGraphic; aNewWidth, aNewHeight:Integer): TPortableNetworkGraphic;
var
  SrcImg, DstImg: TLazIntfImage;
  SrcX, SrcY, DestX, DestY, Width, Height: integer;
  OldWidth,OldHeight,OldX,OldY: Integer;
  MyTFPColor: TFPColor;
  CopiedPNG: TPortableNetworkGraphic;
  MyColor: TFPColor;
begin
  // Create source interface image from original PNG
  SrcImg := TLazIntfImage.Create(0, 0);
  //writeln('handle allocated ',Source.HandleAllocated);

  SrcImg.LoadFromBitmap(Source.Handle, Source.MaskHandle);

  // Create destination interface image with same dimensions and pixel format

  DstImg := TLazIntfImage.Create(0, 0, [riqfRGB, riqfAlpha]);
  DstImg.DataDescription := SrcImg.DataDescription;
  OldWidth := Source.Width;
  OldHeight := Source.Height;
  DstImg.SetSize(aNewWidth, aNewHeight);


  // Copy each pixel's ARGB value
  // for each pixel in the new image, look convert its coordinates to one in the old image and copy its value

  for DestY := 0 to aNewHeight - 1 do
  begin

    for DestX := 0 to aNewWidth - 1 do
    begin
      SrcX := (DestX * OldWidth) div aNewWidth;
      SrcY := (DestY * OldHeight) div aNewHeight;

      MyTFPColor := SrcImg.Colors[SrcX, SrcY];
      MyColor.red := MyTFPColor.Red;
      MyColor.green := MyTFPColor.green;
      MyColor.blue := MyTFPColor.blue;
      MyColor.alpha := MyTFPColor.alpha;
      DstImg.Colors[DestX, DestY] := MyColor;
    end;
  end;


  // Create the output PNG and assign the copied bitmap

  CopiedPNG := TPortableNetworkGraphic.Create;
  CopiedPNG.LoadFromIntfImage(DstImg);

  // Clean up
  SrcImg.Free;
  DstImg.Free;

  Result := CopiedPNG;

end;

end.
