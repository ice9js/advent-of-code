module IntComputer exposing (..)

import Array exposing (Array, append, get, length, set, repeat)
import Tuple exposing (first)

type ComputerState
    = Running
    | AwaitingInput
    | Terminated
    | NotSupported

type alias IntComputer =
    { position: Int
    , relativeBase: Int
    , memory: Array Int
    , input: List Int
    , output: List Int
    , state: ComputerState
    }

initComputer: List Int -> Array Int -> IntComputer
initComputer input memory =
    { position = 0
    , relativeBase = 0
    , memory = memory
    , input = input
    , output = []
    , state = Running
    }

updateMemory: Int -> Int -> Array Int -> Array Int
updateMemory position value memory =
    case position < length memory of
        True -> set position value memory
        _ -> updateMemory position value (append memory (repeat (position - (length memory) + 1) 0))

getInt: Int -> Array Int -> Int
getInt index array =
    Maybe.withDefault 0 (get index array)

getParameterIndex: Int -> IntComputer -> Int
getParameterIndex param computer =
    let
        opcode =
            getInt computer.position computer.memory
        paramMode =
            modBy 10 (opcode // 10 ^ (param + 1))
    in
    case paramMode of
        0 -> getInt (computer.position + param) computer.memory
        1 -> computer.position + param
        2 -> computer.relativeBase + (getInt (computer.position + param) computer.memory)
        _ -> -1

run: IntComputer -> IntComputer
run computer =
    let
        opcode =
            getInt computer.position computer.memory
        instruction =
            modBy 100 opcode
        read =
            (\i -> getInt (getParameterIndex i computer) computer.memory)
        write =
            (\i v -> updateMemory (getParameterIndex i computer) v computer.memory)
    in
    case (instruction, computer.input) of
        (1, _) -> run
            { computer
            | position = computer.position + 4
            , memory = (write 3 ((read 1) + (read 2)))
            }
        (2, _) -> run
            { computer
            | position = computer.position + 4
            , memory = (write 3 ((read 1) * (read 2)))
            }
        (3, value::rest) -> run
            { computer
            | position = computer.position + 2
            , memory = (write 1 value)
            , input = rest
            }
        (3, []) -> { computer | state = AwaitingInput }
        (4, _) -> run
            { computer
            | position = computer.position + 2
            , output = computer.output ++ [(read 1)]
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
            , memory = (write 3 (if (read 1) < (read 2) then 1 else 0))
            }
        (8, _) -> run
            { computer
            | position = computer.position + 4
            , memory = (write 3 (if (read 1) == (read 2) then 1 else 0))
            }
        (9, _) -> run
            { computer
            | position = computer.position + 2
            , relativeBase = computer.relativeBase + (read 1)
            }
        (99, _) -> { computer | state = Terminated }
        _ -> { computer | state = NotSupported }

findIntComputerInput: Int -> Int -> Int -> Array Int -> (Int, Int)
findIntComputerInput x y expectedResult memory =
    let
        output =
            memory
                |> set 1 x
                |> set 2 y
                |> initComputer []
                |> run
                |> .memory
                |> getInt 0
    in
    case (output == expectedResult, x, y) of
        (True, _, _) -> (x, y)
        (_, 0, _) -> (-1,-1)
        (_, _, 0) -> findIntComputerInput (x - 1) 99 expectedResult memory
        _ -> findIntComputerInput x (y - 1) expectedResult memory
