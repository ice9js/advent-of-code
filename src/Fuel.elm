module Fuel exposing (..)

--import Basics exposing (min)
import Array exposing (Array, get)
import Dict exposing (Dict)
import List exposing (foldl, map, sum, range)
import Tuple exposing (first, mapFirst, mapSecond, second)

type Substance
    = Product String Int (List (Int, Substance))
    | Ore

--type alias Requirements = List (Int, Substance)

getRecipeFor: List ((Int, String), List (Int, String)) -> String -> Maybe ((Int, String), List (Int, String))
getRecipeFor products label =
    case products of
        ((n, l), recipe)::rest -> if l == label then Just ((n, l), recipe) else getRecipeFor rest label
        [] -> Nothing

parseInput: List ((Int, String), List (Int, String)) -> String -> Substance
parseInput input label =
    let recipe = getRecipeFor input label
    in
    case recipe of
        Just ((n,_), reagents) -> Product label n (map (mapSecond (parseInput input)) reagents)
        Nothing -> Ore

minOreRequired: Int -> Dict String Int -> Substance -> (Int, Dict String Int)
minOreRequired amount available substance =
    case substance of
        Product label nResult reagents ->
            let
                nAvailable =
                    min (Maybe.withDefault 0 (Dict.get label available)) amount
                actualRequired =
                    amount - nAvailable
                multiplier =
                    ceiling ((toFloat actualRequired) / (toFloat nResult))
                actualProduced =
                    nResult * multiplier
                nLeftOver =
                    actualProduced - actualRequired
                updatedAvailable =
                    Dict.update label (\v -> Just ((Maybe.withDefault 0 v) - nAvailable)) available
            in
            foldl (\(n, reagent) (ore, leftover) -> mapFirst (\sum -> ore + sum) (minOreRequired (n * multiplier) leftover reagent)) (0, updatedAvailable) reagents
                |> mapSecond (Dict.update label (\v -> Just (nLeftOver + Maybe.withDefault 0 v)))
        Ore -> (amount, available)

-- solution for part two between 843 671 and probably less than 1 000 000

search: (Int -> Order) -> Array Int -> Int
search test values =
    let
        middle =
            (Array.length values) // 2
        current =
            Maybe.withDefault 0 (get middle values)
    in
    case (middle == 0, test current) of
        (_, EQ) -> current
        (True, _) -> current
        (_, LT) -> search test (Array.slice 0 middle values)
        (_, GT) -> search test (Array.slice middle (Array.length values) values)

-- 1376631 is the answer but this doesn't work (search)
maxForOre: Int -> Substance -> Int
maxForOre amount substance =
    let
        (orePerSubstanceUnit, _) =
            minOreRequired 1 Dict.empty substance
        lower =
            amount // orePerSubstanceUnit
        upper =
            lower * 2
        test =
            (\n -> compare (first (minOreRequired n Dict.empty substance)) amount)
    in
    search test (Array.fromList (range lower upper))



