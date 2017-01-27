fItems = require( GetScriptDirectory() .. "/items" )


Items = fItems.Items;
local Bot = GetBot()

function GetDesire()

    if( #Items == 0 ) then return BOT_MODE_DESIRE_NONE end
    Item = Items[1]
    
    if IsItemPurchasedFromSideShop( Item ) and Bot:DistanceFromSideShop() <= 5000 and Bot:GetGold() >= GetItemCost( Item )
    then
        return BOT_MODE_DESIRE_HIGH 
    else
        return BOT_MODE_DESIRE_NONE
	end
    
end