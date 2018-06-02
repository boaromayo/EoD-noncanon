-- Lua script of map Fir House, a place where Fern, a lone woman, lives.
-- This script is executed every time the hero enters this map.

-- Feel free to modify the code below.
-- You can add more events and remove the ones you don't need.

-- See the Solarus Lua API documentation:
-- http://www.solarus-games.org/doc/latest

local map = ...
local game = map:get_game()
local fern = map:get_entity("Fern")

-- Check event conditions.
local fern_quest = game:get_value("fern")

-- Event called as soon as this map is loaded.
function map:on_started()
  -- Check if quest finished, move Fern
  -- to shop bench if it is.
  if fern_quest == 5 then
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
no_item: ask if hero has item
weapon: chest has a weapon to use
tip: give tips on item
reward: praise player and give prize
--=========================
--]]
function map:fern_dialog()
  -- In any case fern event was not initialized.
  if fern_quest == nil then
    fern_quest = 0
    game:set_value("fern", 0)
  end
  -- After getting weapon in chest,
  -- have her ask if hero has item.
  if game:get_value("c1") == true then
    game:set_value("fern", 3)
    fern_quest = game:get_value("fern")
  end
  -- Introduce fern to player.
  if fern_quest == 0 then
    print("fern active")
    game:start_dialog("fern.hello", function()
      game:start_dialog("fern.request", function(answer)
        if answer == 1 then -- If yes.
          game:start_dialog("fern.yes", function()
            game:start_dialog("fern.weapon")
            game:set_value("fern", 1)
            fern_quest = game:get_value("fern")
          end)
        else -- If no, be disappointed.
          game:start_dialog("fern.no")
        end
      end)
    end) -- Call decision function.
  elseif fern_quest == 1 then
    game:start_dialog("fern.weapon") -- Mention weapon in chest.
    game:set_value("fern", 2)
    fern_quest = game:get_value("fern")
  elseif fern_quest == 2 then
    game:start_dialog("fern.tip") -- Tell tips on item.
    game:set_value("fern", 1)
    fern_quest = game:get_value("fern")
  elseif fern_quest == 3 then
    game:start_dialog("fern.no_item") -- If item not found yet.
  elseif fern_quest == 4 then
    game:start_dialog("fern.reward") -- Give reward if quest finished.
    game:get_reward("very-important-item") -- Rewards very important item.
    game:set_value("fern", 5)
    fern_quest = game:get_value("fern")
  else
    game:start_dialog("fern.hello2") -- When revisit, greet from bench.
  end
end