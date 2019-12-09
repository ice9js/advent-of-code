module Amplifier exposing (..)

import Array exposing (fromList)
import Basics exposing (max)
import List exposing (foldl, head, map, reverse)

import IntComputer exposing (ComputerState(..), IntComputer, initComputer, run)
import Math exposing (permutate)

type alias Amplifier = IntComputer

type alias AmplifierArray = List IntComputer

getOutput: Amplifier -> Int
getOutput amplifier =
    Maybe.withDefault -1 (head amplifier.output)

initArray: List Int -> List Int -> AmplifierArray
initArray driver phaseSettings =
    case phaseSettings of
        s::rest -> [initComputer [s] (fromList driver)] ++ initArray driver rest
        [] -> []

getArrayOutput: AmplifierArray -> Int
getArrayOutput amplifiers =
    case head (reverse amplifiers) of
        Just amp -> getOutput amp
        _ -> -1

amplifyOnce: Int -> AmplifierArray -> AmplifierArray
amplifyOnce inputSignal amplifiers =
    case amplifiers of
        amp::rest ->
            let result = run { amp | input = amp.input ++ [inputSignal], output = [] }
            in
            [result] ++ (amplifyOnce (getOutput result) rest)
        [] -> []

amplifyLoop: Int -> AmplifierArray -> AmplifierArray
amplifyLoop inputSignal amplifiers =
    let result = amplifyOnce inputSignal amplifiers
    in
    case head result of
        Just amp -> if amp.state == Terminated then result else amplifyLoop (getArrayOutput result) result
        _ -> []

findMaxThrustSignal: List Int -> Int -> List Int -> Int
findMaxThrustSignal driver initialInput allowedSettings =
    let
        amplifierArrays =
            map (initArray driver) (permutate allowedSettings)
        outputSignals =
            map getArrayOutput (map (amplifyLoop initialInput) amplifierArrays)
    in
    foldl max 0 outputSignals
