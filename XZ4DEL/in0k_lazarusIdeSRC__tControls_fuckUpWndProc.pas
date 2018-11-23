unit in0k_lazarusIdeSRC__tControls_fuckUpWndProc;

{$mode objfpc}{$H+}

interface

{$include in0k_LazarusIdeSRC__Settings.inc}

uses {$ifDef in0k_LazarusIdeEXT__DEBUG}in0k_lazarusIdeSRC__wndDEBUG,{$endIf}
  in0k_lazarusIdeSRC__tControl_fuckUpWndProc,
  //
  LMessages, //sysutils,
  syncobjs,  //Dialogs,
  Classes,
  Controls;


type
 tIn0k_lazIdeSRC__tControls_fuckUpLAIR_CORE=class;


 tIn0k_lazIdeSRC__tControls_fuckUpLAIR_CORE=class
  strict private
   _LAIR_:pointer;
  protected
    function  _NODE_GET_(const Control:TControl; const fuckUpTYPE:tIn0k_lazIdeSRC__tControls_fuckUpNODE_TYPE):tIn0k_lazIdeSRC__tControls_fuckUpNODE;
  public
    constructor Create;
    destructor DESTROY; override;
  end;

 tIn0k_lazIdeSRC__tControls_fuckUpLAIR=class(tIn0k_lazIdeSRC__tControls_fuckUpLAIR_CORE)
  public
    function NODE_GET(const Control:TControl; const fuckUpTYPE:tIn0k_lazIdeSRC__tControls_fuckUpNODE_TYPE):tIn0k_lazIdeSRC__tControls_fuckUpNODE;
  end;

implementation {%region --- возня с ДЕБАГОМ ----------------------- /fold}
{$ifDef in0k_lazarusIdeSRC__tControls_fuckUpWndProc--DEBUG}
    {$if declared(in0k_lazarusIdeSRC_DEBUG)}
        // `in0k_lazarusIdeSRC_DEBUG` - это функция ИНДИКАТОР что используется
        //                              моя "система"
        {$define _debugLOG_} //< и типа да ... можно делать ДЕБАГ отметки
    {$endIf}
{$endIf}
{%endregion}

//==============================================================================



//==============================================================================


//==============================================================================


//------------------------------------------------------------------------------


//==============================================================================

function tIn0k_lazIdeSRC__tControls_fuckUpLAIR.NODE_GET(const Control:TControl; const fuckUpTYPE:tIn0k_lazIdeSRC__tControls_fuckUpNODE_TYPE):tIn0k_lazIdeSRC__tControls_fuckUpNODE;
begin
    result:=_NODE_GET_(Control,fuckUpTYPE);
end;

end.

