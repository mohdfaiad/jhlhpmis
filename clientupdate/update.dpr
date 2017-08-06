program update;

uses
  System.SysUtils,
  Winapi.Windows,
  Vcl.Forms,
  Vcl.Dialogs,
  System.SyncObjs,
  main in 'main.pas' {updateForm},
  datamoudle in 'datamoudle.pas' {updateDataModule: TDataModule},
  servermethods in '..\clientsyc\servermethods.pas',
  Vcl.Themes,
  Vcl.Styles,
  common in 'common.pas',
  setting in '..\setting\setting.pas' {bplsettingFrame: TFrame};

{$R *.res}

var
  hAppMutex: TMutex; //�����������
  mainHandle: THandle;

begin
  DeleteTempfile(ExtractFilePath(Application.ExeName));

  hAppMutex := TMutex.Create(nil,false,'{3DE1B19B-A903-4879-97FE-AB18266539AE}');
  //if  hAppMutex.WaitFor(1)=wrTimeout then exit;
  if GetLastError<>183 then
  begin
    hAppMutex.Acquire;
    updateDataModule := TupdateDataModule.Create(nil);
    try
      try
        if updateDataModule.GetUpdateList then
        begin
          Application.Initialize;
          Application.MainFormOnTaskbar := True;
          TStyleManager.TrySetStyle('Metropolis UI Blue');
          Application.CreateForm(TupdateForm, updateForm);
  updateForm.updateJson := updateDataModule.UpdateJson;
          if updateForm.CanShow then
          begin
            if ( ParamCount > 0 )  then
            begin
            {$IFDEF DEBUG}
              if Application.MessageBox('��⵽����,ȷ�Ϻ���ֹ���򲢽��и���,�뱣�����ڱ༭������.',
                '��⵽����', MB_OKCANCEL + MB_ICONINFORMATION + MB_TOPMOST)=ID_CANCEL then
                exit;
            {$ELSE}
              Application.MessageBox('��⵽����,ȷ�Ϻ���ֹ���򲢽��и���,�뱣�����ڱ༭������.',
                '��⵽����', MB_OK + MB_ICONINFORMATION + MB_TOPMOST);
              mainHandle:=OpenProcess(PROCESS_ALL_ACCESS, FALSE,strtoint(ParamStr(1)) );
              if mainHandle>0 then TerminateProcess(mainHandle,0);
            {$ENDIF}
            end;
            Application.Run;
          end
          else
            Application.Terminate;
        end;
      except
      {$IFDEF DEBUG}
        on E:Exception do ShowMessage(e.Message);
      {$ENDIF}
      end;
    finally
      updateDataModule.Free;
      hAppMutex.Release;
      hAppMutex.Free;
    end;
  end
  else hAppMutex.Free;



//
//  Application.Initialize;
//  Application.MainFormOnTaskbar := True;
//  Application.CreateForm(TupdateForm, updateForm);
//  Application.CreateForm(TupdateDataModule, updateDataModule);
//  Application.Run;
end.

