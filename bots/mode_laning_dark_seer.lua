-------

Utility = require(GetScriptDirectory().."/Utility")
----------

local npcBot = GetBot();
local lane = LANE_TOP;
local distance = 1000;
local curr_hp = 0.0;
local last_harassed = GameTime();

local ion_shell=npcBot:GetAbilityByName("dark_seer_ion_shell");
	

			
if GetTeam()==TEAM_DIRE then
	lane = LANE_BOT
end


local function WhereToStand()

	if(npcBot:WasRecentlyDamagedByAnyHero(2) or npcBot:WasRecentlyDamagedByTower(2)) then
		distance = 4000
	else
		distance = 1000
	end
	return GetLaneFrontLocation(GetTeam(),lane,-distance)
end





function Think()
	--print(last_hp)
	
	--if not casting 
	--think about casting
	--if you are being harassed move back(flag harrased that takes 1-2 sec)
	--if enemy is low make him more miserable

	npcBot:Action_MoveToLocation(WhereToStand());
	
end

--------
