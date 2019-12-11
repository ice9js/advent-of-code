module HullPaintingRobot exposing (..)

import Array
import List exposing (foldl, foldr, head, length, map, range, tail)
import Set
import Tuple exposing (first, mapSecond, second)

import IntComputer exposing (ComputerState(..), IntComputer, initComputer, run)

intMax = 2147483647

type Direction
    = Left
    | Right
    | Up
    | Down

type alias Coord = (Int, Int)

type alias Panel =
    { position: Coord
    , color: Int
    }

type alias HullPaintingRobot =
    { position: Coord
    , direction: Direction
    , paintedPath: List Panel
    , controller: IntComputer
    }

getCurrentColorFor: Coord -> List Panel -> Int
getCurrentColorFor position paintedPanels =
    case (paintedPanels, position) of
        (panel::rest, _) -> if panel.position == position then panel.color else getCurrentColorFor position rest
        (_, (0, 0)) -> 1
        _ -> 0

initRobot: List Int -> Coord -> HullPaintingRobot
initRobot driver origin =
    { position = origin
    , direction = Up
    , paintedPath = []
    , controller = initComputer [] (Array.fromList driver)}

initPanel: Coord -> Int -> Panel
initPanel position color =
    { position = position
    , color = color
    }

nextDirection: Direction -> Int -> Direction
nextDirection current signal =
    case (current, signal) of
        (Left, 0) -> Down
        (Down, 0) -> Right
        (Right, 0) -> Up
        (Up, 0) -> Left
        (Left, 1) -> Up
        (Down, 1) -> Left
        (Right, 1) -> Down
        (Up, 1) -> Right
        _ -> Up

nextPosition: Coord -> Direction -> Coord
nextPosition (x, y) direction =
    case direction of
        Up -> (x, y + 1)
        Right -> (x + 1, y)
        Down -> (x, y - 1)
        Left -> (x - 1, y)

getRobotControllerOutput: IntComputer -> (Int, Int)
getRobotControllerOutput controller =
    case controller.output of
        color::direction::_ -> (color, direction)
        _ -> (0, -1)

runRobot: HullPaintingRobot -> HullPaintingRobot
runRobot ({ controller, direction, paintedPath, position } as robot) =
    let
        next =
            run { controller
                | input = [getCurrentColorFor position paintedPath]
                , output = []
                }
        (color, turnSignal) =
            getRobotControllerOutput next
        nextRobot =
            { position = nextPosition position (nextDirection direction turnSignal)
            , direction = (nextDirection direction turnSignal)
            , paintedPath = [initPanel position color] ++ paintedPath
            , controller = next
            }
    in
    case (length paintedPath < 10, next.state) of
        (_, AwaitingInput) -> runRobot nextRobot
        _ -> nextRobot

getTotalPaintedPanels: HullPaintingRobot -> Int
getTotalPaintedPanels robot =
    runRobot robot
        |> .paintedPath
        |> map .position
        |> Set.fromList
        |> Set.size

paint: HullPaintingRobot -> String
paint robot =
    let
        panels =
            .paintedPath (runRobot robot)
        coordinates =
            Set.fromList (map .position panels)
        minX =
            Set.foldl (first >> min) intMax coordinates
        maxX =
            Set.foldl (first >> max) 0 coordinates
        minY =
            Set.foldl (second >> min) intMax coordinates
        maxY =
            Set.foldl (second >> max) 0 coordinates
        drawPoint =
            (\x y -> if 0 == getCurrentColorFor (x, y) panels then " " else "X")
        drawRow =
            (\y -> foldl (\x row -> row ++ (drawPoint x y)) "" (range minX maxX))
    in
    foldr (\y out -> out ++ (drawRow y) ++ "\n" ) "" (range minY maxY)
