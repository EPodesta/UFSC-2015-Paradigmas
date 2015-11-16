-- GRUPO: 
-- Pedro van Rooij Costa
-- Nelson Mariano Leite Neto
-- Bruno Freitas

module Formas ( Forma (Esfera,Cilindro,Cone,TroncoCone,EsferoideOblato, EsferoideProblato ),
	Raio, Altura,RaioBase, RaioSeccao,SemiMaior,SemiMenor) where
data Forma = Esfera Raio
	| Cilindro RaioBase Altura
	| Cone RaioBase Altura
	| TroncoCone RaioBase RaioSeccao Altura
	| EsferoideOblato SemiMaior SemiMenor 
	| EsferoideProblato SemiMaior SemiMenor 
	deriving Show

type RaioBase = Float
type Raio = Float
type Altura = Float
type RaioSeccao = Float
type SemiMaior = Float
type SemiMenor = Float

exce :: SemiMaior -> SemiMenor -> Float
exce a b = (sqrt((a*a)-(b*b)))/a 

areaTotal :: Forma -> Float
areaTotal (Esfera r) = 4*pi*r*r
areaTotal (Cilindro r h) = areaLateral(Cilindro r h) + 2*pi*r*r
areaTotal (Cone r h) = pi*r*(sqrt((r*r)+(h*h))+r)
areaTotal (TroncoCone r1 r2 h) = pi*r1*r1 + pi*r2*r2 + areaLateral(TroncoCone r1 r2 h)
areaTotal (EsferoideOblato a b) = (2*pi*a*a) + (((b*b)/(exce a b))*log((1+((exce a b)))/(1-((exce a b)))))
areaTotal (EsferoideProblato a b) = (2*pi*b*b) + (2*pi*((a*b)/exce a b)*asin (exce a b)) 

areaLateral :: Forma -> Float
areaLateral (Cilindro r h) = 2*r*h
areaLateral (Cone r h) = pi*r*sqrt((r*r)+(h*h))
areaLateral (TroncoCone r1 r2 h) = pi*(r1+r2)*sqrt((h*h)+((r1-r2)*(r1-r2)))

volume :: Forma -> Float
volume (Esfera r) = (4/3)*pi*r*r*r
volume (Cilindro r h) = pi*r*r*h
volume (Cone r h) = (1/3)*pi*r*r*h
volume (TroncoCone r1 r2 h) = (1/3)*pi*h*((r1*r1)+(r2*r2)+(r1*r2))
volume (EsferoideOblato a b) = ((4/3)*pi*a*a*b)
volume (EsferoideProblato a b) = ((4/3)*pi*a*b*b)



