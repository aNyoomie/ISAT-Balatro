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
  cost = 5,
  unlocked = false,
	unlock_condition = {type = 'win_custom'},
  discovered = false,
  blueprint_compat = false,
  perishable_compat = true, 
  eternal_compat = true,
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
            card = card
        }
      end
    end
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
  cost = 8,
  unlocked = false,
	unlock_condition = {type = 'win_custom'},
  discovered = false,
  blueprint_compat = false,
  perishable_compat = false, 
  eternal_compat = true,
  atlas = 'Jokers',
  pos = {x = 6, y = 1},
  add_to_deck = function(self, card, from_debuff)
    G.jokers.config.card_limit = G.jokers.config.card_limit + 2
  end,
  remove_from_deck = function(self, card, from_debuff)
    G.jokers.config.card_limit = G.jokers.config.card_limit - 2
  end
}

-- Mal du Pays
SMODS.Joker{
  key = 'mal',
  loc_txt = {
    name = 'Mal du Pays',
	  text = {
      "After {C:attention}#1#{} rounds,",
      "sell this card to add",
      "{C:dark_edition}Negative{} to a random Joker",
      "{C:inactive}(Currently {C:attention}#2#{C:inactive}/#1#)",
    },
    unlock = {
      "Loop with {C:snack}Siffrin{}",
      "in Ante level {C:attention}8{}"
    }
  },
  rarity = 3,
  cost = 7,
  unlocked = false,
  discovered = false,
  blueprint_compat = false,
  perishable_compat = false, 
  eternal_compat = false,
  atlas = 'Jokers',
  pos = {x = 5, y = 4},
  config = {extra = {rounds = 2, counter = 0}},
  loc_vars = function(self,info_queue,card)
    return {vars = {card.ability.extra.rounds, card.ability.extra.counter}}
  end,
  calculate = function(self,card,context)
    if ((not context.repetition and not context.individual and context.end_of_round) or context.skip_blind) and not context.blueprint then
      card.ability.extra.counter = card.ability.extra.counter + 1
      if card.ability.extra.counter == card.ability.extra.rounds then
        local eval = function(card) return not card.REMOVED end
        juice_card_until(card, eval, true)
      end
      card_eval_status_text(card, 'extra', nil, nil, nil, {colour = G.C.MONOBLUE, message = ""..card.ability.extra.counter.."/"..card.ability.extra.rounds})
    end
    if context.selling_self and card.ability.extra.counter >= card.ability.extra.rounds then
      G.E_MANAGER:add_event(Event({
        func = function()
          local jokelist = {}
          for i,v in pairs (G.jokers.cards) do
            if not v.edition and v ~= card then
              table.insert(jokelist,v)
            end
          end
          local _card = pseudorandom_element(jokelist,pseudoseed('maldupays'))
          if _card then _card:set_edition({negative=true},true) end
          return true
        end
      }))
    end
  end
}