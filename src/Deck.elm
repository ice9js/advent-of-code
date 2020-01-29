module Deck exposing (..)

import List exposing (drop, foldl, foldr, indexedMap, length, map, range, reverse, sort, tail, take)
import Tuple exposing (second)

import Arithmetic exposing (lcm, modularInverse)

type Technique
    = Reverse
    | Cut Int
    | Increment Int

type LinearFunction
    = LF Int Int Int

fromTechnique: Int -> Technique -> LinearFunction
fromTechnique deckSize technique =
    case technique of
        Reverse -> LF -1 -1 deckSize
        Cut k -> LF 1 -k deckSize
        Increment k -> LF k 0 deckSize

apply: LinearFunction -> Int -> Int
apply func x =
    case func of
        LF a b deckSize -> modBy deckSize (a * x + b)

inverse: LinearFunction -> LinearFunction
inverse func =
    case func of
        LF a b deckSize ->
            let x = Maybe.withDefault 0 (modularInverse a deckSize)
            in
            LF x (modBy deckSize (x * (-b))) deckSize

compose: LinearFunction -> LinearFunction -> LinearFunction
compose f1 f2 =
    case (f1, f2) of
        -- make sure decksizes match
        (LF a1 b1 ds1, LF a2 b2 ds2) -> LF (modBy ds1 (a1 * a2)) (modBy ds1 (a2 * b1 + b2)) ds1

exp: Int -> LinearFunction -> LinearFunction
exp n func =
    case (n, func) of
        (0, LF _ _ deckSize) -> LF 1 0 deckSize -- identity
        (1, _) -> func
        _ ->
            let ff = exp (n // 2) func
            in
            if 1 == modBy 2 n then compose func (compose ff ff) else compose ff ff

calcPositionNormal: Int -> Int -> List Technique -> Int
calcPositionNormal position deckSize techniques =
    map (fromTechnique deckSize) techniques
        |> foldl compose (LF 1 0 deckSize)
        |> (\f -> apply f position)

calcPosition: Int -> List Technique -> Int
calcPosition deckSize techniques =
    map (fromTechnique deckSize) techniques
        |> foldl compose (LF 1 0 deckSize)
        |> exp 101741582076661
        |> inverse
        |> (\f -> apply f 2020)


-- many questions here:
-- a) what's a linear function :o
-- b) what is modularInverse
-- c) what am I even doing here
