{-----------------------------------------------------------------------------
The contents of this file are subject to the Mozilla Public License
Version 1.1 (the "License"); you may not use this file except in compliance
with the License. You may obtain a copy of the License at
http://www.mozilla.org/MPL/MPL-1.1.html

Software distributed under the License is distributed on an "AS IS" basis,
WITHOUT WARRANTY OF ANY KIND, either expressed or implied. See the License for
the specific language governing rights and limitations under the License.

The Original Code is: JvDockTree.pas, released on 2003-12-31.

The Initial Developer of the Original Code is luxiaoban.
Portions created by luxiaoban are Copyright (C) 2002,2003 luxiaoban.
All Rights Reserved.

Contributor(s):

Last Modified: 2003-12-31

You may retrieve the latest version of this file at the Project JEDI's JVCL home page,
located at http://jvcl.sourceforge.net

Known Issues:
-----------------------------------------------------------------------------}

{$I jvcl.inc}

unit JvDockTree;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Consts,
  JvDockJvDockSupportClass;

const
  HTSPLITTER = 30;
  HTNONE = 31;

type
  TJvDockTree = class;

  IJvDockManager = interface(IDockManager)
    ['{7B0AACBC-E9BF-42F8-9629-E551067090B2}']
    function GetActiveControl: TControl;
    procedure SetActiveControl(const Value: TControl);
    function GetGrabberSize: Integer;
    procedure SetGrabberSize(const Value: Integer);
    function GetDockSplitterWidth: Integer;
    procedure SetDockSplitterWidth(const Value: Integer);
    function GetBorderWidth: Integer;
    procedure SetBorderWidth(const Value: Integer);
    function GetDockRect: TRect;
    procedure SetDockRect(const Value: TRect);
    function GetDockSiteSize: Integer;
    procedure SetDockSiteSize(const Value: Integer);
    function GetMinSize: Integer;
    procedure BeginResizeDockSite;
    procedure EndResizeDockSite;
    function GetDockEdge(DockRect: TRect; MousePos: TPoint;
      var DropAlign: TAlign; Control: TControl): TControl;
    function GetHTFlag(MousePos: TPoint): Integer;
    procedure GetSiteInfo(Client: TControl;
      var InfluenceRect: TRect; MousePos: TPoint; var CanDock: Boolean);
    procedure ShowControl(Control: TControl);
    procedure HideControl(Control: TControl);
    procedure ShowAllControl;
    procedure HideAllControl;
    procedure ShowSingleControl(Control: TControl);
    procedure HideSingleControl(Control: TControl);
    procedure ReplaceZoneChild(OldControl, NewControl: TControl);
    function HasZoneWithControl(Control: TControl): Boolean;
    function GetDockClientLimit(Orient: TDockOrientation; IsMin: Boolean): Integer;
    function GetFrameRect(Control: TControl): TRect;
    function GetFrameRectEx(Control: TControl): TRect;
    property ActiveControl: TControl read GetActiveControl write SetActiveControl;
    property GrabberSize: Integer read GetGrabberSize write SetGrabberSize;
    property SplitterWidth: Integer read GetDockSplitterWidth write SetDockSplitterWidth;
    property BorderWidth: Integer read GetBorderWidth write SetBorderWidth;
    property DockSiteSize: Integer read GetDockSiteSize write SetDockSiteSize;
    property DockRect: TRect read GetDockRect write SetDockRect;
    property MinSize: Integer read GetMinSize;
  end;

  TJvDockZone = class(TObject)
  private
    FChildControl: TWinControl;
    FChildZones: TJvDockZone;
    FNextSibling: TJvDockZone;
    FOrientation: TDockOrientation;
    FParentZone: TJvDockZone;
    FPrevSibling: TJvDockZone;
    FTree: TJvDockTree;
    FZoneLimit: Integer;
    FVisibleSize: Integer;
    FVisibled: Boolean;
    FControlVisibled: Boolean;
    FIsInside: Boolean;
    function GetFirstSibling: TJvDockZone;
    function GetLastSibling: TJvDockZone;
    function GetFirstChild: TJvDockZone;
    function GetLastChild: TJvDockZone;
    function GetTopLeftArr(Orient: TDockOrientation): Integer;
    function GetHeightWidthArr(Orient: TDockOrientation): Integer;
    function GetAfterClosestVisibleZone: TJvDockZone;
    function GetBeforeClosestVisibleZone: TJvDockZone;
    function GetAfterApoapsisVisibleZone: TJvDockZone;
    function GetBeforeApoapsisVisibleZone: TJvDockZone;
    function GetNextSiblingCount: Integer;
    function GetPrevSiblingCount: Integer;
    procedure SetVisibled(const Value: Boolean);
    procedure SetZoneLimit(const Value: Integer);
    function GetVisibleNextSiblingCount: Integer;
    function GetVisibleNextSiblingTotal: Integer;
    function GetVisiblePrevSiblingCount: Integer;
    function GetVisiblePrevSiblingTotal: Integer;
    function GetFirstVisibleChildZone: TJvDockZone;
    function GetLastVisibleChildZone: TJvDockZone;
    procedure SetIsInside(const Value: Boolean);
  protected
    procedure AdjustZoneLimit(Value: Integer); virtual;
    procedure LButtonDblClkMethod; virtual;
    function GetChildCount: Integer;
    function GetVisibleChildCount: Integer;
    function GetChildTotal: Integer;
    function GetVisibleChildTotal: Integer;
    function GetLimitBegin: Integer;
    function GetLimitSize: Integer;
    function GetTopLeft(Orient: Integer): Integer;
    function GetHeightWidth(Orient: Integer): Integer;
    function GetControlName: string;
    function GetSplitterLimit(IsMin: Boolean): Integer; virtual;
    function DoGetSplitterLimit(Orientation: TDockOrientation;
      IsMin: Boolean; var LimitResult: Integer): Integer; virtual;
    function SetControlName(const Value: string): Boolean;
    procedure DoCustomSetControlName; virtual;
    procedure SetChildControlVisible(Client: TControl; AVisible: Boolean); virtual;
  public
    constructor Create(Tree: TJvDockTree); virtual;
    procedure Insert(DockSize: Integer; Hide: Boolean); virtual;
    procedure Remove(DockSize: Integer; Hide: Boolean); virtual;
    procedure InsertOrRemove(DockSize: Integer; Insert: Boolean; Hide: Boolean); virtual;
    procedure ResetChildren(Exclude: TJvDockZone); virtual;
    procedure Update; virtual;
    function GetFrameRect: TRect; virtual;
    procedure SetZoneSize(Size: Integer; Show: Boolean); virtual;
    property BeforeClosestVisibleZone: TJvDockZone read GetBeforeClosestVisibleZone;
    property AfterClosestVisibleZone: TJvDockZone read GetAfterClosestVisibleZone;
    property BeforeApoapsisVisibleZone: TJvDockZone read GetBeforeApoapsisVisibleZone;
    property AfterApoapsisVisibleZone: TJvDockZone read GetAfterApoapsisVisibleZone;
    property FirstVisibleChildZone: TJvDockZone read GetFirstVisibleChildZone;
    property LastVisibleChildZone: TJvDockZone read GetLastVisibleChildZone;
    property ChildCount: Integer read GetChildCount;
    property ChildTotal: Integer read GetChildTotal;
    property ChildZones: TJvDockZone read FChildZones write FChildZones;
    property ChildControl: TWinControl read FChildControl write FChildControl;
    property FirstChild: TJvDockZone read GetFirstChild;
    property FirstSibling: TJvDockZone read GetFirstSibling;
    property Height: Integer index Ord(doHorizontal) read GetHeightWidth;
    property HeightWidth[Orient: TDockOrientation]: Integer read GetHeightWidthArr;
    property LastChild: TJvDockZone read GetLastChild;
    property LastSibling: TJvDockZone read GetLastSibling;
    property Left: Integer index Ord(doVertical) read GetTopLeft;
    property LimitBegin: Integer read GetLimitBegin;
    property LimitSize: Integer read GetLimitSize;
    property NextSibling: TJvDockZone read FNextSibling write FNextSibling;
    property NextSiblingCount: Integer read GetNextSiblingCount;
    property Orientation: TDockOrientation read FOrientation write FOrientation;
    property ParentZone: TJvDockZone read FParentZone write FParentZone;
    property PrevSibling: TJvDockZone read FPrevSibling write FPrevSibling;
    property PrevSiblingCount: Integer read GetPrevSiblingCount;
    property Top: Integer index Ord(doHorizontal) read GetTopLeft;
    property TopLeft[Orient: TDockOrientation]: Integer read GetTopLeftArr;
    property Tree: TJvDockTree read FTree write FTree;
    property VisibleChildCount: Integer read GetVisibleChildCount;
    property VisibleChildTotal: Integer read GetVisibleChildTotal;
    property VisiblePrevSiblingCount: Integer read GetVisiblePrevSiblingCount;
    property VisiblePrevSiblingTotal: Integer read GetVisiblePrevSiblingTotal;
    property VisibleNextSiblingCount: Integer read GetVisibleNextSiblingCount;
    property VisibleNextSiblingTotal: Integer read GetVisibleNextSiblingTotal;
    property VisibleSize: Integer read FVisibleSize write FVisibleSize;
    property Width: Integer index Ord(doVertical) read GetHeightWidth;
    property ZoneLimit: Integer read FZoneLimit write SetZoneLimit;
    property Visibled: Boolean read FVisibled write SetVisibled;
    property IsInside: Boolean read FIsInside write SetIsInside;
  end;

  TJvDockAdvZone = class(TJvDockZone)
  private
    FCloseBtnDown: Boolean;
    FMouseDown: Boolean;
  protected
    procedure LButtonDblClkMethod; override;
  public
    constructor Create(Tree: TJvDockTree); override;
    destructor Destroy; override;
    procedure Insert(DockSize: Integer; Hide: Boolean); override;
    procedure Remove(DockSize: Integer; Hide: Boolean); override;
    property CloseBtnDown: Boolean read FCloseBtnDown write FCloseBtnDown;
    property MouseDown: Boolean read FMouseDown write FMouseDown;
  end;

  TJvDockTreeScanKind = (tskForward, tskMiddle, tskBackward);
  TJvDockTreeScanPriority = (tspSibling, tspChild);
  TJvDockGrabbersPosition = (gpTop, gpBottom, gpLeft, gpRight);
  TJvDockForEachZoneProc = procedure(Zone: TJvDockZone) of object;
  TJvDockZoneClass = class of TJvDockZone;

  TJvDockTree = class(TInterfacedObject, IJvDockManager)
  private
    FDockZoneClass: TJvDockZoneClass;
    FActiveControl: TControl;
    FBorderWidth: Integer;
    FSplitterWidth: Integer;
    FBrush: TBrush;
    FDockSite: TWinControl;
    FGrabberSize: Integer;
    FPreviousRect: TRect;
    FDockRect: TRect;
    FOldWndProc: TWndMethod;
    FReplacementZone: TJvDockZone;
    FResizeCount: Integer;
    FScaleBy: Double;
    FShiftScaleOrientation: TDockOrientation;
    FShiftBy: Integer;
    FSizePos: TPoint;
    FSizingDC: HDC;
    FSizingWnd: HWND;
    FSizingZone: TJvDockZone;
    FTopZone: TJvDockZone;
    FTopXYLimit: Integer;
    FUpdateCount: Integer;
    FVersion: Integer;
    FOldHTFlag: Integer;
    FParentLimit: Integer;
    FMinSize: Integer;
    FCanvas: TControlCanvas;
    procedure SetTopZone(const Value: TJvDockZone);
    procedure SetTopXYLimit(const Value: Integer);
    procedure SetDockZoneClass(const Value: TJvDockZoneClass);
    function GetDockSplitterWidth: Integer;
    function GetBorderWidth: Integer;
    procedure SetDockSplitterWidth(const Value: Integer);
    procedure SetBorderWidth(const Value: Integer);
    function GetDockSiteOrientation: TDockOrientation;
    function GetDockSiteSize: Integer;
    procedure SetDockSiteSize(const Value: Integer);
    procedure SetMinSize(const Value: Integer);
    function GetDockSiteBegin: Integer;
    procedure SetDockSiteBegin(const Value: Integer);
    function GetDockSiteSizeAlternatelternatelternate: Integer;
    procedure SetDockSiteSizeAlternatelternatelternate(const Value: Integer);
    procedure SetVersion(const Value: Integer);
    function GetDockSiteSizeWithOrientation(Orient: TDockOrientation): Integer;
    procedure SetDockSiteSizeWithOrientation(Orient: TDockOrientation; const Value: Integer);
    function GetDockRect: TRect;
    procedure SetDockRect(const Value: TRect);
    function GetMinSize: Integer;
  protected
    function HasZoneWithControl(Control: TControl): Boolean;
    procedure WindowProc(var Msg: TMessage); virtual;
    procedure BeginDrag(Control: TControl;
      Immediate: Boolean; Threshold: Integer = -1); virtual;
    function DoMouseEvent(var Msg: TWMMouse;
      var Zone: TJvDockZone; out HTFlag: Integer): TWMNCHitMessage; virtual;
    procedure DoMouseMove(var Msg: TWMMouse;
      var Zone: TJvDockZone; out HTFlag: Integer); virtual;
    function DoLButtonDown(var Msg: TWMMouse;
      var Zone: TJvDockZone; out HTFlag: Integer): Boolean; virtual;
    procedure DoLButtonUp(var Msg: TWMMouse;
      var Zone: TJvDockZone; out HTFlag: Integer); virtual;
    procedure DoLButtonDbClk(var Msg: TWMMouse;
      var Zone: TJvDockZone; out HTFlag: Integer); virtual;
    procedure DoMButtonDown(var Msg: TWMMouse;
      var Zone: TJvDockZone; out HTFlag: Integer); virtual;
    procedure DoMButtonUp(var Msg: TWMMouse;
      var Zone: TJvDockZone; out HTFlag: Integer); virtual;
    procedure DoMButtonDbClk(var Msg: TWMMouse;
      var Zone: TJvDockZone; out HTFlag: Integer); virtual;
    procedure DoRButtonDown(var Msg: TWMMouse;
      var Zone: TJvDockZone; out HTFlag: Integer); virtual;
    procedure DoRButtonUp(var Msg: TWMMouse;
      var Zone: TJvDockZone; out HTFlag: Integer); virtual;
    procedure DoRButtonDbClk(var Msg: TWMMouse;
      var Zone: TJvDockZone; out HTFlag: Integer); virtual;
    procedure DoHideZoneChild(AZone: TJvDockZone); virtual;
    procedure DoSetCursor(var Msg: TWMSetCursor;
      var Zone: TJvDockZone; out HTFlag: Integer); virtual;
    procedure DoHintShow(var Msg: TCMHintShow;
      var Zone: TJvDockZone; out HTFlag: Integer); virtual;
    procedure DoOtherHint(Zone: TJvDockZone;
      HTFlag: Integer; var HintStr: string); virtual;
    procedure CustomSaveZone(Stream: TStream;
      Zone: TJvDockZone); virtual;
    procedure CustomLoadZone(Stream: TStream;
      var Zone: TJvDockZone); virtual;
    procedure DoSaveZone(Stream: TStream;
      Zone: TJvDockZone; Level: Integer); virtual;
    procedure DoLoadZone(Stream: TStream); virtual;
    procedure AdjustDockRect(Control: TControl; var ARect: TRect); virtual;
    procedure BeginResizeDockSite;
    procedure BeginUpdate;
    procedure CalcSplitterPos; virtual;
    procedure ControlVisibilityChanged(Control: TControl; Visible: Boolean); virtual;
    function GetDockAlign(Client: TControl; var DropCtl: TControl): TAlign; virtual;
    function DoFindZone(const MousePos: TPoint;
      out HTFlag: Integer; Zone: TJvDockZone): TJvDockZone; virtual;
    procedure DrawSizeSplitter; virtual;
    procedure EndResizeDockSite;
    procedure EndUpdate;
    function FindControlZone(Control: TControl; IncludeHide: Boolean = False): TJvDockZone; virtual;
    function FindControlZoneAndLevel(Control: TControl;
      var CtlLevel: Integer; IncludeHide: Boolean = False): TJvDockZone; virtual;
    procedure ForEachAt(Zone: TJvDockZone; Proc: TJvDockForEachZoneProc;
      ScanKind: TJvDockTreeScanKind = tskForward; ScanPriority: TJvDockTreeScanPriority = tspSibling); virtual;
    function GetActiveControl: TControl; virtual;
    function GetGrabberSize: Integer; virtual;
    function GetBorderHTFlag(const MousePos: TPoint;
      out HTFlag: Integer; Zone: TJvDockZone): TJvDockZone; virtual;
    function GetLeftGrabbersHTFlag(const MousePos: TPoint;
      out HTFlag: Integer; Zone: TJvDockZone): TJvDockZone; virtual;
    function GetRightGrabbersHTFlag(const MousePos: TPoint;
      out HTFlag: Integer; Zone: TJvDockZone): TJvDockZone; virtual;
    function GetTopGrabbersHTFlag(const MousePos: TPoint;
      out HTFlag: Integer; Zone: TJvDockZone): TJvDockZone; virtual;
    function GetBottomGrabbersHTFlag(const MousePos: TPoint;
      out HTFlag: Integer; Zone: TJvDockZone): TJvDockZone; virtual;
    function GetDockEdge(DockRect: TRect; MousePos: TPoint;
      var DropAlign: TAlign; Control: TControl): TControl; virtual;
    function GetDockClientLimit(Orient: TDockOrientation; IsMin: Boolean): Integer; virtual;
    function GetFrameRect(Control: TControl): TRect; virtual;
    function GetFrameRectEx(Control: TControl): TRect; virtual;
    function GetSplitterRect(Zone: TJvDockZone): TRect; virtual;
    function GeTJvDockGrabbersPosition: TJvDockGrabbersPosition; virtual;
    procedure GetControlBounds(Control: TControl; out CtlBounds: TRect); virtual;
    function GetSplitterLimit(AZone: TJvDockZone; IsCurrent, IsMin: Boolean): Integer; virtual;
    procedure DoGetNextLimit(Zone, AZone: TJvDockZone; var LimitResult: Integer); virtual;
    function GetHTFlag(MousePos: TPoint): Integer; virtual;
    procedure GetSiteInfo(Client: TControl;
      var InfluenceRect: TRect; MousePos: TPoint; var CanDock: Boolean); virtual;
    function HitTest(const MousePos: TPoint; out HTFlag: Integer): TControl; virtual;
    function InternalHitTest(const MousePos: TPoint;
      out HTFlag: Integer): TJvDockZone; virtual;
    procedure InsertControl(Control: TControl; InsertAt: TAlign;
      DropCtl: TControl); virtual;
    procedure InsertNewParent(NewZone, SiblingZone: TJvDockZone;
      ParentOrientation: TDockOrientation; InsertLast, Update: Boolean); virtual;
    procedure InsertSibling(NewZone, SiblingZone: TJvDockZone;
      InsertLast, Update: Boolean); virtual;
    procedure LoadFromStream(Stream: TStream); virtual;
    procedure SaveToStream(Stream: TStream); virtual;
    procedure PaintDockSite; virtual;
    procedure DrawDockSiteRect; virtual;
    procedure DrawZone(Zone: TJvDockZone); virtual;
    procedure DrawZoneGrabber(Zone: TJvDockZone); virtual;
    procedure DrawDockGrabber(Control: TControl; const ARect: TRect); virtual;
    procedure DrawZoneSplitter(Zone: TJvDockZone); virtual;
    procedure DrawSplitterRect(const ARect: TRect); virtual;
    procedure DrawZoneBorder(Zone: TJvDockZone); virtual;
    procedure DrawDockBorder(DockControl: TControl; R1, R2: TRect); virtual;
    procedure GetCaptionRect(var Rect: TRect); virtual;
    procedure PositionDockRect(Client, DropCtl: TControl;
      DropAlign: TAlign; var DockRect: TRect); virtual;
    procedure PruneZone(Zone: TJvDockZone); virtual;
    procedure RemoveZone(Zone: TJvDockZone; Hide: Boolean = True); virtual;
    procedure ScaleZone(Zone: TJvDockZone); virtual;
    procedure ScaleChildZone(Zone: TJvDockZone); virtual;
    procedure ScaleSiblingZone(Zone: TJvDockZone); virtual;
    procedure ShiftZone(Zone: TJvDockZone); virtual;
    procedure UpdateZone(Zone: TJvDockZone); virtual;
    procedure DrawSplitter(Zone: TJvDockZone); virtual;
    procedure RemoveControl(Control: TControl); virtual;
    procedure SetActiveControl(const Value: TControl); virtual;
    procedure SetGrabberSize(const Value: Integer); virtual;
    procedure SetNewBounds(Zone: TJvDockZone); virtual;
    procedure SetReplacingControl(Control: TControl);
    procedure SplitterMouseDown(OnZone: TJvDockZone; MousePos: TPoint); virtual;
    procedure SplitterMouseUp; virtual;
    procedure ResetBounds(Force: Boolean); virtual;
    procedure WriteControlName(Stream: TStream; ControlName: string);
    procedure ReadControlName(Stream: TStream; var ControlName: string);
    procedure ShowControl(Control: TControl);
    procedure HideControl(Control: TControl);
    procedure ShowAllControl;
    procedure HideAllControl;
    procedure ShowSingleControl(Control: TControl);
    procedure HideSingleControl(Control: TControl);
    procedure ReplaceZoneChild(OldControl, NewControl: TControl);
    property BorderWidth: Integer read GetBorderWidth write SetBorderWidth;
    property Canvas: TControlCanvas read FCanvas;
    property DockSiteSize: Integer read GetDockSiteSize write SetDockSiteSize;
    property DockSiteSizeAlternatelternate: Integer read GetDockSiteSizeAlternatelternatelternate write SetDockSiteSizeAlternatelternatelternate;
    property DockSiteBegin: Integer read GetDockSiteBegin write SetDockSiteBegin;
    property DockSiteSizeWithOrientationation[Orient: TDockOrientation]: Integer
    read GetDockSiteSizeWithOrientation write SetDockSiteSizeWithOrientation;
    property GrabberSize: Integer read FGrabberSize write SetGrabberSize;
    property GrabbersPosition: TJvDockGrabbersPosition read GeTJvDockGrabbersPosition;
    property MinSize: Integer read GetMinSize write SetMinSize;
    property DockRect: TRect read GetDockRect write SetDockRect;
    property PreviousRect: TRect read FPreviousRect write FPreviousRect;
    property ParentLimit: Integer read FParentLimit write FParentLimit;
    property ReplacementZone: TJvDockZone read FReplacementZone write FReplacementZone;
    property ResizeCount: Integer read FResizeCount write FResizeCount;
    property ScaleBy: Double read FScaleBy write FScaleBy;
    property ShiftBy: Integer read FShiftBy write FShiftBy;
    property ShiftScaleOrientationation: TDockOrientation read FShiftScaleOrientation write FShiftScaleOrientation;
    property SizePos: TPoint read FSizePos write FSizePos;
    property SizingDC: HDC read FSizingDC;
    property SizingWnd: HWND read FSizingWnd;
    property SizingZone: TJvDockZone read FSizingZone write FSizingZone;
    property SplitterWidth: Integer read GetDockSplitterWidth write SetDockSplitterWidth;
    property UpdateCount: Integer read FUpdateCount write FUpdateCount;
    property Version: Integer read FVersion write SetVersion;
  public
    // (rom) deactivated  completely unused
    // SplitterCanvas: TControlCanvas;
    constructor Create(DockSite: TWinControl; ADockZoneClass: TJvDockZoneClass); virtual;
    destructor Destroy; override;
    property DockSite: TWinControl read FDockSite write FDockSite;
    property DockSiteOrientationation: TDockOrientation read GetDockSiteOrientation;
    procedure SetSplitterCursor(CursorIndex: TDockOrientation); virtual;
    procedure PaintSite(DC: HDC); virtual;
    property TopXYLimit: Integer read FTopXYLimit write SetTopXYLimit;
    property TopZone: TJvDockZone read FTopZone write SetTopZone;
    procedure UpdateAll;
    procedure UpdateChild(Zone: TJvDockZone);
    property DockZoneClass: TJvDockZoneClass read FDockZoneClass write SetDockZoneClass;
  end;

  TJvDockTreeClass = class of TJvDockTree;

  TJvDockAdvTree = class(TJvDockTree)
  private
    FButtonHeight: Integer;
    FButtonWidth: Integer;
    FLeftOffset: Integer;
    FRightOffset: Integer;
    FTopOffset: Integer;
    FBottomOffset: Integer;
    FButtonSplitter: Integer;
    FCloseButtonZone: TJvDockAdvZone;
    FDropDockSize: Integer;
    FDockHeightWidth: array[TDockOrientation] of Integer;
    FDockRectangles: array[TDockOrientation, Boolean] of Integer;
    procedure SetBottomOffset(const Value: Integer);
    procedure SetButtonHeight(const Value: Integer);
    procedure SetButtonSplitter(const Value: Integer);
    procedure SetButtonWidth(const Value: Integer);
    procedure SetLeftOffset(const Value: Integer);
    procedure SetRightOffset(const Value: Integer);
    procedure SetTopOffset(const Value: Integer);
    function GetDockHeightWidth(Orient: TDockOrientation): Integer;
    procedure SetDockHeightWidth(Orient: TDockOrientation; const Value: Integer);
    function GetDockRectFromArr(Orient: TDockOrientation; AtLast: Boolean): Integer;
    procedure SetDockRectToArr(Orient: TDockOrientation; AtLast: Boolean; const Value: Integer);
    procedure SetDropDockSize(const Value: Integer);
  protected
    function DoLButtonDown(var Msg: TWMMouse;
      var Zone: TJvDockZone; out HTFlag: Integer): Boolean; override;
    procedure DoLButtonUp(var Msg: TWMMouse;
      var Zone: TJvDockZone; out HTFlag: Integer); override;
    procedure DoMouseMove(var Msg: TWMMouse;
      var Zone: TJvDockZone; out HTFlag: Integer); override;
    procedure InsertSibling(NewZone, SiblingZone: TJvDockZone;
      InsertLast, Update: Boolean); override;
    procedure InsertNewParent(NewZone, SiblingZone: TJvDockZone;
      ParentOrientation: TDockOrientation; InsertLast, Update: Boolean); override;
    procedure SetDockHeightWidthArr(NoOrValue, HorValue, VerValue: Integer);
    procedure SetDockRectangles(ARect: TRect);
    procedure ScaleZone(Zone: TJvDockZone); override;
    procedure ScaleChildZone(Zone: TJvDockZone); override;
    procedure ScaleSiblingZone(Zone: TJvDockZone); override;
    procedure ShiftZone(Zone: TJvDockZone); override;
    procedure RemoveZone(Zone: TJvDockZone; Hide: Boolean); override;
  public
    constructor Create(DockSite: TWinControl; ADockZoneClass: TJvDockZoneClass); override;
    property BottomOffset: Integer read FBottomOffset write SetBottomOffset;
    property ButtonHeight: Integer read FButtonHeight write SetButtonHeight;
    property ButtonSplitter: Integer read FButtonSplitter write SetButtonSplitter;
    property ButtonWidth: Integer read FButtonWidth write SetButtonWidth;
    property LeftOffset: Integer read FLeftOffset write SetLeftOffset;
    property RightOffset: Integer read FRightOffset write SetRightOffset;
    property TopOffset: Integer read FTopOffset write SetTopOffset;
    property CloseButtonZone: TJvDockAdvZone read FCloseButtonZone write FCloseButtonZone;
    property DockHeightWidth[Orient: TDockOrientation]: Integer read GetDockHeightWidth write SetDockHeightWidth;
    property DockRectangles[Orient: TDockOrientation; AtLast: Boolean]: Integer read GetDockRectFromArr write
      SetDockRectToArr;
    property DropDockSize: Integer read FDropDockSize write SetDropDockSize;
  end;

