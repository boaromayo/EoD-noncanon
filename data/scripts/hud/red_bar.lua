-- Create life bar for the HUD to display player's health.
-- Initialize a table for the life bar.
local life_bar = {}
local width = 52
local height = 6

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
  -- of where life bar and stats will be drawn.
  self.game = game
  self.surface = sol.surface.create(width * 3, height * 2)
  self.text_surface = sol.text_surface.create{
    font = "8_bit",
    horizontal_alignment = "left"
  }
  self.life_gauge = sol.surface.create("hud/gauge.png")
  self.life_bar_background = sol.sprite.create("hud/red_bar")
  self.current_life = game:get_life()
  self.max_life = game:get_max_life()
end

-- Start drawing life bar.
function life_bar:on_started()
  self:update()
  self:redraw()
end

-- Update method for life bar.
function life_bar:update()
  local redraw = false
  local max_life = self.game:get_max_life()
  local life = self.game:get_life()

  -- Update life bar if gauge is not maximum.
  if max_life ~= self.max_life_gauge then
    redraw = true
    if self.current_life > max_life then
      self.current_life = max_life
    end
    self.max_life = max_life
  end

  -- Gradually update life bar based on current life player has.
  if life ~= self.current_life then
    redraw = true
    local increment = 1
    if life > self.current_life then
      increment = 1
    elseif life < self.current_life then
      increment = -1
    end
    -- When increment is different, change life gauge length.
    if increment ~= 0 then
      self.current_life = self.current_life + increment
    end
  end

  -- Draw text life rate.
  self.text_surface:set_text(self.current_life .. "/" .. self.max_life)

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
   local life_rate = self.current_life * width / self.max_life
   self.surface:clear()

  -- Draw life bar background.
  self.life_bar_background:draw(self.surface)

  -- Draw life gauge.
  self.life_gauge:draw_region(1, 10, 
    math.floor(life_rate), height, self.surface)

  -- Draw text life to screen.
  self.text_surface:draw(self.surface, width + 4, 4)
end

-- Set life bar to disappear when called (ie. for cutscenes).
function life_bar:on_disappeared()
end

-- Set life bar to semi-opaque if dialog started.
function life_bar:on_dialog_started(dialog)
  local opacity = nil

  if self.game.dialog_box.dialog == dialog then
    opacity = 128

    if opacity ~= nil then
      self.surface:set_opacity(opacity)
    end
  end
end

-- Set life bar opaque once dialog finished
-- unless player is near or on upper-left corner
-- of screen.
function life_bar:on_dialog_finished()
  local opacity = nil
  local hero = self.game:get_hero()
  local hero_x, hero_y = hero:get_position()
  local cam_x, cam_y = game:get_map():get_camera():get_bounding_box()
  local x = hero_x - cam_x
  local y = hero_y - cam_y

  if self.game.dialog_box.dialog == nil then
    if (x < 88 and y < 80) then
      opacity = 128
    elseif (x >= 88 and y >= 80) then
      opacity = 255
    end
    
    if opacity ~= nil then
      self.surface:set_opacity(opacity)
    end
  end
end

-- Set life bar's position on-screen.
function life_bar:set_dst_position(x,y)
  self.dest_x = x
  self.dest_y = y
end

-- Draw life bar.
function life_bar:on_draw(screen)
  local x, y = self.dest_x, self.dest_y
  self.surface:draw(screen, x, y)
end

return life_bar -- Return life bar when finished.