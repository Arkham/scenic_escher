defmodule Fishy do
  def fish_shapes do
    fish_curves()
    |> Enum.map(fn curve -> {:curve, curve} end)
  end

  defp vector(x, y) do
    Vector.build(x, y)
  end

  defp curve(v1, v2, v3, v4) do
    {v1, v2, v3, v4}
  end

  defp fish_curves do
    [
      # C1
      curve(
        vector(0.116, 0.702),
        vector(0.26, 0.295),
        vector(0.33, 0.258),
        vector(0.815, 0.078)
      ),
      # C2
      curve(
        vector(0.564, 0.032),
        vector(0.73, 0.056),
        vector(0.834, 0.042),
        vector(1.0, 0.0)
      ),
      # C3
      curve(
        vector(0.25, 0.25),
        vector(0.372, 0.194),
        vector(0.452, 0.132),
        vector(0.564, 0.032)
      ),
      # C4
      curve(
        vector(0.0, 0.0),
        vector(0.11, 0.11),
        vector(0.175, 0.175),
        vector(0.25, 0.25)
      ),
      # C5
      curve(
        vector(-0.25, 0.25),
        vector(-0.15, 0.15),
        vector(-0.09, 0.09),
        vector(0.0, 0.0)
      ),
      # C6
      curve(
        vector(-0.25, 0.25),
        vector(-0.194, 0.372),
        vector(-0.132, 0.452),
        vector(-0.032, 0.564)
      ),
      # C7
      curve(
        vector(-0.032, 0.564),
        vector(0.055, 0.355),
        vector(0.08, 0.33),
        vector(0.25, 0.25)
      ),
      # C8
      curve(
        vector(-0.032, 0.564),
        vector(-0.056, 0.73),
        vector(-0.042, 0.834),
        vector(0.0, 1.0)
      ),
      # C9
      curve(
        vector(0.0, 1.0),
        vector(0.104, 0.938),
        vector(0.163, 0.893),
        vector(0.234, 0.798)
      ),
      # C10
      curve(
        vector(0.234, 0.798),
        vector(0.368, 0.65),
        vector(0.232, 0.54),
        vector(0.377, 0.377)
      ),
      # C11
      curve(
        vector(0.377, 0.377),
        vector(0.4, 0.35),
        vector(0.45, 0.3),
        vector(0.5, 0.25)
      ),
      # C12
      curve(
        vector(0.5, 0.25),
        vector(0.589, 0.217),
        vector(0.66, 0.208),
        vector(0.766, 0.202)
      ),
      # C13
      curve(
        vector(0.766, 0.202),
        vector(0.837, 0.107),
        vector(0.896, 0.062),
        vector(1.0, 0.0)
      ),
      # C14
      curve(
        vector(0.234, 0.798),
        vector(0.34, 0.792),
        vector(0.411, 0.783),
        vector(0.5, 0.75)
      ),
      # C15
      curve(
        vector(0.5, 0.75),
        vector(0.5, 0.625),
        vector(0.5, 0.575),
        vector(0.5, 0.5)
      ),
      # C16
      curve(
        vector(0.5, 0.5),
        vector(0.46, 0.46),
        vector(0.41, 0.41),
        vector(0.377, 0.377)
      ),
      # C17
      curve(
        vector(0.315, 0.71),
        vector(0.378, 0.732),
        vector(0.426, 0.726),
        vector(0.487, 0.692)
      ),
      # C18
      curve(
        vector(0.34, 0.605),
        vector(0.4, 0.642),
        vector(0.435, 0.647),
        vector(0.489, 0.626)
      ),
      # C19
      curve(
        vector(0.348, 0.502),
        vector(0.4, 0.564),
        vector(0.422, 0.568),
        vector(0.489, 0.563)
      ),
      # C20
      curve(
        vector(0.451, 0.418),
        vector(0.465, 0.4),
        vector(0.48, 0.385),
        vector(0.49, 0.381)
      ),
      # C21
      curve(
        vector(0.421, 0.388),
        vector(0.44, 0.35),
        vector(0.455, 0.335),
        vector(0.492, 0.325)
      ),
      # C22
      curve(
        vector(-0.17, 0.237),
        vector(-0.125, 0.355),
        vector(-0.065, 0.405),
        vector(0.002, 0.436)
      ),
      # C23
      curve(
        vector(-0.121, 0.188),
        vector(-0.06, 0.3),
        vector(-0.03, 0.33),
        vector(0.04, 0.375)
      ),
      # C24
      curve(
        vector(-0.058, 0.125),
        vector(-0.01, 0.24),
        vector(0.03, 0.28),
        vector(0.1, 0.321)
      ),
      # C25
      curve(
        vector(-0.022, 0.063),
        vector(0.06, 0.2),
        vector(0.1, 0.24),
        vector(0.16, 0.282)
      ),
      # C26
      curve(
        vector(0.053, 0.658),
        vector(0.075, 0.677),
        vector(0.085, 0.687),
        vector(0.098, 0.7)
      ),
      # C27
      curve(
        vector(0.053, 0.658),
        vector(0.042, 0.71),
        vector(0.042, 0.76),
        vector(0.053, 0.819)
      ),
      # C28
      curve(
        vector(0.053, 0.819),
        vector(0.085, 0.812),
        vector(0.092, 0.752),
        vector(0.098, 0.7)
      ),
      # C29
      curve(
        vector(0.13, 0.718),
        vector(0.15, 0.73),
        vector(0.175, 0.745),
        vector(0.187, 0.752)
      ),
      # C30
      curve(
        vector(0.13, 0.718),
        vector(0.11, 0.795),
        vector(0.11, 0.81),
        vector(0.112, 0.845)
      ),
      # C31
      curve(
        vector(0.112, 0.845),
        vector(0.15, 0.805),
        vector(0.172, 0.78),
        vector(0.187, 0.752)
      )
    ]
  end
end
