module Permutation exposing (..)

type Shuffle
	= Reverse
	| Cut Int
	| Increment Int

type alias Permutation = (Int, Int)

shuffle: Int -> Shuffle -> Int
shuffle n shuffleType =
	case shuffleType of
		Reverse -> negate n
		Cut at -> 
		Increment by ->


-- so this is a good idea as in it's associative right,
-- so I can combine the next steps to get the current step
-- but I cannot operate on lists, that's way to large,
-- which is a problem because I need the previous permutation
-- unless permutation is a function
--
-- in such case, it still sucks
