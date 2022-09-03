program NonLCL1;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  SysUtils, Classes, Unit1, Lui_beta
  //, LResources
  ;

procedure PaintWidget(AWidget: TLuiWidget);
  var
    i: Integer;
    Child: TLuiWidget;
  begin
      writeln(AWidget.Name,' : ', AWidget.Caption,'  > ', Awidget.Left, Awidget.Top, ' childs:',AWidget.ChildCount);
      // children
      if AWidget.ChildCount>0 then begin
          for i:=0 to AWidget.ChildCount-1 do begin
              Child:=AWidget.Children[i];
              PaintWidget(Child);
          end;
      end;
  end;

begin
   MyForm1:= TLuiForm1.Create(nil);
   PaintWidget(MyForm1);
   writeln('finish.');
end.

