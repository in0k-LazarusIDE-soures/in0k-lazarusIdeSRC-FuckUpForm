unit in0k_lazarusIdeSRC__tControlWndProc_fuckUp;

{$mode objfpc}{$H+}

interface

{$include in0k_LazarusIdeSRC__Settings.inc}

uses {$ifDef in0k_lazarusIdeSRC__fuckUp_tControlWndProc__DEBUG}
     in0k_lazarusIdeSRC__wndDEBUG,
     {$endIf}
     LMessages,
     Controls;

type

 tIn0k_lazarusIdeSRC__fuckUp_tControlWndProc=class
  strict private //< подмена аля "СабКлассинг"
   _ctrl_original_WindowProc_:TWndMethod;                //< указатель на ОРИГИНАЛЬНЫЙ метод
    procedure _MY_WindowProc_(var TheMessage:TLMessage); //< МОЯ подстава
  strict private //< подмена аля "СабКлассинг"
   _ctrl_reXXXXX_Window_LOCK_:boolean; //< БЛОКИРОВАКА замены
    procedure _ctrl_rePlace_WindowProc_(const ctrl:TControl; out   original:TWndMethod; const myCustom:TWndMethod); {$ifOpt D-}inline;{$endIf}
    procedure _ctrl_rePlace_WindowProc_(const ctrl:TControl);                                                       {$ifOpt D-}inline;{$endIf}
    procedure _ctrl_reStore_WindowProc_(const ctrl:TControl; const original:TWndMethod);                            {$ifOpt D-}inline;{$endIf}
    procedure _ctrl_reStore_WindowProc_(const ctrl:TControl);                                                       {$ifOpt D-}inline;{$endIf}
  protected
    procedure _ctrl__WindowProc_BEFO_(const {%H-}TheMessage:TLMessage); virtual;
    procedure _ctrl__WindowProc_AFTE_(const {%H-}TheMessage:TLMessage); virtual;
  protected
   _ctrl_:TControl;
    procedure _ctrl_SET_(const Control:TControl);
  public
    constructor Create;
    destructor DESTROY; override;
  public
    property  FuckUP_Control:TControl read _ctrl_ write _ctrl_SET_;
    procedure FuckUP_reSet(const Control:TControl);
    procedure FuckUP_Clear;
  end;


implementation
{%region --- возня с ДЕБАГОМ -------------------------------------- /fold}
{$if declared(in0k_lazarusIdeSRC_DEBUG)}
    // `in0k_lazarusIdeSRC_DEBUG` - это функция ИНДИКАТОР что используется
    //                              моя "система"
    {$define _debugLOG_} //< и типа да ... можно делать ДЕБАГ отметки
{$endIf}
{$ifDEF _debugLOG_}
const
 _cTXT_msgTYPE_  ='FuckUp WndProc:';
 _cTXT_rePlace_  =_cTXT_msgTYPE_+' rePlace';
 _cTXT_reStore_  =_cTXT_msgTYPE_+' reStore';
  //---
 _cTXT_SKIPped_='SKIPped';
 _cTXT_obj_    ='obj';
 _cTXT_arrow_  ='->';
 _cTXT_space_  =' ';
{$endIf}
{%endregion}

constructor tIn0k_lazarusIdeSRC__fuckUp_tControlWndProc.Create;
begin
    inherited;
   _ctrl_:=NIL;
   _ctrl_original_WindowProc_:=nil;
   _ctrl_reXXXXX_Window_LOCK_:=false;
end;

destructor tIn0k_lazarusIdeSRC__fuckUp_tControlWndProc.DESTROY;
begin
   _ctrl_reXXXXX_Window_LOCK_:=false;
   _ctrl_SET_(NIL);
    inherited;
end;

//------------------------------------------------------------------------------

// БЕЗ проверок !!! подмена
procedure tIn0k_lazarusIdeSRC__fuckUp_tControlWndProc._ctrl_rePlace_WindowProc_(const ctrl:TControl; out original:TWndMethod; const myCustom:TWndMethod);
begin {$ifOpt D+}
      Assert(Assigned(ctrl));
      Assert(Assigned(myCustom));
      {$endIf}
      original:=ctrl.WindowProc;
      ctrl.WindowProc:=myCustom;
end;

// Заменяем оригинальную функцию `WindowProc` на собственную реализацию
procedure tIn0k_lazarusIdeSRC__fuckUp_tControlWndProc._ctrl_rePlace_WindowProc_(const ctrl:TControl);
begin
    if _ctrl_reXXXXX_Window_LOCK_ then begin
        {$ifDEF _debugLOG_}
        DEBUG(_cTXT_rePlace_,_cTXT_SKIPped_+'. is LOCK!');
        {$endIf}
        EXIT;
		end;
    //-----
    if Assigned(ctrl) and (ctrl.WindowProc<>@_MY_WindowProc_) then begin
       _ctrl_rePlace_WindowProc_(ctrl,_ctrl_original_WindowProc_,@_MY_WindowProc_);
        {$ifDEF _debugLOG_}
        DEBUG(_cTXT_rePlace_,_cTXT_obj_+addr2txt(ctrl)+_cTXT_space_+mthd2txt(@_ctrl_original_WindowProc_)+_cTXT_arrow_+mthd2txt(@ctrl.WindowProc));
        {$endIf}
    end
    else begin
        {$ifDEF _debugLOG_}
        DEBUG(_cTXT_rePlace_,_cTXT_SKIPped_+_cTXT_space_+_cTXT_obj_+addr2txt(ctrl)+mthd2txt(@ctrl.WindowProc));
        {$endIf}
    end
