local tableItemsToBuyAsMid = { 
	"item_circlet",
	"item_slippers",
	"item_recipe_wraith_band",
	"item_branches",
	"item_branches",
	"item_bottle",
	"item_boots",
	"item_blight_stone",
	"item_belt_of_strength",
	"item_gloves",
	"item_mithril_hammer",
	"item_mithril_hammer",
	"item_boots_of_elves",
	"item_blade_of_alacrity",
	"item_recipe_yasha",
	"item_belt_of_strength",
	"item_ogre_axe",
	"item_recipe_sange",
	"item_broadsword",
	"item_blades_of_attack",
	"item_recipe_lesser_crit",
	"item_demon_edge",
	"item_recipe_greater_crit",
	"item_eagle",
	"item_talisman_of_evasion",
	"item_quarterstaff",
	"item_demon_edge",
	"item_javelin",
	"item_javelin"
};

local toSell = {"item_branches", 
	"item_wraith_band", 
	"item_bottle"
};

----------------------------------------------------------------------------------------------------

local function SellItems()
	local npcBot = GetBot();
	
	if ( #toSell == 0 ) then
		return;
	end
	for i=1,3 do
		item_name = toSell[i];
		where_is_it = npcBot:FindItemSlot( item_name );
		if where_is_it >= 6 and where_is_it < 9 then
			item = npcBot:GetItemInSlot( where_is_it );
			npcBot:ActionImmediate_SellItem( item);
		end
		where_is_it = npcBot:FindItemSlot( item_name );
		if where_is_it ~= -1 and item_name == "item_bottle" and DotaTime() > 2400 then
			item = npcBot:GetItemInSlot( where_is_it );
			npcBot:ActionImmediate_SellItem( item);
		end
	end
end
		

function ItemPurchaseThink()

	SellItems();

	local npcBot = GetBot();
	
	if npcBot == nil then return end
	if ( GetGameState() ~= GAME_STATE_GAME_IN_PROGRESS and GetGameState() ~= GAME_STATE_PRE_GAME ) then return end
	
	if ( (npcBot:GetNextItemPurchaseValue() > 0) and (npcBot:GetGold() < npcBot:GetNextItemPurchaseValue()) ) then
		return
	end
	
	local pID = npcBot:GetPlayerID() - 1;	
	
	havetp = (npcBot:FindItemSlot("item_tpscroll") ~= -1);
	if not havetp and DotaTime() >= 100 and npcBot:GetGold() >= GetItemCost( "item_tpscroll" ) then
		npcBot:ActionImmediate_PurchaseItem( "item_tpscroll" );
		return;
	end
		
	local sNextItem = nil

	if ( #tableItemsToBuyAsMid == 0 ) then
		npcBot:SetNextItemPurchaseValue( 0 );
		return;
	end

	sNextItem = tableItemsToBuyAsMid[1];
	
	npcBot:SetNextItemPurchaseValue( GetItemCost( sNextItem ) );
	secretShopThreshold = 120;
	if IsItemPurchasedFromSecretShop( sNextItem ) then
		if npcBot:GetGold() >= GetItemCost( sNextItem ) then
			npcBot.secretShopMode = true;
		else 
			npcBot.secretShopMode = false;
		end
		if ( npcBot:DistanceFromSecretShop() <= secretShopThreshold and npcBot:GetGold() >= GetItemCost( sNextItem )) then
			npcBot:ActionImmediate_PurchaseItem( sNextItem );
			table.remove( tableItemsToBuyAsMid, 1 );
			npcBot:SetNextItemPurchaseValue( 0 );
			npcBot.secretShopMode = false;
		end
		return;
	end
	
	if ( npcBot:GetGold() >= GetItemCost( sNextItem ) ) then
		npcBot:ActionImmediate_PurchaseItem( sNextItem );
		table.remove( tableItemsToBuyAsMid, 1 );
		npcBot:SetNextItemPurchaseValue( 0 );
	end
	
end

----------------------------------------------------------------------------------------------------