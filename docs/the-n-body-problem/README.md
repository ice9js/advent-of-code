# The N-Body Problem

## Solution ([Implementation](../../src/Moon.elm))

```
-- Solution for part one: 13500
(map initMoon input
    |> getMoonsAfter 10
    |> getTotalEnergyForSystem)

-- Solution for part two: 278013787106916
getStepsUntilRepeat (map initMoon input)
```

### Input

```elm
input = [(0,4,0),(-10,-6,-14),(9,-16,-3),(6,-1,2)]
```
