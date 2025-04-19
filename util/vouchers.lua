
-- snack break
SMODS.Voucher{
	key = "snack",
    loc_txt = {
        name = 'Snack Break',
        text = {
            '{C:snack}Snack{} cards appear',
            'in the Shop'
        }
    },
    atlas = "Vouchers",
    order = 33,
    set = "Voucher",
	pos = { x = 0, y = 0 },
    config = {},
    unlocked = true,
    available = true,
    cost = 10,
	loc_vars = function(self, info_queue)
		return { vars = {} }
	end,
    redeem = function(self)
        G.E_MANAGER:add_event(Event({
            func = function()
                G.GAME.snack_rate = (G.GAME.snack_rate or 0) + 4
                return true
            end,
        }))
    end,
    unredeem = function(self)
        G.E_MANAGER:add_event(Event({
            func = function()
                G.GAME.snack_rate = (G.GAME.snack_rate or 0) - 4
                return true
            end,
        }))
    end
}

-- leftovers
SMODS.Voucher{
    key = "snack2",
    loc_txt = {
        name = 'Leftovers',
        text = {
            '{C:snack}Snack{} cards appear',
            '{C:attention}2X{} more frequently',
            'in the Shop'
            },
        unlock = {
            "Buy a total of",
            "{C:attention}#1#{C:snack} Snack{} cards",
            "from the shop",
            "{C:inactive}(#2#)"
        }
        },
    atlas = "Vouchers",
    order = 33,
    set = "Voucher",
    pos = { x = 0, y = 1 },
    config = {},
    unlocked = false,
    unlock_condition = {type = 'c_snack_cards_bought', extra = 10},
    available = true,
    requires = {"v_isat_snack"},
    cost = 10,
	locked_loc_vars = function(self, info_queue, card)
		return { vars = {10, G.PROFILES[G.SETTINGS.profile].career_stats.c_snack_cards_bought} }
	end,
    redeem = function(self)
        G.E_MANAGER:add_event(Event({
            func = function()
                G.GAME.snack_rate = (G.GAME.snack_rate or 0)*2
                return true
            end,
        }))
    end,
    unredeem = function(self)
        G.E_MANAGER:add_event(Event({
            func = function()
                G.GAME.snack_rate = (G.GAME.snack_rate or 0)/2
                return true
            end,
        }))
    end
}