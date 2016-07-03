local SECOND = 1;
local MINUTE = 60*SECOND;
local HOUR = 60*MINUTE;
local DAY = 24*HOUR;
local WEEK = 7*DAY;
local YEAR = 365*DAY;
local LYEAR = 366*DAY;
local AYEAR = 365.25*DAY;
local TYEAR = 365.24*DAY;
local MONTH = TYEAR/12;
local iMONTH = DAY/0.0328549;

local ceil, floor, t, format = math.ceil, math.floor, os.time, string.format

local Days = {[0] = "Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"}
local iMonths = {"January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"}

local function TimeFromSeconds(sec)
    sec = sec or t()
    return format("%02d:%02d:%02d", floor(sec / HOUR % 24), floor(sec / MINUTE % MINUTE), floor(sec % MINUTE))
end

local function TimeEquations(sec, bool)
    local sec   = sec or t()
    local days  = floor(sec / DAY) + 719468
    local year  = floor((days >= 0 and days or days - 146096) / 146097)
    days        = (days - year * 146097)
    local years = floor((days - floor(days/1460) + floor(days/36524) - floor(days/146096))/365)
    days        = days - (365*years + floor(years/4) - floor(years/100))
    local month = floor((5*days + 2)/153)
    days        = days - floor((153*month + 2)/5) + 1
    month       = month + (month < 10 and 3 or -9)
    year        = years + year*400 + (month < 3 and 1 or 0)

    if bool then
        return year
    else
        return iMonths[month], days
    end
end

local function DayFromSeconds(sec)
    --- Finds weekday name
    sec = sec or t()
    return Days[(floor(sec / DAY) + 4) % 7]
end

local function GetMonth(sec)
    return TimeEquations(sec)
end

local function FullDate(sec) -- Remember...
	sec = sec or t()
	
    local ret = {}
    ret.Time = TimeFromSeconds(sec)
    ret.Month, ret.Date = TimeEquations(sec)
    ret.Day = DayFromSeconds(sec)
    ret.Year = TimeEquations(sec, true)
    ret.Second = floor(sec % MINUTE)
    ret.Minute = floor(sec / MINUTE % MINUTE)
    ret.Hour = floor(sec / HOUR % 24)
    return ret;
end

return {
    Time = FullDate;
    FullDate = FullDate;
    GetMonth = GetMonth;
    TimeFromSeconds = TimeFromSeconds;
    FormatTime = TimeFromSeconds;
    SECOND = SECOND;
    MINUTE = MINUTE;
    HOUR = HOUR;
    DAY = DAY;
    WEEK = WEEK;
    YEAR = YEAR;
    LYEAR = LYEAR;
    AYEAR = AYEAR;
    TYEAR = TYEAR;
    MONTH = MONTH;
    iMONTH = iMONTH;
}
