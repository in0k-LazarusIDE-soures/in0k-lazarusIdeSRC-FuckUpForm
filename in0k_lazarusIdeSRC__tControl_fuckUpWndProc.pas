unit in0k_lazarusIdeSRC__tControl_fuckUpWndProc;
//
//------------------------------------------------------------------------------
//
//  Мягкий **subClassing** (subEventing).
//
//  В отличии от класического, подменяем не РЕАЛЬНУЮ оконную процедуру,
//  а свойство `tControl.WindowProc`, которое используется при выполнении
//  РЕАЛЬНОЙ `windowproc` (по крайней мере в Винде) и которая ,видимо,
//  как-то эмулируется в др. системах (плата за кросПлатформ наверное).
//
//------------------------------------------------------------------------------
//
//  # Идея (как и при "каноническом subClassing-ге") из трех шагов
//   1. Подменить "метод" `WindowProc` на СОБСТВЕННУЮ реализацию
//      и запомнить адресс "оригинальной".
//   2. В ходе выполнения собсвенной реализации, выполнить "необходимые нам
//      действия", после чего вызвать ОРИГИНАЛЬНЫЙ метод.
//   3. Вернуть все в исходное состояние, когда необходимость в "subClassing"
//      отпадет.
//
//  # Ограничения накладываемые Идеей.
//   -  Подмена "оригинального" метода.
//      Исходя из описание идеи, НЕЛЬЗА дважды выполнять "subClassing"
//      одного и того-же объекта, или двух разных объектов!
//      (На шаге 1. мы ПОТЕРЯЕМ адрес "оригинального" метода, или будем помнить
//      "оригинальный" метод ДРУГОГО объекта)
//   -  Восстановление "оригинального" метода.
//      В случае многократной подмены [оригиниал-1-2-3], КРАЙНЕ важно соблюсти
//      очередность обратного процесса. НЕ верная последовательность, может
//      привести к невразумительным ошибкам, связанными с пропуском и/или
//      запутыванием последовательности вызова подмененных методов.
//
//  # ВЫВОДЫ.
//   -  Объект реализующий "subClassing", должен делать это
//      только ОДИН раз для ОДНОГО объекта.
//   -  ЕДИНСТВЕННОЕ БЕЗОПАСНОЕ место восстановления "оригинального" метода
//      это обработка сообщения `LM_DESTROY` в АВТОМАТИЧЕСКОМ режиме.
//
//  # Реализация.
//
//    === ОДИН объект - ОДИН "subClassing".
//      Реализация `tIn0k_lazIdeSRC__tControl__fuckUpWndProc`.
//
//      --- code ----------------------
//      type
//       tMyFuckUP=class(tIn0k_lazIdeSRC__tControl__fuckUpWndProc) .. end;
//       ..
//      var myFuckUP:tMyFuckUP;
//       ..
//       // инициализация
//      fuckUpER:=tIn0k_lazIdeSRC__tControl__fuckUpWndProc.CREATE;
//      myFuckUP.FuckUP(Control); //< "subClassing" для Control
//       ..
//       // работа программы
//       ..
//       // завершение работы "subClassing"
//      Control.FREE;  //< или убедиться что он уничтожен
//      myFuckUP.FREE;
//       ..
//      ^^^ code ^^^^^^^^^^^^^^^^^^^^^^
//
//    === Многократный "subClassing" множества объектов.
//      Реализуется с помощью ДВУХ сущностей
//      * наследники от `tIn0k_lazIdeSRC__tControls_fuckUpWndProcNODE`
//        описывают САМ "subClassing" как и в случае "ОДНОГО объекта ОДИН раз"
//      * экземпляр `tIn0k_lazIdeSRC__tControls_fuckUpWndProcLAIR`
//        является "СИНХРОНИЗАТОРОМ" действий, для обеспечения условий
//        корректной работы системы описанных в "ВЫВОДАХ".
//
//      --- code ----------------------
//      type
//       tMyFuckUp1=class(tIn0k_lazIdeSRC__tControls_fuckUpWndProcNODE) .. end;
//        ..
//       tMyFuckUpN=class(tIn0k_lazIdeSRC__tControls_fuckUpWndProcNODE) .. end;
//        ..
//      var LAIR:tIn0k_lazIdeSRC__tControls_fuckUpWndProcLAIR;
//        ..
//       // инициализация "системы"
//      LAIR:=tIn0k_lazIdeSRC__tControls_fuckUpWndProcLAIR.CREATE;
//        ..
//       // работа программы c переодическим subClassing
//       // проверяется БЫЛ ли subClassing типа tMyFuckUPj для Controli
//       // если НЕТ, то выполняется
//      LAIR.NODE_GET(Control_i,tMyFuckUP_j); //<
//        ..
//       // завершение работы программы/"системы"
//      LAIR.FREE;
//       ..
//      ^^^ code ^^^^^^^^^^^^^^^^^^^^^^
//
//------------------------------------------------------------------------------

