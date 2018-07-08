import qualified Utils as Utils
import qualified Pilha as Pilha
import qualified Cards as Cards
import Control.Concurrent
import System.Console.ANSI
import System.Random.Shuffle

main :: IO()
main = do
  putStrLn (Utils.banner)
  threadDelay 5000000
  clearScreen
  menu
  
opcoesMenu :: String
opcoesMenu = "Escolha uma Opcão: \n1 - Iniciar Jogo - 1P \n2 - Iniciar Jogo 2P \n3 - Créditos\n4 - Sair"

creditos :: IO()
creditos = do
  putStrLn ("Desenvolvido por: \nCaio Sanches\nThallyson Alves\nDomingos Gabriel\n Daniel José")
  menu


 
menu :: IO()
menu = do
  clearScreen
  putStrLn (opcoesMenu)
 
  putStrLn ("Opção: ")
  opcao <- getLine
  
  if opcao == "1" then do
    let cartas = Utils.iniciarCartas
    embaralhadas <- shuffleM cartas
    putStrLn (">>> CARTAS EMBARALHADAS <<<")
    threadDelay 2000000

    let lista_1 = take 16 embaralhadas
    let lista_2 = take 16 (reverse embaralhadas)
    let pilha_1 = Utils.iniciarPilha lista_1
    let pilha_2 = Utils.iniciarPilha lista_2
    putStrLn (">>> PILHAS MONTADAS <<<")
    threadDelay 2000000
    
    let playerAtual = Utils.randomPlayerIniciaJogo
    putStrLn (">>> PLAYER " ++ show(playerAtual) ++ " INICIA O JOGO <<<")
    threadDelay 3000000
    
    iniciaVsBot pilha_1 pilha_2 playerAtual 1   
         
  else if opcao == "2" then iniciaVsP2
  else if opcao == "3" then creditos
  else if opcao == "4" 
  then clearScreen
  else  menu
 
 
 
iniciaVsBot :: Pilha.Stack Cards.Carta -> Pilha.Stack Cards.Carta -> Int -> Int -> IO()
iniciaVsBot pilha1 pilha2 playerAtual rodadaAtual = do
  clearScreen
  let carta_p1 = Pilha.peek pilha1
  let carta_p2 = Pilha.peek pilha2
  putStrLn ("[Placar: " ++ show(Pilha.size pilha1) ++ " P1 x " ++ show(Pilha.size pilha2) ++ " P2 ]")
  putStrLn ("Rodada Atual: " ++ show(rodadaAtual))
  putStrLn ("Player Atual: " ++ show(playerAtual))
  putStrLn ("")
  putStrLn ("[NOVA JOGADA]")
  putStrLn ("")
  putStrLn ("Carta: ")
  if playerAtual == 1 then do
   
    
  
    putStrLn (Cards.toString (carta_p1))
    putStrLn ("")
    
    if Cards.isTrunfo carta_p1 then do
      putStrLn ("[EH TRUNFO]")
      if Cards.isA carta_p2 then do
        putStrLn ("")
        putStrLn ("Carta P2")
        putStrLn(Cards.toString (carta_p2))
        putStrLn ("")
        putStrLn ("[PLAYER 2 VENCEDOR DA RODADA!]")
        let pilha2_temp1 = Pilha.invertePilha pilha2
        let pilha2_temp2 = Pilha.push carta_p1 pilha2_temp1
        let pilha2_final = Pilha.invertePilha pilha2_temp2
        let (carta_perdida, pilha1_final)  = Pilha.pop pilha1
        threadDelay 6000000
        iniciaVsBot pilha1_final pilha2_final 2 (rodadaAtual + 1)
        
      else do
        putStrLn ("")
        putStrLn ("Carta P2")
        putStrLn(Cards.toString (carta_p2))
        putStrLn ("")
        putStrLn ("[PLAYER 1 VENCEDOR DA RODADA!]")
        let pilha1_temp1 = Pilha.invertePilha pilha1
        let pilha1_temp2 = Pilha.push carta_p2 pilha1_temp1
        let pilha1_final = Pilha.invertePilha pilha1_temp2
        let (carta_perdida, pilha2_final)  = Pilha.pop pilha2
        threadDelay 6000000
        iniciaVsBot pilha1_final pilha2_final 1 (rodadaAtual + 1)
        
    else do              
      putStrLn ("Escolha um Atributo " ++ Utils.atributos)
      atributo <- Utils.leAtributo
      let comparador = Cards.compara atributo carta_p1 carta_p2
      if comparador == 1 then do
        putStrLn ("")
        putStrLn ("Carta P2")
        putStrLn(Cards.toString (carta_p2))
        putStrLn ("")
        putStrLn ("[PLAYER 1 VENCEDOR DA RODADA!]")
        let pilha1_temp1 = Pilha.invertePilha pilha1
        let pilha1_temp2 = Pilha.push carta_p2 pilha1_temp1
        let pilha1_final = Pilha.invertePilha pilha1_temp2
        let (carta_perdida, pilha2_final)  = Pilha.pop pilha2
        threadDelay 6000000
        iniciaVsBot pilha1_final pilha2_final 1 (rodadaAtual + 1)
        
      else do
        putStrLn ("")
        putStrLn ("Carta P2")
        putStrLn(Cards.toString (carta_p2))
        putStrLn ("")
        putStrLn ("[PLAYER 2 VENCEDOR DA RODADA!]")
        let pilha2_temp1 = Pilha.invertePilha pilha2
        let pilha2_temp2 = Pilha.push carta_p1 pilha2_temp1
        let pilha2_final = Pilha.invertePilha pilha2_temp2
        let (carta_perdida, pilha1_final)  = Pilha.pop pilha1
        threadDelay 6000000
        iniciaVsBot pilha1_final pilha2_final 2 (rodadaAtual + 1)
        
        
   
  else do
    putStrLn (Cards.toString (Pilha.peek pilha1))
    putStrLn (Cards.toString (Pilha.peek pilha1))
    threadDelay 2000000
  
  
  

iniciaVsP2 :: IO()
iniciaVsP2 = do
  clearScreen
  putStrLn("y")
  threadDelay 5000000
  menu
  
 
  




  
  
 
