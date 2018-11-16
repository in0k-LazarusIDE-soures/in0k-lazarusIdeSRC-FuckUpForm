unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  in0k_lazarusIdeSRC__tControls_fuckUpWndProc,
  Unit2, Unit3, Unit4, Unit5,
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private

  public
   fuckUpLAIR:tIn0k_lazIdeSRC__tControls_fuckUpLAIR;
  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.FormCreate(Sender: TObject);
begin
    fuckUpLAIR:=tIn0k_lazIdeSRC__tControls_fuckUpLAIR.Create;
end;


procedure TForm1.FormDestroy(Sender: TObject);
begin
    fuckUpLAIR.FREE;
end;

//------------------------------------------------------------------------------

procedure TForm1.Button1Click(Sender: TObject);
begin
    fuckUpLAIR.GetNODE(Form2,tIn0k_lazIdeSRC__tControls_fuckUpNODE);
    fuckUpLAIR.GetNODE(Form3,tIn0k_lazIdeSRC__tControls_fuckUpNODE);
    fuckUpLAIR.GetNODE(Form4,tIn0k_lazIdeSRC__tControls_fuckUpNODE);
    fuckUpLAIR.GetNODE(Form5,tIn0k_lazIdeSRC__tControls_fuckUpNODE);
end;

end.