// (rom) made typed const to allow SizeOf
const
  TreeStreamEndFlag: Integer = -1;

implementation

uses
  Math,
  JvDockControlForm, JvDockJvDockSupportProc, JvDockGlobals, JvDockVSNetStyle;

type
  THackWinControl = class(TWinControl);

//=== TJvDockZone ============================================================

constructor TJvDockZone.Create(Tree: TJvDockTree);
begin
  ParentZone := nil;
  PrevSibling := nil;
  NextSibling := nil;
  ChildZones := nil;
  ChildControl := nil;
  FTree := Tree;
  FVisibled := True;
end;

function TJvDockZone.GetChildCount: Integer;
var
  Zone: TJvDockZone;
begin
  Result := 0;
  Zone := ChildZones;
  while Zone <> nil do
  begin
    Zone := Zone.NextSibling;
    Inc(Result);
  end;
end;

function TJvDockZone.GetLimitBegin: Integer;
var
  CheckZone: TJvDockZone;
begin
  if FTree.FTopZone = Self then
    CheckZone := Self
  else
    CheckZone := FParentZone;
  if CheckZone.Orientation = doHorizontal then
    Result := Top
  else
  if CheckZone.Orientation = doVertical then
    Result := Left
  else
    Result := 0;
end;

function TJvDockZone.GetLimitSize: Integer;
var
  CheckZone: TJvDockZone;
begin
  if FTree.FTopZone = Self then
    CheckZone := Self
  else
    CheckZone := FParentZone;
  if CheckZone.Orientation = doHorizontal then
    Result := Height
  else
  if CheckZone.Orientation = doVertical then
    Result := Width
  else
    Result := Tree.TopXYLimit;
end;

function TJvDockZone.GetTopLeft(Orient: Integer): Integer;
var
  Zone: TJvDockZone;
  R: TRect;
begin
  Zone := Self;
  while Zone <> FTree.FTopZone do
  begin
    if (Zone.VisiblePrevSiblingCount > 0) and (Zone.ParentZone.Orientation = TDockOrientation(Orient)) then
    begin
      Result := Zone.BeforeClosestVisibleZone.ZoneLimit;
      Exit;
    end
    else
      Zone := Zone.ParentZone;
  end;
  R := FTree.FDockSite.ClientRect;
  THackWinControl(FTree.FDockSite).AdjustClientRect(R);
  case TDockOrientation(Orient) of
    doVertical:
      Result := R.Left;
    doHorizontal:
      Result := R.Top;
  else
    Result := 0;
  end;
end;

function TJvDockZone.GetHeightWidth(Orient: Integer): Integer;
var
  Zone: TJvDockZone;
  R: TRect;
begin
  if (Self = FTree.FTopZone) or ((FParentZone = FTree.FTopZone) and
    (ChildControl <> nil) and (FTree.FTopZone.ChildCount = 1)) then
  begin
    R := FTree.FDockSite.ClientRect;
    THackWinControl(FTree.FDockSite).AdjustClientRect(R);
    if TDockOrientation(Orient) = doHorizontal then
      Result := R.Bottom - R.Top
    else
      Result := R.Right - R.Left;
  end
  else
  begin
    Zone := Self;
    while (Zone <> FTree.FTopZone) and (Zone.ParentZone <> nil) do
    begin
      if Zone.ParentZone.Orientation = TDockOrientation(Orient) then
      begin
        Result := Zone.ZoneLimit - Zone.LimitBegin;
        Exit;
      end
      else
        Zone := Zone.ParentZone;
    end;
    if FTree.FTopZone.Orientation = TDockOrientation(Orient) then
      Result := FTree.TopXYLimit
    else
      Result := FTree.FTopZone.ZoneLimit;
  end;
end;

procedure TJvDockZone.ResetChildren(Exclude: TJvDockZone);
var
  SumLimit: Integer;
  NewLimit: Integer;
  FirstChildBegin: Integer;
  OldPrevLimit: Integer;
  ChildNode: TJvDockZone;
  PrevNode: TJvDockZone;
begin
  case Orientation of
    doHorizontal:
      NewLimit := Height;
    doVertical:
      NewLimit := Width;
  else
    Exit;
  end;

  ChildNode := FirstVisibleChildZone;
  if ChildNode = nil then
    Exit;

  SumLimit := NewLimit;
  NewLimit := NewLimit div VisibleChildCount;

  FirstChildBegin := ChildNode.LimitBegin;

  Tree.ShiftScaleOrientationation := Orientation;
  Tree.ParentLimit := 0;
  if ChildNode.ZoneLimit - FirstChildBegin > 0 then
    Tree.ScaleBy := NewLimit / (ChildNode.ZoneLimit - FirstChildBegin)
  else
    Tree.ScaleBy := 1;
  if (Tree.ScaleBy <> 1) and (ChildNode.VisibleChildCount > 0) then
    Tree.ForEachAt(ChildNode.ChildZones, Tree.ScaleChildZone, tskMiddle, tspChild);

  if ChildNode <> Exclude then
    OldPrevLimit := ChildNode.ZoneLimit
  else
    OldPrevLimit := FirstChildBegin;

  ChildNode.ZoneLimit := FirstChildBegin + NewLimit;
  ChildNode.Update;

  PrevNode := ChildNode;
  ChildNode := ChildNode.AfterClosestVisibleZone;

  while ChildNode <> nil do
  begin
    if ChildNode.ZoneLimit - OldPrevLimit > 0 then
      Tree.ScaleBy := NewLimit / (ChildNode.ZoneLimit - OldPrevLimit)
    else
      Tree.ScaleBy := 1;

    Tree.ShiftBy := PrevNode.ZoneLimit - OldPrevLimit;
    if (Tree.ShiftBy <> 0) and (ChildNode.VisibleChildCount > 0) then
      Tree.ForEachAt(ChildNode.ChildZones, Tree.ShiftZone, tskForward);

    Tree.ParentLimit := PrevNode.ZoneLimit;

    if (Tree.ScaleBy <> 1) and (ChildNode.VisibleChildCount > 0) then
      Tree.ForEachAt(ChildNode.ChildZones, Tree.ScaleChildZone, tskForward);

    if ChildNode <> Exclude then
      OldPrevLimit := ChildNode.ZoneLimit;

    ChildNode.ZoneLimit := PrevNode.ZoneLimit + NewLimit;

    if ChildNode.AfterClosestVisibleZone = nil then
    begin
      if NewLimit = 0 then
        NewLimit := 1;
      ChildNode.ZoneLimit := ChildNode.ZoneLimit + (SumLimit mod NewLimit);
    end;
    ChildNode.Update;
    PrevNode := ChildNode;
    ChildNode := ChildNode.AfterClosestVisibleZone;
  end;