end;

//------------------------------------------------------------------------------

// БЕЗ проверок !!! восстановление
procedure tIn0k_lazarusIdeSRC__fuckUp_tControlWndProc._ctrl_reStore_WindowProc_(const ctrl:TControl; const original:TWndMethod);
begin {$ifOpt D+}
      Assert(Assigned(ctrl));
      Assert(Assigned(original));
      {$endIf}
      ctrl.WindowProc:=original;
end;

// Восстанавливаем СТАРУЮ-оригинальную функцию `WindowProc`
procedure tIn0k_lazarusIdeSRC__fuckUp_tControlWndProc._ctrl_reStore_WindowProc_(const ctrl:TControl);
begin
    if _ctrl_reXXXXX_Window_LOCK_ then begin
        {$ifDEF _debugLOG_}
        DEBUG(_cTXT_reStore_,_cTXT_SKIPped_+'. is LOCK!');
        {$endIf}
        EXIT;
		end;
    //-----
    if Assigned(ctrl) and (ctrl.WindowProc=@_MY_WindowProc_) then begin
        {$ifDEF _debugLOG_}
        DEBUG(_cTXT_reStore_,_cTXT_obj_+addr2txt(ctrl)+_cTXT_space_+mthd2txt(@ctrl.WindowProc)+_cTXT_arrow_+mthd2txt(@_ctrl_original_WindowProc_));
        {$endIf}
       _ctrl_reStore_WindowProc_(ctrl,_ctrl_original_WindowProc_);
       _ctrl_original_WindowProc_:=NIL;
    end
    else begin
        {$ifDEF _debugLOG_}
        DEBUG(_cTXT_rePlace_,_cTXT_SKIPped_+_cTXT_space_+_cTXT_obj_+addr2txt(ctrl)+mthd2txt(@ctrl.WindowProc));
        {$endIf}
    end;
end;

//------------------------------------------------------------------------------

procedure tIn0k_lazarusIdeSRC__fuckUp_tControlWndProc._MY_WindowProc_(var TheMessage:TLMessage);
begin
    if Assigned(_ctrl_) then begin //< мы с кем-то работаем?
        if (TheMessage.msg=LM_DESTROY) then begin //< УДАЛЯЕТСЯ
            {$ifDEF _debugLOG_}
            DEBUG(_cTXT_msgTYPE_,'LM_DESTROY ---->>>');
            {$endIf}
           _ctrl_reStore_WindowProc_(_ctrl_);
           _ctrl_.WindowProc(TheMessage);
           _ctrl_:=nil;
            {$ifDEF _debugLOG_}
            DEBUG(_cTXT_msgTYPE_,'LM_DESTROY ----<<<');
            {$endIf}
        end
        else begin
            // блокируем СОБСТВЕННЫЙ "subEventing"
           _ctrl_reXXXXX_Window_LOCK_:=TRUE;
            // восстанавливаем СТАРУЮ-ОРИГИНАЛЬНУЮ процедуру
           _ctrl_reStore_WindowProc_(_ctrl_,_ctrl_original_WindowProc_);

           _ctrl__WindowProc_BEFO_(TheMessage);
           _ctrl_.WindowProc      (TheMessage);
           _ctrl__WindowProc_AFTE_(TheMessage);

            // востанавливаем НАШУ подмену
           _ctrl_rePlace_WindowProc_(_ctrl_,_ctrl_original_WindowProc_,@_MY_WindowProc_);
            // разрешаем СОБСТВЕННЫЙ "subEventing"
           _ctrl_reXXXXX_Window_LOCK_:=FALSE;
        end;
    end
    {$ifDEF _debugLOG_}
    else begin // вот тут по идее МЕГАфайл наметился
        DEBUG(_cTXT_msgTYPE_,'!!! WRONG_00 !!! MegaFAIL !!!!!!!!!!!!!!!!!');
    end;
    {$endIf}
end;

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

procedure tIn0k_lazarusIdeSRC__fuckUp_tControlWndProc._ctrl__WindowProc_BEFO_(const TheMessage:TLMessage);
begin

end;

procedure tIn0k_lazarusIdeSRC__fuckUp_tControlWndProc._ctrl__WindowProc_AFTE_(const TheMessage:TLMessage);
begin

end;

//------------------------------------------------------------------------------

procedure tIn0k_lazarusIdeSRC__fuckUp_tControlWndProc.FuckUP_reSet(const Control:TControl);
begin
   _ctrl_SET_(Control);
end;

procedure tIn0k_lazarusIdeSRC__fuckUp_tControlWndProc.FuckUP_Clear;
begin
   _ctrl_SET_(NIL);
end;

//------------------------------------------------------------------------------

procedure tIn0k_lazarusIdeSRC__fuckUp_tControlWndProc._ctrl_SET_(const Control:TControl);
begin
    if _ctrl_<>Control then begin
        if Assigned(_ctrl_) then _ctrl_reStore_WindowProc_(_ctrl_);
       _ctrl_:=Control;
        if Assigned(_ctrl_) then _ctrl_rePlace_WindowProc_(_ctrl_);
    end;
end;

end.

