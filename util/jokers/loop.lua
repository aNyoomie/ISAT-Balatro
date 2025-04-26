-- Loop
SMODS.Joker{
  key = 'loop',
  loc_txt = {
    name = 'Loop',
	  text = {
      'This Joker gains {X:mult,C:white}X#2#{} Mult',
      'at end of round or',
      'when {C:attention}Blind{} is skipped',
      '{C:inactive}(Currently {X:mult,C:white} X#1# {C:inactive} Mult)',
	    "{E:1,C:inactive}Hey, Stardust!",
    },
    unlock = {
      "Loop with {E:1,C:snack}Siffrin{}"
    }
  },
  rarity = 3,
  cost = 7,
  unlocked = false,
  discovered = false,
  blueprint_compat = true,
  perishable_compat = true, 
  eternal_compat = true,
  atlas = 'Jokers',
  pos = {x = 0, y = 1},
  config = {xmult = 1, xmult_bonus = 0.15, extra = {}},
  loc_vars = function(self,info_queue,card)
    return{vars = {card.ability.xmult,card.ability.xmult_bonus}}
  end,
  calculate = function(self,card,context)
    if context.joker_main and card.ability.xmult > 1 then
      return { 
        colour = G.C.RED,
        Xmult = card.ability.xmult,
      }
    elseif ((not context.repetition and not context.individual and context.end_of_round) or context.skip_blind) and not context.blueprint then
      card.ability.xmult = card.ability.xmult + card.ability.xmult_bonus
      card_eval_status_text(card, 'extra', nil, nil, nil, {colour = G.C.RED, message = localize{ type = 'variable', key = 'a_xmult', vars = { card.ability.xmult } } })
    end
    if ((context.skip_blind and G.GAME.round_resets.blind_states.Boss == 'Select') --skip check
    or (context.ending_shop and G.GAME.round_resets.blind_states.Big == 'Defeated')) --shop check
    and G.GAME.round_resets.ante == G.GAME.win_ante and not context.blueprint then
      for i = 1, #G.jokers.cards do
        if G.jokers.cards[i].config.center.key == 'j_isat_siffrin' then
          card.ability.extra.siffplace = i
        end
      end
      if card.ability.extra.siffplace then
        card:set_eternal(true)
        G.jokers.cards[card.ability.extra.siffplace]:set_eternal(true)
        G.jokers.cards[card.ability.extra.siffplace].pinned = true
        G.jokers.cards[card.ability.extra.siffplace].ability.extra.loop = false
        G.E_MANAGER:add_event(Event({
          func = function()
            G.E_MANAGER:add_event(Event({
              func = function()
                G.jokers.cards[1].ability.mult_bonus = 3
                G.jokers.cards[1].ability.extra.phase = 3
                G.jokers.cards[1].ability.extra.pos_override.x = 3
                G.jokers.cards[1].children.center:set_sprite_pos(G.jokers.cards[1].ability.extra.pos_override)
                return true
              end
            }))
            G.E_MANAGER:add_event(Event({
              func = function()
                trigger = 'after'
                local delay = 1.6
                play_sound('isat_shift',1,0.15)
                if not extra or not extra.no_juice then
                  G.jokers.cards[1]:juice_up(0.6, 0.1)
                end
                return true
              end
            }))
            return true
          end
        }))
        local par = G.blind_select_opts.boss.parent
        G.GAME.round_resets.blind_choices.Boss = "bl_isat_loop_bossblind"
        if G.STATE == G.STATES.BLIND_SELECT then
          G.blind_select_opts.boss:remove()
          G.blind_select_opts.boss = UIBox {
              T = {par.T.x, 0, 0, 0},
              definition = {
                  n = G.UIT.ROOT,
                  config = {
                      align = "cm",
                      colour = G.C.CLEAR
                  },
                  nodes = {UIBox_dyn_container({create_UIBox_blind_choice('Boss')}, false,
                      get_blind_main_colour('Boss'), mix_colours(G.C.BLACK, get_blind_main_colour('Boss'), 0.8))}
              },
              config = {
                  align = "bmi",
                  offset = {
                      x = 0,
                      y = G.ROOM.T.y + 9
                  },
                  major = par,
                  xy_bond = 'Weak'
              }
            }
            par.config.object = G.blind_select_opts.boss
            par.config.object:recalculate()
            G.blind_select_opts.boss.parent = par
            G.blind_select_opts.boss.alignment.offset.y = 0

            for i = 1, #G.GAME.tags do
                if G.GAME.tags[i]:apply_to_run({
                    type = 'new_blind_choice'
                }) then
                    break
                end
            end
          end
        end
    -- swaps loop for loop_boss
    elseif context.setting_blind and not context.blueprint and card.ability.extra.siffplace and G.GAME.blind:get_type() == 'Boss' then
      if card.edition then
        previous_edition = card.edition
      end
      local jokers_to_create = math.min(1,
        G.jokers.config.card_limit - (#G.jokers.cards + G.GAME.joker_buffer))
      G.GAME.joker_buffer = G.GAME.joker_buffer + jokers_to_create
      G.GAME.loopcarryover = card.ability.xmult
      G.E_MANAGER:add_event(Event({
        func = function()
          card:start_dissolve({HEX("EAEAEA")}, true, nil)
          return true
        end
      })) 
      G.E_MANAGER:add_event(Event({
        func = function()
          local card = create_card('Joker', G.jokers, nil, 0, nil, nil,
            'j_isat_loop_boss', nil)
          if previous_edition then
            card:set_edition(previous_edition, true)
          else
            card:set_edition(nil, true)
          end
          card:set_eternal(true)
          card:add_to_deck()
          G.jokers:emplace(card)
          card:start_materialize()
          G.GAME.joker_buffer = 0
          play_sound('isat_shift',1,0.15)
          if not extra or not extra.no_juice then
            card:juice_up(0.6, 0.1)
          end
          return true
        end
      }))
    end
  end,
  add_to_deck = function(self, card, from_debuff)
    if G.GAME.loopcarryover then
      card.ability.xmult = G.GAME.loopcarryover
      G.GAME.loopcarryover = nil
    end
  end
}

-- LoopBoss
SMODS.Joker{
  key = 'loop_boss',
  loc_txt = {
    name = 'Loop',
	  text = {
      '{E:1,C:inactive}Stage! Lights!',
      '{E:1,C:inactive}Action! Teehee!!!'
    },
  },
  rarity = 'isat_starlight',
  cost = -1,
  unlocked = true,
  discovered = true,
  blueprint_compat = true,
  atlas = 'Jokers',
	no_collection = true,
	in_pool = function(self, args)
		return false
	end,
  pos = {x = 1, y = 1},
  config = {submult = 0,divmult = 1.5, extra = {shift = false,phase = 0,targetphase = 0,pos_override={x = 1, y = 1}}},
	process_loc_text = function(self)
		SMODS.process_loc_text(G.localization.descriptions[self.set], self.key, self.loc_txt)
		SMODS.process_loc_text(G.localization.descriptions[self.set], "loop_boss2", {
			name = 'Loop',
      text = {
        '{X:snack,C:white}÷#2#{} Mult',
        '{E:1,C:inactive}Have you forgotten',
        '{E:1,C:inactive}who I used to be?'
      },
		})
    SMODS.process_loc_text(G.localization.descriptions[self.set], "loop_boss3", {
			name = 'Loop',
      text = {
        '{X:snack,C:white}÷#2#{} Mult',
        '{C:snack}-#1#{} Mult',
        '{C:red}THEY WERE MINE FIRST!!',
        '{E:1,s:1.2,C:red}AND YOU STOLE THEM FROM ME!!!'
      },
		})
	end,
  loc_vars = function(self,info_queue,card)
    return {key = (card.ability.extra.phase == 1 and "loop_boss2" or card.ability.extra.phase == 2 and "loop_boss3" or card.config.center.key), 
    vars = {card.ability.submult,card.ability.divmult}}
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
    if context.joker_main and card.ability.extra.phase > 0 then
      return { 
        divmult = card.ability.divmult,
        submult = (card.ability.extra.phase > 1 and card.ability.submult)or 0,
      }
    elseif context.phase_change then
      if card.ability.extra.targetphase > card.ability.extra.phase then
        return {
          G.E_MANAGER:add_event(Event({
            func = function()
              G.E_MANAGER:add_event(Event({
                func = function()
                  card.ability.submult = (G.jokers.cards[1].ability.mult)
                  card.ability.divmult = (G.jokers.cards[1].ability.xmult1)
                  card.ability.extra.phase = card.ability.extra.targetphase
                  card.ability.extra.pos_override.x = card.ability.extra.phase+1
                  card.children.center:set_sprite_pos(card.ability.extra.pos_override)
                  return true
                end
              }))
              G.E_MANAGER:add_event(Event({
                func = function()
                  trigger = 'after'
                  local delay = 0.6
                  play_sound('isat_loop',1,0.1)
                  if not extra or not extra.no_juice then
                    card:juice_up(0.6, 0.1)
                  end
                  card_eval_status_text(card, 'extra', nil, nil, nil,
                          { message = "(Loop looped back.)", colour = G.C.GREY, delay = 2.75 })
                  return true
                end
              }))
              return true
            end
          }))
        }
      end
    -- turn back into normal loop oh my god
    elseif not context.repetition and not context.individual and context.end_of_round and not context.blueprint then
      if card.edition then
        previous_edition = card.edition
      end
      G.jokers.cards[1]:set_eternal(false)
      G.jokers.cards[1].pinned = false
      local jokers_to_create = math.min(1,
        G.jokers.config.card_limit - (#G.jokers.cards + G.GAME.joker_buffer))
      G.GAME.joker_buffer = G.GAME.joker_buffer + jokers_to_create
      G.E_MANAGER:add_event(Event({
        func = function()
          card:start_dissolve({HEX("EAEAEA")}, true, 0.5)
          return true
        end
      })) 
      G.E_MANAGER:add_event(Event({
        func = function()
          local card = create_card('Joker', G.jokers, nil, 0, nil, nil,
            'j_isat_loop', nil)
          if previous_edition then
            card:set_edition(previous_edition, true)
          else
            card:set_edition(nil, true)
          end
          card:add_to_deck()
          G.jokers:emplace(card)
          card:start_materialize()
          G.GAME.joker_buffer = 0
          play_sound('isat_shift',1,0.15)
          if not extra or not extra.no_juice then
            card:juice_up(0.6, 0.1)
          end
          return true
        end
      }))
    end
  end
}

--Boss Blind
SMODS.Blind{
  key = 'loop_bossblind',
  loc_txt = {
    name = 'Loop',
	  text = {
      "It's you."
    },
  },
  no_collection = true,
  unlocked = true,
  discovered = true,
  perishable_compat = false, 
  atlas = 'isat_blind',
  pos = {x = 0, y = 0},
  boss = {min = 1, max = 10, showdown = true},
  dollars = 5,
  mult = 1,
  boss_colour = HEX('AAAAAA'),
  config = {extra = {phase = 0,triggered = false,blind_mult = {1,0.7,0.5},blind_clears = {1,0.7,0.3}}},
	in_pool = function(self, args)
		return false
	end,
  set_blind = function(self)   
    self.config.extra.final = nil
    self.config.extra.triggered = false
    self.config.extra.phase = 0
    self.config.extra.scale = get_blind_amount(G.GAME.round_resets.ante)*G.GAME.starting_params.ante_scaling
    for i = 1, #self.config.extra.blind_clears do
      self.config.extra.blind_clears[i] = self.config.extra.blind_mult[i]* self.config.extra.scale
    end
    ease_background_colour{new_colour = lighten(G.C.WHITE,0.4), special_colour = mix_colours(G.C.WHITE, G.C.BLACK,0.5), tertiary_colour = darken(G.C.BLACK, 0.4), contrast = 5}
  end,
  press_play = function(self)
    -- re-debuffs jokers incase others were added
    local loop_pos = nil
    for i = 2, #G.jokers.cards do
      if G.jokers.cards[i].config.center.key ~= 'j_isat_loop_boss' then
        G.jokers.cards[i]:set_debuff(true)
        if G.jokers.cards[i].debuff then G.jokers.cards[i].debuffed_by_blind = true end
      else
        loop_pos = i
      end
    end
    if G.jokers.cards[loop_pos].ability.extra.phase == 2 then 
      ease_background_colour{new_colour = lighten(G.C.WHITE,0.4), special_colour = G.C.RED, tertiary_colour = darken(G.C.BLACK, 0.4), contrast = 5}
    else
      ease_background_colour{new_colour = lighten(G.C.WHITE,0.4), special_colour = mix_colours(G.C.WHITE, G.C.BLACK,0.5), tertiary_colour = darken(G.C.BLACK, 0.4), contrast = 5}
    end
    -- deals with loading mid fight resetting blind_clears
    self.config.extra.scale = get_blind_amount(G.GAME.round_resets.ante)*G.GAME.starting_params.ante_scaling
    for i = 1, #self.config.extra.blind_clears do
      self.config.extra.blind_clears[i] = self.config.extra.blind_mult[i]* self.config.extra.scale
    end
    -- deals with the the boss not drawing when on the final hand
    if G.GAME.current_round.hands_left <= 1 and self.config.extra.phase < 2 then 
      G.GAME.current_round.hands_left = G.GAME.current_round.hands_left + 1
      self.config.extra.final = true
    end
    -- sometimes it isnt triggered
    if self.config.extra.phase < 2 then
      G.E_MANAGER:add_event(Event({
        func = function()
          G.GAME.blind.chips = (100000000000000000000000000000000000000000000000000000000000000)
          G.GAME.blind.chip_text = number_format(self.config.extra.blind_clears[self.config.extra.phase+1])
          return true
        end
      })) 
    end
  end,
  drawn_to_hand = function(self)
    local loop_pos = nil
    for i = 1, #G.jokers.cards do
      if G.jokers.cards[i].config.center.key == 'j_isat_loop_boss' then
        loop_pos = i
      end
    end
    -- a force spawn of loop because sometimes the boss shows up without loop?????? i dont fucking know how. but this might help.
    if not loop_pos then
      G.E_MANAGER:add_event(Event({
        func = function()
          local card = create_card('Joker', G.jokers, nil, 0, nil, nil,
            'j_isat_loop_boss', nil)
          card:set_eternal(true)
          card:add_to_deck()
          G.jokers:emplace(card)
          G.GAME.joker_buffer = 0
          play_sound('isat_shift',1,0.15)
          if not extra or not extra.no_juice then
            card:juice_up(0.6, 0.1)
          end
          return true
        end
      }))
      loop_pos = #G.jokers.cards
    end
    if #G.hand.cards < G.hand.config.card_limit then
      G.hand:change_size(G.hand.config.card_limit-#G.hand.cards)
      G.hand:change_size(-1*(G.hand.config.card_limit-#G.hand.cards))
    end
    if not self.config.extra.triggered then
      G.E_MANAGER:add_event(Event({
        func = function()
            G.GAME.blind.chips = (100000000000000000000000000000000000000000000000000000000000000)
            G.GAME.blind.chip_text = number_format(self.config.extra.blind_clears[1])
            G.hand_text_area.blind_chips:juice_up()
            return true
        end
      })) 
      for i = 2, #G.jokers.cards do
        if i ~= loop_pos then
          G.jokers.cards[i]:set_debuff(true)
          if G.jokers.cards[i].debuff then G.jokers.cards[i].debuffed_by_blind = true end
        end
      end
      self.config.extra.triggered = true
    end
    -- red bg
    if G.jokers.cards[loop_pos].ability.extra and G.jokers.cards[loop_pos].ability.extra.phase == 2 then 
      ease_background_colour{new_colour = lighten(G.C.WHITE,0.4), special_colour = G.C.RED, tertiary_colour = darken(G.C.BLACK, 0.4), contrast = 5}
    end
    local chipscore = G.GAME.chips
    if (SMODS.Mods['Talisman'] or {}).can_load then chipscore = to_big(G.GAME.chips) end
    if chipscore > self.config.extra.blind_clears[self.config.extra.phase+1] then
      self.config.extra.phase = self.config.extra.phase+1
      G.jokers.cards[loop_pos].ability.extra.targetphase = self.config.extra.phase
      G.jokers.cards[loop_pos]:calculate_joker({phase_change = true})
      self.config.extra.redraw = true
      self.config.extra.final = nil
      G.GAME.chips = 0
    end
    if self.config.extra.final == true then
      G.GAME.current_round.hands_left = G.GAME.current_round.hands_left - 1
			G.STATE = G.STATES.HAND_PLAYED
			G.STATE_COMPLETE = true
			end_round()
    end
    if self.config.extra.redraw then
      self.config.extra.redraw = nil
      G.E_MANAGER:add_event(Event({
        func = function()
          G.E_MANAGER:add_event(Event({
            trigger = "immediate",
            func = function()
              G.STATE = G.STATES.DRAW_TO_HAND
              G.deck:shuffle()
              G.deck:hard_set_T()
              G.STATE_COMPLETE = false
              return true
            end,
          }))
          G.FUNCS.draw_from_hand_to_discard()
          G.FUNCS.draw_from_discard_to_deck()
          G.GAME.blind.chips = ((self.config.extra.phase > 1 and self.config.extra.blind_clears[3]) or G.GAME.blind.chips)
          G.GAME.blind.chip_text = number_format(self.config.extra.blind_clears[self.config.extra.phase+1])
          G.hand_text_area.blind_chips:juice_up()
          delay(0.5)
          return true
        end
      })) 
      ease_discard(
        math.max(0, G.GAME.round_resets.discards + G.GAME.round_bonus.discards) - G.GAME.current_round.discards_left
      )
      ease_hands_played(
        math.max(1, G.GAME.round_resets.hands + G.GAME.round_bonus.next_hands) - G.GAME.current_round.hands_left
      )
      G.deck:shuffle('loop'..G.GAME.round_resets.ante)
      G.deck:hard_set_T()
      delay(0.3)
      G.hand:change_size(G.hand.config.card_limit)
      G.hand:change_size(-1*G.hand.config.card_limit)
      for k, v in pairs(G.playing_cards) do
        v.ability.wheel_flipped = nil
      end
    end
  end,
  recalc_debuff = function(self, card, from_blind)
      return card.debuff
  end,
  disable = function(self)
    for _, card in pairs(G.playing_cards) do
        if card.debuff then card:set_debuff() end
    end
    G.E_MANAGER:add_event(Event({
      func = function()
        G.GAME.blind.chips = get_blind_amount(G.GAME.round_resets.ante)*G.GAME.starting_params.ante_scaling
        G.GAME.blind.chip_text = number_format(G.GAME.blind.chips)
        return true
      end
    })) 
  end,
  defeat = function(self)
    for _, card in pairs(G.playing_cards) do
        if card.debuff then card:set_debuff() end
    end
  end
}