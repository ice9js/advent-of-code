module AsteroidMap exposing (..)

import Array exposing (Array, get)
import Dict exposing (Dict, update)
import List exposing (drop, filterMap, head, isEmpty, length, map, reverse, sort, sortBy)
import String exposing (split, trim)
import Tuple exposing (mapBoth)

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
    let substract = (\a b -> toFloat (b - a))
    in
    case (x, y) == asteroid of
        True -> Nothing
        _ -> Just (toPolar (mapBoth (substract x) (substract y) asteroid))

getAbsolutePosition: Asteroid -> Maybe Polar -> Maybe Asteroid
getAbsolutePosition (x, y) coordinates =
    let addTo = (\a b -> a + (round b))
    in
    case coordinates of
        Just c -> Just (mapBoth (addTo x) (addTo y) (fromPolar c))
        Nothing -> Nothing

turnsToVertical: Float -> Float
turnsToVertical angle =
    case angle < -0.5 * pi of
        True -> 2 * pi + angle
        _ -> angle

buildMap: List Polar -> AsteroidMap
buildMap coordinates =
    case coordinates of
        (distance, angle)::rest -> update (turnsToVertical angle) (\v -> Just ([distance] ++ (Maybe.withDefault [] v))) (buildMap rest)
        [] -> Dict.empty

initMap: List Asteroid -> Asteroid -> AsteroidMap
initMap asteroids origin =
    filterMap (getRelativePosition origin) asteroids
        |> buildMap
        |> Dict.map (\_ distances -> sort distances)

getVisible: AsteroidMap -> List Polar
getVisible asteroidMap =
    Dict.map (\angle distances -> (Maybe.withDefault 0 (head distances), angle)) asteroidMap
        |> Dict.values

getVisibleNumber: AsteroidMap -> Int
getVisibleNumber asteroidMap =
    length (getVisible asteroidMap)

dropVisible: AsteroidMap -> AsteroidMap
dropVisible asteroidMap =
    Dict.map (\_ l -> drop 1 l) asteroidMap
        |> Dict.filter (\_ l -> not (isEmpty l))

getFiringOrder: AsteroidMap -> List Polar
getFiringOrder asteroidMap =
    let
        visible =
            getVisible asteroidMap
        remaining =
            dropVisible asteroidMap
    in
    case Dict.isEmpty remaining of
        True -> visible
        _ -> visible ++ (getFiringOrder remaining)

findAsteroidByMostVisibleAsteroids: List Asteroid -> Maybe Asteroid
findAsteroidByMostVisibleAsteroids asteroids =
    asteroids
        |> sortBy ((initMap asteroids) >> getVisibleNumber)
        |> reverse
        |> head

findAsteroidByFiringOrder: Int -> List Asteroid -> Maybe Asteroid
findAsteroidByFiringOrder order asteroids =
    case findAsteroidByMostVisibleAsteroids asteroids of
        Just station ->
            initMap asteroids station
                |> getFiringOrder
                |> Array.fromList
                |> get (order - 1)
                |> getAbsolutePosition station
        Nothing -> Nothing

findMostVisibleAsteroids: List Asteroid -> Int
findMostVisibleAsteroids asteroids =
    case findAsteroidByMostVisibleAsteroids asteroids of
        Just a -> getVisibleNumber (initMap asteroids a)
        Nothing -> 0
