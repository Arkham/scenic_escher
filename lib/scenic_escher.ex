defmodule ScenicEscher do
  @moduledoc """
  Starter application using the Scenic framework.
  """

  def start(_type, _args) do
    # load the viewport configuration from config
    main_viewport_config = Application.get_env(:scenic_escher, :viewport)

    # start the application with the viewport
    children = [
      ScenicEscher.Refresher,
      {Scenic, viewports: [main_viewport_config]}
    ]

    Supervisor.start_link(children, strategy: :one_for_one)
  end
end
