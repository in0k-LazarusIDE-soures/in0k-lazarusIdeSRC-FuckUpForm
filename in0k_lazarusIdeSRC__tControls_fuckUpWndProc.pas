unit in0k_lazarusIdeSRC__tControls_fuckUpWndProc;

{$mode objfpc}{$H+}

interface

{$include in0k_LazarusIdeSRC__Settings.inc}

uses {$ifDef in0k_LazarusIdeEXT__DEBUG}in0k_lazarusIdeSRC__wndDEBUG,{$endIf}
  in0k_lazarusIdeSRC__tControl_fuckUpWndProc,
  //
  LMessages, sysutils,
  syncobjs,  Dialogs,
  Classes,
  Controls;


type
 tIn0k_lazIdeSRC__tControls_fuckUpLAIR_CORE=class;

 tIn0k_lazIdeSRC__tControls_fuckUpNODE=class(tIn0k_lazIdeSRC__tControl_fuckUpWndProc)
  strict private //< подмена аля "СабКлассинг"
    procedure _MY_WindowProc_(var TheMessage:TLMessage); //< МОЯ подстава
  private
   _lair_:pointer;
   _next_:tIn0k_lazIdeSRC__tControls_fuckUpNODE;
  private
    function _fucUpControl_(const cntrl:TControl):boolean;
  protected
    function _OWNER_:tIn0k_lazIdeSRC__tControls_fuckUpLAIR_CORE; inline;
  public
    constructor Create(const LAIR:pointer);
  end;
 tIn0k_lazIdeSRC__tControls_fuckUpNODE_TYPE=class of tIn0k_lazIdeSRC__tControls_fuckUpNODE;

 tIn0k_lazIdeSRC__tControls_fuckUpLAIR_CORE=class
  strict private
   _LAIR_:pointer;
  protected
    // function  _NODES_present_:boolean;
    function  _NODE_GET_(const Control:TControl; const fuckUpTYPE:tIn0k_lazIdeSRC__tControls_fuckUpNODE_TYPE):tIn0k_lazIdeSRC__tControls_fuckUpNODE;
    //procedure _NODE_DEL_(const node:tIn0k_lazIdeSRC__tControls_fuckUpNODE);

  public
    constructor Create;
    destructor DESTROY; override;
  end;

 tIn0k_lazIdeSRC__tControls_fuckUpLAIR=class(tIn0k_lazIdeSRC__tControls_fuckUpLAIR_CORE)
  public
    function GetNODE(const Control:TControl; const fuckUpTYPE:tIn0k_lazIdeSRC__tControls_fuckUpNODE_TYPE):tIn0k_lazIdeSRC__tControls_fuckUpNODE;
  end;



implementation
{%region --- возня с ДЕБАГОМ -------------------------------------- /fold}
{$if declared(in0k_lazarusIdeSRC_DEBUG)}
    // `in0k_lazarusIdeSRC_DEBUG` - это функция ИНДИКАТОР что используется
    //                              моя "система"
    {$define _debugLOG_} //< и типа да ... можно делать ДЕБАГ отметки
{$endIf}
{%endregion}

{%region --- then LAIR ------------------------------------------------}

type
_pLAIR_=^_rLAIR_;
_rLAIR_=record
   ownr:tIn0k_lazIdeSRC__tControls_fuckUpLAIR_CORE;
   dfdr:TCriticalSection;
   frst:tIn0k_lazIdeSRC__tControls_fuckUpNODE;
  end;

//------------------------------------------------------------------------------

function _LAIR_CRT_(const Owner:tIn0k_lazIdeSRC__tControls_fuckUpLAIR_CORE):_pLAIR_;
begin
   new(result);
   result^.ownr:=Owner;
   result^.frst:=nil;
   result^.dfdr:=TCriticalSection.Create;
end;

procedure _LAIR_DST_(const LAIR:_pLAIR_);
begin
   LAIR^.dfdr.FREE;
   dispose(LAIR);
end;

//------------------------------------------------------------------------------

function _LAIR__inline_frst__GET_(const LAIR:_pLAIR_):tIn0k_lazIdeSRC__tControls_fuckUpNODE; inline;
begin
    result:=LAIR^.frst;
end;

