unit NameOfKey;

interface

uses
  SysUtils, LCLIntf, LCLType, Forms, Controls, Graphics, Classes;

function GetKeyName(Key: Word): String;
function FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState): String;


implementation


function GetKeyName(Key: Word): String;
begin
  Result := '';
  case Key of
    VK_ESCAPE: Result := 'Escape';
    VK_BACK: Result := 'Backspace';
    VK_TAB: Result := 'Tab';
    VK_RETURN: Result := 'Enter';
    VK_SHIFT: Result := 'Shift';
    VK_CONTROL: Result := 'Control';
    VK_MENU: Result := 'Alt';
    VK_PAUSE: Result := 'Pause';
    VK_CAPITAL: Result := 'Caps Lock';
    VK_PRIOR: Result := 'Page Up';
    VK_NEXT: Result := 'Page Down';
    VK_END: Result := 'End';
    VK_HOME: Result := 'Home';
    VK_LEFT: Result := 'Left Arrow';
    VK_UP: Result := 'Up Arrow';
    VK_RIGHT: Result := 'Right Arrow';
    VK_DOWN: Result := 'Down Arrow';
    VK_INSERT: Result := 'Insert';
    VK_DELETE: Result := 'Delete';
    VK_F1..VK_F24: Result := Format('F%d', [Key - VK_F1 + 1]);
    VK_NUMPAD0..VK_NUMPAD9: Result := Format('Numpad %d', [Key - VK_NUMPAD0]);
  else
    // For character keys, you can translate the key code directly, but this is locale-dependent.
    // For a more robust solution for character keys, you might need to use platform-specific functions.
    // However, for basic usage, simple translation of the key code often works.
    if (Key >= Ord('A')) and (Key <= Ord('Z')) then
      Result := Chr(Key)
    else if (Key >= Ord('0')) and (Key <= Ord('9')) then
      Result := Chr(Key);
  end;
end;

function FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState): String;
var
  KeyName: String;
begin
  Result := '';
  KeyName := GetKeyName(Key);

  // Check for modifier keys
  if ssShift in Shift then KeyName := 'Shift+' + KeyName;
  if ssCtrl in Shift then KeyName := 'Ctrl+' + KeyName;
  if ssAlt in Shift then KeyName := 'Alt+' + KeyName;

  //ShowMessage('Key pressed: ' + KeyName);
  Result := KeyName;
end;

end.

