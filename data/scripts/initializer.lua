-- The Lua script initializes game variables for a new game.
-- This overrides the game_manager's initialize_new_savegame() function
-- as a way to set the starting location and stats for the player.

local initializer = {}

-- Sets the initial values for the new game.
function initializer:initialize_new_savegame(game)
  game:set_starting_location("fir_house")

  game:set_max_life(16)
  game:set_life(game:get_max_life()) 
  game:set_ability("lift", 1) -- Set lift ability only.
end

return initializer