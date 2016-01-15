library KeyHook;

uses
  Windows, Messages, SysUtils,
  IniHook in '..\IniHook.pas';

const
  WM_ReadWithHook = WM_USER + 120; // ���������������� ���������

// ������� ������������� �������
function KeyboardProc(Code: Integer; wParam: WPARAM; lParam: LPARAM): Integer; StdCall;
begin
  if Code < 0 then // �������� ��������� ������ �������� � �������
    Result := CallNextHookEx(DataArea^.HookHandleKey, Code, wParam, lParam)
  else
    if Byte(lParam shr 24) < $80 then // ������ ������� �������
    begin
      {��������� � �������� ��� ������� �������}
      PostMessage(DataArea^.FormHandle, WM_ReadWithHook, wParam, 0); // ������� ��������� ������� �����
    end;
    Result := CallNextHookEx(DataArea^.HookHandleKey, Code, wParam, lParam);
end;

// ��������� �������
procedure SetHook; StdCall;
begin
  DataArea^.HookHandleKey := SetWindowsHookEx(WH_KEYBOARD, KeyboardProc, hInstance, 0);
end;

// �������� �������
procedure DelHook; StdCall;
begin
  UnhookWindowsHookEx(DataArea^.HookHandleKey);
end;

// ������� ��������
exports
  SetHook, DelHook;

begin
end.
