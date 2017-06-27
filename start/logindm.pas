unit logindm;

interface

uses
  System.SysUtils, System.Classes,staticstr, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client;

type
  Tlogindatamod = class(TDataModule)
    loginfdquery: TFDQuery;
  private
    { Private declarations }
    FUsername:string;
    FPassword:string;
  public
    { Public declarations }
    property Username:string read FUsername write FUsername;
    property Password:string read FPassword write FPassword;
    procedure login;
  end;

var
  logindatamod: Tlogindatamod;


implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

{ Tlogindatamod }

procedure Tlogindatamod.login;
begin

  loginfdquery.SQL.Clear;
  loginfdquery.Open(format(LOGIN_SQL,[Username,Password]));
  if loginfdquery.RecordCount=0 then
    raise Exception.Create('�û������������ ');
end;

end.
