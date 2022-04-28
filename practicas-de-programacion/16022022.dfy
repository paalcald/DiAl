method algoritmo(x: int) returns (y: int)
	requires x >= 0
	ensures y > 0
{
	y := x + 1;
}

method algoritmo2(x:int, y: int) returns (z: int)
	requires x >= 2 && 2 * y > 5
	ensures z - 2 > 2
{
	z := 2 * x + y - 1;
}

method algoritmo3 (v: array?<int>, i: int, j: int)
	modifies v
	requires v != null && 0 <= i < v.Length && 0 <= j < v.Length && i == j
	ensures v[j] == 0
{
	v[i] := 0;
}
