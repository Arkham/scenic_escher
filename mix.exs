defmodule ScenicEscher.MixProject do
  use Mix.Project

  def project do
    [
      app: :scenic_escher,
      version: "0.1.0",
      elixir: "~> 1.8",
      build_embedded: true,
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      mod: {ScenicEscher, []},
      extra_applications: []
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:scenic, "~> 0.9"},
      {:scenic_driver_glfw, "~> 0.9", targets: :host},
      {:exsync, git: "https://github.com/Arkham/exsync", branch: "support-escher", only: :dev}
    ]
  end
end
