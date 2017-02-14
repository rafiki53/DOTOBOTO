local utils = require( GetScriptDirectory().."/Utility" )

local EyeRange=1200;

function GetDesire()
	if DotaTime() < 900 then
		return 0.3;
	end
	return 0.0;
end

local function getDesiredPos()
	mid = GetLaneFrontLocation(TEAM_RADIANT, LANE_MID, 0.0) - Vector(100,100);
	--print (mid);
	--DebugDrawCircle(mid, 100, 0.5, 0.5, 0.5);
	local npcBot=GetBot();
	
	local EnemyCreeps = npcBot:GetNearbyLaneCreeps(EyeRange,true);
	local WeakestCreep, WeakestCreepHealth = utils.GetWeakestCreep(EnemyCreeps);
	if WeakestCreep == nil or WeakestCreepHealth == WeakestCreep:GetMaxHealth() then 
		return mid; 
	end;
	
	
	local EnemyHeroes = npcBot:GetNearbyHeroes(EyeRange, true, BOT_MODE_NONE);
	if #EnemyHeroes == 0 then
		return WeakestCreep:GetLocation() + Vector(-80, -80);
	end
	
	enemy = EnemyHeroes[1];
	direction_vector = WeakestCreep:GetLocation() - enemy:GetLocation();
	norm = math.sqrt(direction_vector[1] * direction_vector[1] + direction_vector[2] * direction_vector[2]);
	
	range = npcBot:GetAttackRange();
	scalar = 1.0 * range / norm;
	DesiredLocation = WeakestCreep:GetLocation() + direction_vector * scalar;
	return DesiredLocation;
end

local function LastHit()

	local npcBot=GetBot();
	
	local EnemyCreeps = npcBot:GetNearbyLaneCreeps(EyeRange,true);
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

	local npcBot=GetBot();

	local AllyCreeps = npcBot:GetNearbyLaneCreeps(EyeRange,false);
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

local function Harass()

	local npcBot=GetBot();
	
	local EnemyCreeps = npcBot:GetNearbyLaneCreeps(EyeRange,true);
	local EnemyHeroes = npcBot:GetNearbyHeroes(EyeRange, true, BOT_MODE_NONE);
	
	if #EnemyHeroes == 0 then
		return;
	end
	
	enemy = EnemyHeroes[1]
	
	if #EnemyCreeps > 0 and GetUnitToUnitDistance( npcBot, EnemyHeroes[1] ) > GetUnitToUnitDistance( npcBot, enemy ) then
		return;
	end
	
	npcBot:Action_AttackUnit(enemy, false);
	
end

function Think()
	
	local npcBot=GetBot();
	
	if ( npcBot:IsUsingAbility() or not npcBot:IsAlive()) then return end;
	
	if LastHit() then return end;
	if Deny() then return end;
	if Harass() then return end;
	local pos = getDesiredPos();
	npcBot:Action_MoveToLocation(pos);
end