module Amplifier exposing (..)

import Array exposing (fromList)
import Basics exposing (max)
import List exposing (append, foldl, head, map, reverse)
import Tuple exposing (second)

import IntComputer exposing (IntComputer, initComputer, run)
import Math exposing (permutate)

type alias Amplifier = IntComputer

initAmplifier: List Int -> Int -> Int -> Amplifier
initAmplifier driver phaseSetting initialInput =
    initComputer 0 [phaseSetting, initialInput] (fromList driver)
        |> run

getAmplifierOutput: Amplifier -> Int
getAmplifierOutput amplifier =
    amplifier.output
        |> head
        |> Maybe.withDefault -1

amplifierArray: List Int -> Int -> List Int -> List Amplifier
amplifierArray driver initialInput phaseSettings =
    case phaseSettings of
        phase::settings ->
            let amplifier = initAmplifier driver phase initialInput
            in
            append [amplifier] (amplifierArray driver (getAmplifierOutput amplifier) settings)
        _ -> []

runAmplifierArray: Int -> List Amplifier -> List Amplifier
runAmplifierArray inputSignal amplifiers =
    case amplifiers of
        amplifier::rest ->
            let nextState = run { amplifier | input = [inputSignal], output = [] }
            in
            append [nextState] (runAmplifierArray (getAmplifierOutput nextState) rest)
        _ -> []

getAmplifierArrayOutput: List Amplifier -> Int
getAmplifierArrayOutput amplifiers =
    case head (reverse amplifiers) of
        Just a -> getAmplifierOutput a
        Nothing -> -1

loopAmplifierArray: List Amplifier -> Int
loopAmplifierArray amplifiers =
    let tick = runAmplifierArray (getAmplifierArrayOutput amplifiers) amplifiers
    in
    case amplifiers of
        first::_ -> if first.terminated then getAmplifierArrayOutput amplifiers else loopAmplifierArray tick
        _ -> -1

amplifySeries: List Int -> Int -> List Int -> Int
amplifySeries driver initialInput phaseSettings =
    getAmplifierArrayOutput (amplifierArray driver initialInput phaseSettings)

amplifyLoop: List Int -> Int -> List Int -> Int
amplifyLoop driver initialInput phaseSettings =
    loopAmplifierArray (amplifierArray driver initialInput phaseSettings)

findMaxThrustSignal: (List Int -> Int -> List Int -> Int) -> List Int -> Int -> List Int -> Int
findMaxThrustSignal configuration driver initialInput allowedSettings =
    foldl max 0 (map (configuration driver initialInput) (permutate allowedSettings))
