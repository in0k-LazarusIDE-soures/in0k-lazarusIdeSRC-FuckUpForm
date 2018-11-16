unit in0k_lazarusIdeSRC__tControl_fuckUpWndProc;

{$mode objfpc}{$H+}

interface

uses
  LMessages,
  Controls;

type

 tIn0k_lazIdeSRC__tControl_fuckUpWndProc=class
  strict private //< подмена аля "СабКлассинг"
    procedure _MY_WindowProc_(var TheMessage:TLMessage); //< МОЯ подстава
  protected
   _ctrl_:TControl;                                      //< кого мы НАГНУЛИ
   _ctrl_original_WindowProc_:TWndMethod;                //< ОРИГИНАЛЬНЫЙ метод
  protected //< подмена аля "СабКлассинг"
    procedure _ctrl_rePlace_WindowProc_(const ctrl:TControl; out   original:TWndMethod; const myCustom:TWndMethod); {$ifOpt D-}inline;{$endIf}
    function  _ctrl_rePlace_WindowProc_(const ctrl:TControl; const myCustom:TWndMethod):boolean;                    {$ifOpt D-}inline;{$endIf}
    function  _ctrl_reStore_WindowProc_(const ctrl:TControl; const myCustom:TWndMethod):boolean;                    {$ifOpt D-}inline;{$endIf}
  protected
    function _fuckUP_already_:boolean;
  protected
    procedure fuckUP__wndProc_BEFO(const {%H-}TheMessage:TLMessage); virtual;
    procedure fuckUP__wndProc_AFTE(const {%H-}TheMessage:TLMessage); virtual;
  protected
    procedure fuckUP__onSET; virtual; //< дополнительный "сабЕвентинг"
    procedure fuckUP__onCLR; virtual; //< очистка "сабЕвентинга"
  public
    constructor Create;
    destructor DESTROY;
  end;

implementation

constructor tIn0k_lazIdeSRC__tControl_fuckUpWndProc.Create;
begin
   _ctrl_original_WindowProc_:=nil;
   _ctrl_:=nil;
end;

destructor tIn0k_lazIdeSRC__tControl_fuckUpWndProc.DESTROY;
begin
    inherited;
end;

//------------------------------------------------------------------------------

function tIn0k_lazIdeSRC__tControl_fuckUpWndProc._fuckUP_already_:boolean;
begin // ВСЕ должно быть НЕ NIL
    result:= Assigned(_ctrl_) AND Assigned(_ctrl_original_WindowProc_);
end;

//------------------------------------------------------------------------------

procedure tIn0k_lazIdeSRC__tControl_fuckUpWndProc.fuckUP__wndProc_BEFO(const {%H-}TheMessage:TLMessage);
begin

end;

procedure tIn0k_lazIdeSRC__tControl_fuckUpWndProc.fuckUP__wndProc_AFTE(const {%H-}TheMessage:TLMessage);
begin

end;

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

procedure tIn0k_lazIdeSRC__tControl_fuckUpWndProc._MY_WindowProc_(var TheMessage:TLMessage);
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

//------------------------------------------------------------------------------

procedure tIn0k_lazIdeSRC__tControl_fuckUpWndProc.fuckUP__onSET;
begin

end;

procedure tIn0k_lazIdeSRC__tControl_fuckUpWndProc.fuckUP__onCLR;
begin

end;


//------------------------------------------------------------------------------

// БЕЗ проверок !!! подмена
procedure tIn0k_lazIdeSRC__tControl_fuckUpWndProc._ctrl_rePlace_WindowProc_(const ctrl:TControl; out original:TWndMethod; const myCustom:TWndMethod);
begin {$ifOpt D+}
      Assert(Assigned(ctrl));
      Assert(Assigned(myCustom));
      {$endIf}
      original:=ctrl.WindowProc;
      ctrl.WindowProc:=myCustom;
end;

// Заменяем оригинальную функцию `WindowProc` на собственную реализацию
function tIn0k_lazIdeSRC__tControl_fuckUpWndProc._ctrl_rePlace_WindowProc_(const ctrl:TControl; const myCustom:TWndMethod):boolean;
begin
    result:=FALSE;
    if Assigned(ctrl) and (ctrl.WindowProc<>@_MY_WindowProc_) then begin
        // пользовательское
        fuckUP__onSET;
        // собственное
       _ctrl_rePlace_WindowProc_(ctrl,_ctrl_original_WindowProc_,myCustom);
        {$ifDEF _debugLOG_}
        DEBUG(_cTXT_rePlace_,_cTXT_obj_+addr2txt(ctrl)+_cTXT_space_+mthd2txt(@_ctrl_original_WindowProc_)+_cTXT_arrow_+mthd2txt(@ctrl.WindowProc));
        {$endIf}
        result:=TRUE;
    end
    else begin
        {$ifDEF _debugLOG_}
        DEBUG(_cTXT_rePlace_,_cTXT_SKIPped_+_cTXT_space_+_cTXT_obj_+addr2txt(ctrl)+mthd2txt(@ctrl.WindowProc));
        {$endIf}
    end
end;

//------------------------------------------------------------------------------

// Восстанавливаем СТАРУЮ-оригинальную функцию `WindowProc`
function tIn0k_lazIdeSRC__tControl_fuckUpWndProc._ctrl_reStore_WindowProc_(const ctrl:TControl; const myCustom:TWndMethod):boolean;
begin
    result:=FALSE;
    if Assigned(ctrl) and (ctrl.WindowProc=myCustom) then begin
        result:=TRUE;
        {$ifDEF _debugLOG_}
        DEBUG(_cTXT_reStore_,_cTXT_obj_+addr2txt(ctrl)+_cTXT_space_+mthd2txt(@ctrl.WindowProc)+_cTXT_arrow_+mthd2txt(@_ctrl_original_WindowProc_));
        {$endIf}
        // собственное
        ctrl.WindowProc:=_ctrl_original_WindowProc_;
       _ctrl_original_WindowProc_:=NIL;
        // пользовательское
        fuckUP__onCLR;
    end
    else begin
        {$ifDEF _debugLOG_}
        DEBUG(_cTXT_rePlace_,_cTXT_SKIPped_+_cTXT_space_+_cTXT_obj_+addr2txt(ctrl)+mthd2txt(@ctrl.WindowProc));
        {$endIf}
    end;
end;

end.

