module DeckTest exposing (..)

import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer, int, list, string)
import Test exposing (..)

import List exposing (map, range)

import Deck exposing (..)

asteroidMapTests : Test
asteroidMapTests =
    describe "Deck"
    [ test "reversePosition reverses the order"
        (\_ -> Expect.equal [9,8,7,6,5,4,3,2,1,0] (map (reversePosition 10) (range 0 9)))
    , test "cutAt works with positive numbers"
        (\_ -> Expect.equal [3,4,5,6,7,8,9,0,1,2] (map (cutAt 10 3) (range 0 9)))
    , test "cutAt works with negative numbers"
        (\_ -> Expect.equal [6,7,8,9,0,1,2,3,4,5] (map (cutAt 10 -4) (range 0 9)))
    , test "incrementBy returns the numbers by skipping n places each time"
        (\_ -> Expect.equal [0,7,4,1,8,5,2,9,6,3] (map (incrementBy 10 3) (range 0 9)))
    , test "compact returns correct values for a single Increment technique"
        (\_ -> Expect.equal { reverse = False, cut = 0, increment = 4} (compact [Increment 4] 10))
    , test "compact returns correct values for multiple Increment techniques"
        (\_ -> Expect.equal { reverse = False, cut = 0, increment = 6} (compact [Increment 4, Increment 2, Increment 7] 10))
    , test "compact returns correct values for a single Cut technique"
        (\_ -> Expect.equal { reverse = False, cut = 3, increment = 1} (compact [Cut 3] 10))
    , test "compact returns correct values for multiple Cut techniques"
        (\_ -> Expect.equal { reverse = False, cut = 1, increment = 1} (compact [Cut 3, Cut 8, Cut 5, Cut 5] 10))
    , test "compact returns correct values for chaining Cut with Increment"
        (\_ -> Expect.equal { reverse = False, cut = 6, increment = 7} (compact [Cut 6, Increment 7] 10))
    , test "compact returns correct values for chaining Increment with Cut"
        (\_ -> Expect.equal { reverse = False, cut = 4, increment = 3} (compact [Increment 3, Cut 2] 10))
    , test "compact resurns correct values for Reverse technique"
        (\_ -> Expect.equal { reverse = True, cut = 0, increment = 1} (compact [Reverse] 10))
    , test "compact resurns correct values for chained Reverse techniques"
        (\_ -> Expect.equal { reverse = True, cut = 0, increment = 1} (compact [Reverse, Reverse, Reverse] 10))
    , test "compact resurns correct values for chained Reverse techniques 2"
        (\_ -> Expect.equal { reverse = False, cut = 0, increment = 1} (compact [Reverse, Reverse, Reverse, Reverse] 10))
    , test "compact returns correct values for Reverse and Cut"
        (\_ -> Expect.equal { reverse = True, cut = 4, increment = 1} (compact [Reverse, Cut 4] 10))
    , test "compact returns correct values for Cut and Reverse"
        (\_ -> Expect.equal { reverse = True, cut = -4, increment = 1} (compact [Cut 4, Reverse] 10))
    , test "compact returns correct values for Increment and Reverse"
        (\_ -> Expect.equal { reverse = True, cut = 6, increment = 3} (compact [Increment 3, Reverse] 10))
    , test "compact returns correct values for Increment, Cut and Reverse"
        (\_ -> Expect.equal { reverse = True, cut = 2, increment = 3} (compact [Increment 3, Cut 2, Reverse] 10))
    , test "compact returns correct values for Cut, Increment and Reverse"
        (\_ -> Expect.equal { reverse = True, cut = 6, increment = 7} (compact [Cut 6, Increment 7, Reverse] 10))
    ]
