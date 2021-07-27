unit umain;
//TODO: implementar o FCP
{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  ActnList, LCLType, uconstantes, ufuncoes;

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
    actions: TActionList;
    btnCalc: TButton;
    btnClear: TButton;
    btnExit: TButton;
    cmbCST: TComboBox;
    edtAliqOrigemRed: TEdit;
    edtRedST: TEdit;
    edtFCPAliq: TEdit;
    edtFCPVlr: TEdit;
    edtVlrLiq: TEdit;
    edtQtde: TEdit;
    edtIPIVlr: TEdit;
    edtAliqOrigem: TEdit;
    edtAliqDest: TEdit;
    edtAliqDestRed: TEdit;
    edtRedICMS: TEdit;
    edtICMSBase: TEdit;
    edtICMSVlr: TEdit;
    edtMVA: TEdit;
    edtSTBase: TEdit;
    edtSTVlr: TEdit;
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
    Label1: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    Label2: TLabel;
    Label20: TLabel;
    Label21: TLabel;
    Label22: TLabel;
    Label23: TLabel;
    Label24: TLabel;
    Label25: TLabel;
    lblResultCST: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    procedure actExitExecute(Sender: TObject);
    procedure btnCalcClick(Sender: TObject);
    procedure btnClearClick(Sender: TObject);
    procedure cmbCSTChange(Sender: TObject);
    procedure edtAliqOrigemExit(Sender: TObject);
    procedure edtQtdeChange(Sender: TObject);
    procedure edtQtdeClick(Sender: TObject);
    procedure edtQtdeKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
    procedure edtQtdeKeyPress(Sender: TObject; var Key: char);
    procedure FormCreate(Sender: TObject);
  private
    function ValidaQuantidades: boolean;
    procedure ChamaAction(AAction: TAction);
  public

  end;

var
  frmMain: TfrmMain;

implementation

{$R *.lfm}

{ TfrmMain }

procedure TfrmMain.actExitExecute(Sender: TObject);
begin
  ChamaAction(Sender as TAction);
end;

procedure TfrmMain.btnCalcClick(Sender: TObject);
var
  cst: byte;
  AliqOrigem, AliqOrigemRed, AliqDestRed, AliqDest, vlrSeguro, vlrFrete,
  vlrOutras, IPIVlr, mva, vlrLiq, ICMSRed, ICMSBase, STRed, ICMSVlr,
  STBase, IPIAliq, qtde, mult, vlrProduto, desc, STVlr, VlrUnit, FCPAliq, FCPVlr: single;
  somaValores: extended;
begin
  //caso Negativo não calcula nada
  if not ValidaQuantidades then
  begin
    Mensagem(MSGERROR_VLR_NULO);
    ProcuraEditVazia(GroupBox1);
    Exit;
  end;

  cst := cmbCST.items.IndexOf(cmbCST.Text);

  //--------------------------------------------------------------------------
  //Campos Informados pelo usuário/operador
  //Produto
  qtde := StrToFloat(edtQtde.Text);
  mult := StrToFloat(edtMult.Text);
  vlrProduto := StrToFloat(edtVlrProduto.Text);
  desc := StrToFloat(edtDesc.Text);

  vlrSeguro := StrToFloat(edtSeguro.Text);
  vlrFrete := StrToFloat(edtFrete.Text);
  vlrOutras := StrToFloat(edtOutras.Text);
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
  FCPAliq:=StrToFloat(edtFCPAliq.Text);
  //--------------------------------------------------------------------------

  //--------------------------------------------------------------------------
  //Campos Calculados
  //valores
  VlrUnit := CalculaValorUnitario(qtde, mult, vlrProduto, desc);
  VlrLiq := CalculaTotalLiq(vlrProduto, desc);

  //IPI
  IPIVlr := CalculaIPI(vlrLiq, IPIAliq);

  //Reduções
  ICMSRed := CalculaReducao(AliqOrigem, AliqOrigemRed);
  STRed := CalculaReducao(AliqDest, AliqDestRed);

  //Soma os valores pra compor a base da ICMS
  somaValores := vlrLiq + vlrSeguro + vlrFrete + vlrOutras;

  //ICMS
  ICMSBase := CalculaBaseICMS(cst, somaValores, ICMSRed);
  ICMSVlr := CalculaValorICMS(cst, ICMSBase, AliqOrigem, AliqDest);

  //Soma os valores pra compor a base da ST, com o valor do IPI Incluso
  somaValores := somaValores + IPIVlr;

  //ST
  STBase := CalculaBaseST(cst, somaValores, STRed, mva);
  STVlr := CalculaValorST(cst, STBase, AliqDest, ICMSVlr);

  //FCP
  FCPVlr:=CalculaValorFCP(STBase, FCPAliq);
  //--------------------------------------------------------------------------

  //--------------------------------------------------------------------------
  //Mostra os resultados
  edtVlrUnit.Text := FormatFloat(FORMAT, VlrUnit);
  edtVlrLiq.Text := FormatFloat(FORMAT, vlrLiq);
  edtIPIVlr.Text := FormatFloat(FORMAT, IPIVlr);
  edtRedICMS.Text := FormatFloat(FORMAT, ICMSRed);
  edtRedST.Text := FormatFloat(FORMAT, STRed);
  edtICMSBase.Text := FormatFloat(FORMAT, ICMSBase);
  edtICMSVlr.Text := FormatFloat(FORMAT, ICMSVlr);
  edtSTBase.Text := FormatFloat(FORMAT, STBase);
  edtSTVlr.Text := FormatFloat(FORMAT, STVlr);    
  edtFCPAliq.Text := FormatFloat(FORMAT, FCPAliq);
  edtFCPVlr.Text := FormatFloat(FORMAT, FCPVlr);

  //CST 30 é Simples Nacional, assim como CST 90
  if cst = 3 then
  begin
    edtICMSBase.Text := FloatToStr(ZERO);
    edtICMSVlr.Text := FloatToStr(ZERO);
  end;
end;

procedure TfrmMain.btnClearClick(Sender: TObject);
var
  i: word;
begin
  for i := 0 to self.ComponentCount - 1 do
  begin
    if (Components[i] is TGroupBox) and (Components[i] <> GroupBox3) then
    begin
      LimpaCampos((Components[i] as TGroupBox));
    end;
  end;
  edtQtde.SetFocus;
  edtQtde.Text := '1';
  edtQtde.SelectAll;

  edtMult.Text := '1';
end;

procedure TfrmMain.cmbCSTChange(Sender: TObject);
begin
  lblResultCST.Caption := CST[cmbCST.Items.IndexOf(cmbCST.Text)];
  case cmbCST.ItemIndex of
    0, 1:
    begin
      edtAliqOrigemRed.Text := edtAliqOrigem.Text;
      edtAliqDestRed.Text := edtAliqDest.Text;
    end;
    2, 7:
      edtAliqOrigemRed.SetFocus;
    5:
      edtAliqDest.SetFocus;
  end;
end;

procedure TfrmMain.edtAliqOrigemExit(Sender: TObject);
begin
  FormataPontoFlutuante(Sender as TEdit);
end;

procedure TfrmMain.edtQtdeChange(Sender: TObject);
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
{$ifdef MSWINDOWS}
var
  i: integer;
{$EndIf}
begin
  //Necessário por questão de compatibilidade
  {$IfDef MSWINDOWS}
  for i := 0 to ComponentCount - 1 do
    if Components[i] is TEdit then
        ConverterPontoPraVirgula(Components[i] as TEdit);
  {$EndIf}
end;

function TfrmMain.ValidaQuantidades: boolean;
begin
  Result := True;
  if (edtQtde.Text = EmptyStr) or (edtMult.Text = EmptyStr) or
    (edtVlrProduto.Text = EmptyStr) or (edtDesc.Text = EmptyStr) then
    Result := False;
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
  if AAction = actExit then
    Application.Terminate;
end;

end.
