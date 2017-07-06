unit ServerMethodsUnit;

interface

uses System.SysUtils, System.Classes, System.Json,
  DataSnap.DSProviderDataModuleAdapter,
  DataSnap.DSServer, DataSnap.DSAuth, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.MySQL,
  FireDAC.Phys.MySQLDef, FireDAC.ConsoleUI.Wait, Data.DB, FireDAC.Comp.Client,
  FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt,
  FireDAC.Stan.StorageBin, FireDAC.Comp.DataSet,System.Generics.Collections,System.Variants;

type
  TErrorRecordIDs = array of integer;

  TServerLog = class(TFileStream)
  public
     procedure SaveLog(msg:string);
  end;

  TServerMethods = class(TDSServerModule)
    FDConnection1: TFDConnection;
    FDPhysMySQLDriverLink1: TFDPhysMySQLDriverLink;
    expoFDQuery: TFDQuery;
    FDStanStorageBinLink1: TFDStanStorageBinLink;
    customertypeFDQuery: TFDQuery;
    paytypeFDQuery: TFDQuery;
    expotypeFDQuery: TFDQuery;
    shoppersourceFDQuery: TFDQuery;
    customerFDQuery: TFDQuery;
    shopperFDQuery: TFDQuery;
    ShopperRemoveFDCommand: TFDCommand;
    procedure customerFDQueryUpdateError(ASender: TDataSet; AException: EFDException;
      ARow: TFDDatSRow; ARequest: TFDUpdateRequest; var AAction: TFDErrorAction);
    private
      { Private declarations }
      FUpdateErrorRecords:TErrorRecordIDs;
      FErrorsList: TJSONObject;
      function GenerateErrorMessage: string;
    public
      { Public declarations }
      function EchoString(Value: string): string;
      function ReverseString(Value: string): string;
      function ExpoData(username: string; password: string): TStream;
      function CustomertypeData(username: string; password: string): TStream;
      function PaytypeData(username: string; password: string): TStream;
      function ExpoTypeData(username: string; password: string): TStream;
      function ShopperSourceData(username: string; password: string): TStream;
      function CustomerDataPost(AStream: TStream):string;
      function ShopperDataPost(AStream:TStream):string;
    end;

const
   LogFilename = './server.log';

implementation

{%CLASSGROUP 'System.Classes.TPersistent'}
{$R *.dfm}

uses System.StrUtils,System.DateUtils;

function CopyStream(const AStream: TStream): TMemoryStream;
var
  LBuffer: TBytes;
  LCount: Integer;
begin
  Result := TMemoryStream.Create;
  try
    SetLength(LBuffer, 1024 * 32);
    while True do
    begin
      LCount := AStream.Read(LBuffer, Length(LBuffer));
      Result.Write(LBuffer, LCount);
      if LCount < Length(LBuffer) then
        break;
    end;
  except
    Result.Free;
    writeln('copystream error');
    raise;
  end;
end;

function TServerMethods.ShopperDataPost(AStream: TStream): string;
var
  LMemStream: TMemoryStream;
  LErrors: Integer;
  count:int64;
  starttime,endtime:TDateTime;
  Log:TServerLog;
begin
  if AStream.Size= 0  then exit;
  if not FileExists(LogFilename) then  //创建或者打开LOG文件
  begin
    Log:=TServerLog.Create(LogFilename,fmCreate);
    Writeln('file not exists');
  end
  else
    Log:=TServerLog.Create(LogFilename,fmOpenWrite);
  FErrorsList := TJSONObject.Create;
  LMemStream:=CopyStream(AStream);
  Log.SaveLog('stream size:'+LMemStream.Size.ToString);  //LOG 流的大小
  LMemStream.Position:=0;
  try
    shopperFDQuery.Close;
    shopperFDQuery.LoadFromStream(LMemStream,TFDStorageFormat.sfBinary);
    Log.SaveLog('record count:'+customerFDQuery.RecordCount.ToString);  //LOG 本次更新的记录数
    starttime:=now();
    FDConnection1.StartTransaction;
    LErrors:=shopperFDQuery.ApplyUpdates;
    if LErrors<>0 then
      FDConnection1.Rollback
    else
      FDConnection1.Commit;
    endtime:=now();
    count:=MilliSecondsBetween(endtime,starttime);
    Log.SaveLog('time count:'+count.ToString);  //LOG插入数据用时
  finally
    customerFDQuery.Close;
    LMemStream.Free;
    FDConnection1.Close;
    if LErrors<>0 then
    begin
      //Result := Format(sErrorsOnApplyUpdates, [GenerateErrorMessage]);
      //Writeln(Result);
      Result:=FErrorsList.ToJSON;
      Log.SaveLog('error message:'+Result); //Log出错数据
    end;
    log.SaveLog('------------------------');
    FErrorsList.Free;
    FreeAndNil(Log);  //关闭Logy文件
  end;

end;

function TServerMethods.CustomerDataPost(AStream: TStream):string;
var
  LMemStream: TMemoryStream;
  LErrors: Integer;
  count:int64;
  starttime,endtime:TDateTime;
  Log:TServerLog;
