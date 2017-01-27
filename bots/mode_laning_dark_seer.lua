-------
require( GetScriptDirectory().."/mode_laning_generic" )
Utility = require(GetScriptDirectory().."/Utility")
----------

local lane = LANE_TOP;
if GetTeam()==TEAM_DIRE then
	lane = LANE_BOT
end
local npcBot = GetBot();

function OnStart()
	
	mode_generic_laning.OnStart();
end

function OnEnd()
	mode_generic_laning.OnEnd();
end

function GetDesire()
--print(GetBot());
	return 1.0;--return mode_generic_laning.GetDesire();
end


function WhereToStand()
--exp range
	return GetLaneFrontLocation(GetTeam(),lane,-1000)
end

function SpamIonShell()
	--allied creeps
	local creeps=npcBot:GetNearbyCreeps(1300,false)
	mindist = 20000.0
	print(GetTeam());
	for _,creep in pairs(creeps) do
		print(creep:GetAttackRange());
		--if creep:GetAttackRange()==100
	end
			
	
end



function Think()
	--if not casting 
	--think about casting
	--if you are being harrassed move back(flag harrased that takes 1-2 sec)
	--if enemy is low make him more miserable
	SpamIonShell();
	npcBot:Action_MoveToLocation(WhereToStand());
	
end

--------
