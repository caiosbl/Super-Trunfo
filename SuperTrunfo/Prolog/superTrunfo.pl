:- initialization main.
:- use_module(library(pio)).
:- include('Utils.pl').
:- include('Pilha.pl').

main :-
    setup_jogo(Pilha1,Pilha2,Player_Inicia_Jogo),
    top(Pilha1,Top),
    write(''),nl,
    write(Top),nl,
    build_acumulador_atributos(1,0,0,0,0,0,Acumulador),
    escolhe_atributo_bot(Top,Acumulador,Atributo),
    write(Atributo).
    

setup_jogo(Pilha1,Pilha2,Player_Inicia_Jogo) :-
    print_n_lines(2),
    iniciar_cartas(Cartas),
    random_permutation(Cartas, Cartas_Embaralhas),
    write('>>> CARTAS EMBARALHADAS <<<'), nl,
    sleep(2),
    iniciar_pilhas(Cartas_Embaralhas,Pilha1,Pilha2),
    write('>>> PILHAS MONTADAS <<<'), nl,
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
        
        write(passou),nl,

       media_ata(Acumulador,Media_Ata),
       media_def(Acumulador,Media_Def),
       media_mei(Acumulador,Media_Mei),
       media_tit(Acumulador,Media_Tit),
       media_apa(Acumulador,Media_Apa),
       write(passou),nl,

       Dif_Ata is Ataque - Media_Ata,
       Dif_Def is Defesa - Media_Def,
       Dif_Mei is Meio - Media_Mei,
       Dif_Tit is Titulos - Media_Tit,
       Dif_Apa is Aparicoes - Media_Apa,

       write(passou),nl,
      escolhe_atributo_bot_aux(Dif_Ata,Dif_Def,Dif_Mei,Dif_Tit,Dif_Apa,Atributo Atributo).


escolhe_atributo_bot_aux(Dif_Ata,Dif_Def,Dif_Mei,Dif_Tit,Dif_Apa,Atributo) :-
    List = [Dif_Ata,Dif_Def,Dif_Mei,Dif_Tit,Dif_Apa],
    max_list(List, Max),
    (Dif_Ata >= Max -> Atributo = 'ATAQUE'
    ;Dif_Def >= Max -> Atributo = 'DEFESA'
    ;Dif_Mei >= Max -> Atributo = 'MEIO'
    ;Dif_Tit >= Max -> Atributo = 'TITULOS'
    ; Atributo = 'APARICOES').
    
    



    



