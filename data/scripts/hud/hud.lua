-- Make a HUD for the game.
-- Display the currency currently held, along with the health
-- and weapons carried.

local game = ...

-- Initialize HUD on top-left of screen.
function game:initialize_hud()
  -- Load HUD components.
  -- Heart icon.
  --local heart_icon_init = require("scripts/hud/heart")
  -- Red bar and health stats to indicate player's life.
  local life_bar_init = require("scripts/hud/red_bar")
  -- Blue bar to indicate player's tech points.
  local tech_bar_init = require("scripts/hud/blue_bar")
  -- Currency.
  --local coin_init = require("scripts/hud/coin")

  -- Index counter to insert HUD components.
  local counter = 1

  -- Create table for HUD components.
  self.hud = {
    dialog_visible = false
  }

  -- Add components to HUD.
  --[[local menu = heart_icon_init:new(self)
  menu:set_dst_position(8, 8)
  self.hud[counter] = menu
  self.hud.heart_icon = menu
  counter = counter + 1--]]
  
  local menu = life_bar_init:new(self)
  menu:set_dst_position(12, 12)
  self.hud[counter] = menu
  self.hud.life_bar = menu
  counter = counter + 1

  menu = tech_bar_init:new(self)
  menu:set_dst_position(12, 24)
  self.hud[counter] = menu
  self.hud.tech_bar = menu
  counter = counter + 1

  --[[
  menu = coin_init:new(self)
  menu:set_dst_position(180, 24)
  self.hud[counter] = menu
  counter = counter + 1
  --]]

  self:set_hud_visible(true)

  self:update_hud()
end

-- Update player's HUD on top-left.
function game:update_hud()

  local map = game:get_map()

  -- If hero is below the HUD, make HUD slightly transparent.
  if map ~= nil then
    local camera = map:get_camera()
    local hero = game:get_hero()
    local hero_x, hero_y = hero:get_position()      
    local cam_x, cam_y = camera:get_bounding_box()
    local x = hero_x - cam_x
    local y = hero_y - cam_y
    local opacity = nil

    if (x < 88 and y < 80) then
      opacity = 128
    elseif (x >= 88 or y >= 80) then
      opacity = 255
    end

    if opacity ~= nil then
      --self.hud.heart_icon.surface:set_opacity(opacity)
      self.hud.life_bar.surface:set_opacity(opacity)
      self.hud.tech_bar.surface:set_opacity(opacity)
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
    self:set_hud_visible(false)
  end
  -- Take everything out.
  self.hud = nil
end

function game:set_hud_visible(hud_visible)
  if hud_visible ~= self.hud_visible then
    self.hud_visible = hud_visible

    -- Generate HUD components one-by-one.
    for i, hud in ipairs(self.hud) do
      if hud_visible then
        sol.menu.start(self, hud)
      else
        sol.menu.stop(hud)
      end
    end
  end
end

function game:is_hud_visible()
  return self.hud_visible
end

function game:hud_on_map_changed(map)
  if self:is_hud_visible() then
    -- For each HUD part, do action when game paused.
    for i, hud in ipairs(self.hud) do
      if hud.on_map_changed ~= nil then
        hud:on_map_changed(map)
      end
    end
  end
end

function game:hud_on_paused()
  if self:is_hud_visible() then
    -- For each HUD part, do action when game paused.
    for i, hud in ipairs(self.hud) do
      if hud.on_paused ~= nil then
        hud:on_paused()
      end
    end
  end
end

function game:hud_on_unpaused()
  if self:is_hud_visible() then
    -- For each HUD part, do action when game paused.
    for i, hud in ipairs(self.hud) do
      if hud.on_unpaused ~= nil then
        hud:on_unpaused()
      end
    end
  end
end

function game:hud_on_dialog_started(dialog)
  if self:is_hud_visible() then
    -- For each HUD part, do action when game paused.
    for i, hud in ipairs(self.hud) do
      if hud.on_dialog_started ~= nil then
        hud:on_dialog_started(dialog)
      end
    end
  end
end

function game:hud_on_dialog_finished()
  if self:is_hud_visible() then
    -- For each HUD part, do action when game paused.
    for i, hud in ipairs(self.hud) do
      if hud.on_dialog_finished ~= nil then
        hud:on_dialog_finished()
      end
    end
  end
end