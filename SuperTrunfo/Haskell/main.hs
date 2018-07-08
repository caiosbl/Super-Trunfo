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
    let mediaAtributos =  Cards.MediaAtributos { Cards.contador = 1,
    Cards.acumulador_ataque = 0, Cards.acumulador_defesa = 0, Cards.acumulador_meio = 0, Cards.acumulador_titulos = 0, Cards.acumulador_aparicoes_copas = 0}
    
    iniciaVsBot mediaAtributos pilha_1 pilha_2 playerAtual 1   
         
  else if opcao == "2" then do
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
    iniciaVsP2 pilha_1 pilha_2 playerAtual 1
    
    
  else if opcao == "3" then creditos
  else if opcao == "4" then clearScreen
  else  menu
 
 
 
iniciaVsBot :: Cards.MediaAtributos -> Pilha.Stack Cards.Carta -> Pilha.Stack Cards.Carta -> Int -> Int -> IO()
iniciaVsBot mediaAtributos pilha1 pilha2 playerAtual rodadaAtual = do
  clearScreen
  
  if Pilha.empty pilha1 then putStrLn ("FIM DE JOGO - PLAYER 2 VENCEU!! \nTOTAL DE RODADAS: " ++ show(rodadaAtual))
  else if Pilha.empty pilha2 then putStrLn ("FIM DE JOGO - PLAYER 1 VENCEU!! \nTOTAL DE RODADAS: " ++ show(rodadaAtual))
  else do
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
          threadDelay 8000000
          iniciaVsBot mediaAtributos pilha1_final pilha2_final 2 (rodadaAtual + 1)
        
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
          threadDelay 8000000
          iniciaVsBot mediaAtributos pilha1_final pilha2_final 1 (rodadaAtual + 1)
        
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
          threadDelay 8000000
          iniciaVsBot mediaAtributos pilha1_final pilha2_final 1 (rodadaAtual + 1)
        
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
          threadDelay 8000000
          iniciaVsBot mediaAtributos pilha1_final pilha2_final 2 (rodadaAtual + 1)
        
        
   
    else do
      let newMediaAtributos = Cards.atualizaMediaAtributos carta_p2 mediaAtributos
      putStrLn (Cards.toString (carta_p2))
      putStrLn ("")
      if Cards.isTrunfo carta_p2 then do
        putStrLn ("[EH TRUNFO]")
        if Cards.isA carta_p1 then do
          putStrLn ("")
          putStrLn ("Carta P1")
          putStrLn(Cards.toString (carta_p1))
          putStrLn ("")
          putStrLn ("[PLAYER 1 VENCEDOR DA RODADA!]")
          let pilha1_temp1 = Pilha.invertePilha pilha1
          let pilha1_temp2 = Pilha.push carta_p2 pilha1_temp1
          let pilha1_final = Pilha.invertePilha pilha1_temp2
          let (carta_perdida, pilha2_final)  = Pilha.pop pilha2
          threadDelay 8000000
          iniciaVsBot newMediaAtributos pilha1_final pilha2_final 1 (rodadaAtual + 1)
        else do
          putStrLn ("")
          putStrLn ("Carta P1")
          putStrLn(Cards.toString (carta_p1))
          putStrLn ("")
          putStrLn ("[PLAYER 2 VENCEDOR DA RODADA!]")
          let pilha2_temp1 = Pilha.invertePilha pilha2
          let pilha2_temp2 = Pilha.push carta_p1 pilha2_temp1
          let pilha2_final = Pilha.invertePilha pilha2_temp2
          let (carta_perdida, pilha1_final)  = Pilha.pop pilha1
          threadDelay 8000000
          iniciaVsBot newMediaAtributos pilha1_final pilha2_final 2 (rodadaAtual + 1)
      else do
        putStrLn ("")
        putStrLn ("Carta P1")
        putStrLn(Cards.toString (carta_p1))
        putStrLn ("")
        let atributo =  Utils.escolheAtributo carta_p2 mediaAtributos
        threadDelay 2000000
        putStrLn ("ATRIBUTO ESCOLHIDO " ++ atributo)
        threadDelay 2000000
        let comparador = Cards.compara atributo carta_p2 carta_p1
      
     
        if comparador == 1 then do
          putStrLn ("")
          putStrLn ("[PLAYER 2 VENCEDOR DA RODADA!]")
          let pilha2_temp1 = Pilha.invertePilha pilha2
          let pilha2_temp2 = Pilha.push carta_p1 pilha2_temp1
          let pilha2_final = Pilha.invertePilha pilha2_temp2
          let (carta_perdida, pilha1_final)  = Pilha.pop pilha1
          threadDelay 8000000
          iniciaVsBot newMediaAtributos pilha1_final pilha2_final 2 (rodadaAtual + 1)
        
        else do
          putStrLn ("")
          putStrLn ("[PLAYER 1 VENCEDOR DA RODADA!]")
          let pilha1_temp1 = Pilha.invertePilha pilha1
          let pilha1_temp2 = Pilha.push carta_p2 pilha1_temp1
          let pilha1_final = Pilha.invertePilha pilha1_temp2
          let (carta_perdida, pilha2_final)  = Pilha.pop pilha2
          threadDelay 8000000
          iniciaVsBot newMediaAtributos pilha1_final pilha2_final 1 (rodadaAtual + 1)
      
  
  
  

