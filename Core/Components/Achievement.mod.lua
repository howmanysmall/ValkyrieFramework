local Valkyrie = _G.Valkyrie;
local RemoteCommunication = Valkyrie:GetComponent("RemoteCommunication");

local Controller = {};
local extract;

-- |: Increment
-- |~ IncrementStep, Step
-- |< Instance<Player> Player, string AchievementName, int ?Increment = 1
-- |> bool Success, int NewStep, bool Awarded
Controller.Increment = function(...)
	local Player, AchievementName, Increment = extract(...);
	Increment = Increment or 1;
	
end;
Controller.IncrementStep = Controller.Increment;
Controller.Step = Controller.Increment;

-- |: Reveal
-- |~ Show
-- |< Instance<Player> Player, string AchievementName
-- |> bool Success
Controller.Reveal = function(...)
	local Player, AchievementName = extract(...);
	
end;
Controller.Show = Controller.Reveal

-- |: Award
-- |~ Unlock, Give, GiveAchievement
-- |< Instance<Player> Player, string AchievementName
-- |> bool Success, bool AlreadyAwarded
Controller.Award = function(...)
	local Player, AchievementName = extract(...);
	
end;
Controller.Unlock = Controller.Award;
Controller.Give = Controller.Award;
Controller.GiveAchievement = Controller.Award;

-- |: SetStep
-- |~ SetStage, SetState
-- |< Instance<Player> Player, string AchievementName, int NewStep
-- |> bool Success, bool NewStep
Controller.SetStep = function(...)
	local Player, AchievementName, NewStep = extract(...);
	
	-- If NewStep is less than the current step, keep the current.
end;
Controller.SetStage = Controller.SetStep;
Controller.SetState = Controller.SetStep;

-- |: List
-- |~ ListAchievements, GetAchievements
-- |< Instance<Player> Player
-- |> table {
--      ... = {
--        Name = string AchievementName,
--        ?Steps = int Steps,
--        Awarded = bool HasAchievement,
--        Hidden = bool IsHidden
--      }
--    } AchievementsList
Controller.List = function(...)
	local Player = extract(...);

end;
Controller.ListAchievements = Controller.List;
Controller.GetAchievements = Controller.List;

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
