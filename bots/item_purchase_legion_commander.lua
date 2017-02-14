------------------------------------------------------------
--- AUTHOR: PLATINUM_DOTA2 (Pooya J.)
--- EMAIL ADDRESS: platinum.dota2@gmail.com
------------------------------------------------------------

local Abilities ={
"legion_commander_overwhelming_odds",
"legion_commander_press_the_attack",
"legion_commander_moment_of_courage",
"legion_commander_duel"
};

local AbilityPriority = {
"legion_commander_moment_of_courage",
"legion_commander_overwhelming_odds",
"legion_commander_moment_of_courage",
"legion_commander_overwhelming_odds",
"legion_commander_moment_of_courage",
"legion_commander_duel",
"legion_commander_overwhelming_odds",
"legion_commander_overwhelming_odds",
"legion_commander_press_the_attack",
--"special_bonus_attack_damage_15",
"legion_commander_press_the_attack",
"legion_commander_duel",--
"legion_commander_press_the_attack",--
"legion_commander_press_the_attack",
--"special_bonus_hp_150",
"legion_commander_moment_of_courage",
"legion_commander_duel"
--"+25 Attack Speed",
--"+15 All Stats"
};

local npcBot=GetBot();

local ItemsToBuy = {
"item_recipe_yasha",
"item_ogre_axe",
"item_recipe_sange",
"item_ultimate_orb",
"item_recipe_silver_edge",
"item_javelin",
"item_belt_of_strength",
"item_recipe_abyssal_blade",
"item_recipe_basher",
"item_stout_shield",
"item_vitality_booster",
"item_ring_of_health",
"item_recipe_greater_crit",
"item_demon_edge",
"item_recipe_lesser_crit",
"item_blades_of_attack",
"item_broadsword",
"item_hyperstone",
"item_chainmail",
"item_platemail",
"item_recipe_assault",
"item_mithril_hammer",
"item_mithril_hammer",
"item_blight_stone",
"item_belt_of_strength",
"item_gloves",
"item_blink",
"item_boots",
"item_recipe_iron_talon",
"item_ring_of_protection",
"item_quelling_blade",
"item_tango",
"item_stout_shield"
};

local Talents=
{
"special_bonus_strength_7",
"special_bonus_attack_damage_30",
"special_bonus_armor_7",
"special_bonus_unique_legion_commander"
}

local function LevelUp()
	local aq=npcBot:GetAbilityByName(Abilities[1]);
	local aw=npcBot:GetAbilityByName(Abilities[2]);
	local ae=npcBot:GetAbilityByName(Abilities[3]);
	local ar=npcBot:GetAbilityByName(Abilities[4]);
	
	local ability=npcBot:GetAbilityByName(Talents[1]);
	
	if (ability~=nil and ability:CanAbilityBeUpgraded() and ability:GetLevel()<ability:GetMaxLevel()) then
		npcBot:ActionImmediate_LevelAbility(Talents[1]);
		table.remove( Talents, 1 );
	end	
	
	if ar~=nil and ar:CanAbilityBeUpgraded() then
		npcBot:ActionImmediate_LevelAbility(Abilities[4]);
		return;
	end
	
	if ae~=nil and ae:CanAbilityBeUpgraded() then
		npcBot:ActionImmediate_LevelAbility(Abilities[3]);
		return;
	end
	if aw~=nil and aw:CanAbilityBeUpgraded() then
		npcBot:ActionImmediate_LevelAbility(Abilities[2]);
		return;
	end	
	
	if aq~=nil and aq:CanAbilityBeUpgraded() then
		npcBot:ActionImmediate_LevelAbility(Abilities[1]);
		return;
	end

end

function ItemPurchaseThink()
	local npcBot = GetBot();
	
	if npcBot:GetAbilityPoints()>0 then
		LevelUp();
	end
	
	if (ItemsToBuy==nil or #ItemsToBuy == 0 ) then
		npcBot:SetNextItemPurchaseValue( 0 );
		return;
	end
	
	local NextItem = ItemsToBuy[#ItemsToBuy];

	npcBot:SetNextItemPurchaseValue( GetItemCost( NextItem ) );
	
	if (not IsItemPurchasedFromSecretShop(NextItem)) and (not(IsItemPurchasedFromSideShop(NextItem) and npcBot:DistanceFromSideShop()<=2200)) then
		if ( npcBot:GetGold() >= GetItemCost( NextItem ) ) then
			npcBot:ActionImmediate_PurchaseItem( NextItem );
			table.remove(ItemsToBuy);
		end
	end
end