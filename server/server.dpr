program server;

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  ServerMethodsUnit in 'ServerMethodsUnit.pas' {ServerMethods: TDSServerModule},
  ServerConst in 'ServerConst.pas',
  ServerContainerUnit in 'ServerContainerUnit.pas' {ServerContainer1: TDataModule};

begin
  try
    RunDSServer;
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end
end.
