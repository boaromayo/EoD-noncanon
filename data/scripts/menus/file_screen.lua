-- File selection screen.

local file_screen = {}

function file_screen:on_started()
  local sea_color = { 80, 145, 190 }
  -- Create graphics.
  self.surface = sol.surface.create(320, 240)
  self.background_color = sea_color
end

-- Drawing method.
function file_screen:on_draw(screen)
  -- Fill background.
  self.surface:fill_color(self.background_color)

  -- Draw to screen.
  self.surface:draw(screen)
end

-- Key input.
function file_screen:on_key_pressed(key)
  local handled = false

  if key == "escape" then
    -- Shutdown game.
    handled = true
    sol.main.exit()
  elseif key == "right" then
  elseif key == "up" then
  elseif key == "left" then
  elseif key == "down" then
  end

  return handled
end