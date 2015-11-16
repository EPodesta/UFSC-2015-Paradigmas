-- GRUPO: 
-- Pedro van Rooij Costa
-- Nelson Mariano Leite Neto
-- Bruno Freitas
-- ============== PARTE II ================
-- quase2		OK
-- quaseE		OK


module QuaseNumeros (quaseUm, quaseDois, quaseE) where
import Fact

quaseUm n = sum (map (\x->(1/(x^2+x))) (take n [1..]))

quaseDois n = sum (map(\x->(2/(x^2+x))) (take n [1..]))

quaseE n = 1 + sum(map(\x->(1/fac x)) (take n [1..]))


