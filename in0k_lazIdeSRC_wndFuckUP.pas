unit in0k_lazIdeSRC_wndFuckUP;

{$mode objfpc}{$H+}

interface

{$ifDef In0k_lazIdeSRC_wndFuckUP_DebugLOG_mode}
    {$define _debugLOG_}
{$endIf}
{$define _debugLOG_}


uses {$ifDef _debugLOG_}SysUtils,{$endIf}
    Classes, Forms;


type

 tIn0k_lazIdeSRC_wndFuckUP_Node=class
  {%region --- debug Event LOG ------------------------------------ /fold}
  {$ifDef _debugLOG_}
  private
   _onDbgLOG_:TGetStrProc;
    procedure _do_onDbgLOG_(const text:string); inline;
  protected
    procedure  DEBUG       (const text:string); inline;
    procedure  DEBUG(const mTYPE,mTEXT:string); inline;
    function   addr2txt    (const value:pointer):string; inline;
  {$endIf}
  {%endregion}
  strict private
   _frm_:TCustomForm;            //< окно, которое мы обрабатываем
   _frm_onDESTROY_:TNotifyEvent; //< его старое событие, которое мы заменяем
    procedure _do_FuckUP_SET_(const form:TCustomForm; const newOnDESTROY:TNotifyEvent); inline;
    procedure _do_FuckUP_CLR_(const form:TCustomForm; const oldOnDESTROY:TNotifyEvent); inline;
  private
    procedure _FuckUP_SET_(const newOnDESTROY:TNotifyEvent);
    procedure _FuckUP_CLR_;
  public
    constructor Create(const aForm:TCustomForm); virtual;
  protected
    property Form:TCustomForm read _frm_;
  public
    procedure FuckUP_SET; virtual;
    procedure FuckUP_CLR; virtual;
  end;
 tIn0k_lazIdeSRC_wndFuckUP_NodeTYPE=class of tIn0k_lazIdeSRC_wndFuckUP_Node;


 tIn0k_lazIdeSRC_wndFuckUP=class
  {%region --- debug Event LOG ------------------------------------ /fold}
  {$ifDef _debugLOG_}
  private
   _onDbgLOG_:TGetStrProc;
    procedure _do_onDbgLOG_(const text:string); inline;
  protected
    procedure  DEBUG       (const text:string); inline;
    procedure  DEBUG(const mTYPE,mTEXT:string); inline;
    function   addr2txt    (const value:pointer):string; inline;
  public
    property onDebug:TGetStrProc read _onDbgLOG_ write _onDbgLOG_;
  {$endIf}
  {%endregion}

  protected
   _nodes_:TList;
  protected
    procedure _wndFuckUP_onFormDestroy(Sender:TObject);
  protected
    function  _node_CRT_(const Form:TCustomForm; const nodeTYPE:tIn0k_lazIdeSRC_wndFuckUP_NodeTYPE):tIn0k_lazIdeSRC_wndFuckUP_Node;
    procedure _node_DST_(const node:tIn0k_lazIdeSRC_wndFuckUP_Node);
  protected
    function  _nodes_fnd_(const Form:TCustomForm):tIn0k_lazIdeSRC_wndFuckUP_Node;
    function  _nodes_cut_(const Form:TCustomForm):tIn0k_lazIdeSRC_wndFuckUP_Node;
    procedure _nodes_CLR_;
    procedure _nodes_del_(const Form:TCustomForm);
  protected
    function  _nodes_GET_(const Form:TCustomForm; const nodeTYPE:tIn0k_lazIdeSRC_wndFuckUP_NodeTYPE):tIn0k_lazIdeSRC_wndFuckUP_Node;
  public
    constructor Create;
    destructor DESTROY; override;
  end;


implementation

{%region --- debug Event LOG -------------------------------------- /fold}
// для работы необходимо
//  # `DEFINE`, определить глобальный или локальный
//      - глобальный: `In0k_lazIdeSRC_SourceEditor_onActivate_DebugLOG_mode`
//      - локальный : `_debugLOG_`
//  # указать обработчик события `onDebug`
{$ifDef _debugLOG_}

const
  _c_DBG_PleaseReport_=
        LineEnding+
        'EN: Please report this error to the developer.'+LineEnding+
        'RU: Пожалуйста, сообщите об этой ошибке разработчику.'+
        LineEnding;

const
  _c_DBG_addr_='$';
  _c_DBG_f_O_ ='[';
  _c_DBG_f_C_ =']';


