function GetDesire()
  local npcBot = GetBot();
  local desire = 0.0;
  if ( npcBot.secretShopMode == true ) then
    desire = 0.5;
  end
  
  return desire;
end