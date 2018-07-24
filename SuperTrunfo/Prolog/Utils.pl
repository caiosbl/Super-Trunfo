:- include('Cards.pl').

iniciar_cartas(Cards) :-
    open('selecoes.txt', read, Str),
    read_file(Str,Cartas),
    map(map_card,Cartas,Cards),
    close(Str). 

iniciar_pilhas([H|T],Pilha1,Pilha2) :-
    reverse([H|T], Lista_Invertida),
    list_take([H|T],Lista1),
    list_take(Lista_Invertida,Lista2),
    stack(Lista1,Pilha1),
    stack(Lista2,Pilha2).

list_take([H|T],[[NH|NT]]) :-
    list_take_aux(0,[H|T],[NH|NT]).

list_take_aux(16,_,_).
list_take_aux(Index,[H|T],[NH|NT]) :-
    Index_1 is Index + 1,
    NH = H,
    list_take_aux(Index_1,T,NT).
    
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

print_n_lines(0):-!. 
print_n_lines(X):- 
    integer(X), 
    Y is X - 1, 
    nl, 
    print_n_lines(Y).