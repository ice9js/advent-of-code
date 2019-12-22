module Deck exposing (..)

import List exposing (drop, foldr, indexedMap, length, map, range, reverse, sort, take)
import Tuple exposing (second)

type alias Deck = List Int

new = (range 0 10006)

dealIntoNewStack: Deck -> Deck
dealIntoNewStack deck =
    reverse deck

cut: Int -> Deck -> Deck
cut by deck =
    let n = modBy (length deck) (length deck + by)
    in
    (drop n deck) ++ (take n deck)

dealWithIncrement: Int -> Deck -> Deck
dealWithIncrement incrementBy deck =
    indexedMap (\i n -> (modBy (length deck) (i * incrementBy), n)) deck
        |> sort
        |> map second

shuffle: List (Deck -> Deck) -> Deck -> Deck
shuffle instructions deck =
    (foldr (>>) identity instructions) deck

-- Solution for part one: 1879
