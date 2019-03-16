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
like this:

```elixir
iex(1)> Vector.build(1, 0)
%Vector{x: 1, y: 0}
```

Once we have vectors, we can describe geometrical operations on vectors such as
adding, subtracting, negating and scaling them:

```elixir
iex(1)> Vector.add(Vector.build(1, 0), Vector.build(1, 1))
%Vector{x: 2, y: 1}

iex(2)> Vector.sub(Vector.build(1, 0), Vector.build(1, 1))
%Vector{x: 0, y: -1}

iex(3)> Vector.neg(Vector.build(1, 2))
%Vector{x: -1, y: -2}

iex(4)> Vector.scale(4, Vector.build(1, 0))
%Vector{x: 4, y: 0}
```

A box is defined by three vectors, `a`, `b` and `c`.

```elixir
box = %Box{
  a: Vector.build(75.0, 75.0),
  b: Vector.build(500.0, 0.0),
  c: Vector.build(0.0, 500.0)
}
```

In the picture below, `a` is red, `b` is orange and `c` is purple.

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

Now let's say we wanted to draw the letter `f`. We could write a function like this:

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
had a `turn` function that rotated the box left, we could then rotate the
picture by just calling that.

```elixir
defmodule Box do
  def turn(%Box{a: a, b: b, c: c}) do
    %Box{
      a: Vector.add(a, b),
      b: c,
      c: Vector.neg(b)
    }
  end
end

defmodule Picture do
  def turn(picture) do
    fn box ->
      box
      |> Box.turn()
      |> picture.()
    end
  end
end
```

If we applied this code to our `f` we would see something like this:

<img src="https://github.com/Arkham/scenic_escher/blob/master/images/letter_f_turned.png" width="400" height="400">

In a similar way, we could describe the horizontal flipping of a picture as
an horizontal flipping of the box that contains such picture.

```elixir
defmodule Box do
  def flip(%Box{a: a, b: b, c: c}) do
    %Box{
      a: Vector.add(a, b),
      b: Vector.neg(b),
      c: c
    }
  end
end

defmodule Picture do
  def flip(picture) do
    fn box ->
      box
      |> Box.flip()
      |> picture.()
    end
  end
end
```

And if we applied this to our `f` letter we would obtain this:

<img src="https://github.com/Arkham/scenic_escher/blob/master/images/letter_f_flipped.png" width="400" height="400">

What if we wanted to display two pictures side by side? We can think of a
function that takes a box and returns a tuple `{left_box, right_box}`:

```elixir
defmodule Box do
  def split_vertically(%Box{a: a, b: b, c: c}) do
    left_box = %Box{
      a: a,
      b: Vector.scale(0.5, b),
      c: c
    }

    right_box = %Box{
      a: Vector.add(a, Vector.scale(0.5, b)),
      b: Vector.scale(0.5, b),
      c: c
    }

    {left_box, right_box}
  end
end
```

Then we can build a function that takes two pictures and applies the first one
to the left box and the second one to the right box:

```elixir
defmodule Picture do
  def beside(p1, p2) do
    fn box ->
      {left_box, right_box} = Box.split_vertically(box)

      p1.(left_box) ++ p2.(right_box)
    end
  end
end
```

Applying this function to two `f` letters would look like this:

<img src="https://github.com/Arkham/scenic_escher/blob/master/images/letter_f_beside.png" width="400" height="400">

But what if we applied this function to `f` and `Picture.flip(f)`? Then this
would happen!

<img src="https://github.com/Arkham/scenic_escher/blob/master/images/letter_f_beside_flipped.png" width="400" height="400">

Pretty neat, no?

It turns out we can generalize the above functions to specify a ratio, so we can
control how much space we want to allocate to the left and right.

```elixir
defmodule Box do
  def split_horizontally(factor, %Box{a: a, b: b, c: c}) do
    above_ratio = factor

    below_ratio = 1 - above_ratio

    above = %Box{
      a: Vector.add(a, Vector.scale(below_ratio, c)),
      b: b,
      c: Vector.scale(above_ratio, c)
    }

    below = %Box{
      a: a,
      b: b,
      c: Vector.scale(below_ratio, c)
    }

    {above, below}
  end
end

defmodule Picture do
  def beside_ratio(m, n, p1, p2) do
    fn box ->
      factor = m / (m + n)

      {box_left, box_right} = Box.split_vertically(factor, box)

      p1.(box_left) ++ p2.(box_right)
    end
  end

  def beside(p1, p2) do
    beside_ratio(1, 1, p1, p2)
  end
end
```

With these functions we could write something like `Picture.beside_ratio(1, 2, f, f)` and obtain something like this:

<img src="https://github.com/Arkham/scenic_escher/blob/master/images/letter_f_beside_ratio.png" width="400" height="400">

Now imagine that just like our `beside` and `beside_ratio` functions, we would
have another couple of functions that are called `above` and `above_ratio`,
which would position two pictures above one another. You can check out their
implementation in `lib/picture.ex`.

With those functions in place we can implement a function that takes four
pictures and creates a quartet:

```elixir
def quartet(p1, p2, p3, p4) do
  above(
    beside(p1, p2),
    beside(p3, p4)
  )
end
```

Applying this to four `f` letters would look like this:

<img src="https://github.com/Arkham/scenic_escher/blob/master/images/letter_f_quartet.png" width="400" height="400">

Similarly, we could write a function that puts nine pictures together in a
three-by-three grid:

```elixir
def nonet(p1, p2, p3, p4, p5, p6, p7, p8, p9) do
  above_ratio(
    1,
    2,
    beside_ratio(1, 2, p1, beside(p2, p3)),
    above(
      beside_ratio(1, 2, p4, beside(p5, p6)),
      beside_ratio(1, 2, p7, beside(p8, p9))
    )
  )
end
```

