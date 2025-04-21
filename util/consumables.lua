SMODS.UndiscoveredSprite({
    key = "snack",
    atlas = 'snacks',
    pos = { x = 1, y = 1 }
})

SMODS.ConsumableType{
    key = "snack",
    primary_colour = HEX("848484"),
	secondary_colour = HEX("959595"),
	collection_rows = { 5, 5 },
	shop_rate = 0.0,
	loc_txt = {
        name = "Snack",
        collection = "Snack Cards",
        undiscovered = {
            name = 'Unknown Snack Card',
            text = {
                'Find this card in an unseeded',
                'run to find out what it does'
            }
        }
    },
	default = "c_isat_pineapple"
}

-- plantain
SMODS.Consumable{
    key = "plantain",
    set = 'snack',
    loc_txt = {
        name = 'Plantain Chips',
        text = {
        "{C:mult}+#1#{} Mult",
        "{C:green}#2# in #3#{} chance this card is",
        "destroyed at end of round",
        '{C:inactive}Crunchy. Delicious.',
        '{C:inactive}And full of potassium.'
        }
    },
    unlocked = true,
    atlas = 'snacks',
    pos = { x = 0, y = 0 },
    cost = 3,
    effect = "Enhance",
    config = {extra = {mult = 10, odds = 4}},
    loc_vars = function(self,info_queue,center)
        return {vars = {center.ability.extra.mult, G.GAME.probabilities.normal, center.ability.extra.odds}}
    end,
    set_ability = function(self, card, initial, delay_sprites)
        local scale = 1
        card.children.center.scale.y = (78/95)*card.children.center.scale.y
        card.T.h = card.T.h*(78/95)*scale
    end,
    can_use = function(self, card)
        return false
    end,
    use = function(self, card, area, copier)
    end,
    calculate = function(self,card,context)
        if context.joker_main and not card.debuff then
          return { 
            mult = card.ability.extra and card.ability.extra.mult,
          }
        elseif not context.repetition and not context.individual and context.end_of_round and card.ability.name == "c_isat_plantain" then
            if card.ability.extra and card.ability.extra.odds and 
            (pseudorandom('plantain') < G.GAME.probabilities.normal/card.ability.extra.odds) then
                G.E_MANAGER:add_event(Event({
                    func = function()
                        play_sound('tarot1')
                        card.T.r = -0.2
                        card:juice_up(0.3, 0.4)
                        card.states.drag.is = true
                        card.children.center.pinch.x = true
                        G.E_MANAGER:add_event(Event({
                            trigger = 'after',
                            delay = 0.3,
                            blockable = false,
                            func = function()
                                G.jokers:remove_card(card)
                                card:remove()
                                return true
                            end
                            }))
                        return true
                    end
                }))
                return {
                message = localize('k_extinct_ex')
                }
            else
                return {message = localize('k_safe_ex')}
            end
        end
    end      
}

-- cookies
SMODS.Consumable{
    key = "cookies",
    set = 'snack',
    loc_txt = {
        name = 'Cookies',
        text = {
        "Removes one selected {C:attention}Joker{}'s",
        '{C:dark_edition}Edition{} + {C:attention}Stickers{} and',
        "raises it's {C:attention}Sell Value{} by {C:money}$#1#{}",
        '{C:inactive}Boring but delicious!!!'
        }
    },
    unlocked = true,
    atlas = 'snacks',
    pos = { x = 1, y = 0 },
    cost = 3,
    effect = "Enhance",
    config = {extra = 5},
    loc_vars = function(self,info_queue,center)
        return {vars = {center.ability.extra}}
    end,
    set_ability = function(self, card, initial, delay_sprites)
        local scale = 1
        card.children.center.scale.y = (78/95)*card.children.center.scale.y
        card.T.h = card.T.h*(78/95)*scale
    end,
    can_use = function(self, card)
        return #G.jokers.highlighted == 1
    end,
    use = function(self, card, area, copier)
        G.jokers.highlighted[1].ability.extra_value = (G.jokers.highlighted[1].ability.extra_value or 0) + card.ability.extra
        G.jokers.highlighted[1]:set_cost()
        card_eval_status_text(G.jokers.highlighted[1], 'extra', nil, nil, nil, {message = localize('k_val_up'),colour = G.C.MONEY,})
        local edition = {foil = false, holo = false, polychrome = false, negative = false}
        delay(0.2)
        G.jokers.highlighted[1].ability.eternal = false
        G.jokers.highlighted[1].ability.rental = false
        G.jokers.highlighted[1].ability.perishable = false
        G.jokers.highlighted[1]:set_edition(edition, true)
        local loop = nil
        for i = 1, #G.jokers.cards do
            if G.jokers.cards[i].config.center.key == 'j_isat_loop_boss' then
                loop = true
            end
        end
        if G.jokers.highlighted[1].ability.perish_tally and G.jokers.highlighted[1].ability.perish_tally <= 0 and not loop then
            G.jokers.highlighted[1].debuff = false
        end
        G.E_MANAGER:add_event(Event({
            trigger = 'immediate',
            func = function()
            G.E_MANAGER:add_event(Event({
                trigger = 'immediate',
                func = function()
                G.GAME.last_snack = card.config.center_key
                    return true
                end
            }))
                return true
            end
        }))
    end,
}

