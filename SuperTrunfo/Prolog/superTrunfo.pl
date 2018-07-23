:- initialization main.
:- use_module(library(pio)).
:- include('Utils.pl').

main :-
    iniciar_cartas(La),
    map(map_card,La,Cartas),
    write(Cartas),
    halt(0). 


