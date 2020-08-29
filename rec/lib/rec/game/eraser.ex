defmodule Rec.Game.Eraser do
  defstruct ~w[text plan]a

  # Constructor
  def new(text, steps) do
    %__MODULE__{text: text, plan: build_plan(text, steps)}
  end

  # Transformer
  def perform(%{text: text, plan: [step | rest]}) do
    %__MODULE__{plan: rest, text: process_step(text, step)}
  end

  # Reducers
  defp chunk_size(text, steps) do
    text |> String.length |> Kernel./(steps) |> ceil
  end

  defp build_plan(text, steps) do
    chunk_size = chunk_size(text, steps)
    1..String.length(text) |> Enum.shuffle |> Enum.chunk_every(chunk_size)
  end

  defp process_step(text, step) do
    text
    |> String.graphemes
    |> Enum.with_index(1)
    |> Enum.map(fn {g, i} -> replace_grapheme(g, i in step) end)
    |> Enum.join()
  end

  defp replace_grapheme(" ", true), do: " "
  defp replace_grapheme(_, true), do: "_"
  defp replace_grapheme(grapheme, false), do: grapheme
end
