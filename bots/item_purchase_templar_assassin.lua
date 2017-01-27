local tableItemsToBuyAsMid = { 
	"item_circlet",
	"item_slippers",
	"item_recipe_wraith_band",
	"item_faerie_fire",
	"item_branches",
	"item_bottle",
	"item_boots",
	"item_blight_stone",
	"item_belt_of_strength",
	"item_gloves_of_haste",
	"item_mithril_hammer",
	"item_mithril_hammer",
};

local AbilityPriority = {
	"templar_assassin_refraction",
	"templar_assassin_psi_blades",
	"templar_assassin_refraction",
	"templar_assassin_psi_blades",
	"templar_assassin_refraction",
	"templar_assassin_psionic_trap",
	"templar_assassin_refraction",
	"templar_assassin_meld",
	"templar_assassin_psi_blades",
	"templar_assassin_psi_blades",
	"templar_assassin_meld",
	"templar_assassin_meld",
	"templar_assassin_meld"
}

----------------------------------------------------------------------------------------------------

local function LevelUp()
    
	local npcBot = GetBot();
	
	if DotaTime() < 0 then
		return;
	end
	
	local ability = npcBot:GetAbilityByName(AbilityPriority[1]);
	
	if (ability~=nil and ability:CanAbilityBeUpgraded() and ability:GetLevel()<ability:GetMaxLevel()) then
		npcBot:Action_LevelAbility(AbilityPriority[1]);
		table.remove(AbilityPriority, 1 );
	end
end

function ItemPurchaseThink()

	local npcBot = GetBot();
	
	if npcBot:GetAbilityPoints() > 0 then
		LevelUp();
	end
	
	if npcBot == nil then return end
	if ( GetGameState() ~= GAME_STATE_GAME_IN_PROGRESS and GetGameState() ~= GAME_STATE_PRE_GAME ) then return end
	
	if ( (npcBot:GetNextItemPurchaseValue() > 0) and (npcBot:GetGold() < npcBot:GetNextItemPurchaseValue()) ) then
		return
	end
	
	local pID = npcBot:GetPlayerID() - 1;	
	
	local sNextItem = nil

	if ( #tableItemsToBuyAsMid == 0 ) then
		npcBot:SetNextItemPurchaseValue( 0 );
		print( "    No More Items in Purchase Table!" )
		return;
	end

	sNextItem = tableItemsToBuyAsMid[1];

	npcBot:SetNextItemPurchaseValue( GetItemCost( sNextItem ) );

	if ( npcBot:GetGold() >= GetItemCost( sNextItem ) ) then
		npcBot:Action_PurchaseItem( sNextItem );
		table.remove( tableItemsToBuyAsMid, 1 );
		npcBot:SetNextItemPurchaseValue( 0 );
	end
	
end

----------------------------------------------------------------------------------------------------