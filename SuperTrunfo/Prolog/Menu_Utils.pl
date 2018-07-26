

show_banner :-
    open('banner.txt', read, Str),
    read_file(Str,String),
    close(Str),
    imprime(String),
    sleep(5),
    shell(clear).



imprime([]).
imprime([H|T]):- write(H),nl, imprime(T).



