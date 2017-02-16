fItems = require( GetScriptDirectory() .. "/items_slark" )


Items = fItems.Items;
local Bot = GetBot()

function GetDesire()

    if( #Items == 0 ) then return BOT_MODE_DESIRE_NONE end
    Item = Items[1]

    if IsItemPurchasedFromSecretShop( Item ) and Bot:GetGold() >= GetItemCost( Item )
    then
        return Clamp( 600.0 / ( 1.0 + Bot:DistanceFromSecretShop() ), 0.0, 1.0 )
    else
        return BOT_MODE_DESIRE_NONE
	end

end




function Think()

    Shop1 = GetShopLocation( Bot:GetTeam(), SHOP_SECRET )
    Shop2 = GetShopLocation( Bot:GetTeam(), SHOP_SECRET2 )

    if GetUnitToLocationDistance( Bot, Shop1 ) < GetUnitToLocationDistance( Bot, Shop2 )
    then
        Bot:ActionQueue_MoveToLocation( Shop1 )
    else
        Bot:ActionQueue_MoveToLocation( Shop2 )
    end

end