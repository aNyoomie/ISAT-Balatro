return {
	["descriptions"] = {
		["ISAT"] = {
			['timeloop'] = {
				["text"] = {
					"{E:1,C:inactive}[You're stuck in a time loop!]",
					'Once per ante when hitting {C:red}Game Over',
					'return to the beginning of the ante!',
					'{C:inactive}[Currently {C:red}#1#{C:inactive}]'
				},
			},
			['onigiri'] = {
				["text"] = {
					"{C:inactive}(So Bonnie likes",
					"{C:inactive}rice, huh...)",
					'If used when {C:snack}Bonnie{}',
					'is owned, they will make {C:attention}2',
					'{C:snack}Snack{} cards instead of {C:attention}1'
				},
			},
			['onigiri2'] = {
				["text"] = {
					"{C:inactive}Hmf.",
					'Will make {C:attention}2 {C:snack}Snack{}',
					'cards instead of {C:attention}1'
				},
			},
			['pineapple'] = {
				["text"] = {
					"{E:1,C:inactive}Don't eat pineapples!",
					"{E:1,C:inactive}You're allergic.",
					'If used on {C:snack}Siffrin{}, they',
					'will {C:green}always{} be {C:attention}destroyed{}.'
				},
			},
			['fritters'] = {
				["text"] = {
					"{C:inactive}Hmfyurghm.",
					'If used on {C:snack}Siffrin{}, their',
					'{X:mult,C:white}xMult{} will gain {X:mult,C:white}X0.1{}'
				},
			},
        },
		Sleeve = {
			sleeve_isat_star = {
				name = 'Star Sleeve',
				  text = {
					'Start with {C:snack,T:j_isat_siffrin}Siffrin{}',
					'and {C:snack,T:v_isat_snack}Snack Break{}',
      				'{C:red}X#1#{} base Blind size'
				},
			  },
			sleeve_isat_star_alt = {
				name = 'Star Sleeve',
				  text = {
					'Start with {C:snack,T:j_isat_loop}Loop{}',
					'and {C:snack,T:v_isat_snack2}Leftovers{}',
      				'{C:red}X#1#{} base Blind size'
				},
			  }, 
		},
	  }}