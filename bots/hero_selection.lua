

local RadiantBots = { "npc_dota_hero_antimage", "npc_dota_hero_axe", "npc_dota_hero_bane", "npc_dota_hero_slark", "npc_dota_hero_crystal_maiden" };
local DireBots    = { "npc_dota_hero_drow_ranger", "npc_dota_hero_earthshaker", "npc_dota_hero_juggernaut",  "npc_dota_hero_mirana", "npc_dota_hero_nevermore" };


function Think()
    Team = GetTeam();
    if Team == TEAM_RADIANT then Bots = RadiantBots;
                            else Bots = DireBots;
                            end
                            
    local IDs = GetTeamPlayers( Team );
	
    for i, id in pairs( IDs ) do
        if IsPlayerBot( id ) 
        then 
			SelectHero( id, Bots[i] );
        end
    end
end

