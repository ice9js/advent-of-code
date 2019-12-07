# Crossed Wires

### Part One

The gravity assist was successful, and you're well on your way to the Venus refuelling station. During the rush back on Earth, the fuel management system wasn't completely installed, so that's next on the priority list.

Opening the front panel reveals a jumble of wires. Specifically, two wires are connected to a central port and extend outward on a grid. You trace the path each wire takes as it leaves the central port, one wire per line of text (your puzzle input).

The wires twist and turn, but the two wires occasionally cross paths. To fix the circuit, you need to **find the intersection point closest to the central port**. Because the wires are on a grid, use the [Manhattan distance](https://en.wikipedia.org/wiki/Taxicab_geometry) for this measurement. While the wires do technically cross right at the central port where they both start, this point does not count, nor does a wire count as crossing with itself.

For example, if the first wire's path is `R8,U5,L5,D3`, then starting from the central port (o), it goes right 8, up 5, left 5, and finally down 3:

```
...........
...........
...........
....+----+.
....|....|.
....|....|.
....|....|.
.........|.
.o-------+.
...........
```

Then, if the second wire's path is `U7,R6,D4,L4`, it goes up 7, right 6, down 4, and left 4:

```
...........
.+-----+...
.|.....|...
.|..+--X-+.
.|..|..|.|.
.|.-X--+.|.
.|..|....|.
.|.......|.
.o-------+.
...........
```

These wires cross at two locations (marked X), but the lower-left one is closer to the central port: its distance is `3 + 3 = 6`.

Here are a few more examples:

`R75,D30,R83,U83,L12,D49,R71,U7,L72
U62,R66,U55,R34,D71,R55,D58,R83` = distance 159
`R98,U47,R26,D63,R33,U87,L62,D20,R33,U53,R51
U98,R91,D20,R16,D67,R40,U7,R15,U6,R7` = distance 135

**What is the Manhattan distance** from the central port to the closest intersection?

### Part Two

It turns out that this circuit is very timing-sensitive; you actually need to **minimize the signal delay**.

To do this, calculate the **number of steps** each wire takes to reach each intersection; choose the intersection where the **sum of both wires' steps** is lowest. If a wire visits a position on the grid multiple times, use the steps value from the **first** time it visits that position when calculating the total value of a specific intersection.

The number of steps a wire takes is the total number of grid squares the wire has entered to get to that location, including the intersection being considered. Again consider the example from above:

```
...........
.+-----+...
.|.....|...
.|..+--X-+.
.|..|..|.|.
.|.-X--+.|.
.|..|....|.
.|.......|.
.o-------+.
...........
```

In the above example, the intersection closest to the central port is reached after 8+5+5+2 = 20 steps by the first wire and 7+6+4+3 = 20 steps by the second wire for a total of 20+20 = 40 steps.

However, the top-right intersection is better: the first wire takes only 8+5+2 = 15 and the second wire takes only 7+6+2 = 15, a total of 15+15 = 30 steps.

Here are the best steps for the extra examples from above:

`R75,D30,R83,U83,L12,D49,R71,U7,L72
U62,R66,U55,R34,D71,R55,D58,R83` = 610 steps
`R98,U47,R26,D63,R33,U87,L62,D20,R33,U53,R51
U98,R91,D20,R16,D67,R40,U7,R15,U6,R7` = 410 steps

**What is the fewest combined steps the wires must take to reach an intersection?**

### Solution

[Implementation](../../src/Wires.elm)

```elm
import Tuple exposing (first, second)
import Wires exposing (..)

input = (
    [Right 1009, Down 117, ...],
    [Up 995, Down 93, ...]
)

-- Solution for part one: 721
(getClosestIntersection
    (manhattanDistance (0, 0))
    (initPath (0,0) (first input))
    (initPath (0,0) (second input)))

-- Solution for part two: 7388
let
    a = (initPath (0,0) (first input))
    b = (initPath (0,0) (second input))
in
getClosestIntersection (pathLengths a b) a b
```

```elm
input =
    ( [Right 1009, Down 117, Left 888, Down 799, Left 611, Up 766, Left 832, Up 859, Left 892, Down 79, Right 645, Up 191, Left 681, Down 787, Right 447, Down 429, Left 988, Up 536, Left 486, Down 832, Right 221, Down 619, Right 268, Down 545, Left 706, Up 234, Left 528, Down 453, Right 493, Down 24, Left 688, Up 658, Left 74, Down 281, Right 910, Down 849, Left 5, Up 16, Right 935, Down 399, Left 417, Up 609, Right 22, Down 782, Left 432, Down 83, Left 357, Down 982, Left 902, Up 294, Left 338, Up 102, Right 342, Down 621, Right 106, Up 979, Left 238, Up 158, Right 930, Down 948, Left 700, Down 808, Right 445, Up 897, Right 980, Up 227, Left 466, Down 416, Right 244, Up 396, Right 576, Up 157, Right 548, Up 795, Right 709, Up 550, Right 137, Up 212, Left 977, Up 786, Left 423, Down 792, Right 391, Down 974, Right 390, Up 771, Right 270, Down 409, Left 917, Down 9, Right 412, Down 699, Left 170, Down 276, Left 912, Up 710, Right 814, Up 656, Right 4, Down 800, Right 596, Up 970, Left 194, Up 315, Left 845, Down 490, Left 303, Up 514, Left 675, Down 737, Left 880, Down 86, Left 253, Down 525, Right 861, Down 5, Right 424, Down 113, Left 764, Down 900, Right 485, Down 421, Right 125, Up 684, Right 53, Up 96, Left 871, Up 260, Right 456, Up 378, Left 448, Down 450, Left 903, Down 482, Right 750, Up 961, Right 264, Down 501, Right 605, Down 367, Right 550, Up 642, Right 228, Up 164, Left 343, Up 868, Right 595, Down 318, Right 452, Up 845, Left 571, Down 281, Right 49, Down 889, Left 481, Up 963, Right 182, Up 358, Right 454, Up 267, Left 790, Down 252, Right 455, Down 188, Left 73, Up 256, Left 835, Down 816, Right 503, Up 895, Left 259, Up 418, Right 642, Up 818, Left 187, Up 355, Right 772, Up 466, Right 21, Up 91, Right 707, Down 349, Left 200, Up 305, Right 931, Down 982, Left 334, Down 416, Left 247, Down 935, Left 326, Up 449, Left 398, Down 914, Right 602, Up 10, Right 762, Down 944, Left 639, Down 141, Left 457, Up 579, Left 198, Up 527, Right 750, Up 167, Right 816, Down 753, Right 850, Down 281, Left 712, Down 583, Left 172, Down 254, Left 544, Down 456, Right 966, Up 839, Right 673, Down 479, Right 730, Down 912, Right 992, Down 969, Right 766, Up 205, Right 477, Down 719, Right 172, Down 735, Right 998, Down 687, Right 698, Down 407, Right 172, Up 945, Right 199, Up 348, Left 256, Down 876, Right 580, Up 770, Left 483, Down 437, Right 353, Down 214, Right 619, Up 541, Right 234, Down 962, Right 842, Up 639, Right 520, Down 354, Left 279, Down 15, Right 42, Up 138, Left 321, Down 376, Left 628, Down 893, Left 670, Down 574, Left 339, Up 298, Left 321, Down 120, Left 370, Up 408, Left 333, Down 353, Left 263, Down 79, Right 535, Down 487, Right 113, Down 638, Right 623, Down 59, Left 508, Down 866, Right 315, Up 166, Left 534, Up 927, Left 401, Down 626, Left 19, Down 994, Left 778, Down 317, Left 936, Up 207, Left 768, Up 948, Right 452, Up 165, Right 864, Down 283, Left 874]
    , [Left 995, Down 93, Left 293, Up 447, Left 793, Down 605, Right 497, Down 155, Left 542, Down 570, Right 113, Down 779, Left 510, Up 367, Left 71, Down 980, Right 237, Up 290, Left 983, Up 49, Right 745, Up 182, Left 922, Down 174, Left 189, Down 629, Right 315, Down 203, Right 533, Up 72, Left 981, Down 848, Left 616, Up 654, Right 445, Down 864, Right 526, Down 668, Left 678, Up 378, Left 740, Down 840, Left 202, Down 429, Right 136, Down 998, Left 116, Down 554, Left 893, Up 759, Right 617, Up 942, Right 999, Up 582, Left 220, Up 447, Right 895, Down 13, Right 217, Up 743, Left 865, Up 950, Right 91, Down 381, Right 662, Down 518, Left 798, Down 637, Left 213, Down 93, Left 231, Down 185, Right 704, Up 581, Left 268, Up 773, Right 405, Up 862, Right 796, Up 73, Left 891, Up 553, Left 952, Up 450, Right 778, Down 868, Right 329, Down 669, Left 182, Up 378, Left 933, Down 83, Right 574, Up 807, Right 785, Down 278, Right 139, Down 362, Right 8, Up 546, Right 651, Up 241, Left 462, Down 309, Left 261, Down 307, Left 85, Up 701, Left 913, Up 271, Right 814, Up 723, Left 777, Down 256, Right 417, Up 814, Left 461, Up 652, Right 198, Down 747, Right 914, Up 520, Right 806, Up 956, Left 771, Down 229, Right 984, Up 685, Right 663, Down 812, Right 650, Up 214, Right 839, Up 574, Left 10, Up 66, Right 644, Down 371, Left 917, Down 819, Left 73, Down 236, Right 277, Up 611, Right 390, Up 723, Left 129, Down 496, Left 552, Down 451, Right 584, Up 105, Left 805, Up 165, Right 179, Down 372, Left 405, Down 702, Right 14, Up 332, Left 893, Down 419, Right 342, Down 146, Right 907, Down 672, Left 316, Up 257, Left 903, Up 919, Left 942, Up 771, Right 879, Up 624, Left 280, Up 150, Left 320, Up 220, Right 590, Down 242, Right 744, Up 291, Right 562, Up 418, Left 898, Up 66, Left 564, Up 495, Right 837, Down 555, Left 739, Down 780, Right 409, Down 122, Left 426, Down 857, Right 937, Down 600, Right 428, Down 592, Right 727, Up 917, Right 256, Down 680, Left 422, Up 630, Left 14, Up 240, Right 617, Down 664, Left 961, Down 554, Left 302, Up 925, Left 376, Down 187, Left 700, Down 31, Left 762, Up 397, Left 554, Down 217, Right 679, Down 683, Right 680, Down 572, Right 54, Down 164, Left 940, Down 523, Right 140, Up 52, Left 506, Down 638, Right 331, Down 415, Right 389, Down 884, Right 410, Down 62, Right 691, Up 665, Right 889, Up 864, Left 663, Down 690, Right 487, Up 811, Left 190, Up 780, Left 758, Up 267, Right 155, Down 344, Left 133, Down 137, Right 93, Down 229, Left 729, Up 878, Left 889, Down 603, Right 288, Up 890, Right 251, Up 531, Left 249, Down 995, Right 863, Down 257, Right 655, Down 311, Right 874, Up 356, Left 833, Up 151, Left 741, Up 246, Right 694, Down 899, Left 48, Up 915, Left 900, Up 757, Left 861, Up 402, Right 971, Up 537, Right 460, Down 844, Right 54, Up 956, Left 151, Up 74, Right 892, Up 248, Right 677, Down 881, Right 99, Down 931, Right 427]
    )
```
