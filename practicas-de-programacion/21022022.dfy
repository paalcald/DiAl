method quehace(x0: int, y0 :int) returns (x: int, y: int)
	ensures x == y0 && y == x0
{
	x := x0 - y0;
	y := x + y0;
	x := y - x;
}

datatype relation = Lessthan | Equalto | Morethan

method compare(x:int, y:int) returns (r: relation)
{
	if (x > y) {r := Morethan;}
	if (x == y) {r := Equalto;}
	if (x < y) {r := Lessthan;}
}
method ejercicio_2_5(x: int, y: int ) returns (z: int)
	ensures z > y
{
	var r := compare(x, y);
	match (r)
	{
		case Morethan =>
			z := x;
		case Equalto =>
			z := x + 1;
		case Lessthan =>
			z := y + 2;
	}
}
