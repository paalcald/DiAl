method algoritmo2 (v: array?<int>, i: int, j: int)
	modifies v
	requires v != null && 0 <= i < v.Length && 0 <= j < v.Length && i == j
	ensures v[j] == 0
{
	v[i] := 0;
}

method convertir(t: int) returns (s: int, m: int, h: int)
	ensures t == 3600 * h + 60 * m + s && 0 <= s < 60 && 0 <= m < 60
{
	h := t / 3600;
	s := t % 3600;
	m := s / 60;
	s := s % 60;
}

method intercambiar (x0: int, y0: int) returns (x: int, y: int)
	ensures x == y0 && y == x0
{
	var z := x0;
	x := y0;
	y := z;
}

method doscuatroa (x0: int) returns (x: int)
	ensures x > 0
{
	x := x0 * x0;
	x := x + 1;
}

