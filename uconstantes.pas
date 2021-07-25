unit uconstantes;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

//constantes do programa
const
  CST: array [0..8] of string = (
    'ICMS Tributada Integralmente',
    'ST Recolhida na Fonte',
    'ICMS Reduzido',
    'ICMS Isento e ST Recolhida na Fonte',
    'Isento',
    'ICMS Diferido',
    'ST Recolhido Anteriormente',
    'ICMS Reduzido e ST Recolhida na Fonte',
    'Outras'
    );
  CFOP_02: array [0..1] of string = ('1102', '2102');
  CFOP_03: array [0..1] of string = ('1403', '2403');


  Messages: array[0..7] of string = (
    'Valor não pode ser nulo',
    'Desconto não pode ser maior que o valor do produto',
    'Valor do Produto não pode ser zero',
    'Quantidade não pode ser nula',
    'Aliquota zero só se aplica aos CSTs 30, 40 e 60',
    'Informe um CST',
    'Redução só se aplica aos CSTs 20 e 70',
    'Aliquota da redução não pode ser maior que o próprio');

  //Essas constantes tem relação com a constante acima
  MSGERROR_VLR_NULO = 0;
  MSGERROR_DESC = 1;
  MSGERROR_VLR_PROD = 2;
  MSGERROR_QTDE = 3;
  MSGERROR_ALIQ_ZER0 = 4;
  MSGERROR_CST_INPUT = 5;
  MSGERROR_REDUCAO = 6;
  MSGERROR_RED_MAIOR_QUE_PROPRIO = 7;

  //Formatador de decimais
  FORMAT = '0.00';
  ZERO = 0.00;
implementation

end.

