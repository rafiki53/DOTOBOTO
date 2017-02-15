fItems = require( GetScriptDirectory() .. "/items_dark_seer" )

Utility = require(GetScriptDirectory().."/Utility")
----------

local Abilities ={
"dark_seer_vacuum",
"dark_seer_ion_shell",
"dark_seer_surge",
"dark_seer_wall_of_replica"
};

local Ability_Priority = {
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

Items = fItems.Items
local Bot = GetBot()
function InGame()

    State = GetGameState();
    return State == GAME_STATE_PRE_GAME or State == GAME_STATE_GAME_IN_PROGRESS

end


local LastTime = 0
local LastItem

function Have( Item )

    local i = Bot:FindItemSlot( Item )

    --[[
    local Time = DotaTime()
    if LastItem ~= Item or LastTime + 10 <= Time
    then

        if i >= 0
        then
            print( "Already have " .. Item .. " in slot " .. i )
        else
            print( "Don't have item " .. Item )
        end

        LastItem = Item
        LastTime = Time

    end
    ]]--

    return i >= 0

end




function LevelUp()

    local Bot = GetBot()

    if( #Ability_Priority == 0 )
    then
        print( "Warning: LevelUp called but Ability_Priority is empty." )
        return
    end

    local Ability_Name = Ability_Priority[1]
    if( Ability_Name == nil )
    then
        print( "New level achieved, but no ability can be upgraded." )
        return
    else
        print( "New level achieved - upgrading ability: " .. Ability_Name )
    end


    local Ability = Bot:GetAbilityByName( Ability_Name )
    if( Ability == nil )
    then
        print( "Warning: Ability " .. Ability_Name .. " not found." )
    elseif( Ability:CanAbilityBeUpgraded() and Ability:GetLevel() < Ability:GetMaxLevel() )
    then
        Bot:ActionImmediate_LevelAbility( Ability_Name )
        print( "Ability upgraded successfully." )
    else
        print( "Warning: ability " .. Ability_Name .. " can not be upgraded." )
    end

    table.remove( Ability_Priority, 1 )

end



function ItemPurchaseThink()

    if( not InGame() ) then return end

    if( Bot:GetAbilityPoints() > 0 )
    then
        LevelUp()
    end



    while true
    do

        if( #Items == 0 ) then return end

        Item = Items[1]
        if not Have( Item ) then break end

        table.remove( Items, 1 )

    end

    Bot:SetNextItemPurchaseValue( GetItemCost( Item ) )

    Psc = IsItemPurchasedFromSecretShop( Item )
    Psd = IsItemPurchasedFromSideShop( Item )
    Dsc = Bot:DistanceFromSecretShop()
    Dsd = Bot:DistanceFromSideShop()

    Buy = false
    if Bot:GetGold() >= GetItemCost( Item )
    then
        if ( Psc and Dsc == 0 ) or ( Psd and Dsd == 0 )
        then
            print( "In shop" )
            Buy = true
        elseif Psd and Dsd <= 2500
        then
            print( "Close to shop: " .. Dsd )
            Buy = false
        elseif Psc
        then
            Buy = false
        else
            print( "In shop" )
            Buy = true
        end
    end

    if Buy
    then

        Result = Bot:ActionImmediate_PurchaseItem( Item )

            if Result == PURCHASE_ITEM_SUCCESS            then print( Item .. " purchased. " )
        elseif Result == PURCHASE_ITEM_OUT_OF_STOCK       then print( "Error: " .. Item .. " out of stock. " )
        elseif Result == PURCHASE_ITEM_DISALLOWED_ITEM    then print( "Error: " .. Item .. " is disallowed. " )
        elseif Result == PURCHASE_ITEM_INSUFFICIENT_GOLD  then print( "Error: " .. "insufficient gold for " .. Item )
        elseif Result == PURCHASE_ITEM_NOT_AT_HOME_SHOP   then print( "Error: " .. Item .. " is not at home shop. " )
        elseif Result == PURCHASE_ITEM_NOT_AT_SIDE_SHOP   then print( "Error: " .. Item .. " is not at side shop. " )
        elseif Result == PURCHASE_ITEM_NOT_AT_SECRET_SHOP then print( "Error: " .. Item .. " is not at secret shop. " )
        elseif Result == PURCHASE_ITEM_INVALID_ITEM_NAME  then print( "Error: " .. Item .. " is not a valid item name. " )
        end

        if Result == PURCHASE_ITEM_SUCCESS then table.remove( Items, 1 ) end
    end

end