function _addr2txt_(const value:pointer):string; inline;
begin
    result:=_c_DBG_addr_+IntToHex({%H-}PtrUint(value),sizeOf(PtrUint)*2);
end;

{$endIf}
{%endRegion}


{$region --- tIn0k_lazIdeSRC_wndFuckUP_Node ----------------------- /fold}

{%region --- debug Event LOG -------------------------------------- /fold}
{$ifDef _debugLOG_}

procedure tIn0k_lazIdeSRC_wndFuckUP_Node._do_onDbgLOG_(const text:string);
begin
    if Assigned(_onDbgLOG_) then _onDbgLOG_(text);
end;

procedure tIn0k_lazIdeSRC_wndFuckUP_Node.DEBUG(const text:string);
begin
   _do_onDbgLOG_(text);
end;

procedure tIn0k_lazIdeSRC_wndFuckUP_Node.DEBUG(const mTYPE,mTEXT:string);
begin
    DEBUG(_c_DBG_f_O_+mTYPE+_c_DBG_f_C_+' '+mTEXT);
end;

function  tIn0k_lazIdeSRC_wndFuckUP_Node.addr2txt(const value:pointer):string;
begin
    result:=_addr2txt_(value);
end;

{$endIf}
{%endRegion}


constructor tIn0k_lazIdeSRC_wndFuckUP_Node.Create(const aForm:TCustomForm);
begin
   _frm_:=aForm;
end;

//------------------------------------------------------------------------------

procedure tIn0k_lazIdeSRC_wndFuckUP_Node._do_FuckUP_SET_(const form:TCustomForm; const newOnDESTROY:TNotifyEvent);
begin
    {$ifDEF _debugLOG_}
    DEBUG('FuckUP_SET','--->>> Sender'+addr2txt(form));
    {$endIf}
    //--- пользователь хочет что-то изменить
    FuckUP_SET;
    //--- теперь наше ОБЯЗАТЕЛЬНОЕ изменение
   _frm_onDESTROY_:=form.OnDestroy;
    form.OnDestroy:=newOnDESTROY;
    {$ifDEF _debugLOG_}
    DEBUG('FuckUP_SET','<<<--- Sender'+addr2txt(form));
    {$endIf}
end;

procedure tIn0k_lazIdeSRC_wndFuckUP_Node._FuckUP_SET_(const newOnDESTROY:TNotifyEvent);
begin
   _do_FuckUP_SET_(_frm_,newOnDESTROY);
end;

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

procedure tIn0k_lazIdeSRC_wndFuckUP_Node._do_FuckUP_CLR_(const form:TCustomForm; const oldOnDESTROY:TNotifyEvent);
begin
    {$ifDEF _debugLOG_}
    DEBUG('FuckUP_CLR','--->>> Sender'+addr2txt(form));
    {$endIf}
    //--- чистим наше ОБЯЗАТЕЛЬНОЕ изменение
    form.OnDestroy:=oldOnDESTROY;
    //--- просим пользорвателя прибрать за собой
    FuckUP_CLR;
    {$ifDEF _debugLOG_}
    DEBUG('FuckUP_CLR','<<<--- Sender'+addr2txt(form));
    {$endIf}
end;

procedure tIn0k_lazIdeSRC_wndFuckUP_Node._FuckUP_CLR_;
begin
   _do_FuckUP_CLR_(_frm_,_frm_onDESTROY_);
end;

//------------------------------------------------------------------------------

procedure tIn0k_lazIdeSRC_wndFuckUP_Node.FuckUP_SET;
begin
    //ShowMessage('FuckUP_SET');
end;

procedure tIn0k_lazIdeSRC_wndFuckUP_Node.FuckUP_CLR;
begin
    //ShowMessage('FuckUP_CLR');
end;

{$endregion}

{$region --- tIn0k_lazIdeSRC_wndFuckUP ----------------------- /fold}

{%region --- debug Event LOG -------------------------------------- /fold}
{$ifDef _debugLOG_}

procedure tIn0k_lazIdeSRC_wndFuckUP._do_onDbgLOG_(const text:string);
begin
    if Assigned(_onDbgLOG_) then _onDbgLOG_(text);
end;

procedure tIn0k_lazIdeSRC_wndFuckUP.DEBUG(const text:string);
begin
   _do_onDbgLOG_(text);
end;

procedure tIn0k_lazIdeSRC_wndFuckUP.DEBUG(const mTYPE,mTEXT:string);
begin
    DEBUG(_c_DBG_f_O_+mTYPE+_c_DBG_f_C_+' '+mTEXT);
end;

