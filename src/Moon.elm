module Moon exposing (..)

import List exposing (head, foldl, range, sortBy, sum)

-- refactor: make a vector type where a is position and b is velocity
type alias Vector = (Int, Int)

type alias VectorSpace = List Vector

-- refactor: moon should be a {x: Vector, y: Vector, z: Vector}
type alias Moon =
    { x: Vector
    , y: Vector
    , z: Vector
    }

type alias MoonSystem = List Moon

-- refactor:
init: (Int, Int, Int) -> Moon
init (x, y, z) =
    { x = x
    , y = y
    , z = z
    }

map: (Vector -> Vector) -> (Vector -> Vector) -> (Vector -> Vector) -> Moon -> Moon
map applyX applyY applyZ {x, y, z} =
    { x = applyX x
    , y = applyY y
    , z = applyZ z
    }

getVelocity: Vector -> Vector -> Int
getVelocity (position, _) (other, _) =
    case compare position other of
        LT -> 1
        EQ -> 0
        GR -> -1

applyGravity: VectorSpace -> Vector -> Vector
applyGravity space vector =
    let velocity = sum (List.map (getVelocity vector) space)
    in
    mapSecond (\v -> v + velocity) vector

applyVelocity: Vector -> Vector
applyVelocity (position, velocity) =
    (position + velocity, velocity)

iterateVector: VectorSpace -> Vector -> Vector
iterateVector space vector =
    applyGravity space vector
        |> applyVelocity

iterateVectorSpace: VectorSpace -> VectorSpace
iterateVectorSpace space =
    List.map (iterateVector space) space

itarate: Int -> MoonSystem -> MoonSystem
itarate times system =
    let
        nextVector =
            (\axis -> iterateVector (List.map axis system))
        next =
            List.map (map (nextVector .x) (nextVector .y) (nextVector .z))
    in
    case times of
        0 -> system
        _ -> iterate (times - 1) (next system)

totalEnergy: Moon -> Int
totalEnergy {x, y, z} =
    let
        (px, vx) = x
        (py, vy) = y
        (pz, vz) = z
    in
    ((abs px) + (abs py) + (abs pz)) * ((abs vx) + (abs vy) + (abs vz))

systemEnergy: MoonSystem -> Int
systemEnergy system =
    map totalEnergy system
        |> sum

-- Move into math module
gcd: Int -> Int -> Int
gcd a b =
    case (a == b, a < b) of
        (True, _) -> a
        (_, True) -> gcd a (b - a)
        _ -> gcd b a

-- Move into math module
lcm: Int -> Int -> Int
lcm a b =
    a * b // (gcd a b)

iterationsForAxis: VectorSpace -> Int -> VectorSpace -> Int
iterationsForAxis expected count current =
    let next = iterateVector current 
    in
    case expected == next of
        True -> count + 1
        _ -> iterationsForAxis expected (count + 1) next


iterationsUntilState: List Moon -> Int -> List Moon -> Int
iterationsUntilState desiredState count currentState =




stepsUntilRepeatsAxis: List Moon -> ((Int, Int, Int) -> Int) -> Int -> List Moon -> Int
stepsUntilRepeatsAxis initialState getAxis count next =
    let
        matchPosition =
            map (.position >> getAxis) initialState == map (.position >> getAxis) next
        matchVelocity =
            map (.velocity >> getAxis) initialState == map (.velocity >> getAxis) next
    in
    case matchPosition && matchVelocity of
        True -> count
        _ -> stepsUntilRepeatsAxis initialState getAxis (count + 1) (getMoonsAfter 1 next)

getStepsUntilRepeat: List Moon -> Int
getStepsUntilRepeat moons =
    let
        repeatX =
            stepsUntilRepeatsAxis moons (\(x, _, _) -> x) 1 (getMoonsAfter 1 moons)
        repeatY =
            stepsUntilRepeatsAxis moons (\(_, y, _) -> y) 1 (getMoonsAfter 1 moons)
        repeatZ =
            stepsUntilRepeatsAxis moons (\(_, _, z) -> z) 1 (getMoonsAfter 1 moons)
    in
    lcm repeatX (lcm repeatY repeatZ)





