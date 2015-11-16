-- GRUPO: 
-- Pedro van Rooij Costa
-- Nelson Mariano Leite Neto
-- Bruno Freitas

module Fact (fac ) where

fac 0 = 1
fac n = n * fac (n -1)
