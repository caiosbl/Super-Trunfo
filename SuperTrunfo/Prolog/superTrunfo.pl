:- initialization main.
:- use_module(library(pio)).
:- include('Utils.pl').
:- include('Pilha.pl').

main :-
    setup_jogo(Pilha1,Pilha2,Player_Inicia_Jogo),
    nth0(0, Pilha1, Carta),
    show_carta(Carta).
    



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
    



    



