-- Set up dialog box for the game.
-- Dialog box is a menu object.

local game = ...
local map = game:get_map()

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
  iterator = nil,        -- Iterator for next line in dialog.
  lines = {},            -- Table for the lines in dialog.
  line_surfaces = {},    -- Table for the text surfaces.
  index = 0,             -- Index for line shown.
  char_index = 0,        -- Index for character in current line.
  char_delay = 0,        -- In-between delay when displaying one-character-at-a-time.
  full = false,          -- If dialog box is full, or all lines in box are shown.
  letter_sound = false,  -- If letter-at-a-time sound is played.
  
  -- Graphics settings.
  surface = nil,              -- Dialog surface.
  box_surface = nil,          -- Dialog box.
  decision_box_surface = nil, -- Dialog decision box.
  decision_icon_surface = nil -- Dialog decision icon.

  -- Positions for surfaces.
  box_position = nil,           -- For dialog box.
  decision_box_position = nil,  -- For decision box.
  decision_icon_position = nil, -- For decision cursor icon.
}

-- CONSTANTS.
local visible_lines = 4     -- There are four lines in game.
local width = 220           -- Set size of dialog box.
local height = 112
local decision_width = 48
local decision_height = 48

local char_delays = { 
  fastest = 10, 
  fast = 20, 
  normal = 40, 
  normal_slow = 50, 
  slow = 60, 
  slowest = 80 
} -- One-at-a-time character display delays (fastest to slowest).

-- Initialize dialog box.
function game:initialize_dialog_box()
  game.dialog_box = dialog_box

  -- Font settings.
  local font = "lunchds.ttf"
  local font_size = 24

  -- Initialize drawing surface.
  dialog_box.surface = sol.surface.create("menus/dialog_box.png")

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
  local cam_w, cam_h = map:get_camera():get_size()

  local x = cam_w / 2 - self.surface:get_width()
  local y = cam_h - 10

  -- Set positions of dialog images.
  self.box_position = { x = x, y = y }
  self.decision_box_position = { x = x + 16, y = y + height }
  self.decision_icon_position = { x = x, y = y + height - 45 }

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
  dialog_box.next_line = dialog_box.iterator
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

  -- Check if decision dialog.
  if dialog.answer == "1" then
    dialog_box.answer = 1 -- Answer either yes (1) or no (2).
  end

  dialog_box:show_lines()
end

-- Write out characters to dialog box.
local function show_characters()

  while not dialog_box.full and
      dialog_box.char_index > #dialog_box.lines[dialog_box.index] do
    -- Check if line finished.
    dialog_box.char_index = 1
    dialog_box.is_full()
  end
end

-- Check if there are more lines to display.
function dialog_box:has_more_lines()
  return self.next_line ~= nil
end

-- Check if dialog box is full. 
-- By "full", this means that all of the lines in
-- the dialog box are fully displayed.
function dialog_box:is_full()
  self.full = (dialog_box.line_index >= visible_lines) and 
    (dialog_box.char_index > #dialog_box.lines[visible_lines])
  return self.full
end

-- Drawing method.
function dialog_box:on_draw(screen)
  local x, y = self.box_position.x, self.box_position.y

  self.surface:clear()

  -- Draw dialog box.
  self.box_surface:draw_region(0, 0, 
    width, height, self.surface, x, y)

  -- Draw text.
  local text_x = 12
  local text_y = y
  for i = 1, visible_lines do
    text_y = text_y + 24
    self.line_surfaces[i]:draw(self.surface, text_x, text_y)
  end

  -- Draw decision box and cursor.
  --[[if self.answer ~= nil and 
      self:is_full and 
      self:has_more_lines() then
  end--]]

  -- Do not draw anything at end-of-dialog.

  -- Draw to screen.
  self.surface:draw(screen)
end

-- Events called when player presses a key.
function dialog_box:on_key_pressed(key)

  if key == "return" then
    skipped = true
  elseif key == "space" then
    self.char_delay = char_delays["fastest"]
  end

end