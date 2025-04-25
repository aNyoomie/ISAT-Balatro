--- STEAMODDED HEADER
--- MOD_NAME: In Stars and Time
--- MOD_ID: ISAT
--- MOD_AUTHOR: [aNyoomie]
--- MOD_DESCRIPTION: ----- In Stars and Time themed Content Mod!! ----- In Stars and Time created by Insertdisc5, Music by Studio Thumpy Puppy, Art assets primarily lifted from ISAT's assets. Features spoiler content from ISAT, as late as ACT 6. You are warned. Play In Stars and Time. Also, Pixel Art Smoothing is reccomended to be ON!
--- PREFIX: isat
--- BADGE_COLOUR: 3A3A3A
--- PRIORITY: 1
--- VERSION: 1.1.1

----------------------------------------------
------------MOD CODE -------------------------

ISAT = SMODS.current_mod
isat_dir = ''..SMODS.current_mod.path
isat_config = SMODS.current_mod.config

assert(SMODS.load_file('config_ui.lua'))()

-- loads objects
assert(SMODS.load_file('util/jokers/family.lua'))()
assert(SMODS.load_file('util/jokers/floor1.lua'))()
assert(SMODS.load_file('util/jokers/floor2.lua'))()
assert(SMODS.load_file('util/jokers/floor3.lua'))()
assert(SMODS.load_file('util/jokers/loop.lua'))()
assert(SMODS.load_file('util/jokers/npcs.lua'))()
assert(SMODS.load_file('util/consumables.lua'))()
assert(SMODS.load_file('util/deck.lua'))()
assert(SMODS.load_file('util/vouchers.lua'))()
assert(SMODS.load_file('util/deckskins.lua'))()
assert(SMODS.load_file('util/notifications.lua'))()

SMODS.Language {
  key = 'suitnames_en',
  label = 'ISAT EN',
  loc_key = 'en-us'
}

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
      mult = mod_mult(math.max(mult-amount,1))
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

--Changes main menu colors and stuff
if isat_config.menu then
  SMODS.Atlas {
    key = "splash",
    path = "splash.png",
    px = 333,
    py = 216,
    atlas_table = "ASSET_ATLAS"
  }
  local oldfunc = Game.main_menu
  Game.main_menu = function(change_context)
    local ret = oldfunc(change_context)
    -- adds frin to the main menu
    local newcard = Card(
      G.title_top.T.x,
      G.title_top.T.y,
      G.CARD_W,
      G.CARD_H,
      G.P_CARDS.empty,
      G.P_CENTERS.j_isat_siffrin,
      { bypass_discovery_center = true }
    )
    -- recenter the title
    G.title_top.T.w = G.title_top.T.w * 1.7675
    G.title_top.T.x = G.title_top.T.x - 0.8
    G.title_top:emplace(newcard)
    -- make the card look the same way as the title screen Ace of Spades
    newcard.T.w = newcard.T.w * 1.1 * 1.2
    newcard.T.h = newcard.T.h * 1.1 * 1.2
    newcard.no_ui = true
    newcard.states.visible = true

    -- make the title screen use different background colors
    G.SPLASH_BACK:define_draw_steps({
      {
        shader = "splash",
        send = {
          { name = "time", ref_table = G.TIMERS, ref_value = "REAL_SHADER" },
          { name = "vort_speed", val = 0.4 },
          { name = "colour_1", ref_table = G.C, ref_value = "MONOBLUE" },
          { name = "colour_2", ref_table = G.C, ref_value = "MONORED" },
        },
      },
    })

    G.E_MANAGER:add_event(Event({
      trigger = "after",
      delay = 0,
      blockable = false,
      blocking = false,
      func = function()
        if change_context == "splash" then
          newcard.states.visible = true
          newcard:start_materialize({ G.C.WHITE, G.C.WHITE }, true, 2.5)
        else
          newcard.states.visible = true
          newcard:start_materialize({ G.C.WHITE, G.C.WHITE }, nil, 1.2)
        end
        ISAT.notification_overlay("start")
        return true
      end,
    }))
    return ret
  end
else
  SMODS.Atlas {
    key = "splash",
    path = "balatro.png",
    px = 333,
    py = 216,
    atlas_table = "ASSET_ATLAS"
  }
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
