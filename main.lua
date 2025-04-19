--- STEAMODDED HEADER
--- MOD_NAME: In Stars and Time
--- MOD_ID: ISAT
--- MOD_AUTHOR: [aNyoomie]
--- MOD_DESCRIPTION: ----- In Stars and Time themed Content Mod!! ----- In Stars and Time created by Insertdisc5, Music by Studio Thumpy Puppy, Art assets primarily lifted from ISAT's assets. Features spoiler content from ISAT, as late as ACT 6. You are warned. Play In Stars and Time.
--- PREFIX: isat
--- BADGE_COLOUR: 3A3A3A
--- PRIORITY: 0
--- VERSION: 1.0.1

----------------------------------------------
------------MOD CODE -------------------------

ISAT = SMODS.current_mod

-- loads jokers
assert(SMODS.load_file('util/jokers/family.lua'))()
assert(SMODS.load_file('util/jokers/loop.lua'))()
assert(SMODS.load_file('util/jokers/npcs.lua'))()
assert(SMODS.load_file('util/consumables.lua'))()
assert(SMODS.load_file('util/deck.lua'))()
assert(SMODS.load_file('util/vouchers.lua'))()

SMODS.Atlas { -- modicon
  key = 'modicon',
  path = 'isaticon.png',
  px = 32,
  py = 32
}

SMODS.Atlas{
  key = 'Jokers',
  path = 'Jokers.png',
  px = 71,
  py = 95
}

SMODS.Atlas{
  key = 'snacks',
  path = 'items.png',
  px = 71,
  py = 95
}

SMODS.Atlas{
  key = 'deck',
  path = 'deck.png',
  px = 71,
  py = 95
}

SMODS.Atlas{
  key = 'isat_sleeve',
  path = "sleeve.png",
	px = 73,
	py = 95
}

SMODS.Atlas{
  key = 'Vouchers',
  path = 'voucher.png',
  px = 71,
  py = 95
  }

SMODS.Atlas{
  key = 'isat_blind',
  path = 'blind.png',
  atlas_table = 'ANIMATION_ATLAS',
  frames = 21,
  px = 34,
  py = 34
}

if SMODS.Sound then
  SMODS.Sound({
    key = "divmult",
    path = "divmult.wav"
  })
  SMODS.Sound({
    key = "submult",
    path = "submult.wav"
  })
  SMODS.Sound({
    key = "shift",
    path = "casette_stop.ogg"
  })
  SMODS.Sound({
    key = "loop",
    path = "CASSETTE_SLOW DOWN SPEED UP_02.ogg"
  })
  SMODS.Sound({
    key = "coin",
    path = "coin.ogg"
  })
  SMODS.Sound({
    key = "music_loop",
    path = "battle_LOOP.ogg",
    sync = false,
    pitch = 1,
    volume = 0.25,
    select_music_track = function()
      return next(find_joker("j_isat_loop_boss"))
    end,
  })
end

SMODS.Rarity{
  key = 'starlight',
  loc_txt = {
    name = 'Starlight'
  },
  badge_colour = HEX('7f7f7f'),
  default_weight = 0
}

-- divide/sub mult
if SMODS and SMODS.calculate_individual_effect then
  local scie = SMODS.calculate_individual_effect
  function SMODS.calculate_individual_effect(effect, scored_card, key, amount, from_edition)
    local ret = scie(effect, scored_card, key, amount, from_edition)
    if ret then
      return ret
    end
    if (key == 'div_mult' or key == 'divmult' or key == 'divmult_mod') and amount ~= 1 then 
      if effect.card then juice_card(effect.card) end
      mult = mod_mult(mult * (1/amount))
      update_hand_text({delay = 0}, {chips = hand_chips, mult = mult})
      if not effect.remove_default_message then
          if from_edition then
              card_eval_status_text(scored_card, 'jokers', nil, percent, nil, {message = "÷"..amount.." Mult", colour =  G.C.EDITION, edition = true})
          elseif key ~= 'divmult_mod' then
              if effect.divmult_message then
                  card_eval_status_text(scored_card or effect.card or effect.focus, 'extra', nil, percent, nil, {message = "÷"..amount.." Mult", colour =  G.C.L_BLACK, edition = false})
              else
                  card_eval_status_text(scored_card or effect.card or effect.focus, 'divmult', amount, percent, nil, {message = "÷"..amount.." Mult", colour =  G.C.L_BLACK, edition = false})
              end
          end
      end
      return true
    end

    if (key == 'submult' or key == 'esub_ult' or key == 'submult_mod') and amount ~= 1 then 
      if effect.card then juice_card(effect.card) end
      mult = mod_mult(mult-amount)
      update_hand_text({delay = 0}, {chips = hand_chips, mult = mult})
      if not effect.remove_default_message then
          if from_edition then
              card_eval_status_text(scored_card, 'jokers', nil, percent, nil, {message = "-"..amount.." Mult", colour =  G.C.BLACK, edition = true})
          elseif key ~= 'submult_mod' then
              if effect.submult_message then
                  card_eval_status_text(scored_card or effect.card or effect.focus, 'extra', nil, percent, nil, {message = "-" ..amount.." Mult", colour =  G.C.BLACK, edition = false})
              else
                  card_eval_status_text(scored_card or effect.card or effect.focus, 'submult', amount, percent, nil, {message = "-" ..amount.." Mult", colour =  G.C.BLACK, edition = false})
              end
          end
      end
      return true
    end
  end
  for _, v in ipairs({'divmult', 'submult',
                      'div_mult', 'sub_mult',
                      'divmult_mod', 'submult_mod'}) do
    table.insert(SMODS.calculation_keys, v)
  end
end

function isat_tooltip(_c, info_queue, card, desc_nodes, specific_vars, full_UI_table)
  localize{type = 'descriptions', set = 'ISAT', key = _c.key, nodes = desc_nodes, vars = _c.vars or specific_vars or nil}
  desc_nodes['colour'] = G.C.WHITE
  desc_nodes.isat = true
  desc_nodes.title = _c.title or localize('isat')
end
local itfr = info_tip_from_rows
function info_tip_from_rows(desc_nodes, name)
    if desc_nodes.isat then
        local t = {}
        for k, v in ipairs(desc_nodes) do
        t[#t+1] = {n=G.UIT.R, config={align = "cm"}, nodes=v}
        end
        return {n=G.UIT.R, config={align = "cm", colour = lighten(HEX('607174'), 0.15) , r = 0.1}, nodes={
            {n=G.UIT.R, config={align = "tm", minh = 0.36, padding = 0.03}, nodes={{n=G.UIT.T, config={text = desc_nodes.title, scale = 0.32, colour = G.C.UI.TEXT_LIGHT}}}},
            {n=G.UIT.R, config={align = "cm", minw = 1.5, minh = 0.4, r = 0.1, padding = 0.05, colour = lighten(desc_nodes.colour, 0.5)}, nodes={{n=G.UIT.R, config={align = "cm", padding = 0.03}, nodes=t}}}
        }}
    else
        return itfr(desc_nodes, name)
    end
end

-- Sleeves Patch
if (SMODS.Mods['CardSleeves'] or {}).can_load then
  NFS.load(ISAT.path .. 'util/sleeves/starsleeve.lua')()
end
----------------------------------------------
------------MOD CODE END----------------------