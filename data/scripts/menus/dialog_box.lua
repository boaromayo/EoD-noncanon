-- Set up dialog box for the game.
-- Dialog box is a menu object.

local game = ...

local dialog_box = {
  -- Default dialog settings.
  dialog = nil          -- No dialog available.
  visible = false       -- Set to invisible during gameplay.
  info = nil            -- Parameters for additional dialog info.
  first = true          -- If this is the first line in game.
  answer = nil          -- Selected answer.

  -- One-at-a time letter settings.
  
  -- Graphics settings.
  surface = nil         -- Create surface.
}

-- Initialize dialog box.
function game:initialize_dialog_box()
  game.dialog_box = dialog_box

  -- Initialize drawing surface.
  dialog_box.surface = sol.surface.create("sprites/hud/dialog_box.png")
  dialog_box.surface:set_opacity(216)
end

-- Game method that starts dialog with dialog box.
function game:on_dialog_started(dialog, info)
  dialog_box.dialog = dialog
  dialog_box.info = info
  sol.menu.start(game, dialog_box)
end

-- Game method when dialog box is finished.
function game:on_dialog_finished(dialog)
  sol.menu.stop(dialog_box)
  dialog_box.dialog = nil
  dialog_box.info = nil
end

-- When dialog box is open.
function dialog_box:on_started()
  
end

-- When dialog box is finished.
function dialog_box:on_finished()

end

-- Draw dialog box.
function dialog_box:on_draw(surface)
  
end

-- Events called when player presses a key.
function dialog_box:on_key_pressed(key)

end