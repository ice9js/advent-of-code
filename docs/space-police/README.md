# Space Police

### Part one

On the way to Jupiter, you're pulled over by the **Space Police**.

"Attention, unmarked spacecraft! You are in violation of Space Law! All spacecraft must have a clearly visible **registration identifier**! You have 24 hours to comply or be sent to Space Jail!"

Not wanting to be sent to Space Jail, you radio back to the Elves on Earth for help. Although it takes almost three hours for their reply signal to reach you, they send instructions for how to power up the **emergency hull painting robot** and even provide a small Intcode program (your puzzle input) that will cause it to paint your ship appropriately.

There's just one problem: you don't have an emergency hull painting robot.

You'll need to build a new emergency hull painting robot. The robot needs to be able to move around on the grid of square panels on the side of your ship, detect the color of its current panel, and paint its current panel **black** or **white**. (All of the panels are currently **black**.)

The Intcode program will serve as the brain of the robot. The program uses input instructions to access the robot's camera: provide 0 if the robot is over a **black** panel or 1 if the robot is over a **white** panel. Then, the program will output two values:

- First, it will output a value indicating the **color to paint the panel** the robot is over: `0` means to paint the panel **black**, and `1` means to paint the panel **white**.
- Second, it will output a value indicating the **direction the robot should turn**: `0` means it should turn **left 90 degrees**, and `1` means it should turn **right 90 degrees**.

After the robot turns, it should always move forward exactly one panel. The robot starts facing **up**.

The robot will continue running for a while like this and halt when it is finished drawing. Do not restart the Intcode computer inside the robot during this process.

For example, suppose the robot is about to start running. Drawing black panels as ., white panels as #, and the robot pointing the direction it is facing (< ^ > v), the initial state and region near the robot looks like this:

```
.....
.....
..^..
.....
.....
```

The panel under the robot (not visible here because a ^ is shown instead) is also black, and so any input instructions at this point should be provided 0. Suppose the robot eventually outputs 1 (paint white) and then 0 (turn left). After taking these actions and moving forward one panel, the region now looks like this:

```
.....
.....
.<#..
.....
.....
```

Input instructions should still be provided 0. Next, the robot might output 0 (paint black) and then 0 (turn left):

```
.....
.....
..#..
.v...
.....
```

After more outputs (1,0, 1,0):

```
.....
.....
..^..
.##..
.....
```

The robot is now back where it started, but because it is now on a white panel, input instructions should be provided 1. After several more outputs (0,1, 1,0, 1,0), the area looks like this:

```
.....
..<#.
...#.
.##..
.....
```

Before you deploy the robot, you should probably have an estimate of the area it will cover: specifically, you need to know the **number of panels it paints at least once**, regardless of color. In the example above, the robot painted **6 panels** at least once. (It painted its starting panel twice, but that panel is still only counted once; it also never painted the panel it ended on.)

Build a new emergency hull painting robot and run the Intcode program on it. **How many panels does it paint at least once?**

### Part two

You're not sure what it's trying to paint, but it's definitely not a **registration identifier**. The Space Police are getting impatient.

Checking your external ship cameras again, you notice a white panel marked "emergency hull painting robot starting panel". The rest of the panels are still black, but it looks like the robot was expecting to **start on a white panel, not a black one**.

Based on the Space Law Space Brochure that the Space Police attached to one of your windows, a valid registration identifier is always **eight capital letters**. After starting the robot on a single **white panel** instead, **what registration identifier does it paint** on your hull?

## Solution ([Implementation](../../src/HullPaintingRobot.elm))

```elm
import HullPaintingRobot exposing (..)

driver = [3,8,1005,8,328,...]

-- Solution for part one: 1932 (249 after adjusting for part two)
getTotalPaintedPanels (initRobot driver (0,0))

-- Solution for part two:
paint (initRobot driver (0,0))

- """
- XXXX  XX  X  X X  X  XX    XX XXXX XXX     
- X    X  X X  X X X  X  X    X X    X  X    
- XXX  X    XXXX XX   X       X XXX  X  X    
- X    X XX X  X X X  X XX    X X    XXX     
- X    X  X X  X X X  X  X X  X X    X X     
- XXXX  XXX X  X X  X  XXX  XX  XXXX X  X    
- """
```

