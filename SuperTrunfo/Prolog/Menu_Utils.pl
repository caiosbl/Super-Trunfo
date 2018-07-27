

show_banner :-
    open('banner.txt', read, Str),
    read_file(Str,String),
    close(Str),
    nl,nl,
    imprime(String),
    sleep(5),
    shell(clear).

show_creditos :-
    shell(clear),
    write('Desenvolvido por : \n
        Caio Sanches\n
        Thallyson Alves\n
        Daniel José\n
        Higor Ferreira\n
        Domingos Gabriel'),nl,
sleep(6),
menu.

show_opcoes :-
    write('[1] - INICIAR JOGO 1PLAYER'),nl,
    write('[2] - INICIAR JOGO 2PLAYERS'),nl,
    write('[3] - CREDITOS'),nl,
    write('[4] - SAIR'),nl,
    write('ESCOLHA UM OPCAO: '),nl.



imprime([]).
imprime([H|T]):- write(H),nl, imprime(T).



