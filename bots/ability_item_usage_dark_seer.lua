Utility = require( GetScriptDirectory().."/Utility");

local npcBot=GetBot();
local ion_shell=npcBot:GetAbilityByName("dark_seer_ion_shell");
local surge = npcBot:GetAbilityByName("dark_seer_surge")
local vacuum = npcBot:GetAbilityByName("dark_seer_vacuum")
local wall = npcBot:GetAbilityByName("dark_seer_wall_of_replica")

local combo_target = nil;
local queue_time = 0;
local last_time = DotaTime();
local function SoulAndIonShell(bot)

	local soulring=Utility.IsItemAvailable("item_soul_ring");
	if soulring ~= nil and soulring:IsFullyCastable() and npcBot:GetHealth()/npcBot:GetMaxHealth() > 0.6 and ion_shell:IsCooldownReady() then
		npcBot:ActionQueue_UseAbility(soulring);
		queue_time = 0.5
	end
	if ion_shell:IsFullyCastable() then
		npcBot:ActionQueue_UseAbilityOnEntity(ion_shell,bot);
		queue_time = 0.5
		return true;
	end
	

			
	
	return false
end

local function SpamIonShell()
	--allied creeps
	local creeps=npcBot:GetNearbyCreeps(1300,false)
	
	for _,creep in pairs(creeps) do
		if(creep:GetAttackRange()==100 and creep:GetHealth()>350 and not(creep:HasModifier("modifier_dark_seer_ion_shell")) )then
			return SoulAndIonShell(creep)
		end
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
	local prev_time = last_time
	last_time = DotaTime() 
	queue_time = queue_time - (last_time-prev_time)
	
	if npcBot:IsUsingAbility() or npcBot:IsChanneling()  then
		return;
	end
	if queue_time<0  and npcBot:NumQueuedActions()~=0 then 
		npcBot:Action_ClearActions( false )
	end
	if npcBot:NumQueuedActions()~=0 then
		return
	end
	--if many enemies and alliez use vacuum+wall(requires at least vacuum)
	local locationAoE = npcBot:FindAoELocation(true, true, npcBot:GetLocation(), vacuum:GetCastRange(),vacuum:GetSpecialValueInt( "radius"  ), vacuum:GetCastPoint(), 0)
	
	if locationAoE.count>1  then
		
		if vacuum:IsFullyCastable() then
			
			combo_target = locationAoE.targetloc
			
			npcBot:Action_UseAbilityOnLocation(vacuum,combo_target)
			npcBot:ActionQueue_UseAbilityOnLocation(wall,combo_target);
			queue_time = 1.5
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
	
	
	
	
	--cast surge offensively
	local attacking_allies = npcBot:GetNearbyHeroes(1500,false,BOT_MODE_ATTACK)
	
	if #attacking_allies> #npcBot:GetNearbyHeroes(1500,true,BOT_MODE_NONE) and #attacking_allies>1  then
		if(SurgePlayer(attacking_allies[2])) then
			return 
		end
	end
	
	

	--if in farm or lane mode spam ion shell on creeps
	if( currMode == BOT_MODE_LANING or currMode == BOT_MODE_FARM) then
		--spam ion shell on creeps
		if SpamIonShell() then
			return;
		end
	end
	--if appropriate mode is selected spam ion shell on heroes
	if ( currMode == BOT_MODE_ATTACK or currMode==BOT_MODE_PUSH_TOWER_TOP or currMode==BOT_MODE_PUSH_TOWER_MID or currMode==BOT_MODE_PUSH_TOWER_BOT or currMode==BOT_MODE_PUSH_TOWER_TOP  or currMode==BOT_MODE_DEFEND_TOWER_MID or currMode==BOT_MODE_DEFEND_TOWER_BOT or currMode==BOT_MODE_DEFEND_TOWER_TOP) then
		if not(npcBot:HasModifier("modifier_dark_seer_ion_shell")) then
			if SoulAndIonShell(npcBot)then
				return
			end
		end
		for _,ally in pairs(npcBot:GetNearbyHeroes(1000,false,npcBot:GetActiveMode())) do
			if ally:GetAttackRange()== 150 and not(ally:HasModifier("modifier_dark_seer_ion_shell")) then
				if SoulAndIonShell(ally)then
					return
				end
			end
		end
	end
	
end

function BuybackUsageThink()
	local npcBot=GetBot()
	if DotaTime() < 2400 then
		return
	elseif npcBot:HasBuyback() and (not npcBot:IsAlive()) then
		npcBot:ActionImmediate_Buyback()
	end
end

function CourierUsageThink()
	local npcBot=GetBot();
	if not IsCourierAvailable() then
		return
	end
	local courier = GetCourier(0);
	--print (GetCourierState(courier));
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
