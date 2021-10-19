unit Exceptions;

interface

uses
  System.Threading,
  System.Diagnostics,
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, System.TimeSpan;

type
  TException = class
  private
    { private declarations }
    FArquivoLog: string;
  public
    constructor Create;
    procedure GravarLog(AMensagem: string);
    procedure TratarException(Sender: TObject; E: Exception);
  end;

implementation

// uses

constructor TException.Create;
begin
  FArquivoLog := IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0))) + 'Log.txt';
  Application.onException := TratarException;
end;

procedure TException.GravarLog(AMensagem: String);
var
  txtLog: TextFile;
begin
  AssignFile(txtLog, FArquivoLog);
  if FileExists(FArquivoLog) then
    Append(txtLog)
  else
    Rewrite(txtLog);
  Writeln(txtLog, FormatDateTime('dd/mm/YY hh:mm:ss - ', now) + AMensagem);
  CloseFile(txtLog);
end;

procedure TException.TratarException(Sender: TObject; E: Exception);
begin
  GravarLog('---------------------------------------------------------------');
  if TComponent(Sender) is TForm then
  begin
    GravarLog('Form: ' + TForm(Sender).Name);
    GravarLog('Caption: ' + TForm(Sender).Caption);
    GravarLog('Error: ' + E.ClassName);
    GravarLog('Error: ' + E.Message);
  end
  else
  begin
    GravarLog('Form: ' + TForm(TComponent(Sender).Owner).Name);
    GravarLog('Caption: ' + TForm(TComponent(Sender).Owner).Caption);
    GravarLog('Error: ' + E.ClassName);
    GravarLog('Error: ' + E.Message);
  end;
  GravarLog('---------------------------------------------------------------');
  ApplicationShowException(E);
//  ShowMessage(E.Message);
end;

var
  MinhaException: TException;

initialization;
  MinhaException := TException.Create;

finalization;
  MinhaException.Free;
end.
