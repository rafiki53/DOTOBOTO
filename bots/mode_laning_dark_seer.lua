-------
--behaviour in this file makes more sense for usual games with ds solo vs trilane, but it is not the case in the most of bot games so it is not used

Utility = require(GetScriptDirectory().."/Utility")
----------

local npcBot = GetBot();
local lane = LANE_TOP;
local distance = 1000;

	

			
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




--[[
function Think()
	if npcBot:IsUsingAbility() or npcBot:IsChanneling() or npcBot:NumQueuedActions()~=0 then
		return 
	end;
	npcBot:Action_MoveToLocation(WhereToStand());
	
end
--]]
--------
