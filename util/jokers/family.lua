-- Siff
SMODS.Joker{
  key = 'siffrin',
  loc_txt = {
    name = 'Siffrin',
	  text = {
      '{C:red}+#2#{} Mult at end of round',
      'or when {C:attention}Blind{} is skipped',
      '{C:inactive}(Currently {C:red}+#1#{} {C:inactive}Mult)',
	    "{E:1,C:inactive}It's you!",
    },
  },
  rarity = 2,
  cost = 6,
  unlocked = true,
  discovered = true,
  blueprint_compat = true,
  perishable_compat = false, 
  eternal_compat = true,
  atlas = 'Jokers',
  pos = {x = 0, y = 0},
  config = {mult = 0, mult_bonus = 3,xmult1 = 1.5, xmult2 = 2.5, extra = {loop = true, loopcount = 0, shift = false,phase = 0,targetphase = 0,antephases = {3,7,8},pos_override={x = 0, y = 0}}},
	process_loc_text = function(self)
		SMODS.process_loc_text(G.localization.descriptions[self.set], self.key, self.loc_txt)
		SMODS.process_loc_text(G.localization.descriptions[self.set], "siffrin2", {
			name = 'Siffrin',
      text = {
        '{C:red}+#2#{} Mult at end of round',
        'or when {C:attention}Blind{} is skipped',
        '{C:inactive}(Currently {C:red}+#1#{} {C:inactive}Mult)',
        '{X:mult,C:white}X#3#{} Mult',
        "{C:inactive}It's you.",
      },
		})
    SMODS.process_loc_text(G.localization.descriptions[self.set], "siffrin3", {
			name = 'Siffrin',
      text = {
        '{C:red}+#2#{} Mult at end of round',
        'or when {C:attention}Blind{} is skipped',
        '{C:inactive}(Currently {C:red}+#1#{} {C:inactive}Mult)',
        '{X:mult,C:white}X#3#{} Mult',
        "{C:inactive}(Finish it.)",
      },
		})
    SMODS.process_loc_text(G.localization.descriptions[self.set], "siffrin4", {
			name = 'Siffrin',
      text = {
        '{C:red}+#2#{} Mult at end of round',
        '{C:inactive}(Currently {C:red}+#1#{} {C:inactive}Mult)',
        '{X:mult,C:white}X#3#{} Mult',
        "{E:1,C:inactive}It's you!!!!",
      },
		})
	end,
  loc_vars = function(self,info_queue,card)
    if card.config then
      if card.ability.extra.phase < 3 and not card.debuff then
        info_queue[#info_queue + 1] = {generate_ui = isat_tooltip, key = 'timeloop', title = 'Your Wish?',vars = {(card.ability.extra.loop and "Active") or "Inactive"}}
      end
      return {key = (card.ability.extra.phase == 1 and "siffrin2" or card.ability.extra.phase == 2 and "siffrin3" or card.ability.extra.phase == 3 and "siffrin4" or card.config.center.key), 
      vars = {card.ability.mult,card.ability.mult_bonus,((card.ability.extra.phase == 1 or card.ability.extra.phase == 3) and card.ability.xmult1 or card.ability.extra.phase == 2 and card.ability.xmult2)}}
    else
      return{vars = {card.ability.mult,card.ability.mult_bonus}}
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
				Xmult = ((card.ability.extra.phase == 1 or card.ability.extra.phase == 3) and card.ability.xmult1 
                  or card.ability.extra.phase == 2 and card.ability.xmult2)
      }
      end
    if context.game_over and card.ability.extra.loop and not context.blueprint then
      unlock_card(G.P_CENTERS["j_isat_loop"])
      if G.GAME.round_resets.ante == 8 then unlock_card(G.P_CENTERS["j_isat_mal"]) end
      card.ability.extra.shift = false
      card.ability.extra.targetphase = 0
      card.ability.mult = card.ability.mult + card.ability.mult_bonus
      card.ability.extra.loop = false
      card.ability.extra.loopcount = card.ability.extra.loopcount + 1
      G.localization.misc.dictionary.ph_mr_bones = "Loop "..card.ability.extra.loopcount
      if G.GAME.blind:get_type() == 'Boss' and not G.GAME.looping then G.GAME.round_resets.ante = G.GAME.round_resets.ante-1 end
      G.GAME.looping = true
      return {message = 'Loop Back!',sound = "isat_loop", volume = 0.1,colour = G.C.L_BLACK,
        saved = true}
    elseif context.isat_cash_out and G.GAME.looping and not context.blueprint then
      -- undoes loop
      for i = 1, #G.jokers.cards do
        if G.jokers.cards[i].config.center.key == 'j_isat_loop' then
          G.jokers.cards[i].ability.extra.bigover = nil
        end
      end
      G.GAME.looping = nil
      G.GAME.round_resets.blind_states = G.GAME.round_resets.blind_states or {Small = 'Select', Big = 'Upcoming', Boss = 'Upcoming'}
      G.GAME.round_resets.blind_states.Small = 'Upcoming'
      G.GAME.round_resets.blind_states.Big = 'Upcoming'
      G.GAME.round_resets.blind_states.Boss = 'Upcoming'
      G.GAME.blind_on_deck = 'Small'
      card_eval_status_text(card, 'extra', nil, nil, nil,
              { message = "Ante Reset!", colour = G.C.GREY })
    elseif context.ending_shop then
      G.localization.misc.dictionary.ph_mr_bones = card.config.old_bones
    elseif ((not context.repetition and not context.individual and context.end_of_round) or (context.skip_blind and card.ability.extra.phase < 3)) and not context.blueprint then
      if G.GAME.blind:get_type() == 'Boss' and card.ability.extra.phase < 3 then card.ability.extra.loop = true
      elseif card.ability.extra.phase == 3 and card.ability.extra.loop then card.ability.extra.loop = false end
      card.ability.mult = card.ability.mult + card.ability.mult_bonus
      card_eval_status_text(card, 'extra', nil, nil, nil, {colour = G.C.RED, message = localize{ type = 'variable', key = 'a_mult', vars = { card.ability.mult } } })   
    end
    -- handles card art shift
    if context.isat_cash_out and card.ability.extra.shift and not context.blueprint then
      card.ability.extra.shift = false
      return {
        G.E_MANAGER:add_event(Event({
          func = function()
            G.E_MANAGER:add_event(Event({
              func = function()
                card.ability.mult_bonus = (card.ability.extra.targetphase == 3 and 3) or 3 - card.ability.extra.targetphase
                card.ability.extra.phase = card.ability.extra.targetphase
                card.ability.extra.pos_override.x = card.ability.extra.phase
                card.children.center:set_sprite_pos(card.ability.extra.pos_override)
                return true
              end
            }))
            G.E_MANAGER:add_event(Event({
              func = function()
                trigger = 'after'
                local delay = 0.6
                play_sound('isat_shift',1,0.15)
                if not extra or not extra.no_juice then
                  card:juice_up(0.6, 0.1)
                end
                return true
              end
            }))
            return true
          end
        }))
      }
    -- checks if it should shift after the round
    elseif context.first_hand_drawn and not context.blueprint then
      if G.GAME.blind and G.GAME.blind:get_type() == 'Boss' then
        for i = 1, #card.ability.extra.antephases do
          if G.GAME.round_resets.ante >= card.ability.extra.antephases[i] then
            card.ability.extra.targetphase = i
          end
        end
        if card.ability.extra.phase < card.ability.extra.targetphase then
          card.ability.extra.shift = true
        end
      end
    -- -1 ante shift
    elseif context.isat_voucher and not context.blueprint then
      if card.ability.extra.phase == 0 and G.GAME.used_vouchers.v_hieroglyph then
        card.ability.extra.targetphase = 1
      elseif card.ability.extra.phase == 1 and G.GAME.used_vouchers.v_petroglyph then
        card.ability.extra.targetphase = 2
      end
      if card.ability.extra.phase < card.ability.extra.targetphase then
        return {
          G.E_MANAGER:add_event(Event({
            func = function()
              G.E_MANAGER:add_event(Event({
                func = function()
                  card.ability.mult_bonus = (card.ability.extra.targetphase == 3 and 3) or 3 - card.ability.extra.targetphase
                  card.ability.extra.phase = card.ability.extra.targetphase
                  card.ability.extra.pos_override.x = card.ability.extra.phase
                  card.children.center:set_sprite_pos(card.ability.extra.pos_override)
                  return true
                end
              }))
              G.E_MANAGER:add_event(Event({
                func = function()
                  trigger = 'after'
                  local delay = 1.6
                  play_sound('isat_shift',1,0.15)
                  if not extra or not extra.no_juice then
                    card:juice_up(0.6, 0.1)
                  end
                  return true
                end
              }))
              return true
            end
          }))
        }
      end
    end
    -- snack unlock
    if context.end_of_round and G.GAME.blind:get_type() == 'Boss' and G.GAME.round_resets.ante == G.GAME.win_ante then
      local siff = nil
      local bonnie = nil
      for i = 1, #G.jokers.cards do
        if G.jokers.cards[i].config.center.key == 'j_isat_siffrin' then
            siff = true
        elseif G.jokers.cards[i].config.center.key == 'j_isat_bonnie' then
            bonnie = true
        end
      end
      if siff and bonnie then
        unlock_card(G.P_CENTERS["c_isat_eternal"])
      end
    end
  end,
  -- incase the win ante isnt 8 for some reason
  add_to_deck = function(self, card, from_debuff)
    card.ability.extra.antephases[2] = G.GAME.win_ante-1
    card.ability.extra.antephases[3] = G.GAME.win_ante
  end,
}

