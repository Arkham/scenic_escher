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
               b: %Vector{x: 500.0, y: 0.0},
               c: %Vector{x: 0.0, y: 500.0}
             }

             {width, height} = Box.dimensions(box)

             george = Fitting.create_picture(Figure.george())

             atom =
               Picture.above(
                 george,
                 george |> Picture.turn() |> Picture.turn()
               )

             molecule =
               Picture.beside(
                 atom,
                 atom |> Picture.flip()
               )

             simple =
               Picture.quartet(
                 molecule,
                 molecule,
                 molecule,
                 molecule
               )

             picture =
               Picture.quartet(
                 simple,
                 simple,
                 simple,
                 simple
               )

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

  def init(_, _) do
    push_graph(@graph)
    {:ok, @graph}
  end
end
