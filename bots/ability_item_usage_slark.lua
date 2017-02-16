
local Bot = GetBot();

local Q = Bot:GetAbilityByName( "slark_dark_pact"     )
local W = Bot:GetAbilityByName( "slark_pounce"        )
local E = Bot:GetAbilityByName( "slark_essence_shift" )
local R = Bot:GetAbilityByName( "slark_shadow_dance"  )


local function UseCombo()

    if Q:IsFullyCastable() and W:IsFullyCastable()
    then

        Enemy = Bot:GetTarget();
        if GetUnitToUnitDistance( Bot, Enemy ) <= 600
        then
            Bot:ActionPush_UseAbility( W );
            Bot:ActionPush_UseAbility( Q );
        end

    end

end


local function Retreat()

    Enemies = Bot:GetNearbyHeroes( 700, true, BOT_MODE_NONE )
    n = #Enemies
    if n == 0 then return end


    if R:IsFullyCastable()
    then
        print( "[Slark] Using shadow dance to retreat. " )
        Bot:ActionPush_UseAbility( R )
    end

    if not Bot:HasModifier( "modifier_slark_shadow_dance" ) and W:IsFullyCastable()
    then

        m = Vector( 0, 0 )
        for _, E in ipairs( Enemies )
        do
            v = E:GetLocation()
            if v then m = m + v else n = n - 1 end
        end
        m = m / n

        u = Bot:GetLocation() - m
        u = u / math.sqrt( u.x * u.x + u.y * u.y )

        f = Bot:GetFacing() / 180 * 3.1415
        v.x = math.cos( f )
        v.y = math.sin( f )

        if u.x * v.x + u.y * v.y > 0.5
        then
            print( "[Slark] Using pounce to retreat. " )
            Bot:Action_UseAbility( W )
        end

    end

end


function AbilityUsageThink()

    if not Bot:IsAlive() or Bot:IsUsingAbility() or Bot:IsChanneling() then return end

    Mode = Bot:GetActiveMode()
        if Mode == BOT_MODE_ATTACK  then UseCombo()
    elseif Mode == BOT_MODE_RETREAT then Retreat()
    end

end


