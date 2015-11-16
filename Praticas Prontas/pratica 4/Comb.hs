-- GRUPO: 
-- Pedro van Rooij Costa
-- Nelson Mariano Leite Neto
-- Bruno Freitas

module Comb (arSim , arRep ,
	     perSim , perCirc ,
             combSim , combRep ) where
import Fact

-- arranjo simples
arSim m p = fac m / fac (m-p)
-- arranjo c/ repeticao
arRep m p = m ** p

-- permutacao simples
perSim m = fac m
-- permutacao circular
perCirc m = fac (m -1)

-- combinacao simples
combSim m p = fac m / (fac (m-p) * fac p)
-- combinacao c/ repeticao
combRep m p = combSim (m+p -1) p
