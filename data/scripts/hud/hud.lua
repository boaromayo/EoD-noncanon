-- Make a HUD for the game.
-- Display the currency currently held, along with the health
-- and weapons carried.

-- Initialize HUD on top-left of screen.
function game:initialize_hud()
  -- Initialize menu object for HUD.
  local menu = nil
  -- Create HUD stats.
  local heart_icon_init = require("scripts/hud/heart")
  -- Create red bar to indicate player's life.
  local life_bar_init = require("scripts/hud/red_bar")
  -- Create blue bar to indicate player's tech points.
  --local tech_bar_init = require("scripts/hud/blue_bar")
  -- Create currency.
  --local coin_init = require("scripts/hud/coin")

  -- Create table for HUD components.
  self.hud = {}

  -- Add components to HUD.
  menu = heart_icon_init:new(self)
  menu:set_dst_position(8, 8)
  self.hud.heart_icon = menu
  
  menu = life_bar_init:new(self)
  menu:set_dst_position(32, 12)
  self.hud.life_bar = menu

  --[[
  menu = tech_bar_init:new(self)
  menu:set_dst_position()
  self.hud.tech_bar = menu

  menu = coin_init:new(self)
  menu:set_dst_position(8, 100)
  self.hud.coin = menu
  --]]

  self:set_hud_visible(true)

  self:update_hud()
end

-- Update player's HUD on top-left.
function game:update_hud()
  local map = self:get_map()
  -- If hero is below the HUD, make HUD slightly transparent.
  if map ~= nil then
    local hero = map:get_entity("Hero")
    local hero_x, hero_y = hero:get_position()      
    local cam_x, cam_y = map:get_camera:get_bounding_box()
    local x = hero_x - cam_x
    local y = hero_y - cam_y
    local opacity = nil

    if (x < 88 and y < 80) then
      opacity = 128
    elseif (x >= 88 or y >= 80) then
      opacity = 255
    end

    if opacity ~= nil then
      self.hud.heart_icon.surface:set_opacity(opacity)
      self.hud.life_bar.surface:set_opacity(opacity)
      --self.hud.tech_bar.surface:set_opacity(opacity)
    end
  end

  -- Update HUD every 5/100s of a second.
  sol.timer.start(self, 50, function()
    self:update_hud()
  end)
end

-- When game is shutdown, dispose HUD.
function game:quit_hud()
  if self:is_hud_visible() then
    self.set_hud_visible(false)
  end
  -- Take everything out.
  self.hud = nil
end

function game:set_hud_visible(hud_visible)
  if hud_visible ~= self.hud_visible then
    self.hud_visible = hud_visible

    -- Generate HUD components to menu.
    for i, menu in ipairs(self.hud) do
      if hud_visible then
        sol.menu.start(self, menu)
      else
        sol.menu.stop(menu)
      end
    end
  end
end

function game:is_hud_visible()
  return self.hud_visible
end
