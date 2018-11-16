unit in0k_lazarusIdeSRC__tControls_fuckUpWndProc;

{$mode objfpc}{$H+}

interface

uses
  in0k_lazarusIdeSRC__tControl_fuckUpWndProc,
  //
  LMessages,
  syncobjs,
  Classes,
  Controls;


type
 tIn0k_lazIdeSRC__tControls_fuckUpLAIR_CORE=class;

 tIn0k_lazIdeSRC__tControls_fuckUpNODE=class(tIn0k_lazIdeSRC__tControl_fuckUpWndProc)
  strict private //< подмена аля "СабКлассинг"
    procedure _MY_WindowProc_(var TheMessage:TLMessage); //< МОЯ подстава
  protected
   _ownr_:tIn0k_lazIdeSRC__tControls_fuckUpLAIR_CORE;
   _next_:tIn0k_lazIdeSRC__tControls_fuckUpNODE;
  private
    function _fucUpControl_(const cntrl:TControl):boolean;
  public
    constructor Create(const Owner:tIn0k_lazIdeSRC__tControls_fuckUpLAIR_CORE);
  end;
 tIn0k_lazIdeSRC__tControls_fuckUpNODE_TYPE=class of tIn0k_lazIdeSRC__tControls_fuckUpNODE;

 tIn0k_lazIdeSRC__tControls_fuckUpLAIR_CORE=class
  protected
   _dfdr_:TCriticalSection;
  protected
   _frst_:tIn0k_lazIdeSRC__tControls_fuckUpNODE;
    function  _fnd_(const Control:TControl; const fuckUpTYPE:tIn0k_lazIdeSRC__tControls_fuckUpNODE_TYPE):tIn0k_lazIdeSRC__tControls_fuckUpNODE;
    procedure _add_(const node:tIn0k_lazIdeSRC__tControls_fuckUpNODE);
    procedure _cut_(const node:tIn0k_lazIdeSRC__tControls_fuckUpNODE);
  protected
    //function GetNODE(const Control:TControl; const fuckUpTYPE:tIn0k_lazIdeSRC__tControls_fuckUpNODE_TYPE):tIn0k_lazIdeSRC__tControls_fuckUpNODE;
    function _GetNODE_(const Control:TControl; const fuckUpTYPE:tIn0k_lazIdeSRC__tControls_fuckUpNODE_TYPE):tIn0k_lazIdeSRC__tControls_fuckUpNODE;
  public
    constructor Create;
    destructor DESTROY; override;
  end;

 tIn0k_lazIdeSRC__tControls_fuckUpLAIR=class(tIn0k_lazIdeSRC__tControls_fuckUpLAIR_CORE)
  public
    function GetNODE(const Control:TControl; const fuckUpTYPE:tIn0k_lazIdeSRC__tControls_fuckUpNODE_TYPE):tIn0k_lazIdeSRC__tControls_fuckUpNODE;
  end;



implementation
{%region --- then KILLER ------------------------------------------------}

type
_tKILLER_=class(TThread)
  protected
   _node_:tIn0k_lazIdeSRC__tControls_fuckUpNODE;
  protected
    procedure Execute; override;
  public
    constructor Create(const node:tIn0k_lazIdeSRC__tControls_fuckUpNODE);
  end;

constructor _tKILLER_.Create(const node:tIn0k_lazIdeSRC__tControls_fuckUpNODE);
begin
    inherited Create(FALSE);
   _node_:=node;
    FreeOnTerminate:=TRUE;
end;

//------------------------------------------------------------------------------

procedure _tKILLER_.Execute;
begin
    // вырезаем из очереди
   _node_._ownr_._dfdr_.Acquire;
   _node_._ownr_._cut_(_node_);
   _node_._ownr_._dfdr_.Release;
    // УБИВАЕМ
   _node_.FREE;
end;

{%endregion}
//==============================================================================

constructor tIn0k_lazIdeSRC__tControls_fuckUpNODE.Create(const Owner:tIn0k_lazIdeSRC__tControls_fuckUpLAIR_CORE);
begin
    inherited Create;
   _ownr_:=Owner;
   _next_:=nil;
end;

//------------------------------------------------------------------------------

