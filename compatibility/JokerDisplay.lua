if SMODS.Mods["JokerDisplay"] and SMODS.Mods["JokerDisplay"].can_load then
	if JokerDisplay then
		local jd_def = JokerDisplay.Definitions
		jd_def["j_isat_siffrin"] = {
			text = {
					{text = "+"},
					{ref_table = "card.ability", ref_value = "mult", retrigger_type = "mult"}
			},
        	text_config = { colour = G.C.RED },
			extra = {
				{
					{
						border_nodes = {
							{ text = "X" },
							{ ref_table = "card.joker_display_values", ref_value = "xmult", retrigger_type = "exp" }
						}
					}
				}
			},
			reminder_text = {
				{ text = "(" },
				{ ref_table = "card.joker_display_values", ref_value = "active" },
				{ text = ")" },
			},
			calc_function = function(card)
				card.joker_display_values.xmult = (card.ability.extra.phase == 1 or card.ability.extra.phase == 3) and card.ability.xmult1 
                or card.ability.extra.phase == 2 and card.ability.xmult2 or 1

            	card.joker_display_values.active = G.GAME and card.ability.extra.loop and
                localize("jdis_active") or localize("jdis_inactive")
        	end,
		}
		jd_def["j_isat_isa"] = {
			text = {{
					border_nodes = {
						{ text = "X" },
						{ ref_table = "card.joker_display_values", ref_value = "xmult", retrigger_type = "exp" }
					}}
			},
			calc_function = function(card)
				local count = 0
				local text, _, scoring_hand = JokerDisplay.evaluate_hand(G.hand.highlighted)
				if text ~= 'Unknown' then
					for _, scoring_card in pairs(scoring_hand) do
						if scoring_card:get_id() and scoring_card:get_id() == 13 then
							count = count +
								JokerDisplay.calculate_card_triggers(scoring_card, scoring_hand)
						end
					end
				end
				card.joker_display_values.xmult = card.ability.Xmult + (card.ability.Xmult_bonus*count)
			end,
		}
		-- floor 1
		jd_def["j_isat_tristesse"] = {
			text = {
				{ text = "+",                       colour = G.C.CHIPS },
				{ ref_table = "card.joker_display_values", ref_value = "chips", colour = G.C.CHIPS, retrigger_type = "mult" },
			},
			text_config = { colour = G.C.CHIPS },
			reminder_text = {
				{ text = "(" },
				{
					ref_table = "card.joker_display_values",
					ref_value = "localized_text",
				},
				{ text = ")", colour = G.C.UI.TEXT_INACTIVE },
			},
			calc_function = function(card)
				local count = 0
				local text, _, scoring_hand = JokerDisplay.evaluate_hand(G.hand.highlighted)
				if text ~= 'Unknown' then
					for _, scoring_card in pairs(scoring_hand) do
						if scoring_card:is_suit(card.ability.extra.suit) and scoring_card:is_suit(card.ability.extra.suit) then
							count = count +
								JokerDisplay.calculate_card_triggers(scoring_card, scoring_hand)
						end
					end
				end
				card.joker_display_values.chips = card.ability.chips + (card.ability.extra.s_chips*count)
            	card.joker_display_values.localized_text = localize(card.ability.extra.suit, 'suits_plural')
			end,
			style_function = function(card, text, reminder_text, extra)
				if reminder_text and reminder_text.children[2] then
					reminder_text.children[2].config.colour = lighten(G.C.SUITS[card.ability.extra.suit], 0.35)
				end
				return false
			end
		}
		jd_def["j_isat_chagrin"] = {
			text = {
					{text = "+", colour = G.C.RED},
					{ref_table = "card.ability", ref_value = "mult", retrigger_type = "mult", colour = G.C.RED}
			},
			extra = {
				{
						{text = "+", colour = G.C.CHIPS},
						{ref_table = "card.ability", ref_value = "chips", retrigger_type = "mult", colour = G.C.CHIPS}
					}
			},
			reminder_text = {
				{
					border_nodes = {
						{ text = "X" , colour = G.C.WHITE},
						{ ref_table = "card.ability", ref_value = "Xmult", retrigger_type = "exp" , colour = G.C.WHITE}
					}
				}
			},
			reminder_text_config = {scale = 0.4}
		}
		jd_def["j_isat_tutorial"] = {
			text = {
					{ ref_table = "card.joker_display_values", ref_value = "slot3", colour = G.C.IMPORTANT, retrigger_type = "mult" },
					{text = "+", colour = G.C.RED},
					{ref_table = "card.ability", ref_value = "mult", retrigger_type = "mult", colour = G.C.RED}
			},
			extra = {
				{
					{ ref_table = "card.joker_display_values", ref_value = "slot2", colour = G.C.IMPORTANT, retrigger_type = "mult" },
					{text = "+", colour = G.C.CHIPS},
					{ref_table = "card.ability", ref_value = "chips", retrigger_type = "mult", colour = G.C.CHIPS}
				},
				{
					{ ref_table = "card.joker_display_values", ref_value = "slot1", colour = G.C.IMPORTANT, retrigger_type = "mult" },
					{border_nodes = {
						{ text = "X"},
						{ ref_table = "card.ability", ref_value = "Xmult", retrigger_type = "exp"}
					}},
				}
			},
			calc_function = function(card)
				card.joker_display_values.slot1 = (card.ability.extra == 1 and "> ") or " "
				card.joker_display_values.slot2 = (card.ability.extra == 2 and "> ") or " "
				card.joker_display_values.slot3 = (card.ability.extra == 3 and "> ") or " "
        	end,
		}
		jd_def["j_isat_amertume"] = {
			text = {
					{text = "-", colour = lighten(G.C.BLACK,0.35)},
					{ref_table = "card.ability.extra", ref_value = "submult", retrigger_type = "mult", colour = lighten(G.C.BLACK,0.35)}
			},
			extra = {
				{
						{text = "+", colour = G.C.CHIPS},
						{ref_table = "card.ability", ref_value = "chips", retrigger_type = "mult", colour = G.C.CHIPS}
					}
			},
		}
		jd_def["j_isat_calamite"] = {
			text = {{
					border_nodes = {
						{ text = "X" },
						{ ref_table = "card.joker_display_values", ref_value = "xmult", retrigger_type = "exp" }
					}}
			},
			reminder_text = {
				{ text = "(" },
				{
					ref_table = "card.joker_display_values",
					ref_value = "localized_text",
				},
				{ text = ")", colour = G.C.UI.TEXT_INACTIVE },
			},
			calc_function = function(card)
				local hassuit = false
				local text, _, scoring_hand = JokerDisplay.evaluate_hand()
				if text ~= 'Unknown' then
					for _, scoring_card in pairs(scoring_hand) do
						if scoring_card:is_suit(G.GAME.current_round.calamite_card.suit) then
							hassuit = true
						end
					end
				end
				card.joker_display_values.xmult = hassuit and card.ability.extra.Xmult or 1
            	card.joker_display_values.localized_text = localize(G.GAME.current_round.calamite_card.suit, 'suits_singular')
			end,
			style_function = function(card, text, reminder_text, extra)
				if reminder_text and reminder_text.children[2] then
					reminder_text.children[2].config.colour = lighten(G.C.SUITS[G.GAME.current_round.calamite_card.suit], 0.35)
				end
				return false
			end
		}
		-- floor 2
		jd_def["j_isat_detresse"] = {
			text = {
				{ text = "+",                       colour = G.C.RED },
				{ ref_table = "card.joker_display_values", ref_value = "mult", colour = G.C.RED, retrigger_type = "mult" },
			},
			text_config = { colour = G.C.RED },
			reminder_text = {
				{ text = "(" },
				{
					ref_table = "card.joker_display_values",
					ref_value = "localized_text",
				},
				{ text = ")", colour = G.C.UI.TEXT_INACTIVE },
			},
			calc_function = function(card)
				local count = 0
				local text, _, scoring_hand = JokerDisplay.evaluate_hand(G.hand.highlighted)
				if text ~= 'Unknown' then
					for _, scoring_card in pairs(scoring_hand) do
						if scoring_card:is_suit(card.ability.extra.suit) and scoring_card:is_suit(card.ability.extra.suit) then
							count = count +
								JokerDisplay.calculate_card_triggers(scoring_card, scoring_hand)
						end
					end
				end
				card.joker_display_values.mult = card.ability.mult + (card.ability.extra.s_mult*count)
            	card.joker_display_values.localized_text = localize(card.ability.extra.suit, 'suits_plural')
			end,
			style_function = function(card, text, reminder_text, extra)
				if reminder_text and reminder_text.children[2] then
					reminder_text.children[2].config.colour = lighten(G.C.SUITS[card.ability.extra.suit], 0.35)
				end
				return false
			end
		}
		jd_def["j_isat_nostalgie"] = {
			text = {
				{ text = "+" },
				{ ref_table = "card.joker_display_values", ref_value = "count", retrigger_type = "mult" },
			},
			text_config = { colour = G.C.SECONDARY_SET.Planet },
			extra = {
				{
					{ text = "(" },
					{ ref_table = "card.joker_display_values", ref_value = "odds" },
					{ text = ")" },
				}
			},
			extra_config = { colour = G.C.GREEN, scale = 0.3 },
			calc_function = function(card)
				local count = 0
				local text, _, scoring_hand = JokerDisplay.evaluate_hand()
				if text ~= 'Unknown' then
					for _, scoring_card in pairs(scoring_hand) do
						if scoring_card:is_suit('Spades') and scoring_card:is_suit('Spades') then
							count = count +
								JokerDisplay.calculate_card_triggers(scoring_card, scoring_hand)
						end
					end
				end
				card.joker_display_values.count = count
				local numerator, denominator = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, 'space')
				card.joker_display_values.odds = localize { type = 'variable', key = "jdis_odds", vars = { numerator, denominator } }
			end
		}
		jd_def["j_isat_anxiete"] = {
			text = {
				{ text = "+",colour = G.C.RED },
				{ ref_table = "card.joker_display_values", ref_value = "mult", retrigger_type = "mult",colour = G.C.RED }
			},
			reminder_text = {
				{ text = "(" },
				{ ref_table = "card.joker_display_values", ref_value = "active" },
				{ text = ")" },
			},
			calc_function = function(card)
				card.joker_display_values.active = card.ability.extra.remaining > 0 and ""..card.ability.extra.remaining.." remaining" or "Active!"
				card.joker_display_values.mult = card.ability.extra.remaining > 0 and 0 or card.ability.extra.mult
			end
		}
		jd_def["j_isat_accablement"] = {
			text = {
					{
						border_nodes = {
							{ text = "X" },
							{ ref_table = "card.ability", ref_value = "Xmult", retrigger_type = "exp" }
						}
				}
			},
		}
		-- floor 3
		jd_def["j_isat_misere"] = {
			text = {
					{
						border_nodes = {
							{ text = "X" },
							{ ref_table = "card.joker_display_values", ref_value = "Xmult", retrigger_type = "exp" }
						}
				}
			},
			reminder_text = {
				{ text = "(" },
				{
					ref_table = "card.joker_display_values",
					ref_value = "localized_text",
				},
				{ text = ")", colour = G.C.UI.TEXT_INACTIVE },
			},
			calc_function = function(card)
				local count = 0
				local text, _, scoring_hand = JokerDisplay.evaluate_hand(G.hand.highlighted)
				if text ~= 'Unknown' then
					for _, scoring_card in pairs(scoring_hand) do
						if scoring_card:is_suit(card.ability.extra.suit) and scoring_card:is_suit(card.ability.extra.suit) then
							count = count +
								JokerDisplay.calculate_card_triggers(scoring_card, scoring_hand)
						end
					end
				end
				card.joker_display_values.Xmult = card.ability.xmult + (card.ability.extra.s_xmult*count)
            	card.joker_display_values.localized_text = localize(card.ability.extra.suit, 'suits_plural')
			end,
			style_function = function(card, text, reminder_text, extra)
				if reminder_text and reminder_text.children[2] then
					reminder_text.children[2].config.colour = lighten(G.C.SUITS[card.ability.extra.suit], 0.35)
				end
				return false
			end
		}
		jd_def["j_isat_tears"] = {
			text = {
					{ text = "+" },
					{ ref_table = "card.joker_display_values", ref_value = "mult", retrigger_type = "exp" }
			},
        	text_config = { colour = G.C.MULT },
			calc_function=function(card)
				local debuffed_cards = 0
				if G.deck then for k, v in pairs(G.playing_cards) do if v.debuff then debuffed_cards = debuffed_cards + 1 end end end
				card.joker_display_values.mult = debuffed_cards*card.ability.extra.mult_bonus
			end
		}
		jd_def["j_isat_desespoir"] = {
			reminder_text = {
				{ text = "x"},
				{ ref_table = "card.joker_display_values", ref_value = "count", retrigger_type = "mult" },
			},
			extra = {{
				{ text = "$1",                             colour = G.C.GOLD },
				{ text = "/" },
				{ text = "10",                             colour = G.C.CHIPS }
			}},
			calc_function = function(card)
				local count = 0
				local text, _, scoring_hand = JokerDisplay.evaluate_hand()
				if text ~= 'Unknown' then
					for _, scoring_card in pairs(scoring_hand) do
						count = count + JokerDisplay.calculate_card_triggers(scoring_card, scoring_hand)
					end
				end
				card.joker_display_values.count = count
			end,
		}
		jd_def["j_isat_bourdon"] = {
			text = {
				{ text = "+",                       colour = G.C.CHIPS },
				{ ref_table = "card.joker_display_values", ref_value = "chips", colour = G.C.CHIPS, retrigger_type = "mult" },
			},
			reminder_text = {
				{ text = "(" },
				{ text= "3 Suits", colour = G.C.ORANGE },
				{ text = ")" }
			},
			calc_function = function(card)
				local text, _, scoring_hand = JokerDisplay.evaluate_hand()
				local suits = {
					['Hearts'] = 0,
					['Diamonds'] = 0,
					['Spades'] = 0,
					['Clubs'] = 0
				}
				if text ~= 'Unknown' then
					for i = 1, #scoring_hand do
						if scoring_hand[i].ability.name ~= 'Wild Card' then
							if scoring_hand[i]:is_suit('Hearts', true) and suits["Hearts"] == 0 then
								suits["Hearts"] = suits["Hearts"] + 1
							elseif scoring_hand[i]:is_suit('Diamonds', true) and suits["Diamonds"] == 0 then
								suits["Diamonds"] = suits["Diamonds"] + 1
							elseif scoring_hand[i]:is_suit('Spades', true) and suits["Spades"] == 0 then
								suits["Spades"] = suits["Spades"] + 1
							elseif scoring_hand[i]:is_suit('Clubs', true) and suits["Clubs"] == 0 then
								suits["Clubs"] = suits["Clubs"] + 1
							end
						end
					end
					for i = 1, #scoring_hand do
						if scoring_hand[i].ability.name == 'Wild Card' then
							if scoring_hand[i]:is_suit('Hearts') and suits["Hearts"] == 0 then
								suits["Hearts"] = suits["Hearts"] + 1
							elseif scoring_hand[i]:is_suit('Diamonds') and suits["Diamonds"] == 0 then
								suits["Diamonds"] = suits["Diamonds"] + 1
							elseif scoring_hand[i]:is_suit('Spades') and suits["Spades"] == 0 then
								suits["Spades"] = suits["Spades"] + 1
							elseif scoring_hand[i]:is_suit('Clubs') and suits["Clubs"] == 0 then
								suits["Clubs"] = suits["Clubs"] + 1
							end
						end
					end
				end
				local is_boudon_hand = ((suits["Hearts"] + suits["Diamonds"] + suits["Spades"] + suits["Clubs"]) >= 3 )
				card.joker_display_values.chips = is_boudon_hand and card.ability.extra.chips or 0
			end
		}
		-- npc
		jd_def["j_isat_loop"] = {
			text = {
					{
						border_nodes = {
							{ text = "X" },
							{ ref_table = "card.ability", ref_value = "xmult", retrigger_type = "exp" }
						}
				}
			},
		}
		jd_def["j_isat_housemaiden"] = {
			text = {
				{ text = "+$" },
				{ ref_table = "card.ability", ref_value = "extra" },
			},
			text_config = { colour = G.C.GOLD },
			reminder_text = {
				{ text = "(Boss Blind)" },
			},
		}
		jd_def["j_isat_king"] = {
			text = {
				{
					border_nodes = {
						{ text = "X" },
						{ ref_table = "card.joker_display_values", ref_value = "x_mult", retrigger_type = "exp" }
					}
				}
			},
			calc_function = function(card)
				local playing_hand = next(G.play.cards)
				local count = 0
				for _, playing_card in ipairs(G.hand.cards) do
					if playing_hand or not playing_card.highlighted then
						count = count + JokerDisplay.calculate_card_triggers(playing_card, nil, true)
					end
				end
				card.joker_display_values.x_mult = card.ability.extra ^ count
			end
		}
		jd_def["j_isat_mal"] = {
			reminder_text = {
				{ text = "(" },
				{ ref_table = "card.joker_display_values", ref_value = "active" },
				{ text = ")" },
			},
			calc_function = function(card)
				card.joker_display_values.active = card.ability.extra.counter >= card.ability.extra.rounds and
					localize("k_active") or
					(card.ability.extra.counter .. "/" .. card.ability.extra.rounds)
			end
		}
	end
end
