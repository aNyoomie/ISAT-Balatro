-- Misère
SMODS.Joker{
  key = 'misere',
  loc_txt = {
    name = 'Misère',
	  text = {
      'Gains {X:mult,C:white}X#2#{} Mult',
      'per {V:1}#3#{} card',
      'scored this round',
      '{C:inactive}(Currently {X:mult,C:white}X#1#{C:inactive})'
    },
  },
  rarity = 2,
  cost = 5,
  unlocked = true,
  discovered = false,
  blueprint_compat = true,
  perishable_compat = false, 
  eternal_compat = true,
  atlas = 'Jokers',
  pos = {x = 0, y = 4},
  config = {xmult = 1, extra = {s_xmult = 0.2, suit = 'Hearts',pos_override={x = 0, y = 4}}},
  loc_vars = function(self,info_queue,card)
    return {vars = {card.ability.xmult,card.ability.extra.s_xmult,localize(card.ability.extra.suit, 'suits_singular'),
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
    if context.joker_main and card.ability.xmult > 1 then
      return { 
        colour = G.C.RED,
        xmult = card.ability.xmult,
      }
    elseif context.individual and context.cardarea == G.play then
      if context.other_card and context.other_card:is_suit(card.ability.extra.suit) and not context.blueprint then
        card.ability.xmult = card.ability.xmult + card.ability.extra.s_xmult         
        return {
            extra = {focus = card, message = localize('k_upgrade_ex'),colour = G.C.MULT},
            card = card,
        }
      end
    elseif not context.repetition and not context.individual
    and context.end_of_round and not context.blueprint and card.ability.xmult > 0 then
      card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('k_reset')})
      card.ability.xmult = 1
    end
  end
}

