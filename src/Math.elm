module Math exposing (..)

import List exposing (append, concat, filter, map)

excludeNumber: List Int -> Int -> List Int
excludeNumber numbers excluded =
    filter (\n -> n /= excluded) numbers

permutate: List Int -> List (List Int)
permutate numbers =
    let
        appendNumber =
            (\n permutation -> append [n] permutation)
        permutateFor =
            (\range n -> map (appendNumber n) (permutate (excludeNumber range n)))
    in
    case numbers of
        [] -> []
        a::[] -> [[a]]
        _ -> concat (map (permutateFor numbers) numbers)
