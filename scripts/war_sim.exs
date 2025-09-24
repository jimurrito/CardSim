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
  fn decks, self ->
    War.play_hand(decks)
    |> case do
      {:win, result} -> {:win, result}
      decks -> self.(decks, self)
    end
  end

loop.({d1, d2}, loop)
|> IO.inspect()