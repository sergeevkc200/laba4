program Shell;

uses
  Forms,
  Main in 'Main.pas' {Primary};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TPrimary, Primary);
  Application.Run;
end.