procedure _LAIR__inline_frst__SET_(const LAIR:_pLAIR_; const node:tIn0k_lazIdeSRC__tControls_fuckUpNODE); inline;
begin
    LAIR^.frst :=node;
end;

//------------------------------------------------------------------------------

function _LAIR__inline_fnd_(const LAIR:_pLAIR_; const Control:TControl; const fuckUpTYPE:tIn0k_lazIdeSRC__tControls_fuckUpNODE_TYPE):tIn0k_lazIdeSRC__tControls_fuckUpNODE; inline;
begin {todo: может проверок натыкать?}
    result:=_LAIR__inline_frst__GET_(LAIR);
    while Assigned(result) do begin
        if (result._ctrl_=Control)and(result is fuckUpTYPE) then BREAK;
        result:=result._next_;
    end;
end;

procedure _LAIR__inline_add_(const LAIR:_pLAIR_; const node:tIn0k_lazIdeSRC__tControls_fuckUpNODE); inline;
begin {todo: может проверок натыкать?}
    node._next_:=_LAIR__inline_frst__GET_(LAIR);
   _LAIR__inline_frst__SET_(LAIR,node);
end;

procedure _LAIR__inline_cut_(const LAIR:_pLAIR_; const node:tIn0k_lazIdeSRC__tControls_fuckUpNODE); inline;
var tmp:tIn0k_lazIdeSRC__tControls_fuckUpNODE;
begin {todo: может проверок натыкать?}
    tmp:=_LAIR__inline_frst__GET_(LAIR);
    if node=tmp then begin
       _LAIR__inline_frst__SET_(LAIR,node._next_);
    end
    else begin
        while tmp._next_<>node do tmp:=tmp._next_;
        tmp._next_:=node._next_;
    end;
end;

function _LAIR__inline_cnt_(const LAIR:_pLAIR_):integer; inline;
var tmp:tIn0k_lazIdeSRC__tControls_fuckUpNODE;
begin {todo: может проверок натыкать?}
    result:=0;
    tmp:=_LAIR__inline_frst__GET_(LAIR);
    while Assigned(tmp) do begin
        result:=result+1;
        tmp:=tmp._next_;
    end;
end;

//------------------------------------------------------------------------------

function _LAIR__inline_is_ghost_(const LAIR:_pLAIR_):boolean; inline;
begin
    result:=NOT (Assigned(LAIR^.ownr) or Assigned(LAIR^.frst));
end;

//------------------------------------------------------------------------------

procedure _LAIR_Acquire(const LAIR:_pLAIR_); inline;
begin
    LAIR^.dfdr.Acquire;
end;

procedure _LAIR_Release(const LAIR:_pLAIR_); inline;
begin
    LAIR^.dfdr.Release;
end;

//------------------------------------------------------------------------------

function _LAIR_owner_(const LAIR:_pLAIR_):tIn0k_lazIdeSRC__tControls_fuckUpLAIR_CORE;
begin
   _LAIR_Acquire(LAIR);
    result:=LAIR^.ownr;
   _LAIR_Release(LAIR);
end;

function _LAIR_node_GET_(const LAIR:_pLAIR_; const Control:TControl; const fuckUpTYPE:tIn0k_lazIdeSRC__tControls_fuckUpNODE_TYPE):tIn0k_lazIdeSRC__tControls_fuckUpNODE;
begin
   _LAIR_Acquire(LAIR);
    //----------------
    result:=_LAIR__inline_fnd_(LAIR,Control,fuckUpTYPE);
    if not Assigned(result) then begin
        result:=fuckUpTYPE.Create(LAIR);
        result._fucUpControl_(Control);
       _LAIR__inline_add_(LAIR,result);
        {$ifDef _debugLOG_}
        DEBUG('_LAIR_node_GET_','LAIR_count:'+inttostr(_LAIR__inline_cnt_(LAIR))+' + Control('+Control.ClassName+')'+addr2txt(Control)+' FuckUP was DONE');
        {$endIf}
    end
    else begin
        {$ifDef _debugLOG_}
        DEBUG('_LAIR_node_GET_','LAIR_count:'+inttostr(_LAIR__inline_cnt_(LAIR))+' = Control('+Control.ClassName+')'+addr2txt(Control)+' already FuckUP');
        {$endIf}
    end;
    //----------------
   _LAIR_Release(LAIR);
