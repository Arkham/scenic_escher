defmodule Box do
  @moduledoc """
  Describes a box model composed by three vectors:

  - `a` connects the origin (0, 0) with the bottom left corner of the box.
  - `b` describes how wide the box is, connecting the bottom left corner with the bottom right corner.
  - `c` describes how tall the box is, connecting the bottom left corner with the top left corner.
  """

  defstruct [:a, :b, :c]

  def dimensions(%Box{a: a, b: b, c: c}) do
    {a.x + b.x, a.y + c.y}
  end

  def turn(%Box{a: a, b: b, c: c}) do
    %Box{a: Vector.add(a, b), b: c, c: Vector.neg(b)}
  end

  def flip(%Box{a: a, b: b, c: c}) do
    %Box{a: Vector.add(a, b), b: Vector.neg(b), c: c}
  end

  def toss(%Box{a: a, b: b, c: c}) do
    %Box{
      a: Vector.add(a, Vector.scale(0.5, Vector.add(b, c))),
      b: Vector.scale(0.5, Vector.add(b, c)),
      c: Vector.scale(0.5, Vector.add(c, Vector.neg(b)))
    }
  end

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

  def split_vertically(factor, %Box{a: a, b: b, c: c}) do
    left_ratio = factor

    right_ratio = 1 - left_ratio

    left = %Box{
      a: a,
      b: Vector.scale(left_ratio, b),
      c: c
    }

    right = %Box{
      a: Vector.add(a, Vector.scale(left_ratio, b)),
      b: Vector.scale(right_ratio, b),
      c: c
    }

    {left, right}
  end
end