end;

function TJvDockZone.GetControlName: string;
begin
  Result := '';
  if ChildControl <> nil then
  begin
    if ChildControl.Name = '' then
      raise Exception.CreateRes(@SDockedCtlNeedsName);
    Result := ChildControl.Name;
  end;
end;

function TJvDockZone.SetControlName(const Value: string): Boolean;
var
  Client: TControl;
begin
  Client := nil;
  with FTree do
  begin
    THackWinControl(FDockSite).ReloadDockedControl(Value, Client);
    Result := Client <> nil;
    if Result then
    begin
      FReplacementZone := Self;
      ChildControl := TWinControl(Client);
      DoCustomSetControlName;
      try
        if IsInside then
          Client.ManualDock(FDockSite, nil, alNone);
      finally
        SetChildControlVisible(Client, FControlVisibled);
        FReplacementZone := nil;
      end;
    end;
  end;
end;

procedure TJvDockZone.Update;
var
  NewWidth, NewHeight: Integer;
  R: TRect;

  function ParentNotLast: Boolean;
  var
    Parent: TJvDockZone;
  begin
    Result := False;
    Parent := FParentZone;
    while Parent <> nil do
    begin
      if (Parent.VisibleNextSiblingCount > 0) and (Parent.Orientation = ParentZone.Orientation) then
      begin
        Result := True;
        Exit;
      end;
      Parent := Parent.FParentZone;
    end;
  end;

begin
  if Visibled and (ChildControl <> nil) and (FTree.FUpdateCount = 0) then
  begin
    ChildControl.DockOrientation := FParentZone.Orientation;
    NewWidth := Width;
    NewHeight := Height;
    if ParentNotLast then
      if FParentZone.Orientation = doHorizontal then
        Dec(NewWidth, FTree.SplitterWidth)
      else
        Dec(NewHeight, FTree.SplitterWidth);

    if ((NextSibling <> nil) and (VisibleNextSiblingTotal > 0)) or ((FParentZone <> FTree.FTopZone) and
      ((FParentZone.Orientation = FTree.FTopZone.Orientation) and
      (FZoneLimit < FTree.TopXYLimit)) or
      ((FParentZone.Orientation <> FTree.FTopZone.Orientation) and
      (FZoneLimit < FTree.FTopZone.ZoneLimit))) then
      if FParentZone.Orientation = doHorizontal then
        Dec(NewHeight, FTree.SplitterWidth)
      else
        Dec(NewWidth, FTree.SplitterWidth);
    R := Bounds(Left, Top, NewWidth, NewHeight);
    FTree.AdjustDockRect(ChildControl, R);
    ChildControl.BoundsRect := R;
  end;
end;

function TJvDockZone.GetFrameRect: TRect;
var
  ALeft, ATop, ARight, ABottom, BorderWidth: Integer;
begin
  ALeft := Left;
  ATop := Top;
  if NextSibling <> nil then
    BorderWidth := Tree.BorderWidth
  else
    BorderWidth := 0;
  ARight := ALeft + Width - BorderWidth;
  ABottom := ATop + Height - BorderWidth;
  Result := Rect(ALeft, ATop, ARight, ABottom);
end;

function TJvDockZone.GetFirstSibling: TJvDockZone;
begin
  Result := Self;
  while Result.PrevSibling <> nil do
    Result := Result.PrevSibling;
end;

function TJvDockZone.GetLastSibling: TJvDockZone;
begin
  Result := Self;
  while (Result <> nil) and (Result.NextSibling <> nil) do
    Result := Result.NextSibling;
end;

function TJvDockZone.GetFirstChild: TJvDockZone;
begin
  Result := ChildZones;
end;

function TJvDockZone.GetLastChild: TJvDockZone;
begin
  Result := ChildZones;
  if Result <> nil then
    Result := Result.LastSibling;
end;

function TJvDockZone.GetTopLeftArr(Orient: TDockOrientation): Integer;
begin
  case Orient of
    doHorizontal:
      Result := Top;
    doVertical:
      Result := Left;
  else
    Result := 0;
  end;
end;

function TJvDockZone.GetHeightWidthArr(Orient: TDockOrientation): Integer;
begin
  case Orient of
    doHorizontal:
      Result := Height;
    doVertical:
      Result := Width;
  else
    Result := 0;
  end;
end;

procedure TJvDockZone.AdjustZoneLimit(Value: Integer);
begin
  FZoneLimit := Value;
  if PrevSibling <> nil then
    PrevSibling.ZoneLimit := PrevSibling.ZoneLimit + Value;
end;

procedure TJvDockZone.SetZoneSize(Size: Integer; Show: Boolean);
begin
  InsertOrRemove(Size, Show, False);
end;

procedure TJvDockZone.InsertOrRemove(DockSize: Integer; Insert: Boolean; Hide: Boolean);
begin
end;

procedure TJvDockZone.Insert(DockSize: Integer; Hide: Boolean);
begin
  InsertOrRemove(DockSize, True, Hide);

  if (ParentZone <> nil) and (ParentZone.VisibleChildCount = 0) then
    ParentZone.Insert(ParentZone.VisibleSize, Hide);

  Visibled := True;
  if ParentZone <> nil then
    ParentZone.ResetChildren(Self);

  Tree.SetNewBounds(ParentZone);
  Tree.UpdateChild(ParentZone);
end;

procedure TJvDockZone.Remove(DockSize: Integer; Hide: Boolean);
var
  Zone: TJvDockZone;
begin
  InsertOrRemove(DockSize, False, Hide);

  Visibled := not Hide;

  if (ParentZone <> Tree.TopZone) and (ParentZone.VisibleChildCount = 0) then
    ParentZone.Remove(ParentZone.LimitSize, Hide);

  if AfterClosestVisibleZone = nil then
  begin
    Zone := BeforeClosestVisibleZone;
    if Zone <> nil then
    begin
      Zone.ZoneLimit := ZoneLimit;
      Tree.SetNewBounds(Zone);
    end;
  end;

  ZoneLimit := LimitBegin;
end;

function TJvDockZone.GetVisibleChildCount: Integer;
var
  Zone: TJvDockZone;
begin
  Result := 0;
  Zone := ChildZones;
  while Zone <> nil do
  begin
    if Zone.Visibled then
      Inc(Result);
    Zone := Zone.NextSibling;
  end;
end;

function TJvDockZone.GetChildTotal: Integer;

  procedure DoFindChildCount(Zone: TJvDockZone);
  begin
    if Zone <> nil then
    begin
      DoFindChildCount(Zone.NextSibling);
      DoFindChildCount(Zone.ChildZones);
      Inc(Result);
    end;
  end;

begin
  Result := 0;
  DoFindChildCount(ChildZones);
end;

function TJvDockZone.GetVisibleChildTotal: Integer;

  procedure DoFindVisibleChildCount(Zone: TJvDockZone);
  begin
    if Zone <> nil then
    begin
      DoFindVisibleChildCount(Zone.NextSibling);
      DoFindVisibleChildCount(Zone.ChildZones);
      if Zone.Visibled then
        Inc(Result);
    end;
  end;

begin
  Result := 0;
  DoFindVisibleChildCount(ChildZones);
end;

function TJvDockZone.GetAfterClosestVisibleZone: TJvDockZone;
begin
  Result := NextSibling;
  while Result <> nil do
  begin
    if Result.Visibled then
      Break;
    Result := Result.NextSibling;
  end;
end;

function TJvDockZone.GetBeforeClosestVisibleZone: TJvDockZone;
begin
  Result := PrevSibling;
  while Result <> nil do
  begin
    if Result.Visibled then
      Break;
    Result := Result.PrevSibling;
  end;
end;

function TJvDockZone.GetAfterApoapsisVisibleZone: TJvDockZone;
begin
  Result := LastSibling;
  if Result <> nil then
    Result := Result.BeforeClosestVisibleZone;
  if Self = Result then
    Result := nil;
end;

function TJvDockZone.GetBeforeApoapsisVisibleZone: TJvDockZone;
begin
  Result := ParentZone.ChildZones;
  if Result <> Self then
    Result := Result.AfterClosestVisibleZone;
  if Self = Result then
    Result := nil;
end;

function TJvDockZone.GetNextSiblingCount: Integer;
var
  AZone: TJvDockZone;
begin
  Result := 0;
  AZone := NextSibling;
  while AZone <> nil do
  begin
    Inc(Result);
    AZone := AZone.NextSibling;
  end;
end;

function TJvDockZone.GetPrevSiblingCount: Integer;
var
  AZone: TJvDockZone;
begin
  Result := 0;
  AZone := PrevSibling;
  while AZone <> nil do
  begin
    Inc(Result);
    AZone := AZone.PrevSibling;
  end;
end;

procedure TJvDockZone.SetVisibled(const Value: Boolean);
begin
  FVisibled := Value;
  if (not FVisibled) and (Self <> Tree.TopZone) then
    if ParentZone.Orientation = doNoOrient then
      VisibleSize := Tree.TopXYLimit
    else
      VisibleSize := LimitSize;
end;

function TJvDockZone.GetVisibleNextSiblingCount: Integer;
var
  Zone: TJvDockZone;
begin
  Result := 0;
  Zone := NextSibling;
  while Zone <> nil do
  begin
    if Zone.Visibled then
      Inc(Result);
    Zone := Zone.NextSibling;
  end;
end;

function TJvDockZone.GetVisibleNextSiblingTotal: Integer;

  procedure DoFindVisibleNextSiblingCount(Zone: TJvDockZone);
  begin
    if Zone <> nil then
    begin
      DoFindVisibleNextSiblingCount(Zone.NextSibling);
      DoFindVisibleNextSiblingCount(Zone.ChildZones);
      if Zone.Visibled then
        Inc(Result);
    end;
  end;

begin
  Result := 0;
  DoFindVisibleNextSiblingCount(NextSibling);
end;

function TJvDockZone.GetVisiblePrevSiblingCount: Integer;
var
  Zone: TJvDockZone;
begin
  Result := 0;
  Zone := PrevSibling;
  while Zone <> nil do
  begin
    if Zone.Visibled then
      Inc(Result);
    Zone := Zone.PrevSibling;
  end;
end;

function TJvDockZone.GetVisiblePrevSiblingTotal: Integer;

  procedure DoFindVisibleNextSiblingCount(Zone: TJvDockZone);
  begin
    if (Zone <> nil) and (Zone <> Self) then
    begin
      DoFindVisibleNextSiblingCount(Zone.NextSibling);
      DoFindVisibleNextSiblingCount(Zone.ChildZones);
      if Zone.Visibled then
        Inc(Result);
    end;
  end;

begin
  Result := 0;
  DoFindVisibleNextSiblingCount(ParentZone);
end;

procedure TJvDockZone.SetZoneLimit(const Value: Integer);
begin
  FZoneLimit := Value;
end;

function TJvDockZone.GetFirstVisibleChildZone: TJvDockZone;
begin
  Result := ChildZones;
  while (Result <> nil) and (not Result.Visibled) do
    Result := Result.NextSibling;
end;

function TJvDockZone.GetSplitterLimit(IsMin: Boolean): Integer;
begin
  if IsMin then
    Result := ZoneLimit
  else
    Result := LimitBegin;

  if ChildZones <> nil then
    ChildZones.DoGetSplitterLimit(ParentZone.Orientation, IsMin, Result);
end;

function TJvDockZone.DoGetSplitterLimit(Orientation: TDockOrientation;
  IsMin: Boolean; var LimitResult: Integer): Integer;
begin
  Result := 0;
  if (ParentZone <> nil) and (ParentZone.Orientation = Orientation) and Visibled then
    if IsMin then
      LimitResult := Min(LimitResult, ZoneLimit)
    else
    if AfterClosestVisibleZone <> nil then
      LimitResult := Max(LimitResult, ZoneLimit);

  if NextSibling <> nil then
    NextSibling.DoGetSplitterLimit(Orientation, IsMin, LimitResult);

  if ChildZones <> nil then
    ChildZones.DoGetSplitterLimit(Orientation, IsMin, LimitResult);
end;

function TJvDockZone.GetLastVisibleChildZone: TJvDockZone;
var
  Zone: TJvDockZone;
begin
  Result := nil;
  Zone := ChildZones;
  while (Zone <> nil) and Zone.Visibled do
  begin
    Result := Zone;
    Zone := Zone.NextSibling;
  end;
end;

procedure TJvDockZone.DoCustomSetControlName;
begin
end;

procedure TJvDockZone.LButtonDblClkMethod;
begin
  if ChildControl <> nil then
    ChildControl.ManualDock(nil, nil, alTop);
end;

procedure TJvDockZone.SetIsInside(const Value: Boolean);
begin
  FIsInside := Value;
end;

procedure TJvDockZone.SetChildControlVisible(Client: TControl; AVisible: Boolean);
begin
  if Client <> nil then
    Client.Visible := FControlVisibled;
end;

//=== TJvDockTree ============================================================

constructor TJvDockTree.Create(DockSite: TWinControl;
  ADockZoneClass: TJvDockZoneClass);
var
  I: Integer;
begin
  // (rom) added inherited Create
  inherited Create;
  // (rom) Canvas now always existent
  FCanvas := TControlCanvas.Create;
  FDockZoneClass := ADockZoneClass;
  FBorderWidth := 0;
  FSplitterWidth := 4;
  FDockSite := TWinControl(DockSite);
  FDockSite.ShowHint := True;
  FVersion := RsDockBaseDockTreeVersion;
  GrabberSize := 12;
  FMinSize := 12;
  FTopZone := FDockZoneClass.Create(Self);
  FBrush := TBrush.Create;
  FBrush.Bitmap := AllocPatternBitmap(clBlack, clWhite);

  BeginUpdate;
  try
    for I := 0 to DockSite.ControlCount - 1 do
      InsertControl(DockSite.Controls[I], alLeft, nil);
    FTopZone.ResetChildren(nil);
  finally
    EndUpdate;
  end;
  if not (csDesigning in DockSite.ComponentState) then
  begin
    FOldWndProc := FDockSite.WindowProc;
    FDockSite.WindowProc := WindowProc;
  end;
end;

destructor TJvDockTree.Destroy;
begin
  if Assigned(FOldWndProc) then
    FDockSite.WindowProc := FOldWndProc;
  PruneZone(FTopZone);
  FBrush.Free;
  inherited Destroy;
  // (rom) free a Canvas always AFTER inherited Destroy
  FCanvas.Free;
end;

procedure TJvDockTree.AdjustDockRect(Control: TControl; var ARect: TRect);
begin
  InflateRect(ARect, -BorderWidth, -BorderWidth);
  case GrabbersPosition of
    gpTop:
      Inc(ARect.Top, GrabberSize);
    gpBottom:
      Dec(ARect.Bottom, GrabberSize);
    gpLeft:
      Inc(ARect.Left, GrabberSize);
    gpRight:
      Dec(ARect.Right, GrabberSize);
  end;
end;

procedure TJvDockTree.BeginUpdate;
begin
  Inc(FUpdateCount);
end;

procedure TJvDockTree.EndUpdate;
begin
  Dec(FUpdateCount);
  if FUpdateCount <= 0 then
  begin
    FUpdateCount := 0;
    UpdateAll;
  end;
end;

function TJvDockTree.FindControlZone(Control: TControl; IncludeHide: Boolean): TJvDockZone;
var
  CtlZone: TJvDockZone;

  procedure DoFindControlZone(StartZone: TJvDockZone);
  begin
    if (StartZone.ChildControl = Control) and (StartZone.Visibled or IncludeHide) then
      CtlZone := StartZone
    else
    begin
      if (CtlZone = nil) and (StartZone.NextSibling <> nil) then
        DoFindControlZone(StartZone.NextSibling);

      if (CtlZone = nil) and (StartZone.ChildZones <> nil) then
        DoFindControlZone(StartZone.ChildZones);
    end;
  end;

