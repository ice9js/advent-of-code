module IntComputer exposing (..)

import Array exposing (Array, get, set)
import List exposing (append)
import Tuple exposing (first)

getInt: Int -> Array Int -> Int
getInt index array =
    Maybe.withDefault 0 (get index array)

type alias IntComputer =
    { position: Int
    , state: Array Int
    , input: List Int
    , output: List Int
    , terminated: Bool
    }

initComputer: Int -> List Int -> Array Int -> IntComputer
initComputer position input state =
    { position = position
    , state = state
    , input = input
    , output = []
    , terminated = False
    }

readArg: Int -> Int -> Array Int -> Int
readArg index mode state =
    case mode of
        0 -> readArg (getInt index state) 1 state
        1 -> getInt index state
        _ -> 0

run: IntComputer -> IntComputer
run computer =
    let
        opcode =
            (getInt computer.position computer.state)
        instruction =
            modBy 100 opcode
        mode =
            (\i -> modBy 10 (opcode // 10 ^ (i + 1)))
        read =
            (\i -> readArg (computer.position + i) (mode i) computer.state)
        write =
            (\i v -> (set (getInt (computer.position + i) computer.state) v) computer.state)
    in
    case (instruction, computer.input) of
        (1, _) -> run
            { computer
            | position = computer.position + 4
            , state = (write 3 ((read 1) + (read 2)))
            }
        (2, _) -> run
            { computer
            | position = computer.position + 4
            , state = (write 3 ((read 1) * (read 2)))
            }
        (3, value::rest) -> run
            { computer
            | position = computer.position + 2
            , state = (write 1 value)
            , input = rest
            }
        (4, _) -> run
            { computer
            | position = computer.position + 2
            , output = append computer.output [(read 1)]
            }
        (5, _) -> run
            { computer
            | position = if (read 1) == 0 then computer.position + 3 else (read 2)
            }
        (6, _) -> run
            { computer
            | position = if (read 1) /= 0 then computer.position + 3 else (read 2)
            }
        (7, _) -> run
            { computer
            | position = computer.position + 4
            , state = (write 3 (if (read 1) < (read 2) then 1 else 0))
            }
        (8, _) -> run
            { computer
            | position = computer.position + 4
            , state = (write 3 (if (read 1) == (read 2) then 1 else 0))
            }
        (99, _) -> { computer | terminated = True }
        _ -> computer

findIntComputerInput: Int -> Int -> Int -> Array Int -> (Int, Int)
findIntComputerInput x y expectedResult initialState =
    let output = initialState |> set 1 x |> set 2 y |> (initComputer 0 []) |> run |> .state |> getInt 0
    in
    case (output == expectedResult, x, y) of
        (True, _, _) -> (x, y)
        (_, 0, _) -> (-1,-1)
        (_, _, 0) -> findIntComputerInput (x - 1) 99 expectedResult initialState
        _ -> findIntComputerInput x (y - 1) expectedResult initialState
