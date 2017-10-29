unit Form;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Menus,
  ComCtrls, Grids, StdCtrls, Types;

type

  { TDatabase }

  TDatabase = class(TForm)
    Table2Edit: TEdit;
    Table2StringGrid: TStringGrid;
    Table1Button: TButton;
    Table1Edit: TEdit;
    MainMenu: TMainMenu;
    DB: TMenuItem;
    dbCreate: TMenuItem;
    dbOpen: TMenuItem;
    dbSave: TMenuItem;
    dbClose: TMenuItem;
    PageControl: TPageControl;
    Table1StringGrid: TStringGrid;
    Table1TabSheet: TTabSheet;
    Table2TabSheet: TTabSheet;
    Table2Button: TToggleBox;
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  Database: TDatabase;

implementation

{$R *.lfm}

{ TDatabase }

end.

