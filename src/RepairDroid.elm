module RepairDroid exposing (..)

import Array
import List exposing (any, filter, filterMap, foldl, head, map, member, reverse)

import IntComputer exposing (IntComputer, initComputer, run)

type alias Point = (Int, Int)

type alias Path = List Direction

type Direction
    = North
    | South
    | West
    | East

type alias RepairDroid = IntComputer

toInt: Direction -> Int
toInt direction =
    case direction of
        North -> 1
        South -> 2
        West -> 3
        East -> 4

bootDroid: List Int -> RepairDroid
bootDroid driver =
    initComputer [] (Array.fromList driver)

runDroid: RepairDroid -> List Direction -> RepairDroid
runDroid droid directions =
    run { droid | input = map toInt directions }

getOutput: RepairDroid -> Int
getOutput droid =
    droid.output
        |> reverse
        |> head
        |> Maybe.withDefault 0

nextLocation: Direction -> Point -> Point
nextLocation direction (x, y) =
    case direction of
        North -> (x, y + 1)
        South -> (x, y - 1)
        West -> (x - 1, y)
        East -> (x + 1, y)

hasLoops: List Point -> Path -> Bool
hasLoops visited path =
    let current = Maybe.withDefault (0, 0) (head visited)
    in
    case path of
        [] -> False
        direction::rest ->
            let next = nextLocation direction current
            in
            if member next visited then True else hasLoops ([next] ++ visited) rest

findPathToOxygenSystem: RepairDroid -> Path -> Maybe Path
findPathToOxygenSystem droid path =
    let
        nextMoves =
            filter (\d -> not (hasLoops [] (path ++ [d]))) [North, South, West, East]
        results =
            map (\move -> (move, runDroid droid [move])) nextMoves
                |> filter (\(_, result) -> getOutput result /= 0)
        isOxygenSystem =
            (\(_, result) -> getOutput result == 2)
    in
    case (any isOxygenSystem results, results) of
        (True, _) -> Maybe.map (\(move, _) -> path ++ [move]) (head (filter isOxygenSystem results))
        (_, []) -> Nothing
        _ -> results
            |> filterMap (\(move, result) -> findPathToOxygenSystem result (path ++ [move]))
            |> head

-- could be improved because it's mosty similar to the above (it does return something else though /)
minutesUntilFilled: RepairDroid -> Path -> Int
minutesUntilFilled droid path =
    let
        nextMoves =
            filter (\d -> not (hasLoops [] (path ++ [d]))) [North, South, West, East]
        results =
            map (\move -> (move, runDroid droid [move])) nextMoves
                |> filter (\(_, result) -> getOutput result /= 0)
    in
    case results of
        [] -> 0
        _ -> results
            |> map (\(move, result) -> 1 + (minutesUntilFilled result (path ++ [move])))
            |> foldl max 0
