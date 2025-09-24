defmodule CardSim.Deck do
  @moduledoc """
  Manipulate pre-made decks of cards.
  """

  alias CardSim.Card

  @typedoc """
  List of Cards that represents a deck.
  """
  @type t() :: list(Card.t())

  #
  #
  @doc """
  Shuffles deck of cards.
  """
  @spec shuffle({non_neg_integer(), t()}) :: {non_neg_integer(), t()}
  def shuffle({length, deck}), do: {length, Enum.shuffle(deck)}

  #
  #
  @doc """
  Halves the deck in two.
  """
  @spec half_deck({non_neg_integer(), t()}) :: {t(), t()}
  def half_deck({length, deck}) do
    Enum.split(deck, div(length, 2))
  end
end
