
local Bot = GetBot()

function AbilityUsageThink()

    if Bot:GetActiveMode() == BOT_MODE_RETREAT
    then
        Enemies = Bot:GetNearbyHeroes( 1200, true, BOT_MODE_NONE )

    end

end


