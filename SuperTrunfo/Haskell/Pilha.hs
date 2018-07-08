module Pilha where

type Stack a = [a]
 
create :: Stack a
create  = []
 
push :: a -> Stack a -> Stack a
push = (:)
 
pop :: Stack a -> (a, Stack a)
pop []     = error "Stack empty"
pop (x:xs) = (x,xs)
 
empty :: Stack a -> Bool
empty = null

size :: Stack a -> Int
size pilha = length pilha
 
peek :: Stack a -> a
peek []    = error "Stack empty"
peek (x:_) = x

invertePilha :: Stack a -> Stack a
invertePilha pilha = reverse pilha



