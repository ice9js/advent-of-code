module TunnelMap exposing (..)

import Char
import Dict exposing (Dict)
import List exposing (append, all, concat, filter, filterMap, foldl, head, indexedMap, isEmpty, length, map, sortBy)
import Set exposing (Set)
import String

import Math exposing (combinations)

intMax = 2147483647

type alias Point = (Int, Int, Char)

type alias Key = Char

type alias Keychain = Set Key

type alias Path =
    { distance: Int
    , doors: List Char
    }

-- Think again! What if:
-- Find/mark the entrance/position
--
-- Find all doors/distance to them and what keys are on the way - done
--
-- What's a good way to think about this..

-- Take any key-key pair - you know what keys you need to reach it so the shortest path will be 

-- A) Find which doors need to be opened in the next 'tick'
-- B) Find which keys are in between you and these doors/walls

-- add start position (if that works)
type alias TunnelMap =
    { keys: Set Key
    , paths: Dict (Key, Key) Path
    }

getPosition: Char -> List Point -> Point
getPosition item points =
    filter (\(_, _, c) -> c == item) points
        |> head
        |> Maybe.withDefault (-1, -1, '#')


getNeighboringPoints: Point -> Set Point -> Set Point
getNeighboringPoints (x, y, _) points =
    Set.filter (\(px, py, _) -> (abs (x - px)) + (abs (y - py)) == 1) points


getShortestPath: Point -> Point -> List Point -> Set Point -> Maybe (List Point)
getShortestPath from to path points =
    let
        neighbors =
            getNeighboringPoints from points
        currentPath =
            path ++ [from]
        chooseShortest =
            (\neighbor shortest ->
                let current = getShortestPath neighbor to currentPath (Set.remove from (Set.diff points neighbors))
                in
                case (current, shortest) of
                    (Nothing, _) -> shortest
                    (_, Nothing) -> current
                    (Just a, Just b) -> if length a < length b then current else shortest)
    in
    case (from == to, Set.toList neighbors) of
        (True, _) -> Just currentPath
        (_, []) -> Nothing
        (_, neighborList) -> neighborList
            |> foldl chooseShortest Nothing

-- create a graph
fromString: String -> TunnelMap
fromString src =
    let
        points =
             String.trim src
                |> String.split "\n"
                |> map String.trim
                |> map String.toList
                |> indexedMap (\y line -> indexedMap (\x point -> (x, y, point)) line)
                |> concat
                |> filter (\(_, _, p) -> p /= '#')
        keys =
            points
                |> filterMap (\(x, y, k) -> if Char.isAlpha k && Char.isLower k then Just (x, y, k) else Nothing)
        paths =
            combinations keys
                |> filterMap (\(from, to) -> Maybe.map (\path -> (from, to, path)) (getShortestPath from to [] (Set.fromList points)))
                |> map (\((_, _, from), (_, _, to), path) -> ((from, to), { distance = (List.length path) - 1, doors = filterMap (\(_, _ ,d) -> if Char.isAlpha d && Char.isUpper d then Just (Char.toLower d) else Nothing) path}))
        entrance =
            filter (\(_, _, c) -> c == '@') points
                |> head
                |> Maybe.withDefault (-1, -1, '@')
        entrancePaths =
            keys
                |> filterMap (\k -> Maybe.map (\p -> (entrance, k, p)) (getShortestPath entrance k [] (Set.fromList points)))
                |> map (\((_, _, from), (_, _, to), path) -> ((from, to), { distance = (List.length path) - 1, doors = filterMap (\(_, _ ,d) -> if Char.isAlpha d && Char.isUpper d then Just (Char.toLower d) else Nothing) path}))
    in
    { keys = Set.fromList (map (\(_, _, c) -> c) keys)
    , paths = Dict.fromList (paths ++ entrancePaths)
    }

minStepsForKeys: TunnelMap -> Keychain -> Char -> Int
minStepsForKeys ({keys, paths} as tunnelMap) collected current =
    let
        isAccessible =
            (\key -> Maybe.map (\{doors} -> all (\d -> Set.member d collected) doors) (Dict.get (current, key) paths))
        possibleMoves =
            Set.filter (\k -> isAccessible k /= Nothing && isAccessible k /= Just False) (Set.diff keys collected)
    in
    case keys == collected of
        True -> 0
        _ ->
            Set.toList possibleMoves
                |> filterMap (\next -> Maybe.map (\p -> (next, p.distance)) (Dict.get (current, next) paths))
                |> map (\(key, d) -> d + (minStepsForKeys tunnelMap (Set.insert key collected) key))
                |> foldl min intMax

-- Got me graph
-- now need to walk through it and keep track of distance and keys collected
