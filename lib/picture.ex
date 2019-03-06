defmodule Picture do
  # A picture is a lambda function that takes a box and produces a list
  # of {shape, style} tuples. Think of it as something like this:
  #
  # picture =
  #   fn box ->
  #     render_stuff_with box
  #   end
  #
  # The nice thing about this idea is that we can transform the picture
  # by just transforming the box. For example, if we want to turn the picture
  # we could just do something like:
  #
  # turned_picture =
  #   fn box ->
  #     box
  #     |> Box.turn
  #     |> picture.()
  #   end

  def turn(picture) do
    fn box ->
      box
      |> Box.turn()
      |> picture.()
    end
  end

  def flip(picture) do
    fn box ->
      box
      |> Box.flip()
      |> picture.()
    end
  end

  def toss(picture) do
    fn box ->
      box
      |> Box.toss()
      |> picture.()
    end
  end

  def above_ratio(m, n, p1, p2) do
    fn box ->
      factor = m / (m + n)

      {box_above, box_below} = Box.split_horizontally(factor, box)

      p1.(box_above) ++ p2.(box_below)
    end
  end

  def above(p1, p2) do
    above_ratio(1, 1, p1, p2)
  end

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

  def quartet(p1, p2, p3, p4) do
    above(
      beside(p1, p2),
      beside(p3, p4)
    )
  end

  def over(p1, p2) do
    fn box ->
      p1.(box) ++ p2.(box)
    end
  end

  def over(list) when is_list(list) do
    fn box ->
      Enum.flat_map(list, fn elem ->
        elem.(box)
      end)
    end
  end

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
end
