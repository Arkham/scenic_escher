defmodule Shape do
  def george do
    pts1 = [
      %Vector{x: 0.00, y: 0.55},
      %Vector{x: 0.15, y: 0.45},
      %Vector{x: 0.30, y: 0.55},
      %Vector{x: 0.40, y: 0.50},
      %Vector{x: 0.20, y: 0.00}
    ]

    pts2 = [
      %Vector{x: 0.00, y: 0.80},
      %Vector{x: 0.15, y: 0.60},
      %Vector{x: 0.30, y: 0.65},
      %Vector{x: 0.40, y: 0.65},
      %Vector{x: 0.35, y: 0.80},
      %Vector{x: 0.40, y: 1.00}
    ]

    pts3 = [
      %Vector{x: 0.60, y: 1.00},
      %Vector{x: 0.65, y: 0.80},
      %Vector{x: 0.60, y: 0.65},
      %Vector{x: 0.80, y: 0.65},
      %Vector{x: 1.00, y: 0.45}
    ]

    pts4 = [
      %Vector{x: 1.00, y: 0.20},
      %Vector{x: 0.60, y: 0.50},
      %Vector{x: 0.80, y: 0.00}
    ]

    pts5 = [
      %Vector{x: 0.40, y: 0.00},
      %Vector{x: 0.50, y: 0.30},
      %Vector{x: 0.60, y: 0.00}
    ]

    [
      {:polyline, pts1},
      {:polyline, pts2},
      {:polyline, pts3},
      {:polyline, pts4},
      {:polyline, pts5}
    ]
  end
end
