unit in0k_lazIdeSRC_FuckUpForm;

interface

{$i in0k_lazExt_SETTINGs.inc} //< настройки компанента-Расширения.
//< Можно смело убирать, так как будеть работать только в моей специальной
//< "системе имен и папок" `in0k_LazExt_..`.

uses {$ifDef in0k_lazIdeSRC_FuckUpForm_DebugLOG_mode}in0k_lazExt_DEBUG,{$endIf}
     Classes, Forms;

type

  // основатель: подМена событий некой формы (сабЕвентинг - аля сабКлассинг)
 tIn0k_lazIdeSRC_FuckUpForm=class
  private
   _frm_:TCustomForm;                     //< форма, который мы обрабатываем
   _frm_onDESTROY_original_:TNotifyEvent; //< её старое событие, которое мы ОБЯЗАТЕЛЬНО заменяем
    procedure _frmMyCustom_onDESTROY_(Sender:TObject); //< моя подстава
    procedure _do_FuckUP_SET_; inline;    //< подменить событие onDESTROY
    procedure _do_FuckUP_CLR_; inline;    //< восстановить событие onDESTROY
  private
    procedure _FuckUP_SET_(const frm:TCustomForm);
    procedure _FuckUP_CLR_;
  public
    constructor Create;  virtual;
    destructor DESTROY; override;
  protected
    property Form:TCustomForm read _frm_ write _FuckUP_SET_;
  protected
    procedure FuckUP_onSET; virtual; //< дополнительный "сабЕвентинг"
    procedure FuckUP_onCLR; virtual; //< очистка "сабЕвентинга"
  end;
 tIn0k_lazIdeSRC_FuckUpFormTYPE=class of tIn0k_lazIdeSRC_FuckUpForm;


  // список для хранения ФОРМ с подМененными событиями
 tIn0k_lazIdeSRC_FuckUpFrms_LIST=class
  private //< нагиб "нагибателя"
    procedure _fuckUpNode_SET_(const fuckNode:tIn0k_lazIdeSRC_FuckUpForm); inline;
    procedure _fuckUpNode_CLR_(const fuckNode:tIn0k_lazIdeSRC_FuckUpForm); inline;
    procedure _fuckUpNode_onFormDestroy_(Sender:TObject);
  protected //< собственно сам список "нагибателей"
   _nodes_:TList;
    function  _nodes__ADD_(const fuckNode:tIn0k_lazIdeSRC_FuckUpForm):boolean;
    function  _nodes__CUT_(const Form:TCustomForm):tIn0k_lazIdeSRC_FuckUpForm;
    function  _nodes__fnd_(const Form:TCustomForm):tIn0k_lazIdeSRC_FuckUpForm;
    procedure _nodes__CLR_;
  protected
    procedure  fuckUpForms_del(const Form:TCustomForm);
    function   fuckUpForms_GET(const Form:TCustomForm; const nodeTYPE:tIn0k_lazIdeSRC_FuckUpFormTYPE):tIn0k_lazIdeSRC_FuckUpForm;
  public
    constructor Create;
    destructor DESTROY; override;
  end;

implementation

{%region --- возня с ДЕБАГОМ -------------------------------------- /fold}
{$if declared(in0k_lazIdeSRC_FuckUpForm_DebugLOG_mode) AND declared(in0k_lazIde_DEBUG)}
    {$define _debugLOG_}
{$else}
    {$undef _debugLOG_}
{$endIf}
{%endregion}

{$region --- tIn0k_lazIdeSRC_FuckUpForm --------------------------- /fold}

constructor tIn0k_lazIdeSRC_FuckUpForm.Create;
begin
   _frm_:=nil;
end;

destructor tIn0k_lazIdeSRC_FuckUpForm.DESTROY;
begin
   _FuckUP_CLR_;
end;

//------------------------------------------------------------------------------

procedure tIn0k_lazIdeSRC_FuckUpForm._frmMyCustom_onDESTROY_(Sender: TObject);
begin // агась ... подконтрольная форма уничтожается, нам необходимо срочно отписываться
    // восстановили СТАРОЕ состояние событий формы
   _do_FuckUP_CLR_;
    // вызываем "родное" событие
    if Assigned(_frm_.OnDestroy) then _frm_.OnDestroy(Sender);
    //---
   _frm_:=nil;
