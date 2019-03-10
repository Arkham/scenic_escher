defmodule Figure do
  def triangle do
    [
      {:polygon,
       [
         Vector.build(0.00, 0.00),
         Vector.build(1.00, 0.00),
         Vector.build(0.00, 1.00)
       ]}
    ]
  end

  def square do
    [
      {:polygon,
       [
         Vector.build(0.00, 0.00),
         Vector.build(1.00, 0.00),
         Vector.build(1.00, 1.00),
         Vector.build(0.00, 1.00)
       ]}
    ]
  end

  def george do
    pts1 = [
      Vector.build(0.00, 0.55),
      Vector.build(0.15, 0.45),
      Vector.build(0.30, 0.55),
      Vector.build(0.40, 0.50),
      Vector.build(0.20, 0.00)
    ]

    pts2 = [
      Vector.build(0.00, 0.80),
      Vector.build(0.15, 0.60),
      Vector.build(0.30, 0.65),
      Vector.build(0.40, 0.65),
      Vector.build(0.35, 0.80),
      Vector.build(0.40, 1.00)
    ]

    pts3 = [
      Vector.build(0.60, 1.00),
      Vector.build(0.65, 0.80),
      Vector.build(0.60, 0.65),
      Vector.build(0.80, 0.65),
      Vector.build(1.00, 0.45)
    ]

    pts4 = [
      Vector.build(1.00, 0.20),
      Vector.build(0.60, 0.50),
      Vector.build(0.80, 0.00)
    ]

    pts5 = [
      Vector.build(0.40, 0.00),
      Vector.build(0.50, 0.30),
      Vector.build(0.60, 0.00)
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