-- Mira
SMODS.Joker{
  key = 'mira',
  loc_txt = {
    name = 'Mirabelle',
	  text = {
      'Played Debuffed Cards',
      'become {C:attention}Undebuffed',
	    '{E:1,C:inactive}The Housemaiden!'
    },
  },
  rarity = 2,
  cost = 5,
  unlocked = true,
  discovered = true,
  blueprint_compat = false,
  perishable_compat = true, 
  eternal_compat = true,
  atlas = 'Jokers',
  pos = {x = 4, y = 0},
  config = {extra = {}},
  calculate = function(self,card,context)
    if context.isat_press_play then
      G.E_MANAGER:add_event(Event({
        func = function()
          for k, v in ipairs(G.play.cards) do
            if v.debuff then 
              G.E_MANAGER:add_event(Event({
                func = function()
                  v.debuff = false
                  card_eval_status_text(v, 'extra', nil, nil, nil, {message = "Undebuffed!"})
                  return true
                end
              })) 
            end
          end
          return true
        end
      })) 
    end
  end,
}

-- Isa
SMODS.Joker{
  key = 'isa',
  loc_txt = {
    name = 'Isabeau',
	  text = {
      'This Joker gains {X:mult,C:white}X#2#{} Mult',
      'when a {C:attention}King{} is scored,',
      'Resets at end of round',
      '{C:inactive}(Currently {X:mult,C:white}X#1#{C:inactive} Mult)',
	    '{E:1,C:inactive}The Fighter!'
    },
  },
  rarity = 2,
  cost = 6,
  unlocked = true,
  discovered = true,
  blueprint_compat = true,
  perishable_compat = true, 
  eternal_compat = true,
  atlas = 'Jokers',
  pos = {x = 5, y = 0},
  config = {Xmult = 1, Xmult_bonus = 0.4, extra = {}},
  loc_vars = function(self,info_queue,card)
    return {vars = {card.ability.Xmult,card.ability.Xmult_bonus}}
  end,
  calculate = function(self,card,context)
    if context.joker_main and card.ability.Xmult > 1 then
      return { 
        colour = G.C.RED,
        Xmult = card.ability.Xmult,
      }
    elseif context.individual and context.cardarea == G.play then
      if context.other_card and context.other_card:get_id() == 13 and not context.blueprint then
        card.ability.Xmult = card.ability.Xmult + card.ability.Xmult_bonus           
        return {
            extra = {focus = card, message = localize('k_upgrade_ex'),colour = G.C.MULT},
            card = card,
        }
      end
    elseif not context.repetition and not context.individual and not card.ability.extra.jason
    and context.end_of_round and not context.blueprint then
      card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('k_reset')})
      card.ability.Xmult = 1
    end
  end,
}

