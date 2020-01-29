module Wires exposing (..)

import Array exposing (fromList, toIndexedList)
import Basics exposing (min)
import List exposing (append, filter, filterMap, foldl, length, map, range, reverse)
import Set exposing (fromList, toList, intersect)

intMax = 2147483647

type alias Point = (Int, Int)

type alias Path = List Point

type Direction
    = Left Int
    | Right Int
    | Up Int
    | Down Int

getSegment: Point -> Direction -> Path
getSegment (x, y) direction =
    case direction of
        Right n -> reverse (map (\a -> (a, y)) (range x (x + n)))
        Left n -> map (\a -> (a, y)) (range (x - n) x)
        Up n -> reverse (map (\a -> (x, a)) (range y (y + n)))
        Down n -> map (\a -> (x, a)) (range (y - n) y)

appendDirections: Direction -> Path -> Path
appendDirections direction path =
    case path of
        head::tail -> append (getSegment head direction) tail
        [] -> []

initPath: Point -> List Direction -> Path
initPath start directions =
    reverse (foldl appendDirections [start] directions)

getIntersections: Path -> Path -> List Point
getIntersections a b =
    filter (\p -> p /= (0, 0)) (toList (intersect (Set.fromList a) (Set.fromList b)))

manhattanDistance: Point -> Point -> Int
manhattanDistance (ax, ay) (bx, by) =
    (abs (ax - bx)) + (abs (ay - by))

-- try splitting path by point and then length
pathDistance: Point -> Path -> Int
pathDistance point path =
    let
        -- This 'creative' approach was necessary to help with Elm's REPL
        -- throwing stack overflow errors for the puzzle input
        distances =
            filterMap
                (\(distance, p) -> if p == point then Just distance else Nothing)
                (toIndexedList (Array.fromList path))
    in
    case distances of
        d::_ -> d
        _ -> length path

pathLengths: Path -> Path -> Point -> Int
pathLengths a b point =
    (pathDistance point a) + (pathDistance point b)

getClosestIntersection: (Point -> Int) -> Path -> Path -> Int
getClosestIntersection getDistance a b =
    foldl min intMax (map getDistance (getIntersections a b))
