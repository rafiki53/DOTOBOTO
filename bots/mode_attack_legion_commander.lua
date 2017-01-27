------------------------------------------------------------
--- AUTHOR: PLATINUM_DOTA2 (Pooya J.)
--- EMAIL ADDRESS: platinum.dota2@gmail.com
------------------------------------------------------------

-------
require( GetScriptDirectory().."/mode_attack_generic" )
Utility = require(GetScriptDirectory().."/Utility")
----------


local Abilities ={
"legion_commander_overwhelming_odds",
"legion_commander_press_the_attack",
"legion_commander_moment_of_courage",
"legion_commander_duel"
};


function OnStart()
	mode_generic_attack.OnStart();
end

function OnEnd()
	mode_generic_attack.OnEnd();
end


function GetDesire()
	return mode_generic_attack.GetDesire();
end

local function UseW()
	local npcBot=GetBot();

	local ability=npcBot:GetAbilityByName(Abilities[2]);
	if ability==nil or (not ability:IsFullyCastable()) then
		return false;
	end
	
	local Enemies=npcBot:GetNearbyHeroes(1500,true,BOT_MODE_NONE);
	
	if (Enemies==nil or #Enemies<=1) and (ult~=nil and ult:IsFullyCastable())then
		return false;
	end
	
	if GetUnitToUnitDistance(npcBot,npcBot.Target) >1500 then
		return false;
	end
	
	local center=Utility.GetCenter(Enemies);
	if center~=nil then
		npcBot:Action_UseAbilityOnLocation(ability,center);
	end
	
	return true;
end

local function UseUlt()
	local npcBot=GetBot();
	
	local enemy=npcBot.Target;
	local ability=npcBot:GetAbilityByName(Abilities[4]);
	
	if ability==nil or (not ability:IsFullyCastable()) then
		return false;
	end
	
	if GetUnitToUnitDistance(npcBot.Target,npcBot)<ability:GetCastRange()-100 then
		npcBot:Action_UseAbilityOnEntity(ability,npcBot.Target);
		return true;
	end
	
	return false;
end

function Think()
	mode_generic_attack.Think();
	
	local npcBot=GetBot();
	
	if not npcBot.IsAttacking or npcBot.Target==nil then
		return;
	end
	
	if npcBot:IsChanneling() or npcBot:IsUsingAbility() then
		return;
	end
	
	local Target=npcBot.Target;
	
	local aw=npcBot:GetAbilityByName(Abilities[2]);
	local ar=npcBot:GetAbilityByName(Abilities[4]);
	local blink = Utility.IsItemAvailable("item_blink");
	
	local dist=GetUnitToUnitDistance(Target,npcBot);
	
	local cb = (blink ~= nil and blink:IsFullyCastable())
	local cw = (aw ~= nil and aw:IsFullyCastable())
	local cr = (ar ~= nil and ar:IsFullyCastable())
	
	if cb and cw and cr and (dist < blink:GetCastRange()) and not npcBot:HasModifier("modifier_legion_commander_press_the_attack") then
		npcBot:Action_UseAbilityOnEntity(ability,npcBot);
		return;
	end	
	
	if cb and cr and (dist < blink:GetCastRange()) and npcBot:HasModifier("modifier_legion_commander_press_the_attack") then
		npcBot:Action_UseAbilityOnLocation(blink, Target:GetLocation())
		return;
	end
	
	if ar~=nil and ar:IsFullyCastable() and dist < ar:GetCastRange()-50 then
		npcBot:Action_UseAbilityOnEntity(ar,Target);
		return;
	end
	
	if dist<500 then
		npcBot:Action_AttackUnit(Target,true);	
		return;
	end
	npcBot:Action_AttackUnit(enemy,true);
end

--------