-- onigiri
SMODS.Consumable{
    key = "onigiri",
    set = 'snack',
    loc_txt = {
        name = 'Onigiri',
        text = {
        'Gives +1 {C:red}Discard{} this round',
        'for every #1# {C:attention}Jokers',
        '{C:inactive}(Currently {}+#2#{C:inactive})',
        '{C:inactive}I. Love. Rice.'
        }
    },
    unlocked = true,
    atlas = 'snacks',
    pos = { x = 2, y = 0 },
    cost = 3,
    effect = "Enhance",
    config = {extra = 2},
    loc_vars = function(self,info_queue,center)
        info_queue[#info_queue + 1] = {generate_ui = isat_tooltip, key = 'onigiri', title = 'Favourite!'}
        return {vars = {center.ability.extra, math.floor(((G.jokers and #G.jokers.cards) or 0)/center.ability.extra)}}
    end,
    set_ability = function(self, card, initial, delay_sprites)
        local scale = 1
        card.children.center.scale.y = (78/95)*card.children.center.scale.y
        card.T.h = card.T.h*(78/95)*scale
    end,
    can_use = function(self, card)
        return #G.jokers.cards >= card.ability.extra and
        (G.GAME.round_resets.blind_states.Small == 'Current' 
        or G.GAME.round_resets.blind_states.Big == 'Current' 
        or G.GAME.round_resets.blind_states.Boss == 'Current')
    end,
    use = function(self, card, area, copier)
        G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
            play_sound('timpani')
            card:juice_up(0.3, 0.5)
            ease_discard(math.floor(#G.jokers.cards/card.ability.extra))
            return true end }))
        delay(0.6)
        for i = 1, #G.jokers.cards do
            if G.jokers.cards[i].config.center.key == 'j_isat_bonnie' then
              G.jokers.cards[i].ability.extra.rice = true
              G.jokers.cards[i]:juice_up()
            end
        end
        G.E_MANAGER:add_event(Event({
            trigger = 'immediate',
            func = function()
            G.E_MANAGER:add_event(Event({
                trigger = 'immediate',
                func = function()
                G.GAME.last_snack = card.config.center_key
                    return true
                end
            }))
                return true
            end
        }))
    end,
}

-- Madeleines
SMODS.Consumable{
    key = "madeleines",
    set = 'snack',
    loc_txt = {
        name = 'Madeleines',
        text = {
        "Adds {C:dark_edition}Polychrome{} edition",
        "to a random {C:attention}Joker",
        "and makes them {C:eternal}Eternal{}",
        '{C:inactive}Some madeleines!!!'
        }
    },
    unlocked = true,
    atlas = 'snacks',
    pos = { x = 3, y = 0 },
    cost = 3,
    effect = "Enhance",
    loc_vars = function(self,info_queue,center)
        info_queue[#info_queue + 1] = G.P_CENTERS.e_polychrome
        info_queue[#info_queue + 1] = {key = 'eternal', set = 'Other'}
    end,
    set_ability = function(self, card, initial, delay_sprites)
        local scale = 1
        card.children.center.scale.y = (78/95)*card.children.center.scale.y
        card.T.h = card.T.h*(78/95)*scale
    end,
    can_use = function(self, card)
        for i = 1, #G.jokers.cards do
            if G.jokers and not G.jokers.cards[i].edition and not G.jokers.cards[i].ability.eternal 
            and G.jokers.cards[i].config.center.eternal_compat and not G.jokers.cards[i].ability.perishable then 
                return true 
            end
        end
        return false
    end,
    use = function(self, card, area, copier)
        G.E_MANAGER:add_event(Event({
            trigger = 'immediate',
            func = function()
            G.E_MANAGER:add_event(Event({
                trigger = 'immediate',
                func = function()
                G.GAME.last_snack = card.config.center_key
                    return true
                end
            }))
                return true
            end
        }))
        local j_list = {}
        for k,v in pairs(G.jokers.cards) do
            j_list[k] = v
        end
        pseudoshuffle(j_list)
        for i = 1, #j_list do
            if not j_list[i].ability.eternal and j_list[i].config.center.eternal_compat and not j_list[i].ability.perishable and not j_list[i].edition then
                for j = 1, #G.jokers.cards do
                    if G.jokers.cards[j] == j_list[i] then
                        G.jokers.cards[j]:set_edition({polychrome = true})
                        G.jokers.cards[j]:set_eternal({true})
                        return
                    end
                end
            end
        end
    end,
}

-- Pineapple
SMODS.Consumable{
    key = "pineapple",
    set = 'snack',
    loc_txt = {
        name = 'Pineapple Slices',
        text = {
        'Selected Joker becomes {C:dark_edition}Negative{}',
        '{C:green}#1# in #2#{} chance to {C:attention}destroy{} Joker instead',
        "{C:inactive}With sugar.",
        "{C:inactive}That's what makes them good."
        }
    },
    unlocked = true,
    atlas = 'snacks',
    pos = { x = 4, y = 0 },
    cost = 3,
    effect = "Enhance",
    config = {extra = 4},
    loc_vars = function(self,info_queue,center)
        info_queue[#info_queue + 1] = {generate_ui = isat_tooltip, key = 'pineapple', title = 'Allergy'}
        return {vars = {3*G.GAME.probabilities.normal, center.ability.extra}}
    end,
    set_ability = function(self, card, initial, delay_sprites)
        local scale = 1
        card.children.center.scale.y = (78/95)*card.children.center.scale.y
        card.T.h = card.T.h*(78/95)*scale
    end,
    can_use = function(self, card)
		return #G.jokers.highlighted == 1 and (not G.jokers.highlighted[1].edition or not G.jokers.highlighted[1].edition.negative) and not G.jokers.highlighted[1].ability.eternal
    end,
    use = function(self, card, area, copier)
        G.E_MANAGER:add_event(Event({
            trigger = 'immediate',
            func = function()
            G.E_MANAGER:add_event(Event({
                trigger = 'immediate',
                func = function()
                G.GAME.last_snack = card.config.center_key
                    return true
                end
            }))
                return true
            end
        }))
        local siff = 0
        if G.jokers.highlighted[1].ability.name == "j_isat_siffrin" then siff = 1 end
        if pseudorandom('pineapple') < (siff+3*G.GAME.probabilities.normal)/card.ability.extra then
            G.E_MANAGER:add_event(Event({
                func = function()
                  play_sound('tarot1')
                  G.jokers.highlighted[1].T.r = -0.2
                  G.jokers.highlighted[1]:juice_up(0.3, 0.4)
                  G.jokers.highlighted[1].states.drag.is = true
                  G.jokers.highlighted[1].children.center.pinch.x = true
                  G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 0.3,
                    blockable = false,
                    func = function()
                    card_eval_status_text(G.jokers.highlighted[1], 'extra', nil, nil, nil,
                        { message = "Tasted good, though.", colour = HEX("848484"), delay = 2 })
                        G.jokers.highlighted[1]:remove()
                        return true
                    end
                    }))
                  return true
                  end
              }))
              return
        else
            G.jokers.highlighted[1]:set_edition({negative = true})
        end
    end,
}

-- Fish Head
SMODS.Consumable{
    key = "fish",
    set = 'snack',
    loc_txt = {
        name = 'Fish Head',
        text = {
        'Destroy a selected {C:attention}Joker',
        'and create a new {C:attention}Joker',
        'of the same {C:attention}rarity',
        '{E:1,s:1.1,C:inactive}FISH HEAD!!!!!!!!!!!!!!'
        }
    },
    unlocked = true,
    atlas = 'snacks',
    pos = { x = 5, y = 0 },
    cost = 3,
    effect = "Enhance",
    set_ability = function(self, card, initial, delay_sprites)
        local scale = 1
        card.children.center.scale.y = (78/95)*card.children.center.scale.y
        card.T.h = card.T.h*(78/95)*scale
    end,
    can_use = function(self, card)
        return #G.jokers.highlighted == 1
		and not G.jokers.highlighted[1].ability.eternal
    end,
    use = function(self, card, area, copier)
        local rarity = G.jokers.highlighted[1].config.center.rarity
        local legendary = nil
        if rarity == 1 then
			rarity = 0
		elseif rarity == 2 then
			rarity = 0.9
		elseif rarity == 3 then
			rarity = 0.99
		elseif rarity == 4 then
            legendary = true
        end
        local _first_dissolve = nil
        G.E_MANAGER:add_event(Event({
            trigger = "before",
            delay = 0.75,
            func = function()
                G.jokers.highlighted[1]:start_dissolve(nil, _first_dissolve)
                _first_dissolve = true
                return true
            end,
        }))
        G.E_MANAGER:add_event(Event({
            trigger = "after",
            delay = 0.4,
            func = function()
                play_sound("timpani")
                local card = create_card("Joker", G.jokers, legendary, rarity, nil, nil, nil, "snack")
                card:add_to_deck()
                G.jokers:emplace(card)
                card:juice_up(0.3, 0.5)
                return true
            end,
        }))
        G.E_MANAGER:add_event(Event({
            trigger = 'immediate',
            func = function()
            G.E_MANAGER:add_event(Event({
                trigger = 'immediate',
                func = function()
                G.GAME.last_snack = card.config.center_key
                    return true
                end
            }))
                return true
            end
        }))
    end,
}

create_samosa_joker = function(pseed)
    local samosa_keys = {}
    for k, v in pairs(G.P_CENTERS) do
      if v.perishable_compat and v.unlocked and not (v.rarity == 4) and not(not next(find_joker("Showman")) and G.GAME.used_jokers[v.key]) then
        table.insert(samosa_keys, v.key)
      end
    end
    local samosa_key = "j_joker"
    local create_args = {set = "Joker", area = G.jokers, key = ''}
    
    if #samosa_keys > 0 then
      samosa_key = pseudorandom_element(samosa_keys, pseudoseed(G.GAME.pseudorandom.seed))
    end
    return samosa_key
end
  
-- Samosas
SMODS.Consumable{
    key = "samosas",
    set = 'snack',
    loc_txt = {
        name = 'Samosas',
        text = {
        'Create up to {C:attention}#1#',
        '{C:perishable}Perishable{C:attention} Jokers',
        '{C:inactive}Leftover. A little burnt.'
        }
    },
    unlocked = true,
    atlas = 'snacks',
    pos = { x = 6, y = 0 },
    cost = 3,
    effect = "Enhance",
    config = {extra = 2},
    loc_vars = function(self,info_queue,center)
        info_queue[#info_queue + 1] = {key = 'perishable', set = 'Other', vars = {G.GAME.perishable_rounds or 1, G.GAME.perishable_rounds}} 
        return {vars = {center.ability.extra}}
    end,
    set_ability = function(self, card, initial, delay_sprites)
        local scale = 1
        card.children.center.scale.y = (78/95)*card.children.center.scale.y
        card.T.h = card.T.h*(78/95)*scale
    end,
    can_use = function(self, card)
        return G.jokers.config.card_limit - #G.jokers.cards > 0
    end,
    use = function(self, card, area, copier)
        local jokers_to_create = math.min(card.ability.extra, G.jokers.config.card_limit - #G.jokers.cards)
        G.E_MANAGER:add_event(Event({
            func = function() 
                for i = 1, jokers_to_create do
                    local _card = create_card('Joker', G.jokers, nil, 0, nil, nil,
                    create_samosa_joker(), nil)
                    _card:set_perishable(true)
                    _card:add_to_deck()
                    G.jokers:emplace(_card)
                    _card:start_materialize()
                end
            return true
        end}))
        G.E_MANAGER:add_event(Event({
            trigger = 'immediate',
            func = function()
            G.E_MANAGER:add_event(Event({
                trigger = 'immediate',
                func = function()
                G.GAME.last_snack = card.config.center_key
                    return true
                end
            }))
                return true
            end
        }))
    end,
}

-- Palmiers
SMODS.Consumable{
    key = "palmiers",
    set = 'snack',
    loc_txt = {
        name = 'Palmiers',
        text = {
        '{C:attention}+1{} hand size this round for',
        'every #1# {C:attention}Jokers  {C:inactive}(Currently {C:attention}+#2#{C:inactive})',
        "{C:inactive}They're yummy, they're crunchy,",
        "{C:inactive}they get crumbs everywhere."
        }
    },
    unlocked = true,
    atlas = 'snacks',
    pos = { x = 7, y = 0 },
    cost = 3,
    effect = "Enhance",
    config = {extra = 2},
    loc_vars = function(self,info_queue,center)
        return {vars = {center.ability.extra, math.floor(((G.jokers and #G.jokers.cards) or 0)/center.ability.extra)}}
    end,
    set_ability = function(self, card, initial, delay_sprites)
        local scale = 1
        card.children.center.scale.y = (78/95)*card.children.center.scale.y
        card.T.h = card.T.h*(78/95)*scale
    end,
    can_use = function(self, card)
        return #G.jokers.cards >= card.ability.extra and
        (G.GAME.round_resets.blind_states.Small == 'Current' 
        or G.GAME.round_resets.blind_states.Big == 'Current' 
        or G.GAME.round_resets.blind_states.Boss == 'Current')
    end,
    use = function(self, card, area, copier)
        G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
            play_sound('timpani')
            card:juice_up(0.3, 0.5)
            card_eval_status_text(card, 'extra', nil, nil, nil, {colour = G.C.RED, message = localize{type='variable',key='a_handsize',vars={math.floor(#G.jokers.cards/card.ability.extra)}},colour = G.C.FILTER })
            G.hand:change_size(math.floor(#G.jokers.cards/card.ability.extra))
            G.GAME.Palmiers = (G.GAME.Palmiers or 0) + math.floor(#G.jokers.cards/card.ability.extra)
            return true end }))
        G.E_MANAGER:add_event(Event({
			trigger = "after",
			func = function()
				G.STATE = G.STATES.DRAW_TO_HAND
				return true
			end
		}))
        G.E_MANAGER:add_event(Event({
            trigger = 'immediate',
            func = function()
            G.E_MANAGER:add_event(Event({
                trigger = 'immediate',
                func = function()
                G.GAME.last_snack = card.config.center_key
                    return true
                end
            }))
                return true
            end
        }))
    end,
    calculate = function(self,card,context)
        if not context.repetition and not context.individual and context.end_of_round and G.GAME.Palmiers then
            G.hand:change_size(-G.GAME.Palmiers)
            G.GAME.Palmiers = nil
        end
    end    
}

-- Fritters
SMODS.Consumable{
    key = "fritters",
    set = 'snack',
    loc_txt = {
        name = 'Malanga Fritters',
        text = {
        'Gives {C:money}${} equal to',
        "selected Joker's sell",
        'value {C:attention}Multiplied{} by {C:attention}5',
        "{C:inactive}(Max of {C:money}$#1#{C:inactive})",
        "{C:inactive}Frin's drooling."
        }
    },
    unlocked = true,
    atlas = 'snacks',
    pos = { x = 8, y = 0 },
    cost = 3,
    effect = "Enhance",
    config = {extra = 40},
    loc_vars = function(self,info_queue,center)
        info_queue[#info_queue + 1] = {generate_ui = isat_tooltip, key = 'fritters', title = "Favourite!"}
        return {vars = {center.ability.extra}}
    end,
    set_ability = function(self, card, initial, delay_sprites)
        local scale = 1
        card.children.center.scale.y = (78/95)*card.children.center.scale.y
        card.T.h = card.T.h*(78/95)*scale
    end,
    can_use = function(self, card)
		return #G.jokers.highlighted == 1
    end,
    use = function(self, card, area, copier)
        if G.jokers.highlighted[1].ability.name == "j_isat_siffrin" then 
            G.jokers.highlighted[1].ability.xmult1 = G.jokers.highlighted[1].ability.xmult1+0.1
            G.jokers.highlighted[1].ability.xmult2 = G.jokers.highlighted[1].ability.xmult2+0.1
            G.jokers.highlighted[1]:juice_up()
            if G.jokers.highlighted[1].ability.extra.phase > 0 then
                card_eval_status_text(G.jokers.highlighted[1], 'extra', nil, nil, nil, {colour = G.C.RED, message = localize{ type = 'variable', key = 'a_xmult', 
                vars = { (G.jokers.highlighted[1].ability.extra.phase == 2 and G.jokers.highlighted[1].ability.xmult2) or G.jokers.highlighted[1].ability.xmult1 } } })  
            end
        end
        G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
            play_sound('timpani')
            card:juice_up(0.3, 0.5)
            ease_dollars(math.min(G.jokers.highlighted[1].sell_cost*5,card.ability.extra), true)
            return true end }))
        delay(0.6)
        G.E_MANAGER:add_event(Event({
            trigger = 'immediate',
            func = function()
            G.E_MANAGER:add_event(Event({
                trigger = 'immediate',
                func = function()
                G.GAME.last_snack = card.config.center_key
                    return true
                end
            }))
                return true
            end
        }))
    end,
}

-- Eternal Snacks
SMODS.Consumable{
    key = "eternal",
    set = 'snack',
    loc_txt = {
        name = 'Eternal Snacks',
        text = {
            "Creates the last used {C:snack}Snack{} card",
            "{s:0.85,C:snack}Eternal Snacks{s:0.85} excluded",
        },
        unlock = {
            "Clear a run with both",
            "{C:snack}Siffrin{} and {C:snack}Bonnie{} Together"
        }
    },
    unlocked = false,
	unlock_condition = {type = 'win_custom'},
    atlas = 'snacks',
    pos = { x = 9, y = 0 },
    cost = 3,
    effect = "Enhance",
    config = {},
    generate_ui = function(self, info_queue, card, desc_nodes, specific_vars, full_UI_table)
        SMODS.Center.generate_ui(self, info_queue, card, desc_nodes, specific_vars, full_UI_table)
        local eternal_c = G.GAME.last_snack and G.P_CENTERS[G.GAME.last_snack] or nil
        local last_snack = (eternal_c and eternal_c.loc_txt.name) or localize('k_none')
        local colour = (not eternal_c or eternal_c.name == "c_isat_eternal") and G.C.RED or G.C.GREEN
        main_end = {
            {n=G.UIT.C, config={align = "bm", padding = 0.02}, nodes={
                {n=G.UIT.C, config={align = "m", colour = colour, r = 0.05, padding = 0.05}, nodes={
                    {n=G.UIT.T, config={text = ' '..last_snack..' ', colour = G.C.UI.TEXT_LIGHT, scale = 0.3, shadow = true}},
                }}
            }}
        }
        if not (not eternal_c or eternal_c.name == "c_isat_eternal") then
            info_queue[#info_queue+1] = eternal_c
        end
        desc_nodes[#desc_nodes+1] = main_end 
        desc_nodes[#desc_nodes+1] = {
            {n=G.UIT.C, config={align = "bm"}, nodes={
                {n=G.UIT.C, config={align = "m", r = 0.05}, nodes={
                    {n=G.UIT.T, config={text = "Wh-- How did those get there?!", colour = G.C.UI.TEXT_INACTIVE, scale = 0.3, shadow = false}},
                }}
            }}
        }
    end,
    set_ability = function(self, card, initial, delay_sprites)
        local scale = 1
        card.children.center.scale.y = (78/95)*card.children.center.scale.y
        card.T.h = card.T.h*(78/95)*scale
    end,
    can_use = function(self, card)
        if (#G.consumeables.cards < G.consumeables.config.card_limit or card.area == G.consumeables)
		and G.GAME.last_snack and G.P_CENTERS[G.GAME.last_snack].name ~= "c_isat_eternal" then
            return true
        end
    end,
    use = function(self, card, area, copier)
        G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
            if G.consumeables.config.card_limit > #G.consumeables.cards then
                play_sound('timpani')
                local card = create_card('isat_snack', G.consumeables, nil, nil, nil, nil, G.GAME.last_snack, 'snack')
                card:add_to_deck()
                G.consumeables:emplace(card)
                card:juice_up(0.3, 0.5)
            end
            return true end }))
        delay(0.6)
        G.E_MANAGER:add_event(Event({
            trigger = 'immediate',
            func = function()
            G.E_MANAGER:add_event(Event({
                trigger = 'immediate',
                func = function()
                G.GAME.last_snack = card.config.center_key
                    return true
                end
            }))
                return true
            end
        }))
    end
}