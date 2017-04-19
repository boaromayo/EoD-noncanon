-- Lua script of custom entity objects/push_block.
-- This script is executed every time a custom entity with this model is created.

-- Feel free to modify the code below.
-- You can add more events and remove the ones you don't need.

-- See the Solarus Lua API documentation for the full specification
-- of types, events and methods:
-- http://www.solarus-games.org/doc/latest

local door_block = ...
local game = door_block:get_game()
local map = door_block:get_map()

-- Event called when the custom entity is initialized.
function door_block:on_created()

  -- Initialize the properties of your custom entity here,
  -- like the sprite, the size, and whether it can traverse other
  -- entities and be traversed by them.
  self:set_size(16, 16)
  self:set_origin(8, 13)
  self:set_traversable_by(false) -- Do not let player pass through.
end