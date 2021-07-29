unit ufuncoes;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, StdCtrls, uconstantes, Dialogs;

//FUNÇÕES GERAIS
procedure ConverterVirgulaPraPonto(AEdit: TEdit);
procedure ConverterPontoPraVirgula(AEdit: TEdit);
procedure ProcuraEditVazia(AGroupBox: TGroupBox);
procedure LimpaCampos(AGroupBox: TGroupBox);
procedure Mensagem(AValue: byte);
procedure TestaChar(Key: char);
procedure FormataPontoFlutuante(AEdit: TEdit);

//FUNÇOES DE CALCULOS PRA ACHAR O VALOR UNITÁRIO E LÍQUIDO
function CalculaValorUnitario(qtde, mult, vlrLiq: single): single;
function CalculaTotalLiq(vlrProduto, desc: single): Single;

//FUNÇÕES DE CALCULOS DOS IMPOSTOS
function CalculaIPI(vlrLiq, aliq: single): single;
function CalculaBaseICMS(cst: byte; somaValores, reducao: single): Single;
function CalculaValorICMS(cst: byte; base, aliq, aliqDest: single):Single;
function CalculaReducao(proprio, red: single): Single; overload;
function CalculaReducao(proprio, red: string): String; overload;
function CalculaBaseST(cst: byte; somaValores, reducao, mva: single): Single;
function CalculaValorST(cst: byte; base, aliq, vlrICMS: single): Single;
function CalculaValorFCP(STbase, FCPAliq: single): Single;

implementation

procedure ConverterVirgulaPraPonto(AEdit: TEdit);
begin
  AEdit.Text := StringReplace(AEdit.Text, ',', '.', [rfReplaceAll]);
  AEdit.SelStart := Length(AEdit.Text);
end;

procedure ConverterPontoPraVirgula(AEdit: TEdit);
begin
  AEdit.Text := StringReplace(AEdit.Text, '.', ',', [rfReplaceAll]);
  AEdit.SelStart := Length(AEdit.Text);
end;

procedure ProcuraEditVazia(AGroupBox: TGroupBox);
var
  i: integer;
begin
  for i := 0 to AGroupBox.ControlCount - 1 do
  begin
    if AGroupBox.Controls[i] is TEdit then
      if TEdit(AGroupBox.Controls[i]).Text = '' then
      begin
        TEdit(AGroupBox.Controls[i]).SetFocus;
        Exit;
      end;
  end;
end;

procedure LimpaCampos(AGroupBox: TGroupBox);
var
  i: integer;
begin
  for i := 0 to AGroupBox.ControlCount - 1 do
  begin
    if AGroupBox.Controls[i] is TEdit then
    begin
      TEdit(AGroupBox.Controls[i]).Text := FORMAT;
    end;
  end;
end;

procedure Mensagem(AValue: byte);
begin
  ShowMessage(Messages[AValue]);
end;

procedure TestaChar(Key: char);
begin
  if not (Key in [#8, #13, '0'..'9', ',', '.']) then
  begin
    ShowMessage('Caractere Inválido: ' + Key);
    Key := #0;
  end;
end;

procedure FormataPontoFlutuante(AEdit: TEdit);
begin
  AEdit.Text := FormatFloat(FORMAT, StrToFloat(AEdit.Text));
end;

function CalculaValorUnitario(qtde, mult, vlrLiq: single): single;
begin
  Result := vlrLiq / (qtde * mult);
end;

function CalculaTotalLiq(vlrProduto, desc: single): Single;
begin
  Result := vlrProduto - desc
end;

function CalculaIPI(vlrLiq, aliq: single): Single;
begin
  Result := ZERO;

  if aliq > 0 then
    Result := vlrLiq * (aliq / 100);

end;

//FUNÇÕES DE CÁLCULOS
function CalculaBaseICMS(cst: byte; somaValores, reducao: single): Single;
begin
  //Se enquadrar nesses quisitos não se calcula o ICMS
  if cst in [4, 6, 8] then
    Result := ZERO
  else
    Result := somaValores * (1 - (reducao / 100));
end;

function CalculaValorICMS(cst: byte; base, aliq, aliqDest: single): Single;
begin
  //Diferente do CST 51 calcula-se normal
  if cst <> 5 then
    Result := base * (aliq / 100)
  else
    Result := base * (aliqDest / 100);
end;

function CalculaReducao(proprio, red: single): Single;
begin
  if red > proprio then
  begin
    Mensagem(MSGERROR_RED_MAIOR_QUE_PROPRIO);
    Abort;
  end;

  Result := 100 - ((red / proprio) * 100);
end;

function CalculaReducao(proprio, red: string): string;
var
  vproprio, vred: single;
begin
  vproprio := StrToFloat(proprio);
  vred := StrToFloat(red);

  if vred > vproprio then
  begin
    Mensagem(MSGERROR_RED_MAIOR_QUE_PROPRIO);
    Abort;
  end;

  Result := FormatFloat(FORMAT, 100 - ((vred / vproprio) * 100));
end;

function CalculaBaseST(cst: byte; somaValores, reducao, mva: single): Single;
begin
  Result := ZERO;

  if cst in [1, 3, 7] then
    Result := somaValores * (1 + mva / 100) * (1 - (reducao / 100));
end;

function CalculaValorST(cst: byte; base, aliq, vlrICMS: single): Single;
begin
  Result := ZERO;

  if cst in [1, 3, 7] then
    Result := (base * (aliq / 100)) - vlrICMS;
end;

function CalculaValorFCP(STbase, FCPAliq: single): Single;
begin
  Result:= STbase * (FCPAliq / 100);
end;

end.
