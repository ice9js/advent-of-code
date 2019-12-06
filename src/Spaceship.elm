module Spaceship exposing (fuelRequired, fuelRequiredRecursive, spaceshipFuel)

import List exposing (foldl, map)

fuelRequired: Int -> Int
fuelRequired mass =
    max (mass // 3 - 2) 0

fuelRequiredRecursive: Int -> Int
fuelRequiredRecursive mass =
    let fuel = fuelRequired mass
    in
    case fuel of
        0 -> fuel
        _ -> fuel + (fuelRequiredRecursive fuel)

spaceshipFuel: (Int -> Int) -> List Int -> Int
spaceshipFuel calculateFuel modules =
    foldl (+) 0 (map calculateFuel modules)
