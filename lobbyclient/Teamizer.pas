unit Teamizer;

interface

type
  { TTeamizer }
  TByteSet = set of Byte;
  TTeamizer = class(TObject)
  private
    FRatings: array[0..7] of Integer;
    FResult: TByteSet;
    FCount: Integer;
    FMinDiff: Integer;
    FAverage: Integer;
    function IsMinDiff(ByteSet: TByteSet): Boolean;
    procedure MakeCombination(const A, B, VStart, VDepth : LongInt; const VStartSet: TByteSet);
  public
    constructor Create(const ARatings: array of Integer);
    procedure Teamize;
    property Result: TByteSet read FResult;
  end;

implementation

uses
  Math;

{ TTeamizer }

constructor TTeamizer.Create(const ARatings: array of Integer);
var
  i: Integer;
begin
  FResult := [];
  FMinDiff := MaxInt;
  FillChar(FRatings, Length(FRatings), 0);
  FCount := Length(ARatings);
  if FCount > Length(FRatings) then
    FCount := Length(FRatings);
  for i := 0 to FCount - 1 do
    FRatings[i] := ARatings[i];
  FAverage := SumInt(FRatings) div 2;
end;

function TTeamizer.IsMinDiff(ByteSet: TByteSet): Boolean;
var
  Sum, i: Integer;
begin
  Sum := 0;
  for i := 0 to FCount - 1 do
    if i in ByteSet then
      Inc(Sum, FRatings[i]);
  i := Abs(Sum - FAverage);
  Result := (i < FMinDiff);
  if Result then
    FMinDiff := i;
end;

procedure TTeamizer.MakeCombination(const A, B, VStart, VDepth : LongInt; const VStartSet: TByteSet);
var
  i: LongInt;
  ByteSet: TByteSet;
begin
  for i := vStart to A - 1 do
  begin
    ByteSet := VStartSet + [i];
    if (VDepth >= B - 1) then
    begin
      if IsMinDiff(ByteSet) then
        FResult := ByteSet;
    end else
      MakeCombination(A, B, i + 1, VDepth + 1, ByteSet);
   end;
end;

procedure TTeamizer.Teamize;
begin
  { just use brute-force }
  MakeCombination(FCount, FCount div 2, 0, 0, []);
end;

end.
