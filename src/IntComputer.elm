module IntComputer exposing (intComputer, getInt, findIntComputerInput)

import Array exposing (Array, fromList, toList, get, set, slice)

type alias Params = (Int, Int, Int)

getInt: Int -> Array Int -> Int
getInt index array =
    Maybe.withDefault 0 (get index array)

apply: (Int -> Int -> Int) -> Params -> Array Int -> Array Int
apply func (a, b, saveTo) memory =
    set saveTo (func (getInt a memory) (getInt b memory)) memory

intComputer: Int -> Array Int -> Array Int
intComputer position memory =
    let
        next =
            position + 4
        operation =
            toList (slice position next memory)
    in
    case operation of
        1::i::j::saveTo::_ -> intComputer next (apply (+) (i, j, saveTo) memory)
        2::i::j::saveTo::_ -> intComputer next (apply (*) (i, j, saveTo) memory)
        99::_ -> memory
        _ -> fromList []

findIntComputerInput: Int -> Int -> Int -> Array Int -> (Int, Int)
findIntComputerInput x y expectedResult initialState =
    let output = initialState |> set 1 x |> set 2 y |> (intComputer 0) |> getInt 0
    in
    case (output == expectedResult, x, y) of
        (True, _, _) -> (x, y)
        (_, 0, _) -> (-1,-1)
        (_, _, 0) -> findIntComputerInput (x - 1) 99 expectedResult initialState
        _ -> findIntComputerInput x (y - 1) expectedResult initialState
