library KeyHook;

uses
  Windows, Messages, SysUtils,
  IniHook in '..\IniHook.pas';

const
  WM_ReadWithHook = WM_USER + 120; // Пользовательское сообщение

// Функция обслуживающая ловушку
function KeyboardProc(Code: Integer; wParam: WPARAM; lParam: LPARAM): Integer; StdCall;
begin
  if Code < 0 then // Передаем сообщение другим ловушкам в системе
    Result := CallNextHookEx(DataArea^.HookHandleKey, Code, wParam, lParam)
  else
    if Byte(lParam shr 24) < $80 then // Только нажатие клавиши
    begin
      {Считываем и передаем код нажатой клавиши}
      PostMessage(DataArea^.FormHandle, WM_ReadWithHook, wParam, 0); // Поылаем сообщение главной форме
    end;
    Result := CallNextHookEx(DataArea^.HookHandleKey, Code, wParam, lParam);
end;

// Установка ловушки
procedure SetHook; StdCall;
begin
  DataArea^.HookHandleKey := SetWindowsHookEx(WH_KEYBOARD, KeyboardProc, hInstance, 0);
end;

// Удаление ловушки
procedure DelHook; StdCall;
begin
  UnhookWindowsHookEx(DataArea^.HookHandleKey);
end;

// Экспорт процедур
exports
  SetHook, DelHook;

begin
end.
