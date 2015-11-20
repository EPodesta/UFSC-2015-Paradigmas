x//y = do
	a <- x
	b <- y
	if b == 0 then Nothing else Just(a/b)
soma x y  = do
	a <- x
	b <- y
	return (a + b)
rst x y = let
	one = return 1	
	rx = return x
	ry = return y
	in one // (soma (one // rx) (one // ry))