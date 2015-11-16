e = 1 + sum([1 / product[1..x] | x <- take 1000 [1..]])
gamma n = sqrt(2*pi / n) * (1/e * (n + (1/(12*n - 1/(10*n))))) ** n

sumPA n r a1 = (n*((2*a1) + (n-1)*r))/2
produtoPA n a1 r = (r**n)*((gamma((a1/r) + n))/gamma(a1/r))