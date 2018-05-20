-- This is the main Lua script of your project.
-- You will probably make a title screen and then start a game.
-- See the Lua API! http://www.solarus-games.org/doc/latest

local game_manager = require("scripts/game_manager")

-- Upload the required scripts.
local solarus_logo = require("scripts/menus/solarus_logo")
local boaromayo_logo = require("scripts/menus/boaromayo_logo")
--local title_screen = require("scripts/menus/title_screen")
--local file_screen = require("scripts/menus/file_screen")

-- This function is called when Solarus starts.
function sol.main:on_started()

  -- Setting a language is useful to display text and dialogs.
  sol.language.set_language("en")

  -- Show the Solarus logo initially.
  sol.menu.start(self, solarus_logo)

  -- Show the |boaromayo logo next.
  solarus_logo.on_finished = function()
    sol.menu.start(self, boaromayo_logo)
  end

  -- Then the title screen.
  boaromayo_logo.on_finished = function()
    game_manager:start_game()
    --sol.menu.start(self, title_screen)
  end

  --[[ Then the file menu.
  title_screen.on_finished = function()
    sol.menu.start(self, file_screen)
  end
  --]]

  -- Start the game when the |boaromayo logo menu is finished.
end

-- Event called when the player pressed a keyboard key.
function sol.main:on_key_pressed(key, modifiers)

  local handled = false
  if key == "f5" then
    -- F5: change the video mode.
    sol.video.switch_mode()
    handled = true
  elseif key == "f11" or
    (key == "return" and (modifiers.alt or modifiers.control)) then
    -- F11 or Ctrl + return or Alt + Return: switch fullscreen.
    sol.video.set_fullscreen(not sol.video.is_fullscreen())
    handled = true
  elseif key == "f4" and modifiers.alt then
    -- Alt + F4: stop the program.
    sol.main.exit()
    handled = true
  elseif key == "escape" and sol.main.game == nil then
    -- Escape in title screens: stop the program.
    sol.main.exit()
    handled = true
  end

  return handled
end
