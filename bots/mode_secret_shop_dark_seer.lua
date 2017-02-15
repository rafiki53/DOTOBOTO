fItems = require( GetScriptDirectory() .. "/items_dark_seer" )


Items = fItems.Items;
local Bot = GetBot()

function GetDesire()

    if( #Items == 0 ) then return BOT_MODE_DESIRE_NONE end
    Item = Items[1]

    if IsItemPurchasedFromSecretShop( Item ) and Bot:GetGold() >= GetItemCost( Item )
    then
        return 600 / ( 1 + Bot:DistanceFromSecretShop() )
    else
        return BOT_MODE_DESIRE_NONE
	end

end




function OnStart()

    Shop1 = GetShopLocation( Bot:GetTeam(), SHOP_SECRET )
    Shop2 = GetShopLocation( Bot:GetTeam(), SHOP_SECRET2 )

    if GetUnitToLocationDistance( Bot, Shop1 ) < GetUnitToLocationDistance( Bot, Shop2 )
    then
        Bot:ActionQueue_MoveToLocation( Shop1 )
    else
        Bot:ActionQueue_MoveToLocation( Shop2 )
    end

end