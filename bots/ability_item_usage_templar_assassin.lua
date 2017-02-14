utils = require( GetScriptDirectory().."/Utility");

local EyeRange=1200;

local function UseRefraction()

	local npcBot=GetBot();
	
	local EnemyCreeps = npcBot:GetNearbyLaneCreeps(EyeRange,true);
	local EnemyHeroes = npcBot:GetNearbyHeroes(EyeRange, true, BOT_MODE_NONE);
	local WeakestCreep, WeakestCreepHealth = utils.GetWeakestCreep(EnemyCreeps);
	if ( #EnemyHeroes == 0 and #EnemyCreeps == 0 ) then 
		return;
	end
	
	ability = npcBot:GetAbilityByName( "templar_assassin_refraction" );
	if ability:IsFullyCastable() then
		npcBot:Action_UseAbility(ability);
		return;
	end
end

local function UseMeld()

	local npcBot=GetBot();
	
	ability = npcBot:GetAbilityByName( "templar_assassin_meld" );
	if not ability:IsFullyCastable() then
		return;
	end
	
	local EnemyHeroes = npcBot:GetNearbyHeroes(EyeRange, true, BOT_MODE_NONE);
	if ( #EnemyHeroes == 0) then 
		return;
	end
	
	enemy = EnemyHeroes[1];
	dist = GetUnitToLocationDistance( npcBot, enemy:GetExtrapolatedLocation(0.1) );
	my_range = npcBot:GetAttackRange();
	if (dist > my_range + 1) then
		return;
	end
	
	--npcBot:Action_ClearActions( false )
	npcBot:ActionPush_AttackUnit( enemy, true )
	npcBot:ActionPush_UseAbility(ability)
	
end

local function UseTrap()

	local npcBot=GetBot();
	
	ability = npcBot:GetAbilityByName( "templar_assassin_psionic_trap" );
	if not ability:IsFullyCastable() then
		return;
	end
	
	if npcBot:GetActiveMode() ~= BOT_MODE_ATTACK then
		return;
	end
	--npcBot:Action_ClearActions( false )
	enemy = npcBot:GetTarget();
	if GetUnitToUnitDistance( npcBot, enemy ) > 800 then
		return;
	end
	
	trigger_ability = npcBot:GetAbilityByName("templar_assassin_trap");
	npcBot:ActionPush_UseAbility(trigger_ability);
	
	npcBot:ActionPush_UseAbilityOnLocation(ability, enemy:GetExtrapolatedLocation(0.1));
	
	
end

function AbilityUsageThink()

	local npcBot=GetBot();

	if npcBot:IsUsingAbility() or npcBot:IsChanneling() then
		return;
	end
	
	UseRefraction();
	UseMeld();
	UseTrap();
end


local AbilityPriority = {
	"templar_assassin_refraction",
	"templar_assassin_psi_blades",
	"templar_assassin_refraction",
	"templar_assassin_psi_blades",
	"templar_assassin_refraction",
	"templar_assassin_psionic_trap",
	"templar_assassin_refraction",
	"templar_assassin_meld",
	"templar_assassin_psi_blades",
	"special_bonus_attack_speed_25",
	"templar_assassin_psionic_trap",
	"templar_assassin_psi_blades",
	"templar_assassin_meld",
	"templar_assassin_meld",
	"special_bonus_all_stats_6",
	"templar_assassin_psionic_trap",
	"templar_assassin_meld",
	"special_bonus_attack_damage_40",
	"special_bonus_unique_templar_assassin"
}

function AbilityLevelUpThink() 

	local npcBot = GetBot();
	
	if npcBot:GetAbilityPoints() == 0 then
		return;
	end
	
	if DotaTime() < 0 then
		return;
	end
	
	local ability = npcBot:GetAbilityByName(AbilityPriority[1]);
	
	if (ability~=nil and ability:CanAbilityBeUpgraded() and ability:GetLevel()<ability:GetMaxLevel()) then
		npcBot:ActionImmediate_LevelAbility(AbilityPriority[1]);
		table.remove(AbilityPriority, 1 );
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

