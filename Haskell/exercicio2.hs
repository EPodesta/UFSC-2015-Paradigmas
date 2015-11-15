questao1 = [1..1000]
questao2 = [1, 4..99]
questao3 n = map( \x y -> y*(2^(x-1))) [1..50] n
fat n = map( \x -> product [1..x] ) [1..] !!n
