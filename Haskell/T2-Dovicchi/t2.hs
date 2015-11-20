module Somatorio (serieInteirosImpares, somaInteirosImpares, serieInteirosPares,
                  somaInteirosPares, serieQuadratica, somaQuadratica, serieImparQuadratica,
                  somaImparQuadratica, quaseDois, quaseE) where

serieInteirosImpares n = map (\x -> x*((2*x-1) + 1)/2) [1..n]
somaInteirosImpares n = last(serieInteirosImpares n)

serieInteirosPares n = map (\x -> x*(2*x + 2)/2) [1..n]
somaInteirosPares n = last(serieInteirosPares n)

serieQuadratica n = map (\x -> x*(x+1)*(2*x+1)/6) [1..n]
somaQuadratica n = last(serieQuadratica n)

serieImparQuadratica n = map (\x -> x*(4*x^2-1)/3) [1..n]
somaImparQuadratica n = last(serieImparQuadratica n)

quaseDois n = sum(map (\x -> 2/(x+x^2)) (take n [1..]))
quaseE n = 1 + sum(map (\x -> 1 / product[1..x]) (take n [1..]))