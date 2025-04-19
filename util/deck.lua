-- star deck
SMODS.Back{
    key = "stardeck",
    loc_txt = {
      name = 'Star Deck',
        text = {
        'Start with {C:snack,T:j_isat_siffrin}Siffrin{}',
        'and {C:snack,T:v_isat_snack}Snack Break{}',
        '{C:red}X1.5{} base Blind size'
      },
    },
    unlocked = true,
    order = '17',
    atlas = 'deck',
    pos = { x = 0, y = 0 },
    config = {ante_scaling = 1.5,vouchers = {'v_isat_snack'}},
    apply = function(self)
      G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.8, func = function()
        play_sound('isat_coin',1,0.3)
        local card = nil
        card = create_card('Joker', G.jokers, nil, nil, nil, nil, 'j_isat_siffrin', 'star')
        card:add_to_deck()
        G.jokers:emplace(card)
        card:start_materialize()
        card:set_edition()
        G.GAME.joker_buffer = 0
        return true end }))
    end,
  }
  