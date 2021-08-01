unit uestruturadados;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

type
  TDados = record

    //verificador de CST
    vcst: byte;

    //Produtos
    qtde: single;
    mult: single;   
    vlrUnit: single;
    vlrSeguro: single;
    vlrFrete: single;
    vlrOutras: single;
    vlrProduto: single;  
    desconto: single;
    vlrLiq: single;

    //IPI
    IPIAliq: single;
    IPIVlr: single;

    //ICMS
    aliqOrigem: single;
    aliqOrigemRed: single;
    ICMSRed: single;
    ICMSBase: single;
    ICMSVlr: single;

    //ST
    mva: single;      
    aliqDestRed: single;
    aliqDest: single;
    STRed: single;
    STBase: single;
    STVlr: single;

    //FCP
    FCPAliq: single;
    FCPVlr: single;

    //Soma
    somaValores: extended;
  end;

implementation

end.

