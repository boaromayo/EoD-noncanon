-- Set up dialog box for the game.
-- Dialog box is a menu object.

local game = ...

local dialog_box = {
  -- Default dialog settings.
  dialog = nil,          -- No dialog available.
  info = nil,            -- Info to put dialog box in.
  icon_index = 1,        -- Index for icon for question and end dialog.
  first = true,          -- If this is the first dialog in game.
  skipped = false,       -- If dialog is skipped.
  answer = nil,          -- Selected answer (1 or 2) for decision-making.

  -- One-at-a time letter settings.
  next_line = false,     -- Is next line?
  iterator = nil,        -- Counter for next line in dialog.
  lines = {},            -- Table for the lines in dialog.
  line_surfaces = {},    -- Table for the text surfaces.
  index = 0,             -- Index for line shown.
  char_index = 0,        -- Index for character in current line.
  char_delay = 0,        -- Delay when displaying one-character-at-a-time.
  full = false,          -- If dialog box is full, or all lines in box are shown.
  letter_sound = false,  -- If letter-at-a-time sound is played.
  
  -- Graphics settings.
  surface = nil,              -- Dialog surface.
  box_surface = nil,          -- Dialog box.
  arrow_sprite = nil,         -- Dialog arrow icon (for question or next dialog).

  -- Positions for surfaces.
  box_position = nil,           -- For dialog box.
  decision_box_position = nil,  -- For decision box.
  decision_icon_position = nil  -- For decision cursor icon.
}

-- CONSTANTS.
local visible_lines = 4     -- There are four lines in game.
local width = 220           -- Set size of dialog box.
local height = 84
local decision_width = 48
local decision_height = 48

local char_delays = { 
  fastest = 10, 
  fast = 20, 
  normal = 40, 
  normal_slow = 50, 
  slow = 60, 
  slowest = 80 
} -- Character display delays in-between characters (fastest to slowest).

-- Initialize dialog box.
function game:initialize_dialog_box()
  game.dialog_box = dialog_box

  -- Font settings.
  local font = "lunchds"
  local font_size = 16

  -- Initialize drawing surface.
  dialog_box.surface = sol.surface.create(sol.video.get_quest_size())
  dialog_box.box_surface = sol.surface.create("menus/dialog_box.png")
  dialog_box.arrow_sprite = sol.sprite.create("menus/dialog_box_message_cursor")
  
  -- Initialize text lines.
  for i = 1, visible_lines do
    dialog_box.lines[i] = ""
    dialog_box.line_surfaces[i] = sol.text_surface.create({
      horizontal_alignment = "left",
      vertical_alignment = "top",
      font = font,
      font_size = font_size
    })
  end
end

-- Quit dialog box.
function game:quit_dialog_box()
  if dialog_box ~= nil then
    if game:is_dialog_enabled() then
      sol.menu.stop(dialog_box)
    end
    game.dialog_box = nil
  end
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
  -- Initialize properties of dialog box.
  self.char_delay = char_delays["normal"]

  -- Position dialog box on screen.
  local camera = game:get_map():get_camera()
  local cam_w, cam_h = camera:get_size()

  local x = cam_w / 2 - (width / 2)
  local y = cam_h - (height + 16)

  -- Set positions of dialog images.
  self.box_position = { x = x, y = y }
  self.decision_box_position = { x = x, y = y - 50 }
  self.decision_icon_position = { x = x + 8, y = y - 42 }

  self:show_dialog()
end

-- When dialog box is finished and closed.
function dialog_box:on_finished()
end

