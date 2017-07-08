unit clientsyc;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,clientsycdm, Vcl.StdCtrls,
  Data.DB, Vcl.Grids, Vcl.DBGrids;

type
  TclientsycFrame = class(TFrame)
    Button1: TButton;
    Memo1: TMemo;
    procedure Button1Click(Sender: TObject);
  private
    procedure clientsycDataModuleOnExce(const s: string);
    { Private declarations }
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    { Public declarations }
  end;

implementation

{$R *.dfm}

procedure TclientsycFrame.clientsycDataModuleOnExce(const s:string);
begin
  if Assigned(Memo1) then
  begin
    memo1.Lines.add(s);
    //Memo1.Repaint;
  end;
end;

procedure TclientsycFrame.Button1Click(Sender: TObject);
begin
  Memo1.Lines.Clear;    //���
  Memo1.Repaint;  //�ػ�


  clientsycDataModule.OnExec:=clientsycDataModuleOnExce;    //�����¼�

  clientsycDataModule.GetExpotypeData;       //չ������

  if not clientsycDataModule.SyncError then
    clientsycDataModule.GetExpoData;          //����չ��

  if not clientsycDataModule.SyncError then
    clientsycDataModule.GetCustomertypeData;  //�ͻ�����

  if not clientsycDataModule.SyncError then
    clientsycDataModule.GetPaytypeData;       //֧������

  if not clientsycDataModule.SyncError then
    clientsycDataModule.GetShoppersourceData;  //�˿���Դ

  if not clientsycDataModule.SyncError then
    clientsycDataModule.GetMemberData;        //ϵͳ��Ա


  if not clientsycDataModule.SyncError then
    Memo1.Lines.Add('ͬ���������')
  else
    Memo1.Lines.Add('ͬ������ʱ��������,�п��ܵ������ݲ�����,�����Ժ��ٴ�ͬ��')
end;

constructor TclientsycFrame.Create(AOwner: TComponent);
begin
  inherited;
  if clientsycDataModule=nil then
        clientsycDataModule:=TclientsycDataModule.Create(self);

  Button1.Enabled:=clientsycDataModule.SQLConnection1.Connected;
  if clientsycDataModule.CantConnection then
      raise Exception.Create('�޷����ӵ�������,���Ժ�����!');

end;

destructor TclientsycFrame.Destroy;
begin
  FreeAndNil(clientsycDataModule);
  inherited;
end;

end.
