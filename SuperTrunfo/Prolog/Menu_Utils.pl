

show_banner :-
    open('banner.txt', read, Str),
    read_file(Str,String),
    close(Str),
    imprime(String),
    sleep(5),
    shell(clear).

show_opcoes :-
    write('[1] - INICIAR JOGO 1PLAYER'),nl,
    write('[2] - INICIAR JOGO 2PLAYERS'),nl,
    write('[3] - CREDITOS'),nl,
    write('[4] - SAIR'),nl,
    write('ESCOLHA UM OPCAO: '),nl.



imprime([]).
imprime([H|T]):- write(H),nl, imprime(T).



