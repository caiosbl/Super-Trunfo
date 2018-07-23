:- include('Cards.pl').


iniciar_cartas(Cartas) :-
    open('selecoes.txt', read, Str),
    read_file(Str,Cartas),
    close(Str). 

map(FunctionName,[H|T],[NH|NT]):-
   Function=..[FunctionName,H,NH],
   call(Function),
   map(FunctionName,T,NT).
map(_,[],[]).

read_file(Stream,[]) :-
    at_end_of_stream(Stream).

read_file(Stream,[X|L]) :-
    \+ at_end_of_stream(Stream),
    read_line_to_string(Stream, String),
    atomic_list_concat(X,' ', String),
    read_file(Stream,L), !.

map_card(List_String,Card1) :-
        nth0(0, List_String, String),
        split_string(String, ',', ' ,', List),
        nth0(0, List, Tipo),
        nth0(1, List, Nome),
        nth0(2, List, Ataque),
        nth0(3, List, Defesa),
        nth0(4, List, Meio),
        nth0(5, List, Titulos),
        nth0(6, List, Aparicoes_copas),
        build_carta(Tipo,Nome,Ataque,Defesa,Meio,Titulos,Aparicoes_copas,0,Card),
        Card1 = Card.