begin
  CtlZone := nil;
  if (Control <> nil) and (FTopZone <> nil) then
    DoFindControlZone(FTopZone);
  Result := CtlZone;
end;

procedure TJvDockTree.ForEachAt(Zone: TJvDockZone; Proc: TJvDockForEachZoneProc;
  ScanKind: TJvDockTreeScanKind; ScanPriority: TJvDockTreeScanPriority);

  procedure DoForwardForEach(Zone: TJvDockZone);
  begin
    Proc(Zone);
    if ScanPriority = tspSibling then
    begin
      if Zone.NextSibling <> nil then
        DoForwardForEach(Zone.NextSibling);

      if Zone.ChildZones <> nil then
        DoForwardForEach(Zone.ChildZones);
    end
    else
    begin
      if Zone.ChildZones <> nil then
        DoForwardForEach(Zone.ChildZones);

      if Zone.NextSibling <> nil then
        DoForwardForEach(Zone.NextSibling);
    end;
  end;

  procedure DoMiddleForEach(Zone: TJvDockZone);
  begin
    if ScanPriority = tspSibling then
    begin
      if Zone.NextSibling <> nil then
        DoMiddleForEach(Zone.NextSibling);
    end
    else
    begin
      if Zone.ChildZones <> nil then
        DoMiddleForEach(Zone.ChildZones);
    end;

    Proc(Zone);

    if ScanPriority = tspSibling then
    begin
      if Zone.ChildZones <> nil then
        DoMiddleForEach(Zone.ChildZones);
    end
    else
    if Zone.NextSibling <> nil then
      DoMiddleForEach(Zone.NextSibling);
  end;

  procedure DoBackwardForEach(Zone: TJvDockZone);
  begin
    if ScanPriority = tspSibling then
    begin
      if Zone.NextSibling <> nil then
        DoBackwardForEach(Zone.NextSibling);

      if Zone.ChildZones <> nil then
        DoBackwardForEach(Zone.ChildZones);
    end
    else
    begin
      if Zone.ChildZones <> nil then
        DoForwardForEach(Zone.ChildZones);

      if Zone.NextSibling <> nil then
        DoForwardForEach(Zone.NextSibling);
    end;
    Proc(Zone);
  end;

begin
  if Zone = nil then
  begin
    if FTopZone = nil then
      FTopZone := FDockZoneClass.Create(Self);
    Zone := FTopZone;
  end;

  case ScanKind of
    tskForward:
      DoForwardForEach(Zone);
    tskMiddle:
      DoMiddleForEach(Zone);
    tskBackward:
      DoBackwardForEach(Zone);
  end;
end;

procedure TJvDockTree.GetControlBounds(Control: TControl; out CtlBounds: TRect);
var
  Z: TJvDockZone;
begin
  Z := FindControlZone(Control);
  if Z = nil then
    FillChar(CtlBounds, SizeOf(CtlBounds), 0)
  else
    with Z do
      CtlBounds := Bounds(Left, Top, Width, Height);
end;

function TJvDockTree.HitTest(const MousePos: TPoint; out HTFlag: Integer): TControl;
var
  Zone: TJvDockZone;
begin
  Zone := InternalHitTest(MousePos, HTFlag);
  if Zone <> nil then
    Result := Zone.ChildControl
  else
    Result := nil;
end;

procedure TJvDockTree.InsertControl(Control: TControl; InsertAt: TAlign;
  DropCtl: TControl);
const
  {$IFDEF COMPILER6_UP}
  OrientArray: array [TAlign] of TDockOrientation = (doNoOrient, doHorizontal,
    doHorizontal, doVertical, doVertical, doNoOrient, doNoOrient);
  MakeLast: array [TAlign] of Boolean = (False, False, True, False, True, False, False);
  {$ELSE}
  OrientArray: array [TAlign] of TDockOrientation = (doNoOrient, doHorizontal,
    doHorizontal, doVertical, doVertical, doNoOrient);
  MakeLast: array [TAlign] of Boolean = (False, False, True, False, True, False);
  {$ENDIF COMPILER6_UP}
var
  Sibling: TJvDockZone;
  Me: TJvDockZone;
  InsertOrientation: TDockOrientation;
  CurrentOrientation: TDockOrientation;
  NewWidth, NewHeight: Integer;
  R: TRect;
begin
  if FReplacementZone <> nil then
  begin
    FReplacementZone.ChildControl := TWinControl(Control);
    FReplacementZone.Update;
    Exit;
  end
  else
  if FTopZone <> nil then
  begin
    if FTopZone.ChildZones = nil then
    begin
      R := FDockSite.ClientRect;
      THackWinControl(FDockSite).AdjustClientRect(R);
      NewWidth := R.Right - R.Left;
      NewHeight := R.Bottom - R.Top;
      if THackWinControl(FDockSite).AutoSize then
      begin
        if NewWidth = 0 then
          NewWidth := Control.UndockWidth;
        if NewHeight = 0 then
          NewHeight := Control.UndockHeight;
      end;
      R := Bounds(R.Left, R.Top, NewWidth, NewHeight);
      AdjustDockRect(Control, R);
      Control.BoundsRect := R;
      Me := FDockZoneClass.Create(Self);
      FTopZone.ChildZones := Me;
      Me.FParentZone := FTopZone;
      Me.ChildControl := TWinControl(Control);
    end
    else
    begin
      if InsertAt in [alClient, alNone] then
        InsertAt := alRight;

      Me := FindControlZone(Control, True);
      if Me <> nil then
        RemoveZone(Me, False);

      Sibling := FindControlZone(DropCtl);

      InsertOrientation := OrientArray[InsertAt];
      if FTopZone.ChildCount = 1 then
      begin
        FTopZone.Orientation := InsertOrientation;
        case InsertOrientation of
          doHorizontal:
            begin
              FTopZone.ZoneLimit := FTopZone.ChildZones.Width;
              TopXYLimit := FTopZone.ChildZones.Height;
            end;
          doVertical:
            begin
              FTopZone.ZoneLimit := FTopZone.ChildZones.Height;
              TopXYLimit := FTopZone.ChildZones.Width;
            end;
        end;
      end;

      Me := FDockZoneClass.Create(Self);
      Me.ChildControl := TWinControl(Control);

      if Sibling <> nil then
        CurrentOrientation := Sibling.FParentZone.Orientation
      else
        CurrentOrientation := FTopZone.Orientation;
      if InsertOrientation = doNoOrient then
        InsertOrientation := CurrentOrientation;

      if InsertOrientation = CurrentOrientation then
        InsertSibling(Me, Sibling, MakeLast[InsertAt], True)
      else
        InsertNewParent(Me, Sibling, InsertOrientation, MakeLast[InsertAt], True);
    end;

    FDockSite.Invalidate;
  end;
end;

procedure TJvDockTree.InsertNewParent(NewZone, SiblingZone: TJvDockZone;
  ParentOrientation: TDockOrientation; InsertLast, Update: Boolean);
var
  NewParent: TJvDockZone;
begin
  NewParent := FDockZoneClass.Create(Self);

  NewParent.Orientation := ParentOrientation;
  if SiblingZone = nil then
  begin
    NewParent.ZoneLimit := TopXYLimit;
    TopXYLimit := FTopZone.ZoneLimit;
    ShiftScaleOrientationation := ParentOrientation;
    ScaleBy := 0.5;
    if InsertLast then
    begin
      FTopZone.Visibled := FTopZone.VisibleChildCount > 0;
      NewParent.ChildZones := FTopZone;
      FTopZone.ParentZone := NewParent;
      FTopZone.NextSibling := NewZone;
      NewZone.PrevSibling := FTopZone;
      NewZone.ParentZone := NewParent;
      FTopZone := NewParent;
      ForEachAt(NewParent.ChildZones, ScaleZone, tskForward);
    end
    else
    begin
      NewParent.ChildZones := NewZone;
      FTopZone.ParentZone := NewParent;
      FTopZone.PrevSibling := NewZone;
      NewZone.NextSibling := FTopZone;
      NewZone.ParentZone := NewParent;
      FTopZone := NewParent;

      if ParentOrientation <> FTopZone.Orientation then
        NewZone.ZoneLimit := FTopZone.ZoneLimit div 2
      else
        NewZone.ZoneLimit := TopXYLimit div 2;

      ForEachAt(NewZone.NextSibling, ScaleZone, tskForward);
      if ParentOrientation <> FTopZone.Orientation then
        ShiftBy := FTopZone.ZoneLimit div 2
      else
        ShiftBy := TopXYLimit div 2;
      ForEachAt(NewZone.NextSibling, ShiftZone, tskForward);
    end;
    ForEachAt(nil, UpdateZone, tskForward);
  end
  else
  begin
    NewParent.ZoneLimit := SiblingZone.ZoneLimit;
    NewParent.ParentZone := SiblingZone.ParentZone;
    NewParent.PrevSibling := SiblingZone.PrevSibling;
    if NewParent.PrevSibling <> nil then
      NewParent.PrevSibling.NextSibling := NewParent;
    NewParent.NextSibling := SiblingZone.NextSibling;
    if NewParent.NextSibling <> nil then
      NewParent.NextSibling.PrevSibling := NewParent;
    if NewParent.ParentZone.ChildZones = SiblingZone then
      NewParent.ParentZone.ChildZones := NewParent;
    NewZone.ParentZone := NewParent;
    SiblingZone.ParentZone := NewParent;
    if InsertLast then
    begin
      NewParent.ChildZones := SiblingZone;
      SiblingZone.ZoneLimit := NewParent.ParentZone.ZoneLimit;
      SiblingZone.PrevSibling := nil;
      SiblingZone.NextSibling := NewZone;
      NewZone.PrevSibling := SiblingZone;
    end
    else
    begin
      NewParent.ChildZones := NewZone;
      SiblingZone.PrevSibling := NewZone;
      SiblingZone.NextSibling := nil;
      NewZone.NextSibling := SiblingZone;
    end;
  end;
  if Update then
  begin
    NewParent.ResetChildren(nil);
    ForEachAt(nil, UpdateZone, tskForward);
  end;
end;

procedure TJvDockTree.InsertSibling(NewZone, SiblingZone: TJvDockZone;
  InsertLast, Update: Boolean);
begin
  if (NewZone <> nil) and (SiblingZone <> nil) and
    (NewZone.ChildControl = SiblingZone.ChildControl) then
    SiblingZone := nil;
  if SiblingZone = nil then
  begin
    SiblingZone := FTopZone.ChildZones;
    if InsertLast then
      SiblingZone := SiblingZone.LastSibling;
  end;
  if InsertLast then
  begin
    NewZone.ParentZone := SiblingZone.ParentZone;
    NewZone.PrevSibling := SiblingZone;
    NewZone.NextSibling := SiblingZone.NextSibling;
    if NewZone.NextSibling <> nil then
      NewZone.NextSibling.PrevSibling := NewZone;
    SiblingZone.NextSibling := NewZone;
  end
  else
  begin
    NewZone.NextSibling := SiblingZone;
    NewZone.PrevSibling := SiblingZone.PrevSibling;
    if NewZone.PrevSibling <> nil then
      NewZone.PrevSibling.NextSibling := NewZone;
    SiblingZone.PrevSibling := NewZone;
    NewZone.ParentZone := SiblingZone.ParentZone;
    if NewZone.ParentZone.ChildZones = SiblingZone then
      NewZone.ParentZone.ChildZones := NewZone;
  end;
  if Update then
  begin
    SiblingZone.ParentZone.ResetChildren(nil);
    UpDateChild(SiblingZone.ParentZone);
  end;
end;

function TJvDockTree.DoFindZone(const MousePos: TPoint;
  out HTFlag: Integer; Zone: TJvDockZone): TJvDockZone;
const
  HTFlagArr: array[Boolean] of Integer = (HTCLIENT, HTSPLITTER);
begin
  Result := nil;

  if (Zone.ParentZone.Orientation = doHorizontal) and
    (Zone.NextSibling <> nil) and
    ((MousePos.Y <= Zone.FZoneLimit) and
    (MousePos.Y >= Zone.FZoneLimit - SplitterWidth)) and
    ((MousePos.X <= Zone.ParentZone.FZoneLimit) and
    (MousePos.X >= Zone.ParentZone.LimitBegin)) then
  begin
    HTFlag := HTFlagArr[Zone.VisibleNextSiblingTotal > 0];
    Result := Zone;
  end
  else
  if (Zone.FParentZone.Orientation = doVertical) and
    (Zone.NextSibling <> nil) and
    ((MousePos.X <= Zone.FZoneLimit) and
    (MousePos.X >= Zone.FZoneLimit - SplitterWidth)) and
    ((MousePos.Y <= Zone.ParentZone.FZoneLimit) and
    (MousePos.Y >= Zone.ParentZone.LimitBegin)) then
  begin
    HTFlag := HTFlagArr[Zone.VisibleNextSiblingTotal > 0];
    Result := Zone;
  end
  else
  if Zone.ChildControl <> nil then
  begin
    case GrabbersPosition of
      gpTop:
        Result := GetTopGrabbersHTFlag(MousePos, HTFlag, Zone);
      gpLeft:
        Result := GetLeftGrabbersHTFlag(MousePos, HTFlag, Zone);
      gpBottom:
        Result := GetBottomGrabbersHTFlag(MousePos, HTFlag, Zone);
      gpRight:
        Result := GetRightGrabbersHTFlag(MousePos, HTFlag, Zone);
    end;

    if Result = nil then
      Result := GetBorderHTFlag(MousePos, HTFlag, Zone);
  end
  else
    Result := nil;

  if (Result <> nil) and (not Result.Visibled) then
    Result := nil;

  if (Result = nil) and (Zone.NextSibling <> nil) then
    Result := DoFindZone(MousePos, HTFlag, Zone.NextSibling);
  if (Result = nil) and (Zone.ChildZones <> nil) then
    Result := DoFindZone(MousePos, HTFlag, Zone.ChildZones);
end;

function TJvDockTree.InternalHitTest(const MousePos: TPoint; out HTFlag: Integer): TJvDockZone;
var
  ResultZone: TJvDockZone;

  function FindControlAtPos(const Pos: TPoint): TControl;
  var
    I: Integer;
    P: TPoint;
  begin
    for I := FDockSite.ControlCount - 1 downto 0 do
    begin
      Result := FDockSite.Controls[I];
      with Result do
      begin
        if not Result.Visible or ((Result is TWinControl) and
          not TWinControl(Result).Showing) then
          continue;
        P := Point(Pos.X - Left, Pos.Y - Top);
        if PtInRect(ClientRect, P) then
          Exit;
      end;
    end;
    Result := nil;
  end;

var
  CtlAtPos: TControl;
begin
  ResultZone := nil;
  HTFlag := HTNOWHERE;
  CtlAtPos := FindControlAtPos(MousePos);
  if (CtlAtPos <> nil) and (CtlAtPos.HostDockSite = FDockSite) then
  begin
    ResultZone := FindControlZone(CtlAtPos);
    if ResultZone <> nil then
      HTFlag := HTCLIENT;
  end
  else
  if (FTopZone <> nil) and (FTopZone.ChildZones <> nil) and
    (FTopZone.ChildCount >= 1) and (CtlAtPos = nil) then
    ResultZone := DoFindZone(MousePos, HTFlag, FTopZone.ChildZones);
  Result := ResultZone;
end;

procedure TJvDockTree.LoadFromStream(Stream: TStream);
var
  I: Integer;
begin
  PruneZone(FTopZone);

  Stream.Read(I, SizeOf(I));
  if I <> Version then
    Exit;

  BeginUpdate;
  try
    Stream.Read(FTopXYLimit, SizeOf(FTopXYLimit));
    DoLoadZone(Stream);
  finally
    EndUpdate;
  end;
end;

procedure TJvDockTree.PaintSite(DC: HDC);
begin
  FCanvas.Control := FDockSite;
  FCanvas.Lock;
  try
    FCanvas.Handle := DC;
    try
      PaintDockSite;
    finally
      FCanvas.Handle := 0;
    end;
  finally
    FCanvas.Unlock;
  end;
end;

procedure TJvDockTree.PositionDockRect(Client, DropCtl: TControl;
  DropAlign: TAlign; var DockRect: TRect);
var
  VisibleClients, NewX, NewY, NewWidth, NewHeight: Integer;
