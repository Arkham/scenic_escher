defmodule ScenicEscher.Scene.Home do
  use Scenic.Scene

  alias Scenic.Graph

  import Scenic.Primitives
  import Picture

  @graph Graph.build(font: :roboto, font_size: 24, theme: :light)
         |> group(
           fn g ->
             # We create a box
             box = %Box{
               a: Vector.build(75.0, 75.0),
               b: Vector.build(400.0, 0.0),
               c: Vector.build(0.0, 400.0)
             }

             # We create a fish
             fish = Fitting.create_picture(Fishy.fish_shapes())

             # Then we compose the fish in a square limit
             picture = Picture.square_limit(5, fish)

             # We run the picture function and obtain some points.
             # Then we convert them to scenic-friendly data.
             paths =
               box
               |> picture.()
               |> Rendering.to_paths(Box.dimensions(box))

             # We draw the paths using scenic
             paths
             |> Enum.reduce(g, fn {elem, options}, acc ->
               path(acc, elem, options)
             end)
           end,
           translate: {75, 75}
         )

  def init(_, _) do
    Process.register(self(), __MODULE__)
    push_graph(@graph)
    {:ok, @graph}
  end
end
