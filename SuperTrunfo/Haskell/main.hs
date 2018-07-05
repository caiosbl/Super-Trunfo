import Data.List.Split
import System.IO.Unsafe(unsafeDupablePerformIO)
import System.Random
import System.Random.Shuffle

type Stack a = [a]
 
create :: Stack a
create  = []
 
push :: a -> Stack a -> Stack a
push = (:)
 
pop :: Stack a -> (a, Stack a)
pop []     = error "Stack empty"
pop (x:xs) = (x,xs)
 
empty :: Stack a -> Bool
empty = null
 
peek :: Stack a -> a
peek []    = error "Stack empty"
peek (x:_) = x

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
  let cartas = iniciarCartas
  embaralhadas <- shuffleM cartas
  
  let lista_1 = take 16 embaralhadas
  let lista_2 = take 16 (reverse embaralhadas)

  let pilha_1 = iniciarPilha lista_1
  let pilha_2 = iniciarPilha lista_2

  let player_atual = randomPlayerIniciaJogo

  Bool isTwoPlayers = False

 
  putStrLn (show(peek pilha_1))
  putStrLn (" ")
  putStrLn (show(peek pilha_2))

iniciarJogo :: Stack Carta -> Stack Carta -> Int -> Int -> Bool -> String
iniciarJogo  pilha1 pilha2 playerAtual totalRodadas isTwoPlayers
  | empty pilha1 = "FIM DE JOGO - PLAYER 1 VENCEU!" ++ "Total de Rodadas: " show(totalRodadas)
  | empty pilha2 = "FIM DE JOGO - PLAYER 2 VENCEU!" ++ "Total de Rodadas: " show(totalRodadas)
  | playerAtual == 1 = 


jogada :: Stack Carta -> Stack Carta -> Int -> (Stack,Stack) 
jogada pilha1 pilha2 playerAtual
  | playerAtual == 1 = 
    unsafeDupablePerformIO (putStrLn (toStringCarta (peek pilha1)))
    let atributo = validaAtributo




validaAtributo :: String
validaAtributo = 
  unsafeDupablePerformIO (putStrLn (atributos))
  atributo <- unsafeDupablePerformIO (getLine)
  if checkAtributo atributo then return atributo else return validaAtributo
  


checkAtributo :: String -> Bool
checkAtributo atributo
  | (toUpper atributo) == "ATAQUE" = True
  | (toUpper atributo) == "DEFESA" = True
  | (toUpper atributo) == "MEIO" = True
  | (toUpper atributo) == "APARICOES_COPA" = True
  | (toUpper atributo) == "TITULOS" = True
  | otherwise = False


atributos :: String
atributos = "[ATAQUE | DEFESA | MEIO | TITULOS | APARICOES_COPA]"




iniciarPilha :: [Carta] -> Stack Carta
iniciarPilha lista = iniciarPilhaAuxiliar lista create

iniciarPilhaAuxiliar :: [Carta] -> Stack Carta -> Stack Carta
iniciarPilhaAuxiliar lista pilha 
  |null lista = pilha
  | otherwise = iniciarPilhaAuxiliar (tail lista) (push (head lista) pilha)

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

  
randomPlayerIniciaJogo :: Int
randomPlayerIniciaJogo = unsafeDupablePerformIO (getStdRandom (randomR (1,2)))


comparaCartas :: Carta -> Carta -> Int
invertePilha :: Stack Carta -> Stack Carta
isA :: Carta -> Bool