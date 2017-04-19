-- Fern Lua script.

-- Feel free to modify the code below.
-- You can add more events and remove the ones you don't need.

-- See the Solarus Lua API documentation for the full specification
-- of types, events and methods:
-- http://www.solarus-games.org/doc/latest

local fern = ...
local game = fern:get_game()
local map = fern:get_map()

-- Event called when the custom entity is initialized.
function fern:on_created()

  -- Initialize the properties of your custom entity here,
  -- like the sprite, the size, and whether it can traverse other
  -- entities and be traversed by them.
  self:set_size(16, 16)
  self:set_origin(8, 13)
  self:set_traversable_by(false) -- Do not let player pass through.
end

-- Call start_dialog() to initiate the dialog with Fern.
function fern:on_interaction()
  -- Make steps to face player.
  local hero = map:get_hero()
  local dir = self:get_direction4_to(hero)
  self:set_direction(dir)
  self:start_dialog()
end

-- Call map script to start the dialog with Fern.
function fern:start_dialog()
  if map.fern_dialog then
    map:fern_dialog()
  end
end