----------
--require( GetScriptDirectory().."/mode_farm_generic" )
Utility = require(GetScriptDirectory().."/Utility")
----------


function GetDesire()
	if not Utility.IsItemInInventory("item_blink") then
		return 0.9
	else
		--print(mode_generic_farm.GetDesire())
		--return mode_generic_farm.GetDesire()
		return 0.0
	end
end

local CurCamp = "RadiantMediumClose";

local CampStatus = {
	["RadiantMediumClose"]=false,
	["RadiantHardClose"]=false,
	["RadiantMediumRune"]=false,
	["RadiantEasy"]=false,
	["RadiantHardPull"]=false
};

local JunglingStates={
	Start=0,
	KillingCreeps=3,
	WaitingForCreeps=4,
	MovingToNextCamp=5,
	GettingBack=7
};

local JunglingState = JunglingStates.Start;

local Rot0 = {"RadiantMediumClose", "RadiantHardClose", "RadiantMediumRune", "RadiantEasy", "RadiantHardPull"};
local Rot1 = {"RadiantHardPull", "RadiantEasy", "RadiantMediumRune", "RadiantHardClose", "RadiantMediumClose"};
local Rot = Rot0;
local function Start()
	local npcBot=GetBot();
	if GetTeam()==TEAM_RADIANT then
		BRuneSpot=Utility.Locations["RadiantBotRune"];
	else
		BRuneSpot=Utility.Locations["DireTopRune"];
	end
	npcBot:Action_MoveToLocation(BRuneSpot);
	
	npcBot.CurLane=npcBot:GetAssignedLane();
	
	if math.floor(DotaTime())>30 then
		JunglingState=JunglingStates.MovingToNextCamp;
		return;
	end
end

function Get_Closest(Rotation)
	for i, b in pairs(Rotation) do
		if CampStatus[b] then
			return i, GetUnitToLocationDistance(npcBot, Utility.Locations[b])
		end
	end
	return 0, Utility.Inf
end

local camp_num = 1;

local function WaitForCreeps()
	local npcBot=GetBot()
	local r0_close_camp, r0_d = Get_Closest(Rot0)
	local r1_close_camp, r1_d = Get_Closest(Rot1)
	if r0_d < Utility.Inf or r1_d < Utility.Inf then
		JunglingState=JunglingStates.MovingToNextCamp
		if r0_d < r1_d then
			Rot = Rot0
			camp_num = r0_close_camp
		else
			Rot = Rot1
			camp_num = r1_close_camp
		end
		return
	end
	
	npcBot:Action_MoveToLocation(BRuneSpot);
end

function MoveToNextCamp()
	local npcBot = GetBot();
	if camp_num > 5 then
		JunglingState = JunglingStates.WaitingForCreeps;
		return
	end
	
	local Next_Camp = Rot[camp_num]
	if CampStatus[Next_Camp] then
		if GetUnitToLocationDistance(npcBot, Utility.Locations[Next_Camp])<150 then
			JunglingState = JunglingStates.KillingCreeps;
			CurCamp = Next_Camp
			return;
		end
		npcBot:Action_MoveToLocation(Utility.Locations[Next_Camp])
		return
	else
		camp_num = camp_num + 1;
	end
end

function KillCreeps()
	local npcBot=GetBot();
	
	local creeps=npcBot:GetNearbyCreeps(1000,true);
	
	if creeps==nil or #creeps==0 then
		CampStatus[CurCamp] = false;
		JunglingState=JunglingStates.MovingToNextCamp;
		return;
	end
	
	local MaxHPCreep=Utility.GetMaxHPCreep(creeps);
	npcBot:Action_AttackUnit(MaxHPCreep,true);
end

local StateActions = {
[JunglingStates.Start] = Start,
[JunglingStates.KillingCreeps] = KillCreeps,
[JunglingStates.MovingToNextCamp] = MoveToNextCamp,
[JunglingStates.WaitingForCreeps] = WaitForCreeps,
[JunglingStates.GettingBack] = GetBack
};

function  OnStart()
	print(GetBot():GetUnitName(),"Jungling!");
	if JunglingState~=JunglingStates.Start then
		JunglingState=JunglingStates.WaitingForCreeps;
	end
end

function OnEnd()
end

local function Updates()
	local npcBot=GetBot();
	
	local minutes = math.floor(DotaTime() / 60);
	local seconds = math.floor(DotaTime());
	local sec=seconds % 60;
	
	if seconds==30 or (minutes % 2 ==1 and sec==0) then
		CampStatus = {
			["RadiantMediumClose"]=true,
			["RadiantHardClose"]=true,
			["RadiantMediumRune"]=true,
			["RadiantEasy"]=true,
			["RadiantHardPull"]=true
		};
	end
	
end

function Think()
	local npcBot=GetBot();

	Updates();
	
	if npcBot:IsUsingAbility() or npcBot:IsChanneling() then
		return;
	end
	
	for _,r in pairs(Utility.RuneSpots) do
		local loc=GetRuneSpawnLocation(r);
		if GetUnitToLocationDistance(npcBot, loc)<900 and GetRuneStatus(r)==RUNE_STATUS_AVAILABLE then
			npcBot:Action_PickUpRune(r);
			return;
		end
	end
	StateActions[JunglingState]();
	
	npcBot.JunglingState = JunglingState;
end