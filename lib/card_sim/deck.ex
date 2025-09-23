defmodule CardSim.Deck do
  @moduledoc """
  Manipulate pre-made decks of cards.
  """

  #
  #
  @doc """
  Shuffles deck of cards.
  """
  @spec shuffle(list(tuple())) :: list(tuple())
  def shuffle(deck), do: Enum.shuffle(deck)

  #
  #
  @doc """
  Halves the deck in two.
  """
  @spec half_deck(non_neg_integer(), list(tuple())) :: {list(tuple()), list(tuple())}
  def half_deck(length, deck) do
    Enum.split(deck, div(length, 2))
  end
end
