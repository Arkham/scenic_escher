defmodule Shape do
  # Shapes can be:
  #
  # - `{:polyline, vectors}`, a list of vectors
  # - `{:polygon, vectors}`, a self-closing list of vectors
  # - `{:curve, {v1, v2, v3, v4}}`, a bezier curve

  def map_vectors({:polyline, vectors}, map_fn) do
    {:polyline, Enum.map(vectors, fn vector -> map_fn.(vector) end)}
  end

  def map_vectors({:polygon, vectors}, map_fn) do
    {:polygon, Enum.map(vectors, fn vector -> map_fn.(vector) end)}
  end

  def map_vectors({:curve, {v1, v2, v3, v4}}, map_fn) do
    {:curve,
     {
       map_fn.(v1),
       map_fn.(v2),
       map_fn.(v3),
       map_fn.(v4)
     }}
  end
end
