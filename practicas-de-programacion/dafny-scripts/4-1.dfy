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
