Utility = require(GetScriptDirectory().."/Utility")
----------

local Abilities ={
"dark_seer_vacuum",
"dark_seer_ion_shell",
"dark_seer_surge",
"dark_seer_wall_of_replica"
};

local AbilityPriority = {
"dark_seer_ion_shell",
"dark_seer_surge",
"dark_seer_ion_shell",
"dark_seer_surge",
"dark_seer_ion_shell",
"dark_seer_wall_of_replica",
"dark_seer_ion_shell",
"dark_seer_vacuum",
"dark_seer_vacuum",
"special_bonus_cast_range_100",
"dark_seer_vacuum",
"dark_seer_wall_of_replica",
"dark_seer_vacuum",
"dark_seer_surge",
"special_bonus_hp_regen_14",--
"dark_seer_surge",
"dark_seer_wall_of_replica",
"special_bonus_unique_dark_seer_2",--
"special_bonus_unique_dark_seer",--
};

local npcBot=GetBot();

npcBot.ItemsToBuy = {
"item_tango",
"item_stout_shield",
"item_flask",
"item_clarity",
"item_recipe_soul_ring",
"item_sobi_mask",
"item_ring_of_regen",
"item_boots",
"item_energy_booster",
--mek
"item_branches",
"item_ring_of_regen",
"item_recipe_headdress",
"item_chainmail",
"item_branches",
"item_recipe_buckler",
"item_recipe_guardian_greaves",
--pipe
"item_cloak",
"item_ring_of_health",
"item_ring_of_regen",
"item_branches",
"item_ring_of_regen",
"item_recipe_headdress",
"item_recipe_pipe",
};


local function LevelUp()
	if #AbilityPriority==0 then
		return;
	end
    
	local npcBot = GetBot();
	
	if DotaTime()<0 then
		return;
	end
	
	local ability=npcBot:GetAbilityByName(AbilityPriority[1]);
	
	if (ability~=nil and ability:CanAbilityBeUpgraded() and ability:GetLevel()<ability:GetMaxLevel()) then
		npcBot:ActionImmediate_LevelAbility(AbilityPriority[1]);
		table.remove( AbilityPriority, 1 );
	end
end

function ItemPurchaseThink()
	
	
	local npcBot = GetBot();
	--[[
	if Utility.IsItemAvailable("item_lotus_orb") ~= nil then
		npcBot.SecretGold = 1100;
	end
	--]]
	
	--local item=Utility.IsItemAvailable("item_stout_shield");
--	if item~=nil and Utility.NumberOfItems()>5 then
	--	npcBot:Action_SellItem(item);
--	end

	--print(npcBot:GetAbilityPoints());
	
	
	--pozbadz sie nadmiarowych itemow jak masz za malo slotow
	if npcBot:GetAbilityPoints()>0 then
		LevelUp();
	end
	
	if ( npcBot.ItemsToBuy==nil or #npcBot.ItemsToBuy == 0 ) then
		npcBot:SetNextItemPurchaseValue( 0 );
		return;
	end

	local NextItem = npcBot.ItemsToBuy[1];

	npcBot:SetNextItemPurchaseValue( GetItemCost( NextItem ) );
--	if (not IsItemPurchasedFromSecretShop)
	if (not IsItemPurchasedFromSecretShop( NextItem)) and (not(IsItemPurchasedFromSideShop(NextItem) and npcBot:DistanceFromSideShop()<=2200)) then
		if ( npcBot:GetGold() >= GetItemCost( NextItem ) ) then
			npcBot:ActionImmediate_PurchaseItem( NextItem );
			table.remove( npcBot.ItemsToBuy, 1 );
		end
	end
end