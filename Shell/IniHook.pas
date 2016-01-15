unit IniHook;

interface

uses
  Windows, Messages;

type
  PHookInfo = ^THookInfo;
  THookInfo = packed record
    FormHandle: THandle;    // Дескриптор окна приложения
    HookHandleKey: THandle; // Дескриптор ловушки
  end;

var
  DataArea: PHookInfo = nil;
  hMapArea: THandle = 0;

implementation

initialization

  // Создаем файл в памяти
  hMapArea := CreateFileMapping($FFFFFFFF, nil, PAGE_READWRITE, 0,
    SizeOf(DataArea), 'HookKeyboard');
  DataArea := MapViewOfFile(hMapArea, FILE_MAP_ALL_ACCESS, 0, 0, 0);

finalization

  // Убираем файл из памяти
  if Assigned(DataArea) then
    UnMapViewOfFile(DataArea);
  if hMapArea <> 0 then
    CloseHandle(hMapArea);

end.
