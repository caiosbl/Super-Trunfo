:- initialization main.
:- use_module(library(pio)).
:- include('Utils.pl').
:- include('Pilha.pl').
:- include('Menu_Utils.pl').

main :-
    show_banner,
    menu.


menu :-
    show_opcoes,
    read_opcao(Opcao),
    select_opcao(Opcao).

read_opcao(Opcao) :-
  read(Option),
  (valida_opcao(Option) -> Opcao = Option ; read_opcao(Opcao)).

valida_opcao(1).
valida_opcao(2).
valida_opcao(3).
valida_opcao(4).

select_opcao(1) :- 
setup_jogo(Pilha1,Pilha2,Player_Inicia_Jogo,Acumulador),
inicia_jogo_1p(Pilha1,Pilha2,Player_Inicia_Jogo,Acumulador,1).

select_opcao(2) .
select_opcao(3) .
select_opcao(4) :- halt(0).

inicia_jogo_1p(Pilha1,Pilha2,Player_Atual,Acumulador,Rodada) :-
    number_string(Rodada,Rodada_String),
    length(Pilha1, Size1),
    length(Pilha2,Size2),
    number_string(Size1, Placar1),
    number_string(Size2,Placar2),
    number_string(Player_Atual,Player_String),
    

    string_concat('FIM DE JOGO PLAYER 1 VENCEU!!! TOTAL DE RODADAS: ',Rodada_String, P1_Venceu),
    string_concat('FIM DE JOGO PLAYER 2 VENCEU!!! TOTAL DE RODADAS: ',Rodada_String, P2_Venceu),
    string_concat('Placar: P1 ', Placar1,Top1),
    string_concat(Top1,' x P2 ',Top2),
    string_concat(Top2,Placar2,Top3),
    string_concat(Top3,' - Rodada Atual: ',Top4),
    string_concat(Top4,Rodada_String,Top),
    
    (empty(Pilha1) -> write(P2_Venceu),nl
    ; empty(Pilha2) -> write(P1_Venceu),nl
    ;
    top(Pilha1,Carta1),
    top(Pilha2,Carta2),
    write(Top),nl,nl, 
    write('[Nova Jogada]'),nl,write('Player Atual: '), write(Player_String),nl,
    show_carta_aux(Player_Atual,Carta1,Carta2),nl,
    
    check_trunfo(Player_Atual,Carta1,Carta2,Is_Trunfo,Comparador),
    (Is_Trunfo == 1 -> Comp = Comparador 
     ; escolhe_atributo(Player_Atual,Atributo,Carta2,Acumulador),
     comparador_aux(Player_Atual,Carta1,Carta2,Atributo,Comp)),nl,

    show_carta_aux(Player_Atual,Carta2,Carta1),nl,
    ganha_carta(Comp,Pilha1,Pilha2,Player_Atual,NextPlayer),
    sleep(2),
    inicia_jogo_1p(Pilha1,Pilha2,NextPlayer,Acumulador,Rodada + 1)).


ganha_carta(Comp,Pilha1,Pilha2,1,NextPlayer) :-
  (Comp > 0 -> write('PLAYER 1 VENCEU A RODADA!!!'),nl,
  ganha_carta_aux(Pilha1,Pilha2),
  NextPlayer = 1
  ; write('PLAYER 2 VENCEU A RODADA!!!'),nl,
  ganha_carta_aux(Pilha2,Pilha1),
  NextPlayer = 2
).

ganha_carta(Comp,Pilha1,Pilha2,2,NextPlayer) :-
        (Comp > 0 -> write('PLAYER 2 VENCEU A RODADA!!!'),nl,
        ganha_carta_aux(Pilha2,Pilha1), NextPlayer = 2
        ; write('PLAYER 1 VENCEU A RODADA!!!'),nl,
        ganha_carta_aux(Pilha1,Pilha2),NextPlayer = 1
      ).


ganha_carta_aux(Pilha1,Pilha2) :-
    pop(Removida,Pilha2,Pilha2),
    pop(Topo,Pilha1,Pilha1_),
    reverse(Pilha1_, Pilha1_In),
    push(Topo,Pilha1_In,Pilha1_In_),
    push(Removida,Pilha1_In_,Pilha1_A),
    reverse(Pilha1_A,Pilha1).
   


comparador_aux(1,Carta1,Carta2,Atributo,Comparador) :- compara_cartas(Carta1,Carta2,Atributo,Comparador).
comparador_aux(2,Carta1,Carta2,Atributo,Comparador) :- compara_cartas(Carta2,Carta1,Atributo,Comparador).

