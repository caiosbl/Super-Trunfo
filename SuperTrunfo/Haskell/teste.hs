import System.IO.Unsafe(unsafeDupablePerformIO)
import Control.Concurrent
import System.Console.ANSI
import System.Random
import System.Random.Shuffle
import Data.List.Split

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
size pilha = length pilha
 
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

desempata :: Carta -> Carta -> Int
desempata carta1 carta2 = if (tipo carta1) < (tipo carta2) then 1 else -1
 
invertePilha :: Stack Carta -> Stack Carta
invertePilha pilha = reverse pilha
                       
isA :: Carta -> Bool
isA carta = if (take 1 (tipo carta)) == "A"
  then True
  else False

banner :: String 
banner = unsafeDupablePerformIO (readFile "banner.txt")

iniciarCartas :: [Carta]
iniciarCartas = do
    let file = unsafeDupablePerformIO (readFile "selecoes.txt")
    let lista =  ((map ( splitOn ",") (lines file))) 
    let lista_cartas = ((map (mapeiaCartas) (lista))) 
    return lista_cartas !! 0 

mapeiaCartas :: [String] -> Carta
mapeiaCartas lista = do 
  let indexTrunfo = randomTrunfo
  Carta{tipo = (lista) !! 0, 
  nome = (lista) !! 1,
  ataque = read((lista) !! 2),
  defesa = read((lista) !! 3),
  meio =  read((lista) !! 4),
  titulos =  read((lista) !! 5),
  aparicoes_copas =  read((lista) !! 6), is_trunfo = if (((read(lista !! 0)) !! 7)  == indexTrunfo) then True else False}

randomTrunfo :: Int
randomTrunfo = unsafeDupablePerformIO (getStdRandom (randomR (1,32))) 

iniciarPilha :: [Carta] -> Stack Carta
iniciarPilha lista = iniciarPilhaAuxiliar lista create

iniciarPilhaAuxiliar :: [Carta] -> Stack Carta -> Stack Carta
iniciarPilhaAuxiliar lista pilha 
  |null lista = pilha
  | otherwise = iniciarPilhaAuxiliar (tail lista) (push (head lista) pilha)

randomPlayerIniciaJogo :: Int
randomPlayerIniciaJogo = unsafeDupablePerformIO (getStdRandom (randomR (1,2)))

enganaMain :: IO() -> IO()
enganaMain x = x

iniciarJogo ::  MediaAtributos -> Stack Carta -> Stack Carta -> Int -> Int -> Bool -> [IO()]
iniciarJogo  mediaAtributos pilha1 pilha2 playerAtual totalRodadas isTwoPlayers 
  | empty pilha1 = putStrLn ("FIM DE JOGO - PLAYER 2 VENCEU! Total de Rodadas: " ++ (show(totalRodadas)))
  | empty pilha2 = putStrLn ("FIM DE JOGO - PLAYER 1 VENCEU! Total de Rodadas: " ++ (show(totalRodadas)))
  | otherwise = do
    putStrLn ("PLAYER ATUAL: " ++ show(playerAtual) ++ " RODADA ATUAL: " ++ (show(totalRodadas) ++ "\n"
      ++ "PLACAR: P1 " ++ show(size pilha1) ++ " x " ++ (show(size pilha2)) ++ " P2"))
    iniciarJogo media_Atributos pilha_1 pilha_2 player_atual (totalRodadas + 1) isTwoPlayers 
  where (pilha_1,pilha_2,player_atual,media_Atributos) = jogada mediaAtributos pilha1 pilha2 playerAtual isTwoPlayers

jogada :: MediaAtributos -> Stack Carta -> Stack Carta -> Int -> Bool -> (Stack Carta,Stack Carta,Int,MediaAtributos) -> [IO()]
jogada mediaAtributos pilha1 pilha2 playerAtual isTwoPlayers
  | playerAtual == 1 = do 
    map enganaMain jogadaAuxiliarPlayer1 mediaAtributos pilha1 pilha2
    threadDelay 6000000
    clearScreen

  | playerAtual == 2 && isTwoPlayers = do 
    map enganaMain jogadaAuxiliarPlayer2 mediaAtributos pilha1 pilha2
    threadDelay 6000000
    clearScreen
  | playerAtual == 2 && not isTwoPlayers = do 
    map enganaMain jogadaAuxiliarBot mediaAtributos pilha1 pilha2
    threadDelay 6000000
    clearScreen
main :: IO()

main = do 
  putStrLn (banner)
  threadDelay 5000000
  clearScreen

  let cartas = iniciarCartas
  embaralhadas <- shuffleM cartas

  let lista_1 = take 16 embaralhadas
  let lista_2 = take 16 (reverse embaralhadas)
  let pilha_1 = iniciarPilha lista_1
  let pilha_2 = iniciarPilha lista_2
  let player_atual = randomPlayerIniciaJogo

  putStrLn (">>> CARTAS EMBARALHADAS! <<<")
  threadDelay 2000000
  putStrLn (">>> PILHAS MONTADAS <<<")
  threadDelay 2000000
  putStrLn (">>> PLAYER" ++ show(player_atual) ++ " INICIA O JOGO! <<<")
  threadDelay 3000000
  clearScreen

  let mediaAtributos = MediaAtributos { contador = 0, acumulador_ataque = 0, acumulador_defesa = 0 ,
   acumulador_meio = 0, acumulador_titulos = 0, acumulador_aparicoes_copas = 0}

  let isTwoPlayers = False

  map enganaMain (iniciarJogo mediaAtributos pilha_1 pilha_2 player_atual 0 isTwoPlayers)

  putStrLn (banner)