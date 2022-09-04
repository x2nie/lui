unit lui_design_canvas;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Graphics, lui_beta;

type

  { TLuiDsgnCanvas }

  TLuiDsgnCanvas = class(TLuiCanvas)
  private
    FLclCanvas: TCanvas;
    procedure goPen;
    procedure goFill;
  protected
    procedure DoChanged; override;
  public
    constructor Create; override;
    procedure FillRect(l,t,w,h:integer); override;
    procedure Rectangle(l,t,w,h:integer); override;
    procedure Line (x1,y1,x2,y2:integer); override;

    property LclCanvas : TCanvas read FLclCanvas write FLclCanvas;
  end;

implementation

{ TLuiDsgnCanvas }

procedure TLuiDsgnCanvas.goPen;
begin
  FLclCanvas.Brush.Style:=bsClear;
  FLclCanvas.Pen.Color:=Color;
  FLclCanvas.Pen.Style:=psSolid;
end;

procedure TLuiDsgnCanvas.goFill;
begin
  FLclCanvas.Brush.Color:=Color;
  FLclCanvas.Brush.Style:=bsSolid;
  FLclCanvas.Pen.Style:=psClear;
end;

procedure TLuiDsgnCanvas.DoChanged;
begin
  inherited DoChanged;
end;

constructor TLuiDsgnCanvas.Create;
begin
  inherited Create;
end;

procedure TLuiDsgnCanvas.FillRect(l, t, w, h: integer);
begin
  goFill;
  FLclCanvas.FillRect(l,t,w,h);
end;

procedure TLuiDsgnCanvas.Rectangle(l, t, w, h: integer);
begin
  goPen;
  FLclCanvas.Rectangle(l,t,w,h);
end;

procedure TLuiDsgnCanvas.Line(x1, y1, x2, y2: integer);
begin
  goPen;
  FLclCanvas.Line(x1, y1, x2, y2);
end;

{ Canvas Intercept }

function ALuiLclCanvasCreator():TLuiCanvas;
begin
  result := TLuiDsgnCanvas.create();
end;

initialization
  LuiCanvasCreatorProc := @ALuiLclCanvasCreator;

end.

