Utility =  {}

Utility.Inf = 1e15

Utility.Locations = {
["RadiantMediumClose"]=Vector(-1728, -3928),
["RadiantHardClose"]=Vector(-780,-3291),
["RadiantMediumRune"]=Vector(680,-4420),
["RadiantEasy"]=Vector(3137,-4627),
["RadiantHardPull"]=Vector(4527,-4259),

["RadiantBase"]= Vector(-7200,-6666),
["RBT1"]= Vector(4896,-6140),
["RBT2"]= Vector(-128,-6244),
["RBT3"]= Vector(-3966,-6110),
["RMT1"]= Vector(-1663,-1510),
["RMT2"]= Vector(-3559,-2783),
["RMT3"]= Vector(-4647,-4135),
["RTT1"]= Vector(-6202,1831),
["RTT2"]= Vector(-6157,-860),
["RTT3"]= Vector(-6591,-3397),
["RadiantTopShrine"]= Vector(-4229,1299),
["RadiantBotShrine"]= Vector(622,-2555),
["RadiantBotRune"]= Vector(1276,-4129),
["RadiantTopRune"]= Vector(-4351,200),

["DireBase"]= Vector(7137,6548),
["DBT1"]= Vector(6215,-1639),
["DBT2"]= Vector(6242,400),
["DBT3"]= Vector(-6307,3043),
["DMT1"]= Vector(1002,330),
["DMT2"]= Vector(2477,2114),
["DMT3"]= Vector(4197,3756),
["DTT1"]= Vector(-4714,6016),
["DTT2"]= Vector(0,6020),
["DTT3"]= Vector(3512,5778),
["DireTopShrine"]= Vector(-139,2533),
["DireBotShrine"]= Vector(4173,-1613),
["DireBotRune"]= Vector(3471,295),
["DireTopRune"]= Vector(-2821,4147),
};

Utility.RuneSpots={
RUNE_POWERUP_1,
RUNE_POWERUP_2,
RUNE_BOUNTY_1,
RUNE_BOUNTY_2,
RUNE_BOUNTY_3,
RUNE_BOUNTY_4
};

function Utility.IsItemAvailable(item_name)
    local npcBot = GetBot();

    for i = 0, 5, 1 do
        local item = npcBot:GetItemInSlot(i);
		if (item~=nil) then
			if(item and item:IsFullyCastable() and item:GetName() == item_name) then
				return item;
			end
		end
    end
    return nil;
end

function Utility.IsItemInInventory(item_name)
    local npcBot = GetBot();

    for i = 0, 5, 1 do
        local item = npcBot:GetItemInSlot(i);
		if (item~=nil) then
			if(item and item:GetName() == item_name) then
				return item;
			end
		end
    end
	
    return nil;
end

function Utility.GetMaxHPCreep(creeps)
	npcBot=GetBot();
	
	local maxHPCreep=nil;
	local lh=0;
	
	for _,creep in pairs(creeps) do
		if creep:GetHealth()>lh then
			lh=creep:GetHealth();
			maxHPCreep=creep;
		end
	end
	
	return maxHPCreep;
end