end;

procedure _LAIR_node_DEL_(const LAIR:_pLAIR_; const node:tIn0k_lazIdeSRC__tControls_fuckUpNODE);
begin
   _LAIR_Acquire(LAIR);
   _LAIR__inline_cut_(LAIR,node);
    {$ifDef _debugLOG_}
    DEBUG('_LAIR_node_DEL_','LAIR_count:'+inttostr(_LAIR__inline_cnt_(LAIR))+' - node'+addr2txt(node)+' DELETEd');
    {$endIf}
   _LAIR_Release(LAIR);
    // УБИВАЕМ
    node.Free;
end;

procedure _LAIR_last_WAY_(const LAIR:_pLAIR_);
var b:boolean;
begin
   _LAIR_Acquire(LAIR);
    b:=_LAIR__inline_is_ghost_(LAIR);
   _LAIR_Release(LAIR);
    //----------------
    if b then begin
       _LAIR_DST_(LAIR);
    end;
end;

procedure _LAIR_2_GHOST_(const LAIR:_pLAIR_);
begin
   _LAIR_Acquire(LAIR);
    LAIR^.ownr:=nil;
   _LAIR_Release(LAIR);
end;

{%endregion}


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
    inherited Create(TRUE);
    FreeOnTerminate:=TRUE;
   _node_:=node;
end;

//------------------------------------------------------------------------------

procedure _tKILLER_.Execute;
var _tmp_lair_:pointer;
begin
    //ShowMessage(self.ClassName+' Execute 0 !!!');
    //ThreadSwitch;
    //sysutils.beep();
    Sleep(10);
    if not Assigned(_node_) then begin
        {$ifDEF _debugLOG_}
        //DEBUG(self.ClassName,'Execute !!! node=NIL');
        {$endIf}
        //Exit;
    end
    else
    if not Assigned(_node_._lair_) then begin
        {$ifDEF _debugLOG_}
        //DEBUG(self.ClassName,'Execute !!! _node_._lair_=NIL');
        {$endIf}
        //Exit;
    end
    else begin
        //---
        //ShowMessage(self.ClassName+' Execute 1 !!!');
       _tmp_lair_:=_node_._lair_;
        //ShowMessage(self.ClassName+' Execute 2 !!!');
       _LAIR_node_DEL_(_tmp_lair_,_node_);
        //ShowMessage(self.ClassName+' Execute 3 !!!');
       _LAIR_last_WAY_(_tmp_lair_);
        ShowMessage(self.ClassName+' Execute 4 !!!');
    end;
end;

{%endregion}
//==============================================================================

constructor tIn0k_lazIdeSRC__tControls_fuckUpNODE.Create(const LAIR:pointer);
begin
    inherited Create;
   _lair_:=LAIR;
   _next_:=nil;
end;

//------------------------------------------------------------------------------

function tIn0k_lazIdeSRC__tControls_fuckUpNODE._OWNER_:tIn0k_lazIdeSRC__tControls_fuckUpLAIR_CORE;
begin
    result:=nil;
    if Assigned(_lair_) then result:=_LAIR_owner_(_lair_);
end;

//------------------------------------------------------------------------------

procedure tIn0k_lazIdeSRC__tControls_fuckUpNODE._MY_WindowProc_(var TheMessage:TLMessage);
begin
    if Assigned(_ctrl_) then begin //< мы с кем-то работаем?
        if (TheMessage.msg=LM_DESTROY) then begin //< УДАЛЯЕТСЯ
            {$ifDEF _debugLOG_}
            DEBUG(self.ClassName,'LM_DESTROY ---->>>');
            {$endIf}
           _ctrl_reStore_WindowProc_(_ctrl_,@_MY_WindowProc_);
           _ctrl_.WindowProc(TheMessage);
           _ctrl_:=nil;
            {$ifDEF _debugLOG_}
            DEBUG(self.ClassName,'LM_DESTROY ----<<<');
            {$endIf}
           _tKILLER_.Create(self).Start;
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
        DEBUG(self.ClassName,'!!! WRONG_00 !!! MegaFAIL !!!!!!!!!!!!!!!!!');
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
    inherited Create;
   _LAIR_:=_LAIR_CRT_(self);
