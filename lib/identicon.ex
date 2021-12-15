defmodule Identicon do
  @moduledoc """
    Generate an avatar which represents a hash of unique information.
  """
  @doc """
    Generate an Identicon PNG image from string.
  ## Parameters
      input: The input string.
  """
  def generate_image(input) do
    input
    |> hash_input
    |> pick_color
    |> build_grid
    |> filter_squares
    |> build_pixelMap
    |> draw_image
    |> save_image(input)
  end

  @doc """
    Saves the image as PNG.
  ## Parameters
      image: The binary Image.
      input: the input string
  """
  def save_image(image, input) do
    File.write("#{input}.png", image)
  end

  @doc """
    Draws the Identicon.Image as binary image http://erlang.org/documentation/doc-6.1/lib/percept-0.8.9/doc/html/egd.html
  ## Parameters
      image: The Identicon.Image struct.
  """
  def draw_image(%Identicon.Image{color: color, pixelMap: pixelMap} = image) do
    image = :egd.create(250, 250)
    fill = :egd.color(color)

    Enum.each(pixelMap, fn {start, stop} ->
      :egd.filledRectangle(image, start, stop, fill)
    end)

    :egd.render(image)
  end

  @doc """
    Generates the pixel map from the Image grid
  ## Parameters
      image: The Identicon.Image struct
  """
  def build_pixelMap(%Identicon.Image{grid: grid} = image) do
    pixelMap =
      Enum.map(grid, fn {_, index} ->
        h = rem(index, 5) * 50
        v = div(index, 5) * 50

        top_l = {h, v}
        bottom_r = {h + 50, v + 50}

        {top_l, bottom_r}
      end)

    %Identicon.Image{image | pixelMap: pixelMap}
  end

  def filter_squares(%Identicon.Image{grid: grid} = image) do
    grid = Enum.filter(grid, fn {code, _} -> rem(code, 2) == 0 end)

    %Identicon.Image{image | grid: grid}
  end

  @doc """
    Builds the Identicon grid
  ## Parameters
      image: The Identicon.Image struct
  """
  def build_grid(%Identicon.Image{hex: hex} = image) do
    grid =
      hex
      |> Enum.reverse()
      |> tl()
      |> Enum.reverse()
      |> Enum.chunk_every(3)
      |> Enum.map(&mirror_row/1)
      |> List.flatten()
      |> Enum.with_index()

    %Identicon.Image{image | grid: grid}
  end

  @doc """
    Mirrors an enumerable with 3 elements
  ## Parameters
      row: An enumerable
  ## Examples
        iex> Identicon.mirror_row([1,2,3])
        [1,2,3,2,1]
  """
  def mirror_row(row) do
    [f, s | _] = row
    row ++ [s, f]
  end

  @doc """
    Picks the first three elements as the RGB color for the identicon
  ## Parameters
      image: The Identicon.Image struct
  """
  def pick_color(%Identicon.Image{hex: [r, g, b | _]} = image) do
    %Identicon.Image{image | color: {r, g, b}}
  end

  @doc """
    Hashes the input and converts it into a list of bytes().
  ## Parameters
      input: The input string
  """
  def hash_input(input) do
    hex =
      :crypto.hash(:md5, input)
      |> :binary.bin_to_list()

    %Identicon.Image{hex: hex}
  end
end
