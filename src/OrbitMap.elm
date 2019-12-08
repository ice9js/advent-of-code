module OrbitMap exposing (..)

import List exposing (concat, filter, filterMap, foldl, map)

type Object
    = OrbitingMass Object String
    | CenterOfMass

type alias OrbitMap = List Object

objectLabel: Object -> String
objectLabel object =
    case object of
        OrbitingMass _ label -> label
        CenterOfMass -> "COM"

initObject: (String, String) -> Object -> Maybe Object
initObject (centerLabel, label) centerOfMass =
    case centerLabel == objectLabel centerOfMass of
        True -> Just (OrbitingMass centerOfMass label)
        False -> Nothing

initOrbitMap: Object -> List (String, String) -> OrbitMap
initOrbitMap center orbitDefs =
    let orbiting = (filterMap (\def -> initObject def center) orbitDefs)
    in
    orbiting ++ (concat (map (\m -> initOrbitMap m orbitDefs) orbiting))

findObject: String -> OrbitMap -> Maybe Object
findObject label orbitMap =
    case filter (\o -> label == objectLabel o) orbitMap of
        found::_ -> Just found
        [] -> Nothing

orbitCenter: Object -> Object
orbitCenter object =
    case object of
        OrbitingMass center _ -> center
        CenterOfMass -> object

distanceBetween: Object -> Object -> Int
distanceBetween a b =
    case (a == b, a == CenterOfMass || distanceBetween CenterOfMass a <= distanceBetween CenterOfMass b) of
        (True, _) -> 0
        (_, False) -> distanceBetween b a
        _ -> 1 + distanceBetween a (orbitCenter b)

distanceBetweenByLabel: String -> String -> OrbitMap -> Int
distanceBetweenByLabel from to orbits =
    let
        a = (findObject from orbits)
        b = (findObject to orbits)
    in
    case (a, b) of
        (Just x, Just y) -> distanceBetween x y
        _ -> -1

checksum: OrbitMap -> Int
checksum orbitMap =
    foldl (+) 0 (map (\o -> distanceBetween CenterOfMass o) orbitMap)
