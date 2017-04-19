local item = ...
local game = item:get_game()

-- Make settings when item is created.
function item:on_created()
    --self:set_shadow("small")
    self:set_can_disappear(true)
    self:set_brandish_when_picked(false)
    --self:set_sound_when_picked("coin-clink")
end

-- Set values when item picked up.
function item:on_obtaining(variant, savegame_variable)
    -- set weights of coin.
    local amounts = { 1, 5, 10, 20, 50, 100 }
    local amount = amounts[variant]

    game:add_money(amount)
end