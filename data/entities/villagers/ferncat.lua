-- Lua script of custom entity villagers/ferncat.
-- This script is executed every time a custom entity with this model is created.

-- Feel free to modify the code below.
-- You can add more events and remove the ones you don't need.

-- See the Solarus Lua API documentation for the full specification
-- of types, events and methods:
-- http://www.solarus-games.org/doc/latest

local ferncat = ...
local game = ferncat:get_game()
local map = ferncat:get_map()
local sprite = ferncat:get_sprite()

-- Event called when the custom entity is initialized.
function ferncat:on_created()
  -- Initialize the properties of your custom entity here,
  -- like the sprite, the size, and whether it can traverse other
  -- entities and be traversed by them.  
  sprite:set_animation("sit")
  self:set_size(16, 16)
  self:set_origin(8, 13)
  self:set_traversable_by(false)
end

-- Start "meowing" sound effect on interaction.
function ferncat:on_interaction()
  -- Have cat face player.
  local hero = game:get_hero()
  local left = self:get_direction()
  local dir = self:get_direction4_to(hero)
  self:set_direction(dir)
  -- Freeze hero.
  hero:freeze()
  -- Delay for half a second, then...
  -- Meow!
  sol.timer.start(500, function() 
    sol.audio.play_sound("cat")
    -- Wait a while, then...
    sol.timer.start(500, function()
      -- Move cat back to original direction.
      self:set_direction(left)
      -- Unfreeze hero.
      hero:unfreeze()
    end)
  end)
end