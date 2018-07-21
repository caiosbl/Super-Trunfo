:- module(Cards, [build_carta/1,get_tipo/1,get_nome/1,
    get_ataque/1,get_defesa/1,get_meio/1,get_titulos/1,
    get_aparicoes_copa/1,get_is_trunfo/1 ]).

build_carta(Tipo,Nome,Ataque,Defesa,Meio,Titulos,Aparicoes_copas,Is_trunfo,
    carta(Tipo,Nome,Ataque,Defesa,Meio,Titulos,Aparicoes_copas,Is_trunfo)).

get_tipo(carta(Tipo,_,_,_,_,_,_,_),Tipo).
get_nome(carta(_,Nome,_,_,_,_,_,_),Nome).
get_ataque(carta(_,_,Ataque,_,_,_,_,_),Ataque).
get_defesa(carta(_,_,_,Defesa,_,_,_,_),Defesa).
get_meio(carta(_,_,_,_,Meio,_,_,_),Meio).
get_titulos(carta(_,_,_,_,_,Titulos,_,_),Titulos).
get_aparicoes_copa(carta(_,_,_,_,_,_,Aparicoes_copas,_),Aparicoes_copas).
get_is_trunfo(carta(_,_,_,_,_,_,_,Is_trunfo),Is_trunfo).