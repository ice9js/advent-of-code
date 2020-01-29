module BigDeck exposing (..)

import List exposing (foldl, foldr, map, range)
import Tuple exposing (mapBoth)

import Arithmetic exposing (modularInverse)

type alias Position = Int

type alias Permuation = (Int, Int)

deckSize = 119315717514047
--deckSize = 10007
--deckSize = 10

dealIntoNewStack: Position -> Position
dealIntoNewStack position =
    modBy deckSize ((negate position) - 1)

cut: Int -> Position -> Position
cut by position =
    modBy deckSize (position + by)

dealWithIncrement: Int -> Position -> Position
dealWithIncrement increment position =
    Maybe.withDefault 1 (modularInverse increment deckSize)
        |> ((*) position)
        |> modBy deckSize

exp: Int -> (a -> a) -> (a -> a)
exp n func =
    case n of
        0 -> identity
        1 -> func
        _ ->
            let ff = exp (n // 2) func
            in
            if 1 == modBy 2 n then func >> (ff >> ff) else (ff >> ff)

reverse: List (Position -> Position) -> Position -> Position
reverse instructions position =
    (foldl (>>) identity instructions) position

repeat: Int -> (Position -> Position) -> Position -> Position
repeat n shuffle position =
    case n of
        0 -> position
        1 -> shuffle position
        _ ->
            let
                tmp =
                    repeat (n // 2) shuffle position
                combined =
                    repeat (n // 2) shuffle tmp
            in
            if 1 == modBy 2 n then shuffle combined else combined
