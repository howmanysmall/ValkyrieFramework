local module									= {};
local english									= {
	["InfoFrame/Friends"] 						= "Friends";
	["InfoFrame/Username"]						= "%s's profile";
	["InfoFrame/Achievements"]					= "Achievements";
	["InfoFrame/FieldsContainer/FieldName1"] 	= "Total time in-game";
	["InfoFrame/FieldsContainer/FieldName2"] 	= "Total W.E.U.*";
	["InfoFrame/FieldsContainer/FieldName3"] 	= "Valkyrie member for";
	["InfoFrame/FieldsContainer/FieldCont3"] 	= "%s";
	["InfoFrame/FieldsContainer/FieldName4"] 	= "Last seen";
	["InfoFrame/FieldsContainer/FieldCont4"] 	= {"%s ago", "just now"};
	["InfoFrame/AchievementsContainer/SeeMore"] = "More";
	["InfoFrame/FriendsContainer/SeeMore"]		= "More";
	["InfoFrame/FieldsContainer/OnlineStatus"]	= "Online Status";
	["InfoFrame/FieldsContainer/OnlineStatusCont"] = {"Online: %s", "Offline"};
	["InfoFrame/FieldsContainer/FieldCont1"]	= "%s";
	["InfoFrame/FieldsContainer/FieldCont2"]	= "%s";
	
	["AchievementInfo/AchievementHeader"]			= "Achievement: %s";
	["AchievementInfo/FieldsContainer/FieldName1"]	= "Reward";
	["AchievementInfo/FieldsContainer/FieldName2"]	= "Awarded by";
	["AchievementInfo/FieldsContainer/FieldCont1"]	= "%d W.E.U.";
	["AchievementInfo/FieldsContainer/FieldCont2"]	= "%s";
	["AchievementInfo/DescriptionContainer"]		= "%q";
};

local finnish									= {
	["InfoFrame/Friends"] 						= "Ystavat";
	["InfoFrame/Username"]						= "Kayttajan %s profiili";
	["InfoFrame/Achievements"]					= "Saavutukset";
	["InfoFrame/FieldsContainer/FieldName1"] 	= "Aika peleissa yhteensa";
	["InfoFrame/FieldsContainer/FieldName2"] 	= "W.E.U-pisteita* yhteensa";
	["InfoFrame/FieldsContainer/FieldName3"] 	= "Liittynyt Valkyrie-yhteisoon";
	["InfoFrame/FieldsContainer/FieldCont3"] 	= "%s sitten";
	["InfoFrame/FieldsContainer/FieldName4"] 	= "Viimeksi paikalla";
	["InfoFrame/FieldsContainer/FieldCont4"] 	= {"%s sitten", "juuri asken"};
	["InfoFrame/AchievementsContainer/SeeMore"] = "Lisaa";
	["InfoFrame/FriendsContainer/SeeMore"]		= "Lisaa";
	["InfoFrame/FieldsContainer/OnlineStatus"]	= "Paikalla?";
	["InfoFrame/FieldsContainer/OnlineStatusCont"] = {"Kylla: %s", "Ei"};
	["InfoFrame/FieldsContainer/FieldCont1"]	= "%s";
	["InfoFrame/FieldsContainer/FieldCont2"]	= "%s";
	
	["AchievementInfo/AchievementHeader"]			= "Saavutus: %s";
	["AchievementInfo/FieldsContainer/FieldName1"]	= "Palkinto";
	["AchievementInfo/FieldsContainer/FieldName2"]	= "Myontanyt";
	["AchievementInfo/FieldsContainer/FieldCont1"]	= "%d W.E.U.-pistetta";
	["AchievementInfo/FieldsContainer/FieldCont2"]	= "%s";
	["AchievementInfo/DescriptionContainer"]		= "%q";
};

local esperanto									= {
	["InfoFrame/Friends"] 						= "Amikoj";
	["InfoFrame/Username"]						= "Profilo de %q";
	["InfoFrame/Achievements"]					= "Atingoj";
	["InfoFrame/FieldsContainer/FieldName1"] 	= "Totala tempo ludanta";
	["InfoFrame/FieldsContainer/FieldName2"] 	= "Totala W.E.U.*";
	["InfoFrame/FieldsContainer/FieldName3"] 	= "Valkyrano dum";
	["InfoFrame/FieldsContainerF/ieldCont3"] 	= "%s";
	["InfoFrame/FieldsContainer/FieldName4"] 	= "Lasta vidita";
	["InfoFrame/FieldsContainer/FieldCont4"] 	= {"%s antaux", "jxus"};
	["InfoFrame/AchievementsContainer/SeeMore"] = "Plu";
	["InfoFrame/FriendsContainer/SeeMore"]		= "Plu";
	["InfoFrame/FieldsContainer/OnlineStatus"]	= "Enreta Statuso";
	["InfoFrame/FieldsContainer/OnlineStatusCont"] = {"Enreta: %s", "Senkonekta"};
	["InfoFrame/FieldsContainer/FieldCont1"]	= "%s";
	["InfoFrame/FieldsContainer/FieldCont2"]	= "%s";

	["AchievementInfo/AchievementHeader"]			= "Atingo: %s";
	["AchievementInfo/FieldsContainer/FieldName1"]	= "Rekompenco";
	["AchievementInfo/FieldsContainer/FieldName2"]	= "Aljugxis per";
	["AchievementInfo/FieldsContainer/FieldCont1"]	= "%d W.E.U.";
	["AchievementInfo/FieldsContainer/FieldCont2"]	= "%s";
	["AchievementInfo/DescriptionContainer"]		= "%q";
};

