defmodule CardSim do
  @moduledoc """
  Documentation for `CardSim`.
  """

  alias CardSim.Card

  #
  #
  @doc """
  Generate a deck of Cards. If non-zero integer is provided, that many decks will be generated.
    Returns: {num_of_cards, deck}
  """
  @spec generate_deck(non_neg_integer(), keyword()) :: {non_neg_integer(), list(tuple())}
  def generate_deck(num, jokers: jokers) when num >= 1 do
    deck_size = if jokers, do: 52, else: 50
    {num * deck_size, Card.produce_cards(num, jokers: jokers)}
  end

  @spec generate_deck(non_neg_integer()) :: {non_neg_integer(), list(tuple())}
  def generate_deck(num) when num >= 1 do
    {num * 50, Card.produce_cards(num)}
  end

  @spec generate_deck() :: {non_neg_integer(), list(tuple())}
  def generate_deck() do
    {50, Card.produce_cards(1)}
  end
end
