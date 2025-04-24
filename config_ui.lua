--Config UI
local restart_toggles= { 
    {ref_value = "menu", label = "Custom Title Screen"},
}

local no_restart_toggles = {
  {ref_value = "menu", label = "n/a"},
}
 
local create_menu_toggles = function (parent, toggles)
  for k, v in ipairs(toggles) do
    parent.nodes[#parent.nodes + 1] = create_toggle({
          label = v.label,
          ref_table = isat_config,
          ref_value = v.ref_value,
          callback = function(_set_toggle)
            NFS.write(isat_dir.."/config.lua", STR_PACK(isat_config))
          end,
    })
    if v.tooltip then
      parent.nodes[#parent.nodes].config.detailed_tooltip = v.tooltip
    end
  end
end

isatconfig = function()
  local restart_settings = {n = G.UIT.R, config = {align = "cm", padding = 0.05, scale = 0.75, colour = G.C.CLEAR,}, nodes = {}}
  create_menu_toggles(restart_settings, restart_toggles)

  
  local no_restart_settings = {n = G.UIT.R, config = {align = "tm", padding = 0.05, scale = 0.75, colour = G.C.CLEAR,}, nodes = {}}
  create_menu_toggles(no_restart_settings, no_restart_toggles)
  
  local config_nodes =   
  {
    {
    --   n = G.UIT.R,
    --   config = {
    --     padding = 0,
    --     align = "cm"
    --   },
    --   nodes = {
    --     {
    --       n = G.UIT.T,
    --       config = {
    --         text = "No Restart Required",
    --         shadow = true,
    --         scale = 0.75 * 0.8,
    --         colour = HEX("ED533A")
    --       }
    --     }
    --   },
    -- },
    -- no_restart_settings,
    -- {
      n = G.UIT.R,
      config = {
        padding = 0,
        align = "tm"
      },
      nodes = {
        {
          n = G.UIT.T,
          config = {
            text = "Restart Required",
            shadow = true,
            scale = 0.75 * 0.8,
            colour = HEX("ED533A")
          }
        }
      },
    },
    restart_settings,
  }
  return config_nodes
end

SMODS.current_mod.config_tab = function()
    return {
      n = G.UIT.ROOT,
      config = {
        align = "cm",
        padding = 0.05,
        colour = G.C.CLEAR,
      },
      nodes = isatconfig()
    }
end