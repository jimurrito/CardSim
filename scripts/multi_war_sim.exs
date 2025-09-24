#
# Simulates a game of 1v1 WAR
#

#alias CardSim.Card
alias CardSim.Deck
alias Games.War

defmodule Funcs do
  #
  #
  def get_arg(args, flag, default) do
    index = Enum.find_index(args, &(&1==flag))
    if index == nil, do: default, else: Enum.at(args, index + 1, default)
  end
  #
  #
  def iterate(iters, _, iter_acc, state) when iters < iter_acc, do: state
  def iterate(iters, decks, iter_acc, state) do
    # generate 2 decks
    {d1, d2} = CardSim.generate_deck(decks) |> Deck.shuffle() |> Deck.half_deck()

    d1 = War.make_war_deck(d1)
    d2 = War.make_war_deck(d2)

    loop =
      fn decks, acc, self ->
        War.play_hand(decks)
        |> case do
          {:win, result} -> {result, acc}
          decks -> self.(decks, acc + 1, self)
        end
      end

    result = :timer.tc(fn -> loop.({d1, d2}, 1, loop) end)
    IO.inspect(game_num: iter_acc, result: result)
    iterate(iters, decks, iter_acc + 1, [result | state])
  end
  #
  #
  def aggregate(results), do: aggregate(results, {0, 0, {0, 0, 0}, {0, 0}, 0})
  def aggregate([], state), do: state
  def aggregate([{time, {winner, hands}} | results], {time_c, hands_c, {p1,p2,d}, {l,h}, acc}) do

    winners =
      winner
      |> case do
        :player1 -> {p1+1,p2,d}
        :player2 -> {p1,p2+1,d}
        :draw -> {p1,p2,d+1}
      end

    low = if hands < l or l == 0, do: hands, else: l
    high = if hands > h or h == 0, do: hands, else: h
    state = {time_c + time, hands_c + hands, winners, {low, high}, acc + 1}
    
    aggregate(results, state)
  end
  #
  #
  def stats({time, hands, {p1, p2, d}, {low, high}, acc}) do
    total_ns = (time / 1_000)
    avg_game_ns = total_ns / acc
    avg_hands = (hands / acc)
    IO.inspect(
      games: acc,
      total_ns: total_ns,
      wins: [player1: p1, player2: p2, draws: d],
      avg_game_ns: avg_game_ns,
      avg_hands: avg_hands,
      least_hands: low,
      most_hands: high
    )
  end
  #
end


args = System.argv()

iters = Funcs.get_arg(args, "-i", "1") |> String.to_integer()
decks = Funcs.get_arg(args, "-d", "1") |> String.to_integer()

Funcs.iterate(iters, decks, 0, [])
|> Funcs.aggregate()
|> Funcs.stats()

