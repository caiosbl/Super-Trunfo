module Cards where


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
                                      

toString:: Carta -> String
toString (Carta {tipo = tip, nome = nom, ataque = ata,
 defesa = def, meio = mei, titulos = tit, aparicoes_copas = apa, is_trunfo = is}) = 
    "Tipo: " ++ tip ++ "\n" ++
                       "Selecao: " ++ nom ++ "\n" ++
                       "Ataque: " ++ show(ata) ++ "\n" ++
                       "Meio: " ++ show(mei) ++ "\n" ++
                       "Defesa: " ++ show(def) ++ "\n" ++
                       "Titulos: " ++ show(tit) ++ "\n" ++
                       "Aparicoes em Copas: " ++  show(apa) ++ "\n" ++
                       if is then "É TRUNFO" else ""
isA :: Carta -> Bool
isA carta = if (take 1 (tipo carta)) == "A"
            then True
            else False
            
            
isTrunfo :: Carta -> Bool
isTrunfo carta = is_trunfo carta
            
                                                  
desempata :: Carta -> Carta -> Int
desempata carta1 carta2 = if (tipo carta1) < (tipo carta2) then 1 else -1


compara :: String -> Carta -> Carta -> Int
compara atributo carta1 carta2 
  | (atributo) == "ATAQUE" && (ataque1 - ataque2) > 0 = 1
  | (atributo) == "ATAQUE" && (ataque1 - ataque2) < 0 = -1
  | (atributo) == "ATAQUE" && (ataque1 - ataque2) == 0 = desempata carta1 carta2
  | (atributo) == "DEFESA" && (defesa1 - defesa2) > 0 = 1
  | (atributo) == "DEFESA" && (defesa1 - defesa2) < 0 = -1
  | (atributo) == "DEFESA" && (defesa1 - defesa2) == 0 = desempata carta1 carta2
  | (atributo) == "MEIO" && (meio1 - meio2) > 0 = 1
  | (atributo) == "MEIO" && (meio1 - meio2) < 0 = -1
  | (atributo) == "MEIO" && (meio1 - meio2) == 0 = desempata carta1 carta2
  | (atributo) == "TITULOS" && (titulos1 - titulos2) > 0 = 1
  | (atributo) == "TITULOS" && (titulos1 - titulos2) < 0 = -1
  | (atributo) == "TITULOS" && (titulos1 - titulos2) == 0 = desempata carta1 carta2
  | (atributo) == "APARICOES_COPAS" && (aparicoes_copa1 - aparicoes_copa2) > 0 = 1
  | (atributo) == "APARICOES_COPAS" && (aparicoes_copa1 - aparicoes_copa2) < 0 = -1
  | (atributo) == "APARICOES_COPAS" && (aparicoes_copa1 - aparicoes_copa2) == 0 = desempata carta1 carta2
  where (ataque1,ataque2, defesa1,defesa2, meio1,meio2, titulos1,titulos2,aparicoes_copa1,aparicoes_copa2) = ((ataque carta1), (ataque carta2),(defesa carta1),(defesa carta2),(meio carta1),(meio carta2),(titulos carta1),(titulos carta2),(aparicoes_copas carta1),(aparicoes_copas carta2))                                     
                                      
mediaAtaque :: MediaAtributos -> Int
mediaAtaque mediaAtributos = (acumulador_ataque mediaAtributos) `div` (contador mediaAtributos)

mediaDefesa :: MediaAtributos -> Int
mediaDefesa mediaAtributos = (acumulador_defesa mediaAtributos) `div` (contador mediaAtributos)

mediaMeio :: MediaAtributos -> Int
mediaMeio mediaAtributos = (acumulador_meio mediaAtributos) `div` (contador mediaAtributos)

mediaTitulos :: MediaAtributos -> Int
mediaTitulos mediaAtributos = (acumulador_titulos mediaAtributos) `div` (contador mediaAtributos)

mediaAparicoesCopa :: MediaAtributos -> Int
mediaAparicoesCopa mediaAtributos = (acumulador_aparicoes_copas mediaAtributos) `div` (contador mediaAtributos)


atualizaMediaAtributos :: Carta -> MediaAtributos -> MediaAtributos
atualizaMediaAtributos carta mediaAtributos =
   MediaAtributos { contador = (contador mediaAtributos) + 1,
    acumulador_ataque = (acumulador_ataque mediaAtributos) + (ataque carta),
    acumulador_defesa = (acumulador_defesa mediaAtributos) + (defesa carta), 
    acumulador_meio = (acumulador_meio mediaAtributos) + (meio carta),
    acumulador_titulos = (acumulador_titulos mediaAtributos) + (titulos carta),
    acumulador_aparicoes_copas = (acumulador_aparicoes_copas mediaAtributos) + (aparicoes_copas carta)}
    




