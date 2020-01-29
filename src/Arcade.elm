module Arcade exposing (..)

import Array
import List exposing (filter, foldl, foldr, map, range, reverse)
import Set

import IntComputer exposing (ComputerState(..), IntComputer, run, initComputer)

type Tile
    = Default
    | Empty
    | Wall
    | Block
    | HorizontalPaddle
    | Score
    | Ball

parseTile: Int -> Tile
parseTile n =
    case n of
        0 -> Empty
        1 -> Wall
        2 -> Block
        3 -> HorizontalPaddle
        4 -> Ball
        _ -> Default

runGame: List Int -> IntComputer
runGame game =
    initComputer [] (Array.fromList game)
        |> run

runForFree: List Int -> IntComputer
runForFree game =
    Array.fromList game
        |> Array.set 0 2
        |> initComputer []
        |> run

getType: (Int, Int, Tile) -> Tile
getType (_, _, tileType) =
    tileType

findByType: Tile -> List (Int, Int, Tile) -> (Int, Int, Tile)
findByType tileType tiles =
    case tiles of
        a::rest -> if getType a == tileType then a else findByType tileType rest
        _ -> (-1, -1, Default)

parseBlocks: List (Int, Int, Tile) -> List Int -> List (Int, Int, Tile)
parseBlocks result output =
    case output of
        x::y::tile::rest -> parseBlocks (result ++ [if x == -1 && y == 0 then (tile, 0, Score) else (x, y, parseTile tile)]) rest
        _ -> result

getBallDirection: Int -> Int -> Int
getBallDirection previous current =
    case (previous == current, previous < current) of
        (True, _) -> 0
        (_, True) -> 1
        _ -> -1

getNextMove: Int -> Int -> Int -> Int
getNextMove cursor previous current =
    let
        -- -1 if moving left, +1 if moving right
        ballDirection =
            getBallDirection previous current
    in
    case (cursor == previous, ballDirection < 0, cursor < current) of
        (True, _, _) -> ballDirection
        (_, True, False) -> -1
        (_, False, True) -> 1
        _ -> 0

play: Int -> Int -> IntComputer -> IntComputer
play count lastX game =
    let
        blocks =
            reverse (parseBlocks [] game.output)
        (x, _, _) =
            findByType Ball blocks
        (cursorX, _, _) =
            findByType HorizontalPaddle blocks
        nextMove =
            getNextMove cursorX lastX x
    in
    case (count, game.state) of
        (0, _) -> game
        (_, AwaitingInput) -> play (count - 1) x (run { game | input = [nextMove] })
        _ -> game

-- Solution part one
countBlockTiles: IntComputer -> Int
countBlockTiles arcade =
    arcade.output
        |> parseBlocks []
        |> filter (\(_, _, tile) -> tile == Block)
        |> map (\(x, y, _) -> (x, y))
        |> Set.fromList
        |> Set.size

-- Solution for part two:
-- Try by printing the game as it is before it requests the first input
-- Then visually inspect the course and try to program the inputs up front
-- Print again
-- Get the score

intMax = 2147483647

getScore: List (Int, Int, Tile) -> Int
getScore output =
    let (score, _, _) = findByType Score (reverse output)
    in
    score

getTileFor: (Int, Int) -> List (Int, Int, Tile) -> Maybe (Int, Int, Tile)
getTileFor (x, y) tiles =
    case tiles of
        a::rest -> if first a == x && second a == y then Just a else getTileFor (x, y) rest
        _ -> Nothing

paintPixel: Maybe (Int, Int, Tile) -> String
paintPixel tile =
    case tile of
        Just (_,_,Empty) -> " "
        Just (_,_,Wall) -> "|"
        Just (_,_,Block) -> "X"
        Just (_,_,HorizontalPaddle) -> "-"
        Just (_,_,Ball) -> "O"
        Just (_,_,Score) -> ""
        Nothing -> "a"
        _ -> "u"

first: (a, b, c) -> a
first (a, _, _) =
    a

second: (a, b, c) -> b
second (_, b, _) =
    b

paint: List (Int, Int, Tile) -> String
paint tiles =
    let
        minX =
            foldl (first >> min) intMax tiles
        maxX =
            foldl (first >> max) 0 tiles
        minY =
            foldl (second >> min) intMax tiles
        maxY =
            foldl (second >> max) 0 tiles
        drawPoint =
            (\x y -> paintPixel (getTileFor (x, y) tiles))
        drawRow =
            (\y -> foldl (\x row -> row ++ (drawPoint x y)) "" (range minX maxX))
    in
    foldl (\y out -> out ++ (drawRow y) ++ "\n" ) "" (range minY maxY)









