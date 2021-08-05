unit umain;
//TODO: implementar o FCP
{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  ActnList, LCLType, Menus, uconstantes, ufuncoes, uestruturadados;

type
  { TfrmMain }

  TfrmMain = class(TForm)
    actExit: TAction;
    actCalc: TAction;
    actClear: TAction;
    actFocusOnVlr: TAction;
    actFocusOnAliq: TAction;
    actFocusOnMVA: TAction;
    actFocusOnQtde: TAction;
    actFocusOnIPI: TAction;
    actFocusOnCST: TAction;
    actFocusOnAliqST: TAction;
    actShowCSOSN: TAction;
    actShowCFOP: TAction;
    actions: TActionList;
    btnCalc: TButton;
    btnClear: TButton;
    btnExit: TButton;
    chkArredBaixoICMS: TCheckBox;
    chkArredBaixoST: TCheckBox;
    cmbCST: TComboBox;
    edtAliqDest: TEdit;
    edtAliqDestRed: TEdit;
    edtAliqOrigem: TEdit;
    edtAliqOrigemRed: TEdit;
    edtFCPAliq: TEdit;
    edtRedICMS: TEdit;
    edtRedST: TEdit;
    edtQtde: TEdit;
    edtMVA: TEdit;
    edtMult: TEdit;
    edtVlrUnit: TEdit;
    edtVlrProduto: TEdit;
    edtDesc: TEdit;
    edtFrete: TEdit;
    edtSeguro: TEdit;
    edtOutras: TEdit;
    edtIPIAliq: TEdit;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    GroupBox3: TGroupBox;
    GroupBox4: TGroupBox;
    GroupBox5: TGroupBox;
    GroupBox6: TGroupBox;
    GroupBox7: TGroupBox;
    GroupBox8: TGroupBox;
    Label1: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label18: TLabel;
    Label2: TLabel;
    Label21: TLabel;
    Label24: TLabel;
    Label25: TLabel;
    Label26: TLabel;
    Label27: TLabel;
    Label28: TLabel;
    Label29: TLabel;
    Label3: TLabel;
    Label30: TLabel;
    Label31: TLabel;
    Label32: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    lblICMSBase: TLabel;
    lblICMSVlr: TLabel;
    lblResultCST: TLabel;
    lblSTBase: TLabel;
    lblSTValor: TLabel;
    lblFCPValor: TLabel;
    lblVlrLiq: TLabel;
    lblIPIVlr: TLabel;
    procedure actExitExecute(Sender: TObject);
    procedure actShowCFOPExecute(Sender: TObject);
    procedure actShowCSOSNExecute(Sender: TObject);
    procedure btnCalcClick(Sender: TObject);
    procedure btnClearClick(Sender: TObject);
    procedure cmbCSTChange(Sender: TObject);
    procedure edtAliqOrigemExit(Sender: TObject);
    procedure Change(Sender: TObject);
    procedure edtQtdeClick(Sender: TObject);
    procedure edtQtdeKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
    procedure edtQtdeKeyPress(Sender: TObject; var Key: char);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    procedure InicializaWindows;
    function ValidaQuantidades: boolean;
    procedure InformaCampos;
    procedure CalculaCampos;
    procedure MostraResultados;
    procedure ChamaAction(AAction: TAction);
    procedure RotulosOcultados(ocultado: boolean);
  public

  end;

var
  frmMain: TfrmMain;
  dados: TDados;

implementation

{$R *.lfm}

{ TfrmMain }

procedure TfrmMain.actExitExecute(Sender: TObject);
begin
  ChamaAction(Sender as TAction);
end;

procedure TfrmMain.actShowCFOPExecute(Sender: TObject);
begin
  Mensagem(MSGERROR_SER_IMPLEMENTADO);
end;

procedure TfrmMain.actShowCSOSNExecute(Sender: TObject);
begin
  Mensagem(MSGERROR_SER_IMPLEMENTADO);
end;

procedure TfrmMain.btnCalcClick(Sender: TObject);
begin
  if dados.vcst <> -1 then
    lblResultCST.Caption := CST[dados.vcst];

  //caso Negativo não calcula nada
  if not ValidaQuantidades then
  begin
    Mensagem(MSGERROR_VLR_NULO);
    ProcuraEditVazia(GroupBox1);
    Exit;
  end;

  //Campos Informados pelo usuário/operador
  InformaCampos;

  //Campos Calculados
  CalculaCampos;

  //Mostra os resultados
  MostraResultados;

  RotulosOcultados(False);
end;

procedure TfrmMain.btnClearClick(Sender: TObject);
var
  i: word;
begin
  for i := 0 to self.ComponentCount - 1 do
  begin
    if (Components[i] is TGroupBox) and (Components[i] <> GroupBox5) and
      (Components[i] <> GroupBox6) then
    begin
      LimpaCampos((Components[i] as TGroupBox));
    end;
  end;
  edtQtde.SetFocus;
  edtQtde.Text := '1';
  edtQtde.SelectAll;

  edtMult.Text := '1';

  RotulosOcultados(True);
end;

procedure TfrmMain.cmbCSTChange(Sender: TObject);
begin
  dados.vcst := cmbCST.items.IndexOf(cmbCST.Text);

  if dados.vcst <> -1 then
    lblResultCST.Caption := CST[dados.vcst];

  case cmbCST.ItemIndex of
    0, 1:
    begin
      edtAliqOrigemRed.Text := edtAliqOrigem.Text;
      edtAliqDestRed.Text := edtAliqDest.Text;
    end;
    2, 7:
      edtAliqOrigemRed.SetFocus;
    5:
    begin
      edtAliqOrigemRed.Text := edtAliqOrigem.Text;
      edtAliqDest.SetFocus;
    end;
  end;
end;

procedure TfrmMain.edtAliqOrigemExit(Sender: TObject);
begin
  FormataPontoFlutuante(Sender as TEdit);
end;

procedure TfrmMain.Change(Sender: TObject);
begin
  //Questão de Compatibilidade
  {$IfDef LINUX}
  ConverterVirgulaPraPonto(Sender as TEdit);
  {$EndIf}

  {$IfDef MSWINDOWS}
  ConverterPontoPraVirgula(Sender as TEdit);
  {$EndIf}
end;

procedure TfrmMain.edtQtdeClick(Sender: TObject);
begin
  (Sender as TEdit).SelectAll;
end;

procedure TfrmMain.edtQtdeKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
begin
  if Key = 13 then
  begin
    if not ValidaQuantidades then
    begin
      Mensagem(MSGERROR_QTDE);
      Exit;
    end;

    if Sender = edtAliqOrigem then
      edtAliqOrigemRed.Text := edtAliqOrigem.Text;

    if Sender = edtAliqOrigemRed then
      edtRedICMS.Text := CalculaReducao(edtAliqOrigem.Text, edtAliqOrigemRed.Text);

    if Sender = edtAliqDest then
      edtAliqDestRed.Text := edtAliqDest.Text;

    if Sender = edtAliqDestRed then
      edtRedST.Text := CalculaReducao(edtAliqDest.Text, edtAliqDestRed.Text);

    SelectNext(Sender as TWinControl, True, True);
  end;
end;

procedure TfrmMain.edtQtdeKeyPress(Sender: TObject; var Key: char);
begin
  TestaChar(Key);
end;

procedure TfrmMain.FormCreate(Sender: TObject);

begin
  //Necessário por questão de compatibilidade
  {$IfDef MSWINDOWS}
  InicializaWindows;
  {$EndIf}
end;

procedure TfrmMain.FormShow(Sender: TObject);
begin
  RotulosOcultados(True);
end;

procedure TfrmMain.InicializaWindows;
var
  i: integer;
begin
  for i := 0 to ComponentCount - 1 do
    if Components[i] is TEdit then
      ConverterPontoPraVirgula(Components[i] as TEdit);
end;

function TfrmMain.ValidaQuantidades: boolean;
begin
  Result := True;
  if (edtQtde.Text = EmptyStr) or (edtMult.Text = EmptyStr) or
    (edtVlrProduto.Text = EmptyStr) or (edtDesc.Text = EmptyStr) then
    Result := False;
end;

procedure TfrmMain.InformaCampos;
begin
  with Dados do
  begin
    //Produto
    qtde := StrToFloat(edtQtde.Text);
    mult := StrToFloat(edtMult.Text);
    vlrProduto := StrToFloat(edtVlrProduto.Text);
    desconto := StrToFloat(edtDesc.Text);
    vlrSeguro := StrToFloat(edtSeguro.Text);
    vlrFrete := StrToFloat(edtFrete.Text);
    vlrOutras := StrToFloat(edtOutras.Text);

    //IPI
    IPIAliq := StrToFloat(edtIPIAliq.Text);

    //Aliq Origem
    AliqOrigem := StrToFloat(edtAliqOrigem.Text);
    AliqOrigemRed := StrToFloat(edtAliqOrigemRed.Text);

    //Aliq Destino
    AliqDest := StrToFloat(edtAliqDest.Text);
    AliqDestRed := StrToFloat(edtAliqDestRed.Text);

    //ST
    mva := StrToFloat(edtMVA.Text);

    //FCP
    FCPAliq := StrToFloat(edtFCPAliq.Text);
  end;
end;

procedure TfrmMain.CalculaCampos;
begin
  with Dados do
  begin
    //valores
    VlrLiq := CalculaTotalLiq(vlrProduto, desconto);
    VlrUnit := CalculaValorUnitario(qtde, mult, vlrLiq);

    //IPI
    IPIVlr := CalculaIPI(vlrLiq, IPIAliq);

    //Reduções
    ICMSRed := CalculaReducao(AliqOrigem, AliqOrigemRed);
    STRed := CalculaReducao(AliqDest, AliqDestRed);

    //Soma os valores pra compor a base da ICMS
    somaValores := vlrLiq + vlrSeguro + vlrFrete + vlrOutras;

    //ICMS
    ICMSBase := CalculaBaseICMS(vcst, somaValores, ICMSRed);
    ICMSVlr := CalculaValorICMS(vcst, ICMSBase, AliqOrigem, AliqDest);

    //Soma os valores pra compor a base da ST, com o valor do IPI Incluso
    somaValores := somaValores + IPIVlr;

    //ST
    STBase := CalculaBaseST(vcst, somaValores, STRed, mva);
    STVlr := CalculaValorST(vcst, STBase, AliqDest, ICMSVlr);

    //FCP
    FCPVlr := CalculaValorFCP(STBase, FCPAliq);
  end;
end;

procedure TfrmMain.MostraResultados;
begin
  with Dados do
  begin
    edtVlrUnit.Text := FormatFloat(FORMAT, VlrUnit);
    edtRedICMS.Text := FormatFloat(FORMAT, ICMSRed);
    edtRedST.Text := FormatFloat(FORMAT, STRed);


    lblVlrLiq.Caption := FormatFloat(FORMAT, vlrLiq);
    lblIPIVlr.Caption := FormatFloat(FORMAT, IPIVlr);
    lblICMSBase.Caption := FormatFloat(FORMAT, ICMSBase);
    lblICMSVlr.Caption := FormatFloat(FORMAT, ICMSVlr);
    lblSTBase.Caption := FormatFloat(FORMAT, STBase);
    lblSTValor.Caption := FormatFloat(FORMAT, STVlr);
    lblFCPValor.Caption := FormatFloat(FORMAT, FCPVlr);

    //CST 30 é Simples Nacional, assim como CST 90
    if vcst = 3 then
    begin
      lblICMSBase.Caption := FormatFloat(FORMAT, ZERO);
      lblICMSVlr.Caption := FormatFloat(FORMAT, ZERO);
    end;
  end;
end;

procedure TfrmMain.ChamaAction(AAction: TAction);
begin
  if AAction = actClear then
    btnClearClick(nil);
  if AAction = actCalc then
    btnCalcClick(nil);
  if AAction = actFocusOnQtde then
    edtQtde.SetFocus;
  if AAction = actFocusOnVlr then
    edtVlrProduto.SetFocus;
  if AAction = actFocusOnIPI then
    edtIPIAliq.SetFocus;
  if AAction = actFocusOnAliq then
    edtAliqOrigem.SetFocus;
  if AAction = actFocusOnMVA then
    edtMVA.SetFocus;
  if AAction = actFocusOnCST then
    cmbCST.SetFocus;
  if AAction = actFocusOnAliqST then
    edtAliqDest.SetFocus;
  if AAction = actExit then
    Application.Terminate;
end;

procedure TfrmMain.RotulosOcultados(ocultado: boolean);
begin
  Label24.Visible := not ocultado;
  Label27.Visible := not ocultado;
  Label28.Visible := not ocultado;
  Label29.Visible := not ocultado;
  Label30.Visible := not ocultado;
  Label31.Visible := not ocultado;
  Label32.Visible := not ocultado;
  lblVlrLiq.Visible := not ocultado;
  lblICMSBase.Visible := not ocultado;
  lblICMSVlr.Visible := not ocultado;
  lblSTBase.Visible := not ocultado;
  lblSTValor.Visible := not ocultado;
  lblFCPValor.Visible := not ocultado;
  lblIPIVlr.Visible := not ocultado;
end;

end.
