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
    VlrUnit: single;
    vlrSeguro: single;
    vlrFrete: single;
    vlrOutras: single;
    vlrProduto: single;  
    desc: single;
    vlrLiq: single;

    //IPI
    IPIAliq: single;
    IPIVlr: single;

    //ICMS
    AliqOrigem: single;
    AliqOrigemRed: single;
    ICMSRed: single;
    ICMSBase: single;
    ICMSVlr: single;

    //ST
    mva: single;      
    AliqDestRed: single;
    AliqDest: single;
    STBase: single;  
    STRed: single;
    STVlr: single;

    //FCP
    FCPAliq: single;
    FCPVlr: single;

    //Soma
    somaValores: extended;
  end;

implementation

end.

