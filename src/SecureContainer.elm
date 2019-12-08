module SecureContainer exposing (..)

import List exposing (all, filter, isEmpty, length, map, range, tail, take)

type alias Password = List Int

toPassword: Int -> Password
toPassword number =
    let lastDigit = modBy 10 number
    in
    case number // 10 of
        0 -> [number]
        n -> (toPassword n) ++ [lastDigit]

hasOnlyIncreasingDigits: Password -> Bool
hasOnlyIncreasingDigits password =
    let pair = take 2 password
    in
    case pair of
        a::b::_ -> a <= b && hasOnlyIncreasingDigits (Maybe.withDefault [] (tail password))
        _ -> True

hasPairOfSameDigits: Password -> Bool
hasPairOfSameDigits password =
    let pair = take 2 password
    in
    case pair of
        a::b::_ -> a == b || hasPairOfSameDigits (Maybe.withDefault [] (tail password))
        _ -> False

hasOneGroupOfExactlyTwoDigits: Password -> Bool
hasOneGroupOfExactlyTwoDigits password =
    let getMatchingDigits = (\digit -> filter (\n -> n == digit) password)
    in
    password
        |> map (getMatchingDigits >> length)
        |> filter (\length -> length == 2)
        |> isEmpty
        |> not

findPasswordsMatching: List (Password -> Bool) -> Int -> Int -> List Password
findPasswordsMatching conditions from to =
    range from to
        |> map toPassword
        |> filter (\p -> all (\c -> c p) conditions)
