:- initialization main.
:- use_module(library(pio)).
:- include('Utils.pl').

main :-
    iniciar_cartas(La),
    write(La).


