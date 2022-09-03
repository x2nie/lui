unit Unit1; 

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Lui_beta;

type

  { TLuiForm1 }

  TLuiForm1 = class(TLuiForm)
    MyButton1: TLuiButton;
    MyButton2: TLuiButton;
    MyButton3: TLuiButton;
    MyButton4: TLuiButton;
    MyButton5: TLuiButton;
    MyGroupBox1: TLuiGroupBox;
    MyGroupBox2: TLuiGroupBox;
  private
    { private declarations }
  public
    { public declarations }
  end; 

var
  MyForm1: TLuiForm1;

implementation

{$R *.lfm}

end.

