# CardSim

Playing card game simulation library for Elixir.

> **This library is in development. More playable games should available soon.**

```elixir
defp deps do
  [
    {:dep_from_git, git: "https://github.com/jimurrito/CardSim.git", tag: "0.1.0"}
  ]
end
```

## Quick Start

Cards are represented by a tuple of 2 integers.
A deck is represented by a list of these card tuples.
  
### `{card_suit, card_value}`
  
#### Card Suits

- Spades    => `0`
- Clubs     => `1`
- Diamonds  => `2`
- Hearts    => `3`

#### Card Values

- Values `2` - `10` are the card values themselves.
- Values `11` - `14` are Jack (11), Queen (12), King (13), and Ace (14) respectively.
- Jokers are `{8, 99}` (black), `{9, 99}` (red).

#### Card Examples

- `{0, 2}` => 2 of Spades
- `{1, 13}` => King of Clubs
- `{3, 10}` => 10 of Hearts
- `{8, 99}` => Black Joker


### Code Examples

```elixir

alias CardSim.Deck

# Ordered deck
deck = CardSim.generate_deck()

# Shuffled deck
deck = CardSim.generate_deck() |> Deck.shuffle()

# Split deck (for games like WAR)
deck = CardSim.generate_deck() |> Deck.shuffle() |> Deck.half_deck()

```


### Playable games

- War


### Game Examples

#### War

*Can be found in `scripts/simple_war_sim.exs`*

```elixir
#
# Simple War Simulation

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
```

##### **Output**

```elixir
[nanoseconds: 0, winner: :player1, hands: 282]
```

