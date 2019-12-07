module IntComputer exposing (..)

import Array exposing (Array, get, set)
import List exposing (append)
import Tuple exposing (first)

getInt: Int -> Array Int -> Int
getInt index array =
    Maybe.withDefault 0 (get index array)

readArg: Int -> Int -> Array Int -> Int
readArg index mode state =
    case mode of
        0 -> readArg (getInt index state) 1 state
        1 -> getInt index state
        _ -> 0

intComputer: Int -> List Int -> List Int -> Array Int -> (Array Int, List Int)
intComputer position input output state =
    let
        opcode =
            (getInt position state)
        instruction =
            modBy 100 opcode
        mode =
            (\i -> modBy 10 (opcode // 10 ^ (i + 1)))
        write =
            (\i v -> (set (getInt (position + i) state) v) state)
        read =
            (\i -> readArg (position + i) (mode i) state)
    in
    case (instruction, input) of
        (1, _) -> intComputer (position + 4) input output (write 3 ((read 1) + (read 2)))
        (2, _) -> intComputer (position + 4) input output (write 3 ((read 1) * (read 2)))
        (3, value::rest) -> intComputer (position + 2) rest output (write 1 value)
        (4, _) -> intComputer (position + 2) input (append output [(read 1)]) state
        (5, _) -> intComputer (if (read 1) == 0 then position + 3 else (read 2)) input output state
        (6, _) -> intComputer (if (read 1) /= 0 then position + 3 else (read 2)) input output state
        (7, _) -> intComputer (position + 4) input output (write 3 (if (read 1) < (read 2) then 1 else 0))
        (8, _) -> intComputer (position + 4) input output (write 3 (if (read 1) == (read 2) then 1 else 0))
        (99, _) -> (state, output)
        _ -> (state, output)

findIntComputerInput: Int -> Int -> Int -> Array Int -> (Int, Int)
findIntComputerInput x y expectedResult initialState =
    let output = initialState |> set 1 x |> set 2 y |> (intComputer 0 [] []) |> first |> getInt 0
    in
    case (output == expectedResult, x, y) of
        (True, _, _) -> (x, y)
        (_, 0, _) -> (-1,-1)
        (_, _, 0) -> findIntComputerInput (x - 1) 99 expectedResult initialState
        _ -> findIntComputerInput x (y - 1) expectedResult initialState
