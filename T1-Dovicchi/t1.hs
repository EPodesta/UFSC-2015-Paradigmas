module Formas (Forma (Esferoide, Cilindro, Cone, Tronco),
               RaioEq, RaioPolar, Altura, RaioDaBase, RaioDaSeccao) where


data Forma = Esferoide RaioEq RaioPolar
           | Cilindro RaioDaBase Altura
           | Cone RaioDaBase Altura
           | Tronco RaioDaBase RaioDaSeccao Altura
     deriving Show

type RaioEq = Float
type RaioPolar = Float
type RaioDaBase = Float
type RaioDaSeccao = Float
type Altura = Float
excentricidade::RaioEq -> RaioPolar -> Float
excentricidade a b   
               | b < a = sqrt((a^2 - b^2)/(a^2)) -- Esferoide Oblate  (a = b > c)
               | b > a = sqrt((b^2 - a^2)/(b^2)) -- Esferoide Prolate (a = b < c)
               | b == a = 0                      -- Esfera   (a = b = c)


area::Forma -> Float
area (Esferoide a c)
    | c < a = 2*pi*a^2 + ((pi*c^2)/(excentricidade a c))*log((1 + excentricidade a c)/(1 - excentricidade a c))
    | c > a = 2*pi*(a^2 + ((a*c)/(excentricidade a c))*(asin(excentricidade a c)))
    | c == a = 4*pi*c^2
area (Cilindro r h) = 2*pi*r*(r+h)
area (Cone r h) = pi*r*(sqrt(r^2 + h^2) + r)
area (Tronco r1 r2 h) = pi*(r1^2 + r2^2 + (r1+r2)*sqrt(h^2 + (r1 - r2)^2))

volume :: Forma -> Float
volume (Esferoide a c) = (4/3)*pi*c*a^3
volume (Cilindro r h) = pi*h*r^2
volume (Cone r h) = (1/3)*pi*h*r^2
volume (Tronco r1 r2 h) = (1/3)*pi*h*(r1^2 + r2^2 + r1*r2)