defmodule Fitting do
  def mapper(%Box{a: a, b: b, c: c}, %Vector{x: x, y: y}) do
    scaled_b = Vector.scale(x, b)
    scaled_c = Vector.scale(y, c)

    Vector.add(a, Vector.add(scaled_b, scaled_c))
  end

  def get_stroke_width(%Box{b: b, c: c}) do
    ratio = max(Vector.length(b), Vector.length(c)) / 100.0
    max(ratio, 1.0)
  end

  def create_picture(shapes, options \\ []) do
    debug = Keyword.get(options, :debug, false)

    fn box ->
      %{a: a, b: b, c: c} = box

      stroke_width = get_stroke_width(box)

      styled_shapes =
        shapes
        |> Enum.map(fn
          {:polygon, points} ->
            {:polygon, Enum.map(points, fn point -> mapper(box, point) end)}

          {:polyline, points} ->
            {:polyline, Enum.map(points, fn point -> mapper(box, point) end)}

          {:curve, {v1, v2, v3, v4}} ->
            {:curve,
             {
               mapper(box, v1),
               mapper(box, v2),
               mapper(box, v3),
               mapper(box, v4)
             }}
        end)
        |> Enum.map(fn shape ->
          {shape, %{stroke: {stroke_width, :black}}}
        end)

      box_lines = [
        {{:polyline,
          [
            a,
            %Vector{x: 0.0, y: 0.0}
          ]}, %{stroke: {stroke_width, :red}}},
        {{:polyline,
          [
            a,
            Vector.add(a, b)
          ]}, %{stroke: {stroke_width, :orange}}},
        {{:polyline,
          [
            a,
            Vector.add(a, c)
          ]}, %{stroke: {stroke_width, :purple}}}
      ]

      if debug do
        box_lines ++ styled_shapes
      else
        styled_shapes
      end
    end
  end
end
