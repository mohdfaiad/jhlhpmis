unit clientuploaddm;

interface

uses
  System.SysUtils, System.Classes, Data.DBXDataSnap, Data.DBXCommon,
  IPPeerClient, Data.DB, Data.SqlExpr, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, VCL.Dialogs, FireDAC.Stan.StorageBin;

type
  TclientuploadDataModule = class(TDataModule)
    SQLConnection1: TSQLConnection;
    customerFDQuery: TFDQuery;
    shopperFDQuery: TFDQuery;
    FDStanStorageBinLink1: TFDStanStorageBinLink;
    FDTransaction1: TFDTransaction;
    setshopperautoincFDCommand: TFDCommand;
    procedure DataModuleCreate(Sender: TObject);
    private
      { Private declarations }
      FOnExec: TGetStrProc; // �¼�:����������ִ����Ϣ��������
    public
      { Public declarations }
      ServerError:boolean;
      ServerErrorMsg:string;
      property OnExec: TGetStrProc read FOnExec write FOnExec; // �¼�����
      procedure CustomerDataUpload;
      procedure ShopperDataUpload;
      function test: boolean;
  end;

var
  clientuploadDataModule: TclientuploadDataModule;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

uses servermethodsupload, connectiondm;

{$R *.dfm}

procedure TclientuploadDataModule.CustomerDataUpload;
var
  server: TObject;
  stream: TMemoryStream;
  memtable: TFDMemTable;

  I: integer;
  LResponseMessage: string;
  ids: string;
begin

  SQLConnection1.Open;
  server := TServerMethodsClient.Create(SQLConnection1.DBXConnection);
  ids := TServerMethodsClient(server).UseExpoIds;
  if customerFDQuery <> nil then
  begin
    if ids <> '' then
    begin
      customerFDQuery.Macros.Items[0].AsRaw:=' and eid in ('+ids+')';
    end;

    customerFDQuery.Open;
    if customerFDQuery.State in dsEditModes then
      customerFDQuery.Post;
  end
  else
    exit;
  if customerFDQuery.RecordCount = 0 then
  begin
    if Assigned(FOnExec) then
      FOnExec('Ŀǰû�пͻ�����');
    exit;
  end;

  if Assigned(FOnExec) then
    FOnExec('��ʼ�ϴ��ͻ�����');

  memtable := TFDMemTable.Create(self);
  memtable.CachedUpdates := true;
  memtable.UpdateOptions.AutoIncFields := 'id';
  memtable.UpdateOptions.AutoCommitUpdates := true;
  memtable.UpdateOptions.CheckRequired := false;

  memtable.CopyDataSet(customerFDQuery, [coStructure, coRestart, coAppend]);
  memtable.FieldByName('id').ProviderFlags := memtable.FieldByName('id').ProviderFlags -
    [pfInupdate];
  // exit;
  stream := TMemoryStream.Create;
  memtable.ResourceOptions.StoreItems := [siDelta, siMeta];
  memtable.SaveToStream(stream, TFDStorageFormat.sfBinary);
  stream.Position := 0;

  try
    // FDTransaction1.StartTransaction; //����������
    try
      // customerFDQuery.ServerDeleteAll;
      LResponseMessage := TServerMethodsClient(server).CustomerDataPost(stream);
      if LResponseMessage = '' then
      begin
        // FDTransaction1.Commit;  //���������ύ,ɾ����������
        // if Assigned(FOnExec) then
        // FOnExec('���ؿͻ������Ѿ�ɾ��');
      end
    except
      On E: Exception do
      begin
        // FDTransaction1.Rollback;
        raise Exception.Create(E.Message);
      end;
    end;
  finally
    server.Free;
    memtable.Free;
    customerFDQuery.Close;
    SQLConnection1.Close;
    if LResponseMessage <> '' then
      raise Exception.Create(LResponseMessage);
  end;
  if Assigned(FOnExec) then
    FOnExec('�ͻ������ϴ��ɹ�');
end;

