unit ClienteServidor;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.StdCtrls, Datasnap.DBClient, Data.DB;

type
  TServidor = class
  private
    FPath: String;
  public
    constructor Create;
    // Tipo do parâmetro não pode ser alterado
    function SalvarArquivos(AData: OleVariant; ANumeroPDF: Integer): Boolean;
  end;

  TfClienteServidor = class(TForm)
    ProgressBar: TProgressBar;
    btEnviarSemErros: TButton;
    btEnviarComErros: TButton;
    btEnviarParalelo: TButton;
    procedure FormCreate(Sender: TObject);
    procedure btEnviarSemErrosClick(Sender: TObject);
    procedure btEnviarComErrosClick(Sender: TObject);
    procedure btEnviarParaleloClick(Sender: TObject);
  private
    FPath: String;
    FServidor: TServidor;

    function InitDataset: TClientDataset;
  public
    procedure CarregarProgressBar(iPosicao: Integer);
  end;

var
  fClienteServidor: TfClienteServidor;

const
  QTD_ARQUIVOS_ENVIAR = 100;

implementation

uses
  IOUtils;

{$R *.dfm}

procedure TfClienteServidor.btEnviarComErrosClick(Sender: TObject);
var
  oArquivo: TClientDataset;
  i: Integer;
  sNomeArquivo: string;
begin
  oArquivo := InitDataset;
  oArquivo.Append;
  TBlobField(oArquivo.FieldByName('Arquivo')).LoadFromFile(FPath);
  oArquivo.Post;
  ProgressBar.Max := QTD_ARQUIVOS_ENVIAR;
  ProgressBar.Position := 0;

  try
    for i := 1 to QTD_ARQUIVOS_ENVIAR do
    begin
      ProgressBar.Position := i;
      {$REGION Simulação de erro, não alterar}
      if i = (QTD_ARQUIVOS_ENVIAR/2) then
        FServidor.SalvarArquivos(NULL, i)
      else
        FServidor.SalvarArquivos(oArquivo.Data, i);
      {$ENDREGION}
    end;
  finally
    if i < QTD_ARQUIVOS_ENVIAR then
    begin
      for I := 1 to QTD_ARQUIVOS_ENVIAR do
      begin
        sNomeArquivo := FServidor.FPath + i.ToString + '.pdf';
        if TFile.Exists(sNomeArquivo) then
          TFile.Delete(sNomeArquivo);
      end;
    end;
  end;
end;

procedure TfClienteServidor.btEnviarParaleloClick(Sender: TObject);
begin
  { TODO : implementar }
end;

procedure TfClienteServidor.btEnviarSemErrosClick(Sender: TObject);
var
  oArquivo: TClientDataset;
  i: Integer;
begin
  oArquivo := InitDataset;

  try
    oArquivo.Append;
    TBlobField(oArquivo.FieldByName('Arquivo')).LoadFromFile(FPath);
    oArquivo.Post;
    ProgressBar.Max := QTD_ARQUIVOS_ENVIAR;
    ProgressBar.Position := 0;

    for i := 1 to QTD_ARQUIVOS_ENVIAR do
    begin
      ProgressBar.Position := i;
      FServidor.SalvarArquivos(oArquivo.Data, i);
    end;
  finally
    FreeAndNil(oArquivo);
    ShowMessage('Processamento finalizado.');
  end;
end;

procedure TfClienteServidor.CarregarProgressBar(iPosicao: Integer);
begin
  ProgressBar.Position := iPosicao;
end;

procedure TfClienteServidor.FormCreate(Sender: TObject);
begin
  inherited;
  FPath := IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0))) + 'pdf.pdf';
  FServidor := TServidor.Create;
end;

function TfClienteServidor.InitDataset: TClientDataset;
begin
  Result := TClientDataset.Create(nil);
  Result.FieldDefs.Add('Arquivo', ftBlob);
  Result.CreateDataSet;
end;

{ TServidor }

constructor TServidor.Create;
begin
  FPath := ExtractFilePath(ParamStr(0)) + 'Servidor\';
end;

function TServidor.SalvarArquivos(AData: OleVariant; ANumeroPDF: Integer): Boolean;
var
  cds: TClientDataSet;
  FileName: string;
begin
  Result := False;

  try
    cds := TClientDataset.Create(nil);
    cds.Data := AData;

{$REGION Simulação de erro, não alterar}
    if cds.RecordCount = 0 then
      Exit;
{$ENDREGION}
    cds.First;

    FileName := FPath + ANumeroPDF.ToString + '.pdf';
    if TFile.Exists(FileName) then
      TFile.Delete(FileName);

    TBlobField(cds.FieldByName('Arquivo')).SaveToFile(FileName);

    Result := True;
  finally
    FreeAndNil(cds);
  end;
end;

end.
