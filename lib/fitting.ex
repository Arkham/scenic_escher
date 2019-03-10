defmodule Fitting do
  def mapper(%Box{a: a, b: b, c: c}) do
    fn %Vector{x: x, y: y} ->
      scaled_b = Vector.scale(x, b)
      scaled_c = Vector.scale(y, c)

      Vector.add(a, Vector.add(scaled_b, scaled_c))
    end
  end

  def get_stroke_width(%Box{b: b, c: c}) do
    ratio = max(Vector.length(b), Vector.length(c)) / 100.0
    max(ratio, 0.5)
  end

  def create_picture(shapes, options \\ []) do
    debug = Keyword.get(options, :debug, false)

    fn box ->
      box_mapper = mapper(box)
      stroke_width = get_stroke_width(box)

      styled_shapes =
        shapes
        |> Enum.map(&Shape.map_vectors(&1, box_mapper))
        |> Enum.map(fn shape ->
          {shape, %{stroke: {stroke_width, :black}}}
        end)

      if debug do
        box_lines(box, stroke_width) ++ styled_shapes
      else
        styled_shapes
      end
    end
  end

  defp box_lines(%Box{a: a, b: b, c: c}, stroke_width) do
    [
      {{:polyline,
        [
          a,
          Vector.build(0, 0)
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
  end
end
