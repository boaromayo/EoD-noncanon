--Create tech bar for the HUD for player's tech points.
-- Make a table for tech bar.
local tech_bar = {}
local width = 42
local height = 6

-- Return as object in-game.
function tech_bar:new(game)
  local object = {}
  setmetatable(object, self)
  self.__index = self

  object:initialize(game)

  return object
end

-- Setup tech bar.
function tech_bar:initialize(game)
  self.game = game
  self.surface = sol.surface.create(width * 3, height * 2)
  self.text_surface = sol.text_surface.create{
    font = "8_bit",
    horizontal_alignment = "left"
  }
  self.tech_gauge = sol.surface.create("hud/gauge.png")
  self.tech_bar_background = sol.sprite.create("hud/blue_bar")
  self.current_tech = game:get_magic()
  self.max_tech = game:get_max_magic()
end

-- 
function tech_bar:on_started()
  self:update()
  self:redraw()
end

-- Tech bar update method.
function tech_bar:update()
  local redraw = false
  local current_tech = self.game:get_magic()
  local max_tech = self.game:get_max_magic()

  -- Update tech gauge if not maxed.
  if max_tech ~= self.max_tech then
    redraw = true
    -- Set current points to max if current > max.
    if self.current_tech > max_tech then
      self.current_tech = max_tech
    end
    self.max_tech = max_tech
    -- Show gauge if maximum tech is more than zero.
    if max_tech > 0 then
      self.tech_gauge:set_direction(max_tech / 24 - 1)
    end
  end

  -- Gradually update tech gauge based on current tech player has.
  if current_tech ~= self.current_tech then
    redraw = true
    local increment = 1
    if current_tech > self.current_tech then
      increment = 1
    elseif current_tech < self.current_tech then
      increment = -1
    end
    -- When increment is different, change life gauge length.
    if increment ~= 0 then
      self.current_tech = self.current_tech + increment
    end
  end

  -- Draw text version of tech rate.
  self.text_surface:set_text(self.current_tech .. "/" .. self.max_tech)

  -- Redraw tech gauge, if needed.
  if redraw then
    self:redraw()
  end

  -- Update gauge every 1/50 of a second.
  sol.timer.start(self, 20, function()
    self:update()
  end)
end

-- Tech bar redraw per frame method.
function tech_bar:redraw()
  local tech_rate = self.current_tech * width / self.max_tech
  self.surface:clear()

  -- Draw tech bar background.
  self.tech_bar_background:draw(self.surface)

  -- Draw tech gauge.
  self.tech_gauge:draw_region(54, 10, 
    math.floor(tech_rate), height, self.surface)

  -- Draw text tech to screen.
  self.text_surface:draw(self.surface, width + 4, 4)
end

-- Set tech bar's position on-screen.
function tech_bar:set_dst_position(x, y)
  self.dest_x = x
  self.dest_y = y
end

-- Tech bar drawing method.
function tech_bar:on_draw(screen)
  local x, y = self.dest_x, self.dest_y
  self.surface:draw(screen, x, y)
end

return tech_bar