defmodule ScenicEscher.Scene.Home do
  use Scenic.Scene

  alias Scenic.Graph

  import Scenic.Primitives

  @note """
    Hello World!
  """

  @graph Graph.build(font: :roboto, font_size: 24, theme: :light)
         |> group(
           fn g ->
             box = %Box{
               a: %Vector{x: 75.0, y: 75.0},
               b: %Vector{x: 250.0, y: 0.0},
               c: %Vector{x: 0.0, y: 250.0}
             }

             {width, height} = Box.dimensions(box)

             shapes = Shape.george

             picture = Fitting.create_picture(shapes)

             paths =
               box
               |> picture.()
               |> Rendering.to_paths({width, height})
               |> IO.inspect()

             initial = g
             # |> text(@note, fill: :black, translate: {20, 40})

             paths
             |> Enum.reduce(initial, fn {elem, options}, acc ->
               acc
               |> path(elem, options)
             end)
           end,
           translate: {20, 20}
         )

  # ============================================================================
  # setup

  # --------------------------------------------------------
  def init(_, _) do
    push_graph(@graph)
    {:ok, @graph}
  end
end
