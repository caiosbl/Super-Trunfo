:- initialization main.
:- use_module(library(pio)).
:- include('Cards.pl').
:- include('Utils.pl').



main :-
    open('selecoes.txt', read, Str),
    read_file(Str,Lines),
    close(Str),
    write(Lines),nl.
