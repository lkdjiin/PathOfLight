# Path of Light

[Work In Progress] A ray tracer based on the book «The Ray Tracer Challenge».

## Dependencies

- Julia >= 1.1.0

## Exploring the code

The book is full of the «Tuple» concept. As Julia already has a built-in type
with that name, I changed it to «Element».

Julia has a function `Base.position`, so I use `location(ray, distance)`
instead of the book's `position(ray, distance)`.
For the same reason:
- `intersect` becomes `intersects`
