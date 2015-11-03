module Formas (Forma (Esfera, Cilindro, Cone, Tronco, EsferoideOblato,
                      EsferoideProlato),
               Raio, Altura, RaioDaBase, RaioDaSeccao, SemiEixoMaior,
               SemiEixoMenor) where


data Forma = Esfera Raio
           | Cilindro RaioDaBase Altura
           | Cone RaioDaBase Altura
           | Tronco RaioDaBase RaioDaSeccao Altura
           | EsferoideOblato SemiEixoMaior SemiEixoMenor
           | EsferoideProlato SemiEixoMaior SemiEixoMenor
     deriving Show

type Raio = Float
type Altura = Float
type RaioDaBase = Float
type RaioDaSeccao = Float
type SemiEixoMaior = Float
type SemiEixoMenor = Float

excentricidade::SemiEixoMaior -> SemiEixoMenor -> Float
excentricidade a b = (sqrt(a^2 - b^2))/a

area::Forma -> Float
area (Esfera r) = 4*pi*r^2
area (Cilindro r h) = 2*pi*r*(r+h)
area (Cone r h) = pi*r*(sqrt(r^2 + h^2) + r)
area (Tronco r1 r2 h) = pi*(r1^2 + r2^2 + (r1+r2)*sqrt(h^2 + (r1 - r2)^2))
area (EsferoideOblato a b) = 2*pi*a^2 + ((b^2)/(excentricidade a b))*log((1 + excentricidade a b)/
	                                                                    (1 - excentricidade a b))
area (EsferoideProlato a b) = 2*pi*(b^2 + ((a*b)/(excentricidade a b))*(asin(excentricidade a b)))

volume :: Forma -> Float
volume (Esfera r) = (4/3)*pi*r^3
volume (Cilindro r h) = pi*h*r^2
volume (Cone r h) = (1/3)*pi*h*r^2
volume (Tronco r1 r2 h) = (1/3)*pi*h*(r1^2 + r2^2 + r1*r2)
volume (EsferoideOblato a b) = (4/3)*pi*b*a^2
volume (EsferoideProlato a b) = (4/3)*pi*a*b^2
