module WiresTest exposing (..)

import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer, int, list, string)
import Test exposing (..)

import List exposing (reverse)

import Wires exposing (..)

exampleDirections = [Up 3, Right 2, Down 2, Left 1]
examplePath = [(0, 0), (0, 1), (0, 2), (0, 3), (1, 3), (2, 3), (2, 2), (2, 1), (1, 1)]
partialPath = [(0, 0), (0, 1), (0, 2), (0, 3), (1, 3)]

wiresTests : Test
wiresTests =
    describe "Wires"
    [ test "manhattan distance between (0,0) and (4,7) is 11"
        (\_ -> Expect.equal 11 (manhattanDistance (0, 0) (4, 7)))
    , test "(initPath (0, 0) exampleDirections) should equal examplePath"
        (\_ -> Expect.equal examplePath (initPath (0, 0) exampleDirections))
    , test "pathDistance returns the number of 'hops' path goes through until the given point"
        (\_ -> Expect.equal 4 (pathDistance (1, 3) examplePath))
    , test "pathDistance returns the array length for points that aren't part of the path"
        (\_ -> Expect.equal 9 (pathDistance (9, 9) examplePath))
    , test "pathLengths should return for (2,3)"
        (\_ -> Expect.equal 8 (pathLengths examplePath (reverse examplePath) (0, 3)))
    ]
