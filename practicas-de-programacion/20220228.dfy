function suma_cuadrados(n: int) : int
	requires n >= 0
	decreases n
{
	if (n == 0) then 0
	else n * n + suma_cuadrados(n - 1)
}

method ejercicio_1(n: int) returns (s: int)
	requires n >= 1
	ensures s == suma_cuadrados(n)
{
	s := 0;
	var x := n;
	while (x > 0)
		invariant suma_cuadrados(n) == suma_cuadrados(x) + s
		decreases x
	{
		s := s + x * x;
		x := x - 1;
	}
}

method es_capicua(A : array?<int>) returns (b: bool)
	requires A != null
	ensures b == (forall i :: 0 <= i <= A.Length / 2 ==> A[i] == A[A.Length - 1 - i])
{
	var n: int := 0;
	b := true;
	while n < A.Length / 2
		invariant 0 <= n <= A.Length / 2
		invariant b == (forall i :: 0 <= i < n ==> A[i] == A[A.Length - 1 - i])
		decreases A.Length / 2 - n
	{
		b := A[n] == A[A.Length - 1 - n] && b;
		n := n + 1;
	}
}
