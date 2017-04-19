-- Lua script of map Fir House, a place where Fern, a lone woman, lives.
-- This script is executed every time the hero enters this map.

-- Feel free to modify the code below.
-- You can add more events and remove the ones you don't need.

-- See the Solarus Lua API documentation:
-- http://www.solarus-games.org/doc/latest

local map = ...
local game = map:get_game()
local event_no = game:get_value("fern")
local fern = map:get_entity("fern")

-- Event called as soon as this map is loaded.
function map:on_started()
  -- Check if this quest finished, then move Fern
  -- to shop bench.
  if event_no > 3 then
    fern:set_position(256, 56)
  else
    fern:set_position(80, 56)
  end
end

--[[
--=========================
Fern dialogs:
hello: say hello
hello2: greet after dungeon finish
request: ask for request
yes: accept
no: oh, well
weapon: chest has a weapon to use
tip: give tips on dungeon
reward: praise player and give prize
--=========================
--]]
function map:fern_dialog()
  -- Make checks for event variable
  if event_no == nil then
    event_no = 0
    game:set_value("fern", event_no)
  end
  -- Introduce fern to player.
  if event_no == 0 then
    game:start_dialog("fern.hello", function()
      game:start_dialog("fern.request", function(answer)
        if answer == 1 then
          game:start_dialog("fern.yes", confirm)
        else
          game:start_dialog("fern.no")
        end
      end)
    end) -- Call decision function.
  elseif event_no == 1 then
    game:start_dialog("fern.weapon") -- Mention weapon in chest.
  elseif event_no == 2 then
    game:start_dialog("fern.reward") -- Give reward if quest finished.
    game:get_reward("very-important-item") -- Reward's the very important item.
    confirm()
  elseif event_no == 3 then
    game:start_dialog("fern.tip") -- Tell tips on item.
  elseif event_no > 3 then
    game:start_dialog("fern.hello2") -- When revisit, greet from bench.
  end
end

local function next_dialog(answer)
  if answer == 1 then
    game:start_dialog("fern.yes", confirm)
  else
    game:start_dialog("fern.no")
  end
end

-- Increase event var for fern house.
local function confirm()
   event_no = event_no + 1
end