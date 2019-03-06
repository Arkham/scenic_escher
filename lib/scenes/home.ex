defmodule ScenicEscher.Scene.Home do
  use Scenic.Scene

  alias Scenic.Graph

  import Scenic.Primitives

  @graph Graph.build(font: :roboto, font_size: 24, theme: :light)
         |> group(
           fn g ->
             box = %Box{
               a: %Vector{x: 75.0, y: 75.0},
               b: %Vector{x: 500.0, y: 0.0},
               c: %Vector{x: 0.0, y: 500.0}
             }

             {width, height} = Box.dimensions(box)

             fish =
               Fitting.create_picture(
                 Fishy.fish_shapes()
                 # debug: true
               )

             atom =
               Picture.quartet(
                 Picture.ttile(fish),
                 Picture.ttile(fish) |> Picture.turn(),
                 Picture.ttile(fish) |> Picture.turn() |> Picture.turn() |> Picture.turn(),
                 Picture.ttile(fish) |> Picture.turn() |> Picture.turn()
               )

             picture =
               Picture.quartet(
                 atom,
                 atom,
                 atom,
                 atom
               )

             paths =
               box
               |> picture.()
               |> Rendering.to_paths({width, height})

             initial = g
             # |> text("Hello!", fill: :black, translate: {20, 40})

             paths
             |> Enum.reduce(initial, fn {elem, options}, acc ->
               acc
               |> path(elem, options)
             end)
           end,
           translate: {20, 60}
         )

  def init(_, _) do
    Process.register(self(), __MODULE__)
    push_graph(@graph)
    {:ok, @graph}
  end
end