procedure TclientuploadDataModule.ShopperDataUpload;
var
  server: TObject;
  stream: TMemoryStream;
  memtable: TFDMemTable;
  I: integer;
  LResponseMessage: string;
begin
  // �����ݼ�,���������ģʽ��
  if shopperFDQuery <> nil then
  begin
    shopperFDQuery.Open;
    if shopperFDQuery.State in dsEditModes then
      shopperFDQuery.Post;
  end
  else exit;

  // ��¼��Ϊ0���˳�
  if shopperFDQuery.RecordCount = 0 then
  begin
    if Assigned(FOnExec) then
      FOnExec('Ŀǰû�й˿�����');
    exit;
  end;

  if Assigned(FOnExec) then
    FOnExec('��ʼ�ϴ��˿�����');

  // �����ڴ��
  memtable := TFDMemTable.Create(self);
  memtable.CachedUpdates := true;
  memtable.UpdateOptions.AutoIncFields := 'id';
  memtable.UpdateOptions.AutoCommitUpdates := true;
  memtable.UpdateOptions.CheckRequired := false;

  // ����¼���Ƶ��ڴ��,�������ֶ�IDΪ�������ֶ�
  memtable.CopyDataSet(shopperFDQuery, [coStructure, coRestart, coAppend]);
  memtable.FieldByName('id').ProviderFlags := memtable.FieldByName('id').ProviderFlags -[pfInupdate];

  // �����ڴ���,�����ڴ���浽��
  stream := TMemoryStream.Create;
  memtable.ResourceOptions.StoreItems := [siDelta, siMeta];
  memtable.SaveToStream(stream, TFDStorageFormat.sfBinary);
  stream.Position := 0;

  try
    try
      SQLConnection1.Open;
      server := TServerMethodsClient.Create(SQLConnection1.DBXConnection);
      FDTransaction1.StartTransaction; // ����������,����ɾ�������Ѿ��ύ��ɵļ�¼
      shopperFDQuery.ServerDeleteAll;    //ɾ�����ر�������
      setshopperautoincFDCommand.Execute; //���������ֶ�
      LResponseMessage := TServerMethodsClient(server).ShopperDataPost(stream); // �ϴ��������ݵ�������

      if LResponseMessage = '' then //�жϷ������Ƿ񷵻س�����Ϣ
      begin
        FDTransaction1.Commit; // ���������ύ,ɾ����������
        if Assigned(FOnExec) then
          FOnExec('���ع˿������Ѿ�ɾ��');
      end
      else
        FDTransaction1.Rollback;    //��������������쳣,��������ع�
    except
      On E: Exception do
      begin
        FDTransaction1.Rollback;
        raise Exception.Create(E.Message);
      end;
    end;
  finally
    server.Free;
    memtable.Free;
    shopperFDQuery.Close;
    SQLConnection1.Close;
    if LResponseMessage <> '' then
      raise Exception.Create(LResponseMessage);
  end;
  if Assigned(FOnExec) then
    FOnExec('�˿������ϴ��ɹ�');
end;

function TclientuploadDataModule.test: boolean;
begin

end;

procedure TclientuploadDataModule.DataModuleCreate(Sender: TObject);
begin
  ServerError:=false;

  SQLConnection1.Params.Values['DSAuthenticationPassword']:=clientuser.Password;
  SQLConnection1.Params.Values['DSAuthenticationUser']:=clientuser.Username;
  try
    try
      SQLConnection1.Open;
    except
      on E:Exception do
      begin
        ServerError:=true;
        ServerErrorMsg:=E.Message;
        exit;
      end;
    end;
  finally
    SQLConnection1.Close;
  end;

  customerFDQuery.Connection := connectionDataModule.mainFDConnection;
  shopperFDQuery.Connection := connectionDataModule.mainFDConnection;
  setshopperautoincFDCommand.Connection:=connectionDataModule.mainFDConnection;
  FDTransaction1.Connection := connectionDataModule.mainFDConnection;
end;

end.
