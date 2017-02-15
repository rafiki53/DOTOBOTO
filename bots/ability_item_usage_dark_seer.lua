Utility = require( GetScriptDirectory().."/Utility");

local npcBot=GetBot();
local ion_shell=npcBot:GetAbilityByName("dark_seer_ion_shell");
local surge = npcBot:GetAbilityByName("dark_seer_surge")
local vacuum = npcBot:GetAbilityByName("dark_seer_vacuum")
local wall = npcBot:GetAbilityByName("dark_seer_wall_of_replica")

local combo_target = nil;

local function SpamIonShell()
	--allied creeps
	
		
	local creeps=npcBot:GetNearbyCreeps(1300,false)
	
	--print(GetTeam());
	for _,creep in pairs(creeps) do
		if(creep:GetAttackRange()==100 and creep:GetHealth()>350 and not(creep:HasModifier("modifier_dark_seer_ion_shell")) )then
			local soulring=Utility.IsItemAvailable("item_soul_ring");
			if soulring ~= nil and soulring:IsFullyCastable() and npcBot:GetHealth()/npcBot:GetMaxHealth() > 0.6  then
				npcBot:Action_UseAbility(soulring);
				return true;
			end
			if ion_shell:IsFullyCastable() then
			
				npcBot:Action_UseAbilityOnEntity(ion_shell,creep);
				return true
			end
			
		end
	
	end
	return false
			
	
end
local function IonShellPlayer(bot)
	if ion_shell:IsFullyCastable() then
			
		npcBot:Action_UseAbilityOnEntity(ion_shell,bot);
		return true
	end
			
	
	return false
end

local function SurgePlayer(bot)
	if surge:IsFullyCastable() then
		npcBot:Action_UseAbilityOnEntity(surge,bot);
		return true
	end
	return false
end
function AbilityUsageThink()
	
	

	
	--if not casting
	local currMode = npcBot:GetActiveMode();
	if npcBot:IsUsingAbility() or npcBot:IsChanneling() then
		return;
	end
	
	
	if combo_target ~= nil then
		local target = combo_target
		combo_target = nil
		if wall:IsFullyCastable() then
			npcBot:Action_UseAbilityOnLocation(wall,target);
			return
			
		end
		
	end
	
	--if many enemies and alliez use vacuum+wall(requires at least vacuum)
	
	local locationAoE = npcBot:FindAoELocation(true, true, npcBot:GetLocation(), vacuum:GetCastRange(),vacuum:GetSpecialValueInt( "radius"  ), vacuum:GetCastPoint(), 0)
	--@maybe add condition for nearby allies, so you dont attack alone, maybe mana condition
	if locationAoE.count>2  then
		
		if vacuum:IsFullyCastable() then
			
			combo_target = locationAoE.targetloc
			
			npcBot:Action_UseAbilityOnLocation(vacuum,combo_target)
			return
		end
		
	end
	
	
	
	
	
	
	
	--if you or some allies are in retreat mode, cast surge
	if(npcBot:GetActiveMode()==BOT_MODE_RETREAT) then
	
		if(SurgePlayer(npcBot))then
			return 
		end
	end
	for _,ally in pairs(npcBot:GetNearbyHeroes(1000,false,BOT_MODE_RETREAT)) do
		if(SurgePlayer(ally))then
			return 
		end
	end
	
	
	
	
	--@cast surge offensively? 
	--@or when noone around?
	
	

	--if in farm or lane mode spam ion shell on creeps
	if( currMode == BOT_MODE_LANING or currMode == BOT_MODE_FARM) then
		--spam ion shell on creeps
		if(SpamIonShell())then
			return
		end
	end
	--if appropriate mode is selected spam ion shell on heroes
	if ( currMode == BOT_MODE_ATTACK or currMode==BOT_MODE_PUSH_TOWER_TOP or currMode==BOT_MODE_PUSH_TOWER_MID or currMode==BOT_MODE_PUSH_TOWER_BOT or currMode==BOT_MODE_PUSH_TOWER_TOP  or currMode==BOT_MODE_DEFEND_TOWER_MID or currMode==BOT_MODE_DEFEND_TOWER_BOT or currMode==BOT_MODE_DEFEND_TOWER_TOP) then
		if npcBot:GetAttackRange()== 150 and not(npcBot:HasModifier("modifier_dark_seer_ion_shell")) then
			if IonShellPlayer(npcBot)then
				return
			end
		end
		for _,ally in pairs(npcBot:GetNearbyHeroes(1000,false,npcBot:GetActiveMode())) do
			if ally:GetAttackRange()== 150 and not(ally:HasModifier("modifier_dark_seer_ion_shell")) then
				if IonShellPlayer(ally)then
					return
				end
			end
		end
	end
	
end
function CourierUsageThink()
	local npcBot=GetBot();
	if not IsCourierAvailable() then
		return
	end
	local courier = GetCourier(0);
	if (npcBot:IsAlive() and (npcBot:GetStashValue() > 0 or npcBot:GetCourierValue() > 0) ) then
		npcBot:ActionImmediate_Courier(courier, COURIER_ACTION_TAKE_AND_TRANSFER_ITEMS);
		npcBot.CourierMoving = true;
		return;
	end
	
	if npcBot.CourierMoving and GetCourierState(courier) ~= COURIER_STATE_DELIVERING_ITEMS then
		npcBot:ActionImmediate_Courier(courier, COURIER_ACTION_RETURN);
		npcBot.CourierMoving = false;
	end
end
