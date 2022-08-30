{ Example designer for the Lazarus IDE

  Copyright (C) 2009 Mattias Gaertner mattias@freepascal.org

  This library is free software; you can redistribute it and/or modify it
  under the terms of the GNU Library General Public License as published by
  the Free Software Foundation; either version 2 of the License, or (at your
  option) any later version with the following modification:
  As a special exception, the copyright holders of this library give you
  permission to link this library with independent modules to produce an
  executable, regardless of the license terms of these independent modules,and
  to copy and distribute the resulting executable under terms of your choice,
  provided that you also meet, for each linked independent module, the terms
  and conditions of the license of that module. An independent module is a
  module which is not derived from or based on this library. If you modify
  this library, you may extend this exception to your version of the library,
  but you are not obligated to do so. If you do not wish to do so, delete this
  exception statement from your version.
  This program is distributed in the hope that it will be useful, but WITHOUT
  ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
  FITNESS FOR A PARTICULAR PURPOSE. See the GNU Library General Public License
  for more details.
  You should have received a copy of the GNU Library General Public License
  along with this library; if not, write to the Free Software Foundation,
  Inc., 51 Franklin Street - Fifth Floor, Boston, MA 02110-1335, USA.
}

unit Lui_FormDesigner;

{$mode objfpc}{$H+}

interface

uses
  LCLProc, LCLType, Classes, SysUtils, FormEditingIntf, LCLIntf, Graphics,
  ProjectIntf, Lui_beta;

type

  { TLuiWidgetMediator }

  TLuiWidgetMediator = class(TDesignerMediator,ILuiWidgetDesigner)
  private
    FMyForm: TLuiForm;
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation);
      override;
  public
    // needed by the Lazarus form editor
    class function CreateMediator(TheOwner, aForm: TComponent): TDesignerMediator;
      override;
    class function FormClass: TComponentClass; override;
    procedure GetBounds(AComponent: TComponent; out CurBounds: TRect); override;
    procedure SetBounds(AComponent: TComponent; NewBounds: TRect); override;
    procedure GetClientArea(AComponent: TComponent; out
            CurClientArea: TRect; out ScrollOffset: TPoint); override;
    procedure Paint; override;
    function ComponentIsIcon(AComponent: TComponent): boolean; override;
    function ParentAcceptsChild(Parent: TComponent;
                Child: TComponentClass): boolean; override;
  public
    // needed by TLuiWidget
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure InvalidateRect(Sender: TObject; ARect: TRect; Erase: boolean);
    property MyForm: TLuiForm read FMyForm;
  public
    procedure GetObjInspNodeImageIndex(APersistent: TPersistent; var AIndex: integer); override;
  end;

  { TFileDescPascalUnitWithMyForm }

  TFileDescPascalUnitWithMyForm = class(TFileDescPascalUnitWithResource)
  public
    constructor Create; override;
    function GetInterfaceUsesSection: string; override;
    function GetLocalizedName: string; override;
    function GetLocalizedDescription: string; override;
  end;


procedure Register;

implementation

procedure Register;
begin
  FormEditingHook.RegisterDesignerMediator(TLuiWidgetMediator);
  RegisterComponents('LUI',[TLuiButton,TLuiGroupBox]);
  RegisterProjectFileDescriptor(TFileDescPascalUnitWithMyForm.Create,
                                FileDescGroupName);
end;

{ TLuiWidgetMediator }

constructor TLuiWidgetMediator.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

destructor TLuiWidgetMediator.Destroy;
begin
  if FMyForm<>nil then FMyForm.Designer:=nil;
  FMyForm:=nil;
  inherited Destroy;
end;

procedure TLuiWidgetMediator.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if Operation=opRemove then
  begin
    if FMyForm=AComponent then
    begin
      FMyForm.Designer:=nil;
      FMyForm:=nil;
    end;
  end;
end;

class function TLuiWidgetMediator.CreateMediator(TheOwner, aForm: TComponent
  ): TDesignerMediator;
var
  Mediator: TLuiWidgetMediator;
begin
  Result:=inherited CreateMediator(TheOwner,aForm);
  Mediator:=TLuiWidgetMediator(Result);
  Mediator.FMyForm:=aForm as TLuiForm;
  Mediator.FMyForm.FreeNotification(Mediator);
  Mediator.FMyForm.Designer:=Mediator;
end;

class function TLuiWidgetMediator.FormClass: TComponentClass;
begin
  Result:=TLuiForm;
end;

procedure TLuiWidgetMediator.GetBounds(AComponent: TComponent; out
  CurBounds: TRect);
var
  w: TLuiWidget;
begin
  if AComponent is TLuiWidget then begin
    w:=TLuiWidget(AComponent);
    CurBounds:=Bounds(w.Left,w.Top,w.Width,w.Height);
  end else
    inherited GetBounds(AComponent,CurBounds);
end;

procedure TLuiWidgetMediator.InvalidateRect(Sender: TObject; ARect: TRect;
  Erase: boolean);
