unit in0k_lazarusIdeSRC__fuckUp_onActivate;

{$mode objfpc}{$H+}

interface

{$include in0k_LazarusIdeSRC__Settings.inc}

uses {$ifDef in0k_LazarusIdeEXT__DEBUG}in0k_lazarusIdeSRC__wndDEBUG,{$endIf}
  in0k_lazarusIdeSRC__tControls_fuckUpWndProc,
  LMessages,
  Classes,
  Controls;

type

 tIn0k_lazarusIdeSRC__fuckUp_onActivate=class(tIn0k_lazIdeSRC__tControls_fuckUpLAIR_CORE)
  protected
   _m_onActivate_:TNotifyEvent;
   _m_onDeActvte_:TNotifyEvent;
  public
    constructor Create;
    destructor DESTROY; override;
  public
    procedure Appaly4Control(const Control:TControl);
  public
    property onActivate:TNotifyEvent read _m_onActivate_ write _m_onActivate_;
    property onDeActvte:TNotifyEvent read _m_onDeActvte_ write _m_onDeActvte_;
  end;

implementation
//------------------------------------------------------------------------------
{%region --- возня с ДЕБАГОМ -------------------------------------- /fold}
{$if declared(in0k_lazarusIdeSRC_DEBUG)}
    // `in0k_lazarusIdeSRC_DEBUG` - это функция ИНДИКАТОР что используется
    //                              моя "система"
    {$define _debugLOG_} //< и типа да ... можно делать ДЕБАГ отметки
{$endIf}
{%endregion}
//------------------------------------------------------------------------------
{%region --- _fuckUp_onActivate_NODE_ ----------------------------- /fold}

type
_tfuckUp_onActivate_NODE_=class(tIn0k_lazIdeSRC__tControls_fuckUpNODE)
  protected
    procedure fuckUP__wndProc_AFTE(const {%H-}TheMessage:TLMessage); override;
  end;

procedure _tfuckUp_onActivate_NODE_.fuckUP__wndProc_AFTE(const {%H-}TheMessage:TLMessage);
begin
    if Assigned(_ownr_) and (TheMessage.msg=LM_ACTIVATE) then begin
        if ((TheMessage.wParam=WA_ACTIVE)or(TheMessage.wParam=WA_CLICKACTIVE))
        then begin //< АКТИВИРОВАЛОСЬ
            if Assigned(tIn0k_lazarusIdeSRC__fuckUp_onActivate(_ownr_)._m_onActivate_)
            then tIn0k_lazarusIdeSRC__fuckUp_onActivate(_ownr_)._m_onActivate_(_ctrl_);
        end
        else begin //< ДезАктивировалось
            if Assigned(tIn0k_lazarusIdeSRC__fuckUp_onActivate(_ownr_)._m_onDeActvte_)
            then tIn0k_lazarusIdeSRC__fuckUp_onActivate(_ownr_)._m_onDeActvte_(_ctrl_);
        end;
    end;
end;

{%endregion}
//------------------------------------------------------------------------------

constructor tIn0k_lazarusIdeSRC__fuckUp_onActivate.Create;
begin
    inherited;
   _m_onActivate_:=NIL;
   _m_onDeActvte_:=NIL;
end;

destructor tIn0k_lazarusIdeSRC__fuckUp_onActivate.DESTROY;
begin
    inherited;
end;

//------------------------------------------------------------------------------

procedure tIn0k_lazarusIdeSRC__fuckUp_onActivate.Appaly4Control(const Control:TControl);
begin
   _GetNODE_(Control,_tfuckUp_onActivate_NODE_);
end;

end.

