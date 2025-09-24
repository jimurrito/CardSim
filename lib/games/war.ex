defmodule Games.War do
  @moduledoc """
  Logic to handle a 1v1 game of war.
  """
  
  require Logger
  alias CardSim.Card
  alias CardSim.Deck

  @typedoc """
  Deck list converted to a queue for quick append operations.
  """
  @type t() :: :queue.queue(Card.t())

  #
  #
  @doc """
  Makes a WAR Deck from a list of Cards.
  """
  @spec make_war_deck(Deck.t()) :: t()
  def make_war_deck(deck), do: :queue.from_list(deck)

  #
  #
  @doc """
  Draws a card from a WAR Deck
  """
  @spec draw(t()) :: :empty | {Card.t(), t()}
  def draw(war_deck) do
    :queue.out(war_deck)
    |> case do
      {:empty, _} ->
        :empty

      {{:value, value}, new_deck} ->
        {value, new_deck}
    end
  end

  #
  #
  @doc """
  Draws x amount of cards
  """
  @spec draw_many(t(), non_neg_integer()) :: {:ok | :empty, Deck.t()}
  def draw_many(war_deck, count), do: draw_many(war_deck, count, 0, [])

  defp draw_many(_deck, count, acc, state) when count <= acc, do: {:ok, state}

  defp draw_many(war_deck, count, acc, state) do
    case draw(war_deck) do
      :empty ->
        {:empty, state}

      {value, new_deck} ->
        draw_many(new_deck, count, acc + 1, [value | state])
    end
  end

  #
  #
  @doc """
  Puts a list of cards to the end of a WAR Deck.
  """
  @spec put_end(t(), Deck.t()) :: t()
  def put_end(war_deck, []), do: war_deck
  def put_end(war_deck, [c | rest]), do: put_end(:queue.in(c, war_deck), rest)

  #
  #
  @doc """
  Compares to Cards.

  - 1 => 1st arity card is higher
  - 2 => 2nd arity card is higher
  - 3 => War is declared

  """
  @spec compare_cards(Card.t(), Card.t()) :: non_neg_integer()
  def compare_cards({_, v1}, {_, v2}) when v1 > v2, do: 1
  def compare_cards({_, v1}, {_, v2}) when v1 < v2, do: 2
  def compare_cards({_, v1}, {_, v2}) when v1 == v2, do: 3

  #
  #
  @doc """
  Plays a hand of WAR with two WAR Decks.
  """
  @spec play_hand({t(), t()}) :: {t(), t()} | {:win, :player1 | :player2 | :draw}
  def play_hand({d1, d2}) do
    {:queue.is_empty(d1), :queue.is_empty(d2)}
    |> case do
      # Both empty decks
      {true, true} ->
        Logger.info(winner: :draw)
        {:win, :draw}

      # 2nd player out of cards
      {_, true} ->
        Logger.info(winner: :player1)
        {:win, :player1}

      # 1st player is out of cards
      {true, _} ->
        Logger.info(winner: :player2)
        {:win, :player2}

      # both players have cards
      _ ->
        {{c1, d1}, {c2, d2}} = {draw(d1), draw(d2)}
        prize = [c1, c2]

        compare_cards(c1, c2)
        |> case do
          # Player one won battle
          1 ->
            Logger.info(result: :player1, player1: c1, player2: c2)
            d1 = put_end(d1, Enum.shuffle(prize))
            {d1, d2}

          # Player one won battle
          2 ->
            Logger.info(result: :player2, player1: c1, player2: c2)
            d2 = put_end(d2, Enum.shuffle(prize))
            {d1, d2}

          # WAR Declared
          3 ->
            Logger.info(result: :war, player1: c1, player2: c2)
            war(d1, d2, prize, 1)
        end
    end
  end

  #
  #
  @doc """
  Logic for WAR Phase of the game.
  """
  @spec war(t(), t(), Deck.t(), non_neg_integer()) ::
          {t(), t()} | {:win, :player1 | :player2 | :draw}
  def war(d1, d2, prize, acc) do
    {draw_many(d1, 4), draw_many(d2, 4)}
    |> case do
      #
      # Empty checks
      {{:empty, _}, {:empty, _}} ->
        Logger.info(war_winner: :draw)
        {:win, :draw}

      {_, {:empty, _}} ->
        Logger.info(war_winner: :player1)
        {:win, :player1}

      {{:empty, _}, _} ->
        Logger.info(war_winner: :player2)
        {:win, :player2}

      #
      {{:ok, draw1}, {:ok, draw2}} ->
        [c1 | _p1] = draw1
        [c2 | _p2] = draw2
        # generate prize
        prize = draw1 ++ draw2 ++ prize
        # compare
        compare_cards(c1, c2)
        |> case do
          # player 1 wins
          1 ->
            Logger.info(war_result: :player1, player1: c1, player2: c2)
            {put_end(d1, Enum.shuffle(prize)), d2}

          # Player 2 wins
          2 ->
            Logger.info(war_result: :player2, player1: c1, player2: c2)
            {d1, put_end(d2, Enum.shuffle(prize))}

          # Nested WAR
          3 ->
            acc = acc + 1
            Logger.info(war_result: :nested_war, level: acc, player1: c1, player2: c2)
            war(d1, d1, prize, acc)
        end
    end
  end

  #
  #
end
