defmodule Rendering do
  def to_paths(styled_shapes, {_width, height}) do
    styled_shapes
    |> Enum.map(fn {shape, style} ->
      {mirror_shape(height, shape), style}
    end)
    |> Enum.map(fn
      {{:polygon, [first | rest]}, style} ->
        result =
          [:begin, {:move_to, first.x, first.y}] ++
            Enum.map(rest, fn %{x: x, y: y} -> {:line_to, x, y} end) ++
            [:close_path]

        {result, style}

      {{:polyline, [first | rest]}, style} ->
        result =
          [:begin, {:move_to, first.x, first.y}] ++
            Enum.map(rest, fn %{x: x, y: y} -> {:line_to, x, y} end)

        {result, style}
    end)
  end

  def mirror_vector(height, %Vector{x: x, y: y}) do
    %Vector{x: x, y: height - y}
  end

  def mirror_shape(height, {:polygon, points}) do
    {:polygon, Enum.map(points, &mirror_vector(height, &1))}
  end

  def mirror_shape(height, {:polyline, points}) do
    {:polyline, Enum.map(points, &mirror_vector(height, &1))}
  end
end
