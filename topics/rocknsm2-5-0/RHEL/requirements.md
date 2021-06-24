# Hardware Requirements

The analysis of live network data is a resource intensive task. The bottom line
is this: if you throw hardware at ROCK it will use it, and use it well. The higher
the [IOPS](https://en.wikipedia.org/wiki/IOPS) the better.

Here's a starting point to get you moving:

| RESOURCE | RECOMMENDATION                                                  |
|----------|-----------------------------------------------------------------|
| CPU      | 4 or more physical cores                                        |
| Memory   | 16GB (10GB is doable, 16 is better)                              |
| Storage  | 256GB, with 200+ of that dedicated to /data, SSD preferred      |
| Network  | 2 gigabit interfaces, one for management and one for collection |

Move on to the [Sensor Deployment](sensordeploy.md)
