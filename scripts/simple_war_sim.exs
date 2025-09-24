#
# Simulates a game of 1v1 WAR
#

#alias CardSim.Card
alias CardSim.Deck
alias Games.War

# generate 2 decks
{d1, d2} = CardSim.generate_deck() |> Deck.shuffle() |> Deck.half_deck()

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

  
{time, {winner, hands}} = :timer.tc(fn -> loop.({d1, d2}, 1, loop) end)

IO.inspect(nanoseconds: div(time,1_000), winner: winner, hands: hands)
