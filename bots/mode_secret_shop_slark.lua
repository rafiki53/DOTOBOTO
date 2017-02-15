fItems = require( GetScriptDirectory() .. "/items" )


Items = fItems.Items;
local Bot = GetBot()

function GetDesire()

    if( #Items == 0 ) then return BOT_MODE_DESIRE_NONE end
    Item = Items[1]
    
    if IsItemPurchasedFromSecretShop( Item ) and Bot:GetGold() >= GetItemCost( Item )
    then
        return 3000 / Bot:DistanceFromSecretShop()
    else
        return BOT_MODE_DESIRE_NONE
	end
    
end