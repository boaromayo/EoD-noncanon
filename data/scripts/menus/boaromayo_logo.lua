-- Logo by boaromayo.

-- Create the boaromayo logo, or the second splash
-- screen for the game.

local boaromayo_logo = {}

-- Start menu.
function boaromayo_logo:on_started()
  -- Create main surface of logo.
  self.surface = sol.surface.create(320, 240)
  -- Delay half a second before showing logo.
  sol.timer.start(self, 500, function()
    self:show_logo()
  end)
end

-- Show logo.
function boaromayo_logo:show_logo()
  -- Load logo.
  self.logo = sol.surface.create("menus/boaromayo-splash-small.png")  

  -- Create logo.
  self.surface:fill_color({0, 0, 0})
  self.logo:draw(self.surface)

  self.surface:fade_in()
  
  -- Wait before activating pre-finish method.
  sol.timer.start(self, 3000, function()
    self:on_pre_finish()
  end)
end

-- Draw method.
function boaromayo_logo:on_draw(screen)
  -- Get size of screen for blit drawing.
  local width, height = screen:get_size()
  self.surface:draw(screen, width / 2 - 160, height / 2 - 120)
end

-- Events called when player presses a key.
function boaromayo_logo:on_key_pressed(key)

  local handled = false

  -- If escape key pressed, quit game.
  if key == "escape" then
    sol.main.exit()
    handled = true
  -- Handle input to fade out logo.
  elseif key == "space" or key == "return" then
    self:on_pre_finish()
    handled = true
  end
end

-- Do pre-finished process for logo.
function boaromayo_logo:on_pre_finish()
  sol.timer.start(self, 1000, function()
    self.surface:fade_out(30)
    sol.timer.start(self, 1000, function()
      sol.menu.stop(self)
    end)
  end)
end

return boaromayo_logo