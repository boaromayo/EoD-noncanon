-- Make the pesos, or money, display for the game.
local pesos = {}
local width = 24
local height = 12

function pesos:new(game)
  local object = {}
  setmetatable(object, self)
  self.__index = self

  object:initialize(game)

  return object
end

-- Setup money counter.
function pesos:initialize(game)
  self.game = game
  self.surface = sol.surface.create(width * 2, height)
  --self.icon = sol.sprite.create("hud/peso")
  self.text_surface = sol.text_surface.create {
    font = "8_bit",
    horizontal_alignment = "right"
  }
  self.current_money = game:get_money()
  self.max_money = game:get_max_money()
  self.text_surface:set_text(self.current_money)
end

-- Automatically called after initialized.
function pesos:on_started()
  self:update()
  self:redraw()
end

-- Update method.
function pesos:update()
  local redraw = false
  local money = self.game:get_money()
  local max_money = self.game:get_max_money()

  -- If money counter max different,
  -- update and redraw.
  if max_money ~= self.max_money then
    redraw = true
    -- Set current money to max if current > max.
    if money > max_money then
      self.current_money = max_money
    end
  end

  -- Gradually update to current money.
  if money ~= self.current_money then
    redraw = true
    local increment = 0
    if money > self.current_money then
      increment = 1
    elseif money < self.current_money then
      increment = -1
    end
    -- When increment different, update until at actual current money.
    if increment ~= 0 then
      self.current_money = self.current_money + increment
    end
    -- Play keep counting sound for every 5 pesos counted.
    if self.current_money % 5 == 0 then
      sol.audio.play_sound("rupee_counter")
    
    -- Play sound after reaching end of money count.    
    elseif money == self.current_money then
      sol.audio.play_sound("rupee_counter_end")
    end
   end
  
  -- Redraw pesos counter if changed.
  if redraw then
    self:redraw()
  end

  -- Update every 1/50 of a second.
  sol.timer.start(self, 20, function()
    self:update()
  end)
end

-- Method to redraw counter to current number of pesos.
function pesos:redraw()
  self.surface:clear()

  -- Draw icon to surface.
  --self.icon:draw(self.surface)

  -- Draw current money counter to surface.
  self.text_surface:draw(self.surface, width + 16, 4)
end

-- Set position of money counter on-screen.
function pesos:set_dst_position(x, y)
  self.dest_x = x
  self.dest_y = y
end

-- Drawing method.
function pesos:on_draw(screen)
  local x, y = self.dest_x, self.dest_y
  self.surface:draw(screen, x, y)
end

return pesos