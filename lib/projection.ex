defmodule Projection do
  def to_circle(%Box{a: a, b: b, c: c}) do
    fn vector ->
      scaled_center = Vector.scale(0.5, Vector.add(b, c))
      box_center = Vector.add(a, scaled_center)

      # We want to transpose the vector in a world
      # where the maximum value for x and y is 1.0
      %{x: x, y: y} = Vector.sub(vector, box_center)
      x_ = x / scaled_center.x
      y_ = y / scaled_center.y

      # We want to map a point in a square to a point in a circle.
      # From https://www.xarg.org/2017/07/how-to-map-a-square-to-a-circle
      # Since we are not mapping points but straight lines, I've changed
      # the root factor from 1/2 to 3/5.
      root_factor = 3 / 5
      circle_x = x_ * :math.pow(1 - y_ * y_ / 2, root_factor)
      circle_y = y_ * :math.pow(1 - x_ * x_ / 2, root_factor)

      # go back to normal values
      Vector.build(
        circle_x * scaled_center.x,
        circle_y * scaled_center.y
      )
      |> Vector.add(box_center)
    end
  end
end