end;

//------------------------------------------------------------------------------

procedure tIn0k_lazIdeSRC_FuckUpForm._do_FuckUP_SET_;
begin
    {$ifDEF _debugLOG_}
    DEBUG('FuckUP_SET','--->>> Sender'+addr2txt(form));
    {$endIf}
    //---
    if Assigned(_frm_)and(_frm_.OnDestroy<>@_frmMyCustom_onDESTROY_) then begin
        //--- нагибание от пользователя
        FuckUP_onSET;
        //--- теперь наше ОБЯЗАТЕЛЬНОЕ изменение
       _frm_onDESTROY_original_:=form.OnDestroy;
        form.OnDestroy:=@_frmMyCustom_onDESTROY_;
    end;
    //---
    {$ifDEF _debugLOG_}
    DEBUG('FuckUP_SET','<<<--- Sender'+addr2txt(form));
    {$endIf}
end;

procedure tIn0k_lazIdeSRC_FuckUpForm._do_FuckUP_CLR_;
begin
    {$ifDEF _debugLOG_}
    DEBUG('FuckUP_CLR','--->>> Sender'+addr2txt(form));
    {$endIf}
    //---
    if Assigned(_frm_)and(_frm_.OnDestroy=@_frmMyCustom_onDESTROY_) then begin
        //--- чистим наше ОБЯЗАТЕЛЬНОЕ изменение
       _frm_.OnDestroy:=_frm_onDESTROY_original_;
        //--- просим пользорвателя прибрать за собой
        FuckUP_onCLR;
    end;
    //---
    {$ifDEF _debugLOG_}
    DEBUG('FuckUP_CLR','<<<--- Sender'+addr2txt(form));
    {$endIf}
end;

//------------------------------------------------------------------------------

procedure tIn0k_lazIdeSRC_FuckUpForm._FuckUP_SET_(const frm:TCustomForm);
begin
    if Assigned(_frm_) then _do_FuckUP_CLR_;
   _frm_:=frm;
    if Assigned(_frm_) then _do_FuckUP_SET_;
end;

procedure tIn0k_lazIdeSRC_FuckUpForm._FuckUP_CLR_;
begin
   _do_FuckUP_CLR_;
   _frm_:=nil;
end;

//------------------------------------------------------------------------------

// Происходит НАГИБ формы.
procedure tIn0k_lazIdeSRC_FuckUpForm.FuckUP_onSET;
begin
    // тут можно поучаствовать в этом безобразии
    // ShowMessage('FuckUP_SET');
end;

// Форму разгибают в начально состояние.
procedure tIn0k_lazIdeSRC_FuckUpForm.FuckUP_onCLR;
begin
    // почистить следы безобразиЯ оставленные в `FuckUP_onSET`
    // ShowMessage('FuckUP_CLR');
end;

{$endregion}

{$region --- tIn0k_lazIdeSRC_FuckUpFrms_LIST ---------------------- /fold}

constructor tIn0k_lazIdeSRC_FuckUpFrms_LIST.Create;
begin
   _nodes_:=TList.Create;
end;

destructor tIn0k_lazIdeSRC_FuckUpFrms_LIST.DESTROY;
begin
   _nodes__CLR_;
   _nodes_.FREE;
end;

//------------------------------------------------------------------------------

procedure tIn0k_lazIdeSRC_FuckUpFrms_LIST._fuckUpNode_onFormDestroy_(Sender:TObject);
var tmp:tIn0k_lazIdeSRC_FuckUpForm;
begin
    if Assigned(Sender)and (Sender is TCustomForm) then begin
        tmp:=_nodes__CUT_(TCustomForm(Sender)); // вырезали из списка
        if Assigned(tmp) then begin             // теперь аккуратно приканчиваем
            tmp._frmMyCustom_onDESTROY_(Sender);
            tmp.FREE;
        end;
    end;
end;

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

// нагибаем "нагибателя"
procedure tIn0k_lazIdeSRC_FuckUpFrms_LIST._fuckUpNode_SET_(const fuckNode:tIn0k_lazIdeSRC_FuckUpForm);
begin
    if Assigned(fuckNode) and Assigned(fuckNode._frm_) then begin
        fuckNode._frm_.OnDestroy:=@_fuckUpNode_onFormDestroy_;
    end;
