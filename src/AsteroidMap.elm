module AsteroidMap exposing (..)

import Array exposing (Array, get)
import Dict exposing (Dict, keys, update)
import List exposing (filterMap, foldl, foldr, head, isEmpty, length, map, sort, tail)
import Set exposing (Set)
import String exposing (split, trim)
import Tuple exposing (mapBoth, first, second)

type alias Polar = (Float, Float)

type alias Asteroid = (Int, Int)

type alias AsteroidMap = Dict Float (List Float)

parsePoint: Int -> Int -> String -> Maybe Asteroid
parsePoint x y value =
    case value of
        "#" -> Just (x, y)
        _ -> Nothing

parseRow: Int -> Int -> List String -> List (Maybe Asteroid)
parseRow x y points =
    case points of
        p::rest -> [parsePoint x y p] ++ (parseRow (x + 1) y rest)
        [] -> []

parseMap: Int -> List (List String) -> List (Maybe Asteroid)
parseMap y rows =
    case rows of
        r::rest -> (parseRow 0 y r) ++ (parseMap (y + 1) rest)
        [] -> []

fromString: String -> List Asteroid
fromString src =
    map (trim >> (split "")) (split "\n" (trim src))
        |> parseMap 0
        |> filterMap identity

getRelativePosition: Asteroid -> Asteroid -> Maybe Polar
getRelativePosition (x, y) asteroid =
    let substractFrom = (\n -> ((-) n) >> toFloat)
    in
    case (x, y) == asteroid of
        True -> Nothing
        _ -> Just (toPolar (mapBoth (substractFrom x) (substractFrom y) asteroid))

getAbsolutePosition: Asteroid -> Polar -> Asteroid
getAbsolutePosition (x, y) coordinates =
    let addTo = (\n -> round >> ((+) n))
    in
    mapBoth (addTo x) (addTo y) (fromPolar coordinates)

buildMap: List Polar -> AsteroidMap
buildMap coordinates =
    case coordinates of
        (distance, angle)::rest -> update angle (\v -> Just ([distance] ++ (Maybe.withDefault [] v))) (buildMap rest)
        [] -> Dict.empty

initMap: List Asteroid -> Asteroid -> AsteroidMap
initMap asteroids origin =
    filterMap (getRelativePosition origin) asteroids
        |> buildMap
        |> Dict.map (\_ distances -> sort distances)

findMostVisibleAsteroids: List Asteroid -> Int
findMostVisibleAsteroids asteroids =
    let numberOfVisibleAsteroids = (initMap asteroids) >> keys >> length
    in
    map numberOfVisibleAsteroids asteroids
        |> foldl max 0
