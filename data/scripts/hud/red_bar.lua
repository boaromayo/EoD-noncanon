-- Create the life bar for the HUD
-- to display player's health.

-- Initialize a table for the life bar.
local life_bar = {}

-- When constructing a new life bar, 
-- return as an object in-game.
function life_bar:new(game)
  local object = {}
  setmetatable(object, self)
  self.__index = self

  object:initialize(game)

  return object
end

-- Initialize life bar.
function life_bar:initialize(game)
  -- Setup the surface, or area, 
  -- of where life bar will be drawn.
  self.game = game
  self.surface = sol.surface.create(44, 4)
  self.life_bar_surface = sol.surface.create("hud/gauge.png")
  self.life_gauge = sol.sprite.create("hud/life_bar")
  self.current_life_gauge = game:get_life()
  self.max_life_gauge = game:get_max_life()

  -- Make checks and draw to surface.
  self:update()
  self:redraw()
end

-- Update method for life bar.
function life_bar:update()
  local redraw = false
  local max_life = self.game:get_max_life()
  local life = self.game:get_life()

  -- Update life bar based on maximum gauge.
  if max_life ~= self.max_life_gauge then
    redraw = true
    if self.current_life_gauge > max_life then
      self.current_life_gauge = max_life
    end
    self.max_life_gauge = max_life
    -- Draw gauge if maximum life is more than zero.
    if max_life > 0 then
      self.life_gauge:set_direction(max_life / 24 - 1)
    end
  end

  -- Gradually update life bar based on current life player has.
  if life ~= self.current_life_gauge then
    redraw = true
    local increment = 1
    if life > self.current_life_gauge then
      increment = -1
    elseif life < self.current_life_gauge then
      increment = 1
    end
    -- When increment is different, change life gauge length.
    if increment ~= 0 then
      self.current_life_gauge = self.current_life_gauge + increment
    end
  end

  -- If redraw needed based on changes, do so.
  if redraw then
    self:redraw()
  end

  -- Make another update.
  sol.timer.start(self.game, 20, function()
    self:update()
  end)
end

-- Redraw life bar.
function life_bar:redraw()
   self.surface:clear()

  -- Draw maximum life gauge.
  self.life_gauge:draw(self.surface)

  -- Draw life bar region.
  self.life_bar_surface:draw_region(32, 16, 2 + self.current_life_gauge, 4, self.surface)
end

-- Set life bar's dst position.
function life_bar:set_dst_position(x,y)
  self.dst_x = x
  self.dst_y = y
end

-- Draw life bar.
function life_bar:on_draw(dst_surface)
  local x, y = self.dst_x, self.dst_y
  self.surface:draw(dst_surface, x, y)
end

return life_bar -- Return life bar when finished.