-- Odile
SMODS.Joker{
  key = 'odile',
  loc_txt = {
    name = 'Odile',
	  text = {
      'Reduces Blind',
      'Requirement by {C:attention}#1#%',
	    '{E:1,C:inactive}The Researcher!'
    },
  },
  rarity = 2,
  cost = 5,
  unlocked = true,
  discovered = true,
  blueprint_compat = true,
  perishable_compat = true, 
  eternal_compat = true,
  atlas = 'Jokers',
  pos = {x = 6, y = 0},
  config = {extra = 25},
  loc_vars = function(self,info_queue,card)
    return {vars = {card.ability.extra}}
  end,
  calculate = function(self,card,context)
    if context.first_hand_drawn then 
      G.E_MANAGER:add_event(Event({
        func = function()
          G.GAME.blind.chips = G.GAME.blind.chips*0.01*(100-card.ability.extra)
          G.GAME.blind.chip_text = number_format(G.GAME.blind.chips)
          G.hand_text_area.blind_chips:juice_up()
          card_eval_status_text(card, 'extra', nil, nil, nil,
                        { message = "Blind Lowered!", colour = G.C.GREY, delay = 1 })
          return true
        end
      })) 
    end
  end,
}

-- Bonnie
SMODS.Joker{
  key = 'bonnie',
  loc_txt = {
    name = 'Bonnie',
	  text = {
      'Create a {C:snack}Snack{} card',
      'when {C:attention}Cashing Out{}',
	    "{C:inactive}That's just a kid!!!"
    },
  },
  rarity = 1,
  cost = 5,
  unlocked = true,
  discovered = true,
  blueprint_compat = true,
  perishable_compat = true, 
  eternal_compat = true,
  atlas = 'Jokers',
  pos = {x = 7, y = 0},
  config = {extra = {}},
  loc_vars = function(self,info_queue,card)
    if card.ability.extra.rice then
      info_queue[#info_queue + 1] = {generate_ui = isat_tooltip, key = 'onigiri2', title = 'Good Snack'}
    end
  end,
  calculate = function(self,card,context)
    if context.isat_cash_out and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
      local rice_bonus = 0
      if card.ability.extra.rice then 
        rice_bonus = 1 
        card.ability.extra.rice = nil
      end
      G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1+rice_bonus
      G.E_MANAGER:add_event(Event({
        func = (function()
          for i = 1, 1+rice_bonus do
            local _card = create_card('snack',G.consumeables, nil, nil, nil, nil, nil, 'bon')
            G.E_MANAGER:add_event(Event({
              func = function() 
                _card:add_to_deck()
                G.consumeables:emplace(_card)
                G.GAME.consumeable_buffer = 0
                return true
              end})) 
            if _card.ability.name == "c_isat_onigiri" then
              card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {
                message = pseudorandom_element({"Oginiri...", "Orinigi...", "Onion-geeree."},pseudoseed('onigiri')), colour = HEX('848484'), delay = 1.25})
            else card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {
                message = _card.config.center.loc_txt.name .. "!!", colour = HEX('848484'), delay = 1.25})
            end
          end
        return true
      end)}))
    elseif context.ending_shop then
      card.ability.extra.rice = nil
    end
  end,
}