function Utility.UseItems()
	local npcBot = GetBot();
	
	if npcBot:IsChanneling() or npcBot:IsUsingAbility() then
		return -1;
	end
	
	local courier=Utility.IsItemAvailable("item_courier");
	if courier~=nil and courier:IsFullyCastable() then
		npcBot:Action_UseAbility(courier);
		return -1;
	end
	
	
	local flyingCourier=Utility.IsItemAvailable("item_flying_courier");
	if flyingCourier~=nil and flyingCourier:IsFullyCastable() then
		npcBot:Action_UseAbility(flyingCourier);
		return -1;
	end
	
		
	local flask=Utility.IsItemAvailable("item_flask");
    if flask~=nil and flask:IsFullyCastable() and not npcBot:HasModifier(modifier_flask_healing) then
		local Enemies=npcBot:GetNearbyHeroes(850,true,BOT_MODE_NONE);
		
		if Enemies==nil or #Enemies==0 then
			if npcBot:GetMaxHealth()-npcBot:GetHealth()>320 then
				npcBot:Action_UseAbilityOnEntity(flask,npcBot);
				return -1;
			end
		end
	end

	local tango=Utility.IsItemAvailable("item_tango");
	if tango~=nil and tango:IsFullyCastable() and npcBot:GetMaxHealth() - npcBot:GetHealth() > 150 and not npcBot:HasModifier("modifier_tango_heal") then
		local trees=npcBot:GetNearbyTrees(500);
		local BestTree;
		local d = 10000;
		for _, tree in pairs(trees) do
			local v = GetTreeLocation(tree);
			if GetUnitToLocationDistance(npcBot, v) < d and GetHeightLevel(v) == GetHeightLevel(npcBot:GetLocation()) then
				d = GetUnitToLocationDistance(npcBot, v);
				BestTree = tree;
			end
		end
		if d < 500 then
			npcBot:Action_UseAbilityOnTree(tango, BestTree);
			return -1;
		end
	end
	
	local Enemies=npcBot:GetNearbyHeroes(1200,true,BOT_MODE_NONE);
	
	local talon=Utility.IsItemAvailable("item_iron_talon");
	
	if talon ~= nil and talon:IsFullyCastable() then
		local creeps=npcBot:GetNearbyCreeps(700,true)
		if Utility.GetMaxHPCreep(creeps) ~= nil then
			npcBot:Action_UseAbilityOnEntity(talon, Utility.GetMaxHPCreep(creeps))
			return -1;
		end
	end
	
	
	local hood=Utility.IsItemAvailable("item_hood_of_defiance");
    if hood~=nil and hood:IsFullyCastable() and npcBot:GetHealth()/npcBot:GetMaxHealth()<0.6 and (Enemies~=nil and #Enemies>0)then
		npcBot:Action_UseAbility(hood);
		return -1;
	end
	
	local pipe=Utility.IsItemAvailable("item_pipe");
    if pipe~=nil and pipe:IsFullyCastable() and npcBot:GetHealth()/npcBot:GetMaxHealth()<0.6 and (Enemies~=nil and #Enemies>0) then
		npcBot:Action_UseAbility(pipe);
		return -1;
	end
	
	local cg=Utility.IsItemAvailable("item_crimson_guard");
    if cg~=nil and cg:IsFullyCastable() and npcBot:GetHealth()/npcBot:GetMaxHealth()<0.65 and (Enemies~=nil and #Enemies>0) then
		npcBot:Action_UseAbility(cg);
		return -1;
	end
	
	local shiva=Utility.IsItemAvailable("item_shivas_guard");
    if shiva~=nil and shiva:IsFullyCastable() and ((Enemies~=nil and #Enemies>2) or npcBot:GetActiveMode()==BOT_MODE_ATTACK or npcBot:GetHealth()/npcBot:GetMaxHealth()<0.4) then
		npcBot:Action_UseAbility(shiva);
		return -1;
	end
	
	local rod=Utility.IsItemAvailable("item_rod_of_atos");
	if rod~=nil and rod:IsFullyCastable() and npcBot:GetActiveMode()==BOT_MODE_ATTACK and npcBot.Target~=nil and GetUnitToUnitDistance(npcBot,npcBot.Target)<=1000 then
		npcBot:Action_UseAbilityOnEntity(rod,npcBot.Target);
		return -1;
	end
	
	local lotus=Utility.IsItemAvailable("item_lotus_orb");

	if lotus~=nil and lotus:IsFullyCastable() and ((npcBot:GetHealth()/npcBot:GetMaxHealth()<0.45 and (Enemies~=nil and #Enemies>0)) or npcBot:IsSilenced() or (#Enemies~=nil and #Enemies>3 and npcBot:GetHealth()/npcBot:GetMaxHealth()<0.65)) then
		npcBot:Action_UseAbilityOnEntity(lotus,npcBot);
		return -1;
	end
	
	if lotus~=nil and lotus:IsFullyCastable() then
		local Allies=npcBot:GetNearbyHeroes(1000,false,BOT_MODE_NONE);
		for _,Ally in pairs(Allies) do
			if ((Ally:GetHealth()/Ally:GetMaxHealth()<0.35 and (Enemies~=nil and #Enemies>0)) or Ally:IsSilenced()) then
				npcBot:Action_UseAbilityOnEntity(lotus,Ally);
				return -1;
			end
		end
	end
	

	
	local se=Utility.IsItemAvailable("item_silver_edge");
    if se~=nil and se:IsFullyCastable() and npcBot:GetActiveMode()==BOT_MODE_RETREAT and GetUnitToLocationDistance(npcBot,Utility.Fountain(GetTeam()))>1500 then
		npcBot:Action_UseAbility(se);
		npcBot.SBTimer=DotaTime();
		return DotaTime();
	end
	
	local sb=Utility.IsItemAvailable("item_invis_sword");
    if sb~=nil and sb:IsFullyCastable() and npcBot:GetActiveMode()==BOT_MODE_RETREAT and GetUnitToLocationDistance(npcBot,Utility.Fountain(GetTeam()))>1500 then
		npcBot:Action_UseAbility(sb);
		npcBot.SBTimer=DotaTime();
		return DotaTime();
	end
	
	
	if (npcBot:GetActiveMode())==BOT_MODE_RETREAT then
		return -1;
	end
	
	local arcane=Utility.IsItemAvailable("item_arcane_boots");
    if arcane~=nil and arcane:IsFullyCastable() then
		if npcBot:GetMaxMana()-npcBot:GetMana()>160 then
			npcBot:Action_UseAbility(arcane);
			return -1;
		end
	end
	
	local veil=Utility.IsItemAvailable("item_veil_of_discord");
    if veil~=nil and veil:IsFullyCastable() then
		local Enemies=npcBot:GetNearbyHeroes(1000,true,BOT_MODE_NONE);
		
		if Enemies~=nil and #Enemies~=0 then
			local cpos=Utility.GetCenter(Enemies);
		
			npcBot:Action_UseAbilityOnLocation(veil,cpos);
			return -1;
		end
	end
	
	local drums=Utility.IsItemAvailable("item_ancient_janggo");
    if drums~=nil and drums:IsFullyCastable() and npcBot:GetActiveMode()==BOT_MODE_PUSH_TOWER_MID and drums:GetCurrentCharges()>0 then
		npcBot:Action_UseAbility(drums);
		return -1;
	end
	
	local tp=Utility.IsItemAvailable("item_tpscroll");
	if tp~=nil then
		local dest=GetLocationAlongLane(npcBot.CurLane,0.5);
		if tp:IsFullyCastable() and npcBot:GetActiveMode()==BOT_MODE_LANING and GetUnitToLocationDistance(npcBot,Utility.Fountain(GetTeam()))<2000 then
			npcBot:Action_UseAbilityOnLocation(tp,dest);
		elseif not (npcBot:IsUsingAbility() or npcBot:IsChanneling()) then
			npcBot:Action_SellItem(tp);
		end
	end
	
	local hod=Utility.IsItemAvailable("item_helm_of_the_dominator");
    if hod~=nil and hod:IsFullyCastable() and npcBot:GetActiveMode()==BOT_MODE_PUSH_TOWER_MID then
		local creeps=npcBot:GetNearbyCreeps(700,true);
		for _,creep in pairs(creeps) do
			if string.find(creep:GetUnitName(),"siege")~=nil then
				npcBot:Action_UseAbilityOnEntity(hod,creep);
				return -1;
			end
		end
	end
end

function Utility.HasRecipe()
	 local npcBot = GetBot();

    for i = 6, 20, 1 do
        local item = npcBot:GetItemInSlot(i);
		if (item~=nil) then
			if((string.find(item:GetName(),"recipe")~=nil) or (string.find(item:GetName(),"item_boots")~=nil) or (string.find(item:GetName(), "item_tango")~=nil)) then
				return true;
			end
			
			if(item:GetName()=="item_ward_observer" and item:GetCurrentCharges()>1) then
				return true;
			end
		end
    end
	
    return false;
end

function Utility.Fountain(team)
	if team==TEAM_RADIANT then
		return Vector(-7093,-6542);
	end
	return Vector(7015,6534);
end

function Utility.NotNilOrDead(unit)
	if unit==nil then
		return false;
	end
	if unit:IsAlive() then
		return true;
	end
	return false;
end

function Utility.GetOtherTeam()
	if GetTeam()==TEAM_RADIANT then
		return TEAM_DIRE;
	else
		return TEAM_RADIANT;
	end
	
end

function Utility.GetHeroLevel()
    local npcBot = GetBot();
    local respawnTable = {8, 10, 12, 14, 16, 26, 28, 30, 32, 34, 36, 46, 48, 50, 52, 54, 56, 66, 70, 74, 78,  82, 86, 90, 100};
    local nRespawnTime = npcBot:GetRespawnTime() +1;
    for k,v in pairs (respawnTable) do
        if v == nRespawnTime then
        return k;
        end
    end
end

function Utility.FindTarget(dist)
	local npcBot=GetBot();
	
	local mindis=100000;
	local candidate=nil;
	local MaxScore=-1;
	local damage=0;
	
	local Enemies=npcBot:GetNearbyHeroes(dist,true,BOT_MODE_NONE);
	
	if Enemies==nil or #Enemies==0 then
		return nil,0.0,0.0;
	end
	
	local Towers=npcBot:GetNearbyTowers(1100,true);
	local AlliedTowers=npcBot:GetNearbyTowers(950,false);
	local AlliedCreeps=npcBot:GetNearbyCreeps(1000,false);
	local EnemyCreeps=npcBot:GetNearbyCreeps(700,true);
	local nEc=0;
	local nAc=0;
	if AlliedCreeps~=nil then
		nAc=#AlliedCreeps;
	end
	if EnemyCreeps~=nil then
		nEc=#EnemyCreeps;
	end
	
	local nTo=0;
	if Towers~=nil then
		nTo=#Towers;
	end
	
	local fTo=0;
	if AlliedTowers~=nil then
		fTo=#AlliedTowers;
	end
	
	local lvl=Utility.GetHeroLevel();
	if lvl==nil then
		lvl=25;
	end
	
	for _,enemy in pairs(Enemies) do
		if Utility.NotNilOrDead(enemy) and enemy:GetHealth()>0 and GetUnitToLocationDistance(enemy,Utility.Fountain(Utility.GetOtherTeam()))>1350 then
			local myDamage=npcBot:GetEstimatedDamageToTarget(true,enemy,4.5,DAMAGE_TYPE_ALL);

			local nfriends=0;
			for j=1,5,1 do
				local enemy2=GetTeamMember(Utility.GetOtherTeam(),j);
				if Utility.NotNilOrDead(enemy2) and enemy2:GetHealth()>0 then
					if GetUnitToUnitDistance(enemy,enemy2)<1200 and enemy2:GetHealth()/enemy2:GetMaxHealth()>0.4 then
						nfriends=nfriends+1;
					end
				end
			end
			
			local nMyFriends=0;
			for j =1,5,1 do
				local Ally=GetTeamMember(GetTeam(),j);
				if Utility.NotNilOrDead(Ally) and GetUnitToUnitDistance(enemy,Ally)<1100 then
					if Ally:GetActiveMode()==BOT_MODE_RETREAT then
						nMyFriends=nMyFriends+3;
					else
						nMyFriends=nMyFriends+1;
					end
				end
			end
			
			local score= Min(myDamage/enemy:GetHealth(),4) + (nMyFriends)/1.7 - (nfriends)/1.7 - GetUnitToUnitDistance(enemy,npcBot)/3500 -(1-npcBot:GetHealth()/npcBot:GetMaxHealth()) - nTo/(Min(lvl/8,3)) + fTo/(Min(lvl/8,3)) - nEc/(2*lvl) + nAc/(2*lvl);
			if score>MaxScore then
				damage=myDamage;
				candidate=enemy;
				MaxScore=score;
			end
		end
	end
	
	return candidate,damage,MaxScore;
end

return Utility;