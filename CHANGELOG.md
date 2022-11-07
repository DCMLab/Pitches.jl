# Changes

## 0.1.2

- The definition of `sign` has been updated for spelled pitches:
  - Unisons now have a direction (e.g., `sign(a1:0) == 1`).
  - As a consequence, the `alteration` of `d1:0` (= `-a1:0`) is now 1
    because it is considered downward.
  - The interval class `d1` is considered downward:
  - For interval classes, `sign` takes the shortest realization (as before)
    but `alteration` always considers the upward interval (as in printing).-

## 0.1.0/0.1.1

- first version
