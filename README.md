# Scenic Escher

An implementation of Escher's Square Limit using Scenic and Elixir.

This work is based on the [Functional Geometry
paper](https://eprints.soton.ac.uk/257577/1/funcgeo2.pdf) by Peter Henderson. Here's the abstract:

```
An algebra of pictures is described that is sufficiently powerful to denote
the structure of a well-known Escher woodcut, Square Limit. A decomposition of the
picture that is reasonably faithful to Escher's original design is given. This illustrates
how a suitably chosen algebraic specification can be both a clear description and a
practical implementation method. It also allows us to address some of the criteria
that make a good algebraic description.
```

## How to run

Pull the repo

```
git clone https://github.com/Arkham/scenic_escher
```

Install and compile all the dependencies

```
mix deps.get && mix deps.compile
```

Then run the program

```
iex -S mix scenic.run
```

You should see something like this

![](https://github.com/Arkham/scenic_escher/blob/master/images/square_limit.png)

## How does it work

A vector connects the origin to a specific point `(x, y)`. You can create one
like this: `Vector.build(0, 1)`.

A box is defined by three vectors, `a`, `b` and `c`. In the picture below, `a`
is red, `b` is orange and `c` is purple.

<img src="https://github.com/Arkham/scenic_escher/blob/master/images/box.png"
width="400" height="400">

A picture is an anonymous function that takes a box and emits a list of shapes.
So a simple picture that creates a diagonal line would look like this:

```elixir
def diagonal do
  fn %Box{a: a, b: b, c: c} ->
    v1 = Vector.build(a.x, a.y)
    v2 = Vector.build(a.x + b.x, a.y + c.y)
    {:polyline, [v1, v2]}
  end
end
```

<img src="https://github.com/Arkham/scenic_escher/blob/master/images/diagonal.png" width="400" height="400">

As you can see, it becomes quite error prone to create vectors by manipulating
their individual `x` and `y` properties. Instead we can use vector algebra to
achieve the same result in a much cleaner way:

```elixir
def diagonal do
  fn %Box{a: a, b: b, c: c} ->
    {:polyline, [
      a,
      Vector.add(a, Vector.add(b, c))
    ]}
  end
end
```

A picture that creates a triangle would look like this:

```elixir
def triangle do
  fn %Box{a: a, b: b, c: c} ->
    {:polygon, [
      Vector.add(a, b),
      Vector.add(a, Vector.add(b, c)),
      Vector.add(a, c)
    ]}
  end
end
```

<img src="https://github.com/Arkham/scenic_escher/blob/master/images/triangle.png" width="400" height="400">

It would be nice to define the properties of the triangle without having to
interact with the box model. It could look like this:

```elixir
def triangle_shape do
  {:polygon, [
    Vector.build(0, 1),
    Vector.build(1, 1),
    Vector.build(1, 0)
  ]}
end
```

Then we could write a function that automatically fits that into our box model:

```elixir
def fit_shape(shapes, %Box{a: a, b: b, c: c}) do
  map_point = fn %Vector{x: x, y: y} ->
    scaled_b = Vector.scale(x, b)
    scaled_c = Vector.scale(y, c)

    Vector.add(a, Vector.add(scaled_b, scaled_c))
  end

  shapes
  |> Enum.map(fn
    {:polyline, points} ->
      {:polyline, Enum.map(points, map_point)}

    {:polygon, points} ->
      {:polygon, Enum.map(points, map_point)}
    end)
end
```

This is exactly what the `Fitting.create_picture` function does!

Now let's say we wanted to draw the letter `F`. We could write a function like this:

```elixir
def f do
  [
    {:polygon,
     [
       Vector.build(0.3, 0.2),
       Vector.build(0.4, 0.2),
       Vector.build(0.4, 0.45),
       Vector.build(0.6, 0.45),
       Vector.build(0.6, 0.55),
       Vector.build(0.4, 0.55),
       Vector.build(0.4, 0.7),
       Vector.build(0.7, 0.7),
       Vector.build(0.7, 0.8),
       Vector.build(0.3, 0.8)
     ]}
  ]
end
```

This would look like this!

<img src="https://github.com/Arkham/scenic_escher/blob/master/images/letter_f.png" width="400" height="400">

The amazing thing about defining a picture as an anonymous function is that we
can transform the picture by calling functions on the box. For example, if we
had a `turn_box` function that rotated the box left, we could then rotate the
picture by just calling that.

```elixir
def turn_box(%Box{a: a, b: b, c: c}) do
  %Box{
    a: Vector.add(a, b),
    b: c,
    c: Vector.neg(b)
  }
end

def turn_picture(picture) do
  fn box ->
    box
    |> turn_box()
    |> picture.()
  end
end
```

If we applied this code to our `F` we would see something like this:

<img src="https://github.com/Arkham/scenic_escher/blob/master/images/letter_f_turned.png" width="400" height="400">


So this is how you would hook the whole thing together:


```elixir
Graph.build(font: :roboto, font_size: 24, theme: :light)
  |> group(fn g ->
    # We create a box
    box = %Box{
      a: Vector.build(75.0, 75.0),
      b: Vector.build(500.0, 0.0),
      c: Vector.build(0.0, 500.0)
    }

    # We create our F letter which will automatically fit to the box
    picture =
      Fitting.create_picture(Letter.f())
      |> Picture.turn()

    # We run the picture function and obtain some points.
    # Then we convert them to scenic-friendly data.
    paths =
      box
      |> picture.()
      |> Rendering.to_paths(Box.dimensions(box))

    # We draw the paths using scenic
    paths
    |> Enum.reduce(g, fn {elem, options}, acc ->
      path(acc, elem, options)
    end)
  end)
```

This is very similar to the code you will find in `lib/scenes/home.ex`. The call
to `Rendering.to_paths` transforms our shapes into scenic data types. In the
final example we see something like this:

```
# We create a fish
fish = Fitting.create_picture(Fishy.fish_shapes())

# Then we compose the fish in a square limit
picture = Picture.square_limit(5, fish)
```

Here we create a fish and compose it multiple times to form the Square Limit composition.

<img src="https://github.com/Arkham/scenic_escher/blob/master/images/square_limit.png" width="400" height="400">

If we wanted to get fancy we could try to apply a projection of that image to a
circle!

```elixir
# We create a fish
fish = Fitting.create_picture(Fishy.fish_shapes())

# Then we compose the fish in a square limit
picture = Picture.square_limit(5, fish)

# Create a projection function that maps a square to a circle
projection = Projection.to_circle(box)

# We run the picture function and obtain some points.
# Then we convert them to scenic-friendly data.
paths =
  box
  |> picture.()
  |> Enum.map(fn {shape, style} ->
    {Shape.map_vectors(shape, projection), style}
  end)
  |> Rendering.to_paths(Box.dimensions(box))
```

And now we will see a Circle Limit!

<img src="https://github.com/Arkham/scenic_escher/blob/master/images/circle_limit.png" width="400" height="400">

## Credits

Huge props to https://github.com/einarwh/escher-workshop