-- refactor:
move: List Moon -> Moon -> Moon
move moons =
    { x = }


type alias Moon =
    { position: (Int, Int, Int)
    , velocity: (Int, Int, Int)
    }

initMoon: (Int, Int, Int) -> Moon
initMoon position =
    { position = position
    , velocity = (0, 0, 0)
    }

add: (Int, Int, Int) -> (Int, Int, Int) -> (Int, Int, Int)
add (ax, ay, az) (bx, by, bz) =
    (ax + bx, ay + by, az + bz)

getRelativeVelocity: Int -> Int -> Int
getRelativeVelocity a b =
    case compare a b of
        LT -> 1
        EQ -> 0
        GT -> -1

getVelocity: List Moon -> Moon -> (Int, Int, Int)
getVelocity allMoons moon =
    let (x, y, z) = moon.position
    in
    map .position allMoons
        |> map (\(mx, my, mz) -> (getRelativeVelocity x mx, getRelativeVelocity y my, getRelativeVelocity z mz))
        |> foldl add moon.velocity

updatePosition: List Moon -> Moon -> Moon
updatePosition allMoons moon  =
    let velocity = getVelocity allMoons moon
    in
    { position = add moon.position velocity
    , velocity = velocity
    }

getMoonsAfter: Int -> List Moon -> List Moon
getMoonsAfter steps moons =
    case steps of
        0 -> moons
        _ -> getMoonsAfter (steps - 1) (map (updatePosition moons) moons)

getTotalEnergy: Moon -> Int
getTotalEnergy moon =
    let
        (x, y, z) =
            moon.position
        (vx, vy, vz) =
            moon.velocity
    in
    ((abs x) + (abs y) + (abs z)) * ((abs vx) + (abs vy) + (abs vz))

getTotalEnergyForSystem: List Moon -> Int
getTotalEnergyForSystem moons =
    map getTotalEnergy moons
        |> sum

-- THis is still a bottleneck, need to find a better way
gcd: Int -> Int -> Int
gcd a b =
    case (a == b, a < b) of
        (True, _) -> a
        (_, True) -> gcd a (b - a)
        _ -> gcd b a

lcm: Int -> Int -> Int
lcm a b =
    a * b // (gcd a b)

stepsUntilRepeatsAxis: List Moon -> ((Int, Int, Int) -> Int) -> Int -> List Moon -> Int
stepsUntilRepeatsAxis initialState getAxis count next =
    let
        matchPosition =
            map (.position >> getAxis) initialState == map (.position >> getAxis) next
        matchVelocity =
            map (.velocity >> getAxis) initialState == map (.velocity >> getAxis) next
    in
    case matchPosition && matchVelocity of
        True -> count
        _ -> stepsUntilRepeatsAxis initialState getAxis (count + 1) (getMoonsAfter 1 next)

getStepsUntilRepeat: List Moon -> Int
getStepsUntilRepeat moons =
    let
        repeatX =
            stepsUntilRepeatsAxis moons (\(x, _, _) -> x) 1 (getMoonsAfter 1 moons)
        repeatY =
            stepsUntilRepeatsAxis moons (\(_, y, _) -> y) 1 (getMoonsAfter 1 moons)
        repeatZ =
            stepsUntilRepeatsAxis moons (\(_, _, z) -> z) 1 (getMoonsAfter 1 moons)
    in
    lcm repeatX (lcm repeatY repeatZ)

getStepsUntilMatching: List Moon -> Int -> List Moon -> Int
getStepsUntilMatching initialState count state =
    let nextState = getMoonsAfter 1 state
    in
    case map .position nextState == map .position initialState of
        True -> count + 1
        _ -> getStepsUntilMatching initialState (count + 1) nextState

getSumSteps: Int -> Int -> List Moon -> List Int
getSumSteps from to moons =
    let
        state =
            getMoonsAfter from moons
        nextState =
            getMoonsAfter 1 state
        difference =
            (getTotalEnergyForSystem nextState) - (getTotalEnergyForSystem state)
    in
    case from + 1 == to of
        True -> [difference]
        _ -> [difference] ++ getSumSteps (from + 1) to moons
