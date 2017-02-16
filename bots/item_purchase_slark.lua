fItems = require( GetScriptDirectory() .. "/items_slark" )


local Abilities =
{
    "slark_dark_pact",
    "slark_pounce",
    "slark_essence_shift",
    "slark_shadow_dance"
}

local Ability_Priority =
{
    [ 1] = "slark_pounce",
    [ 2] = "slark_essence_shift",
    [ 3] = "slark_dark_pact",
    [ 4] = "slark_dark_pact",
    [ 5] = "slark_dark_pact",
    [ 6] = "slark_shadow_dance",
    [ 7] = "slark_dark_pact",
    [ 8] = "slark_pounce",
    [ 9] = "slark_pounce",
    [10] = "special_bonus_lifesteal_10",
    [11] = "slark_pounce",
    [12] = "slark_shadow_dance",
    [13] = "slark_essence_shift",
    [14] = "slark_essence_shift",
    [15] = "special_bonus_agility_15",
    [16] = "slark_essence_shift",
    [17] = nil,
    [18] = "slark_shadow_dance",
    [19] = nil,
    [20] = "special_bonus_attack_speed_25",
    [21] = nil,
    [22] = nil,
    [23] = nil,
    [24] = nil,
    [25] = "special_bonus_all_stats_12"
}


Items = fItems.Items
local Bot = GetBot()



function InGame()

    State = GetGameState();
    return State == GAME_STATE_PRE_GAME or State == GAME_STATE_GAME_IN_PROGRESS

end


function Have( Item )

    local i = Bot:FindItemSlot( Item )
    return i >= 0

end


FirstRun = true

function Reset()

    if FirstRun
    then


        FirstRun = false
    end

end


NextTime = 0

function PeriodicInfo()

    Time = DotaTime()
    if NextTime <= Time
    then
        -- Print info
        NextTime = Time + 10
    end

end




function LevelUp()

    Level = Bot:GetLevel()
    local Ability_Name = Ability_Priority[ Level ]
    if Ability_Name == nil
    then
        print( "[Slark] New level achieved, but no ability can be upgraded." )
        return
    else
        print( "[Slark] New level achieved - upgrading ability: " .. Ability_Name )
    end


    local Ability = Bot:GetAbilityByName( Ability_Name )
    if Ability == nil
    then
        print( "[Slark] Warning: Ability " .. Ability_Name .. " not found." )
    elseif Ability:CanAbilityBeUpgraded() and Ability:GetLevel() < Ability:GetMaxLevel()
    then
        Bot:ActionImmediate_LevelAbility( Ability_Name )
        print( "[Slark] Ability upgraded successfully." )
    else
        print( "[Slark] Warning: ability " .. Ability_Name .. " can not be upgraded." )
    end

end



function ItemPurchaseThink()

    if not InGame() or not Bot:IsAlive() then return end

    Reset()
    PeriodicInfo()


    if( Bot:GetAbilityPoints() > 0 )
    then
        LevelUp()
    end


    TP = "item_tpscroll"
    if not Have( TP ) and DotaTime() >= 100 and Bot:GetGold() >= GetItemCost( TP )
    then
        Bot:ActionImmediate_PurchaseItem( TP )
    end


    Item = Items[1]
    Psc = IsItemPurchasedFromSecretShop( Item )
    Psd = IsItemPurchasedFromSideShop( Item )
    Dsc = Bot:DistanceFromSecretShop()
    Dsd = Bot:DistanceFromSideShop()

    Buy = false
    if Bot:GetGold() >= GetItemCost( Item )
    then
        if ( Psc and Dsc == 0 ) or ( Psd and Dsd == 0 )
        then
            Buy = true
        elseif Psd and Dsd <= 2500
        then
            Buy = false
        elseif Psc
        then
            Buy = false
        else
            Buy = true
        end
    end

    if Buy
    then

        Result = Bot:ActionImmediate_PurchaseItem( Item )

            if Result == PURCHASE_ITEM_SUCCESS            then print( "[Slark] " .. Item .. " purchased. " )
        elseif Result == PURCHASE_ITEM_OUT_OF_STOCK       then print( "[Slark] Error: " .. Item .. " out of stock. " )
        elseif Result == PURCHASE_ITEM_DISALLOWED_ITEM    then print( "[Slark] Error: " .. Item .. " is disallowed. " )
        elseif Result == PURCHASE_ITEM_INSUFFICIENT_GOLD  then print( "[Slark] Error: " .. "insufficient gold for " .. Item )
        elseif Result == PURCHASE_ITEM_NOT_AT_HOME_SHOP   then print( "[Slark] Error: " .. Item .. " is not at home shop. " )
        elseif Result == PURCHASE_ITEM_NOT_AT_SIDE_SHOP   then print( "[Slark] Error: " .. Item .. " is not at side shop. " )
        elseif Result == PURCHASE_ITEM_NOT_AT_SECRET_SHOP then print( "[Slark] Error: " .. Item .. " is not at secret shop. " )
        elseif Result == PURCHASE_ITEM_INVALID_ITEM_NAME  then print( "[Slark] Error: " .. Item .. " is not a valid item name. " )
        end

        if Result == PURCHASE_ITEM_SUCCESS then table.remove( Items, 1 ) end

    end

end