local romanian									= {
	["InfoFrame/Friends"]       				= "Prieteni";
 	["InfoFrame/Username"]      				= "Profilul lui %s";
 	["InfoFrame/Achievements"]     				= "Realizari";
 	["InfoFrame/FieldsContainer/FieldName1"]  	= "Timp total in joc";
 	["InfoFrame/FieldsContainer/FieldName2"]  	= "W.E.U total*";
 	["InfoFrame/FieldsContainer/FieldName3"]  	= "Membru Valkyrie pentru";
 	["InfoFrame/FieldsContainer/FieldCont3"]  	= "%s";
 	["InfoFrame/FieldsContainer/FieldName4"]  	= "Vazut ultima data";
 	["InfoFrame/FieldsContainer/FieldCont4"]  	= {"%s in urma", "chiar acum"};
 	["InfoFrame/AchievementsContainer/SeeMore"] = "Mai mult";
 	["InfoFrame/FriendsContainer/SeeMore"]  	= "Mai mult";
 	["InfoFrame/FieldsContainer/OnlineStatus"] 	= "Status Conectat";
 	["InfoFrame/FieldsContainer/OnlineStatusCont"] = {"Conectat: %s", "Deconectat"};
 	["InfoFrame/FieldsContainer/FieldCont1"]  	= "%s";
 	["InfoFrame/FieldsContainer/FieldCont2"]  	= "%s";
 	
	["AchievementInfo/AchievementHeader"]			= "Realizare: %s";
	["AchievementInfo/FieldsContainer/FieldName1"]	= "Recompensa";
	["AchievementInfo/FieldsContainer/FieldName2"]	= "Castigat de";
	["AchievementInfo/FieldsContainer/FieldCont1"]	= "%d W.E.U.";
	["AchievementInfo/FieldsContainer/FieldCont2"]	= "%s";
	["AchievementInfo/DescriptionContainer"]		= "%q";
};

local swedish									= {
	["InfoFrame/Friends"]       				= "Vänner";
 	["InfoFrame/Username"]      				= "%s profil";
 	["InfoFrame/Achievements"]  				= "Vinningar";
 	["InfoFrame/FieldsContainer/FieldName1"]  	= "Total Speltid";
	["InfoFrame/FieldsContainer/FieldName2"]  	= "Total W.E.U.*";
 	["InfoFrame/FieldsContainer/FieldName3"]  	= "Valkyrie medlem för";
 	["InfoFrame/FieldsContainer/FieldCont3"]  	= "%s";
 	["InfoFrame/FieldsContainer/FieldName4"]  	= "Senast sedd";
 	["InfoFrame/FieldsContainer/FieldCont4"]  	= {"%s sedan", "just nu"};
 	["InfoFrame/AchievementsContainer/SeeMore"] = "Mer";
 	["InfoFrame/FriendsContainer/SeeMore"]  	= "Mer";
 	["InfoFrame/FieldsContainer/OnlineStatus"] 	= "Inloggnings Status";
 	["InfoFrame/FieldsContainer/OnlineStatusCont"] = {"Inloggad: %s", "Utloggad"};
 	["InfoFrame/FieldsContainer/FieldCont1"]  	= "%s";
 	["InfoFrame/FieldsContainer/FieldCont2"]  	= "%s";
 	
	["AchievementInfo/AchievementHeader"]			= "Veining: %s";
	["AchievementInfo/FieldsContainer/FieldName1"]	= "Pris";
	["AchievementInfo/FieldsContainer/FieldName2"]	= "Utdelad av";
	["AchievementInfo/FieldsContainer/FieldCont1"]	= "%d W.E.U.";
	["AchievementInfo/FieldsContainer/FieldCont2"]	= "%s";
	["AchievementInfo/DescriptionContainer"]		= "%q";
};

