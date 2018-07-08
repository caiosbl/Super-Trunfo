module Utils where

import qualified Cards as Cards
import qualified Pilha as Pilha
import System.IO.Unsafe(unsafeDupablePerformIO)
import System.Random
import Data.List.Split



atributos :: String
atributos = "[ATAQUE | DEFESA | MEIO | TITULOS | APARICOES_COPA]"


leAtributo :: IO String
leAtributo = do
  atributo <- getLine
  if (verificaAtributo atributo) then return atributo else leAtributo
  
escolheAtributo :: Cards.Carta -> Cards.MediaAtributos -> String
escolheAtributo carta mediaAtributos = do
  let ata = (Cards.ataque carta)
  let def = Cards.defesa carta
  let mei = Cards.meio carta
  let tit = Cards.titulos carta
  let apa = Cards.aparicoes_copas carta
  
  let mediaAtaque = Cards.mediaAtaque mediaAtributos
  let mediaDefesa = Cards.mediaDefesa mediaAtributos
  let mediaMeio = Cards.mediaMeio mediaAtributos
  let mediaTitulos = Cards.mediaTitulos mediaAtributos
  let mediaAparicoesCopa = Cards.mediaAparicoesCopa mediaAtributos
  
  let difAtaque = ata - mediaAtaque
  let difDefesa = def - mediaDefesa
  let difMeio = mei - mediaMeio
  let difTitulos = tit - mediaTitulos
  let difAparCopas = apa - mediaAparicoesCopa
  
  escolherAtributoAuxiliar difAtaque difDefesa difMeio difTitulos difAparCopas
  
escolherAtributoAuxiliar :: Int -> Int -> Int -> Int -> Int -> String
escolherAtributoAuxiliar difAtaque difDefesa difMeio difTitulos difAparicoes_copas 
  | difAtaque >= max (max difDefesa difMeio) (max difTitulos difAparicoes_copas ) = "ATAQUE"
  | difDefesa >= max  difMeio (max difTitulos difAparicoes_copas) = "DEFESA"
  | difMeio >= max difTitulos difAparicoes_copas = "MEIO"
  | difTitulos >= difAparicoes_copas = "TITULOS"
  | otherwise = "APARICOES_COPA"
    
verificaAtributo :: String -> Bool
verificaAtributo atributo 
  | atributo == "ATAQUE" = True
  | atributo == "DEFESA" = True
  | atributo == "MEIO" = True
  | atributo == "TITULOS" = True
  | atributo == "APARICOES_COPA" = True
  | otherwise = False

banner :: String
banner = unsafeDupablePerformIO (readFile "banner.txt")

randomTrunfo :: Int
randomTrunfo = unsafeDupablePerformIO (getStdRandom (randomR (1,32))) 

randomPlayerIniciaJogo :: Int
randomPlayerIniciaJogo = unsafeDupablePerformIO (getStdRandom (randomR (1,2)))

iniciarPilha :: [Cards.Carta] -> Pilha.Stack Cards.Carta
iniciarPilha lista = iniciarPilhaAuxiliar lista Pilha.create

iniciarPilhaAuxiliar :: [Cards.Carta] -> Pilha.Stack Cards.Carta -> Pilha.Stack Cards.Carta
iniciarPilhaAuxiliar lista pilha 
  |null lista = pilha
  | otherwise = iniciarPilhaAuxiliar (tail lista) (Pilha.push (head lista) pilha)


iniciarCartas :: [Cards.Carta]
iniciarCartas = do
    let file = unsafeDupablePerformIO (readFile "selecoes.txt")
    let lista =  ((map ( splitOn ",") (lines file))) 
    let indexTrunfo = randomTrunfo
    let lista_cartas = ((map (mapeiaCarta indexTrunfo)) (lista))
    return lista_cartas !! 0 

   
mapeiaCarta :: Int -> [String] -> Cards.Carta
mapeiaCarta indexTrunfo lista =
  Cards.Carta{Cards.tipo = (lista) !! 0, 
  Cards.nome = (lista) !! 1,
  Cards.ataque = read((lista) !! 2),
  Cards.defesa = read((lista) !! 3),
  Cards.meio =  read((lista) !! 4),
  Cards.titulos =  read((lista) !! 5),
  Cards.aparicoes_copas =  read((lista) !! 6), Cards.is_trunfo = if ((read(lista !! 7))  == indexTrunfo) then True else False}  
