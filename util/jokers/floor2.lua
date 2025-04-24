-- Détresse
SMODS.Joker{
  key = 'detresse',
  loc_txt = {
    name = 'Détresse',
	  text = {
      '{C:mult}+#2#{} Mult per {V:1}#3#{}',
      'card scored this round',
      '{C:inactive}(Currently {C:mult}+#1#{C:inactive})'
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
  pos = {x = 0, y = 3},
  config = {mult = 0, extra = {s_mult = 3, suit = 'Hearts',pos_override={x = 0, y = 3}}},
  loc_vars = function(self,info_queue,card)
    return {vars = {card.ability.mult,card.ability.extra.s_mult,localize(card.ability.extra.suit, 'suits_singular'),
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
    if context.joker_main and card.ability.mult > 0 then
      return { 
        colour = G.C.RED,
        mult = card.ability.mult,
      }
    elseif context.individual and context.cardarea == G.play then
      if context.other_card and context.other_card:is_suit(card.ability.extra.suit) and not context.blueprint then
        card.ability.mult = card.ability.mult + card.ability.extra.s_mult         
        return {
            extra = {focus = card, message = localize('k_upgrade_ex'),colour = G.C.MULT},
            card = card,
        }
      end
    elseif not context.repetition and not context.individual and not card.ability.extra.jason
    and context.end_of_round and not context.blueprint and card.ability.mult > 0 then
      card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('k_reset')})
      card.ability.mult = 0
    end
  end
}

-- Angoisse & Deuil
SMODS.Joker{
  key = 'angoisse',
  loc_txt = {
    name = 'Angoisse & Deuil',
	  text = {
      'When a {C:attention}Glass Card{}',
      'is destroyed in play,',
      'an {C:attention}Enhancementless{}',
      'copy is added to deck'
    },
  },
  rarity = 1,
  cost = 4,
  unlocked = true,
  discovered = false,
  blueprint_compat = false,
  perishable_compat = true, 
  eternal_compat = true,
  atlas = 'Jokers',
  pos = {x = 3, y = 3},
  config = {extra = {cards = {}}},
  calculate = function(self,card,context)
    if context.remove_playing_cards and not context.blueprint then
      for k, val in ipairs(context.removed) do
        if val.shattered then
          local _card = copy_card(val, nil, nil, G.playing_card)
          _card:set_ability(G.P_CENTERS.c_base)
          _card:add_to_deck()
          _card.states.visible = nil
          table.insert(card.ability.extra.cards,_card)
        end
      end
    elseif context.after and not context.blueprint then
      if #card.ability.extra.cards > 0 then
        for i,c in ipairs(card.ability.extra.cards) do
          G.E_MANAGER:add_event(Event({
            func = function()
              G.deck.config.card_limit = G.deck.config.card_limit + 1
              table.insert(G.playing_cards, c)
              c.states.visible = true
              G.deck:emplace(c)
              return true
            end
          })) 
        end
        card.ability.extra.cards = {}
        return {
          message = localize('k_copied_ex'),
          colour = G.C.MONOBLUE,
          card = card,
          playing_cards_created = {true}
        }
      end
    end
  end
}

-- Nostalgie
SMODS.Joker{
  key = 'nostalgie',
  loc_txt = {
    name = 'Nostalgie',
	  text = {
      'Played {C:spades}#1#{} cards have a',
      '{C:green}#2# in #3#{} chance to make',
      "the played {C:attention}poker hand{}'s",
      '{C:planet}Planet{} card'
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
  pos = {x = 5, y = 2},
  config = {extra = {odds = 4}},
  loc_vars = function(self,info_queue,card)
    return {vars = {localize('Spades', 'suits_singular'), G.GAME.probabilities.normal, card.ability.extra.odds}}
  end,
  calculate = function(self,card,context)
    if context.individual and context.cardarea == G.play then
      if context.other_card and context.other_card:is_suit('Spades') and (pseudorandom('nostalgie') < G.GAME.probabilities.normal/card.ability.extra.odds) 
      and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
        G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
        return {
          extra = {focus = card, message = localize('k_plus_planet'), func = function()
            G.E_MANAGER:add_event(Event({
              trigger = 'before',
              delay = 0.0,
              func = (function()
                local _planet = 0
                for k, v in pairs(G.P_CENTER_POOLS.Planet) do
                  if v.config.hand_type == G.GAME.last_hand_played then
                    _planet = v.key
                  end
                end
                local card = create_card('Planet',G.consumeables, nil, nil, nil, nil, _planet, 'star')
                card:add_to_deck()
                G.consumeables:emplace(card)
                G.GAME.consumeable_buffer = 0
              return true
              end)}))
            end},
          colour = G.C.SECONDARY_SET.Planet,
          card = card
        }
      end
    end
  end
}

-- Anxiété
SMODS.Joker{
  key = 'anxiete',
  loc_txt = {
    name = 'Anxiété',
	  text = {
      "{C:mult}+#1#{} Mult every",
      "{C:attention}#2#{} hands played",
      "{C:inactive}#3#",
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
  pos = {x = 4, y = 3},
  config = {extra = {mult = 30, every = 3, remaining = 2}},
  loc_vars = function(self,info_queue,card)
    return {vars = {card.ability.extra.mult,card.ability.extra.every,
    card.ability.extra.remaining > 0 and ""..card.ability.extra.remaining.." remaining" or "Active!"}}
  end,
  calculate = function(self,card,context)
    if context.before then
      card.ability.extra.remaining = card.ability.extra.remaining - 1
      if card.ability.extra.remaining == 0 then
        local eval = function(card) return (card.ability.extra.remaining == 0) end
        juice_card_until(card, eval, true)
      end
      card_eval_status_text(card, 'extra', nil, nil, nil, {colour = G.C.MONORED, message = "Tick..." })
    elseif context.joker_main and card.ability.extra.remaining < 0 then
      card.ability.extra.remaining = card.ability.extra.every-1
      return { 
        colour = G.C.RED,
        mult = card.ability.extra.mult,
      }
    end
  end,
}

-- Accablement & Abattement
SMODS.Joker{
  key = 'accablement',
  loc_txt = {
    name = 'Accablement & Abattement',
	  text = {
      'Randomly {C:attention}Debuffs{}',
      'a scoring card,',
      '{X:mult,C:white}X#1#{} Mult'
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
  pos = {x = 6, y = 3},
  config = {Xmult = 2.5},
  loc_vars = function(self,info_queue,card)
    return {vars = {card.ability.Xmult}}
  end,
  calculate = function(self,card,context)
    if context.isat_press_play then
      G.E_MANAGER:add_event(Event({
        func = function()
          local cardlist = {}
          for k,v in ipairs(G.play.cards) do
            if not v.debuff then
              table.insert(cardlist,v)
            end
          end
          local _card = pseudorandom_element(cardlist,pseudoseed('acca')) or G.play.cards[1]
          if not _card.debuff then
            _card.debuff = true
            card_eval_status_text(_card, 'extra', nil, nil, nil, {message = localize('k_debuffed')})
          end
          return true
        end
      })) 
    elseif context.joker_main then
      return{
        Xmult = card.ability.Xmult
      }
    end
  end
}