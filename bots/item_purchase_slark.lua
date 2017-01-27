fItems = require( GetScriptDirectory() .. "/items" )


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
        Bot:Action_LevelAbility( Ability_Name );
        table.remove( Ability_Priority, 1 )
        print( "Ability upgraded successfully." )
    else
        print( "Warning: ability " .. Ability_Name .. " can not be upgraded." )
    end

end



function ItemPurchaseThink()

    if( not InGame() ) then return end
    
    if( Bot:GetAbilityPoints() > 0 )
    then
        LevelUp()
    end
    
    
    if( #Items == 0 ) then return end
    
    Item = Items[1]
    Bot:SetNextItemPurchaseValue( GetItemCost( Item ) )
    
    if not IsItemPurchasedFromSecretShop( Item ) and not( IsItemPurchasedFromSideShop( Item ) and Bot:DistanceFromSideShop() <= 2200 ) 
       and Bot:GetGold() >= GetItemCost( Item )
    then
        print( "Buying " .. Item )
        Bot:Action_PurchaseItem( Item )
        table.remove( Items, 1 )
	end

end

