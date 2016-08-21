local Valkyrie = _G.Valkyrie;
local RemoteCommunication = Valkyrie:GetComponent("RemoteCommunication");
local IsInstance do
  local game = game;
  local GS = game.GetService;
  local pcall = pcall;
  local type = type;
  IsInstance = function(i)
    if type(i) ~= 'userdata' then return false end;
    local s,e = pcall(GS, game, i);
    if s and not e then
      return true
    end
    return false
  end
end;
local IntentService = Valkyrie:GetComponent("IntentService");

local Controller = {};
local extract;

-- |: Increment
-- |~ IncrementStep, Step
-- |< Instance<Player> Player, string AchievementName, int ?Increment = 1
-- |> bool Success, int NewStep, bool Awarded
Controller.Increment = function(...)
	local Player, AchievementName, Increment = extract(...);
	Increment = Increment or 1;
  if IsInstance(Player) and Player:IsA('Player') then Player = Player.UserId end;
	assert(
		type(Player) == 'number',
		"[Error][Valkyrie Achievements] (in Increment): You need to supply a Player or UserId as #1",
		2
	);
	assert(
		type(AchievementName) == 'string',
		"[Error][Valkyrie Achievements] (in Increment): You need to supply a string as #2",
		2
	);
	assert(
		type(Increment) == 'number',
		"[Error][Valkyrie Achievements] (in Increment): You need to supply a number as #3",
		2
	);
	Increment = math.floor(Increment+.5);
	local r,e = RemoteCommunication.Achievement:Increment{
		Player = Player.UserId;
		Achievement = AchievementName;
		Value = Increment;
	};
	if not r then
		return nil, e
	else
		if r.Awarded then
			IntentService:Broadcast("Achievement.Awarded", Player, Controller.Info(Player, AchievementName));
		else
			IntentService:Broadcast("Achievement.Updated", Player, Controller.Info(Player, AchievementName));
		end;
		return r;
	end;
end;
Controller.IncrementStep = Controller.Increment;
Controller.Step = Controller.Increment;

-- |: Reveal
-- |~ Show
-- |< Instance<Player> Player, string AchievementName
-- |> bool Success
Controller.Reveal = function(...)
	local Player, AchievementName = extract(...);
  if IsInstance(Player) and Player:IsA('Player') then Player = Player.UserId end;
	assert(
		type(Player) == 'number',
		"[Error][Valkyrie Achievements] (in Reveal): You need to supply a Player or UserId as #1",
		2
	);
	assert(
		type(AchievementName) == 'string',
		"[Error][Valkyrie Achievements] (in Reveal): You need to supply a string as #2",
		2
	);
	local r,e = RemoteCommunication.Achievement:Reveal{
		Player = Player.UserId;
		Achievement = AchievementName;
	};
	if not r then
		return nil, e
	else
    if r.AlreadyRevealed then
      warn(AchievementName.." was already revealed to "..Player.Name);
    else
		  IntentService:Broadcast("Achievement.Revealed", Player, Controller.Info(Player, AchievementName));
      IntentService:Broadcast("Achievement.Updated", Player, Controller.Info(Player, AchievementName));
    end
		return r;
	end;
end;
Controller.Show = Controller.Reveal

-- |: Award
-- |~ Unlock, Give, GiveAchievement, AwardAchievement
-- |< Instance<Player> Player, string AchievementName
-- |> bool Success, bool AlreadyAwarded
Controller.Award = function(...)
	local Player, AchievementName = extract(...);
  if IsInstance(Player) and Player:IsA('Player') then Player = Player.UserId end;
	assert(
		type(Player) == 'number',
		"[Error][Valkyrie Achievements] (in Award): You need to supply a Player or UserId as #1",
		2
	);
	assert(
		type(AchievementName) == 'string',
		"[Error][Valkyrie Achievements] (in Award): You need to supply a string as #2",
		2
	);
	local r,e = RemoteCommunication.Achievement:Award{
		Player = Player.UserId;
		Achievement = AchievementName;
	};
	if not r then
		return nil, e
	else
		if r.AlreadyAwarded then
			warn(AchievementName.." was already awarded to "..Player.Name);
		else
			IntentService:Broadcast("Achievement.Awarded", Player, Controller.Info(Player, AchievementName));
		end;
		return r;
	end;
end;
Controller.Unlock = Controller.Award;
Controller.Give = Controller.Award;
Controller.GiveAchievement = Controller.Award;
Controller.AwardAchievement = Controller.Award;

-- |: SetStep
-- |~ SetStage, SetState
-- |< Instance<Player> Player, string AchievementName, int NewStep
-- |> bool Success, int NewStep, bool Awarded
Controller.SetStep = function(...)
	local Player, AchievementName, NewStep = extract(...);
  if IsInstance(Player) and Player:IsA('Player') then Player = Player.UserId end;
	assert(
		type(Player) == 'number',
		"[Error][Valkyrie Achievements] (in SetStep): You need to supply a Player or UserId as #1",
		2
	);
	assert(
		type(AchievementName) == 'string',
		"[Error][Valkyrie Achievements] (in SetStep): You need to supply a string as #2",
		2
	);
	assert(
		type(AchievementName) == 'number',
		"[Error][Valkyrie Achievements] (in SetStep): You need to supply a number as #3",
		2
	);
	NewStep = math.floor(NewStep+.5);
	-- If NewStep is less than the current step, keep the current.
	local r,e = RemoteCommunication.Achievement:SetStep{
		Player = Player.UserId;
		Achievement = AchievementName;
		Value = NewStep;
	};
	if not r then
		return r,e
	else
		if r.Awarded then
			IntentService:Broadcast("Achievement.Awarded", Player, Controller.Info(Player, AchievementName));
		else
			IntentService:Broadcast("Achievement.Updated", Player, Controller.Info(Player, AchievementName));
		end;
		return r;
	end;
