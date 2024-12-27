SMODS.Atlas {
  key = "NoNoJoker",
  path = "NoNoJoker.png",
  px = 71,
  py = 95
}

SMODS.Joker {
  key = 'pair-tower',
  loc_txt = 
  {
    name = "Pair Tower",
    text = 
    {
      -- Gain +9 Mult if the played hand is a Pair, then destroy the Pair cards.
      "Gains {C:mult}+#2#{} Mult",
      "if played hand is",
      "a {C:attention}Pair{}, destroy",
      "played hand",
      "{C:inactive}(Currently {C:mult}+#1#{C:inactive} Mult)"
    }
  },
  config = {extra = { mults = 0, mult_gain = 9 } },
  rarity = 3, -- ! should change later
  cost = 11,
  unlocked = true,
  discovered = true,
  atlas = 'NoNoJoker',
  pos = {x = 0, y = 0},
  loc_vars = function(self, info_queue, card)
    return { vars = { card.ability.extra.mults, card.ability.extra.mult_gain } } 
  end,
  calculate = function(self, card, context)
    local destroyed_cards = {}
    
    if context.joker_main then
      return {
        mult_mod = card.ability.extra.mults,
        message = localize { type = 'variable', key = 'a_mult', vars = { card.ability.extra.mults } }
      }
    end

    -- if context.before and next(context.poker_hands['Pair']) and not context.blueprint then
    if context.before and context.scoring_name == 'Pair' and not context.blueprint then
      card.ability.extra.mults = card.ability.extra.mults + card.ability.extra.mult_gain -- add +Mult to current Mults
      destroyed_cards[#destroyed_cards+1] = context.other_card

      return {
        message = 'Upgraded!',
        colour = G.C.MULT,
        card = card
      }
    end

    if context.destroying_card and not context.blueprint and not context.destroying_card.ability.eternal then
        return true
    end
  end
}

