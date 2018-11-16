unit in0k_lazarusIdeSRC__fuckUp_onActivate;

{$mode objfpc}{$H+}

interface

uses
  in0k_lazarusIdeSRC__tControls_fuckUpWndProc,
  LMessages,
  Classes,
  Controls;

type

 tIn0k_lazarusIdeSRC__fuckUp_onActivate=class(tIn0k_lazIdeSRC__tControls_fuckUpLAIR_CORE)
  protected
   _m_onActivate_:TNotifyEvent;
  public
    constructor Create;
    destructor DESTROY; override;
  public
    procedure Appaly4Control(const Control:TControl);
  public
    property onActivate:TNotifyEvent read _m_onActivate_ write _m_onActivate_;
  end;

implementation

//------------------------------------------------------------------------------
{%region --- _fuckUp_onActivate_NODE_ -----------------------------------}

type
_tfuckUp_onActivate_NODE_=class(tIn0k_lazIdeSRC__tControls_fuckUpNODE)
  protected
    procedure fuckUP__wndProc_AFTE(const {%H-}TheMessage:TLMessage); override;
  end;

procedure _tfuckUp_onActivate_NODE_.fuckUP__wndProc_AFTE(const {%H-}TheMessage:TLMessage);
begin
    if (TheMessage.msg=LM_ACTIVATE) and
      ((TheMessage.wParam=WA_ACTIVE)or(TheMessage.wParam=WA_CLICKACTIVE))
    then begin
        if Assigned(_ownr_) and Assigned(tIn0k_lazarusIdeSRC__fuckUp_onActivate(_ownr_)._m_onActivate_) then begin
            tIn0k_lazarusIdeSRC__fuckUp_onActivate(_ownr_)._m_onActivate_(_ctrl_);
        end;
    end;
end;

{%endregion}
//------------------------------------------------------------------------------

constructor tIn0k_lazarusIdeSRC__fuckUp_onActivate.Create;
begin
    inherited;
   _m_onActivate_:=NIL;
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