function  tIn0k_lazIdeSRC_wndFuckUP.addr2txt(const value:pointer):string;
begin
    result:=_addr2txt_(value);
end;

{$endIf}
{%endRegion}

constructor tIn0k_lazIdeSRC_wndFuckUP.Create;
begin
   _nodes_:=TList.Create;
end;

destructor tIn0k_lazIdeSRC_wndFuckUP.DESTROY;
begin
   _nodes_CLR_;
   _nodes_.FREE;
end;

//------------------------------------------------------------------------------

function tIn0k_lazIdeSRC_wndFuckUP._node_CRT_(const Form:TCustomForm; const nodeTYPE:tIn0k_lazIdeSRC_wndFuckUP_NodeTYPE):tIn0k_lazIdeSRC_wndFuckUP_Node;
begin
    result:=nodeTYPE.Create(Form);
    {$ifDef _debugLOG_}
    result._onDbgLOG_:=onDebug;
    {$endIf}
    result._FuckUP_SET_(@_wndFuckUP_onFormDestroy);
end;

procedure tIn0k_lazIdeSRC_wndFuckUP._node_DST_(const node:tIn0k_lazIdeSRC_wndFuckUP_Node);
begin
    node._FuckUP_CLR_;
    node.FREE;
end;

//------------------------------------------------------------------------------

procedure tIn0k_lazIdeSRC_wndFuckUP._wndFuckUP_onFormDestroy(Sender:TObject);
var tmp:tIn0k_lazIdeSRC_wndFuckUP_Node;
begin
    if Assigned(Sender)and (Sender is TCustomForm) then begin
        tmp:=_nodes_cut_(TCustomForm(Sender));
        if Assigned(tmp) then begin
           _node_DST_(tmp);
            if Assigned(TCustomForm(Sender).OnDestroy) then TCustomForm(Sender).OnDestroy(Sender);
        end;
    end;
end;

//------------------------------------------------------------------------------

function tIn0k_lazIdeSRC_wndFuckUP._nodes_fnd_(const Form:TCustomForm):tIn0k_lazIdeSRC_wndFuckUP_Node;
var i:integer;
  tmp:tIn0k_lazIdeSRC_wndFuckUP_Node;
begin
    result:=nil;
    for i:=0 to _nodes_.Count-1 do begin
        tmp:=tIn0k_lazIdeSRC_wndFuckUP_Node(_nodes_.Items[i]);
        if Assigned(tmp) and (tmp.Form=Form) then begin
            result:=tmp;
            BREAK;
        end;
    end;
end;

function tIn0k_lazIdeSRC_wndFuckUP._nodes_cut_(const Form:TCustomForm):tIn0k_lazIdeSRC_wndFuckUP_Node;
var i:integer;
  tmp:tIn0k_lazIdeSRC_wndFuckUP_Node;
begin
    result:=nil;
    for i:=0 to _nodes_.Count-1 do begin
        tmp:=tIn0k_lazIdeSRC_wndFuckUP_Node(_nodes_.Items[i]);
        if Assigned(tmp) and (tmp.Form=Form) then begin
            result:=tmp;
           _nodes_.Items[i]:=nil;
           _nodes_.Delete(i);
            BREAK;
        end;
    end;
end;

procedure tIn0k_lazIdeSRC_wndFuckUP._nodes_CLR_;
var i:integer;
  tmp:tIn0k_lazIdeSRC_wndFuckUP_Node;
begin
    for i:=0 to _nodes_.Count-1 do begin
        tmp:=tIn0k_lazIdeSRC_wndFuckUP_Node(_nodes_.Items[i]);
        if Assigned(tmp) then begin
            _nodes_.Items[i]:=nil;
            _node_DST_(tmp);
        end;
    end;
   _nodes_.Clear;
end;

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

procedure tIn0k_lazIdeSRC_wndFuckUP._nodes_del_(const Form:TCustomForm);
var tmp:tIn0k_lazIdeSRC_wndFuckUP_Node;
begin
    tmp:=_nodes_cut_(TCustomForm(Form));
    if Assigned(tmp) then _node_DST_(tmp);
end;

function tIn0k_lazIdeSRC_wndFuckUP._nodes_GET_(const Form:TCustomForm; const nodeTYPE:tIn0k_lazIdeSRC_wndFuckUP_NodeTYPE):tIn0k_lazIdeSRC_wndFuckUP_Node;
begin
    result:=_nodes_fnd_(Form);
    if not Assigned(result) then begin
        result:=_node_CRT_(Form,nodeTYPE);
       _nodes_.Add(result);
    end;
end;

{$endregion}

end.

