
build_carta(Tipo,Nome,Ataque,Defesa,Meio,Titulos,Aparicoes_copas,Is_trunfo,carta(Tipo,Nome,Ataque,Defesa,Meio,Titulos,Aparicoes_copas,Is_trunfo)).

get_tipo(carta(Tipo,_,_,_,_,_,_,_),Tipo).
get_nome(carta(_,Nome,_,_,_,_,_,_),Nome).
get_ataque(carta(_,_,Ataque,_,_,_,_,_),Ataque).
get_defesa(carta(_,_,_,Defesa,_,_,_,_),Defesa).
get_meio(carta(_,_,_,_,Meio,_,_,_),Meio).
get_titulos(carta(_,_,_,_,_,Titulos,_,_),Titulos).
get_aparicoes_copa(carta(_,_,_,_,_,_,Aparicoes_copas,_),Aparicoes_copas).
get_is_trunfo(carta(_,_,_,_,_,_,_,Is_trunfo),Is_trunfo).

show_carta(Carta) :-
    write('') ,nl,
    get_tipo(Carta,Tipo_),
    get_nome(Carta,Nome_),
    get_defesa(Carta,Defesa_),
    get_meio(Carta,Meio_),
    get_ataque(Carta,Ataque_),
    get_titulos(Carta,Titulos_),
    get_aparicoes_copa(Carta,Aparicoes_),
    Trunfo = is_trunfo(Carta),
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

is_trunfo(carta(_,_,_,_,_,_,_,1)).

string_equals(StringA,StringB,Equal) :-
    string_to_atom(StringA, Atom),
    string_to_atom(StringB, Atom2),
    ((Atom == Atom2) -> Equal = 1; Equal = 0).

is_A(Carta,Is) :- 
  get_tipo(Carta,Tipo),
  sub_string(Tipo, 0, 1, 1, SubString),
  string_equals('A',SubString,Is).




build_acumulador_atributos(Cont,Ac_Ataque,Ac_Defesa,Ac_Meio,Ac_Titulos,Ac_Aparicoes,
  acumulador_atributos(Cont,Ac_Ataque,Ac_Defesa,Ac_Meio,Ac_Titulos,Ac_Aparicoes)).

get_acu_cont(media_atributos(Cont,_,_,_,_,_),Cont).
get_acu_ata(media_atributos(_,Ac_Ataque,_,_,_,_),Ac_Ataque).
get_acu_def(media_atributos(_,_,Ac_Defesa,_,_,_),Ac_Defesa).
get_acu_mei(media_atributos(_,_,_,Ac_Meio,_,_),Ac_Meio).
get_acu_tit(media_atributos(_,_,_,_,Ac_Titulos,_),Ac_Titulos).
get_acu_apa(media_atributos(_,_,_,_,_,Ac_Aparicoes),Ac_Aparicoes).


update_acumulador(Acumulador,Carta) :-
  get_acu_cont(Acumulador,Cont),
  get_acu_ata(Acumulador,Ata),
  get_acu_def(Acumulador,Def),
  get_acu_mei(Acumulador,Mei),
  get_acu_tit(Acumulador,Tit),
  get_acu_apa(Acumulador,Apa),

  get_ataque(Carta,Ata_),
  get_defesa(Carta,Def_),
  get_meio(Carta,Mei_),
  get_titulos(Carta,Tit_),
  get_aparicoes_copa(Carta,Apa_),

  Con is Cont + 1,
  Ataque is Ata + Ata_,
  Defesa is Def + Def_,
  Meio is Mei + Mei_,
  Titulos is Tit + Tit_,
  Aparicoes is Apa + Apa_,

  Acumulador = build_acumulador_atributos(Con,Ataque,Defesa,Meio,Titulos,Aparicoes).


media_ata(Acumulador,Media) :-
  get_acu_ata(Acumulador,Ata),
  get_acu_cont(Acumulador,Cont),
  Media is Ata / Cont.

media_def(Acumulador,Media) :-
    get_acu_def(Acumulador,Def),
    get_acu_cont(Acumulador,Cont),
    Media is Def / Cont.

media_mei(Acumulador,Media) :-
    get_acu_mei(Acumulador,Mei),
    get_acu_cont(Acumulador,Cont),
    Media is Mei / Cont.

media_tit(Acumulador,Media) :-
    get_acu_tit(Acumulador,Tit),
    get_acu_cont(Acumulador,Cont),
    Media is Tit / Cont.

media_apa(Acumulador,Media) :-
    get_acu_apa(Acumulador,Apa),
    get_acu_cont(Acumulador,Cont),
    Media is Apa / Cont.


desempata(StringA,StringB,Comparator) :-
    (StringA @> StringB) -> Comparator = 1 ; Comparator = -1.

compara_cartas(Carta1,Carta2,Atributo,Comparador) :-
    string_equals(Atributo,'ATAQUE',Ataque_eq),
    string_equals(Atributo,'DEFESA',Defesa_eq),
    string_equals(Atributo,'MEIO',Meio_eq),
    string_equals(Atributo,'TITULOS',Titulos_eq),

    get_ataque(Carta1,Ataque_1),
    number_string(Ataque1, Ataque_1),

    get_ataque(Carta2,Ataque_2),
    number_string(Ataque2, Ataque_2),

    get_meio(Carta1,Meio_1),
    number_string(Meio1, Meio_1),

    get_meio(Carta2,Meio_2),
    number_string(Meio2, Meio_2),

    get_defesa(Carta1,Defesa_1),
    number_string(Defesa1, Defesa_1),

    get_defesa(Carta2,Defesa_2),
    number_string(Defesa2, Defesa_2),

    get_titulos(Carta1,Titulos_1),
    number_string(Titulos1, Titulos_1),

    get_titulos(Carta2,Titulos_2),
    number_string(Titulos2, Titulos_2),

    get_aparicoes_copa(Carta1,Aparicoes_1),
    number_string(Aparicoes1, Aparicoes_1),

    get_aparicoes_copa(Carta2,Aparicoes_2),
    number_string(Aparicoes2, Aparicoes_2),

    get_tipo(Carta1,Tipo1),
    get_tipo(Carta2,Tipo2),
    desempata(Tipo1,Tipo2,Desempate),

(Ataque_eq == 1) -> (((Ataque1 - Ataque2) \= 0) -> Comparador is (Ataque1 - Ataque2) ; Comparador = Desempate)
; Defesa_eq == 1 -> 
  ((Defesa1 - Defesa2) \= 0) -> Comparador is (Defesa1 - Defesa2) ; Comparador = Desempate
; (Meio_eq == 1) -> (((Meio1 - Meio2) \= 0) -> Comparador is (Meio1 - Meio2) ; Comparador = Desempate)
; (Titulos_eq == 1) -> (((Titulos1 - Titulos2) \= 0) -> Comparador is (Titulos1 - Titulos2) ; Comparador = Desempate)
; (((Aparicoes1 - Aparicoes2) \= 0) -> Comparador is (Aparicoes1 - Aparicoes2) ; Comparador = Desempate).
   

