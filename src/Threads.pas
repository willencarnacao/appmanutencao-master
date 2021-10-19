unit Threads;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls,
  System.Threading, Vcl.ExtCtrls;

type
  TMinhaThread = class(TThread)
  private
    FAux: String;
  public
    constructor Create; reintroduce;
    procedure Execute; override;
    procedure Sincronizar;
  end;

type
  TfThreads = class(TForm)
    pbThreads: TProgressBar;
    btnIniciarThreads: TButton;
    edtTempo: TLabeledEdit;
    edtQuantidadeThread: TLabeledEdit;
    mmThreads: TMemo;
    procedure btnIniciarThreadsClick(Sender: TObject);

   private
    { Private declarations }
    FThread: TMinhaThread;
    procedure FinalizarExecucao(Sender: TObject);
  public
    { Public declarations }
    procedure CarregarProgressBar(iTempoSleep: Integer);
    procedure Show;
  end;

var
  fThreads: TfThreads;

implementation

{$R *.dfm}

procedure TfThreads.btnIniciarThreadsClick(Sender: TObject);
var
  i, iQuantidadeThreads: Integer;
begin
  mmThreads.Clear;
  iQuantidadeThreads := StrToInt(edtQuantidadeThread.Text);

  for i := 0 to (iQuantidadeThreads - 1) do
  begin
    Self.FThread := TMinhaThread.Create;
    mmThreads.Lines.Add(FThread.ThreadID.ToString + ' - ' + 'Iniciando processamento');
    FThread.OnTerminate := FinalizarExecucao;
    Self.FThread.Start;
  end;
end;

procedure TfThreads.CarregarProgressBar(iTempoSleep: Integer);
var
  i: Integer;
begin
  pbThreads.Position := 0;

  for i := 0 to 100 do
  begin
    pbThreads.Position := i;
    Sleep(Random(iTempoSleep));
    Application.ProcessMessages;
  end;
end;

procedure TfThreads.FinalizarExecucao(Sender: TObject);
begin
  FThread.Synchronize(procedure
                     begin
                       //
                     end);
end;

procedure TfThreads.Show;
begin
  Visible := True;
  BringToFront;
end;

{ TMinhaThread }

constructor TMinhaThread.Create;
begin
  inherited Create(True);
  Self.FreeOnTerminate := True;

  FAux := '';
end;

procedure TMinhaThread.Execute;
begin
  inherited;

  fThreads.CarregarProgressBar(StrToInt(fThreads.edtTempo.Text));
  Self.Synchronize(Self.Sincronizar);
  Self.Sleep(StrToIntDef(fThreads.edtTempo.Text, 1));
end;

procedure TMinhaThread.Sincronizar;
begin
  fThreads.mmThreads.Lines.Add(ThreadID.ToString + ' - ' + 'Finalizando processamento');
end;

end.