begin
  if AStream.Size= 0  then exit;
  Result:='';
  if not FileExists(LogFilename) then  //创建或者打开LOG文件
  begin
    Log:=TServerLog.Create(LogFilename,fmCreate);
    Writeln('file not exists');
  end
  else
    Log:=TServerLog.Create(LogFilename,fmOpenWrite);
  FErrorsList := TJSONObject.Create; //创建一个JsonObject用来更新出错记录的数据
  LMemStream:=CopyStream(AStream); //将Stream转换成内存流
  Log.SaveLog('stream size:'+LMemStream.Size.ToString);  //LOG 流的大小
  LMemStream.Position:=0;
  try
    customerFDQuery.close;
    customerFDQuery.LoadFromStream(LMemStream,TFDStorageFormat.sfBinary);  //Query组件加载流
    Log.SaveLog('record count:'+customerFDQuery.RecordCount.ToString);  //LOG 本次更新的记录数
    starttime:=now(); //当前时间
    FDConnection1.StartTransaction; //开始事务
    LErrors:=customerFDQuery.ApplyUpdates; //提交数据
    if LErrors<>0 then
      FDConnection1.Rollback  //出错就回滚
    else
      FDConnection1.Commit;  //无错提交事务
    endtime:=now();          //当前时间
    count:=MilliSecondsBetween(endtime,starttime); //计算插入数据耗时
    Log.SaveLog('time count:'+count.ToString);  //LOG插入数据用时
  finally
    customerFDQuery.Close;   //关闭Query组件
    LMemStream.Free;         //释放内存流
    FDConnection1.Close;    //关闭数据库连接
    if LErrors>0 then   //出错返回错误数据
    begin
      Result:=FErrorsList.ToJSON;
      Log.SaveLog('error message:'+Result); //Log出错数据
    end;
    log.SaveLog('------------------------');
    FErrorsList.Free;  //释放Josn对象
    FreeAndNil(Log);  //关闭Logy文件
  end;
end;

procedure TServerMethods.customerFDQueryUpdateError(ASender: TDataSet; AException: EFDException;
  ARow: TFDDatSRow; ARequest: TFDUpdateRequest; var AAction: TFDErrorAction);
var
  LDataStr: string;
begin
  try
    try
      if not VarIsNull(ARow.GetData('id')) then LDataStr := ARow.GetData('id');
      FErrorsList.AddPair('Errorid', LDataStr);
    except

    end;
  finally

  end;
end;

function TServerMethods.GenerateErrorMessage: string;
var
  I: Integer;
  LJSONObject: TJSONObject;
  LJSONArray: TJSONArray;
begin
  //
end;

function TServerMethods.CustomertypeData(username, password: string): TStream;
begin
  Result := TMemoryStream.Create;
  try
    try
      FDConnection1.Open;
      customertypeFDQuery.Close;
      customertypeFDQuery.Open;
      customertypeFDQuery.SaveToStream(Result, TFDStorageFormat.sfBinary);
      Result.Position := 0;
    except
      on E: Exception do
      begin
        Writeln(E.Message);
        Result.Free;
      end;
    end;
  finally
    customertypeFDQuery.Close;
    FDConnection1.Close;
  end;
end;

function TServerMethods.EchoString(Value: string): string;
begin
  Result := Value;
end;

function TServerMethods.ExpoData(username, password: string): TStream;
begin
  Result := TMemoryStream.Create;
  try
    try
      FDConnection1.Open;
      expoFDQuery.Close;
      expoFDQuery.Open;
      expoFDQuery.SaveToStream(Result, TFDStorageFormat.sfBinary);
      Result.Position := 0;
    except
      on E: Exception do
      begin
        Writeln(E.Message);
        Result.Free;
      end;
    end;
  finally
    expoFDQuery.Close;
    FDConnection1.Close;
  end;

end;

function TServerMethods.ExpoTypeData(username, password: string): TStream;
begin
  Result := TMemoryStream.Create;
  try
    try
      FDConnection1.Open;
      expotypeFDQuery.Close;
      expotypeFDQuery.Open;
      expotypeFDQuery.SaveToStream(Result, TFDStorageFormat.sfBinary);
      Result.Position := 0;
    except
      on E: Exception do
      begin
        Writeln(E.Message);
        Result.Free;
      end;
    end;
  finally
    expotypeFDQuery.Close;
    FDConnection1.Close;
  end;
end;

function TServerMethods.PaytypeData(username, password: string): TStream;
begin
  Result := TMemoryStream.Create;
  try
    try
      FDConnection1.Open;
      paytypeFDQuery.Close;
      paytypeFDQuery.Open;
      paytypeFDQuery.SaveToStream(Result, TFDStorageFormat.sfBinary);
      Result.Position := 0;
    except
      on E: Exception do
      begin
        Writeln(E.Message);
        Result.Free;
      end;
    end;
  finally
    paytypeFDQuery.Close;
    FDConnection1.Close;
  end;
end;



function TServerMethods.ShopperSourceData(username, password: string): TStream;
begin
  Result := TMemoryStream.Create;
  try
    try
      FDConnection1.Open;
      shoppersourceFDQuery.Close;
      shoppersourceFDQuery.Open;
      shoppersourceFDQuery.SaveToStream(Result, TFDStorageFormat.sfBinary);
      Result.Position := 0;
    except
      on E: Exception do
      begin
        Writeln(E.Message);
        Result.Free;
      end;
    end;
  finally
    shoppersourceFDQuery.Close;
    FDConnection1.Close;
  end;

end;

function TServerMethods.ReverseString(Value: string): string;
begin
  Result := System.StrUtils.ReverseString(Value);
end;

{ TServerLog }

procedure TServerLog.SaveLog(msg: string);
var
   len: cardinal;
   time:TDatetime;
   timestr:string;
   oString: UTF8String;
begin
   timestr:='';
   Seek(0, soEnd);
   if msg[1]<>'-' then
   begin
      time:=now();
      timestr:=FormatDateTime('--yyyy-mm-dd hh:nn:ss--',time);
   end;
   oString := UTF8String(timestr+msg+#13#10);
   len := length(oString);
   if len > 0 then
      self.WriteBuffer(oString[1], len);
end;

end.