{$mode objfpc}{$H+}

interface

{$include in0k_LazarusIdeSRC__Settings.inc}

uses {$ifDef in0k_LazarusIdeEXT__DEBUG}in0k_lazarusIdeSRC__wndDEBUG,{$endIf}
  LMessages,
  Controls,
  syncobjs,
  Classes;

// #1. Индивидуальная, ОДНОРАЗОВАЯ подмена
{$region --- tIn0k_lazIdeSRC__tControl__fuckUpWndProc ------------- /fold}

type
  // БАЗОВЫЙ класс
 tIn0k_lazIdeSRC__tControl__fuckUpWndProc_CORE=class
 private
   _ctrl_:TControl;                                      //< кого мы НАГНУЛИ
   _ctrl_original_WindowProc_:TWndMethod;                //< ОРИГИНАЛЬНЫЙ метод
    procedure _MY_WindowProc_(var TheMessage:TLMessage); //< МОЯ подстава
  private //< подмена аля "СабКлассинг"
    function  _ctrl_events_rePlace_(const ctrl:TControl; const myCustom:TWndMethod):boolean; {$ifOpt D-}inline;{$endIf}
    function  _ctrl_events_reStore_(const ctrl:TControl; const myCustom:TWndMethod):boolean; {$ifOpt D-}inline;{$endIf}
    function  _ctrl_FuckUP_DO_     (const ctrl:TControl):boolean;                            {$ifOpt D-}inline;{$endIf}
  protected      //
    procedure fuckUP__rePlaceEVNTs(const {%H-}ctrl:TControl); virtual; //< дополнительный "сабЕвентинг"
    procedure fuckUP__reStoreEVNTs(const {%H-}ctrl:TControl); virtual; //< очистка "сабЕвентинга"
  protected
    property  fuckUP__Control:TControl read _ctrl_;
    procedure fuckUP__wndProc_BEFO(const {%H-}TheMessage:TLMessage); virtual;
    procedure fuckUP__wndProc_AFTE(const {%H-}TheMessage:TLMessage); virtual;
  public
    constructor Create;
    destructor DESTROY; override;
  end;

  // класс для ИСПОЛЬЗОВАНИЯ
 tIn0k_lazIdeSRC__tControl__fuckUpWndProc=class(tIn0k_lazIdeSRC__tControl__fuckUpWndProc_CORE)
  public
   function FuckUP(const Control:TControl):boolean;
  end;

{$endregion}