procedure tIn0k_lazIdeSRC__tControls_fuckUpNODE._MY_WindowProc_(var TheMessage:TLMessage);
begin
    if Assigned(_ctrl_) then begin //< мы с кем-то работаем?
        if (TheMessage.msg=LM_DESTROY) then begin //< УДАЛЯЕТСЯ
            {$ifDEF _debugLOG_}
            DEBUG(_cTXT_msgTYPE_,'LM_DESTROY ---->>>');
            {$endIf}
           _ctrl_reStore_WindowProc_(_ctrl_,@_MY_WindowProc_);
           _ctrl_.WindowProc(TheMessage);
           _ctrl_:=nil;
            {$ifDEF _debugLOG_}
            DEBUG(_cTXT_msgTYPE_,'LM_DESTROY ----<<<');
            {$endIf}
           _tKILLER_.Create(self);
        end
        else begin
            // выполняем событие
            fuckUP__wndProc_BEFO     (TheMessage);
           _ctrl_original_WindowProc_(TheMessage);
            fuckUP__wndProc_AFTE     (TheMessage);
        end;
    end
    {$ifDEF _debugLOG_}
    else begin // вот тут по идее МЕГАфайл наметился
        DEBUG(_cTXT_msgTYPE_,'!!! WRONG_00 !!! MegaFAIL !!!!!!!!!!!!!!!!!');
    end;
    {$endIf}
end;

function tIn0k_lazIdeSRC__tControls_fuckUpNODE._fucUpControl_(const cntrl:TControl):boolean;
begin
    result:=_ctrl_rePlace_WindowProc_(cntrl,@_MY_WindowProc_);
    if result then _ctrl_:=cntrl;
end;

//==============================================================================

constructor tIn0k_lazIdeSRC__tControls_fuckUpLAIR_CORE.Create;
begin
   _dfdr_:=TCriticalSection.Create;
   _frst_:=NIL;
end;

destructor tIn0k_lazIdeSRC__tControls_fuckUpLAIR_CORE.DESTROY;
begin
    {$ifOpt D+}
    Assert(not Assigned(_frst_),LineEnding+self.ClassName+LineEnding+'MEGA FAIL! list fuckUped controls NOT clean!'+LineEnding);
    {$endif}
   _dfdr_.Free;
    inherited;
end;

//------------------------------------------------------------------------------

function tIn0k_lazIdeSRC__tControls_fuckUpLAIR_CORE._fnd_(const Control:TControl; const fuckUpTYPE:tIn0k_lazIdeSRC__tControls_fuckUpNODE_TYPE):tIn0k_lazIdeSRC__tControls_fuckUpNODE;
begin {todo: может проверок натыкать?}
    result:=_frst_;
    while Assigned(result) do begin
        if (result._ctrl_=Control)and(result is fuckUpTYPE) then BREAK;
        result:=result._next_;
    end;
end;

procedure tIn0k_lazIdeSRC__tControls_fuckUpLAIR_CORE._add_(const node:tIn0k_lazIdeSRC__tControls_fuckUpNODE);
begin {todo: может проверок натыкать?}
    node._next_:=_frst_;
   _frst_:=node;
end;

procedure tIn0k_lazIdeSRC__tControls_fuckUpLAIR_CORE._cut_(const node:tIn0k_lazIdeSRC__tControls_fuckUpNODE);
var tmp:tIn0k_lazIdeSRC__tControls_fuckUpNODE;
begin {todo: может проверок натыкать?}
    if node=_frst_ then begin
       _frst_:=node._next_;
    end
    else begin
        tmp:=_frst_;
        while tmp._next_<>node do tmp:=tmp._next_;
        tmp._next_:=node._next_;
    end;
end;

//------------------------------------------------------------------------------

function tIn0k_lazIdeSRC__tControls_fuckUpLAIR_CORE._GetNODE_(const Control:TControl; const fuckUpTYPE:tIn0k_lazIdeSRC__tControls_fuckUpNODE_TYPE):tIn0k_lazIdeSRC__tControls_fuckUpNODE;
begin
   _dfdr_.Acquire;
    result:=_fnd_(Control,fuckUpTYPE);
    if not Assigned(result) then begin
        result:=fuckUpTYPE.Create(Self);
        result._fucUpControl_(Control);
       _add_(result);
    end;
   _dfdr_.Release;
end;

//==============================================================================

function tIn0k_lazIdeSRC__tControls_fuckUpLAIR.GetNODE(const Control:TControl; const fuckUpTYPE:tIn0k_lazIdeSRC__tControls_fuckUpNODE_TYPE):tIn0k_lazIdeSRC__tControls_fuckUpNODE;
begin
    result:=_GetNODE_(Control,fuckUpTYPE);
end;

end.

