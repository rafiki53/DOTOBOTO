local npcBot=GetBot();
local ion_shell=npcBot:GetAbilityByName("dark_seer_ion_shell");
local surge = npcBot:GetAbilityByName("dark_seer_surge")
local vacuum = npcBot:GetAbilityByName("dark_seer_surge")
local wall = npcBot:GetAbilityByName("dark_seer_wall_of_replica")

local function SpamIonShell()
	--allied creeps
	
	
	local creeps=npcBot:GetNearbyCreeps(1300,false)
	
	--print(GetTeam());
	for _,creep in pairs(creeps) do
		if(creep:GetAttackRange()==100 and creep:GetHealth()>350 and not(creep:HasModifier("modifier_dark_seer_ion_shell")) )then
			if ion_shell:IsFullyCastable() then
			
				npcBot:Action_UseAbilityOnEntity(ion_shell,creep);
				
			end
			return true
		end
		--if creep:GetAttackRange()==100
	
	end
	return false
			
	
end
function AbilityUsageThink()
	--if not casting
	local currMode = npcBot:GetActiveMode();
	if npcBot:IsUsingAbility() or npcBot:IsChanneling() then
		return;
	end
	
	
	--if low on hp cast surge on yourself
	if npcBot:GetHealth()/npcBot:GetMaxHealth() < 0.2 then
		if surge:IsFullyCastable() then
			npcBot:Action_UseAbilityOnEntity(surge,npcBot);
				
		end
	end
	--if ally then cast on him(maybe merge both)
	
	
	
	
	--if many enemies and alliez use vacuum+wall(requires at least vacuum)
	
	--if in farm or lane mode spam ion shell on creeps
	--if in any other modes cast on melee allies
	
	if( currMode == BOT_MODE_LANING or currMode == BOT_MODE_FARM) then
		--spam ion shell on creeps
		SpamIonShell()
	end
	return
	
end
function ItemUsageThink()
	--print(#npcBot:GetNearbyHeroes(1600,true,npcBot:GetActiveMode()))
	if npcBot:IsUsingAbility() or npcBot:IsChanneling() then
			return;
	end
--salve
	--jesli daleko od wrogow i malo hp to uzyj
--tango 
--soul ring
	--jesli farmie jest cooldown na ion shella rdy ale za malo many to odpal
--jak mam malo many lub ktos obok siebie bez many to odpal arcany (brakujace 100 powiedzmy minimum)
--greavesy i meka tak samo odpalac czyli dla zycia (jak ktos ma <200 lub jak wszystkim (minimum 3) brakuje po 200)
--pipe jak jest duzo naszych i duzo przeciwnikow i ktos kogos zaatakowal 
end

--function CourierUsageThink()
	--npcBot=GetBot();
	--if (npcBot:GetStashValue()>1000 and IsCourierAvailable()) then
	--	npcBot:Action_CourierDeliver();
	--end
--end