// #2. МНОГО-разовая подмена для НЕСКОЛЬКИХ
{$region --- tIn0k_lazIdeSRC__tControls_fuckUpWndProc ------------- /fold}
type
 tIn0k_lazIdeSRC__tControls_fuckUpWndProcLAIR_CORE=class;

 tIn0k_lazIdeSRC__tControls_fuckUpWndProcNODE=class(tIn0k_lazIdeSRC__tControl__fuckUpWndProc_CORE)
  strict private //< подмена аля "СабКлассинг"
    procedure _MY_WindowProc_(var TheMessage:TLMessage); //< МОЯ подстава
  private
    function  _ctrl_fuckUP_(const ctrl:TControl):boolean; {$ifOpt D-}inline;{$endIf}
  private
   _lair_:pointer;                                      //< объект СИНХРОНИЗАЦИИ
   _next_:tIn0k_lazIdeSRC__tControls_fuckUpWndProcNODE; //< организация ОЧЕРЕДИ
  protected
    function _OWNER_:tIn0k_lazIdeSRC__tControls_fuckUpWndProcLAIR_CORE; {$ifOpt D-}inline;{$endIf}
  public
    constructor Create(const LAIR:pointer);
  end;
 tIn0k_lazIdeSRC__tControls_fuckUpWndProcNodeTYPE=class of tIn0k_lazIdeSRC__tControls_fuckUpWndProcNODE;

  // базовый класс
 tIn0k_lazIdeSRC__tControls_fuckUpWndProcLAIR_CORE=class
  strict private
   _LAIR_:pointer; //< объект СИНХРОНИЗАЦИИ
  protected
    function _NODE_GET_(const Control:TControl; const fuckUPer:tIn0k_lazIdeSRC__tControls_fuckUpWndProcNodeTYPE):tIn0k_lazIdeSRC__tControls_fuckUpWndProcNODE; {$ifOpt D-}inline;{$endIf}
  public
    constructor Create;
    destructor DESTROY; override;
  end;

 tIn0k_lazIdeSRC__tControls_fuckUpWndProcLAIR=class(tIn0k_lazIdeSRC__tControls_fuckUpWndProcLAIR_CORE)
  public
    function NODE_GET(const Control:TControl; const fuckUPer:tIn0k_lazIdeSRC__tControls_fuckUpWndProcNodeTYPE):tIn0k_lazIdeSRC__tControls_fuckUpWndProcNODE;
  end;

{$endregion}

implementation {%region --- возня с ДЕБАГОМ ----------------------- /fold}
{$ifDef in0k_lazarusIdeSRC__tControl_fuckUpWndProc--DEBUG}
  {$if declared(in0k_lazarusIdeSRC_DEBUG)}
    // `in0k_lazarusIdeSRC_DEBUG` - это функция ИНДИКАТОР что используется
    //                              моя "система"
    {$define _debugLOG_} //< и типа да ... можно делать ДЕБАГ отметки
  {$endIf}
{$endIf}
{%endregion}

{$region --- tIn0k_lazIdeSRC__tControl__fuckUpWndProc ------------- /fold}

constructor tIn0k_lazIdeSRC__tControl__fuckUpWndProc_CORE.Create;
begin
   _ctrl_original_WindowProc_:=nil;
   _ctrl_:=nil;
end;

destructor tIn0k_lazIdeSRC__tControl__fuckUpWndProc_CORE.DESTROY;
begin
    {$ifOpt D+} // если что-то пошло НЕ так ... попробуем об этом сообщить
    Assert(Assigned(_ctrl_) or Assigned(_ctrl_original_WindowProc_), LineEnding+self.ClassName+': MEGA FAIL!'+LineEnding+'`Control` is still fuckUp!'+LineEnding);
    {$endif}
    inherited;
end;

//------------------------------------------------------------------------------

// Выполнить ПОДМЕНУ событий
function tIn0k_lazIdeSRC__tControl__fuckUpWndProc_CORE._ctrl_FuckUP_DO_(const ctrl:TControl):boolean;
begin
    result:=_ctrl_events_rePlace_(ctrl,@_MY_WindowProc_);
    if result then begin
        // ЗАКРЕПИЛИ факт подмены
       _ctrl_:=ctrl;
    end
    else begin
        // ОТМЕНИЛИ факт подмены
       _ctrl_original_WindowProc_:=nil;
       _ctrl_:=nil;
    end;
end;

//------------------------------------------------------------------------------

// Пользовательская обработка `WindowProc` ПЕРЕД оригинальной
procedure tIn0k_lazIdeSRC__tControl__fuckUpWndProc_CORE.fuckUP__wndProc_BEFO(const {%H-}TheMessage:TLMessage);
begin
    // для функционирования в ПОТОМКАХ
end;

// Пользовательская обработка `WindowProc` ПОСЛЕ оригинальной
procedure tIn0k_lazIdeSRC__tControl__fuckUpWndProc_CORE.fuckUP__wndProc_AFTE(const {%H-}TheMessage:TLMessage);
begin
    // для функционирования в ПОТОМКАХ
end;

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