begin
  VisibleClients := FDockSite.VisibleDockClientCount;

  if (DropCtl = nil) or (DropCtl.DockOrientation = doNoOrient) or
    (VisibleClients < 2) then
  begin
    DockRect := Rect(0, 0, FDockSite.ClientWidth, FDockSite.ClientHeight);

    if VisibleClients > 0 then
      with DockRect do
        case DropAlign of
          alLeft:
            Right := Right div 2;
          alRight:
            Left := Right div 2;
          alTop:
            Bottom := Bottom div 2;
          alBottom:
            Top := Bottom div 2;
        end;
  end
  else
  begin
    NewX := DropCtl.Left;
    NewY := DropCtl.Top;
    NewWidth := DropCtl.Width;
    NewHeight := DropCtl.Height;
    if DropAlign in [alLeft, alRight] then
      NewWidth := DropCtl.Width div 2
    else
    if DropAlign in [alTop, alBottom] then
      NewHeight := DropCtl.Height div 2;
    case DropAlign of
      alRight:
        Inc(NewX, NewWidth);
      alBottom:
        Inc(NewY, NewHeight);
    end;
    DockRect := Bounds(NewX, NewY, NewWidth, NewHeight);
    if DropAlign = alClient then
      DockRect := Bounds(NewX, NewY, NewWidth, NewHeight);
  end;
  MapWindowPoints(FDockSite.Handle, 0, DockRect, 2);
end;

procedure TJvDockTree.PruneZone(Zone: TJvDockZone);

  procedure DoPrune(Zone: TJvDockZone);
  begin
    if Zone.NextSibling <> nil then
      DoPrune(Zone.NextSibling);
    if Zone.ChildZones <> nil then
      DoPrune(Zone.ChildZones);
    Zone.Free;
  end;

begin
  if Zone = nil then
    Exit;

  if Zone.ChildZones <> nil then
    DoPrune(Zone.ChildZones);

  if Zone.FPrevSibling <> nil then
    Zone.FPrevSibling.NextSibling := Zone.NextSibling
  else
  if Zone.FParentZone <> nil then
    Zone.FParentZone.ChildZones := Zone.NextSibling;
  if Zone.NextSibling <> nil then
    Zone.NextSibling.FPrevSibling := Zone.FPrevSibling;

  if Zone = FTopZone then
    FTopZone := nil;
  Zone.Free;
end;

procedure TJvDockTree.RemoveControl(Control: TControl);
var
  Z: TJvDockZone;
begin
  Z := FindControlZone(Control, True);
  if Z <> nil then
  begin
    if Z = FReplacementZone then
      Z.ChildControl := nil
    else
    begin
      if (Z.ParentZone.Orientation <> doNoOrient) and Z.Visibled then
        Z.Remove(Z.LimitSize, False);
      RemoveZone(Z, False);
      SetNewBounds(nil);
      UpdateAll;
    end;
    Control.DockOrientation := doNoOrient;

    FDockSite.Invalidate;
  end;
end;

procedure TJvDockTree.RemoveZone(Zone: TJvDockZone; Hide: Boolean);
var
  Sibling, LastChild: TJvDockZone;
  VisibleZoneChildCount, ZoneChildCount: Integer;
// (rom) disabled  unused
//label
//  LOOP;
begin
  if not Hide then
  begin
    if Zone = nil then
      raise Exception.Create(SDockTreeRemoveError + SDockZoneNotFound);
    if Zone.ChildControl = nil then
      raise Exception.Create(SDockTreeRemoveError + SDockZoneHasNoCtl);
    VisibleZoneChildCount := Zone.ParentZone.VisibleChildCount;
    ZoneChildCount := Zone.ParentZone.ChildCount;
    if VisibleZoneChildCount <= 1 then
    begin
      if Zone.PrevSibling = nil then
      begin
        Zone.ParentZone.ChildZones := Zone.NextSibling;
        if Zone.NextSibling <> nil then
          Zone.NextSibling.PrevSibling := nil;
      end
      else
      if Zone.NextSibling = nil then
        Zone.PrevSibling.NextSibling := nil
      else
      begin
        Zone.PrevSibling.NextSibling := Zone.NextSibling;
        Zone.NextSibling.PrevSibling := Zone.PrevSibling;
      end;
    end;
    if ZoneChildCount = 2 then
    begin
      if Zone.PrevSibling = nil then
        Sibling := Zone.NextSibling
      else
        Sibling := Zone.PrevSibling;
      if Sibling.ChildControl <> nil then
      begin
        if Zone.ParentZone = FTopZone then
        begin
          FTopZone.ChildZones := Sibling;
          Sibling.PrevSibling := nil;
          Sibling.NextSibling := nil;
          Sibling.ZoneLimit := FTopZone.LimitSize;
          Sibling.Update;
        end
        else
        begin
          Zone.ParentZone.Orientation := doNoOrient;
          Zone.ParentZone.ChildControl := Sibling.ChildControl;
          Zone.ParentZone.ChildZones := nil;
          Sibling.Free;
        end;

        ForEachAt(Zone.ParentZone, UpdateZone, tskForward);
      end
      else
      begin
        if Zone.ParentZone = FTopZone then
        begin
          Sibling.ZoneLimit := TopXYLimit;
          TopXYLimit := FTopZone.ZoneLimit;
          FTopZone.Free;
          FTopZone := Sibling;
          Sibling.NextSibling := nil;
          Sibling.PrevSibling := nil;
          Sibling.ParentZone := nil;
        end
        else
        begin
          Sibling.ChildZones.PrevSibling := Zone.ParentZone.PrevSibling;
          if Sibling.ChildZones.PrevSibling = nil then
            Zone.ParentZone.ParentZone.ChildZones := Sibling.ChildZones
          else
            Sibling.ChildZones.PrevSibling.NextSibling := Sibling.ChildZones;
          LastChild := Sibling.ChildZones;
          LastChild.ParentZone := Zone.ParentZone.ParentZone;
          repeat
            LastChild := LastChild.NextSibling;
            if LastChild <> nil then
              LastChild.ParentZone := Zone.ParentZone.ParentZone
            else
              Break;
          until LastChild.NextSibling = nil;
          if LastChild <> nil then
          begin
            LastChild.NextSibling := Zone.ParentZone.NextSibling;
            if LastChild.NextSibling <> nil then
              LastChild.NextSibling.PrevSibling := LastChild;
            ForEachAt(LastChild.ParentZone, UpdateZone, tskForward);
          end;
          Zone.ParentZone.Free;
          Sibling.Free;
        end;
      end;
    end
    else
    begin
      if Zone.PrevSibling = nil then
      begin
        Zone.ParentZone.ChildZones := Zone.NextSibling;
        if Zone.NextSibling <> nil then
        begin
          Zone.NextSibling.PrevSibling := nil;
          Zone.NextSibling.Update;
        end;
      end
      else
      begin
        Zone.PrevSibling.NextSibling := Zone.NextSibling;
        if Zone.NextSibling <> nil then
          Zone.NextSibling.PrevSibling := Zone.PrevSibling;
        Zone.PrevSibling.ZoneLimit := Zone.ZoneLimit;
        Zone.PrevSibling.Update;
      end;
      ForEachAt(Zone.ParentZone, UpdateZone, tskForward);
    end;
    //LOOP:
    Zone.Free;
  end;
  SetNewBounds(nil);
  UpdateAll;
end;

procedure TJvDockTree.ResetBounds(Force: Boolean);
var
  R: TRect;
begin
  if not (csLoading in FDockSite.ComponentState) and
    (FTopZone <> nil) and (FDockSite.DockClientCount > 0) then
  begin
    R := FDockSite.ClientRect;
    THackWinControl(FDockSite).AdjustClientRect(R);
    if Force or (not CompareMem(@R, @FPreviousRect, SizeOf(TRect))) then
    begin
      FPreviousRect := R;
      case FTopZone.Orientation of
        doHorizontal:
          begin
            FTopZone.ZoneLimit := R.Right - R.Left;
            if R.Bottom - R.Top > 0 then
              TopXYLimit := R.Bottom - R.Top;
          end;
        doVertical:
          begin
            FTopZone.ZoneLimit := R.Bottom - R.Top;
            if R.Right - R.Left > 0 then
              TopXYLimit := R.Right - R.Left;
          end;
      end;
      SetNewBounds(nil);
      if FUpdateCount = 0 then
        ForEachAt(nil, UpdateZone, tskForward);
    end;
  end;
end;

procedure TJvDockTree.ScaleZone(Zone: TJvDockZone);
begin
  FParentLimit := 0;
  ScaleChildZone(Zone);
end;

procedure TJvDockTree.SaveToStream(Stream: TStream);
begin
  Stream.Write(FVersion, SizeOf(FVersion));

  Stream.Write(FTopXYLimit, SizeOf(FTopXYLimit));

  DoSaveZone(Stream, FTopZone, 0);
  Stream.Write(TreeStreamEndFlag, SizeOf(TreeStreamEndFlag));
end;

procedure TJvDockTree.SetNewBounds(Zone: TJvDockZone);

  procedure DoSetNewBounds(Zone: TJvDockZone);
  begin
    if Zone <> nil then
    begin
      if (Zone.VisibleNextSiblingCount = 0) and (Zone <> FTopZone) then
      begin
        if Zone.ParentZone = FTopZone then
          Zone.ZoneLimit := FTopXYLimit
        else
          Zone.ZoneLimit := Zone.ParentZone.ParentZone.FZoneLimit;
      end;
      if Zone.ChildZones <> nil then
        DoSetNewBounds(Zone.ChildZones);
      if Zone.NextSibling <> nil then
        DoSetNewBounds(Zone.NextSibling);
    end;
  end;

begin
  if JvGlobalDockJvGlobalDockIsLoading then
    Exit;
  if Zone = nil then
    Zone := FTopZone.ChildZones;
  DoSetNewBounds(Zone);

  FDockSite.Invalidate;
end;

procedure TJvDockTree.SetReplacingControl(Control: TControl);
begin
  FReplacementZone := FindControlZone(Control);
end;

procedure TJvDockTree.ShiftZone(Zone: TJvDockZone);
begin
  if (Zone <> nil) and (Zone <> FTopZone) and
    (Zone.ParentZone.Orientation = FShiftScaleOrientation) then
  begin
    Inc(Zone.FZoneLimit, FShiftBy);
    if Zone.LimitSize < FMinSize then
      Zone.FZoneLimit := Zone.LimitBegin + FMinSize;
  end;
end;

procedure TJvDockTree.SplitterMouseDown(OnZone: TJvDockZone; MousePos: TPoint);
begin
  FSizingZone := OnZone;
  Mouse.Capture := FDockSite.Handle;
  FSizingWnd := FDockSite.Handle;
  FSizingDC := GetDCEx(FSizingWnd, 0, DCX_CACHE or DCX_CLIPSIBLINGS or DCX_LOCKWINDOWUPDATE);
  FSizePos := MousePos;
  DrawSizeSplitter;
end;

procedure TJvDockTree.SplitterMouseUp;

  procedure SetSiblingZoneSize(PosXY: Integer);
  var
    AZone: TJvDockZone;
    PrevCount, NextCount: Integer;
  begin
    PrevCount := FSizingZone.PrevSiblingCount;
    AZone := FSizingZone.ParentZone.ChildZones;
    while (AZone <> nil) and (AZone <> FSizingZone) do
    begin
      if AZone.ZoneLimit >= PosXY - PrevCount * MinSize +
        Integer(AZone.PrevSibling = nil) * (SplitterWidth div 2) then
      begin
        AZone.ZoneLimit := PosXY - PrevCount * MinSize +
          Integer(AZone.PrevSibling = nil) * (SplitterWidth div 2);
        Break;
      end;
      Dec(PrevCount);
      AZone := AZone.NextSibling;
    end;

    AZone := AZone.NextSibling;
    while PrevCount > 0 do
    begin
      Dec(PrevCount);
      AZone.ZoneLimit := AZone.LimitBegin + MinSize;
      AZone := AZone.NextSibling;
    end;

    NextCount := 1;
    AZone := FSizingZone.NextSibling;
    while AZone <> nil do
    begin
      if AZone.ZoneLimit <= PosXY + NextCount * MinSize +
        Integer(AZone.NextSibling <> nil) * (SplitterWidth div 2) then
        AZone.ZoneLimit := PosXY + NextCount * MinSize +
          Integer(AZone.NextSibling <> nil) * (SplitterWidth div 2);
      Inc(NextCount);
      AZone := AZone.NextSibling;
    end;
  end;

begin
  Mouse.Capture := 0;
  DrawSizeSplitter;
  ReleaseDC(FSizingWnd, FSizingDC);
  if FSizingZone.ParentZone.Orientation = doHorizontal then
  begin
    FSizingZone.ZoneLimit := FSizePos.y + (SplitterWidth div 2);
    SetSiblingZoneSize(FSizePos.y);
  end
  else
  begin
    FSizingZone.ZoneLimit := FSizePos.x + (SplitterWidth div 2);
    SetSiblingZoneSize(FSizePos.x);
  end;
  SetNewBounds(FSizingZone.ParentZone);
  ForEachAt(FSizingZone.ParentZone, UpdateZone, tskForward);
  FSizingZone := nil;
end;

procedure TJvDockTree.UpdateAll;
begin
  if (FUpdateCount = 0) and (FDockSite.DockClientCount > 0) then
    ForEachAt(nil, UpdateZone, tskForward);
end;

procedure TJvDockTree.UpdateZone(Zone: TJvDockZone);
begin
  if FUpdateCount = 0 then
    Zone.Update;
end;

procedure TJvDockTree.DrawSizeSplitter;
var
  R: TRect;
  PrevBrush: HBrush;
begin
  if FSizingZone <> nil then
  begin
    with R do
      if FSizingZone.ParentZone.Orientation = doHorizontal then
      begin
        Left := FSizingZone.Left;
        Top := FSizePos.Y - (SplitterWidth div 2);
        Right := Left + FSizingZone.Width;
        Bottom := Top + SplitterWidth;
      end
      else
      begin
        Left := FSizePos.X - (SplitterWidth div 2);
        Top := FSizingZone.Top;
        Right := Left + SplitterWidth;
        Bottom := Top + FSizingZone.Height;
      end;
    PrevBrush := SelectObject(FSizingDC, FBrush.Handle);
    with R do
      PatBlt(FSizingDC, Left, Top, Right - Left, Bottom - Top, PATINVERT);
    SelectObject(FSizingDC, PrevBrush);
  end;
end;

function TJvDockTree.GetSplitterLimit(AZone: TJvDockZone; IsCurrent, IsMin: Boolean): Integer;
begin
  if IsCurrent then
    Result := AZone.GetSplitterLimit(False)
  else
  if AZone.AfterClosestVisibleZone <> nil then
    Result := AZone.AfterClosestVisibleZone.GetSplitterLimit(True)
  else
    Result := AZone.ZoneLimit + AZone.LimitSize;
end;

procedure TJvDockTree.ControlVisibilityChanged(Control: TControl;
  Visible: Boolean);
begin
  if Visible then
    ShowControl(Control)
  else
    HideControl(Control);
end;

procedure TJvDockTree.WindowProc(var Msg: TMessage);
var
  TempZone: TJvDockZone;
  HitTestValue: Integer;
begin
  case Msg.Msg of
    CM_DOCKNOTIFICATION:
      with TCMDockNotification(Msg) do
        if NotifyRec.ClientMsg = CM_VISIBLECHANGED then
          ControlVisibilityChanged(Client, Boolean(NotifyRec.MsgWParam));
    WM_MOUSEMOVE:
      DoMouseMove(TWMMouse(Msg), TempZone, HitTestValue);
    WM_LBUTTONDBLCLK:
      DoLButtonDbClk(TWMMouse(Msg), TempZone, HitTestValue);
    WM_LBUTTONDOWN:
      if DoLButtonDown(TWMMouse(Msg), TempZone, HitTestValue) then
        Exit;
    WM_LBUTTONUP:
      DoLButtonUp(TWMMouse(Msg), TempZone, HitTestValue);
    WM_MBUTTONDOWN:
      DoMButtonDown(TWMMouse(Msg), TempZone, HitTestValue);
    WM_MBUTTONUP:
      DoMButtonUp(TWMMouse(Msg), TempZone, HitTestValue);
    WM_RBUTTONDOWN:
      DoRButtonDown(TWMMouse(Msg), TempZone, HitTestValue);
    WM_RBUTTONUP:
      DoRButtonUp(TWMMouse(Msg), TempZone, HitTestValue);
    WM_SETCURSOR:
      begin
        DoSetCursor(TWMSetCursor(Msg), TempZone, HitTestValue);
        if Msg.Result = 1 then
          Exit;
      end;
  end;

  FOldWndProc(Msg);
  if Msg.Msg = CM_HINTSHOW then
    DoHintShow(TCMHintShow(Msg), TempZone, HitTestValue);
end;

