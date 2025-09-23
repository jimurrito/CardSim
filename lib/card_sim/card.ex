defmodule CardSim.Card do
  @moduledoc """
  Individual Card logic
  """

  #
  #
  @doc """
  Makes produces cards using an accumulator.
  """
  # entry point (w/ Jokers)
  def produce_cards(no_decks, jokers: jokers) when no_decks >= 1 do
    # Starts with a 1
    produce(no_decks, 1, 0, 2, jokers, [])
  end

  #
  # entry point (w/o Jokers)
  def produce_cards(no_decks) when no_decks >= 1 do
    produce(no_decks, 1, 0, 2, false, [])
  end

  # deck_count => Deck number being built 1 -> X
  # type_acc   => Card Type. 0 - 3
  #               - Spades    => 0
  #               - Clubs     => 1
  #               - Diamonds  => 2
  #               - Hearts    => 3
  # card_acc    => Number card we are working on. 2-14 (2-Ace)
  #
  # NOTE: Jokers are {8, 99} (black), {9, 99} (red)
  #
  # Card output examples:
  #
  #   {0, 2}  => {type_acc, card_acc}
  #
  # - {0, 2}  => 2 of Spades
  # - {1, 13} => King of Clubs
  #

  # exit -> Deck count > no_decks
  defp produce(no_decks, deck_count, _type_acc, _card_acc, _jokers, state)
       when no_decks < deck_count do
    state
  end

  # add jokers at end of deck -> deck reset
  defp produce(no_decks, deck_count, 3, 15, true, state) do
    produce(no_decks, deck_count + 1, 0, 2, true, [{9, 99} | [{8, 99} | state]])
  end

  # end of deck, no jokers -> deck reset
  defp produce(no_decks, deck_count, 3, 15, false, state) do
    produce(no_decks, deck_count + 1, 0, 2, false, state)
  end

  # Change type -> increment type
  defp produce(no_decks, deck_count, type_acc, 15, jokers, state) do
    produce(no_decks, deck_count, type_acc + 1, 2, jokers, state)
  end

  # worker
  defp produce(no_decks, deck_count, type_acc, card_acc, jokers, state) do
    produce(no_decks, deck_count, type_acc, card_acc + 1, jokers, [{type_acc, card_acc} | state])
  end
end
