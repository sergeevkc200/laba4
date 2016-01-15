unit IniHook;

interface

uses
  Windows, Messages;

type
  PHookInfo = ^THookInfo;
  THookInfo = packed record
    FormHandle: THandle;    // ���������� ���� ����������
    HookHandleKey: THandle; // ���������� �������
  end;

var
  DataArea: PHookInfo = nil;
  hMapArea: THandle = 0;

implementation

initialization

  // ������� ���� � ������
  hMapArea := CreateFileMapping($FFFFFFFF, nil, PAGE_READWRITE, 0,
    SizeOf(DataArea), 'HookKeyboard');
  DataArea := MapViewOfFile(hMapArea, FILE_MAP_ALL_ACCESS, 0, 0, 0);

finalization

  // ������� ���� �� ������
  if Assigned(DataArea) then
    UnMapViewOfFile(DataArea);
  if hMapArea <> 0 then
    CloseHandle(hMapArea);

end.