procedure TJvDockTree.SetGrabberSize(const Value: Integer);
begin
  if FGrabberSize <> Value then
  begin
    FGrabberSize := Value;
    UpdateAll;
    Docksite.Invalidate;
  end;
end;

function TJvDockTree.GeTJvDockGrabbersPosition: TJvDockGrabbersPosition;
begin
  if DockSite.Align in [alTop, alBottom] then
    Result := gpLeft
  else
    Result := gpTop;
end;

function TJvDockTree.GetBottomGrabbersHTFlag(const MousePos: TPoint;
  out HTFlag: Integer; Zone: TJvDockZone): TJvDockZone;
begin
  Result := nil;
end;

function TJvDockTree.GetBorderHTFlag(const MousePos: TPoint;
  out HTFlag: Integer; Zone: TJvDockZone): TJvDockZone;
var
  ARect: TRect;
begin
  Result := nil;

  ARect := Zone.GetFrameRect;

  if PtInRect(ARect, MousePos) then
  begin
    InflateRect(ARect, -BorderWidth, -BorderWidth);
    if not PtInRect(ARect, MousePos) then
    begin
      Result := Zone;
      HTFlag := HTBORDER;
    end;
  end;
end;

function TJvDockTree.GetLeftGrabbersHTFlag(const MousePos: TPoint;
  out HTFlag: Integer; Zone: TJvDockZone): TJvDockZone;
begin
  if (MousePos.X >= Zone.Left + BorderWidth) and (MousePos.X <= Zone.Left + BorderWidth + FGrabberSize) and
    (MousePos.Y >= Zone.Top) and (MousePos.Y <= Zone.Top + Zone.Height) then
  begin
    Result := Zone;
    if MousePos.Y < Zone.ChildControl.Top + FGrabberSize + 3 then
      HTFlag := HTCLOSE
    else
      HTFlag := HTCAPTION;
  end
  else
    Result := nil;
end;

function TJvDockTree.GetRightGrabbersHTFlag(const MousePos: TPoint;
  out HTFlag: Integer; Zone: TJvDockZone): TJvDockZone;
begin
  Result := nil;
end;

function TJvDockTree.GetTopGrabbersHTFlag(const MousePos: TPoint;
  out HTFlag: Integer; Zone: TJvDockZone): TJvDockZone;
begin
  if (MousePos.Y >= Zone.Top + BorderWidth) and (MousePos.Y <= Zone.Top + BorderWidth + FGrabberSize) and
    (MousePos.X >= Zone.Left) and (MousePos.X <= Zone.Left + Zone.Width) then
  begin
    Result := Zone;
    with Zone.ChildControl do
      if MousePos.X > Left + Width - FGrabberSize - 3 then
        HTFlag := HTCLOSE
      else
        HTFlag := HTCAPTION;
  end
  else
    Result := nil;
end;

function TJvDockTree.GetActiveControl: TControl;
begin
  Result := FActiveControl;
end;

procedure TJvDockTree.SetActiveControl(const Value: TControl);
begin
  FActiveControl := Value;
end;

function TJvDockTree.GetGrabberSize: Integer;
begin
  Result := FGrabberSize;
end;

function TJvDockTree.FindControlZoneAndLevel(Control: TControl;
  var CtlLevel: Integer; IncludeHide: Boolean): TJvDockZone;
var
  CtlZone: TJvDockZone;

  procedure DoFindControlZone(StartZone: TJvDockZone; Level: Integer);
  begin
    if (StartZone.ChildControl = Control) and (StartZone.Visibled or IncludeHide) then
    begin
      CtlZone := StartZone;
      CtlLevel := Level;
    end
    else
    begin
      if (CtlZone = nil) and (StartZone.NextSibling <> nil) then
        DoFindControlZone(StartZone.NextSibling, Level);

      if (CtlZone = nil) and (StartZone.ChildZones <> nil) then
        DoFindControlZone(StartZone.ChildZones, Level + 1);
      if (CtlZone <> nil) and (not CtlZone.Visibled) then
        CtlZone := nil;
    end;
  end;

begin
  CtlZone := nil;
  CtlLevel := 0;
  if (Control <> nil) and (FTopZone <> nil) then
    DoFindControlZone(FTopZone, 0);
  Result := CtlZone;
end;

procedure TJvDockTree.SetDockSplitterWidth(const Value: Integer);
begin
  if FSplitterWidth <> Value then
  begin
    FSplitterWidth := Value;
    if FUpdateCount <= 0 then
      UpdateAll;
  end;
end;

procedure TJvDockTree.SetTopZone(const Value: TJvDockZone);
begin
  FTopZone := Value;
end;

procedure TJvDockTree.SetTopXYLimit(const Value: Integer);
begin
  FTopXYLimit := Value;
end;

procedure TJvDockTree.DoMouseMove(var Msg: TWMMouse;
  var Zone: TJvDockZone; out HTFlag: Integer);
var
  Control: TControl;
  DockClient: TJvDockClient;
begin
  if FSizingZone <> nil then
  begin
    DrawSizeSplitter;
    FSizePos := SmallPointToPoint(Msg.Pos);
    CalcSplitterPos;
    DrawSizeSplitter;
  end;

  Zone := InternalHitTest(SmallPointToPoint(Msg.Pos), HTFlag);
  if Zone <> nil then
  begin
    DockClient := FindDockClient(Zone.ChildControl);
    if DockClient <> nil then
      DockClient.DoNCMouseMove(JvDockCreateNCMessage(
        DockSite, WM_NCMOUSEMOVE, HTFlag, FSizePos), msConjoin);
    Control := Zone.ChildControl;
  end
  else
    Control := nil;
  if (Control <> nil) and (HTFlag <> FOldHTFlag) then
  begin
    Application.HideHint;
    Application.HintMouseMessage(Control, TMessage(Msg));
    Application.ActivateHint(SmallPointToPoint(Msg.Pos));
    FOldHTFlag := HTFlag;
  end;
end;

function TJvDockTree.DoLButtonDown(var Msg: TWMMouse;
  var Zone: TJvDockZone; out HTFlag: Integer): Boolean;
var
  P: TPoint;
  Mesg: TMsg;
begin
  Result := False;
  P := SmallPointToPoint(Msg.Pos);

  Zone := InternalHitTest(P, HTFlag);
  if Zone <> nil then
  begin
    if HTFlag = HTSPLITTER then
      SplitterMouseDown(Zone, P)
    else
    if (HTFlag = HTCAPTION) or (HTFlag = HTBORDER) then
    begin
      JvJvGlobalDockClient := FindDockClient(Zone.ChildControl);
      if JvJvGlobalDockClient <> nil then
        JvJvGlobalDockClient.DoNCButtonDown(JvDockCreateNCMessage(
          DockSite, WM_NCLBUTTONDOWN, HTFlag, P), mbLeft, msConjoin);

      if (not PeekMessage(Mesg, FDockSite.Handle, WM_LBUTTONDBLCLK,
        WM_LBUTTONDBLCLK, PM_NOREMOVE)) and
        (Zone.ChildControl is TWinControl) then
        if (GetActiveControl <> Zone.ChildControl) and Zone.ChildControl.CanFocus then
          Zone.ChildControl.SetFocus;
      if (THackWinControl(Zone.ChildControl).DragKind = dkDock) and
        (THackWinControl(Zone.ChildControl).DragMode = dmAutomatic) then
        BeginDrag(Zone.ChildControl, True);
      Result := True;
    end;
  end;
end;

procedure TJvDockTree.DoLButtonUp(var Msg: TWMMouse;
  var Zone: TJvDockZone; out HTFlag: Integer);
var
  P: TPoint;
  DockClient: TJvDockClient;
begin
  if FSizingZone = nil then
  begin
    P := SmallPointToPoint(Msg.Pos);
    Zone := InternalHitTest(P, HTFlag);
    if Zone <> nil then
      if (HTFlag <> HTSPLITTER) and (Zone.ChildControl <> nil) then
      begin
        DockClient := FindDockClient(Zone.ChildControl);
        if DockClient <> nil then
          DockClient.DoNCButtonUp(JvDockCreateNCMessage(
            DockSite, WM_NCLBUTTONUP, HTFlag, P), mbLeft, msConjoin);
        if HTFlag = HTCLOSE then
        begin
          if (DockClient <> nil) and (not DockClient.EnableCloseButton) then
            Exit;
          DoHideZoneChild(Zone);
        end;
      end;
  end
  else
    SplitterMouseUp;
end;

procedure TJvDockTree.DoLButtonDbClk(var Msg: TWMMouse;
  var Zone: TJvDockZone; out HTFlag: Integer);
var
  P: TPoint;
begin
  P := SmallPointToPoint(Msg.Pos);
  Zone := InternalHitTest(P, HTFlag);
  if (Zone <> nil) and (Zone.ChildControl <> nil) and
    (HTFlag = HTCAPTION) or (HTFlag = HTBORDER) then
  begin
    if HTFlag <> HTSPLITTER then
      JvJvGlobalDockClient.DoNCButtonDblClk(JvDockCreateNCMessage(
        DockSite, WM_NCLBUTTONUP, HTFlag, P), mbLeft, msConjoin);
    if JvJvGlobalDockClient.CanFloat then
    begin
      JvGlobalDockManager.CancelDrag;
      Zone.LButtonDblClkMethod;
    end;
    Zone := nil;
  end;
end;

procedure TJvDockTree.DoSetCursor(var Msg: TWMSetCursor;
  var Zone: TJvDockZone; out HTFlag: Integer);
var
  P: TPoint;
begin
  GetCursorPos(P);
  P := FDockSite.ScreenToClient(P);
  with Msg do
    if (Smallint(HitTest) = HTCLIENT) and (CursorWnd = FDockSite.Handle) and
      (FDockSite.VisibleDockClientCount > 0) then
    begin
      Zone := InternalHitTest(P, HTFlag);
      if (Zone <> nil) and (HTFlag = HTSPLITTER) then
      begin
        SetSplitterCursor(Zone.ParentZone.Orientation);
        Result := 1;
      end;
    end;
end;

procedure TJvDockTree.DoHintShow(var Msg: TCMHintShow;
  var Zone: TJvDockZone; out HTFlag: Integer);
var
  Control: TWinControl;
  R: TRect;
  ADockClient: TJvDockClient;
  CanShow: Boolean;
begin
  with Msg do
  begin
    if Result = 0 then
    begin
      Zone := InternalHitTest(HintInfo^.CursorPos, HTFlag);
      if Zone <> nil then
        Control := Zone.ChildControl
      else
        Control := nil;

      ADockClient := FindDockClient(Control);
      if (ADockClient <> nil) and (not ADockClient.ShowHint) then
        Exit;

      if HTFlag = HTSPLITTER then
        HintInfo^.HintStr := ''
      else
      if Control <> nil then
      begin
        R := GetFrameRect(Control);
        if HTFlag = HTCAPTION then
          HintInfo^.HintStr := THackWinControl(Control).Caption
        else
        if HTFlag = HTCLOSE then
          HintInfo^.HintStr := RsDockJvDockTreeCloseBtnHint
        else
          DoOtherHint(Zone, HTFlag, HintInfo^.HintStr);

        HintInfo^.CursorRect := R;

        CanShow := True;
        if ADockClient <> nil then
          ADockClient.DoFormShowHint(HTFlag, HintInfo^.HintStr, CanShow);
        if not CanShow then
          HintInfo^.HintStr := '';
      end;
    end;
  end;
end;

procedure TJvDockTree.SetSplitterCursor(CursorIndex: TDockOrientation);
const
  SizeCursors: array [TDockOrientation] of TCursor =
    (crDefault, crVSplit, crHSplit);
begin
  Windows.SetCursor(Screen.Cursors[SizeCursors[CursorIndex]]);
end;

procedure TJvDockTree.SetDockZoneClass(const Value: TJvDockZoneClass);
begin
  FDockZoneClass := Value;
end;

procedure TJvDockTree.DoMButtonDown(var Msg: TWMMouse;
  var Zone: TJvDockZone; out HTFlag: Integer);
var
  Mesg: TWMNCHitMessage;
  DockClient: TJvDockClient;
begin
  Mesg := DoMouseEvent(Msg, Zone, HTFlag);
  if Mesg.Result > 0 then
  begin
    DockClient := FindDockClient(Zone.ChildControl);
    if DockClient <> nil then
      DockClient.DoNCButtonDown(Mesg, mbMiddle, msConjoin);
  end;
end;

procedure TJvDockTree.DoMButtonUp(var Msg: TWMMouse;
  var Zone: TJvDockZone; out HTFlag: Integer);
var
  Mesg: TWMNCHitMessage;
  DockClient: TJvDockClient;
begin
  Mesg := DoMouseEvent(Msg, Zone, HTFlag);
  if Mesg.Result > 0 then
  begin
    DockClient := FindDockClient(Zone.ChildControl);
    if DockClient <> nil then
      DockClient.DoNCButtonUp(Mesg, mbMiddle, msConjoin);
  end;
end;

procedure TJvDockTree.DoRButtonDown(var Msg: TWMMouse;
  var Zone: TJvDockZone; out HTFlag: Integer);
var
  Mesg: TWMNCHitMessage;
  DockClient: TJvDockClient;
begin
  Mesg := DoMouseEvent(Msg, Zone, HTFlag);
  if Mesg.Result > 0 then
  begin
    DockClient := FindDockClient(Zone.ChildControl);
    if DockClient <> nil then
      DockClient.DoNCButtonDown(Mesg, mbRight, msConjoin);
  end;
end;

procedure TJvDockTree.DoRButtonUp(var Msg: TWMMouse;
  var Zone: TJvDockZone; out HTFlag: Integer);
var
  Mesg: TWMNCHitMessage;
  DockClient: TJvDockClient;
begin
  Mesg := DoMouseEvent(Msg, Zone, HTFlag);
  if Mesg.Result > 0 then
  begin
    DockClient := FindDockClient(Zone.ChildControl);
    if DockClient <> nil then
      DockClient.DoNCButtonUp(Mesg, mbRight, msConjoin);
  end;
end;

function TJvDockTree.DoMouseEvent(var Msg: TWMMouse;
  var Zone: TJvDockZone; out HTFlag: Integer): TWMNCHitMessage;
var
  Pt: TPoint;
begin
  Result.Result := 0;
  Pt := SmallPointToPoint(Msg.Pos);
  Zone := InternalHitTest(Pt, HTFlag);
  if (Zone <> nil) and (Zone.ChildControl <> nil) and (HTFlag <> HTSPLITTER) then
  begin
    Result := JvDockCreateNCMessage(DockSite, Msg.Msg + WM_NCMOUSEFIRST - WM_MOUSEFIRST, HTFlag, Pt);
    Result.Result := 1;
  end;
end;

procedure TJvDockTree.DoMButtonDbClk(var Msg: TWMMouse;
  var Zone: TJvDockZone; out HTFlag: Integer);
var
  Pt: TPoint;
  DockClient: TJvDockClient;
begin
  Pt := SmallPointToPoint(Msg.Pos);
  Zone := InternalHitTest(Pt, HTFlag);
  if (Zone <> nil) and (Zone.ChildControl <> nil) and (HTFlag = HTCAPTION) then
    if HTFlag <> HTSPLITTER then
    begin
      DockClient := FindDockClient(Zone.ChildControl);
      if DockClient <> nil then
        DockClient.DoNCButtonDblClk(JvDockCreateNCMessage(
          DockSite, WM_NCLBUTTONUP, HTFlag, Pt), mbMiddle, msConjoin);
    end;
end;

procedure TJvDockTree.DoRButtonDbClk(var Msg: TWMMouse;
  var Zone: TJvDockZone; out HTFlag: Integer);
var
  Pt: TPoint;
  DockClient: TJvDockClient;
begin

  Pt := SmallPointToPoint(Msg.Pos);
  Zone := InternalHitTest(Pt, HTFlag);
  if (Zone <> nil) and (Zone.ChildControl <> nil) and (HTFlag = HTCAPTION) then
    if HTFlag <> HTSPLITTER then
    begin
      DockClient := FindDockClient(Zone.ChildControl);
      if DockClient <> nil then
        DockClient.DoNCButtonDblClk(JvDockCreateNCMessage(
          DockSite, WM_NCLBUTTONUP, HTFlag, Pt), mbRight, msConjoin);
    end;
end;

function TJvDockTree.GetFrameRect(Control: TControl): TRect;
var
  NLeft, NTop: Integer;
begin
  if Control <> nil then
  begin
    Result := Control.BoundsRect;
    NLeft := Result.Left;
    NTop := Result.Top;
    AdjustDockRect(Control, Result);
    Dec(Result.Left, 2 * (Result.Left - Control.Left) + 1);
    Dec(Result.Top, 2 * (Result.Top - Control.Top));
    Dec(Result.Right, 2 * (Result.Right - NLeft - Control.Width));
    Dec(Result.Bottom, 2 * (Result.Bottom - NTop - Control.Height));
  end
  else
    raise Exception.Create(RsDockControlCannotIsNil);