// ЕДИНСТВЕННОЕ место КОРРЕКТНО восстановить ОРИГИНАЛЬНУЮ функцию,
// в случае когда объект нагнули НЕСКОЛЬКО раз.
//< УДАЛЯЕТСЯ

procedure tIn0k_lazIdeSRC__tControl__fuckUpWndProc_CORE._MY_WindowProc_(var TheMessage:TLMessage);
begin
    if Assigned(_ctrl_) then begin //< мы с кем-то работаем?
        if (TheMessage.msg=LM_DESTROY) then begin
            // Восстанавливаем ОРИГИНАЛЬНУЮ функуию `WindowProc`,
            // после чего мы ГОТОВЫ к удалению.
            {$ifDEF _debugLOG_}
            DEBUG(self.ClassName+addr2txt(self),'LM_DESTROY ---->>> control '+_ctrl_.ClassName+addr2txt(self));
            {$endIf}
           _ctrl_events_reStore_(_ctrl_,@_MY_WindowProc_);
           _ctrl_.WindowProc(TheMessage);
           _ctrl_:=nil; //< теперь мы ПОЛНОСТЬЮ "отписались" от `_ctrl_`
            {$ifDEF _debugLOG_}
            DEBUG(self.ClassName+addr2txt(self),'LM_DESTROY ----<<< ');
            {$endIf}
        end
        else begin
            // выполняем "ШТАТНУЮ" обработку события событие
            fuckUP__wndProc_BEFO     (TheMessage);
           _ctrl_original_WindowProc_(TheMessage);
            fuckUP__wndProc_AFTE     (TheMessage);
        end;
    end
    {$ifDEF _debugLOG_}
    else begin // вот тут по идее МЕГАфайл наметился
        DEBUG(self.ClassName+addr2txt(self),'!!! WRONG !!! MegaFAIL !!! _ctrl_=NIL !!!');
    end;
    {$endIf}
end;

//------------------------------------------------------------------------------

// Событие: ПОДМЕНА событий
procedure tIn0k_lazIdeSRC__tControl__fuckUpWndProc_CORE.fuckUP__rePlaceEVNTs(const ctrl:TControl);
begin
    // в "потомках" класса тут можно подменить любые другие необходимые события
end;

// Событие: восстановление ПЕРВОНАЧАЛЬНОГО вида
procedure tIn0k_lazIdeSRC__tControl__fuckUpWndProc_CORE.fuckUP__reStoreEVNTs(const ctrl:TControl);
begin
    // в "потомках" класса тут НЕОБХОДИМО восстановить прежние обработчки!
end;

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

// Заменяем оригинальную функцию `WindowProc` на собственную реализацию
function tIn0k_lazIdeSRC__tControl__fuckUpWndProc_CORE._ctrl_events_rePlace_(const ctrl:TControl; const myCustom:TWndMethod):boolean;
begin
    result:=FALSE;
    if Assigned(ctrl) and (ctrl.WindowProc<>myCustom) then begin //< проверим что это ВОЗМОЖНО
        // дадим "развлечся" пользователю
        fuckUP__rePlaceEVNTs(ctrl);
        // наслаждаемся сами
       _ctrl_original_WindowProc_:=ctrl.WindowProc;
        ctrl.WindowProc:=myCustom;
        {$ifDEF _debugLOG_}
        DEBUG(self.ClassName+addr2txt(self),'rePlace_WindowProc: ctrl'+addr2txt(ctrl)+' '+mthd2txt(@_ctrl_original_WindowProc_)+'->'+mthd2txt(@ctrl.WindowProc));
        {$endIf}
        result:=TRUE;
    end
    else begin
        {$ifDEF _debugLOG_}
        if Assigned(ctrl)
        then DEBUG(self.ClassName+addr2txt(self),'rePlace_WindowProc SKIP:'+' ctrl.WindowProc=myCustom. '+'ctrl'+addr2txt(ctrl)+' '+mthd2txt(@ctrl.WindowProc))
        else DEBUG(self.ClassName+addr2txt(self),'rePlace_WindowProc SKIP:'+' ctrl=NIL.');
        {$endIf}
    end
end;