end;

// разгибаем "нагибателя"
procedure tIn0k_lazIdeSRC_FuckUpFrms_LIST._fuckUpNode_CLR_(const fuckNode:tIn0k_lazIdeSRC_FuckUpForm);
begin
    if Assigned(fuckNode) and Assigned(fuckNode._frm_) then begin
        fuckNode._frm_.OnDestroy:=@(fuckNode._frmMyCustom_onDESTROY_);
    end;
end;

//------------------------------------------------------------------------------

function tIn0k_lazIdeSRC_FuckUpFrms_LIST._nodes__ADD_(const fuckNode:tIn0k_lazIdeSRC_FuckUpForm):boolean;
begin
    result:=not Assigned(_nodes__fnd_(fuckNode._frm_));
    if result then begin
       _nodes_.Add(fuckNode);
       _fuckUpNode_SET_(fuckNode);
    end;
end;

// вырезать узел из списка
function tIn0k_lazIdeSRC_FuckUpFrms_LIST._nodes__CUT_(const Form:TCustomForm):tIn0k_lazIdeSRC_FuckUpForm;
var i:integer;
  tmp:tIn0k_lazIdeSRC_FuckUpForm;
begin
    result:=nil;
    for i:=0 to _nodes_.Count-1 do begin
        tmp:=tIn0k_lazIdeSRC_FuckUpForm(_nodes_.Items[i]);
        if Assigned(tmp) and (tmp._frm_=Form) then begin
            result:=tmp;
           _nodes_.Items[i]:=nil;
           _nodes_.Delete(i);
            BREAK;
        end;
    end;
    if Assigned(result) then _fuckUpNode_CLR_(result);
end;


// найти узел в списке
function tIn0k_lazIdeSRC_FuckUpFrms_LIST._nodes__fnd_(const Form:TCustomForm):tIn0k_lazIdeSRC_FuckUpForm;
var i:integer;
  tmp:tIn0k_lazIdeSRC_FuckUpForm;
begin
    result:=nil;
    for i:=0 to _nodes_.Count-1 do begin
        tmp:=tIn0k_lazIdeSRC_FuckUpForm(_nodes_.Items[i]);
        if Assigned(tmp) and (tmp._frm_=Form) then begin
            result:=tmp;
            BREAK;
        end;
    end;
end;

// полностью очистить список (перед уничтожением, чистка)
procedure tIn0k_lazIdeSRC_FuckUpFrms_LIST._nodes__CLR_;
var i:integer;
  tmp:tIn0k_lazIdeSRC_FuckUpForm;
begin
    for i:=0 to _nodes_.Count-1 do begin
        tmp:=tIn0k_lazIdeSRC_FuckUpForm(_nodes_.Items[i]);
        if Assigned(tmp) then begin
            _nodes_.Items[i]:=nil;
            _fuckUpNode_CLR_(tmp);
             tmp.FREE;
        end;
    end;
   _nodes_.Clear;
end;

//------------------------------------------------------------------------------

// "РАЗОГНУТЬ" форму и изъять из списка
procedure tIn0k_lazIdeSRC_FuckUpFrms_LIST.fuckUpForms_del(const Form:TCustomForm);
var tmp:tIn0k_lazIdeSRC_FuckUpForm;
begin
    tmp:=_nodes__CUT_(TCustomForm(Form));
    if Assigned(tmp) then tmp.FREE;
end;

// Получить "НАГНуТУЮ" форму (найти среди УЖЕ, или "нагнуть" и добавить)
function tIn0k_lazIdeSRC_FuckUpFrms_LIST.fuckUpForms_GET(const Form:TCustomForm; const nodeTYPE:tIn0k_lazIdeSRC_FuckUpFormTYPE):tIn0k_lazIdeSRC_FuckUpForm;
begin
    result:=_nodes__fnd_(Form);
    if not Assigned(result) then begin
        result:=nodeTYPE.Create;//(Form);
        result._FuckUP_SET_(Form);
        if not _nodes__ADD_(result) then begin
            result.FREE;
            result:=nil;
        end;
    end;
end;

{$endregion}

end.

