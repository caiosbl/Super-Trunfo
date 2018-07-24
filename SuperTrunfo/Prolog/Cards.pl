
build_carta(Tipo,Nome,Ataque,Defesa,Meio,Titulos,Aparicoes_copas,Is_trunfo,carta(Tipo,Nome,Ataque,Defesa,Meio,Titulos,Aparicoes_copas,Is_trunfo)).

get_tipo(carta(Tipo,_,_,_,_,_,_,_),Tipo).
get_nome(carta(_,Nome,_,_,_,_,_,_),Nome).
get_ataque(carta(_,_,Ataque,_,_,_,_,_),Ataque).
get_defesa(carta(_,_,_,Defesa,_,_,_,_),Defesa).
get_meio(carta(_,_,_,_,Meio,_,_,_),Meio).
get_titulos(carta(_,_,_,_,_,Titulos,_,_),Titulos).
get_aparicoes_copa(carta(_,_,_,_,_,_,Aparicoes_copas,_),Aparicoes_copas).
get_is_trunfo(carta(_,_,_,_,_,_,_,Is_trunfo),Is_trunfo).


is_trunfo(Carta,Is) :- get_is_trunfo(Carta) == 1 -> Is = true ; Is = false.


show_carta(Carta) :-
  write('') ,nl,

  get_tipo(Carta,Tipo_),
  get_nome(Carta,Nome_),
  get_defesa(Carta,Defesa_),
  get_meio(Carta,Meio_),
  get_ataque(Carta,Ataque_),
  get_titulos(Carta,Titulos_),
  get_aparicoes_copa(Carta,Aparicoes_),
  is_trunfo(Carta,Trunfo),

  string_concat('Tipo: ', Tipo_, Tipo),
  string_concat('Nome: ', Nome_, Nome),
  string_concat('Defesa: ', Defesa_, Defesa),
  string_concat('Meio: ', Meio_, Meio),
  string_concat('Ataque: ', Ataque_, Ataque),
  string_concat('Titulos: ',Titulos_, Titulos),
  string_concat('Aparicoes Copas: ',Aparicoes_ ,Aparicoes),
  

  write(Tipo),nl,
  write(Nome),nl,
  write(Defesa),nl,
  write(Meio),nl,
  write(Ataque),nl,
  write(Titulos),nl,
  write(Aparicoes),nl,
  Trunfo -> write('[É TRUNFO]') ; write('').