// Восстанавливаем СТАРУЮ-оригинальную функцию `WindowProc`
function tIn0k_lazIdeSRC__tControl__fuckUpWndProc_CORE._ctrl_events_reStore_(const ctrl:TControl; const myCustom:TWndMethod):boolean;
begin
    result:=FALSE;
    if Assigned(ctrl) and (ctrl.WindowProc=myCustom) then begin //< проверим что это ВОЗМОЖНО
        // восстанавливаем собственное изменение
        ctrl.WindowProc:=_ctrl_original_WindowProc_;
       _ctrl_original_WindowProc_:=NIL;
        // дадим "зачистить следы" пользователю
        fuckUP__reStoreEVNTs(ctrl);
        {$ifDEF _debugLOG_}
        DEBUG(self.ClassName+addr2txt(self),'reStore_WindowProc: ctrl'+addr2txt(ctrl)+' '+mthd2txt(@myCustom)+'->'+mthd2txt(@ctrl.WindowProc));
        {$endIf}
        result:=TRUE;
    end
    else begin
        {$ifDEF _debugLOG_}
        if Assigned(ctrl)
        then DEBUG(self.ClassName+addr2txt(self),'reStore_WindowProc SKIP:'+' ctrl.WindowProc<>myCustom. '+'ctrl'+addr2txt(ctrl)+' '+mthd2txt(@ctrl.WindowProc)+'<>'+mthd2txt(@myCustom))
        else DEBUG(self.ClassName+addr2txt(self),'reStore_WindowProc SKIP:'+' ctrl=NIL.');
        {$endIf}
    end;
end;

//==============================================================================
//------------------------------------------------------------------------------

// Выполнить ПОДМЕНУ событий
function tIn0k_lazIdeSRC__tControl__fuckUpWndProc.FuckUP(const Control:TControl):boolean;
begin
    result:=_ctrl_FuckUP_DO_(Control);
end;

{$endregion}

{$region --- tIn0k_lazIdeSRC__tControls_fuckUpWndProc ------------- /fold}

{%region --- LAIR - "СИНХРОНИЗИРУЮЩИЙ" объект --------------------- /fold}

type //< Центральный объект "Синхронизации"
_pLAIR_=^_rLAIR_;
_rLAIR_=record
   dfdr:TCriticalSection;                                  //< защитник очередей
   ownr:tIn0k_lazIdeSRC__tControls_fuckUpWndProcLAIR_CORE; //< владелец, индикатор завершения
   frst:tIn0k_lazIdeSRC__tControls_fuckUpWndProcNODE;      //< начало очереди
  end;

//------------------------------------------------------------------------------

// создать и инициализировать
function _LAIR_CRT_(const Owner:tIn0k_lazIdeSRC__tControls_fuckUpWndProcLAIR_CORE):_pLAIR_;
begin
   new(result);
   result^.ownr:=Owner;
   result^.frst:=nil;
   result^.dfdr:=TCriticalSection.Create;
end;

// УНИЧТОЖИТЬ (очередь УЖЕ должна быть ПУСТА)
procedure _LAIR_DST_(const LAIR:_pLAIR_);
begin
   LAIR^.dfdr.FREE;
   dispose(LAIR);
end;

//------------------------------------------------------------------------------

// ЗАХВАТИТЬ объект для работы с ним
procedure _LAIR_Acquire_(const LAIR:_pLAIR_); inline;
begin
    LAIR^.dfdr.Acquire;
end;

// ОСВОБОДИТЬ объкт
procedure _LAIR_Release_(const LAIR:_pLAIR_); inline;
begin
    LAIR^.dfdr.Release;
end;

{%region --- Acquire .. inline_function ... Release -------------- /fold }

function _lair__inline__frst_GET_(const LAIR:_pLAIR_):tIn0k_lazIdeSRC__tControls_fuckUpWndProcNODE; inline;
begin
    result:=LAIR^.frst;
end;

procedure _lair__inline__frst_SET_(const LAIR:_pLAIR_; const node:tIn0k_lazIdeSRC__tControls_fuckUpWndProcNODE); inline;
begin
    LAIR^.frst :=node;
end;

//------------------------------------------------------------------------------

