defmodule ScenicEscher.Scene.Home do
  use Scenic.Scene

  alias Scenic.Graph

  import Scenic.Primitives

  @graph Graph.build(font: :roboto, font_size: 24, theme: :light)
         |> group(
           fn g ->
             box = %Box{
               a: %Vector{x: 75.0, y: 75.0},
               b: %Vector{x: 300.0, y: 0.0},
               c: %Vector{x: 0.0, y: 300.0}
             }

             {width, height} = Box.dimensions(box)

             fish =
               Fitting.create_picture(
                 Fishy.fish_shapes(),
                 debug: true
               )

             picture = fish

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
           translate: {20, 20}
         )

  def init(_, _) do
    Process.register(self(), __MODULE__)
    push_graph(@graph)
    {:ok, @graph}
  end
end
