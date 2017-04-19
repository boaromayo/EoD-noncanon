-- Make a HUD for the game.
-- Display the currency currently held, along with the health
-- and weapons carried.

-- Initialize game vars.
local hud = {}
local game = hud:get_game()

-- Set up main surface for the HUD.
local surface = sol.surface.create(0, 0)

-- Set up timer for gauge.


-- Draw player's health on top-left of screen.
function hud:draw_life()
  -- Create a heart image icon.

  -- Create a red bar to indicate player's health.

  -- Display HP / MaxHP to the right of gauge.
  --game:get_life() / game:get_max_life()
end

-- Draw player's tech power, or magic below health of player.
function hud:draw_tech()
  -- Create a mini-sword image icon.

  -- Draw up a blue bar to indicate player's tech power.

  -- Display TP / MaxTP to the right of gauge.
end
 
-- Draw money currently in possession on top of screen
-- next to the health.
function hud:draw_currency()
  -- Load up currency image (coins, gems, maybe?)

  -- Draw money player has currently.
  --game:get_money()
end

return hud