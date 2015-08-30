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

local ce, fl, t = math.ceil, math.floor, os.time

local Days = {
    "Monday";
    "Tuesday";
    "Wednesday";
    "Thursday";
    "Friday";
    "Saturday";
    "Sunday"
}
local Months = {
    31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31
}
local iMonths = {
    "January";
    "Febuary";
    "March";
    "April";
    "May";
    "June";
    "July";
    "August";
    "September";
    "October";
    "November";
}

local function isLeapYear(year)
    if year%100 == 0 then
        return year%400==0;
    end;
    return year%4==0;
end
local function TimeFromSeconds(sec)
    sec = sec or t();
    sec = sec%DAY
    return string.format("%.2d:%.2d:%.2d", sec/HOUR, sec/60%60, sec%MINUTE)
end
local function DayFromSeconds(sec) -- Epoch was on a Thursday
    sec = sec or t();
    return Days[ce(((sec+3*DAY)%WEEK)/DAY)]
end
local function GetMonth(sec) -- Not so lazy months
    sec = sec or t();
    local days = ce(sec%AYEAR/DAY);
    local month = 0;
    local useLeapFeb = isLeapYear(fl(sec/YEAR+1970))
    for _,v in pairs(Months) do
        if _==2 and useLeapFeb then v=29 end;
        if days>v then
            days = days-v;
        else
            month = iMonths[_]
            break
        end
    end
    return month, days;
end
local function FullDate(sec) -- Remember...
    sec = sec or t();
    local ret = {}
    ret.Time = TimeFromSeconds(sec)
    ret.Month, ret.Date = GetMonth(sec)
    ret.Day = DayFromSeconds(sec)
    ret.Year = fl(sec/YEAR)+1970
    ret.Second = sec%MINUTE
    ret.Minute = fl(sec/60%60)
    ret.Hour = fl(sec%DAY/HOUR)
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
    iMONTH = iMONTH
}
