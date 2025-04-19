-- Euphrasie
SMODS.Joker{
  key = 'housemaiden',
  loc_txt = {
    name = 'Euphrasie',
	  text = {
      'Earn {C:money}$#1#{} when',
      'ending a {C:attention}Boss Blind',
	    '{C:inactive}Head Housemaiden!'
    },
    unlock = {
      "Win a run"
    }
  },
  rarity = 2,
  cost = 6,
  unlocked = false,
	unlock_condition = {type = 'win_custom'},
  discovered = false,
  blueprint_compat = false,
  perishable_compat = true, 
  eternal_compat = true,
  order = 157,
  atlas = 'Jokers',
  pos = {x = 4, y = 1},
  config = {extra = 15},
  loc_vars = function(self,info_queue,card)
    return {vars = {card.ability.extra}}
  end,
  calc_dollar_bonus = function(self,card,context)
    if G.GAME.blind:get_type() == 'Boss' then return card.ability.extra end
  end,
}

-- Change God
SMODS.Joker{
  key = 'god',
  loc_txt = {
    name = 'Change God',
	  text = {
      '+2 {C:attention}Joker{} Slots',
	    '{E:1,C:inactive}(/^v^)/*:*, vidya gaems!!'
    },
    unlock = {
      '{E:1}win with both {E:1,C:snack}mirabelle{E:1}!!',
      '{E:1}(and {C:snack}siffrin{E:1})',
      '{E:1}together!!!! @^v^@'
    }
  },
  rarity = 3,
  cost = 7,
  unlocked = false,
	unlock_condition = {type = 'win_custom'},
  discovered = false,
  blueprint_compat = false,
  perishable_compat = false, 
  eternal_compat = true,
  order = 158,
  atlas = 'Jokers',
  pos = {x = 6, y = 1},
  add_to_deck = function(self, card, from_debuff)
    G.jokers.config.card_limit = G.jokers.config.card_limit + 2
  end,
  remove_from_deck = function(self, card, from_debuff)
    G.jokers.config.card_limit = G.jokers.config.card_limit - 2
  end
}

-- Tutorial Kid
SMODS.Joker{
  key = 'tutorial',
  loc_txt = {
    name = 'Tutorial Kid',
	  text = {
      'In a cycle, gives:',
      '{C:attention}#4#{X:mult,C:white}X#1#{V:1} Mult',
      '{C:attention}#5#{C:chips}+#2#{V:2} Chips',
      '{C:attention}#6#{C:mult}+#3#{V:3} Mult',
	    '{C:inactive}Rock, Paper, Scissors!'
    },
  },
  rarity = 1,
  cost = 4,
  unlocked = true,
  discovered = false,
  blueprint_compat = true,
  perishable_compat = true, 
  eternal_compat = true,
  order = 159,
  atlas = 'Jokers',
  pos = {x = 5, y = 1},
  config = {Xmult = 1.5, chips = 75, mult = 10,extra = 1},
  loc_vars = function(self,info_queue,card)
    return {vars = {card.ability.Xmult, card.ability.chips, card.ability.mult,
      (card.ability.extra == 1 and "> ") or "  ",(card.ability.extra == 2 and "> ") or "  ",(card.ability.extra == 3 and "> ") or "  ",
      colours = {(card.ability.extra == 1 and G.C.L_BLACK) or G.C.UI.TEXT_INACTIVE,(card.ability.extra == 2 and G.C.L_BLACK) or G.C.UI.TEXT_INACTIVE,(card.ability.extra == 3 and G.C.L_BLACK) or G.C.UI.TEXT_INACTIVE}}}
  end,
  calculate = function(self,card,context)
    if context.joker_main then
      return { 
        Xmult = (card.ability.extra == 1 and card.ability.Xmult)or 1,
        chips = (card.ability.extra == 2 and card.ability.chips)or 0,
        mult = (card.ability.extra == 3 and card.ability.mult)or 0,
      }
    elseif context.after and not context.blueprint then
      card.ability.extra = card.ability.extra+1
      if card.ability.extra > 3 then
        card.ability.extra = 1
      end
    end
  end,
}

-- King
SMODS.Joker{
  key = 'king',
  loc_txt = {
    name = 'King',
	  text = {
      'Cards held in hand are',
      'turned {C:attention}face down{} and',
      'each give {X:mult,C:white}X#1#{} Mult',
	    "{C:inactive}......Do you remember?"
    },
    unlock = {
      "Enter the Final",
      "{E:1,C:attention}Boss Blind"
    }
  },
  rarity = 3,
  cost = 6,
  unlocked = false,
	unlock_condition = {type = 'set_blind'},
  discovered = false,
  blueprint_compat = true,
  perishable_compat = true, 
  eternal_compat = true,
  order = 160,
  atlas = 'Jokers',
  pos = {x = 7, y = 1},
  config = {extra = {1.5}},
  loc_vars = function(self,info_queue,card)
    return {vars = {card.ability.extra[1]}}
  end,
  calculate = function(self,card,context)
    if context.cardarea == G.hand and context.individual and not context.end_of_round then
      if context.other_card.facing == 'front' then
        context.other_card:flip()
      end
      if context.other_card.debuff then
        return {
            message = localize('k_debuffed'),
            colour = G.C.RED,
            card = context.other_card,
        }
      else
        return {
            x_mult = card.ability.extra[1],
            card = context.other_card
        }
      end
    end
  end,
}