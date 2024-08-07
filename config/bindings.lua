-- if true then
--    return {}
-- end
local wezterm = require('wezterm')
local platform = require('utils.platform')()
local backdrops = require('utils.backdrops')
local act = wezterm.action

local mod = {}

if platform.is_mac then
   mod.SUPER = 'SUPER'
   mod.SUPER_REV = 'SUPER|CTRL'
elseif platform.is_win or platform.is_linux then
   mod.SUPER = 'ALT' -- to not conflict with Windows key shortcuts
   mod.SUPER_REV = 'ALT|CTRL'
end

-- stylua: ignore
local keys = {
   -- misc/useful --
   { key = 'Space', mods = 'LEADER', action = act.ActivateCommandPalette },
   { key = 'y',     mods = 'LEADER', action = 'ActivateCopyMode' },
   { key = 'l',     mods = 'LEADER', action = act.ShowLauncher },
   { key = 'o',     mods = 'LEADER', action = act.ShowLauncherArgs({ flags = 'FUZZY|TABS' }) },
   {
      key = 'w',
      mods = 'LEADER',
      action = act.ShowLauncherArgs({ flags = 'FUZZY|WORKSPACES' }),
   },
   { key = 'F', mods = 'LEADER', action = act.ToggleFullScreen },
   { key = 'D', mods = 'LEADER', action = act.ShowDebugOverlay },
   { key = '/', mods = 'LEADER', action = act.Search({ CaseInSensitiveString = '' }) },
   {
      key = 'u',
      mods = 'LEADER',
      action = wezterm.action.QuickSelectArgs({
         label = 'open url',
         patterns = {
            '\\((https?://\\S+)\\)',
            '\\[(https?://\\S+)\\]',
            '\\{(https?://\\S+)\\}',
            '<(https?://\\S+)>',
            '\\bhttps?://\\S+[)/a-zA-Z0-9-]+'
         },
         action = wezterm.action_callback(function(window, pane)
            local url = window:get_selection_text_for_pane(pane)
            wezterm.log_info('opening: ' .. url)
            wezterm.open_with(url)
         end),
      }),
   },

   -- -- cursor movement --
   -- { key = 'LeftArrow',  mods = mod.SUPER,     action = act.SendString '\x1bOH' },
   -- { key = 'RightArrow', mods = mod.SUPER,     action = act.SendString '\x1bOF' },
   -- { key = 'Backspace',  mods = mod.SUPER,     action = act.SendString '\x15' },

   -- copy/paste --
   { key = 'c',      mods = mod.SUPER_REV, action = act.CopyTo('Clipboard') },
   { key = 'v',      mods = mod.SUPER_REV, action = act.PasteFrom('Clipboard') },
   { key = 'Insert', mods = 'CTRL',        action = act.CopyTo('Clipboard') },
   { key = 'Insert', mods = 'SHIFT',       action = act.PasteFrom('Clipboard') },

   -- tabs --
   -- tabs: spawn+close
   { key = 'n',      mods = 'LEADER',      action = act.SpawnCommandInNewTab({ domain = { DomainName = "local" } }) },
   { key = 'a',      mods = 'LEADER',      action = act.SpawnTab({ DomainName = 'Arch' }) },
   { key = 'q',      mods = mod.SUPER_REV, action = act.CloseCurrentTab({ confirm = false }) },

   -- tabs: navigation
   { key = '[',      mods = 'LEADER',      action = act.ActivateTabRelative(-1) },
   { key = ']',      mods = 'LEADER',      action = act.ActivateTabRelative(1) },
   { key = '[',      mods = mod.SUPER_REV, action = act.MoveTabRelative(-1) },
   { key = ']',      mods = mod.SUPER_REV, action = act.MoveTabRelative(1) },

   -- window --
   -- spawn windows
   -- { key = 'n',      mods = mod.SUPER,     action = act.SpawnWindow },

   -- background controls --
   {
      key = [[/]],
      mods = mod.SUPER,
      action = wezterm.action_callback(function(window, _pane)
         backdrops:random(window)
      end),
   },
   {
      key = [[,]],
      mods = mod.SUPER,
      action = wezterm.action_callback(function(window, _pane)
         backdrops:cycle_back(window)
      end),
   },
   {
      key = [[.]],
      mods = mod.SUPER,
      action = wezterm.action_callback(function(window, _pane)
         backdrops:cycle_forward(window)
      end),
   },
   {
      key = [[/]],
      mods = mod.SUPER_REV,
      action = act.InputSelector({
         title = 'Select Background',
         choices = backdrops:choices(),
         fuzzy = true,
         fuzzy_description = 'Select Background: ',
         action = wezterm.action_callback(function(window, _pane, idx)
            ---@diagnostic disable-next-line: param-type-mismatch
            backdrops:set_img(window, tonumber(idx))
         end),
      }),
   },

   -- panes --
   -- panes: split panes
   {
      key = 's',
      mods = 'LEADER',
      action = act.SplitVertical({ domain = 'CurrentPaneDomain' }),
   },
   {
      key = 'v',
      mods = 'LEADER',
      action = act.SplitHorizontal({ domain = 'CurrentPaneDomain' }),
   },

   -- panes: zoom+close pane
   -- { key = 'Enter', mods = mod.SUPER,     action = act.TogglePaneZoomState },
   { key = 'q', mods = 'LEADER',      action = act.CloseCurrentPane({ confirm = false }) },

   -- panes: navigation
   { key = 'k', mods = mod.SUPER_REV, action = act.ActivatePaneDirection('Up') },
   { key = 'j', mods = mod.SUPER_REV, action = act.ActivatePaneDirection('Down') },
   { key = 'h', mods = mod.SUPER_REV, action = act.ActivatePaneDirection('Left') },
   { key = 'l', mods = mod.SUPER_REV, action = act.ActivatePaneDirection('Right') },
   {
      key = 'p',
      mods = 'LEADER',
      action = act.PaneSelect({ alphabet = 'asdfghjkl', mode = 'SwapWithActiveKeepFocus' }),
   },

   -- key-tables --
   -- resizes fonts
   {
      key = 'x',
      mods = 'LEADER',
      action = act.ActivateKeyTable({
         name = 'resize_font',
         one_shot = false,
         timemout_miliseconds = 1000,
      }),
   },
   -- resize panes
   {
      key = 'p',
      mods = 'LEADER',
      action = act.ActivateKeyTable({
         name = 'resize_pane',
         one_shot = false,
         timemout_miliseconds = 1000,
      }),
   },
}

