-- GRUPO: 
-- Pedro van Rooij Costa
-- Nelson Mariano Leite Neto
-- Bruno Freitas

module Mixfunc ((+++) ,(***)) where

class Num a => Mf a where
	(+++) :: a -> a -> a
	(***) :: a -> a -> a

	x *** y = x * x * y
instance Mf Double where
	x +++ y = 2* x + y
instance Mf Integer where
	x +++ y = 10* x + y

