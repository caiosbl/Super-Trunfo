:- initialization main.
:- use_module(library(pio)).
:- include('Utils.pl').
:- include('Pilha.pl').

main :-
    iniciar_cartas(Cartas),
    iniciar_pilhas(Cartas,Pilha1,Pilha2),
    write(Pilha1),nl,nl,
    write(Pilha2),nl,nl.



