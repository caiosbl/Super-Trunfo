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

data MediaAtributos = MediaAtributos { contador  :: Int
     , acumulador_ataque :: Int 
     , acumulador_defesa :: Int
     , acumulador_meio :: Int
     , acumulador_titulos :: Int
     , acumulador_aparicoes_copas :: Int
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

iniciarJogo :: MediaAtributos -> Stack Carta -> Stack Carta -> Int -> Int -> Bool -> String
iniciarJogo  mediaAtributos pilha1 pilha2 playerAtual totalRodadas isTwoPlayers
  | empty pilha1 = "FIM DE JOGO - PLAYER 1 VENCEU!" ++ "Total de Rodadas: " show(totalRodadas)
  | empty pilha2 = "FIM DE JOGO - PLAYER 2 VENCEU!" ++ "Total de Rodadas: " show(totalRodadas)
  | otherwise = do
    unsafeDupablePerformIO (putStrLn ("PLAYER ATUAL: " ++ show(playerAtual) ++ " RODADA ATUAL: " ++ show(totalRodadas)))
    unsafeDupablePerformIO (putStrLn ("PLACAR: P1 " ++ show(size pilha1) ++ " x " ++ show(size pilha2) ++ " P2"))
    iniciarJogo media_Atributos pilha_1 pilha_2 player_atual (totalRodadas + 1) isTwoPlayers
  where (pilha_1,pilha_2,player_atual,media_Atributos) = jogada mediaAtributos pilha1 pilha2 playerAtual isTwoPlayers


jogada :: MediaAtributos -> Stack Carta -> Stack Carta -> Int -> Bool -> (Stack Carta,Stack Carta,Int,MediaAtributos) 
jogada mediaAtributos pilha1 pilha2 playerAtual isTwoPlayers
  | playerAtual == 1 = jogadaAuxiliarPlayer1 mediaAtributos pilha1 pilha2
  | playerAtual == 2 && not isTwoPlayers = jogadaAuxiliarPlayer2 mediaAtributos pilha1 pilha2
  | playerAtual == 2 && isTwoPlayers = jogadaAuxiliarBot mediaAtributos pilha1 pilha2


jogadaAuxiliarPlayer1 ::  MediaAtributos -> Stack Carta -> Stack Carta -> (Stack Carta,Stack Carta,Int,MediaAtributos)
jogadaAuxiliarPlayer1 mediaAtributos pilha1 pilha2 = do
  let carta_p1 = peek pilha1
  let carta_p2 = peek pilha2
  unsafeDupablePerformIO (putStrLn (toStringCarta (carta_p1)))
  let atributo = validaAtributo
  let comparador = jogadaAuxiliar carta_p1 carta_p2 atributo

  let (cartaPerdida,pilhaPerdedor) =  if comparador > 0 then pop pilha2 else pop pilha1
  let pilhaTemp = if comparador > 0 then push cartaPerdida (invertePilha(pilha1)) else push cartaPerdida (invertePilha(pilha2))
  
  let pilhaVencedor = invertePilha(pilhaTemp)

  let media_atributos = MediaAtributos {contador =
     ((contador mediaAtributos ) + 1),
      acumulador_ataque = ((acumulador_ataque mediaAtributos) + (carta_p1 ataque)),
      acumulador_defesa = ((acumulador_defesa mediaAtributos ) + (carta_p1 defesa)),
      acumulador_titulos = ((acumulador_titulos mediaAtributos) + (carta_p1 titulos)),
      acumulador_aparicoes_copas = ((acumulador_aparicoes_copas mediaAtributos) + (aparicoes_copas carta_p1))
      }
  
  if comparador > 0 then unsafeDupablePerformIO (putStrLn ("PLAYER 1 - VENCEU A RODADA!")) else unsafeDupablePerformIO (putStrLn ("PLAYER 2 - VENCEU A RODADA!"))
  if (comparador > 0) then return (pilhaVencedor,pilhaPerdedor,1,media_atributos) else return (pilhaPerdedor,pilhaVencedor,2,media_atributos)

jogadaAuxiliarPlayer2 ::  MediaAtributos -> Stack Carta -> Stack Carta -> (Stack Carta,Stack Carta,Int,MediaAtributos)
jogadaAuxiliarPlayer2 mediaAtributos pilha1 pilha2 = do
  let carta_p1 = peek pilha1
  let carta_p2 = peek pilha2
  unsafeDupablePerformIO (putStrLn (toStringCarta (carta_p2)))
  let atributo = validaAtributo
  let comparador = jogadaAuxiliar carta_p2 carta_p1 atributo

  let (cartaPerdida,pilhaPerdedor) =  if comparador > 0 then pop pilha1 else pop pilha2
  let pilhaTemp = if comparador > 0 then push cartaPerdida (invertePilha(pilha2)) else push cartaPerdida (invertePilha(pilha1))
  
  let pilhaVencedor = invertePilha(pilhaTemp)

  let media_atributos = MediaAtributos {contador =
    ((contador mediaAtributos ) + 1),
     acumulador_ataque = ((acumulador_ataque mediaAtributos) + (carta_p2 ataque)),
     acumulador_defesa = ((acumulador_defesa mediaAtributos ) + (carta_p2 defesa)),
     acumulador_titulos = ((acumulador_titulos mediaAtributos) + (carta_p2 titulos)),
     acumulador_aparicoes_copas = ((acumulador_aparicoes_copas mediaAtributos) + (aparicoes_copas carta_p2))
     }
 
  
  if comparador > 0 then unsafeDupablePerformIO (putStrLn ("PLAYER 2 - VENCEU A RODADA!")) else unsafeDupablePerformIO (putStrLn ("PLAYER 1 - VENCEU A RODADA!"))
  if (comparador > 0) then return (pilhaPerdedor,pilhaVencedor,2,media_atributos) else return (pilhaVencedor,pilhaPerdedor,1,media_atributos)

jogadaAuxiliarBot :: MediaAtributos ->  Stack Carta -> Stack Carta -> (Stack Carta,Stack Carta,Int,MediaAtributos)
jogadaAuxiliarBot mediaAtributos pilha1 pilha2 = do
  let carta_p1 = peek pilha1
  let carta_p2 = peek pilha2
  unsafeDupablePerformIO (putStrLn (toStringCarta (carta_p2)))
  
  let atributo = selectAtributoBot mediaAtributos carta_p2

  unsafeDupablePerformIO (putStrLn ("ATRIBUTO ESCOLHIDO: " ++ atributo))

  let comparador = jogadaAuxiliar carta_p2 carta_p1 atributo

  let (cartaPerdida,pilhaPerdedor) =  if comparador > 0 then pop pilha1 else pop pilha2
  let pilhaTemp = if comparador > 0 then push cartaPerdida (invertePilha(pilha2)) else push cartaPerdida (invertePilha(pilha1))
  
  let pilhaVencedor = invertePilha(pilhaTemp)

  let media_atributos = MediaAtributos {contador =
    ((contador mediaAtributos ) + 1),
     acumulador_ataque = ((acumulador_ataque mediaAtributos) + (carta_p2 ataque)),
     acumulador_defesa = ((acumulador_defesa mediaAtributos ) + (carta_p2 defesa)),
     acumulador_titulos = ((acumulador_titulos mediaAtributos) + (carta_p2 titulos)),
     acumulador_aparicoes_copas = ((acumulador_aparicoes_copas mediaAtributos) + (aparicoes_copas carta_p2))
     }
 
  
  if comparador > 0 then unsafeDupablePerformIO (putStrLn ("PLAYER 2 - VENCEU A RODADA!")) else unsafeDupablePerformIO (putStrLn ("PLAYER 1 - VENCEU A RODADA!"))
  if (comparador > 0) then return (pilhaPerdedor,pilhaVencedor,2,media_atributos) else return (pilhaVencedor,pilhaPerdedor,1,media_atributos)

selectAtributoBot :: MediaAtributos -> Carta -> String
selectAtributoBot mediaAtributos carta = do
  let (media_ataque,media_defesa,media_meio,media_titulos,media_aparicoes) = ((mediaAtributos acumulador_ataque) `div` (contador mediaAtributos),((mediaAtributos acumulador_defesa) `div` (contador mediaAtributos)), ((mediaAtributos acumulador_meio) `div` (contador mediaAtributos)),((mediaAtributos acumulador_titulos) `div` (contador mediaAtributos)),((mediaAtributos acumulador_aparicoes_copa) `div` (contador mediaAtributos)))

  let ataque = (carta ataque) - media_ataque
  let defesa = (carta defesa) - media_defesa
  let meio = (carta meio) - media_meio
  let titulos = (carta titulos) - media_titulos
  let aparicoes_copas = (carta aparicoes_copas) - media_aparicoes
  
  if ataque >= (max defesa meio titulos aparicoes_copas) then return "ATAQUE"
  else if defesa >=  (max meio titulos aparicoes_copas) then return "DEFESA"
  else if meio >= (max titulos aparicoes_copas) then return "MEIO"
  else if titulos > aparicoes_copas then return "TITULOS"
  else return "APARICOES_COPAS"
  

jogadaAuxiliar :: Carta -> Carta -> String -> Int 
jogadaAuxiliar carta1 carta2 atributo 
  | (comparaCartas atributo carta1 carta2) == 0 =  if isA carta1 then 1 else -1
  | (comparaCartas atributo carta1 carta2) > 0 = 1
  | (comparaCartas atributo carta1 carta2) < 0 = -1

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
    let index_trunfo = randomTrunfo
    let lista_cartas = ((map (mapeiaCartas index_trunfo) (lista))) 
    return lista_cartas !! 0 
   
mapeiaCartas :: [String] -> Int -> Carta
mapeiaCartas lista indexTrunfo = 
  Carta{tipo = (lista) !! 0, 
  nome = (lista) !! 1,
  ataque = read((lista) !! 2),
  defesa = read((lista) !! 3),
  meio =  read((lista) !! 4),
  titulos =  read((lista) !! 5),
  aparicoes_copas =  read((lista) !! 6), is_trunfo = if ((read(lista) !! 7)  == indexTrunfo) then True else False}

randomTrunfo :: Int
randomTrunfo = unsafeDupablePerformIO (getStdRandom (randomR (1,32))) 

randomPlayerIniciaJogo :: Int
randomPlayerIniciaJogo = unsafeDupablePerformIO (getStdRandom (randomR (1,2)))


comparaCartas :: String -> Carta -> Carta -> Int
invertePilha :: Stack Carta -> Stack Carta
isA :: Carta -> Bool