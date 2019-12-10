module AsteroidMapTest exposing (..)

import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer, int, list, string)
import Test exposing (..)

import AsteroidMap exposing (..)

asteroidMapTests : Test
asteroidMapTests =
    describe "AsteroidMap"
    [ test "fromString parses strings correctly"
        (\_ -> Expect.equal [(0,0), (1,2)] (fromString "#..\n...\n.#."))
    ]