### Input

```elm
driver = [3,8,1005,8,328,1106,0,11,0,0,0,104,1,104,0,3,8,102,-1,8,10,1001,10,1,10,4,10,108,0,8,10,4,10,1002,8,1,28,1,1003,10,10,3,8,1002,8,-1,10,101,1,10,10,4,10,108,1,8,10,4,10,102,1,8,54,2,1103,6,10,3,8,1002,8,-1,10,101,1,10,10,4,10,108,0,8,10,4,10,101,0,8,80,3,8,1002,8,-1,10,1001,10,1,10,4,10,108,1,8,10,4,10,1002,8,1,102,3,8,102,-1,8,10,1001,10,1,10,4,10,108,0,8,10,4,10,1001,8,0,124,3,8,102,-1,8,10,101,1,10,10,4,10,1008,8,1,10,4,10,1001,8,0,147,1006,0,35,1,7,3,10,2,106,13,10,2,1104,9,10,3,8,102,-1,8,10,1001,10,1,10,4,10,108,0,8,10,4,10,1002,8,1,183,2,7,16,10,2,105,14,10,1,1002,12,10,1006,0,13,3,8,102,-1,8,10,1001,10,1,10,4,10,108,0,8,10,4,10,1002,8,1,220,1006,0,78,2,5,3,10,1006,0,92,1006,0,92,3,8,1002,8,-1,10,101,1,10,10,4,10,108,1,8,10,4,10,1001,8,0,255,1006,0,57,2,1001,11,10,1006,0,34,2,1007,18,10,3,8,1002,8,-1,10,101,1,10,10,4,10,1008,8,1,10,4,10,1002,8,1,292,2,109,3,10,1,1103,14,10,2,2,5,10,2,1006,3,10,101,1,9,9,1007,9,997,10,1005,10,15,99,109,650,104,0,104,1,21101,932700762920,0,1,21101,0,345,0,1105,1,449,21102,1,386577306516,1,21102,356,1,0,1106,0,449,3,10,104,0,104,1,3,10,104,0,104,0,3,10,104,0,104,1,3,10,104,0,104,1,3,10,104,0,104,0,3,10,104,0,104,1,21101,179355975827,0,1,21101,403,0,0,1106,0,449,21102,1,46413220903,1,21102,1,414,0,1106,0,449,3,10,104,0,104,0,3,10,104,0,104,0,21101,988224959252,0,1,21102,1,437,0,1106,0,449,21101,717637968660,0,1,21101,0,448,0,1106,0,449,99,109,2,22101,0,-1,1,21102,40,1,2,21101,480,0,3,21101,470,0,0,1106,0,513,109,-2,2105,1,0,0,1,0,0,1,109,2,3,10,204,-1,1001,475,476,491,4,0,1001,475,1,475,108,4,475,10,1006,10,507,1102,1,0,475,109,-2,2105,1,0,0,109,4,2102,1,-1,512,1207,-3,0,10,1006,10,530,21102,1,0,-3,22102,1,-3,1,22101,0,-2,2,21102,1,1,3,21101,0,549,0,1105,1,554,109,-4,2105,1,0,109,5,1207,-3,1,10,1006,10,577,2207,-4,-2,10,1006,10,577,21202,-4,1,-4,1106,0,645,21202,-4,1,1,21201,-3,-1,2,21202,-2,2,3,21102,1,596,0,1106,0,554,21201,1,0,-4,21101,1,0,-1,2207,-4,-2,10,1006,10,615,21101,0,0,-1,22202,-2,-1,-2,2107,0,-3,10,1006,10,637,21201,-1,0,1,21101,0,637,0,105,1,512,21202,-2,-1,-2,22201,-4,-2,-4,109,-5,2105,1,0]
```
