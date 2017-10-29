unit Form;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Menus,
  ComCtrls, Grids, StdCtrls, Types;

type

  { TDatabase }

  TDatabase = class(TForm)
    Help: TMenuItem;
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
    procedure HelpClick(Sender: TObject);
    procedure Table1ButtonClick(Sender: TObject);
    procedure Table1StringGridKeyDown(Sender: TObject; var Key: word;
      Shift: TShiftState);
    procedure Table1StringGridSelectCell(Sender: TObject; aCol, aRow: integer;
      var CanSelect: boolean);
    procedure Table1StringGridSetEditText(Sender: TObject; ACol, ARow: integer;
      const Value: string);
  private
    { private declarations }
    function Find(AName: string): integer;
    procedure InsertRow;
  public
    { public declarations }
  end;

var
  Database: TDatabase;

implementation

{$R *.lfm}

{ TDatabase }

function TDatabase.Find(AName: string): integer;
var
  CurRow: integer;
begin
  Result := 0;
  for CurRow := 1 to Table1StringGrid.RowCount - 1 do
    if Table1StringGrid.Rows[CurRow].Strings[0] = AName then
      Result := CurRow;
end;

procedure TDatabase.InsertRow;
begin
  Table1StringGrid.InsertRowWithValues(Table1StringGrid.RowCount, ['', '0', '0']);
end;

procedure TDatabase.Table1StringGridSetEditText(Sender: TObject;
  ACol, ARow: integer; const Value: string);
begin
  if (Table1StringGrid.Rows[Table1StringGrid.RowCount - 1].Strings[0] <> '') then
    InsertRow;
end;

procedure TDatabase.Table1StringGridSelectCell(Sender: TObject;
  aCol, aRow: integer; var CanSelect: boolean);
begin
  if aRow = Table1StringGrid.RowCount - 1 then
    if (aCol = 1) or (aCol = 2) then
      CanSelect := False;
end;

procedure TDatabase.Table1StringGridKeyDown(Sender: TObject; var Key: word;
  Shift: TShiftState);
begin
  { Если нажата клавиша Delete }
  if (Key = 46) then
  begin
    { Удалить запись }
    Table1StringGrid.DeleteRow(Table1StringGrid.Row);
    { Если удалена единственная запись в таблице, то добавить новую пустую запись }
    if Table1StringGrid.RowCount = 1 then
      InsertRow;
  end;
end;

procedure TDatabase.Table1ButtonClick(Sender: TObject);
var
  FindResult: integer;
begin
  FindResult := Find(Table1Edit.Text);
  if FindResult > 0 then
  begin
    Table1StringGrid.Row := FindResult;
    Table1StringGrid.SetFocus;
  end
  else
    ShowMessage('Не найдено');
end;

procedure TDatabase.HelpClick(Sender: TObject);
begin

end;

end.
