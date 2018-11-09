unit in0k_lazarusIdeSRC__fuckUp_onActivate;

{$mode objfpc}{$H+}

interface

uses in0k_lazarusIdeSRC__tControlWndProc_fuckUp,
    LMessages,
    Classes;

type

 tIn0k_lazarusIdeSRC__fuckUp_onActivate=class(tIn0k_lazarusIdeSRC__fuckUp_tControlWndProc)
  protected
   _m_onActivate_:TNotifyEvent;
  protected
    procedure _ctrl__WindowProc_AFTE_(const TheMessage:TLMessage); override;
  public
    constructor Create;
    destructor DESTROY; override;
  public
    property onActivate:TNotifyEvent read _m_onActivate_ write _m_onActivate_;
  end;

implementation

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

procedure tIn0k_lazarusIdeSRC__fuckUp_onActivate._ctrl__WindowProc_AFTE_(const TheMessage:TLMessage);
begin
    if (TheMessage.msg=LM_ACTIVATE) and
      ((TheMessage.wParam=WA_ACTIVE)or(TheMessage.wParam=WA_CLICKACTIVE))
    then begin
        if Assigned(_m_onActivate_) then begin
            _m_onActivate_(_ctrl_);
        end;
    end;
end;

end.

