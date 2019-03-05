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

      {{:curve, {v1, v2, v3, v4}}, style} ->
        {[
           :begin,
           {:move_to, v1.x, v1.y},
           {:bezier_to, v2.x, v2.y, v3.x, v3.y, v4.x, v4.y}
         ], style}
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

  def mirror_shape(height, {:curve, {v1, v2, v3, v4}}) do
    v1_ = mirror_vector(height, v1)
    v2_ = mirror_vector(height, v2)
    v3_ = mirror_vector(height, v3)
    v4_ = mirror_vector(height, v4)
    {:curve, {v1_, v2_, v3_, v4_}}
  end
end