function _lair__inline_fnd_(const LAIR:_pLAIR_; const Control:TControl; const fuckUPer:tIn0k_lazIdeSRC__tControls_fuckUpWndProcNodeTYPE):tIn0k_lazIdeSRC__tControls_fuckUpWndProcNODE; inline;
begin {todo: может проверок натыкать?}
    result:=_lair__inline__frst_GET_(LAIR);
    while Assigned(result) do begin
        if (result._ctrl_=Control)and(result is fuckUPer) then BREAK;
        result:=result._next_;
    end;
end;

procedure _lair__inline_add_(const LAIR:_pLAIR_; const node:tIn0k_lazIdeSRC__tControls_fuckUpWndProcNODE); inline;
begin {todo: может проверок натыкать?}
    node._next_:=_lair__inline__frst_GET_(LAIR);
   _lair__inline__frst_SET_(LAIR,node);
end;

procedure _lair__inline_cut_(const LAIR:_pLAIR_; const node:tIn0k_lazIdeSRC__tControls_fuckUpWndProcNODE); inline;
var tmp:tIn0k_lazIdeSRC__tControls_fuckUpWndProcNODE;
begin {todo: может проверок натыкать?}
    tmp:=_lair__inline__frst_GET_(LAIR);
    if node=tmp then begin
       _lair__inline__frst_SET_(LAIR,node._next_);
    end
    else begin
        while tmp._next_<>node do tmp:=tmp._next_;
        tmp._next_:=node._next_;
    end;
end;

function _lair__inline_cnt_(const LAIR:_pLAIR_):integer; inline;
var tmp:tIn0k_lazIdeSRC__tControls_fuckUpWndProcNODE;
begin {todo: может проверок натыкать?}
    result:=0;
    tmp:=_lair__inline__frst_GET_(LAIR);
    while Assigned(tmp) do begin
        result:=result+1;
        tmp:=tmp._next_;
    end;
end;

//------------------------------------------------------------------------------

// Объект еще ЖИВ, имеются "живые" объекты связанные с ним
function _lair__inline__still_alive_(const LAIR:_pLAIR_):boolean; inline;
begin // жив пока есть ВЛАДЕЛЕЦ или Берлога НЕ пуста
    result:=Assigned(LAIR^.ownr) or Assigned(LAIR^.frst);
end;

// Объект ПРИЗРАК, к нему больше НИЧЕГО не привязано
function _lair__inline__is_ghost_(const LAIR:_pLAIR_):boolean; inline;
begin
    result:=NOT _LAIR__inline__still_alive_(LAIR);
end;

{%endregion LAIR - "СИНХРОНИЗИРУЮЩИЙ" объект-----------------------------------}

//------------------------------------------------------------------------------

function _LAIR_owner_(const LAIR:_pLAIR_):tIn0k_lazIdeSRC__tControls_fuckUpWndProcLAIR_CORE;
begin
   _LAIR_Acquire_(LAIR);
    result:=LAIR^.ownr;
   _LAIR_Release_(LAIR);
end;

function _LAIR_node_GET_(const LAIR:_pLAIR_; const Control:TControl; const fuckUPer:tIn0k_lazIdeSRC__tControls_fuckUpWndProcNodeTYPE):tIn0k_lazIdeSRC__tControls_fuckUpWndProcNODE;
begin
   _LAIR_Acquire_(LAIR);
    //----------------
    result:=_LAIR__inline_fnd_(LAIR,Control,fuckUPer);
    if not Assigned(result) then begin //< еще НЕ нагибали ... исправляем
        result:=fuckUPer.Create(LAIR);
        if result._ctrl_fuckUP_(Control) then begin  //< НАГНУЛИ `Control`
           _LAIR__inline_add_(LAIR,result); //< зарегистрировали в списке
            {$ifDef _debugLOG_}
            DEBUG('_LAIR_node_GET_','LAIR_count:'+inttostr(_LAIR__inline_cnt_(LAIR))+' + Control('+Control.ClassName+')'+addr2txt(Control)+' FuckUP was DONE');
            {$endIf}
        end
        else begin //< что-то пошло не так
            result.FREE;
            result:=NIL;
        end;
    end
    else begin //< все УЖЕ нагнуто до нас
        {$ifDef _debugLOG_}
        DEBUG('_LAIR_node_GET_','LAIR_count:'+inttostr(_LAIR__inline_cnt_(LAIR))+' = Control('+Control.ClassName+')'+addr2txt(Control)+' already FuckUP');
        {$endIf}
    end;
    //----------------
   _LAIR_Release_(LAIR);
