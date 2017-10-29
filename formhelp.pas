unit FormHelp;

{$mode objfpc}{$H+}

interface

uses
  Forms, StdCtrls;

type

  { THelpForm }

  THelpForm = class(TForm)
    HelpText: TStaticText;
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  HelpForm: THelpForm;

implementation

{$R *.lfm}

end.

