:- include('Cards.pl').

iniciar_cartas(Cards) :-
    open('selecoes.txt', read, Str),
    read_file(Str,Cartas),
    random(0,32,Index_Trunfo),
    map(Index_Trunfo,map_card,Cartas,Cards),
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
    
map(Index,FunctionName,[H|T],[NH|NT]):-
   Function=..[FunctionName,Index,H,NH],
   call(Function),
   map(Index,FunctionName,T,NT).
map(_,_,[],[]).

read_file(Stream,[]) :-
    at_end_of_stream(Stream).

read_file(Stream,[X|L]) :-
    \+ at_end_of_stream(Stream),
    read_line_to_string(Stream, String),
    atomic_list_concat(X,' ', String),
    read_file(Stream,L), !.

map_card(Trunfo_Index,List_String,Card) :-
        nth0(0, List_String, String),
        split_string(String, ',', ' ,', List),
        nth0(0, List, Tipo),
        nth0(1, List, Nome),
        nth0(2, List, Ataque),
        nth0(3, List, Defesa),
        nth0(4, List, Meio),
        nth0(5, List, Titulos),
        nth0(6, List, Aparicoes_copas),
        nth0(7, List, Index),
        number_string(Index_Number, Index),
        eh_Trunfo(Index_Number,Trunfo_Index,Trunfo),
        build_carta(Tipo,Nome,Ataque,Defesa,Meio,Titulos,Aparicoes_copas,Trunfo,Card).

eh_Trunfo(Index,IndexCarta,Etrunfo):- (Index == IndexCarta -> Etrunfo = 1 ; Etrunfo = 0).

print_n_lines(0):-!. 
print_n_lines(X):- 
    integer(X), 
    Y is X - 1, 
    nl, 
    print_n_lines(Y).

string_equals(StringA,StringB,Equal) :-
  string_to_atom(StringA, Atom),
  string_to_atom(StringB, Atom2),
  (Atom == Atom2) -> Equal = 1; Equal = 0.

desempata(StringA,StringB,Comparator) :-
  (StringA @> StringB) -> Comparator = 1 ; Comparator = -1.