end;

function TJvDockTree.GetSplitterRect(Zone: TJvDockZone): TRect;
var
  A, B, C, D: Integer;
begin
  if (Zone <> nil) and Zone.Visibled and (Zone.ParentZone <> nil) and
    (Zone.VisibleNextSiblingCount >= 1) and
    (Zone.ParentZone.Orientation <> doNoOrient) then
  begin
    A := Zone.ParentZone.LimitBegin;
    B := Zone.ParentZone.ZoneLimit;
    C := Zone.ZoneLimit - SplitterWidth;
    D := C + 1 * SplitterWidth;
    if Zone.ParentZone.Orientation = doHorizontal then
      Result := Rect(A, C, B, D)
    else
    if Zone.ParentZone.Orientation = doVertical then
      Result := Rect(C, A, D, B);
  end
  else
    Result := Rect(0, 0, 0, 0);
end;

procedure TJvDockTree.BeginDrag(Control: TControl;
  Immediate: Boolean; Threshold: Integer);
var
  DockClient: TJvDockClient;
begin
  DockClient := FindDockClient(Control);
  if DockClient <> nil then
    JvGlobalDockManager.BeginDrag(Control, DockClient.DirectDrag, Threshold);
end;

function TJvDockTree.GetFrameRectEx(Control: TControl): TRect;
begin
  if Control <> nil then
  begin
    Result := GetFrameRect(Control);
    MapWindowPoints(DockSite.Handle, 0, Result, 2);
  end;
end;

procedure TJvDockTree.DrawDockSiteRect;
begin
end;

procedure TJvDockTree.SetBorderWidth(const Value: Integer);
begin
  if FBorderWidth <> Value then
  begin
    FBorderWidth := Value;
    if FUpdateCount <= 0 then
      UpdateAll;
  end;
end;

function TJvDockTree.GetBorderWidth: Integer;
begin
  Result := FBorderWidth;
end;

function TJvDockTree.GetDockSplitterWidth: Integer;
begin
  Result := FSplitterWidth;
end;

procedure TJvDockTree.DrawSplitter(Zone: TJvDockZone);
var
  R: TRect;
begin
  R := GetSplitterRect(Zone);
  DrawSplitterRect(R);
end;

function TJvDockTree.GetDockEdge(DockRect: TRect; MousePos: TPoint;
  var DropAlign: TAlign; Control: TControl): TControl;
begin
  Result := nil;
end;

function TJvDockTree.GetDockSiteOrientation: TDockOrientation;
begin
  Result := JvDockGetControlOrient(DockSite);
end;

procedure TJvDockTree.BeginResizeDockSite;
begin
  Inc(FResizeCount);
end;

procedure TJvDockTree.EndResizeDockSite;
begin
  Dec(FResizeCount);
  if FResizeCount < 0 then
    FResizeCount := 0;
end;

procedure TJvDockTree.ScaleChildZone(Zone: TJvDockZone);
begin
  if (Zone <> nil) and (Zone.ParentZone <> nil) and Zone.Visibled and
    (Zone.ParentZone.Orientation = ShiftScaleOrientationation) then
    Zone.ZoneLimit := Integer(Round(Zone.ZoneLimit * ScaleBy + FParentLimit * (1 - ScaleBy)));
end;

procedure TJvDockTree.ScaleSiblingZone(Zone: TJvDockZone);
begin
  ScaleChildZone(Zone);
end;

function TJvDockTree.GetDockSiteSize: Integer;
begin
  case DockSiteOrientationation of
    doVertical:
      Result := DockSite.Width;
    doHorizontal:
      Result := DockSite.Height;
  else
    raise Exception.Create(RsDockCannotGetValueWithNoOrient);
  end;
end;

procedure TJvDockTree.SetDockSiteSize(const Value: Integer);
begin
  DockSite.Parent.DisableAlign;
  try
    if DockSite.Align in [alRight, alBottom] then
      DockSiteBegin := DockSiteBegin - (Value - DockSiteSize);
    case DockSiteOrientationation of
      doVertical:
        DockSite.Width := Value;
      doHorizontal:
        DockSite.Height := Value;
    else
      raise Exception.Create(RsDockCannotSetValueWithNoOrient);
    end;
  finally
    DockSite.Parent.EnableAlign;
  end;
end;

procedure TJvDockTree.SetMinSize(const Value: Integer);
begin
  FMinSize := Value;
end;

function TJvDockTree.GetDockSiteBegin: Integer;
begin
  case DockSiteOrientationation of
    doVertical:
      Result := DockSite.Left;
    doHorizontal:
      Result := DockSite.Top;
  else
    raise Exception.Create(RsDockCannotGetValueWithNoOrient);
  end;
end;

procedure TJvDockTree.SetDockSiteBegin(const Value: Integer);
begin
  case DockSiteOrientationation of
    doVertical:
      DockSite.Left := Value;
    doHorizontal:
      DockSite.Top := Value;
  else
    raise Exception.Create(RsDockCannotSetValueWithNoOrient);
  end;
end;

function TJvDockTree.GetDockSiteSizeAlternatelternatelternate: Integer;
begin
  case DockSiteOrientationation of
    doVertical:
      Result := DockSite.Height;
    doHorizontal:
      Result := DockSite.Width;
  else
    raise Exception.Create(RsDockCannotGetValueWithNoOrient);
  end;
end;

procedure TJvDockTree.SetDockSiteSizeAlternatelternatelternate(const Value: Integer);
begin
  case DockSiteOrientationation of
    doVertical:
      DockSite.Height := Value;
    doHorizontal:
      DockSite.Width := Value;
  else
    raise Exception.Create(RsDockCannotSetValueWithNoOrient);
  end;
end;

procedure TJvDockTree.CalcSplitterPos;
var
  MinWidth: Integer;
  TestLimit: Integer;
begin
  MinWidth := MinSize;
  if FSizingZone.ParentZone.Orientation = doHorizontal then
  begin
    TestLimit := GetSplitterLimit(FSizingZone, True, False) + MinWidth;
    if FSizePos.y <= TestLimit then
      FSizePos.y := TestLimit;
    TestLimit := GetSplitterLimit(FSizingZone, False, True) - MinWidth - SplitterWidth;
    if FSizePos.y >= TestLimit then
      FSizePos.y := TestLimit;
  end
  else
  begin
    TestLimit := GetSplitterLimit(FSizingZone, True, False) + MinWidth;
    if FSizePos.x <= TestLimit then
      FSizePos.x := TestLimit;
    TestLimit := GetSplitterLimit(FSizingZone, False, True) - MinWidth - SplitterWidth;
    if FSizePos.x >= TestLimit then
      FSizePos.x := TestLimit;
  end;
end;

procedure TJvDockTree.SetVersion(const Value: Integer);
begin
  FVersion := Value;
end;

procedure TJvDockTree.DoSaveZone(Stream: TStream;
  Zone: TJvDockZone; Level: Integer);
begin
  with Stream do
  begin
    Write(Level, SizeOf(Level));
    CustomSaveZone(Stream, Zone);
  end;

  if Zone.ChildZones <> nil then
    DoSaveZone(Stream, Zone.ChildZones, Level + 1);
  if Zone.NextSibling <> nil then
    DoSaveZone(Stream, Zone.NextSibling, Level);
end;

procedure TJvDockTree.WriteControlName(Stream: TStream; ControlName: string);
var
  NameLen: Integer;
begin
  NameLen := Length(ControlName);
  Stream.Write(NameLen, SizeOf(NameLen));
  if NameLen > 0 then
    Stream.Write(Pointer(ControlName)^, NameLen);
end;

procedure TJvDockTree.DoLoadZone(Stream: TStream);
var
  Level, LastLevel, I: Integer;
  Zone, LastZone, NextZone: TJvDockZone;
begin
  LastLevel := 0;
  LastZone := nil;
  while True do
  begin
    with Stream do
    begin
      Read(Level, SizeOf(Level));
      if Level = TreeStreamEndFlag then
        Break;
      Zone := FDockZoneClass.Create(Self);
      CustomLoadZone(Stream, Zone);
      if Zone = nil then
        Continue;
    end;
    if Level = 0 then
      FTopZone := Zone
    else
    if Level = LastLevel then
    begin
      LastZone.NextSibling := Zone;
      Zone.FPrevSibling := LastZone;
      Zone.FParentZone := LastZone.FParentZone;
    end
    else
    if Level > LastLevel then
    begin
      LastZone.ChildZones := Zone;
      Zone.FParentZone := LastZone;
    end
    else
    if Level < LastLevel then
    begin
      NextZone := LastZone;
      for I := 1 to LastLevel - Level do
        NextZone := NextZone.FParentZone;
      NextZone.NextSibling := Zone;
      Zone.FPrevSibling := NextZone;
      Zone.FParentZone := NextZone.FParentZone;
    end;
    LastLevel := Level;
    LastZone := Zone;
  end;
end;

procedure TJvDockTree.ReadControlName(Stream: TStream;
  var ControlName: string);
var
  Size: Integer;
begin
  ControlName := '';
  Size := 0;
  Stream.Read(Size, SizeOf(Size));
  if Size > 0 then
  begin
    SetLength(ControlName, Size);
    Stream.Read(Pointer(ControlName)^, Size);
  end;
end;

procedure TJvDockTree.CustomLoadZone(Stream: TStream; var Zone: TJvDockZone);
var
  CompName: string;
begin
  with Stream do
  begin
    Read(Zone.FOrientation, SizeOf(Zone.Orientation));
    Read(Zone.FZoneLimit, SizeOf(Zone.FZoneLimit));
    Read(Zone.FVisibled, SizeOf(Zone.Visibled));
    Read(Zone.FControlVisibled, SizeOf(Zone.FControlVisibled));
    Read(Zone.FVisibleSize, SizeOf(Zone.VisibleSize));
    Read(Zone.FIsInside, SizeOf(Zone.FIsInside));
    ReadControlName(Stream, CompName);
    if CompName <> '' then
      if not Zone.SetControlName(CompName) then
      begin
        Zone.Free;
        Zone := nil;
      end;
  end;
end;

procedure TJvDockTree.CustomSaveZone(Stream: TStream; Zone: TJvDockZone);
var
  AVisible: Boolean;
begin
  with Stream do
  begin
    Write(Zone.Orientation, SizeOf(Zone.Orientation));
    Write(Zone.ZoneLimit, SizeOf(Zone.ZoneLimit));

    if Zone.ChildControl <> nil then
      AVisible := Zone.ChildControl.Visible;
    Write(Zone.Visibled, SizeOf(Zone.Visibled));

    AVisible := False;
    if Zone.ChildControl <> nil then
      AVisible := Zone.ChildControl.Visible;
    Write(AVisible, SizeOf(AVisible));

    Write(Zone.VisibleSize, SizeOf(Zone.VisibleSize));

    Zone.IsInside := True;
    if (Zone.ChildControl <> nil) and (Zone.ChildControl.HostDockSite <> DockSite) and
      not (DockSite is TJvDockVSPopupPanel) then
      Zone.IsInside := False;
    Write(Zone.IsInside, SizeOf(Zone.IsInside));

    WriteControlName(Stream, Zone.GetControlName);
  end;
end;

procedure TJvDockTree.SetDockSiteSizeWithOrientation(Orient: TDockOrientation;
  const Value: Integer);
begin
  case Orient of
    doVertical:
      DockSite.Width := Value;
    doHorizontal:
      DockSite.Height := Value;
  else
    raise Exception.Create(RsDockCannotSetValueWithNoOrient);
  end;
end;

procedure TJvDockTree.DoOtherHint(Zone: TJvDockZone;
  HTFlag: Integer; var HintStr: string);
begin
end;

function TJvDockTree.GetHTFlag(MousePos: TPoint): Integer;
var
  Zone: TJvDockZone;
begin
  Zone := InternalHitTest(MousePos, Result);
  if Zone = nil then
    Result := HTNONE;
end;

procedure TJvDockTree.GetSiteInfo(Client: TControl;
  var InfluenceRect: TRect; MousePos: TPoint; var CanDock: Boolean);
begin
  GetWindowRect(DockSite.Handle, InfluenceRect);
  InflateRect(InfluenceRect, DefExpandoRect, DefExpandoRect);
end;

function TJvDockTree.GetDockRect: TRect;
begin
  Result := FDockRect;
end;

procedure TJvDockTree.SetDockRect(const Value: TRect);
begin
  FDockRect := Value;
end;

function TJvDockTree.GetDockAlign(Client: TControl; var DropCtl: TControl): TAlign;
var
  CRect, DRect: TRect;
begin
  Result := alRight;
  if DropCtl <> nil then
  begin
    CRect := Client.BoundsRect;
    DRect := DropCtl.BoundsRect;
    if (CRect.Top <= DRect.Top) and (CRect.Bottom < DRect.Bottom) and
      (CRect.Right >= DRect.Right) then
      Result := alTop
    else
    if (CRect.Left <= DRect.Left) and (CRect.Right < DRect.Right) and
      (CRect.Bottom >= DRect.Bottom) then
      Result := alLeft
    else
    if CRect.Top >= ((DRect.Top + DRect.Bottom) div 2) then
      Result := alBottom;
  end;
end;

procedure TJvDockTree.HideControl(Control: TControl);
var
  Z: TJvDockZone;
begin
  if ReplacementZone <> nil then
    Exit;
  Z := FindControlZone(Control);
  if Z <> nil then
  begin
    if Z = FReplacementZone then
      Z.ChildControl := nil
    else
    begin
      if TopZone.VisibleChildTotal = 1 then
        Z.Remove(TopXYLimit, True)
      else
        Z.Remove(Z.LimitSize, True);
    end;
    Control.DockOrientation := doNoOrient;
    SetNewBounds(nil);
    UpdateAll;

    FDockSite.Invalidate;
  end;
end;

procedure TJvDockTree.ShowControl(Control: TControl);
var
  Z: TJvDockZone;
begin
  if ReplacementZone <> nil then
    Exit;
  Z := FindControlZone(Control, True);
  if Z <> nil then
    Z.Insert(Z.VisibleSize, False);

  SetNewBounds(nil);
  UpdateAll;
  DockSite.Invalidate;
end;

procedure TJvDockTree.DoGetNextLimit(Zone, AZone: TJvDockZone; var LimitResult: Integer);
begin
  if (Zone <> AZone) and
    (Zone.ParentZone.Orientation = AZone.ParentZone.Orientation) and
    (Zone.ZoneLimit > AZone.FZoneLimit) and ((Zone.ChildControl = nil) or
    ((Zone.ChildControl <> nil) and (Zone.ChildControl.Visible))) then
    LimitResult := Min(LimitResult, Zone.ZoneLimit);
  if Zone.NextSibling <> nil then
    DoGetNextLimit(Zone.NextSibling, AZone, LimitResult);

  if Zone.ChildZones <> nil then
    DoGetNextLimit(Zone.ChildZones, AZone, LimitResult);
end;

procedure TJvDockTree.UpdateChild(Zone: TJvDockZone);
begin
  if (FUpdateCount = 0) and (FDockSite.DockClientCount > 0) then
    ForEachAt(Zone, UpdateZone, tskForward);
end;

function TJvDockTree.GetDockClientLimit(Orient: TDockOrientation; IsMin: Boolean): Integer;
var
  Zone: TJvDockZone;
begin
  Result := 0;
  if TopZone.ChildCount = 1 then
    Result := Integer(not IsMin) * DockSiteSizeWithOrientationation[Orient]
  else
  begin
    if IsMin then
    begin
      if TopZone.Orientation = Orient then
        Zone := TopZone.LastVisibleChildZone
      else
        Zone := TopZone;
      if Zone <> nil then
        Result := Zone.LimitBegin;
    end
    else
    begin
      if TopZone.Orientation = Orient then
        Zone := TopZone.FirstVisibleChildZone
      else
        Zone := TopZone;
      if Zone <> nil then
        Result := Zone.ZoneLimit;
    end;

    TopZone.DoGetSplitterLimit(Orient, IsMin, Result);
  end;
end;

function TJvDockTree.GetDockSiteSizeWithOrientation(Orient: TDockOrientation): Integer;
begin
  case Orient of
    doVertical:
      Result := DockSite.Width;
    doHorizontal:
      Result := DockSite.Height;
  else
    raise Exception.Create(RsDockCannotGetValueWithNoOrient);
  end;
end;

function TJvDockTree.GetMinSize: Integer;
begin
  Result := FMinSize;
end;

procedure TJvDockTree.GetCaptionRect(var Rect: TRect);
begin
  Rect.Left := 0;
  Rect.Top := 0;
  Rect.Right := 0;
  Rect.Bottom := 0;