-- Tourment
SMODS.Joker{
  key = 'tourment',
  loc_txt = {
    name = 'Tourment',
	  text = {
      '{C:attention}Stone{} and {C:attention}Mult{} cards',
      'count as {C:attention}Wild{} cards'
    },
  },
  rarity = 2,
  cost = 3,
  unlocked = true,
  discovered = false,
  blueprint_compat = true,
  perishable_compat = true, 
  eternal_compat = true,
  atlas = 'Jokers',
  pos = {x = 3, y = 4},
  config = {},
  loc_vars = function(self,info_queue,card)
		info_queue[#info_queue + 1] = G.P_CENTERS.m_wild
  end
}

-- Tears
SMODS.Joker{
  key = 'tears',
  loc_txt = {
    name = 'Tears',
	  text = {
      'When {C:attention}Blind{} is selected,',
      '{C:attention}Debuffs{} {C:green}#1# in #2#{} cards in deck',
      '{C:mult}+#3#{} Mult for every {C:attention}Debuffed{} card',
      '{C:inactive}(Currently {C:mult}+#4#{C:inactive} Mult)'
    },
  },
  rarity = 2,
  cost = 5,
  unlocked = true,
  discovered = false,
  blueprint_compat = true,
  perishable_compat = true, 
  eternal_compat = true,
  atlas = 'Jokers',
  pos = {x = 5, y = 3},
  config = {extra = {mult_bonus = 3, odds = 6, debuffed_cards = {}}},
  loc_vars = function(self,info_queue,card)
    local debuffed_cards = 0
    if G.deck then for k, v in pairs(G.playing_cards) do if v.debuff then debuffed_cards = debuffed_cards + 1 end end end
    return {vars = {G.GAME.probabilities.normal, card.ability.extra.odds, card.ability.extra.mult_bonus, debuffed_cards*card.ability.extra.mult_bonus}}
  end,
  calculate = function(self,card,context)
    if context.setting_blind then
      for i,c in ipairs(G.playing_cards) do
        if (pseudorandom('tears') < G.GAME.probabilities.normal/card.ability.extra.odds) then
          c:set_debuff(true)
          table.insert(card.ability.extra.debuffed_cards,c)
        end
      end
      card_eval_status_text(card, 'extra', nil, nil, nil, {colour = G.C.MONOBLUE, message = localize('k_debuffed')})
    elseif context.joker_main then
      local debuffed_cards = 0
      for k, v in pairs(G.playing_cards) do if v.debuff then debuffed_cards = debuffed_cards + 1 end end
      if debuffed_cards > 0 then
        return {
          message = localize{type = 'variable', key = 'a_mult', vars = {card.ability.extra.mult_bonus*debuffed_cards}}, 
          colour = G.C.MULT,
          mult_mod = card.ability.extra.mult_bonus*debuffed_cards
        }
      end
    elseif not context.repetition and not context.individual
    and context.end_of_round and not context.blueprint then
      card.ability.extra.debuffed_cards = {}
    elseif context.selling_self then
      local debuffed_cards = 0
      for k, v in pairs(G.playing_cards) do if v.debuff then debuffed_cards = debuffed_cards + 1 end end
      if debuffed_cards > 0 then card_eval_status_text(card, 'extra', nil, nil, nil, {message = "Undebuffed!"}) end
    end
  end
}

-- Désespoir
SMODS.Joker{
  key = 'desespoir',
  loc_txt = {
    name = 'Désespoir',
	  text = {
      'Played cards have a recounting{C:attention}*',
      '{C:chips}X{C:green} in #1#{} chance to give {C:money}$#2#{},',
      '{C:chips}X{}: Chips scored by card',
      '{C:attention}*{C:inactive}rolls again with excess Chips'
    },
  },
  rarity = 2,
  cost = 5,
  unlocked = true,
  discovered = false,
  blueprint_compat = true,
  perishable_compat = true, 
  eternal_compat = true,
  atlas = 'Jokers',
  pos = {x = 4, y = 4},
  config = {extra = {odds = 10, money = 1}},
  loc_vars = function(self,info_queue,card)
    return {vars = {card.ability.extra.odds, card.ability.extra.money}}
  end,
  calculate = function(self,card,context)
    if context.individual and context.cardarea == G.play and not context.end_of_round then
      local _card = context.other_card
      local total_chips = (_card.ability.bonus) + (_card.ability.perma_bonus or 0)
      if _card.ability.effect ~= 'Stone Card' and not _card.config.center.replace_base_card then
        total_chips = total_chips + (_card.base.nominal)
      end
      if _card.edition then
        total_chips = total_chips + (_card.edition.chips or 0)
      end
      local money = 0
      while total_chips >= card.ability.extra.odds do
        money = money+1
        total_chips = total_chips - card.ability.extra.odds
      end
      if (pseudorandom('desespoir') < total_chips/card.ability.extra.odds) then money = money+1 end
      if money > 0 then
        return {
          dollars = card.ability.extra.money*money,
          card = card
        }
      end
    end
  end
}

-- Bourdon
SMODS.Joker{
  key = 'bourdon',
  loc_txt = {
    name = 'Bourdon',
	  text = {
      '{C:chips}+#1#{} Chips if played',
      'hand contains cards',
      'of {C:attention}3{} different suits',
    },
  },
  rarity = 2,
  cost = 5,
  unlocked = true,
  discovered = false,
  blueprint_compat = true,
  perishable_compat = true, 
  eternal_compat = true,
  atlas = 'Jokers',
  pos = {x = 6, y = 4},
  config = {extra = {chips = 200}},
  loc_vars = function(self,info_queue,card)
    return {vars = {card.ability.extra.chips}}
  end,
  calculate = function(self,card,context)
    if context.joker_main then
      local suits = {
        ['Hearts'] = 0,
        ['Diamonds'] = 0,
        ['Spades'] = 0,
        ['Clubs'] = 0
      }
      for i = 1, #context.scoring_hand do
        if context.scoring_hand[i].ability.name ~= 'Wild Card' then
          if context.scoring_hand[i]:is_suit('Hearts', true) and suits["Hearts"] == 0 then suits["Hearts"] = suits["Hearts"] + 1
          elseif context.scoring_hand[i]:is_suit('Diamonds', true) and suits["Diamonds"] == 0  then suits["Diamonds"] = suits["Diamonds"] + 1
          elseif context.scoring_hand[i]:is_suit('Spades', true) and suits["Spades"] == 0  then suits["Spades"] = suits["Spades"] + 1
          elseif context.scoring_hand[i]:is_suit('Clubs', true) and suits["Clubs"] == 0  then suits["Clubs"] = suits["Clubs"] + 1 end
        end
      end
      for i = 1, #context.scoring_hand do
        if context.scoring_hand[i].ability.name == 'Wild Card' then
          if context.scoring_hand[i]:is_suit('Hearts') and suits["Hearts"] == 0 then suits["Hearts"] = suits["Hearts"] + 1
          elseif context.scoring_hand[i]:is_suit('Diamonds') and suits["Diamonds"] == 0  then suits["Diamonds"] = suits["Diamonds"] + 1
          elseif context.scoring_hand[i]:is_suit('Spades') and suits["Spades"] == 0  then suits["Spades"] = suits["Spades"] + 1
          elseif context.scoring_hand[i]:is_suit('Clubs') and suits["Clubs"] == 0  then suits["Clubs"] = suits["Clubs"] + 1 end
        end
      end
      if (suits["Hearts"] + suits["Diamonds"] + suits["Spades"] + suits["Clubs"]) >= 3 then
        return {
          chips = card.ability.extra.chips,
        }
      end
    end
  end
}