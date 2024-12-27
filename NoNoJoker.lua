SMODS.Atlas {
  key = "NoNoJoker",
  path = "NoNoJoker.png",
  px = 71,
  py = 95
}

local function contains(table_, value)
  for _, v in pairs(table_) do
      if v == value then
          return true
      end
  end
  return false
end

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
  rarity = 3,
  cost = 11,
  unlocked = true,
  discovered = true,
  atlas = 'NoNoJoker',
  pos = {x = 0, y = 0},
  loc_vars = function(self, info_queue, card)
    return { vars = { card.ability.extra.mults, card.ability.extra.mult_gain } } 
  end,
  calculate = function(self, card, context)    
    if context.joker_main then
      return {
        mult = card.ability.extra.mults,
        message = localize { type = 'variable', key = 'a_mult', vars = { card.ability.extra.mults } },
        colour = G.C.MULT -- Mult colour
      }
    end
    if context.before and not context.blueprint then 
      card.ability.extra.tower = {} -- played poker cards
      if context.scoring_name == 'Pair' then   
        card.ability.extra.mults = card.ability.extra.mults + card.ability.extra.mult_gain -- add +Mult to current Mults
        for i=1, #context.scoring_hand do -- loop through scoring hand
          if not context.scoring_hand[i].debuff then -- only add non-debuff cards
            card.ability.extra.tower[#card.ability.extra.tower + 1] = context.scoring_hand[i] -- add card to tower
          end
        end
        return {
          message = 'Upgrade!',
          colour = G.C.MULT, 
          card = card
        }
      end
    elseif context.destroying_card and not context.blueprint then
      return contains(card.ability.extra.tower, context.destroying_card) -- Both tower (cards) is destroyed
    elseif context.after and not context.blueprint then
      card.ability.extra.tower = nil
    end
  end
} 