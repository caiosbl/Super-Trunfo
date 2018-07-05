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

size :: Stack a -> Int
size = length (x:xs)
 
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
  let  isTwoPlayers = False

 
  putStrLn (show(peek pilha_1))
  putStrLn (" ")
  putStrLn (show(peek pilha_2))

iniciarJogo :: Stack Carta -> Stack Carta -> Int -> Int -> Bool -> String
iniciarJogo  pilha1 pilha2 playerAtual totalRodadas isTwoPlayers
  | empty pilha1 = "FIM DE JOGO - PLAYER 1 VENCEU!" ++ "Total de Rodadas: " show(totalRodadas)
  | empty pilha2 = "FIM DE JOGO - PLAYER 2 VENCEU!" ++ "Total de Rodadas: " show(totalRodadas)
  | playerAtual == 1 = jogada pilha1 pilha2 playerAtual isWtoPlayers


jogada :: Stack Carta -> Stack Carta -> Int -> Bool -> (Stack,Stack) 
jogada pilha1 pilha2 playerAtual isTwoPlayers
  | playerAtual == 1 = jogadaAuxiliar2 pilha1 pilha2


jogadaAuxiliarPlayer1 ::  Stack Carta -> Stack Carta -> (Stack Carta,Stack Carta)
jogadaAuxiliar2 pilha1 pilha2 = do
  unsafeDupablePerformIO (putStrLn (toStringCarta (carta_p1)))
  let carta_p1 = peek pilha1
  let carta_p2 = peek pilha2
  let atributo = validaAtributo
  let comparador = jogadaAuxiliar carta_p1 carta_p2 atributo

  let (cartaPerdida,pilhaPerdedor) =  if comparador > 0 then pop pilha2 else pop pilha1
  let pilhaTemp = if comparador > 0 then push cartaPerdida (invertePilha(pilha1)) else push cartaPerdida (invertePilha(pilha2))
  
  let pilhaVencedor = invertePilha(pilhaTemp)
  
  if comparador > 0 then unsafeDupablePerformIO (putStrLn ("PLAYER 1 - VENCEU A RODADA!")) else unsafeDupablePerformIO (putStrLn ("PLAYER 2 - VENCEU A RODADA!"))
  return if (comparador > 0) then (pilhaVencedor,pilhaPerdedor) else (pilhaPerdedor,pilhaVencedor)

jogadaAuxiliar :: Carta -> Carta -> String -> Int 
jogadaAuxiliar carta1 carta2 atributo 
  | (comparaCartas atributo carta1 carta2) == 0 =  if isA carta1 then 1 else -1
  | (comparaCartas atributo carta1 carta2) > 0 = 1
  | (comparaCartas atributo carta1 carta2) > 0 = -1

validaAtributo :: String
validaAtributo = do
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


comparaCartas :: String -> Carta -> Carta -> Int
invertePilha :: Stack Carta -> Stack Carta
isA :: Carta -> Bool