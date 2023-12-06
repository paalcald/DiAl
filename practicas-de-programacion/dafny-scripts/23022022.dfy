method ejemplo2(N:int) returns (q: int)
	requires N >= 0
	ensures q == N*N
{
	var i := 0;
	q := 0;
	var p := 1;
	while i < N
		invariant q == i * i && p == 2 * i + 1 && 0 <= i <= N
		decreases N - i
	{
		i := i + 1;
		q := q + p;
		p := p + 2;
	}
}