end;
Controller.SetStage = Controller.SetStep;
Controller.SetState = Controller.SetStep;

-- |: List
-- |~ ListAchievements, GetAchievements
-- |< Instance<Player> Player
-- |> table Data {
--      ... = {
--        DisplayName = string AchievementDisplayName,
--        Name = string AchievementIdentifierName,
--        ?Steps = int Steps,
--        Awarded = bool HasAchievement,
--        Hidden = bool IsHidden
--      }
--    } AchievementsList
Controller.List = function(...)
	local Player = extract(...);
  if IsInstance(Player) and Player:IsA('Player') then Player = Player.UserId end;
	assert(
		type(Player) == 'number',
		"[Error][Valkyrie Achievements] (in List): You need to supply a Player or UserId as #1",
		2
	);
	local r,e = RemoteCommunication.Achievement:GetAchievements{
		Player = Player.UserId;
	};
	if not r then
		return nil, e
	else
		return r
	end;
end;
Controller.ListAchievements = Controller.List;
Controller.GetAchievements = Controller.List;

Controller.ListAll = function(...)
	local Player = extract(...);
  if IsInstance(Player) and Player:IsA('Player') then Player = Player.UserId end;
	assert(
		type(Player) == 'number',
		"[Error][Valkyrie Achievements] (in ListAll): You need to supply a Player or UserId as #1",
		2
	);
	local r,e = RemoteCommunication.Achievement:GetAllAchievements{
		Player = Player.UserId;
	};
	if not r then
		return nil, e
	else
		return r
	end;
end;
Controller.ListAllAchievements = Controller.ListAll;
Controller.GetAllAchievements = Controller.ListAll;

-- |: Info
-- |~ GetInfo, AchievementInfo, GetAchievementInfo
-- |< string AchievementName
-- |> table {
--      Name = string AchievementDisplayName,
--      MaxSteps = int MaxSteps
--      Description = string Description,
--      Image = int AssetId,
--      Reward = int PointsReward,
--      CurrentStep = int CurrentStep,
--      Hidden = bool Hidden,
--      Awarded = bool Awarded
--    } AchievementInfo
Controller.Info = function(...)
  local Player, AchievementName = extract(...);
  if IsInstance(Player) and Player:IsA('Player') then Player = Player.UserId end;
	assert(
		type(Player) == 'number',
		"[Error][Valkyrie Achievements] (in Info): You need to supply a Player or UserId as #1",
		2
	);
	assert(
		type(AchievementName) == 'string',
		"[Error][Valkyrie Achievements] (in Info): You need to supply a string as #2",
		2
	);
	local r,e = RemoteCommunication.Achievement:GetAchievementInfo{
		Name = AchievementName;
    Player = Player;
	};
	if not r then
		return nil, e
	else
		return r;
	end;
end;
Controller.GetInfo = Controller.Info;
Controller.AchievementInfo = Controller.Info;
Controller.GetAchievementInfo = Controller.Info;

-- |: PlainInfo
-- |~ GetPlainInfo, AchievementPlainInfo, GetAchievementPlainInfo
-- |< string AchievementName
-- |> table {
--      Name = string AchievementTrueName,
--      MaxSteps = int MaxSteps
--      Description = string Description,
--      Image = int AssetId,
--      Reward = int PointsReward
--    } AchievementInfo
Controller.PlainInfo = function(...)
  local AchievementName = extract(...);
	assert(
		type(AchievementName) == 'string',
		"[Error][Valkyrie Achievements] (in PlainInfo): You need to supply a string as #1",
		2
	);
	local r,e = RemoteCommunication.Achievement:GetPlainAchievementInfo{
		Name = AchievementName;
	};
	if not r then
		return nil, e
	else
		return r;
	end;
end;
Controller.GetPlainInfo = Controller.PlainInfo;
Controller.AchievementPlainInfo = Controller.PlainInfo;
Controller.GetAchievementPlainInfo = Controller.PlainInfo;

Controller.Stats = function(...)
  local AchievementName = extract(...);
	assert(
		type(AchievementName) == 'string',
		"[Error][Valkyrie Achievements] (in Stats): You need to supply a string as #1",
		2
	);
	local r,e = RemoteCommunication.Achievement:GetAchievementStats{
		Name = AchievementName;
	};
	if not r then
		return nil, e
	else
		return r;
	end;
end;
Controller.GetStats = Controller.Stats;
Controller.AchievementStats = Controller.Stats;
Controller.GetAchievementStats = Controller.Stats;

local _controller = newproxy(true);
local mt = getmetatable(_controller);
mt.__index = Controller;
mt.__metatable = "Locked metatable: Valkyrie";
mt.__tostring = function()
	return "Valkyrie Achievements controller";
end;

extract = function(...)
	if ... == _controller then
		return select(2,...);
	else
		return ...
	end;
end;

return _controller;
