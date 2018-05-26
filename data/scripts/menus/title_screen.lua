-- Title screen for game.

local title_screen = {}

function title_screen:on_started()

  self.mode = 0
  -- Prep surface.
  self.surface = sol.surface.create(320, 240)
  -- Delay half a sec before revealing title.
  sol.timer.start(self, 500, function()
    self.surface:fade_in(30)
    --self:presents()
  end)
end

--[[function title_screen:presents()
  
  self.mode = 1

  -- Draw background.
  local sea_color = {}
  self.background_color = self.sea_color
  
end--]]

-- Draw method.
function title_screen:on_draw(screen)
  -- Call drawing methods based on modes.
  --[[if self.mode == 1 then
    self:on_draw_presents()
  elseif self.mode == 2 then
    self:on_draw_title()
  end--]]

  -- Get surface size for blit drawing.
  local width, height = screen:get_size()
  self.surface:draw(screen, width / 2 - 160, height / 2, 120)
end

function title_screen:on_draw_presents()

end

function title_screen:on_draw_title()
  
end

-- Events called based on player keyboard input.
function title_screen:on_key_pressed(key)
  
  local handled = false

  -- Handle any key events.
  -- If ESC pressed, quit game.
  if key == "escape" then
    sol.main.exit()
    handled = true
  -- Otherwise, continue onto pre-finish.
  else if key == "space" or key == "return" then
    self:on_pre_finish()
    handled = true
  end

end

-- Pre-finish processing for title screen.
function title_screen:on_pre_finish()
  self.surface:fade_out(20)
  sol.timer.start(self, 3000, function()
    sol.main.stop(self)
  end)
end

return title_screen