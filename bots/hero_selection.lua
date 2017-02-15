local MyBots={"npc_dota_hero_dark_seer", "npc_dota_hero_templar_assassin","npc_dota_hero_crystal_maiden" , "npc_dota_hero_legion_commander", "npc_dota_hero_slark"};

function Think()
	local IDs=GetTeamPlayers(GetTeam());
	for i,id in pairs(IDs) do
		if IsPlayerBot(id) then
			SelectHero(id,MyBots[i]);
		end
	end

end

function UpdateLaneAssignments()
	if ( GetTeam() == TEAM_RADIANT ) then
		return {
			[1] = LANE_TOP,
			[2] = LANE_MID,
			[3] = LANE_BOT,
			[4] = LANE_TOP,
			[5] = LANE_BOT,
		};
	elseif ( GetTeam() == TEAM_DIRE ) then
		return {
			[1] = LANE_BOT,
			[2] = LANE_BOT,
			[3] = LANE_TOP,
			[4] = LANE_BOT,
			[5] = LANE_MID,
		};
	end
end