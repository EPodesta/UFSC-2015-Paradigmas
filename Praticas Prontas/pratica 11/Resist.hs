-- GRUPO: 
-- Pedro van Rooij Costa
-- Nelson Mariano Leite Neto
-- Bruno Freitas
module Resist ( rst ) where
x // y = do
	-- extrai os valores de x e y :
	a <- x
	b <- y
	if b == 0 then Nothing else Just ( a / b )

soma x y = do
	x' <- x
	y' <- y
	return (x' + y')

-- definicao monadica da operacao :
rst x y = let
	one = return 1
	rx = return x
	ry = return y
	in one // (soma (one // rx) (one // ry))

