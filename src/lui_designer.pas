{ This file was automatically created by Lazarus. Do not edit!
  This source is only used to compile and install the package.
 }

unit LUI_Designer;

{$warn 5023 off : no warning about unused units}
interface

uses
  Lui_FormDesigner, Lui_beta, LazarusPackageIntf;

implementation

procedure Register;
begin
  RegisterUnit('Lui_FormDesigner', @Lui_FormDesigner.Register);
end;

initialization
  RegisterPackage('LUI_Designer', @Register);
end.
