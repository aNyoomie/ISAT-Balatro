if not G.SETTINGS.isat_notifs then G.SETTINGS.isat_notifs = {} end

-- sets suit and language by default
if not G.SETTINGS.isat_notifs["start"] then
	G.SETTINGS.language = 'suitnames_en'
	G.SETTINGS.CUSTOM_DECK = {
		Collabs = {
			Spades = 'isat_rps_spades',
			Hearts = 'isat_rps_hearts',
			Clubs = 'isat_rps_clubs',
			Diamonds = 'isat_rps_diamonds',
		}
	},
	G:set_language()
	G.E_MANAGER:clear_queue()
end

function ISAT.notification_overlay(key)
	if not G.SETTINGS.isat_notifs[key] then
		G.E_MANAGER:add_event(
			Event({
				trigger = "immediate",
				no_delete = true,
				func = function()
					if not G.OVERLAY_MENU then
						G.SETTINGS.paused = true
						G.FUNCS.overlay_menu({
							definition = create_UIBox_isat_notif(key),
						})
						play_sound("foil1", 0.7, 0.3)
						play_sound("gong", 1.4, 0.15)
						G.SETTINGS.isat_notifs[key] = true
						G:save_settings()
						return true
					end
				end,
			}),
			"unlock"
		)
	end
end

function create_UIBox_isat_notif(key)
	local t = create_UIBox_generic_options({
		padding = 0,
		back_label = "Ok",
		no_pip = true,
		snap_back = true,
		back_func = "continue_unlock",
		minw = 4.5,
		contents = {
			{
				n = G.UIT.R,
				config = { align = "cm", padding = 0 },
				nodes = {
					{
						n = G.UIT.R,
						config = { align = "cm", padding = 0.1 },
						nodes = {
							{
								n = G.UIT.R,
								config = { align = "cm", padding = 0.1 },
								nodes = {
									-- {
									-- 	n = G.UIT.R,
									-- 	config = { align = "cm", padding = 0 },
									-- 	nodes = {
									-- 		{
									-- 			n = G.UIT.O,
									-- 			config = {
									-- 				object = DynaText({
									-- 					string = { "Testy" },
									-- 					colours = { G.C.BLUE },
									-- 					shadow = true,
									-- 					rotate = true,
									-- 					bump = true,
									-- 					pop_in = 0.3,
									-- 					pop_in_rate = 2,
									-- 					scale = 1.2,
									-- 				}),
									-- 			},
									-- 		},
									-- 	},
									-- },
									{
										n = G.UIT.R,
										config = { align = "cm", padding = 0 },
										nodes = {
											{
												n = G.UIT.O,
												config = {
													object = DynaText({
														string = { "Heads up!" },
														colours = { G.C.RED },
														shadow = true,
														rotate = true,
														bump = true,
														pop_in = 0.6,
														pop_in_rate = 2,
														scale = 0.8,
													}),
												},
											},
										},
									},
								},
							},
							{
								n = G.UIT.R,
								config = { align = "cm", padding = 0.2 },
								nodes = {
									{
										n = G.UIT.R,
										config = {
											align = "cm",
											padding = 0.05,
											emboss = 0.05,
											colour = G.C.WHITE,
											r = 0.1,
										},
										nodes = {
											ISAT.notifications[key].nodes(),
										},
									},
								},
							},
						},
					},
					ISAT.notifications[key].cta and {
						n = G.UIT.R,
						config = {
							id = "overlay_menu_back_button",
							align = "cm",
							minw = 2.5,
							padding = 0.1,
							r = 0.1,
							hover = true,
							colour = G.C.BLUE,
							shadow = true,
							focus_args = { nav = "wide", button = "b" },
						},
						nodes = {
							{
								n = G.UIT.R,
								config = { align = "cm", padding = 0, no_fill = true },
								nodes = {
									{
										n = G.UIT.T,
										config = {
											text = ISAT.notifications[key].cta.label,
											scale = 0.5,
											colour = G.C.UI.TEXT_LIGHT,
											shadow = true,
											func = "set_button_pip",
											focus_args = { button = "b" },
										},
									},
								},
							},
						},
					} or nil,
				},
			},
		},
	})
	return t
end

ISAT.notifications = {
	start = {
		nodes = function()
			return {
				n = G.UIT.R,
				config = {
					align = "cm",
					colour = empty and G.C.CLEAR or G.C.UI.BACKGROUND_WHITE,
					r = 0.1,
					padding = 0.04,
					minw = 2,
					minh = 0.8,
					emboss = not empty and 0.05 or nil,
					filler = true,
				},
				nodes = {
					{
						n = G.UIT.R,
						config = { align = "cm", padding = 0.03 },
						nodes = {
							{
								n = G.UIT.R,
								config = { align = "cm", padding = 0 },
								nodes = {
									{
										n = G.UIT.T,
										config = {
											text = "This mod includes a customize deck option for",
											scale = 0.45,
											colour = G.C.BLACK,
										},
									},
								},
							},
							{
								n = G.UIT.R,
								config = { align = "cm", padding = 0 },
								nodes = {
									{
										n = G.UIT.T,
										config = {
											text = "Rock/Paper/Scissors and Star themed suits,",
											scale = 0.45,
											colour = G.C.BLACK,
										},
									},
								},
							},
							{
								n = G.UIT.R,
								config = { align = "cm", padding = 0 },
								nodes = {
									{
										n = G.UIT.T,
										config = {
											text = "as well as a 'ISAT EN' language option to",
											scale = 0.45,
											colour = G.C.BLACK,
										},
									},
								},
							},
							{
								n = G.UIT.R,
								config = { align = "cm", padding = 0 },
								nodes = {
									{
										n = G.UIT.T,
										config = {
											text = "rename them accordingly.",
											scale = 0.45,
											colour = G.C.BLACK,
										},
									},
								},
							},
							{
								n = G.UIT.R,
								config = { align = "cm", padding = 0 },
								nodes = {
									{
										n = G.UIT.T,
										config = {
											text = "",
											scale = 0.2,
											colour = G.C.BLACK,
										},
									},
								},
							},
							{
								n = G.UIT.R,
								config = { align = "cm", padding = 0 },
								nodes = {
									{
										n = G.UIT.T,
										config = {
											text = "These are turned on by default, but are ",
											scale = 0.45,
											colour = G.C.BLACK,
										},
									},
								},
							},
							{
								n = G.UIT.R,
								config = { align = "cm", padding = 0 },
								nodes = {
									{
										n = G.UIT.T,
										config = {
											text = "not required. Reselect your desired language",
											scale = 0.45,
											colour = G.C.BLACK,
										},
									},
								},
							},
							{
								n = G.UIT.R,
								config = { align = "cm", padding = 0 },
								nodes = {
									{
										n = G.UIT.T,
										config = {
											text = "to return to normalcy.",
											scale = 0.45,
											colour = G.C.BLACK,
										},
									},
								},
							},
						},
					},
				},
			}
		end,
	},
}