end;

procedure _LAIR_node_DEL_(const LAIR:_pLAIR_; const node:tIn0k_lazIdeSRC__tControls_fuckUpWndProcNODE);
begin
   _LAIR_Acquire_(LAIR);
    //----------------
   _LAIR__inline_cut_(LAIR,node);
    {$ifDef _debugLOG_}
    DEBUG('_LAIR_node_DEL_','LAIR_count:'+inttostr(_LAIR__inline_cnt_(LAIR))+' - node'+addr2txt(node)+' DELETEd');
    {$endIf}
    //----------------
   _LAIR_Release_(LAIR);
    // УБИВАЕМ
    node.Free;
end;

//------------------------------------------------------------------------------

// Отметить, что ВЛАДЕЛЕЦ ПОКИНУЛ нас, мы скоро будем УНИЧТОЖЕНЫ
procedure _LAIR_to_GHOST_(const LAIR:_pLAIR_);
begin
   _LAIR_Acquire_(LAIR);
    LAIR^.ownr:=nil;
   _LAIR_Release_(LAIR);
end;

// Проверить что Объект ГОТОВ к уничтожению и УНИЧТОЖИТЬ
procedure _LAIR_last_WAY_(const LAIR:_pLAIR_);
var b:boolean;
begin
   _LAIR_Acquire_(LAIR);
    //----------------
    b:=_lair__inline__is_ghost_(LAIR);
    //----------------
   _LAIR_Release_(LAIR);
    //----------------
    if b then begin
       _LAIR_DST_(LAIR);
    end;
end;

{%endregion}

{%region --- KILLER ----------------------------------------------- /fold}

type //< Одноразовый поток УБИЙЦА.
     //< Задание: ВЫПИЛИТЬ из очереди и УНИЧТОЖИТЬ узел `_node_`,
     //<          при необходимости ЗАЧИСТИТЬ `_lair_`. САМОУНИЧТОЖИТЬСЯ!
_tKILLER_=class(TThread)
  protected
   _node_:tIn0k_lazIdeSRC__tControls_fuckUpWndProcNODE;
  protected
    procedure Execute; override;
  public
    constructor Create(const node:tIn0k_lazIdeSRC__tControls_fuckUpWndProcNODE);
  end;

//------------------------------------------------------------------------------

constructor _tKILLER_.Create(const node:tIn0k_lazIdeSRC__tControls_fuckUpWndProcNODE);
begin
    inherited Create(TRUE);
    FreeOnTerminate:=TRUE;  //< мания СУИЦИДА
   _node_:=node;            //< объект ЗАДАНИЕ
end;

//------------------------------------------------------------------------------

procedure _tKILLER_.Execute;
var _lair_:pointer;
begin
    // в самом деле "странная" проверка, по идее иначе и БЫТЬ НЕ МОЖЕТ!
    if Assigned(_node_) and Assigned(_node_._lair_) then begin
        _lair_:=_node_._lair_;
         // выпиливаем узел из очереди и УНИЧТОЖАЕМ
        _LAIR_node_DEL_(_lair_,_node_);
         // зачищаем при необходимости (мы ПОСЛЕДНИЕ кто может это сделать)
        _LAIR_last_WAY_(_lair_);
    end
    {$ifDEF _debugLOG_}
    else begin
        DEBUG(self.ClassName+addr2txt(self),'Execute - WRONG !!! `_node_` or `_node_._lair_` is NIL');
    end
    {$endIf};
end;

{%endregion}

//------------------------------------------------------------------------------

{%region --- .._fuckUpWndProcNODE - УЗЕЛ -------------------------- /fold}

constructor tIn0k_lazIdeSRC__tControls_fuckUpWndProcNODE.Create(const LAIR:pointer);
begin
    inherited Create;
   _lair_:=LAIR;
   _next_:=nil;
end;

//------------------------------------------------------------------------------

