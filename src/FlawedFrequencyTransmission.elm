module FlawedFrequencyTransmission exposing (..)

import List exposing (append, drop, filterMap, foldl, foldr, indexedMap, length, map, range, repeat, reverse, sum, take)

pattern: Int -> Int -> Int
pattern outputPosition position =
    case modBy 4 ((position + 1) // outputPosition) of
        0 -> 0
        1 -> 1
        2 -> 0
        3 -> -1
        _ -> 1

accumulateSum: Int -> List Int -> List Int
accumulateSum n sums =
    case sums of
        a::_ -> [(modBy 10 (abs (a + n)))] ++ sums
        [] -> [n]

applyPhase: Int -> List Int -> List Int
applyPhase offset signal =
    let
        inputRange =
            range 1 (length signal)
        calcPosition =
            (\i -> indexedMap (\j n -> n * (pattern i j)) signal
                |> sum
                |> abs
                |> modBy 10)
    in
    case offset > length signal // 2 of
        True -> foldr accumulateSum [] signal
        _ -> map calcPosition inputRange

times: Int -> (a -> a) -> a -> a
times n generator input =
    case n of
        0 -> input
        _ -> times (n - 1) generator (generator input)

fft: String -> String
fft input =
    let
        signal =
            String.split "" input
                |> filterMap String.toInt
    in
    times 100 (applyPhase 0) signal
        |> take 8
        |> map String.fromInt
        |> String.concat

getOffset: String -> Int
getOffset input =
    String.slice 0 7 input
        |> String.toInt
        |> Maybe.withDefault 0

fftWithOffset: Int -> String -> String
fftWithOffset offset input =
    let
        signal =
            String.split "" input
                |> filterMap String.toInt
    in
    times 100 (applyPhase offset) (drop offset signal)
        |> take 8
        |> map String.fromInt
        |> String.concat
