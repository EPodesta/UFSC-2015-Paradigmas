import Data.Char
import System.Environment
import System.IO

main :: IO ()
main = do
    args <- getArgs
    case args of
        [input] -> do
            processFiles input

splitRGB (b:g:r:[]) = ([b], [g], [r])
splitRGB (b:g:[]) = ([b], [g], [0])
splitRGB (b:[]) = ([b], [0], [0])
splitRGB (b:g:r:resto) = let
    (bs, gs, rs) = splitRGB resto in (b:bs, g:gs, r:rs)

fpoint :: Int -> Float
fpoint i = fromIntegral i / 256

toList :: (a, a, a) -> [a]
toList (x, y, z) = [x, y, z]

processFiles input = do
    inString <- readFile input
    let filename = take (length input - 4) input
    let outname1 = map (filename++) ["_blue.out"
    let outname2 = map(filename++) ["_green.out"]
    let outname3 = map (filename++) ["_red.out"]
    output1 <- openFile outname1 WriteMode
    output2 <- openFile outname2 WriteMode
    output3 <- openFile outname3 WriteMode
    --outputs <- sequence [openFile f WriteMode | f <- outnames]
    let body = snd (splitAt 54 (map ord inString))
    let rgb = toList (splitRGB (map fpoint body))
    hPrint bFile (blue)
    hPrint gFile (red)
    hPrint rFile (green)
    hClose bFile
    hClose gFile
    hClose rFile
    --sequence [hPrint file color | (file, color) <- zip outputs rgb]
    --sequence [hClose f | f <- outputs]
    return ()