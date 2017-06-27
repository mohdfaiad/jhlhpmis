unit customerdm;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async,
  FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client,Vcl.Dialogs;

type
  TcustomerDataModule = class(TDataModule)
    customerFDQuery: TFDQuery;
    customertypeFDQuery: TFDQuery;
    customerDataSource: TDataSource;
    customertypeDataSource: TDataSource;
    salesFDQuery: TFDQuery;
    salesDataSource: TDataSource;
    expoFDQuery: TFDQuery;
    expoDataSource: TDataSource;
    customerFDQuerycreatetime: TDateField;
    customerFDQueryupdatetime: TDateField;
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure customerOpen(s: string);
  end;

var
  customerDataModule: TcustomerDataModule;

implementation
uses connectiondm;

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

procedure TcustomerDataModule.DataModuleCreate(Sender: TObject);
begin
  if connectionDataModule<>nil then
  begin
    customerFDQuery.Connection:=connectionDataModule.mainFDConnection;
    customertypeFDQuery.Connection:=connectionDataModule.mainFDConnection;
    salesFDQuery.Connection:=connectionDataModule.mainFDConnection;
    expoFDQuery.Connection:=connectionDataModule.mainFDConnection;
  end;
  expoFDQuery.open;
  customertypeFDQuery.Open;
  salesFDQuery.open;
end;

procedure TcustomerDataModule.customerOpen(s:string);
begin
  customerFDQuery.Close;
  customerFDQuery.Macros.Items[0].Value:=s;
  //customerFDQuery.Prepare;
  customerFDQuery.Open;
end;

end.