function tIn0k_lazIdeSRC__tControls_fuckUpWndProcNODE._OWNER_:tIn0k_lazIdeSRC__tControls_fuckUpWndProcLAIR_CORE;
begin
    result:=nil;
    if Assigned(_lair_) then result:=_LAIR_owner_(_lair_);
end;

//------------------------------------------------------------------------------

procedure tIn0k_lazIdeSRC__tControls_fuckUpWndProcNODE._MY_WindowProc_(var TheMessage:TLMessage);
begin
    if Assigned(_ctrl_) then begin //< мы с кем-то работаем?
        if (TheMessage.msg=LM_DESTROY) then begin
            // Восстанавливаем ОРИГИНАЛЬНУЮ функуию `WindowProc`,
            // после чего мы ГОТОВЫ к удалению.
            {$ifDEF _debugLOG_}
            DEBUG(self.ClassName+addr2txt(self),'LM_DESTROY ---->>> control '+_ctrl_.ClassName+addr2txt(self));
            {$endIf}
           _ctrl_events_reStore_(_ctrl_,@_MY_WindowProc_);
           _ctrl_.WindowProc(TheMessage);
           _ctrl_:=nil; //< теперь мы ПОЛНОСТЬЮ "отписались" от `_ctrl_`
            {$ifDEF _debugLOG_}
            DEBUG(self.ClassName+addr2txt(self),'LM_DESTROY ----<<< ');
            {$endIf}
            // ЕДИНСТВЕННОЕ отличие от родителя: отдаем ЗАКАЗ на НАШЕ убийство!
           _tKILLER_.Create(self).Start;
        end
        else begin
            // выполняем "ШТАТНУЮ" обработку события событие
            fuckUP__wndProc_BEFO     (TheMessage);
           _ctrl_original_WindowProc_(TheMessage);
            fuckUP__wndProc_AFTE     (TheMessage);
        end;
    end
    {$ifDEF _debugLOG_}
    else begin // вот тут по идее МЕГАфайл наметился
        DEBUG(self.ClassName+addr2txt(self),'!!! WRONG !!! MegaFAIL !!! _ctrl_=NIL !!!');
    end;
    {$endIf}
end;

function tIn0k_lazIdeSRC__tControls_fuckUpWndProcNODE._ctrl_fuckUP_(const ctrl:TControl):boolean;
begin
    result:=_ctrl_events_rePlace_(ctrl,@_MY_WindowProc_);
    if result then _ctrl_:=ctrl;
end;

{%endregion  .._fuckUpWndProcNODE - УЗЕЛ --------------------------------}

{%region --- .._fuckUpWndProcLAIR - ХРАНИТЕЛЬ --------------------- /fold}

constructor tIn0k_lazIdeSRC__tControls_fuckUpWndProcLAIR_CORE.Create;
begin
    inherited Create;
   _LAIR_:=_LAIR_CRT_(self);
end;

destructor tIn0k_lazIdeSRC__tControls_fuckUpWndProcLAIR_CORE.DESTROY;
begin
   _LAIR_to_GHOST_(_LAIR_); //< "отписываемся" от владения
   _LAIR_last_WAY_(_LAIR_); //<  проводим в последний ПУТЬ
    inherited;
end;

//------------------------------------------------------------------------------

function tIn0k_lazIdeSRC__tControls_fuckUpWndProcLAIR_CORE._NODE_GET_(const Control:TControl; const fuckUPer:tIn0k_lazIdeSRC__tControls_fuckUpWndProcNodeTYPE):tIn0k_lazIdeSRC__tControls_fuckUpWndProcNODE;
begin
    result:=_LAIR_node_GET_(_LAIR_,Control,fuckUPer);
end;

//==============================================================================

function tIn0k_lazIdeSRC__tControls_fuckUpWndProcLAIR.NODE_GET(const Control:TControl; const fuckUPer:tIn0k_lazIdeSRC__tControls_fuckUpWndProcNodeTYPE):tIn0k_lazIdeSRC__tControls_fuckUpWndProcNODE;
begin
    result:=_NODE_GET_(Control,fuckUPer);
end;

{%endregion  .._fuckUpWndProcLAIR - ХРАНИТЕЛЬ ---------------------------}

{$endregion}

end.