end;

procedure TJvDockTree.HideAllControl;

  procedure DoHideAllControl(AZone: TJvDockZone);
  begin
    if AZone <> nil then
    begin
      DoHideAllControl(AZone.NextSibling);
      DoHideAllControl(AZone.ChildZones);
      if (AZone.ChildControl <> nil) and (AZone.visibled) then
        AZone.Remove(AZone.LimitSize, True);
    end;
  end;

begin
  if ReplacementZone <> nil then
    Exit;
  DoHideAllControl(TopZone.ChildZones);
  SetNewBounds(nil);
  UpdateAll;
  DockSite.Invalidate;
end;

procedure TJvDockTree.HideSingleControl(Control: TControl);

  procedure DoHideSingleControl(AZone: TJvDockZone);
  begin
    if AZone <> nil then
    begin
      DoHideSingleControl(AZone.NextSibling);
      DoHideSingleControl(AZone.ChildZones);
      if AZone.ChildControl <> nil then
        if AZone.ChildControl = Control then
        begin
          if AZone.ChildControl.Visible then
          begin
            AZone.Remove(AZone.LimitSize, True);
            AZone.ChildControl.Visible := False;
          end;
        end
        else
        begin
          AZone.Insert(AZone.VisibleSize, False);
          AZone.ChildControl.Visible := True;
        end;
    end;
  end;

begin
  if ReplacementZone <> nil then
    Exit;
  if Control <> nil then
  begin
    DoHideSingleControl(TopZone.ChildZones);
    SetNewBounds(nil);
    UpdateAll;
    DockSite.Invalidate;
  end;
end;

procedure TJvDockTree.ShowAllControl;

  procedure DoShowAllControl(AZone: TJvDockZone);
  begin
    if AZone <> nil then
    begin
      DoShowAllControl(AZone.NextSibling);
      DoShowAllControl(AZone.ChildZones);
      if (AZone.ChildControl <> nil) and not AZone.Visibled then
        AZone.Insert(AZone.VisibleSize, True);
    end;
  end;

begin
  if ReplacementZone <> nil then
    Exit;
  DoShowAllControl(TopZone.ChildZones);
  SetNewBounds(nil);
  UpdateAll;
  DockSite.Invalidate;
end;

procedure TJvDockTree.ShowSingleControl(Control: TControl);

  procedure DoShowSingleControl(AZone: TJvDockZone);
  begin
    if AZone <> nil then
    begin
      DoShowSingleControl(AZone.NextSibling);
      DoShowSingleControl(AZone.ChildZones);
      if AZone.ChildControl <> nil then
        if AZone.ChildControl = Control then
        begin
          if not AZone.ChildControl.Visible then
          begin
            AZone.Insert(AZone.VisibleSize, False);
            AZone.ChildControl.Visible := True;
          end;
        end
        else
        begin
          AZone.Remove(AZone.LimitSize, True);
          AZone.ChildControl.Visible := False;
        end;
    end;
  end;

begin
  if ReplacementZone <> nil then
    Exit;
  if Control <> nil then
  begin
    DoShowSingleControl(TopZone.ChildZones);
    SetNewBounds(nil);
    UpdateAll;
    DockSite.Invalidate;
  end;
end;

procedure TJvDockTree.DrawDockBorder(DockControl: TControl; R1, R2: TRect);
begin
end;

procedure TJvDockTree.DrawDockGrabber(Control: TControl;
  const ARect: TRect);

  procedure DrawCloseButton(Left, Top: Integer);
  var
    ADockClient: TJvDockClient;
  begin
    ADockClient := FindDockClient(Control);
    if (ADockClient <> nil) and not ADockClient.EnableCloseButton then
      Exit;
    DrawFrameControl(Canvas.Handle, Rect(Left, Top, Left + GrabberSize - 2,
      Top + GrabberSize - 2), DFC_CAPTION, DFCS_CAPTIONCLOSE);
  end;

  procedure DrawGrabberLine(Left, Top, Right, Bottom: Integer);
  begin
    with Canvas do
    begin
      Pen.Color := clBtnHighlight;
      MoveTo(Right, Top);
      LineTo(Left, Top);
      LineTo(Left, Bottom);
      Pen.Color := clBtnShadow;
      LineTo(Right, Bottom);
      LineTo(Right, Top - 1);
    end;
  end;

begin
  with ARect do
    case GrabbersPosition of
      gpLeft:
        begin
          DrawCloseButton(Left + BorderWidth + BorderWidth + 1, Top + BorderWidth + BorderWidth + 1);
          DrawGrabberLine(Left + BorderWidth + 3, Top + GrabberSize + BorderWidth + 1, Left + BorderWidth + 5, Bottom +
            BorderWidth - 2);
          DrawGrabberLine(Left + BorderWidth + 6, Top + GrabberSize + BorderWidth + 1, Left + BorderWidth + 8, Bottom +
            BorderWidth - 2);
        end;
      gpTop:
        begin
          DrawCloseButton(Right - GrabberSize + BorderWidth + 1, Top + BorderWidth + 1);
          DrawGrabberLine(Left + BorderWidth + 2, Top + BorderWidth + BorderWidth + 3, Right - GrabberSize + BorderWidth
            - 2, Top + BorderWidth + 5);
          DrawGrabberLine(Left + BorderWidth + 2, Top + BorderWidth + BorderWidth + 6, Right - GrabberSize + BorderWidth
            - 2, Top + BorderWidth + 8);
        end;
    end;
end;

procedure TJvDockTree.DrawSplitterRect(const ARect: TRect);
begin
  Canvas.Brush.Color := THackWinControl(DockSite).Color;
  Canvas.FillRect(ARect);
end;

procedure TJvDockTree.DrawZone(Zone: TJvDockZone);
begin
  DrawZoneBorder(Zone);
  DrawZoneGrabber(Zone);
  DrawZoneSplitter(Zone);
  DrawDockSiteRect;
end;

procedure TJvDockTree.DrawZoneBorder(Zone: TJvDockZone);
var
  ChildControl: TControl;
begin
  if Zone = nil then
    Exit;
  ChildControl := Zone.ChildControl;
  if (ChildControl <> nil) and ChildControl.Visible and
    (ChildControl.HostDockSite = DockSite) then
  begin
  end;
end;

procedure TJvDockTree.DrawZoneGrabber(Zone: TJvDockZone);
var
  ChildControl: TControl;
  R: TRect;
begin
  if Zone = nil then
    Exit;
  ChildControl := Zone.ChildControl;
  if (ChildControl <> nil) and ChildControl.Visible and
    (ChildControl.HostDockSite = DockSite) then
  begin
    R := GetFrameRect(ChildControl);
    DrawDockGrabber(ChildControl, R);
  end;
end;

procedure TJvDockTree.DrawZoneSplitter(Zone: TJvDockZone);
var
  R: TRect;
begin
  R := GetSplitterRect(Zone);
  DrawSplitterRect(R);
end;

procedure TJvDockTree.PaintDockSite;
begin
  ForEachAt(nil, DrawZone, tskBackward);
end;

function TJvDockTree.HasZoneWithControl(Control: TControl): Boolean;
begin
  Result := FindControlZone(Control, True) <> nil;
end;

procedure TJvDockTree.ReplaceZoneChild(OldControl, NewControl: TControl);
var
  Zone: TJvDockZone;
begin
  Zone := FindControlZone(OldControl, True);
  if Zone <> nil then
  begin
    Zone.ChildControl := TWinControl(NewControl);
    UpdateAll;
  end;
end;

procedure TJvDockTree.DoHideZoneChild(AZone: TJvDockZone);
var
  AForm: TCustomForm;
begin
  if (AZone <> nil) and (AZone.ChildControl <> nil) then
    if AZone.ChildControl.InheritsFrom(TCustomForm) then
    begin
      AForm := TCustomForm(AZone.ChildControl);
      AForm.Close;
    end
    else
      AZone.ChildControl.Visible := False;
end;

//=== TJvDockAdvZone =========================================================

constructor TJvDockAdvZone.Create(Tree: TJvDockTree);
begin
  inherited Create(Tree);
  FCloseBtnDown := False;
  FMouseDown := False;
end;

destructor TJvDockAdvZone.Destroy;
begin
  if Self = TJvDockAdvTree(Tree).CloseButtonZone then
    TJvDockAdvTree(Tree).CloseButtonZone := nil;
  inherited Destroy;
end;

procedure TJvDockAdvZone.Insert(DockSize: Integer; Hide: Boolean);
begin
  InsertOrRemove(DockSize, True, Hide);
end;

procedure TJvDockAdvZone.LButtonDblClkMethod;
begin
  if JvJvGlobalDockClient <> nil then
    JvJvGlobalDockClient.RestoreChild;
end;

procedure TJvDockAdvZone.Remove(DockSize: Integer; Hide: Boolean);
begin
  InsertOrRemove(DockSize, False, Hide);
end;

//=== TJvDockAdvTree =========================================================

constructor TJvDockAdvTree.Create(DockSite: TWinControl;
  ADockZoneClass: TJvDockZoneClass);
begin
  inherited Create(DockSite, ADockZoneClass);
  GrabberSize := 15;
  FButtonHeight := 12;
  FButtonWidth := 12;
  FLeftOffset := 0;
  FRightOffset := 0;
  FTopOffset := 0;
  FBottomOffset := 0;
  FButtonSplitter := 2;
end;

function TJvDockAdvTree.DoLButtonDown(var Msg: TWMMouse;
  var Zone: TJvDockZone; out HTFlag: Integer): Boolean;
var
  TempZone: TJvDockAdvZone;
begin
  Result := inherited DoLButtonDown(Msg, Zone, HTFlag);
  if (Zone <> nil) and (HTFlag = HTCLOSE) then
  begin
    TempZone := TJvDockAdvZone(Zone);
    TempZone.CloseBtnDown := True;
    TempZone.MouseDown := True;
    FCloseButtonZone := TempZone;
    DockSite.Invalidate;
  end;
end;

procedure TJvDockAdvTree.DoLButtonUp(var Msg: TWMMouse;
  var Zone: TJvDockZone; out HTFlag: Integer);
begin
  inherited DoLButtonUp(Msg, Zone, HTFlag);
  if SizingZone = nil then
  begin
    FCloseButtonZone := nil;
    if (Zone <> nil) and (HTFlag = HTCLOSE) then
      TJvDockAdvZone(Zone).CloseBtnDown := False;
  end;
end;

procedure TJvDockAdvTree.DoMouseMove(var Msg: TWMMouse;
  var Zone: TJvDockZone; out HTFlag: Integer);
var
  TempZone: TJvDockAdvZone;
begin
  inherited DoMouseMove(Msg, Zone, HTFlag);
  if SizingZone = nil then
  begin
    TempZone := TJvDockAdvZone(Zone);
    if ((TempZone <> nil) and (TempZone.CloseBtnDown <> (HTFlag = HTCLOSE)) and
      ((FCloseButtonZone = TempZone) and FCloseButtonZone.MouseDown)) then
    begin
      TempZone.CloseBtnDown := (HTFlag = HTCLOSE) and FCloseButtonZone.MouseDown;
      DockSite.Invalidate;
    end;
  end;
end;

procedure TJvDockAdvTree.InsertSibling(NewZone, SiblingZone: TJvDockZone;
  InsertLast, Update: Boolean);
var
  TempUpdate: Boolean;
begin
  TempUpdate := Update;
  Update := False;
  try
    inherited InsertSibling(NewZone, SiblingZone, InsertLast, Update);
    if NewZone.ChildControl <> nil then
      SetDockHeightWidthArr(0, NewZone.ChildControl.TBDockHeight + BorderWidth,
        NewZone.ChildControl.LRDockWidth + BorderWidth)
    else
      SetDockHeightWidthArr(0, 0, 0);
  finally
    Update := TempUpdate;
  end;

  if Update then
  begin
    NewZone.Insert(FDropDockSize, False);
    SetNewBounds(NewZone.ParentZone);
    ForEachAt(NewZone.ParentZone, UpdateZone, tskForward);
  end;
end;

procedure TJvDockAdvTree.SetBottomOffset(const Value: Integer);
begin
  FBottomOffset := Value;
end;

procedure TJvDockAdvTree.SetButtonHeight(const Value: Integer);
begin
  FButtonHeight := Value;
end;

procedure TJvDockAdvTree.SetButtonSplitter(const Value: Integer);
begin
  FButtonSplitter := Value;
end;

procedure TJvDockAdvTree.SetButtonWidth(const Value: Integer);
begin
  FButtonWidth := Value;
end;

procedure TJvDockAdvTree.SetLeftOffset(const Value: Integer);
begin
  FLeftOffset := Value;
end;

procedure TJvDockAdvTree.SetRightOffset(const Value: Integer);
begin
  FRightOffset := Value;
end;

procedure TJvDockAdvTree.SetTopOffset(const Value: Integer);
begin
  FTopOffset := Value;
end;

function TJvDockAdvTree.GetDockHeightWidth(Orient: TDockOrientation): Integer;
begin
  Result := FDockHeightWidth[Orient];
end;

procedure TJvDockAdvTree.SetDockHeightWidth(Orient: TDockOrientation;
  const Value: Integer);
begin
  FDockHeightWidth[Orient] := Value;
end;

function TJvDockAdvTree.GetDockRectFromArr(Orient: TDockOrientation;
  AtLast: Boolean): Integer;
begin
  Result := FDockRectangles[Orient, Atlast];
end;

procedure TJvDockAdvTree.SetDockRectToArr(Orient: TDockOrientation;
  AtLast: Boolean; const Value: Integer);
begin
  FDockRectangles[Orient, Atlast] := Value;
end;

procedure TJvDockAdvTree.SetDockRectangles(ARect: TRect);
begin
  FDockRectangles[doNoOrient, False] := 0;
  FDockRectangles[doNoOrient, True] := 0;
  FDockRectangles[doHorizontal, False] := ARect.Top;
  FDockRectangles[doHorizontal, True] := ARect.Bottom;
  FDockRectangles[doVertical, False] := ARect.Left;
  FDockRectangles[doVertical, True] := ARect.Right;
end;

procedure TJvDockAdvTree.SetDockHeightWidthArr(NoOrValue, HorValue,
  VerValue: Integer);
begin
  FDockHeightWidth[doNoOrient] := NoOrValue;
  FDockHeightWidth[doHorizontal] := HorValue;
  FDockHeightWidth[doVertical] := VerValue;
end;

procedure TJvDockAdvTree.ScaleChildZone(Zone: TJvDockZone);
begin
  if Zone = ReplacementZone then
    ShiftScaleOrientationation := doNoOrient;
  inherited ScaleChildZone(Zone);
end;

procedure TJvDockAdvTree.ScaleSiblingZone(Zone: TJvDockZone);
begin
  if Zone = ReplacementZone then
    ShiftScaleOrientationation := doNoOrient;
  inherited ScaleSiblingZone(Zone);
end;

procedure TJvDockAdvTree.ScaleZone(Zone: TJvDockZone);
begin
  if Zone = ReplacementZone then
    ShiftScaleOrientationation := doNoOrient;
  inherited ScaleZone(Zone);
end;

procedure TJvDockAdvTree.ShiftZone(Zone: TJvDockZone);
begin
  if Zone = ReplacementZone then
    ShiftScaleOrientationation := doNoOrient;
  inherited ShiftZone(Zone);
end;

procedure TJvDockAdvTree.InsertNewParent(NewZone, SiblingZone: TJvDockZone;
  ParentOrientation: TDockOrientation; InsertLast, Update: Boolean);
var
  TempUpdate: Boolean;
begin
  TempUpdate := Update;
  Update := False;
  if NewZone.ChildControl <> nil then
    SetDockHeightWidthArr(0, NewZone.ChildControl.TBDockHeight + BorderWidth,
      NewZone.ChildControl.LRDockWidth + BorderWidth)
  else
    SetDockHeightWidthArr(0, 0, 0);

  if SiblingZone = nil then
    if InsertLast then
      ReplacementZone := TopZone
    else
      ReplacementZone := NewZone;

  try
    inherited InsertNewParent(NewZone, SiblingZone, ParentOrientation, InsertLast, Update);
  finally
    Update := TempUpdate;
    ReplacementZone := nil;
  end;

  if Update then
  begin
    NewZone.Insert(DropDockSize, False);
    ForEachAt(NewZone.ParentZone, UpdateZone, tskForward);
    SetNewBounds(NewZone.ParentZone);
  end;
end;

procedure TJvDockAdvTree.RemoveZone(Zone: TJvDockZone; Hide: Boolean);
begin
  inherited RemoveZone(Zone, Hide);
end;

procedure TJvDockAdvTree.SetDropDockSize(const Value: Integer);
begin
  FDropDockSize := Value;
end;

end.

