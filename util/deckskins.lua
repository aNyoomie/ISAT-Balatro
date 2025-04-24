SMODS.Atlas{  
  key = 'isat_rps_lc',
  px = 71,
  py = 95,
  path = 'cardCustomColor_lc.png',
  prefix_config = {key = false}
}

SMODS.Atlas{  
  key = 'isat_rps_hc',
  px = 71,
  py = 95,
  path = 'cardCustomColor_hc.png',
  prefix_config = {key = false}
}

SMODS.Atlas{  
  key = 'isat_rps_mono',
  px = 71,
  py = 95,
  path = 'cardCustomNoColor.png',
  prefix_config = {key = false}
}

SMODS.Atlas{  
  key = 'icon_rps_lc',
  px = 18,
  py = 18,
  path = 'customIconColor_lc.png',
  prefix_config = {key = false}
}

SMODS.Atlas{  
  key = 'icon_rps_hc',
  px = 18,
  py = 18,
  path = 'customIconColor_hc.png',
  prefix_config = {key = false}
}

SMODS.Atlas{  
  key = 'icon_rps_mono',
  px = 18,
  py = 18,
  path = 'customIconNoColor.png',
  prefix_config = {key = false}
}

local suits = {'hearts', 'diamonds', 'clubs'} -- Which suits to replace
local colours = {HEX('717171'),HEX('ADADAD'),HEX('484848')}
for i, suit in ipairs(suits) do
  SMODS.DeckSkin {
    key = "rps_"..suit,
    suit = suit:gsub("^%l", string.upper),
    loc_txt = "RPS",
    palettes = {
      {
        key = 'lc',
        ranks = {'2', '3', '4', '5', '6', '7', '8', '9', '10', 'Jack', 'Queen', "King", "Ace",},
        display_ranks = {"Ace", "King", "Queen", "Jack", "10"},
        atlas = 'isat_rps_lc',
        pos_style = 'deck',
        suit_icon = {
          atlas = 'icon_rps_lc',
          pos = {x = i-1, y = 0},
        },
      },
      {
        key = 'hc',
        ranks = {'2', '3', '4', '5', '6', '7', '8', '9', '10', 'Jack', 'Queen', "King", "Ace",},
        display_ranks = {"Ace", "King", "Queen", "Jack", "10"},
        atlas = 'isat_rps_hc',
        pos_style = 'deck',
        suit_icon = {
          atlas = 'icon_rps_hc',
          pos = {x = i-1, y = 0},
        },
      },
      {
        key = 'mono',
        ranks = {'2', '3', '4', '5', '6', '7', '8', '9', '10', 'Jack', 'Queen', "King", "Ace",},
        display_ranks = {"Ace", "King", "Queen", "Jack", "10"},
        atlas = 'isat_rps_mono',
        pos_style = 'deck',
        colour = colours[i],
        suit_icon = {
          atlas = 'icon_rps_mono',
          pos = {x = i-1, y = 0},
        },
        loc_txt = 'Monochrome'
      },
    },
  }
end

SMODS.DeckSkin {
	key = "rps_spades",
	suit = "Spades",
	loc_txt = "Stars",
	palettes = {
		{
			key = 'lc',
			ranks = {'2', '3', '4', '5', '6', '7', '8', '9', '10', 'Jack', 'Queen', "King", "Ace",},
			display_ranks = {"Ace", "King", "Queen", "Jack", "10"},
			atlas = 'isat_rps_mono',
			pos_style = 'deck',
      colour = HEX('717171'),
			suit_icon = {
				atlas = 'icon_rps_mono',
        pos = {x = 3, y = 0},
			},
      loc_txt = 'Monochrome'
		},
	},
}