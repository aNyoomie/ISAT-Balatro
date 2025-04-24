-- Tristesse
SMODS.Joker{
  key = 'tristesse',
  loc_txt = {
    name = 'Tristesse',
	  text = {
      '{C:chips}+#2#{} Chips per {V:1}#3#{}',
      'card scored this round',
      '{C:inactive}(Currently {C:chips}+#1#{C:inactive})'
    },
  },
  rarity = 1,
  cost = 4,
  unlocked = true,
  discovered = false,
  blueprint_compat = true,
  perishable_compat = true, 
  eternal_compat = true,
  atlas = 'Jokers',
  pos = {x = 0, y = 2},
  config = {chips = 0, extra = {s_chips = 25, suit = 'Hearts',pos_override={x = 0, y = 2}}},
  loc_vars = function(self,info_queue,card)
    return {vars = {card.ability.chips,card.ability.extra.s_chips,localize(card.ability.extra.suit, 'suits_singular'),
    colours = {G.C.SUITS[card.ability.extra.suit]}}}
  end,
  set_ability = function(self, card, initial, delay_sprites)
    if card.config.center.discovered then
      local rand = pseudorandom("hand")
      local first = 1 / 3
      local second = 2 / 3
      if 0 < rand and rand < first then
        card.ability.extra.suit = 'Hearts'
      elseif first < rand and rand < second then
        card.ability.extra.suit = 'Clubs'
        card.ability.extra.pos_override.x = 1
      else
        card.ability.extra.suit = 'Diamonds'
        card.ability.extra.pos_override.x = 2
      end
      card.children.center:set_sprite_pos(card.ability.extra.pos_override)
    end
  end,
  load = function(self, card, card_table, other_card)
    G.E_MANAGER:add_event(Event({
      func = function()
        card.children.center:set_sprite_pos(card.ability.extra.pos_override)
        return true
      end
    }))
	end,
  calculate = function(self,card,context)
    if context.joker_main and card.ability.chips > 0 then
      return { 
        colour = G.C.RED,
        chips = card.ability.chips,
      }
    elseif context.individual and context.cardarea == G.play then
      if context.other_card and context.other_card:is_suit(card.ability.extra.suit) and not context.blueprint then
        card.ability.chips = card.ability.chips + card.ability.extra.s_chips         
        return {
            extra = {focus = card, message = localize('k_upgrade_ex'),colour = G.C.CHIPS},
            card = card,
        }
      end
    elseif not context.repetition and not context.individual
    and context.end_of_round and not context.blueprint and card.ability.chips > 0 then
      card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('k_reset')})
      card.ability.chips = 0
    end
  end
}

-- Chagrin, Dépit & Peine
SMODS.Joker{
  key = 'chagrin',
  loc_txt = {
    name = 'Chagrin, Dépit & Peine',
	  text = {
      '{C:chips}+#1#{} Chips',
      '{C:mult}+#2#{} Mult',
      '{X:mult,C:white}X#3#{} Mult'
    },
  },
  rarity = 1,
  cost = 5,
  unlocked = true,
  discovered = false,
  blueprint_compat = true,
  perishable_compat = true, 
  eternal_compat = true,
  atlas = 'Jokers',
  pos = {x = 3, y = 2},
  config = {chips = 20, mult = 2, Xmult = 1.2},
  loc_vars = function(self,info_queue,card)
    return {vars = {card.ability.chips,card.ability.mult,card.ability.Xmult}}
  end,
  calculate = function(self,card,context)
    if context.joker_main and card.ability.mult > 0 then
      return { 
        chips = card.ability.chips,
        mult = card.ability.mult,
				Xmult = card.ability.Xmult
      }
    end
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

-- Amertume & Rancoeur
SMODS.Joker{
  key = 'amertume',
  loc_txt = {
    name = 'Amertume & Rancoeur',
	  text = {
      '{C:chips}+#2#{} Chips',
      '{C:snack}-#1#{} Mult',
    },
  },
  rarity = 1,
  cost = 5,
  unlocked = true,
  discovered = false,
  blueprint_compat = true,
  perishable_compat = true, 
  eternal_compat = true,
  atlas = 'Jokers',
  pos = {x = 4, y = 2},
  config = {submult = 4, chips = 150},
  loc_vars = function(self,info_queue,card)
    return {vars = {card.ability.submult,card.ability.chips}}
  end,
  calculate = function(self,card,context)
    if context.joker_main then
      return { 
        submult = card.ability.submult,
				chips = card.ability.chips
      }
    end
  end
}

-- Calamité
SMODS.Joker{
  key = 'calamite',
  loc_txt = {
    name = 'Calamité',
	  text = {
      '{X:mult,C:white}X#1#{} Mult if played',
      'hand has a scoring',
      '{V:1}#2#{} card',
      '{s:0.8}suit changes every round'
    },
  },
  rarity = 2,
  cost = 6,
  unlocked = true,
  discovered = false,
  blueprint_compat = true,
  perishable_compat = true, 
  eternal_compat = true,
  atlas = 'Jokers',
  pos = {x = 6, y = 2},
  config = {extra = {Xmult = 2}},
  loc_vars = function(self,info_queue,card)
    return {vars = {card.ability.extra.Xmult, localize(G.GAME.current_round.calamite_card.suit, 'suits_singular'), colours = {G.C.SUITS[G.GAME.current_round.calamite_card.suit]}}}
  end,
  calculate = function(self,card,context)
    if context.individual and context.cardarea == G.play then
      card.ability.extra.found = nil
      if context.other_card:is_suit(G.GAME.current_round.calamite_card.suit) then
        card.ability.extra.found = true
      end
    elseif context.joker_main and card.ability.extra.found then
      return { 
        colour = G.C.RED,
        Xmult = card.ability.extra.Xmult
      }
    end
  end
}