check_trunfo(1,Carta1,Carta2,Is,Comparador) :-
    (is_trunfo(Carta1) -> Is = 1,
    check_trunfo_aux(Carta2,Comparador)
; Is = 0).
check_trunfo(2,Carta1,Carta2,Is,Comparador) :-
        (is_trunfo(Carta2) -> Is = 1,
        check_trunfo_aux(Carta1,Comparador)
    ; Is = 0).

check_trunfo_aux(Carta2,Comparador) :-
    is_A(Carta2,Is),
(Is == 1 -> Comparador = -1 ; Comparador = 1).

escolhe_atributo(1,Atributo,_,_) :- escolhe_atributo_user(Atributo).
escolhe_atributo(2,Atributo,Carta2,Acumulador) :- 
    escolhe_atributo_bot(Carta2,Acumulador,Atributo),
    string_concat('Atributo Escolhido: ',Atributo,String),
    write(String),nl.

escolhe_atributo_user(Atributo) :-
    write('ESCOLHA UM ATRIBUTO: [1]ATAQUE - [2]DEFESA - [3]MEIO - [4]TITULOS - [5]APARICOES COPA'),nl,
    le_atributo(Leitura),
    select_atributo(Leitura,Atributo).

select_atributo(1,Atributo) :- Atributo = 'ATAQUE'.
select_atributo(2,Atributo) :- Atributo = 'DEFESA'.
select_atributo(3,Atributo) :- Atributo = 'MEIO'.
select_atributo(4,Atributo) :- Atributo = 'TITULOS'.
select_atributo(5,Atributo) :- Atributo = 'APARICOES'.


le_atributo(Atributo) :-
    read(Read),
    (valida_atributo(Read) -> Atributo = Read ; le_atributo(Atributo)).

valida_atributo(1).
valida_atributo(2).
valida_atributo(3).
valida_atributo(4).
valida_atributo(5).


    
show_carta_aux(1,Carta1,_) :- show_carta(Carta1).
show_carta_aux(2,_,Carta2) :- show_carta(Carta2).
    
setup_jogo(Pilha1,Pilha2,Player_Inicia_Jogo,Acumulador) :-
    print_n_lines(2),
    iniciar_cartas(Cartas),
    random_permutation(Cartas, Cartas_Embaralhas),
    write('>>> CARTAS EMBARALHADAS <<<'), nl,
    sleep(2),
    iniciar_pilhas(Cartas_Embaralhas,Pilha1,Pilha2),
    write('>>> PILHAS MONTADAS <<<'), nl,
    build_acumulador_atributos(1,0,0,0,0,0,Acumulador),
    sleep(2),
    random(1, 3, Player_Inicia_Jogo),
    string_concat('>>> PLAYER ', Player_Inicia_Jogo, P_Inicia1),
    string_concat(P_Inicia1,' INICIA O JOGO <<<', P_Inicia),
    write(P_Inicia), nl,
    sleep(2).

escolhe_atributo_bot(Carta,Acumulador,Atributo) :-
        get_ataque(Carta,Ataque_),
        number_string(Ataque, Ataque_),
        get_meio(Carta,Meio_),
        number_string(Meio, Meio_),
        get_defesa(Carta,Defesa_),
        number_string(Defesa, Defesa_),
        get_titulos(Carta,Titulos_),
        number_string(Titulos, Titulos_),
        get_aparicoes_copa(Carta,Aparicoes_),
        number_string(Aparicoes, Aparicoes_),
        
       media_ata(Acumulador,Media_Ata),
       media_def(Acumulador,Media_Def),
       media_mei(Acumulador,Media_Mei),
       media_tit(Acumulador,Media_Tit),
       media_apa(Acumulador,Media_Apa),

       Dif_Ata is Ataque - Media_Ata,
       Dif_Def is Defesa - Media_Def,
       Dif_Mei is Meio - Media_Mei,
       Dif_Tit is Titulos - Media_Tit,
       Dif_Apa is Aparicoes - Media_Apa,

      escolhe_atributo_bot_aux(Dif_Ata,Dif_Def,Dif_Mei,Dif_Tit,Dif_Apa,Atributo).


escolhe_atributo_bot_aux(Dif_Ata,Dif_Def,Dif_Mei,Dif_Tit,Dif_Apa,Atributo) :-
    List = [Dif_Ata,Dif_Def,Dif_Mei,Dif_Tit,Dif_Apa],
    max_list(List, Max),
    (Dif_Ata >= Max -> Atributo = 'ATAQUE'
    ;Dif_Def >= Max -> Atributo = 'DEFESA'
    ;Dif_Mei >= Max -> Atributo = 'MEIO'
    ;Dif_Tit >= Max -> Atributo = 'TITULOS'
    ; Atributo = 'APARICOES').

