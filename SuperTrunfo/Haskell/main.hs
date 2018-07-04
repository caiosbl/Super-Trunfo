import Data.List.Split
import System.IO.Unsafe(unsafeDupablePerformIO)


data Carta = Carta { tipo :: String  
                     , nome :: String  
                     , ataque :: Int  
                     , defesa :: Int
                     , meio :: Int
                     , titulos :: Int
                     , aparicoes_copas :: Int
                     , is_trunfo :: Bool
                     } deriving (Show)  

toStringCarta :: Carta -> String
toStringCarta (Carta {tipo = tip, nome = nom, ataque = ata,
 defesa = def, meio = mei, titulos = tit, aparicoes_copas = apa, is_trunfo = is}) = 
    "Tipo: " ++ tip ++ "\n" ++
                       "Selecao: " ++ nom ++ "\n" ++
                       "Ataque: " ++ show(ata) ++ "\n" ++
                       "Meio: " ++ show(mei) ++ "\n" ++
                       "Defesa: " ++ show(def) ++ "\n" ++
                       "Titulos: " ++ show(tit) ++ "\n" ++
                       "Aparicoes em Copas: " ++  show(apa) ++ "\n" ++
                       if is then "É TRUNFO" else ""

main :: IO()

main = do 
  putStrLn (show(iniciarCartas))

iniciarCartas :: [Carta]

iniciarCartas = do
    let file = unsafeDupablePerformIO (readFile "selecoes.txt")
    let lista =  ((map ( splitOn ",") (lines file))) 
    let lista_cartas = ((map (mapeiaCartas) (lista))) 
    return lista_cartas !! 0 
   


mapeiaCartas :: [String] -> Carta
mapeiaCartas lista = 
  Carta{tipo = (lista) !! 0, 
  nome = (lista) !! 1,
   ataque = read((lista) !! 2),
defesa = read((lista) !! 3),
 meio =  read((lista) !! 4),
  titulos =  read((lista) !! 5),
 aparicoes_copas =  read((lista) !! 6),
  is_trunfo = False}