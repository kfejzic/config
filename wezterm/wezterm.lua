local wezterm = require 'wezterm'
local act = wezterm.action

local config = {}

local function switch_or_create_workspace(window, pane, line)
  local name = line and line:match('^%s*(.-)%s*$')
  if not name or name == '' then
    return
  end

  window:perform_action(
    act.SwitchToWorkspace { name = name },
    pane
  )
end

--config.color_scheme = 'Google (dark) (terminal.sexy)'
config.color_scheme = 'Kanagawa (Gogh)'
-- config.font = wezterm.font('Comic Code')
-- config.font = wezterm.font('MonoLisa')
-- config.font = wezterm.font('Berkeley Mono')
-- config.font = wezterm.font('Codelia Ligatures')
config.font = wezterm.font('SF Mono')
config.harfbuzz_features = {'zero', 'dlig'}
config.keys = {
  {
    key = 'w',
    mods = 'SUPER|CTRL',
    action = act.ShowLauncherArgs { flags = 'FUZZY|WORKSPACES' },
  },
  {
    key = 'w',
    mods = 'SUPER|CTRL|SHIFT',
    action = act.PromptInputLine {
      description = 'Workspace name: switch if it exists, create it if it does not',
      action = wezterm.action_callback(function(window, pane, line)
        switch_or_create_workspace(window, pane, line)
      end),
    },
  },
}

return config