-- stylua: ignore
local key_tables = {
   resize_font = {
      { key = 'k',      action = act.IncreaseFontSize },
      { key = 'j',      action = act.DecreaseFontSize },
      { key = 'r',      action = act.ResetFontSize },
      { key = 'Escape', action = 'PopKeyTable' },
      { key = 'q',      action = 'PopKeyTable' },
   },
   resize_pane = {
      { key = 'k',      action = act.AdjustPaneSize({ 'Up', 1 }) },
      { key = 'j',      action = act.AdjustPaneSize({ 'Down', 1 }) },
      { key = 'h',      action = act.AdjustPaneSize({ 'Left', 1 }) },
      { key = 'l',      action = act.AdjustPaneSize({ 'Right', 1 }) },
      { key = 'Escape', action = 'PopKeyTable' },
      { key = 'q',      action = 'PopKeyTable' },
   },
}

local mouse_bindings = {
   -- Ctrl-click will open the link under the mouse cursor
   {
      event = { Up = { streak = 1, button = 'Left' } },
      mods = 'CTRL',
      action = act.OpenLinkAtMouseCursor,
   },
}

return {
   disable_default_key_bindings = true,
   -- leader = { key = 'Space', mods = mod.SUPER_REV },
   leader = { key = 'w', mods = 'ALT' },
   keys = keys,
   key_tables = key_tables,
   mouse_bindings = mouse_bindings,
}
