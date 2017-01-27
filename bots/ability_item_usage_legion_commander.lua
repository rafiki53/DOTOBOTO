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
	
	if npcBot:GetMaxHealth() - npcBot:GetHealth() > 200 then
		UseW();
	end
end
--[[
function CourierUsageThink()
	local npcBot=GetBot();
	local courier = GetCourier(0);
	
	if (npcBot:IsAlive() and (npcBot:GetStashValue()>900 or npcBot:GetCourierValue()>0 or Utility.HasRecipe()) and IsCourierAvailable()) then
		npcBot:Action_Courier(courier , COURIER_ACTION_RETURN);
		npcBot:Action_Courier(courier , COURIER_ACTION_TAKE_AND_TRANSFER_ITEMS);
	end
end
]]--

function ItemUsageThink()
	Utility.UseItems();
end


function BuybackUsageThink()
end