local russian									= {
	["InfoFrame/Friends"] 						= "Druz'a";
	["InfoFrame/Username"]						= "%s's profil'";
	["InfoFrame/Achievements"]					= "Vashi dostizhenija";
	["InfoFrame/FieldsContainer/FieldName1"] 	= "Za vse vremja v igre...";
	["InfoFrame/FieldsContainer/FieldName2"] 	= "Obshchij W.E.U.*";
	["InfoFrame/FieldsContainer/FieldName3"] 	= "Chlen Val'kirija za";
	["InfoFrame/FieldsContainer/FieldCont3"] 	= "%s";
	["InfoFrame/FieldsContainer/FieldName4"] 	= "Poslednee poseshchenije";
	["InfoFrame/FieldsContainer/FieldCont4"] 	= {"%s Zapust'", "tol'ko chto"};
	["InfoFrame/AchievementsContainer/SeeMore"] = "eshche";
	["InfoFrame/FriendsContainer/SeeMore"]		= "eshche";
	["InfoFrame/FieldsContainer/OnlineStatus"]	= "Online Status";
	["InfoFrame/FieldsContainer/OnlineStatusCont"] = {"Onlajn: %s", "Oflajn"};
	["InfoFrame/FieldsContainer/FieldCont1"]	= "%s";
	["InfoFrame/FieldsContainer/FieldCont2"]	= "%s";
	
	["AchievementInfo/AchievementHeader"]			= "Vy Vypolnili: %s";
	["AchievementInfo/FieldsContainer/FieldName1"]	= "Nagrada";
	["AchievementInfo/FieldsContainer/FieldName2"]	= "Nagrazhden na";
	["AchievementInfo/FieldsContainer/FieldCont1"]	= "%d W.E.U.";
	["AchievementInfo/FieldsContainer/FieldCont2"]	= "%s";
	["AchievementInfo/DescriptionContainer"]		= "%q";
};


local languages	= {
  fi_fi = finnish,
  en_us = english,
  en_uk = english,
  en_au = english,
  en_ca = english,
  eo_eo = esperanto,
  ro_ro = romanian,
	sv_se = swedish,
	ru_ru = russian
};

local function generateFormatArgs(path, choose, fmtargspath)
	if fmtargspath and fmtargspath.const then
		return unpack(fmtargspath.args);
	elseif fmtargspath and fmtargspath.gen then
		return fmtargspath.gen(path, choose);
	else
		return "";
	end
end

local function split(str, delim)
  local isEscape  = false;
  local isInString= false;
  local isInArray = false;
  local arrayLevel= 0;
  local ret       = {};
  local buf       = "";
  for i = 1, #str do
    if str:sub(i, i) == "\\" then
      isEscape = not isEscape;
    elseif str:sub(i, i) == "\"" and not isEscape then
      isInString = not isInString;
    elseif str:sub(i, i) == "[" and not isInString then
      isInArray  = true;
      arrayLevel = arrayLevel + 1;
    elseif str:sub(i, i) == "]" and not isInString then
      arrayLevel = arrayLevel - 1;
      if arrayLevel < 1 then
        isInArray = false;
      end
    elseif str:sub(i, i) == delim and not isInString and not isInArray then
      table.insert(ret, buf);
      buf = "";
    end
    if str:sub(i, i) ~= delim or isInString or isInArray then
      isEscape = false;
      buf = buf .. str:sub(i, i);
    end
  end

  if buf ~= "" then
    table.insert(ret, buf);
  end

  return ret;
end

local function setWithPath(currinst, path, overrides, value, choose, ...)
	local elems									= split(path, "/");
	local poverride								= table.remove(elems, 1);
	if currinst == nil then
		currinst								= overrides[poverride];
		if currinst == nil then
			return;
		end
	end
	
	for _, instname in next, elems do
		if instname:find(":") then
			instname = instname:sub(1, instname:find(":") - 1);
		end
		if not currinst:FindFirstChild(instname) then
			--warn("LOCALIZER: " .. instname .. " not found in " .. currinst:GetFullName() .. "!\nSkipping " .. value); -- Ignore this since we're going to localize whole different frames
			return;
		end
		currinst								= currinst[instname];
	end
	
	if type(currinst.Text) ~= "string" then
		warn("LOCALIZER: " .. currinst:GetFullName() .. " doesn't have a Text property!\nSkipping " .. value);
	end
	if type(value) == "table" then
		currinst.Text  = value[choose]:format(...);
	else
		currinst.Text = value:format(...);
	end
end

function module.localize(currinst, language, args, fmtargs, overrides)
	if type(languages[language]) ~= "table" then
		error("Invalid language!");
	end
	
	for path, newstr in next, languages[language] do
		setWithPath(currinst, path, overrides, newstr, args[path], generateFormatArgs(path, args[path], fmtargs[path]));
	end
end

return module;