end;

destructor tIn0k_lazIdeSRC__tControls_fuckUpLAIR_CORE.DESTROY;
begin
   _LAIR_2_GHOST_(_LAIR_);
    ShowMessage('uuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuu');
    inherited;
end;

//------------------------------------------------------------------------------

{function tIn0k_lazIdeSRC__tControls_fuckUpLAIR_CORE._cnt_:integer;
var tmp:tIn0k_lazIdeSRC__tControls_fuckUpNODE;
begin {todo: может проверок натыкать?}
    result:=0;
    tmp:=_frst_;
    while Assigned(tmp) do begin
        result:=result+1;
        tmp:=tmp._next_;
    end;
end;}

{function tIn0k_lazIdeSRC__tControls_fuckUpLAIR_CORE._fnd_(const Control:TControl; const fuckUpTYPE:tIn0k_lazIdeSRC__tControls_fuckUpNODE_TYPE):tIn0k_lazIdeSRC__tControls_fuckUpNODE;
begin {todo: может проверок натыкать?}
    result:=_frst_;
    while Assigned(result) do begin
        if (result._ctrl_=Control)and(result is fuckUpTYPE) then BREAK;
        result:=result._next_;
    end;
end;}

{procedure tIn0k_lazIdeSRC__tControls_fuckUpLAIR_CORE._add_(const node:tIn0k_lazIdeSRC__tControls_fuckUpNODE);
begin {todo: может проверок натыкать?}
    node._next_:=_frst_;
   _frst_:=node;
end;}

{procedure tIn0k_lazIdeSRC__tControls_fuckUpLAIR_CORE._cut_(const node:tIn0k_lazIdeSRC__tControls_fuckUpNODE);
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
end;}

//------------------------------------------------------------------------------

function tIn0k_lazIdeSRC__tControls_fuckUpLAIR_CORE._NODE_GET_(const Control:TControl; const fuckUpTYPE:tIn0k_lazIdeSRC__tControls_fuckUpNODE_TYPE):tIn0k_lazIdeSRC__tControls_fuckUpNODE;
begin
   {_dfdr_.Acquire;
    result:=_fnd_(Control,fuckUpTYPE);
    if not Assigned(result) then begin
        result:=fuckUpTYPE.Create(Self);
        result._fucUpControl_(Control);
       _add_(result);
        {$ifDef _debugLOG_}
        DEBUG(self.ClassName ,'_NODE_GET_ (count:'+inttostr(_cnt_)+') : Control('+Control.ClassName+')'+addr2txt(Control)+' FuckUP was DONE');
        {$endIf}
    end
    else begin
        {$ifDef _debugLOG_}
        DEBUG(self.ClassName ,'_NODE_GET_ (count:'+inttostr(_cnt_)+') : Control('+Control.ClassName+')'+addr2txt(Control)+' already FuckUP');
        {$endIf}
    end;
   _dfdr_.Release; }

    result:=_LAIR_node_GET_(_LAIR_,Control,fuckUpTYPE);

end;

{procedure tIn0k_lazIdeSRC__tControls_fuckUpLAIR_CORE._NODE_DEL_(const node:tIn0k_lazIdeSRC__tControls_fuckUpNODE);
begin
    if Assigned(node) then begin
        // вырезаем из очереди
       _dfdr_.Acquire;
       _cut_(node);
        {$ifDef _debugLOG_}
        DEBUG(self.ClassName ,'_NODE_DEL_ (count:'+inttostr(_cnt_)+')');
        {$endIf}
       _dfdr_.Release;
        // УБИВАЕМ
        node.Free;
    end
end; }

{function tIn0k_lazIdeSRC__tControls_fuckUpLAIR_CORE._NODES_present_:boolean;
begin
    _dfdr_.Acquire;
     result:=Assigned(_frst_);
    _dfdr_.Release;
end;}

//==============================================================================

function tIn0k_lazIdeSRC__tControls_fuckUpLAIR.GetNODE(const Control:TControl; const fuckUpTYPE:tIn0k_lazIdeSRC__tControls_fuckUpNODE_TYPE):tIn0k_lazIdeSRC__tControls_fuckUpNODE;
begin
    result:=_NODE_GET_(Control,fuckUpTYPE);
end;

end.