begin
  if (LCLForm=nil) or (not LCLForm.HandleAllocated) then exit;
  LCLIntf.InvalidateRect(LCLForm.Handle,@ARect,Erase);
end;

procedure TLuiWidgetMediator.GetObjInspNodeImageIndex(APersistent: TPersistent;
  var AIndex: integer);
begin
  if Assigned(APersistent) then
  begin
    if (APersistent is TLuiWidget) and (TLuiWidget(APersistent).AcceptChildrenAtDesignTime) then
      AIndex := FormEditingHook.GetCurrentObjectInspector.ComponentTree.ImgIndexBox
    else
    if (APersistent is TLuiWidget) then
      AIndex := FormEditingHook.GetCurrentObjectInspector.ComponentTree.ImgIndexControl
    else
      inherited;
  end
end;

procedure TLuiWidgetMediator.SetBounds(AComponent: TComponent; NewBounds: TRect);
begin
  if AComponent is TLuiWidget then begin
    TLuiWidget(AComponent).SetBounds(NewBounds.Left,NewBounds.Top,
      NewBounds.Right-NewBounds.Left,NewBounds.Bottom-NewBounds.Top);
  end else
    inherited SetBounds(AComponent,NewBounds);
end;

procedure TLuiWidgetMediator.GetClientArea(AComponent: TComponent; out
  CurClientArea: TRect; out ScrollOffset: TPoint);
var
  Widget: TLuiWidget;
begin
  if AComponent is TLuiWidget then begin
    Widget:=TLuiWidget(AComponent);
    CurClientArea:=Rect(Widget.BorderLeft,Widget.BorderTop,
                        Widget.Width-Widget.BorderRight,
                        Widget.Height-Widget.BorderBottom);
    ScrollOffset:=Point(0,0);
  end else
    inherited GetClientArea(AComponent, CurClientArea, ScrollOffset);
end;

procedure TLuiWidgetMediator.Paint;

  procedure PaintWidget(AWidget: TLuiWidget);
  var
    i: Integer;
    Child: TLuiWidget;
  begin
    with LCLForm.Canvas do begin
      // fill background
      Brush.Style:=bsSolid;
      Brush.Color:=clLtGray;
      FillRect(0,0,AWidget.Width,AWidget.Height);
      // outer frame
      Pen.Color:=clRed;
      Rectangle(0,0,AWidget.Width,AWidget.Height);
      // inner frame
      if AWidget.AcceptChildrenAtDesignTime then begin
        Pen.Color:=clMaroon;
        Rectangle(AWidget.BorderLeft-1,AWidget.BorderTop-1,
                  AWidget.Width-AWidget.BorderRight+1,
                  AWidget.Height-AWidget.BorderBottom+1);
      end;
      // caption
      TextOut(5,2,AWidget.Caption);
      // children
      if AWidget.ChildCount>0 then begin
        SaveHandleState;
        // clip client area
        MoveWindowOrgEx(Handle,AWidget.BorderLeft,AWidget.BorderTop);
        if IntersectClipRect(Handle, 0, 0, AWidget.Width-AWidget.BorderLeft-AWidget.BorderRight,
                             AWidget.Height-AWidget.BorderTop-AWidget.BorderBottom)<>NullRegion
        then begin
          for i:=0 to AWidget.ChildCount-1 do begin
            SaveHandleState;
            Child:=AWidget.Children[i];
            // clip child area
            MoveWindowOrgEx(Handle,Child.Left,Child.Top);
            if IntersectClipRect(Handle,0,0,Child.Width,Child.Height)<>NullRegion then
              PaintWidget(Child);
            RestoreHandleState;
          end;
        end;
        RestoreHandleState;
      end;
    end;
  end;

begin
  PaintWidget(MyForm);
  inherited Paint;
end;

function TLuiWidgetMediator.ComponentIsIcon(AComponent: TComponent): boolean;
begin
  Result:=not (AComponent is TLuiWidget);
end;

function TLuiWidgetMediator.ParentAcceptsChild(Parent: TComponent;
  Child: TComponentClass): boolean;
begin
  Result:=(Parent is TLuiWidget) and (Child.InheritsFrom(TLuiWidget))
    and (TLuiWidget(Parent).AcceptChildrenAtDesignTime);
end;

{ TFileDescPascalUnitWithMyForm }

constructor TFileDescPascalUnitWithMyForm.Create;
begin
  inherited Create;
  Name:='MyForm';
  ResourceClass:=TLuiForm;
  UseCreateFormStatements:=true;
end;

function TFileDescPascalUnitWithMyForm.GetInterfaceUsesSection: string;
begin
  Result:='Classes, SysUtils, MyWidgetSet';
end;

function TFileDescPascalUnitWithMyForm.GetLocalizedName: string;
begin
  Result:='MyForm';
end;

function TFileDescPascalUnitWithMyForm.GetLocalizedDescription: string;
begin
  Result:='Create a new MyForm from example package NotLCLDesigner';
end;

end.