And if we apply nine `f` letters to this function we would see this:

<img src="https://github.com/Arkham/scenic_escher/blob/master/images/letter_f_nonet.png" width="400" height="400">

As a fun intermezzo, let's implement a function that takes a picture and throws
it into the air. We will rotate the image by 45 degrees and shrink its area by
half:

```elixir
defmodule Box do
  def toss(%Box{a: a, b: b, c: c}) do
    %Box{
      a: Vector.add(a, Vector.scale(0.5, Vector.add(b, c))),
      b: Vector.scale(0.5, Vector.add(b, c)),
      c: Vector.scale(0.5, Vector.add(c, Vector.neg(b)))
    }
  end
end

defmodule Picture do
  def toss(picture) do
    fn box ->
      box
      |> Box.toss()
      |> picture.()
    end
  end
end
```

You don't need to worry too much about the vector arithmetics, here's what it
would look like:

<img src="https://github.com/Arkham/scenic_escher/blob/master/images/letter_f_tossed.png" width="400" height="400">

Cool!

Now let's take a look at a fish.

<img src="https://github.com/Arkham/scenic_escher/blob/master/images/fish.png" width="400" height="400">

This image has some really interesting properties. Let's define a `over`
function that stacks a bunch of pictures on top of one another:

```elixir
defmodule Picture do
  def over(list) when is_list(list) do
    fn box ->
      Enum.flat_map(list, fn elem ->
        elem.(box)
      end)
    end
  end
end
```

Applying this to `fish` and `fish |> turn |> turn` yields this

<img src="https://github.com/Arkham/scenic_escher/blob/master/images/fish_over.png" width="400" height="400">

Now we will define a function called `ttile` which is fundamental in building
the fractal structure of the painting. We will see that the fish pattern is
indeed amazing:

```elixir
def ttile(fish) do
  fn box ->
    side = fish |> toss |> flip

    over([
      fish,
      side |> turn,
      side |> turn |> turn
    ]).(box)
  end
end
```

<img src="https://github.com/Arkham/scenic_escher/blob/master/images/fish_ttile.png" width="400" height="400">

And our final basic block is the tile which will build the diagonals of our
square, the `utile` function:

```elixir
def utile(fish) do
  fn box ->
    side = fish |> toss |> flip

    over([
      side,
      side |> turn,
      side |> turn |> turn,
      side |> turn |> turn |> turn
    ]).(box)
  end
end
```

<img src="https://github.com/Arkham/scenic_escher/blob/master/images/fish_utile.png" width="400" height="400">

With these tiles we can now create a recursive function called `side` which
creates the side of our square. This function will take a parameter which
specifies the depth of the recursion.

```
def side(0, _fish), do: fn _ -> [] end

def side(n, fish) when n > 0 do
  fn box ->
    quartet(
      side(n - 1, fish),
      side(n - 1, fish),
      turn(ttile(fish)),
      ttile(fish)
    ).(box)
  end
end
```

- If we pass `0`, we will just have an empty picture.
- If we pass `1`, we wil have something that looks like this

<img src="https://github.com/Arkham/scenic_escher/blob/master/images/fish_side_1.png" width="400" height="400">

- If we pass `2`, we wil have something that looks like this

<img src="https://github.com/Arkham/scenic_escher/blob/master/images/fish_side_2.png" width="400" height="400">

This is starting to look great!

Now that we have our sides, we can build corners! `corner` is another recursive
function that will take a parameter which denotes the depth of the recursion:

```elixir
def corner(0, _fish), do: fn _ -> [] end

def corner(n, fish) when n > 0 do
  fn box ->
    quartet(
      corner(n - 1, fish),
      side(n - 1, fish),
      side(n - 1, fish) |> turn,
      utile(fish)
    ).(box)
  end
end
```

- If we pass `0`, we will just have an empty picture.
- If we pass `1`, we wil have something that looks like this

<img src="https://github.com/Arkham/scenic_escher/blob/master/images/fish_corner_1.png" width="400" height="400">

- If we pass `2`, we wil have something that looks like this

<img src="https://github.com/Arkham/scenic_escher/blob/master/images/fish_corner_2.png" width="400" height="400">

Finally, the last step!

By combining a central `utile` and a sequence of `side` and `corner` we can
implement the Square Limit.

```elixir
def square_limit(0, _fish), do: fn _ -> [] end

def square_limit(n, fish) when n > 0 do
  fn box ->
    corner = corner(n - 1, fish)
    side = side(n - 1, fish)

    nw = corner
    nc = side
    ne = corner |> turn |> turn |> turn
    mw = side |> turn
    mc = utile(fish)
    me = side |> turn |> turn |> turn
    sw = corner |> turn
    sc = side |> turn |> turn
    se = corner |> turn |> turn

    nonet(
      nw,
      nc,
      ne,
      mw,
      mc,
      me,
      sw,
      sc,
      se
    ).(box)
  end
end
```

Let's see how it looks with different depths:

- With depth `1`, it's just a `utile`

<img src="https://github.com/Arkham/scenic_escher/blob/master/images/square_limit_1.png" width="400" height="400">

- With depth `2`, it's a `utile` surrounded by a line of sides and corners

<img src="https://github.com/Arkham/scenic_escher/blob/master/images/square_limit_2.png" width="400" height="400">

- With depth `3`, we've added another layer around the previous one

<img src="https://github.com/Arkham/scenic_escher/blob/master/images/square_limit_3.png" width="400" height="400">

- With depth `5`, it's looking really great

<img src="https://github.com/Arkham/scenic_escher/blob/master/images/square_limit.png" width="400" height="400">

Mission complete!

## Scenic integration

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
