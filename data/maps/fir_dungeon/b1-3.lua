-- Lua script of map fir_dungeon/b1-4.
-- This script is executed every time the hero enters this map.

-- Feel free to modify the code below.
-- You can add more events and remove the ones you don't need.

-- See the Solarus Lua API documentation:
-- http://www.solarus-games.org/doc/latest

local map = ...
local game = map:get_game()
local block = map:get_entity("switch_block")
local door_block = map:get_entity("door_block")
local door_block_open = game:get_value("door_block")

-- Event called as soon as this map is loaded.
function map:on_started()

  -- You can initialize the movement and sprites of various
  -- map entities here.
  if door_block_open == 0 then
    door_block:set_enabled(true)  
  end
end

-- Event called after the opening transition effect of the map,
-- that is, when the player takes control of the hero.
function map:on_opening_transition_finished()

end

-- Call this function as soon as player moves the block in the
-- center of the room, which will open the west way of this room.
function block:on_moved()
  -- Play rock break sound effect and
  -- make "door" disappear.
  sol.audio.play_sound("switch")
  sol.timer.start(500, secret_sound)
  door_block:remove_sprite("entities/block")
  door_block:set_enabled(false)
end

local function secret_sound()
  sol.audio.play_sound("secret")
end