defmodule ScenicEscher.Scene.Home do
  use Scenic.Scene

  alias Scenic.Graph

  import Scenic.Primitives
  # import Scenic.Components

  @note """
    This is a very simple starter application.

    If you want a more full-on example, please start from:

    mix scenic.new.example
  """

  @graph Graph.build(font: :roboto, font_size: 24)
         |> group(
           fn g ->
             g
             |> text(@note, translate: {20, 60})
             |> path(
               [
                 :begin,
                 {:move_to, 0, 0},
                 {:bezier_to, 0, 20, 0, 50, 40, 50},
                 {:bezier_to, 60, 50, 60, 20, 80, 20},
                 {:bezier_to, 100, 20, 110, 0, 120, 0},
                 {:bezier_to, 140, 0, 160, 30, 160, 50}
               ],
               stroke: {2, :red},
               translate: {355, 230},
               rotate: 0.5
             )
           end,
           translate: {15, 20}
         )

  # ============================================================================
  # setup

  # --------------------------------------------------------
  def init(_, _) do
    push_graph(@graph)
    {:ok, @graph}
  end
end
