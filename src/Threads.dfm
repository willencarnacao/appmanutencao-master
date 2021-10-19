object fThreads: TfThreads
  Left = 0
  Top = 0
  Caption = 'Threads'
  ClientHeight = 364
  ClientWidth = 396
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object pbThreads: TProgressBar
    Left = 20
    Top = 331
    Width = 349
    Height = 25
    TabOrder = 3
  end
  object btnIniciarThreads: TButton
    Left = 275
    Top = 30
    Width = 94
    Height = 25
    Caption = 'Iniciar threads'
    TabOrder = 2
    OnClick = btnIniciarThreadsClick
  end
  object edtTempo: TLabeledEdit
    Left = 148
    Top = 32
    Width = 121
    Height = 21
    EditLabel.Width = 60
    EditLabel.Height = 13
    EditLabel.Caption = 'Tempo (ms):'
    NumbersOnly = True
    TabOrder = 1
    Text = '100'
  end
  object edtQuantidadeThread: TLabeledEdit
    Left = 20
    Top = 32
    Width = 121
    Height = 21
    EditLabel.Width = 96
    EditLabel.Height = 13
    EditLabel.Caption = 'N'#250'mero de threads:'
    NumbersOnly = True
    TabOrder = 0
    Text = '2'
  end
  object mmThreads: TMemo
    Left = 20
    Top = 59
    Width = 349
    Height = 266
    ScrollBars = ssVertical
    TabOrder = 4
  end
end
