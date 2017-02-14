Utility = require( GetScriptDirectory().."/Utility");

local Abilities ={
"legion_commander_overwhelming_odds",
"legion_commander_press_the_attack",
"legion_commander_moment_of_courage",
"legion_commander_duel"
};

local function UseW()
	local npcBot=GetBot();
	
	local ability=npcBot:GetAbilityByName(Abilities[2]);
	if ability:IsFullyCastable() then
		npcBot:Action_UseAbilityOnEntity(ability,npcBot);
	end
end

function AbilityUsageThink()
	local npcBot=GetBot();
	
	if npcBot:IsUsingAbility() or npcBot:IsChanneling() then
		return;
	end
	
	--local Score=0;
	enemy = npcBot:GetTarget();
	if(enemy == nil or not enemy:IsHero()) then
		return;
	end
	--[[,Score=FindTarget();
	if Target==nil or npcBot:GetHealth()/npcBot:GetMaxHealth() < 0.37  or Score < 0.5 then
		isRoaming=false;
		npcBot.isRoaming=false;
		return;
	end
	]]--
	local aw=npcBot:GetAbilityByName(Abilities[2]);
	local ar=npcBot:GetAbilityByName(Abilities[4]);
	local blink = Utility.IsItemAvailable("item_blink");
	
	local dist=GetUnitToUnitDistance(enemy,npcBot);
	
	local cb = (blink ~= nil and blink:IsFullyCastable())
	local cw = (aw ~= nil and aw:IsFullyCastable())
	local cr = (ar ~= nil and ar:IsFullyCastable())
	
	print("cb ", cb)
	print("cw ", cw)
	print("cr ", cr)
	print("dist ", dist)
	
	if cb and cw and cr and (dist < 1200) and not npcBot:HasModifier("modifier_legion_commander_press_the_attack") then
		npcBot:Action_UseAbilityOnEntity(aw,npcBot);
		return;
	end	
	
	if cb and cr and (dist < 1200) and npcBot:HasModifier("modifier_legion_commander_press_the_attack") then
		npcBot:Action_UseAbilityOnLocation(blink, enemy:GetLocation())
		return;
	end
	
	if cr and dist < 150 then
		npcBot:Action_UseAbilityOnEntity(ar,enemy);
		return;
	end

	if npcBot:GetMaxHealth() - npcBot:GetHealth() > 200 then
		UseW();
	end
end

function CourierUsageThink()
	local npcBot=GetBot();
	if not IsCourierAvailable() then
		return
	end
	local courier = GetCourier(0)
	--print (GetCourierState(courier));
	--print(npcBot:GetStashValue())
	--print(npcBot:IsAlive())	
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

function ItemUsageThink()
	Utility.UseItems();
end


function BuybackUsageThink()
end