iniciaVsP2 :: Pilha.Stack Cards.Carta -> Pilha.Stack Cards.Carta -> Int -> Int -> IO()
iniciaVsP2  pilha1 pilha2 playerAtual rodadaAtual = do
  clearScreen
  if Pilha.empty pilha1 then putStrLn ("FIM DE JOGO - PLAYER 2 VENCEU!! \nTOTAL DE RODADAS: " ++ show(rodadaAtual))
  else if Pilha.empty pilha2 then putStrLn ("FIM DE JOGO - PLAYER 1 VENCEU!! \nTOTAL DE RODADAS: " ++ show(rodadaAtual))
 
  else do
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
          threadDelay 8000000
          iniciaVsP2 pilha1_final pilha2_final 2 (rodadaAtual + 1)
        
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
          threadDelay 8000000
          iniciaVsP2 pilha1_final pilha2_final 1 (rodadaAtual + 1)
        
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
          threadDelay 8000000
          iniciaVsP2 pilha1_final pilha2_final 1 (rodadaAtual + 1)
        
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
          threadDelay 8000000
          iniciaVsP2 pilha1_final pilha2_final 2 (rodadaAtual + 1)

    else do
      putStrLn (Cards.toString (carta_p2))
      putStrLn ("")
    
      if Cards.isTrunfo carta_p2 then do
        putStrLn ("[EH TRUNFO]")
        if Cards.isA carta_p1 then do
          putStrLn ("")
          putStrLn ("Carta P1")
          putStrLn(Cards.toString (carta_p1))
          putStrLn ("")
          putStrLn ("[PLAYER 1 VENCEDOR DA RODADA!]")
          let pilha1_temp1 = Pilha.invertePilha pilha1
          let pilha1_temp2 = Pilha.push carta_p1 pilha1_temp1
          let pilha1_final = Pilha.invertePilha pilha1_temp2
          let (carta_perdida, pilha2_final)  = Pilha.pop pilha2
          threadDelay 8000000
          iniciaVsP2 pilha1_final pilha2_final 1 (rodadaAtual + 1)
        
        else do
          putStrLn ("")
          putStrLn ("Carta P1")
          putStrLn(Cards.toString (carta_p1))
          putStrLn ("")
          putStrLn ("[PLAYER 2 VENCEDOR DA RODADA!]")
          let pilha2_temp1 = Pilha.invertePilha pilha2
          let pilha2_temp2 = Pilha.push carta_p2 pilha2_temp1
          let pilha2_final = Pilha.invertePilha pilha2_temp2
          let (carta_perdida, pilha1_final)  = Pilha.pop pilha1
          threadDelay 8000000
          iniciaVsP2 pilha1_final pilha2_final 2 (rodadaAtual + 1)
        
      else do              
        putStrLn ("Escolha um Atributo " ++ Utils.atributos)
        atributo <- Utils.leAtributo
        let comparador = Cards.compara atributo carta_p1 carta_p2
        if comparador == 1 then do
          putStrLn ("")
          putStrLn ("Carta P1")
          putStrLn(Cards.toString (carta_p1))
          putStrLn ("")
          putStrLn ("[PLAYER 2 VENCEDOR DA RODADA!]")
          let pilha2_temp1 = Pilha.invertePilha pilha2
          let pilha2_temp2 = Pilha.push carta_p2 pilha2_temp1
          let pilha2_final = Pilha.invertePilha pilha2_temp2
          let (carta_perdida, pilha1_final)  = Pilha.pop pilha1
          threadDelay 8000000
          iniciaVsP2 pilha1_final pilha2_final 2 (rodadaAtual + 1)
        
        else do
          putStrLn ("")
          putStrLn ("Carta P1")
          putStrLn(Cards.toString (carta_p1))
          putStrLn ("")
          putStrLn ("[PLAYER 1 VENCEDOR DA RODADA!]")
          let pilha1_temp1 = Pilha.invertePilha pilha1
          let pilha1_temp2 = Pilha.push carta_p1 pilha1_temp1
          let pilha1_final = Pilha.invertePilha pilha1_temp2
          let (carta_perdida, pilha2_final)  = Pilha.pop pilha2
          threadDelay 8000000
          iniciaVsP2 pilha1_final pilha2_final 1 (rodadaAtual + 1)
        
        
  
 
  




  
  
 
