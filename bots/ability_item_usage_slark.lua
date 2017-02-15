local npcBot=GetBot();
local Q = npcBot:GetAbilityByName( "slark_dark_pact" )
local W = npcBot:GetAbilityByName( "slark_pounce" )
local E = npcBot:GetAbilityByName( "slark_essence_shift" )
local R = npcBot:GetAbilityByName( "slark_shadow_dance" )
	
local function UseCombo()

	if not Q:IsFullyCastable() or not W:IsFullyCastable() then
		return;
	end
	
	if npcBot:GetActiveMode() ~= BOT_MODE_ATTACK then
		return;
	end
	
	enemy = npcBot:GetTarget();
	if GetUnitToUnitDistance( npcBot, enemy ) > 500 then
		return;
	end
	
	print("ATTACK")
	npcBot:ActionPush_UseAbility( W );
	npcBot:ActionPush_UseAbility( Q );

end


local function Retreat()
	
	if npcBot:GetActiveMode() ~= BOT_MODE_RETREAT then
		return
	end
	
	Enemies = npcBot:GetNearbyHeroes( 700, true, BOT_MODE_NONE )
    n = #Enemies
    if n == 0 then return end
    
    
    if R:IsFullyCastable()
    then
		npcBot:Action_ClearActions( false )
        npcBot:ActionPush_UseAbility( R )
    end
    
    if not npcBot:HasModifier( "modifier_slark_shadow_dance" ) and W:IsFullyCastable()
    then
    
        m = Vector( 0, 0 )
        for _, E in ipairs( Enemies )
        do
            v = E:GetLocation()
            if v then m = m + v else n = n - 1 end
        end
        m = m / n
        
        u = npcBot:GetLocation() - m
        u = u / math.sqrt( u.x * u.x + u.y * u.y )
        
        f = npcBot:GetFacing() / 180 * 3.1415
        v.x = math.cos( f )
        v.y = math.sin( f )
        
        if u.x * v.x + u.y * v.y > 0.5 
        then
            npcBot:Action_UseAbility( W )
        end
        
    end
	
end

function AbilityUsageThink()

	if npcBot:IsUsingAbility() or npcBot:IsChanneling() then
		return;
	end
	
	UseCombo();
	Retreat();

end


