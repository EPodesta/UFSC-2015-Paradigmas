-- GRUPO: 
-- Pedro van Rooij Costa
-- Nelson Mariano Leite Neto
-- Bruno Freitas

module Hiperbolicas ( Hiperbole (CosenoHiper, 
           	      SenoHiper, TangHiper, CotangHiper),
		      calc, epsilon) where
data Hiperbole = CosenoHiper Float 
		| SenoHiper Float
		| TangHiper Float
		| CotangHiper Float
	   deriving Show

epsilon = 2.718281828

calc :: Hiperbole -> Float
calc ( CosenoHiper x) = (epsilon**(2*x) + 1)/(2*(epsilon**x))
calc ( SenoHiper x ) = (epsilon**(2*x) - 1)/(2*(epsilon**x))
calc ( TangHiper x ) = (calc (SenoHiper x))/(calc (CosenoHiper x))
calc ( CotangHiper x ) = (calc (CosenoHiper x))/(calc (SenoHiper x))

