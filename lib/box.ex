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
end
