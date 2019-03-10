defmodule Vector do
  @moduledoc """
  Describes a two dimensional vector that connects the origin to (x, y)
  """

  defstruct x: 0, y: 0

  @doc """
  Builds a vector.

  ## Examples

      iex> Vector.build(0, 1)
      %Vector{x: 0, y: 1}
  """
  def build(x, y) do
    %Vector{x: x, y: y}
  end

  @doc """
  Adds two vectors.

  ## Examples

      iex> Vector.add(Vector.build(1, 1), Vector.build(3, 4))
      %Vector{x: 4, y: 5}

  """
  def add(%{x: x1, y: y1}, %{x: x2, y: y2}) do
    build(x1 + x2, y1 + y2)
  end

  @doc """
  Negates a vector.

  ## Examples

      iex> Vector.neg(Vector.build(1, 1))
      %Vector{x: -1, y: -1}

  """
  def neg(%{x: x, y: y}) do
    build(-x, -y)
  end

  @doc """
  Subtracts two vectors.

  ## Examples

      iex> Vector.sub(Vector.build(1, 1), Vector.build(3, 4))
      %Vector{x: -2, y: -3}

  """
  def sub(v1, v2) do
    add(v1, neg(v2))
  end

  @doc """
  Scales a vector.

  ## Examples

      iex> Vector.scale(1.5, Vector.build(2, 3))
      %Vector{x: 3.0, y: 4.5}

  """
  def scale(ratio, %{x: x, y: y}) do
    build(ratio * x, ratio * y)
  end

  @doc """
  Computes the length of a vector.

  ## Examples

      iex> Vector.length(Vector.build(3, 4))
      5.0

  """
  def length(%{x: x, y: y}) do
    :math.sqrt(x * x + y * y)
  end
end
