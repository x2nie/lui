{ Example widgetset.
  It does not have any useful implementation, it only provides the classes
  and published properties to define a child-parent relationship and some
  coordinates. The Lazarus designer will do the rest:
  Opening, closing, editing forms of this example widgetset.
  At designtime the TLuiWidgetMediator will paint.


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
unit Lui_beta;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Math, types, GraphType, FPCanvas;

type
  ILuiWidgetDesigner = interface(IUnknown)
    procedure InvalidateRect(Sender: TObject; ARect: TRect; Erase: boolean);
  end;

  TColor = TGraphicsColor;

  //TLuiCanvas = class(TFPCustomCanvas)
  TLuiCanvas = class(TPersistent)
  private
    FColor: TColor;
    FOnchange: TNotifyEvent;
    procedure SetColor(AValue: TColor);
  protected
    procedure DoChanged; virtual;
  public
    constructor Create; virtual;
    procedure FillRect(l,t,w,h:integer); virtual; abstract;
    procedure Rectangle(l,t,w,h:integer); virtual; abstract;
    procedure Line (x1,y1,x2,y2:integer);  virtual; abstract;
    property OnChange: TNotifyEvent read FOnchange write FOnchange;
    property Color : TColor read FColor write SetColor;
  end;
  TLuiCanvasClass = class of TLuiCanvas;

  { TLuiWidget }

  TLuiWidget = class(TComponent)
  private
    FAcceptChildrenAtDesignTime: boolean;
    FBorderBottom: integer;
    FBorderLeft: integer;
    FBorderRight: integer;
    FBorderTop: integer;
    FCanvas: TLuiCanvas;
    FCaption: string;
    FChilds: TFPList; // list of TLuiWidget
    FHeight: integer;
    FLeft: integer;
    FParent: TLuiWidget;
    FTop: integer;
    FVisible: boolean;
    FWidth: integer;
    function GetChilds(Index: integer): TLuiWidget;
    procedure SetBorderBottom(const AValue: integer);
    procedure SetBorderLeft(const AValue: integer);
    procedure SetBorderRight(const AValue: integer);
    procedure SetBorderTop(const AValue: integer);
    procedure SetCaption(const AValue: string);
    procedure SetHeight(const AValue: integer);
    procedure SetLeft(const AValue: integer);
    procedure SetParent(const AValue: TLuiWidget);
    procedure SetTop(const AValue: integer);
    procedure SetVisible(const AValue: boolean);
    procedure SetWidth(const AValue: integer);
  protected
    procedure InternalInvalidateRect({%H-}ARect: TRect; {%H-}Erase: boolean); virtual;
    procedure SetName(const NewName: TComponentName); override;
    procedure SetParentComponent(Value: TComponent); override;
    procedure GetChildren(Proc: TGetChildProc; Root: TComponent); override;
    procedure HandlePaint; virtual;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property Parent: TLuiWidget read FParent write SetParent;
    function ChildCount: integer;
    property Children[Index: integer]: TLuiWidget read GetChilds;
    function HasParent: Boolean; override;
    function GetParentComponent: TComponent; override;
    procedure SetBounds(NewLeft, NewTop, NewWidth, NewHeight: integer); virtual;
    procedure InvalidateRect(ARect: TRect; Erase: boolean);
    procedure Invalidate;
    property Canvas: TLuiCanvas read FCanvas write FCanvas;
    property AcceptChildrenAtDesignTime: boolean read FAcceptChildrenAtDesignTime;
  published
    property Left: integer read FLeft write SetLeft;
    property Top: integer read FTop write SetTop;
    property Width: integer read FWidth write SetWidth;
    property Height: integer read FHeight write SetHeight;
    property Visible: boolean read FVisible write SetVisible;
    property BorderLeft: integer read FBorderLeft write SetBorderLeft default 5;
    property BorderRight: integer read FBorderRight write SetBorderRight default 5;
    property BorderTop: integer read FBorderTop write SetBorderTop default 20;
    property BorderBottom: integer read FBorderBottom write SetBorderBottom default 5;
    property Caption: string read FCaption write SetCaption;
  end;
  TLuiWidgetClass = class of TLuiWidget;

  { TLuiForm }

  TLuiForm = class(TLuiWidget)
  private
    FDesigner: ILuiWidgetDesigner;
  protected
    procedure InternalInvalidateRect(ARect: TRect; Erase: boolean); override;
    procedure HandlePaint; override;
  public
    constructor Create(AOwner: TComponent); override;
    constructor CreateNew(AOwner: TComponent); virtual;
    property Designer: ILuiWidgetDesigner read FDesigner write FDesigner;
  end;

  { TLuiButton
    A widget that does not allow children at design time }

  TLuiButton = class(TLuiWidget)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TButton = class(TLuiButton)
  end;

  { TLuiGroupBox
    A widget that does allow children at design time }

  TLuiGroupBox = class(TLuiWidget)
  end;

  const
    // The following colors match the predefined Delphi Colors

    // standard colors
    clBlack   = TColor($000000);
    clMaroon  = TColor($000080);
    clGreen   = TColor($008000);
    clOlive   = TColor($008080);
    clNavy    = TColor($800000);
    clPurple  = TColor($800080);
    clTeal    = TColor($808000);
    clGray    = TColor($808080);
    clSilver  = TColor($C0C0C0);
    clRed     = TColor($0000FF);
    clLime    = TColor($00FF00);
    clYellow  = TColor($00FFFF);
    clBlue    = TColor($FF0000);
    clFuchsia = TColor($FF00FF);
    clAqua    = TColor($FFFF00);
    clLtGray  = TColor($C0C0C0); // clSilver alias
    clDkGray  = TColor($808080); // clGray alias
    clWhite   = TColor($FFFFFF);
    StandardColorsCount = 16;

    // extended colors
    clMoneyGreen = TColor($C0DCC0);
    clSkyBlue    = TColor($F0CAA6);
    clCream      = TColor($F0FBFF);
    //clMedGray    = TColor($A4A0A0);
    ExtendedColorCount = 4;

    // special colors
    clNone    = TColor($1FFFFFFF);
    clDefault = TColor($20000000);

    clMedGray = TColor($d5d2cd);


  { Canvas Intercept }
type
  TLuiCanvasCreator = function():TLuiCanvas;
var
  LuiCanvasCreatorProc : TLuiCanvasCreator = nil;

implementation

{ TLuiCanvas }

procedure TLuiCanvas.SetColor(AValue: TColor);
begin
  if FColor=AValue then Exit;
  FColor:=AValue;
  DoChanged;
end;

procedure TLuiCanvas.DoChanged;
begin
  if assigned(FOnchange) then
     FOnchange(self);
end;

constructor TLuiCanvas.Create;
begin

end;

{ TLuiWidget }

function TLuiWidget.GetChilds(Index: integer): TLuiWidget;
begin
  Result:=TLuiWidget(FChilds[Index]);
end;

procedure TLuiWidget.SetBorderBottom(const AValue: integer);
begin
  if FBorderBottom=AValue then exit;
  FBorderBottom:=AValue;
  Invalidate;
end;

procedure TLuiWidget.SetBorderLeft(const AValue: integer);
begin
  if FBorderLeft=AValue then exit;
  FBorderLeft:=AValue;
  Invalidate;
end;

procedure TLuiWidget.SetBorderRight(const AValue: integer);
begin
  if FBorderRight=AValue then exit;
  FBorderRight:=AValue;
  Invalidate;
end;

procedure TLuiWidget.SetBorderTop(const AValue: integer);
begin
  if FBorderTop=AValue then exit;
  FBorderTop:=AValue;
  Invalidate;
end;

procedure TLuiWidget.SetCaption(const AValue: string);
begin
  if FCaption=AValue then exit;
  FCaption:=AValue;
  Invalidate;
end;

procedure TLuiWidget.SetHeight(const AValue: integer);
begin
  SetBounds(Left,Top,Width,AValue);
end;

procedure TLuiWidget.SetLeft(const AValue: integer);
begin
  SetBounds(AValue,Top,Width,Height);
end;

procedure TLuiWidget.SetParent(const AValue: TLuiWidget);
begin
  if FParent=AValue then exit;
  if FParent<>nil then begin
    Invalidate;
    FParent.FChilds.Remove(Self);
  end;
  FParent:=AValue;
  if FParent<>nil then begin
    FParent.FChilds.Add(Self);
  end;
  Invalidate;
end;

procedure TLuiWidget.SetTop(const AValue: integer);
begin
  SetBounds(Left,AValue,Width,Height);
end;

procedure TLuiWidget.SetVisible(const AValue: boolean);
begin
  if FVisible=AValue then exit;
  FVisible:=AValue;
  Invalidate;
end;

procedure TLuiWidget.SetWidth(const AValue: integer);
begin
  SetBounds(Left,Top,AValue,Height);
end;

procedure TLuiWidget.InternalInvalidateRect(ARect: TRect; Erase: boolean);
begin
  // see TLuiForm
end;

procedure TLuiWidget.SetName(const NewName: TComponentName);
begin
  if Name=Caption then Caption:=NewName;
  inherited SetName(NewName);
end;

procedure TLuiWidget.SetParentComponent(Value: TComponent);
begin
  if Value is TLuiWidget then
    Parent:=TLuiWidget(Value);
end;

function TLuiWidget.HasParent: Boolean;
begin
  Result:=Parent<>nil;
end;

function TLuiWidget.GetParentComponent: TComponent;
begin
  Result:=Parent;
end;

procedure TLuiWidget.GetChildren(Proc: TGetChildProc; Root: TComponent);
var
  i: Integer;
begin
  for i:=0 to ChildCount-1 do
    if Children[i].Owner=Root then
      Proc(Children[i]);

  if Root = self then
    for i:=0 to ComponentCount-1 do
      if Components[i].GetParentComponent = nil then
        Proc(Components[i]);
end;

procedure TLuiWidget.HandlePaint;
begin
   with Canvas do
  begin
      // fill background
      //Brush.Style:=bsSolid;
      //Brush.Color:=TColor($FF0000);
      Color := clLtGray;
      FillRect(0,0,Width,Height);
      // outer frame
      //Pen.Color:=clRed;
      Color:=clFuchsia;
      Rectangle(0,0,Width,Height);
      // inner frame
      {if AcceptChildrenAtDesignTime then begin
        Pen.Color:=clMaroon;
        Rectangle(BorderLeft-1,BorderTop-1,
                  Width-BorderRight+1,
                  Height-BorderBottom+1);
      end;}
      // caption
      //TextOut(5,2,Caption);
  end;
end;

constructor TLuiWidget.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FCanvas := LuiCanvasCreatorProc();
  FChilds:=TFPList.Create;
  FBorderLeft:=5;
  FBorderRight:=5;
  FBorderBottom:=5;
  FBorderTop:=20;
  FAcceptChildrenAtDesignTime:=true;
end;

destructor TLuiWidget.Destroy;
begin
  Parent:=nil;
  while ChildCount>0 do Children[ChildCount-1].Free;
  FreeAndNil(FChilds);
  inherited Destroy;
end;

function TLuiWidget.ChildCount: integer;
begin
  Result:=FChilds.Count;
end;

procedure TLuiWidget.SetBounds(NewLeft, NewTop, NewWidth, NewHeight: integer);
begin
  if (Left=NewLeft) and (Top=NewTop) and (Width=NewWidth) and (Height=NewHeight) then
    exit;
  Invalidate;
  FLeft:=NewLeft;
  FTop:=NewTop;
  FWidth:=NewWidth;
  FHeight:=NewHeight;
  Invalidate;
end;

procedure TLuiWidget.InvalidateRect(ARect: TRect; Erase: boolean);
begin
  ARect.Left:=Max(0,ARect.Left);
  ARect.Top:=Max(0,ARect.Top);
  ARect.Right:=Min(Width,ARect.Right);
  ARect.Bottom:=Max(Height,ARect.Bottom);
  if Parent<>nil then begin
    OffsetRect(ARect,Left+Parent.BorderLeft,Top+Parent.BorderTop);
    Parent.InvalidateRect(ARect,Erase);
  end else begin
    InternalInvalidateRect(ARect,Erase);
  end;
end;

procedure TLuiWidget.Invalidate;
begin
  InvalidateRect(Rect(0,0,Width,Height),false);
end;

{ TLuiForm }

procedure TLuiForm.InternalInvalidateRect(ARect: TRect; Erase: boolean);
begin
  if (Parent=nil) and (Designer<>nil) then
    Designer.InvalidateRect(Self,ARect,Erase);
end;

procedure TLuiForm.HandlePaint;
begin
  with Canvas do
  begin
      // fill background
      //Brush.Style:=bsSolid;
      //Brush.Color:=TColor($FF0000);
      Color := clGray;
      Color := clMedGray;
      FillRect(0,0,Width,Height);
      // outer frame
      //Pen.Color:=clRed;
      //Color:=clRed;
      //Rectangle(0,0,Width,Height);


      // inner frame
      {Color := clWhite;
      FillRect(BorderLeft-1,BorderTop-1,
                  Width-BorderRight+1,
                  Height-BorderBottom+1);}

      //if AcceptChildrenAtDesignTime then begin
        Color:=clMaroon;
        Rectangle(BorderLeft-1,BorderTop-1,
                  Width-BorderRight+1,
                  Height-BorderBottom+1);
      //end;
      // caption
      //TextOut(5,2,Caption);
  end;
end;

constructor TLuiForm.Create(AOwner: TComponent);
begin
  CreateNew(AOwner);
  if (ClassType<>TLuiForm) and ([csDesignInstance, csDesigning]*ComponentState=[]) then
  begin
    if not InitInheritedComponent(Self, TLuiForm) then
      //raise EResNotFound.CreateFmt(rsResourceNotFound, [ClassName]);
  end;
end;

constructor TLuiForm.CreateNew(AOwner: TComponent);
begin
  inherited Create(AOwner);
  { default props here }
end;

{ TLuiButton }

constructor TLuiButton.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FAcceptChildrenAtDesignTime:=false;
end;

{ Canvas Intercept }

function ALuiCanvasCreator():TLuiCanvas;
begin
  result := TLuiCanvas.create();
end;

initialization
  LuiCanvasCreatorProc := @ALuiCanvasCreator;
end.

