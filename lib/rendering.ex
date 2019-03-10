defmodule Rendering do
  def to_paths(styled_shapes, {_width, height}) do
    mirror_fn = mirror(height)

    styled_shapes
    |> Enum.map(fn {shape, style} ->
      {Shape.map_vectors(shape, mirror_fn), style}
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

  def mirror(height) do
    fn %Vector{x: x, y: y} ->
      Vector.build(x, height - y)
    end
  end
end
