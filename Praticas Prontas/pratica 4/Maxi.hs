-- GRUPO: 
-- Pedro van Rooij Costa
-- Nelson Mariano Leite Neto
-- Bruno Freitas

module Maxi (
	maxi ,
	maxiTri ,
	maxiLst
	) where
maxi :: Ord a => a -> a -> a
maxi a b | a >=b = a
	 | otherwise = b
maxiTri :: Ord a => a -> a -> a -> a
maxiTri a b c = maxi a ( maxi b c)

maxiLst :: (Ord a, Num a) => [a] -> a
maxiLst [] = 0
maxiLst (x:xs) = maxi x ( maxiLst xs)
