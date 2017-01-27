local utils = require( GetScriptDirectory().."/Utility" )

local EyeRange=1200;
local npcBot=GetBot();

local function HandleRefraction()
	if ( npcBot:IsUsingAbility()) then 
		return 0;
	end;
	local EnemyCreeps = npcBot:GetNearbyCreeps(EyeRange,true);
	local EnemyHeroes = npcBot:GetNearbyHeroes(EyeRange, true, BOT_MODE_NONE);
	local WeakestCreep, WeakestCreepHealth = utils.GetWeakestCreep(EnemyCreeps);
	if ( #EnemyHeroes == 0 and #EnemyCreeps == 0 ) then 
		return 0;
	end
	return 1;
end

local function getDesiredPos()
	local EnemyCreeps = npcBot:GetNearbyCreeps(EyeRange,true);
	local WeakestCreep, WeakestCreepHealth = utils.GetWeakestCreep(EnemyCreeps);
	if WeakestCreep == nil then return Vector(-700, -700) end;
	return WeakestCreep:GetLocation() + Vector(-50, -50);
end

local function LastHit()
	local EnemyCreeps = npcBot:GetNearbyCreeps(EyeRange,true);
	local WeakestCreep, WeakestCreepHealth = utils.GetWeakestCreep(EnemyCreeps);
	AttackRange=npcBot:GetAttackRange();
	AttackSpeed=npcBot:GetAttackPoint();
	
	local damage = 80;
	if WeakestCreep ~= nil then
		damage = npcBot:GetEstimatedDamageToTarget( true, WeakestCreep, npcBot:GetSecondsPerAttack(), DAMAGE_TYPE_PHYSICAL ); 
	end
	if WeakestCreep ~= nil and WeakestCreepHealth < damage then
		npcBot:Action_AttackUnit(WeakestCreep, true);
		return 1;
	end
end

local function Deny()
	local AllyCreeps = npcBot:GetNearbyCreeps(EyeRange,false);
	local WeakestCreep, WeakestCreepHealth = utils.GetWeakestCreep(AllyCreeps);
	AttackRange=npcBot:GetAttackRange();
	AttackSpeed=npcBot:GetAttackPoint();
	
	local damage = 80;
	if WeakestCreep ~= nil then
		damage = npcBot:GetEstimatedDamageToTarget( true, WeakestCreep, npcBot:GetSecondsPerAttack(), DAMAGE_TYPE_PHYSICAL ); 
	end
	if WeakestCreep ~= nil and WeakestCreepHealth < damage then
		npcBot:Action_AttackUnit(WeakestCreep, true);
		return 1;
	end
end

function Think() 
	if ( npcBot:IsUsingAbility() or not npcBot:IsAlive()) then return end;
	
	useRefraction = HandleRefraction()
	if useRefraction == 1 then
		abilityREF = npcBot:GetAbilityByName( "templar_assassin_refraction" );
		if abilityREF:IsCooldownReady() then
			npcBot:Action_UseAbility(abilityREF);
			return;
		end
	end
	
	if ( npcBot:IsUsingAbility() ) then return end;
	
	if LastHit() then return end;
	if Deny() then return end;
	local pos = getDesiredPos();
	npcBot:Action_MoveToLocation(pos);
end