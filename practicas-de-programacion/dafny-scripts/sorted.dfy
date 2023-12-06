predicate sorted (a: array?<int>)
	requires a != null
	reads a
{
	forall i, j :: 0 <= i < j < a.Length ==> a[i] <= a[j]
}

method sort(a: array<int>)
modifies a
ensures sorted(a)
ensures multiset(a[..]) == multiset(old(a[..]))

method Abs(x: int) returns (y: int)
	ensures 0 <= y;
	ensures 0 <= x ==> y == x;
	ensures x < 0 ==> y == -x;
{
	if (x < 0)
	{ y := -x;}
	else
	{y := x;}
}
