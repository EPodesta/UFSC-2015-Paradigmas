-- Autores: Pedro van Rooij Costa
-- Nelson Mariano Leite Neto
-- Bruno Freitas
-- ============== PARTE I ================
-- soma impares				OK
-- soma pares				OK
-- soma quadrados dos inteiros		OK	
-- soma quadrados dos pares		OK


module Soma (somaInt, totalInt, somaImp, totalImp, somaPar, totalPar, somaQuadradoInt, totalQuadradoInt, somaQuadradoImp) where

somaInt n = map (\x->(x*(x+1)/2))[1..n]
totalInt n = last( somaInt n)

somaImp n = map(\x->(x*(1+ (x*2-1))/2))[1..n]
totalImp n = last (somaImp n)

somaPar n = map(\x->(x*(2 + 2*x)/2))[1..n]
totalPar n = last(somaPar n)

somaQuadradoInt n = map(\x->((x*(1+ x)*(2*x+1))/6))[1..n]
totalQuadradoInt n = last(somaQuadradoInt n)

somaQuadradoImp n = map(\x->((x*(2*x-1)*(2*x+1))/3))[1..n]
totalQuadradoImp n = last(somaQuadradoImp n)

