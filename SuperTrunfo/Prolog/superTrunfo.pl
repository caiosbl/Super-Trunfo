:- initialization main.
:- use_module(library(pio)).
:- use_module(library(Cards)).


main :-
    open('selecoes.txt', read, Str),
    read_file(Str,Lines),
    close(Str), 
    write(Lines), nl.


lines([])           --> call(eos), !.
lines([Line|Lines]) --> line(Line), lines(Lines).

eos([], []). 

line([])     --> ( "\n" ; call(eos) ), !.
line([L|Ls]) --> [L], line(Ls).

read_file(Stream,[]) :-
    at_end_of_stream(Stream).

read_file(Stream,[X|L]) :-
    \+ at_end_of_stream(Stream),
    read_line_to_codes(Stream,Codes),
    atom_chars(X, Codes),
    read_file(Stream,L), !.