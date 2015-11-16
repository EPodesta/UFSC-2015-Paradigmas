-- GRUPO: 
-- Pedro van Rooij Costa
-- Nelson Mariano Leite Neto
-- Bruno Freitas

import System (getArgs)
import System.IO
import Utilitarios
import List

main = do
	args <- getArgs
	case args of
		[fname] -> do			
			fstr <- readFile fname

			let (cabecalho, imagem) = retirarCabecalho fstr
			let largura = pegarLargura cabecalho
			let imagemSemPadding = removerPadding imagem largura
			let pixels = fazerTriplas imagemSemPadding
			-- Funcao que pega a transposta da matriz passada como parametro
			let rgb = transpose pixels
			let rgbEmLinhas = map (rearranjarPixelList largura) rgb
			let nomeInitArq = take (length fname - 4) fname
			let nomesRGB = map (nomeInitArq++)["_Red.txt","_Green.txt","_Blue.txt"]
			arquivosRGB <- sequence [openFile file WriteMode | file <- nomesRGB]

			sequence [escreverNoArquivo arq str | (arq, str) <- zip arquivosRGB rgbEmLinhas]
			sequence [hClose f | f <- arquivosRGB]

			putStr "Separacao RGB concluida com sucesso!!! Os arquivos criados sao: \n"
			putStr $ concat $ map (++ "\n") nomesRGB
	
		_	-> do
				putStr "Execute o programa criado passando como parametro o nome do arquivo a ser separado em camadas\n"
				putStr "Por exemplo: ./nomePrograma teste.bmp\n"
			
