unit Form;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Menus,
  ComCtrls, Grids, StdCtrls, Types, FormHelp;

type
  TList1ItemData = record
    IsHD, IsPublic: boolean;
    Name: ShortString;
  end;

  TList2ItemData = record
    Cost: word;
    Name: ShortString;
  end;

  { TDatabase }

  TDatabase = class(TForm)
    Help: TMenuItem;
    SelectDirectoryDialog: TSelectDirectoryDialog;
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
    procedure dbCloseClick(Sender: TObject);
    procedure dbCreateClick(Sender: TObject);
    procedure dbOpenClick(Sender: TObject);
    procedure dbSaveClick(Sender: TObject);
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
    procedure ReadFile1(Dir: string);
    procedure ReadFile2(Dir: string);
    procedure WriteFile1(Dir: string);
    procedure WriteFile2(Dir: string);
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

procedure TDatabase.ReadFile1(Dir: string);
var
  CurRow: integer;
  Table1File: file;
  Table1Rec: TList1ItemData;
begin
  AssignFile(Table1File, Dir + '/Table1');
  {$I-}
  Reset(Table1File, 1);
  {$I+}
  if IOResult = 0 then
  begin
    while not EOF(Table1File) do
    begin
      BlockRead(Table1File, Table1Rec, SizeOf(Table1Rec));
      Table1StringGrid.InsertColRow(False, Table1StringGrid.RowCount);
      Table1StringGrid.Rows[Table1StringGrid.RowCount - 1].Strings[0] := Table1Rec.Name;
      if Table1Rec.IsHD = False then
        Table1StringGrid.Rows[Table1StringGrid.RowCount - 1].Strings[1] := '0'
      else
        Table1StringGrid.Rows[Table1StringGrid.RowCount - 1].Strings[1] := '1';
      if Table1Rec.IsPublic = False then
        Table1StringGrid.Rows[Table1StringGrid.RowCount - 1].Strings[2] := '0'
      else
        Table1StringGrid.Rows[Table1StringGrid.RowCount - 1].Strings[2] := '1';
    end;
    CloseFile(Table1File);
  end
  else
    ShowMessage('Не найден файл таблицы телеканалов. Таблица телеканалов не загружена');
end;

procedure TDatabase.ReadFile2(Dir: string);
var
  CurRow: integer;
  Table2File: file;
  Table2Rec: TList2ItemData;
begin
  AssignFile(Table2File, Dir + '/Table1');
  {$I-}
  Reset(Table2File, 1);
  {$I+}
  if IOResult = 0 then
  begin
    while not EOF(Table2File) do
    begin
      BlockRead(Table2File, Table2Rec, SizeOf(Table2Rec));
      Table2StringGrid.InsertRowWithValues(Table2StringGrid.RowCount,
        [Table2Rec.Name, IntToStr(Table2Rec.Cost)]);
    end;
    CloseFile(Table2File);
  end
  else
    ShowMessage('Не найден файл таблицы тарифных планов. Таблица тарифных планов не загружена');
end;

procedure TDatabase.WriteFile1(Dir: string);
var
  CurRow: integer;
  Table1File: file;
  Table1Rec: TList1ItemData;
begin
  AssignFile(Table1File, Dir + '/Table1');
  {$I-}
  Rewrite(Table1File, 1);
  {$I+}
  if IOResult = 0 then
  begin
    for CurRow := 1 to Table1StringGrid.RowCount - 1 do
    begin
      Table1Rec.Name := Table1StringGrid.Rows[CurRow].Strings[0];
      if Table1StringGrid.Rows[CurRow].Strings[1] = '0' then
        Table1Rec.IsHD := False
      else
        Table1Rec.IsHD := True;
      if Table1StringGrid.Rows[CurRow].Strings[2] = '0' then
        Table1Rec.IsPublic := False
      else
        Table1Rec.IsPublic := True;
      BlockWrite(Table1File, Table1Rec, SizeOf(Table1Rec));
    end;
    CloseFile(Table1File);
  end
  else
    ShowMessage('Ошибка при записи таблицы телеканалов');
end;

procedure TDatabase.WriteFile2(Dir: string);
var
  CurRow: integer;
  Table2File: file;
  Table2Rec: TList2ItemData;
begin
  AssignFile(Table2File, Dir + '/Table2');
  {$I-}
  Rewrite(Table2File, 1);
  {$I+}
  if IOResult = 0 then
  begin
    for CurRow := 1 to Table1StringGrid.RowCount - 1 do
    begin
      Table2Rec.Name := Table2StringGrid.Rows[CurRow].Strings[0];
      Table2Rec.Cost := StrToInt(Table2StringGrid.Rows[CurRow].Strings[1]);
      BlockWrite(Table2File, Table2Rec, SizeOf(Table2Rec));
    end;
    CloseFile(Table2File);
  end
  else
    ShowMessage('Ошибка при записи таблицы тарифных планов');
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
  HelpForm.Show;
end;

procedure TDatabase.dbCreateClick(Sender: TObject);
begin
  Table1StringGrid.Clean;
  Table1StringGrid.RowCount := 1;
  InsertRow;
  PageControl.Show;
end;

procedure TDatabase.dbCloseClick(Sender: TObject);
begin
  Table1StringGrid.Clean;
  Table1StringGrid.RowCount := 1;
  PageControl.Hide;
end;

procedure TDatabase.dbOpenClick(Sender: TObject);
begin
  Table1StringGrid.Clean;
  Table1StringGrid.RowCount := 1;
  SelectDirectoryDialog.Execute;
  ReadFile1(SelectDirectoryDialog.FileName);
  PageControl.Show;
  //ReadFile2(SelectDirectoryDialog.FileName);
end;

procedure TDatabase.dbSaveClick(Sender: TObject);
begin
  SelectDirectoryDialog.Execute;
  WriteFile1(SelectDirectoryDialog.FileName);
  //WriteFile2(SelectDirectoryDialog.FileName);
end;

end.
