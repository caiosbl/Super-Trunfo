let NUMERO_CARTAS = 32
Cartas::[Carta]

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
  let carta = Carta {tipo = "A1", nome = "Brasil", ataque = 87, defesa = 86, meio = 50,
  titulos = 6, aparicoes_copas = 7, is_trunfo = True}
   
  putStrLn (toStringCarta carta)



iniciarCartas :: IO() -> [Carta]

iniciarCartas =
    file <- readFile "/selecoes.txt"