-- Show dialog box.
function dialog_box:show_dialog()
  local dialog = self.dialog

  -- If info is available, draw text.
  if dialog_box.info ~= nil then
    -- Count variables as well.
    dialog.text = dialog.text:gsub("%$v", dialog_box.info)
  end

  -- Split text into lines.
  dialog.text = dialog.text:gsub("\r\n", "\n"):gsub("\r", "\n")
  dialog_box.iterator = dialog.text:gmatch("([^\n]*)\n") -- Every line plus empty lines are counted.
  dialog_box.next_line = dialog_box.iterator()
  dialog_box.index = 1
  dialog_box.char_index = 1
  dialog_box.skipped = false
  dialog_box.full = false
  dialog_box.letter_sound = false -- Change if letter sound imported.

  -- Check if icon is visible.
  if dialog.icon == nil then
    dialog_box.icon_index = 1
  else
    dialog_box.icon_index = dialog.icon
  end

  -- Check if dialog is a question.
  if dialog.question == "1" then
    dialog_box.answer = 1 -- Answer either yes (1) or no (2).
  end

  dialog_box:show_more_lines()
end

-- Write out characters to dialog box.
local function show_character()
  local dialog = dialog_box

  dialog:is_full() -- Check for "full" line.
  while not dialog.full and
      dialog.char_index > #dialog.lines[dialog.index] do
    -- Check if line finished.
    dialog.char_index = 1
    dialog.index = dialog.index + 1
    dialog:is_full()
  end

  if not dialog.full then
    dialog:add_character()
  else
    if dialog:has_more_lines()
        or dialog.dialog.next ~= nil then
      dialog.arrow_sprite:set_animation("next")
      --game:set_custom_command("action", "next")
    elseif dialog.answer ~= nil then
      dialog.arrow_sprite:set_animation("question")
    else
      dialog.arrow_sprite:set_animation("last")
      --game:set_custom_command("action", "return")
    end
    --game:set_custom_command("attack", nil)
  end
end

-- Check if there are more lines to display.
function dialog_box:has_more_lines()
  return self.next_line ~= nil
end

-- Show 4 more lines of dialog 
-- if no more lines are available.
function dialog_box:show_more_lines()

  if not self:has_more_lines() then
    self:show_next_dialog()
    return
  end

    -- Prep the next 4 lines.
  for i = 1, visible_lines do
    self.line_surfaces[i]:set_text("")
    if self:has_more_lines() then
      self.lines[i] = self.next_line
      self.next_line = self.iterator()
    else
      self.lines[i] = ""
    end
  end
  self.index = 1
  self.char_index = 1 

  -- Delay the one-by-one character display.
  sol.timer.start(self, self.char_delay, show_character)
end

-- Show the next lines of dialog.
function dialog_box:show_next_dialog()

  local next_dialog_id
  if self.answer ~= 2 then -- If no question or first answer available
    next_dialog_id = self.dialog.next
  else
    -- If second answer selected
    next_dialog_id = self.dialog.next2
  end

  if next_dialog_id ~= nil then
    -- Show the next dialog if available.
    self.first = false
    self.answer = nil
    self.dialog = sol.language.get_dialog(next_dialog_id)
    self:show_dialog()
  else
    -- Finish dialog and return answer or nil if no question raised.
    local decision = self.answer

    -- Handle shop functions.
    if self.dialog.id == "shop.question" then
      -- Shop function needs an answer before exiting shop screen.
      decision = self.answer == 1
    end

    self.answer = nil -- Prevents decision box from appearing after decision made.
    game:stop_dialog(decision)
  end
end

