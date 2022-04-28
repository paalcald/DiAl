method multiplicar(x: int, y: int) returns (p: int)
	requires y >= 0
	ensures p == x * y
{
	p := 0;
	var n := y;
	while (n != 0)
		invariant x * y == p + x * n
		decreases n
	{
		p, n := p + x, n - 1;
	}
}

method sum(v: array?<int>) returns (x: int)
	requires v != null
	ensures x == suma_vector(v, 0)
{
	var n := v.Length;
	x := 0;
	while (n != 0)
		invariant 0 <= n <= v.Length && x == suma_vector(v, n)
		decreases n
	{
		x := x + v[n - 1];
		n := n - 1;
	}
}

function suma_vector(V: array<int>, n: int): int
	reads V
	requires 0 <= n <= V.Length
	decreases V.Length - n
{
	if (n == V.Length) then 0
	else V[n] + suma_vector(V, n + 1)
}
