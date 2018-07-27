stack([E|Es],Pilha) :-  nth0(0, [E|Es], Pilha).
empty([]).
pop(E, [E|Es],Es).
push(E, Es, [E|Es]).
top([E|_],E).