-- Add a character one-by-one to the dialog box.
-- If the case is a special character, then perform
-- action for character here.
function dialog_box:add_character()
  -- Setup the line and character on line.
  local line = self.lines[self.index]
  local character = line:sub(self.char_index, self.char_index)
  if character == "" then
    error("No character available to add to line.")
  end
  self.char_index = self.char_index + 1
  local more_delay = 0
  local text = self.line_surfaces[self.index]

  -- Check for special characters ($).
  local is_special = false

  -- Special characters:
  -- - $0: delay
  -- - $|: delay for two secs
  -- - $[1-6]: change dialog speed from fastest to slowest
  -- - space: remove delay
  if character == "$" then
    is_special = true
    character = line:sub(self.char_index, self.char_index)
    self.char_index = self.char_index + 1

    if character == "0" then
      more_delay = 1000 -- Delay 1 second.
    elseif character == "|" then
      more_delay = 2000 -- Delay 2 seconds.
    elseif character == "1" then
      -- Fastest.
      self.char_delay = char_delays["fastest"]
    elseif character == "2" then
      -- Fast.
      self.char_delay = char_delays["fast"]
    elseif character == "3" then
      -- Normal.
      self.char_delay = char_delays["normal"]
    elseif character == "4" then
      -- Normal-slow.
      self.char_delay = char_delays["normal_slow"]
    elseif character == "5" then
      -- Slow.
      self.char_delay = char_delays["slow"]
    elseif character == "6" then
      -- Slowest.
      self.char_delay = char_delays["slowest"]
    else
      -- If this is not a special char...
      text:set_text(text:get_text() .. "$")
      is_special = false
    end
  end

  -- Remove delay for whitespace chars.
  if character == " " then
    more_delay = -self.char_delay
  end

  -- Print character to dialog box.
  text:set_text(text:get_text() .. character)

  -- Play sound for each character drawn.
  sol.audio.play_sound("message_letter")
  self.letter_sound = false
  sol.timer.start(self, 100 + self.char_delay, function()
    self.letter_sound = true
  end)

  -- Set delays.
  sol.timer.start(self, self.char_delay + more_delay, show_character)
end

-- Skip showing text one-by-one, show entire text now.
-- If the 4 lines are complete, 
-- show next 4 lines of dialog if more.
function dialog_box:show_all()
  if self.full then
    self:show_more_lines()
  else
    -- Check the end of the current line.
    self:is_full()
    while not self.full do
      while not self.full
          and self.char_index > #self.lines[self.index] do
        self.char_index = 1
        self.index = self.index + 1
        self:is_full()
      end

      if not self.full then
        self:add_character()
      end

      self:is_full()
    end
  end
end


-- Check if dialog box is full. 
-- By "full", this means that all of the lines in
-- the dialog box are fully displayed.
function dialog_box:is_full()
  self.full = (dialog_box.index >= visible_lines) and 
    (dialog_box.char_index > #dialog_box.lines[visible_lines])
  return self.full
end

-- Draw method.
function dialog_box:on_draw(screen)
  local x, y = self.box_position.x, self.box_position.y
  local spacing = 16

  self.surface:clear()

  -- Draw dialog box.
  self.box_surface:draw_region(0, 0, width, height, self.surface, x, y)

  -- Draw text.
  local text_x = x + spacing / 2
  local text_y = y + spacing / 2
  for i = 1, visible_lines do
    -- Draw text to screen and return to next line.
    self.line_surfaces[i]:draw(self.surface, text_x, text_y)
    text_y = text_y + spacing
  end

  -- Draw decision box and cursor.
  if self.answer ~= nil 
      and self.full 
      and not self:has_more_lines() 
      and self.arrow_sprite:get_animation() == "question" then
    local cursor_pos = (self.answer == 1 
      and self.decision_icon_position.y + 14 
      or self.decision_icon_position.y + 32)
    self.decision_box_position.y = self.box_position.y - 48
    self.box_surface:draw_region(0, height, 
      decision_width, decision_height, self.surface, 
      self.decision_box_position.x, self.decision_box_position.y)
    self.arrow_sprite:draw(self.surface, 
      self.decision_icon_position.x, cursor_pos)
  end

  -- Draw next line cursor.
  if self.full 
      and self.arrow_sprite:get_animation() == "next" then
    self.arrow_sprite:draw(self.surface, 
      x + width / 2, y + height - 4)
  end

  -- Draw to screen.
  self.surface:draw(screen)
end

-- Events called when player presses key.
function dialog_box:on_key_pressed(key)

  local handled = false

  if key == "return" or key == "space" then
    if self:is_full() then
      self:show_more_lines()
    elseif self.skipped then
      self:show_all()
    else
      self.skipped = true
    end
    handled = true
  elseif key == "up" or key == "down" 
      or key == "left" or key == "right" then
    if self.answer ~= nil
        and self:is_full()
        and not self:has_more_lines() then
      sol.audio.play_sound("cursor") -- Play cursor sound.
      self.answer = 3 - self.answer -- Switch between 1 (yes) or 2 (no).
    end
    handled = true
  end

  return handled
end