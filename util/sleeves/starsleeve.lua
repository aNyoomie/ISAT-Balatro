CardSleeves.Sleeve {
    key = 'star',
    unlocked = false,
    unlock_condition = { deck = "b_isat_stardeck", stake = "stake_white" },
    atlas = 'isat_sleeve',
    pos = {
        x = 0,
        y = 0,
    },
    config = {ante_scaling = 1.5},
    loc_vars = function(self)
        local key
        local vars = {}
        if self.get_current_deck_key() == "b_isat_stardeck" then
            key = self.key .. '_alt'
            self.config = {ante_scaling = self.config.ante_scaling, vouchers = {'v_isat_snack2'}}
            vars = {2}
        else
            key = self.key
            self.config = {ante_scaling = self.config.ante_scaling, vouchers = {'v_isat_snack'}}
            vars = { self.config.ante_scaling }
        end
        return { key = key, vars = vars }
    end,
    apply = function(self)
        if self.get_current_deck_key() == "b_isat_stardeck" then
            G.GAME.used_vouchers.v_isat_snack2 = true
            G.GAME.starting_params.ante_scaling = 2
            G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.8, func = function()
            play_sound('isat_coin',1,0.3)
            local card = nil
            card = create_card('Joker', G.jokers, nil, nil, nil, nil, 'j_isat_loop', 'star')
            card:add_to_deck()
            G.jokers:emplace(card)
            card:start_materialize()
            card:set_edition()
            G.GAME.joker_buffer = 0
            return true end }))
        else
            G.GAME.used_vouchers.v_isat_snack = true
            G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.8, func = function()
            G.GAME.starting_params.ante_scaling = G.GAME.starting_params.ante_scaling*self.config.ante_scaling
            play_sound('isat_coin',1,0.3)
            local card = nil
            card = create_card('Joker', G.jokers, nil, nil, nil, nil, 'j_isat_siffrin', 'star')
            card:add_to_deck()
            G.jokers:emplace(card)
            card:start_materialize()
            card:set_edition()
            G.GAME.joker_buffer = 0
            return true end }))
        end
    end,
}