-- Create a heart icon for the HUD
-- to indicate to player that life bar is
-- player's health.

-- Initialize table for heart icon.
local heart_icon = {}

-- When constructing a new heart icon,
-- return as an in-game object.
function heart_icon:new(game)
  local object = {}
  newmetatable(object, self)
  self.__index = self

  object:initialize(game)

  return object
end

-- Initialize heart icon.
function heart_icon:initialize(game)
  -- Setup the surface area.
  self.game = game
  self.surface = sol.surface.create(24, 24)
  self.dst_x = 0
  self.dst_y = 0
  self.heart_surface = sol.surface.create("hud/heart_shadow.png")
end

-- When HUD is enabled, draw heart icon.
function heart_icon:on_started()
  self:redraw()
end

-- Redraw heart icon.
-- Heart icon is a static image, so it needs little updates. 
function heart_icon:redraw()
  self.surface:clear()
  local x, y = self.dst_x, self.dst_y

  self.heart_surface:draw(self.surface, x, y)
end

-- Set position of heart icon.
function heart_icon:set_dst_position(x,y)
  self.dst_x = x
  self.dst_y = y
end

-- Draw method for heart icon.
function heart_icon:on_draw(dst_surface)
  local x, y = self.dst_x, self.dst_y
  self.surface:draw(dst_surface, x, y)
end

return heart_icon -- Return heart icon.