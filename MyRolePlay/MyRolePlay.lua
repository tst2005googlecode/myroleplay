mrpVersion = "MyRolePlay/"..GetAddOnMetadata("MyRolePlay", "Version")
mrpSupports = "mrp,rsp"

MRP_EMPTY_STRING = "";
mrpIsInitialized = false;
mrpIsRSPInitialized = false;

mrpRSPEventTimer = nil;

mrpWaitingForInfoList = {};

mrpWaitingForDescriptionList = {};
mrpDescriptionList = {};

mrpWaitingForHistoryList = {};
mrpHistoryList = {};

mrpCurCharacterSheetTarget = "";

MRP_DEBUG = false;

BINDING_HEADER_MYROLEPLAY = "MyRolePlay";

function mrpRegisterSlashCommands()
	SLASH_MYROLEPLAY1 = "/mrp";
	SLASH_MYROLEPLAY2 = "/MyRolePlay";

	SlashCmdList["MYROLEPLAY"] = function(args)
		if (string.lower(args) == MRP_LOCALE_Slash_Help_Option) then
			mrpDisplayMessage(MRP_LOCALE_Slash_Help);
		elseif (string.lower(args) == "version") then
			mrpDisplayMessage(mrpVersion);
		else
			mrpDisplayMessage(MRP_LOCALE_Slash_Not_A_Command);
		end
	end;
end

function mrpOnLoad()
	this:RegisterEvent("VARIABLES_LOADED");
	this:RegisterEvent("UPDATE_MOUSEOVER_UNIT");
	this:RegisterEvent("PLAYER_TARGET_CHANGED");

	--Slash Commands
	mrpRegisterSlashCommands();
end

function mrpOnEvent(event)
	if (event == "VARIABLES_LOADED") then
		mrpInitialize();
	end

	if (event == "UPDATE_MOUSEOVER_UNIT" and mrpCheckSettings("Tooltip", "enabled") == true) then
		mrpDisplayTooltip("mouseover", "MOUSEOVER");
	end

	if (event == "PLAYER_TARGET_CHANGED" and mrpIsInitialized == true) then

		mrpCurrentTarget = UnitName("target");

		if ((UnitIsPlayer("target")) and ((mrpIsPlayerInMRP(mrpCurrentTarget) ~= nil) or (mrpCurrentTarget==UnitName("player")))) then
			mrpButtonIconFrame:Show();
		else
			mrpButtonIconFrame:Hide();
		end
	end
end


function mrpChannelListFilter(self,event,...)
	local i = GetChannelName("xtensionxtooltip2");
	if (i and i ~= 0) then
		if (arg4 == i .. ". xtensionxtooltip2") then
			return true
		end
	end
	local i = GetChannelName("MyWarcraftCo");
	if (i and i ~= 0) then
		if (arg4 == i .. ". MyWarcraftCo") then
			return true
		end
	end
	return false
end

--[[ Outfitter
	mrpOnMRPEvent takes an 'event' that an addon generates and does something with that even. Much like the WoW OnEvent script works.
	For this addon, please insert the following code right AFTER you change gOutfitter_Settings.Outfits.Complete.Name (when you switch outfits).
	This is all the code you need to put into your addon to be compatible with MyRolePlay. ]]
--mrpOnMRPEvent("CHANGE_OUTFIT", gOutfitter_Settings.Outfits.Complete.Name);

--[[function mrpOnMRPEvent(event, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9)
	if (event == "CHANGE_OUTFIT") then
		if (arg2 ~= nil and arg2 ~= MRP_EMPTY_STRING) then
			local profileExists = false;

			for i = 1, select("#", MyRolePlay.Profile) do
				if (MyRolePlay.Profile[i].ProfileName == arg2) then
					mrpChangeProfile(arg2);
					profileExists = true;
					break;
				end
			end

			if (profileExists == false) then
				mrpSaveProfile(arg2);
			else
				mrpChangeProfile(arg2);
			end
		end
	elseif (event == "WEAR_OUTFIT") then
		if (arg2 ~= nil and arg2 ~= MRP_EMPTY_STRING) then
			local profileExists = false;

			for i = 1, select("#", MyRolePlay.Profile) do
				if (MyRolePlay.Profile[i].ProfileName == arg2) then
					mrpChangeProfile(arg2);
					profileExists = true;
					break;
				end
			end

			if (profileExists == false) then
				mrpSaveProfile(arg2);
			else
				mrpChangeProfile(arg2);
			end
		end
	end
end]]

function mrpInitialize()
	if (mdbDatabaseExists("MyRolePlayCharacter") == false) then
		mrpCreateNewDatabase();
	end

	mrpInitializeRAM();

	mrpInitializeExtras();
	--This is a really nasty hack. I am resetting the OnShow and OnHide scripts for the PaperDollFrame from Blizzard (the character sheet) and adding my own stuff to it.
	_G["PaperDollFrame"]:SetScript("OnShow", function() PaperDollFrame_OnShow() if (mrpUniversalFrameState == 1) then mrpUniversalFrame:Show() end mrpUniversalFrameToggle:Show() mrpUpdateText() end);
	_G["PaperDollFrame"]:SetScript("OnHide", function() PaperDollFrame_OnHide() mrpUniversalFrame:Hide() mrpUniversalFrameToggle:Hide() end);

	_G["PlayerFrame"]:SetScript("OnEnter", function()
		if ( SpellIsTargeting() ) then
			if ( SpellCanTargetUnit(this.unit) ) then
				SetCursor("CAST_CURSOR");
			else
				SetCursor("CAST_ERROR_CURSOR");
			end
		end

		--GameTooltip_SetDefaultAnchor(GameTooltip, this);
		GameTooltipTextLeft1:Hide();
		GameTooltipTextRight1:Hide();
		GameTooltip_SetDefaultAnchor(GameTooltip, UIParent);
		mrpDisplayTooltip("player", "PLAYER");
	end);

	mrpMoveIcon();

	mrpCharacterButton:SetChecked(true);
	mrpCharacterButton:Disable();
	mrpOptionsPage1Button:SetChecked(true);
	mrpOptionsPage1Button:Disable();

	if (not MRP_DEBUG) then
		ChatFrame_AddMessageEventFilter("CHAT_MSG_CHANNEL_LIST",mrpChannelListFilter);
	end


	--[[if (Outfitter_RegisterOutfitEvent) then
		Outfitter_RegisterOutfitEvent("WEAR_OUTFIT", mrpOnMRPEvent);
	end]]

	mrpUniversalFrameState = 0;
end

function mrpDisplayMessage(msg)
	mduDisplayMessage(msg, "MyRolePlay", .2, .2, 1, 1, 1, 0);
end

function mrpContinueInit(channelName)
	if (channelName == "MyWarcraftCo") then
		mrpRegisterDataIds();
		mcoUnregisterEvent("MCO_CHANNEL_JOINED", mrpContinueInit);
		mrpRespondTimer = mtiCreateNewTimer(1);
		mrpDescTimer = mtiCreateNewTimer(1);
		mrpHistTimer = mtiCreateNewTimer(1);
		mtiRegisterEvent(3, mrpListMRPChannel);
	end
end

function mrpListMRPChannel()
	mtiUnregisterEvent(mtiGetCurEventId());
	ListChannelByName("MyWarcraftCo");
end

function mrpUpdatePlayerListDescription(playerName, descriptionPiece, descriptionVersion)
	if (mrpIsWaitingForDescription(playerName) == true) then
		table.insert(mrpDescriptionList, 1, {});
		mrpDescriptionList[1].playerName = playerName;
		mrpDescriptionList[1].description = descriptionPiece;
		mrpDescriptionList[1].descriptionVersion = descriptionVersion;
		mrpDescriptionList[1].wanted = true;

		mtiRegisterEvent(180, mrpClearWantedDescription);

		mrpRemoveWaitingForDescription(playerName);

		if (mrpDescriptionList[11]) then
			table.remove(mrpDescriptionList, 11);
		end

		if (mrpCharacterSheet1Main:IsShown() and mrpCurCharacterSheetTarget == mrpDescriptionList[1].playerName) then
			mrpCharSheet1DescBox:SetText(mrpDescriptionList[1].description);
		end

	elseif (mrpIsWaitingForDescription(playerName) == false) then
		for i = 1, table.maxn(mrpDescriptionList) do
			if (mrpDescriptionList[i].playerName == playerName) then
				if (mrpDescriptionList[i].descriptionVersion < descriptionVersion) then
					mrpDescriptionList[i].description = mrpDescriptionList[i].description .. descriptionPiece;
					mrpDescriptionList[i].descriptionVersion = descriptionVersion;
				else
					mrpDescriptionList[i].description = descriptionPiece;
					mrpDescriptionList[i].descriptionVersion = descriptionVersion;
				end

				if (mrpDescriptionList[11]) then
					table.remove(mrpDescriptionList, 11);
				end

				if (mrpCharacterSheet1Main:IsShown() and mrpCurCharacterSheetTarget == mrpDescriptionList[i].playerName) then
					mrpCharSheet1DescBox:SetText(mrpDescriptionList[i].description);
				end

				return;
			end
		end

		for i = 1, table.maxn(mrpDescriptionList) do
			if (mrpDescriptionList[i].wanted == false) then
				table.insert(mrpDescriptionList, i, {});
				mrpDescriptionList[i].playerName = playerName;
				mrpDescriptionList[i].description = descriptionPiece;
				mrpDescriptionList[i].descriptionVersion = descriptionVersion;
				mrpDescriptionList[i].wanted = false;

				if (mrpDescriptionList[11]) then
					table.remove(mrpDescriptionList, 11);
				end

				if (mrpCharacterSheet1Main:IsShown() and mrpCurCharacterSheetTarget == mrpDescriptionList[i].playerName) then
					mrpCharSheet1DescBox:SetText(mrpDescriptionList[i].description);
				end

				return;
			end
		end

		local newSize = table.maxn(mrpDescriptionList) + 1;

		table.insert(mrpDescriptionList, newSize, {});
		mrpDescriptionList[newSize].playerName = playerName;
		mrpDescriptionList[newSize].description = descriptionPiece;
		mrpDescriptionList[newSize].descriptionVersion = descriptionVersion;
		mrpDescriptionList[newSize].wanted = false;

		if (mrpDescriptionList[11]) then
			table.remove(mrpDescriptionList, 11);
		end

		if (mrpCharacterSheet1Main:IsShown() and mrpCurCharacterSheetTarget == mrpDescriptionList[newSize].playerName) then
			mrpCharSheet1DescBox:SetText(mrpDescriptionList[newSize].description);
		end

		return;
	end
end

function mrpUpdatePlayerListHistory(playerName, historyPiece, historyVersion)
	if (mrpIsWaitingForHistory(playerName) == true) then
		table.insert(mrpHistoryList, 1, {});
		mrpHistoryList[1].playerName = playerName;
		mrpHistoryList[1].history = historyPiece;
		mrpHistoryList[1].historyVersion = historyVersion;
		mrpHistoryList[1].wanted = true;

		mtiRegisterEvent(180, mrpClearWantedHistory);

		mrpRemoveWaitingForHistory(playerName);

		if (mrpHistoryList[11]) then
			table.remove(mrpHistoryList, 11);
		end

		if (mrpCharacterSheet1Main:IsShown() and mrpCurCharacterSheetTarget == mrpHistoryList[1].playerName) then
			mrpCharSheet1HistBox:SetText(mrpHistoryList[1].history);
		end

	elseif (mrpIsWaitingForHistory(playerName) == false) then
		for i = 1, table.maxn(mrpHistoryList) do
			if (mrpHistoryList[i].playerName == playerName) then
				if (mrpHistoryList[i].historyVersion < historyVersion) then
					mrpHistoryList[i].history = mrpHistoryList[i].history .. historyPiece;
					mrpHistoryList[i].historyVersion = historyVersion;
				else
					mrpHistoryList[i].history = historyPiece;
					mrpHistoryList[i].historyVersion = historyVersion;
				end

				if (mrpHistoryList[11]) then
					table.remove(mrpHistoryList, 11);
				end

				if (mrpCharacterSheet1Main:IsShown() and mrpCurCharacterSheetTarget == mrpHistoryList[i].playerName) then
					mrpCharSheet1HistBox:SetText(mrpHistoryList[i].history);
				end

				return;
			end
		end

		for i = 1, table.maxn(mrpHistoryList) do
			if (mrpHistoryList[i].wanted == false) then
				table.insert(mrpHistoryList, i, {});
				mrpHistoryList[i].playerName = playerName;
				mrpHistoryList[i].history = historyPiece;
				mrpHistoryList[i].historyVersion = historyVersion;
				mrpHistoryList[i].wanted = false;

				if (mrpHistoryList[11]) then
					table.remove(mrpHistoryList, 11);
				end

				if (mrpCharacterSheet1Main:IsShown() and mrpCurCharacterSheetTarget == mrpHistoryList[i].playerName) then
					mrpCharSheet1HistBox:SetText(mrpHistoryList[i].history);
				end

				return;
			end
		end

		local newSize = table.maxn(mrpHistoryList) + 1;

		table.insert(mrpHistoryList, newSize, {});
		mrpHistoryList[newSize].playerName = playerName;
		mrpHistoryList[newSize].history = historyPiece;
		mrpHistoryList[newSize].historyVersion = historyVersion;
		mrpHistoryList[newSize].wanted = false;

		if (mrpHistoryList[11]) then
			table.remove(mrpHistoryList, 11);
		end

		if (mrpCharacterSheet1Main:IsShown() and mrpCurCharacterSheetTarget == mrpHistoryList[newSize].playerName) then
			mrpCharSheet1HistBox:SetText(mrpHistoryList[newSize].history);
		end

		return;
	end
end

function mrpClearWantedDescription()
	for i = table.maxn(mrpDescriptionList), 1, -1 do
		if (mrpDescriptionList[i].wanted == true) then
			mrpDescriptionList[i].wanted = false;

			break;
		end
	end

	mtiUnregisterEvent(mtiGetCurEventId());
end

function mrpClearWantedHistory()
	for i = table.maxn(mrpHistoryList), 1, -1 do
		if (mrpHistoryList[i].wanted == true) then
			mrpHistoryList[i].wanted = false;

			break;
		end
	end

	mtiUnregisterEvent(mtiGetCurEventId());
end

function mrpGetDescription(playerName)
	for i = 1, table.maxn(mrpDescriptionList) do
		if (mrpDescriptionList[i].playerName == playerName) then
			return mrpDescriptionList[i].description;
		end
	end
end

function mrpGetHistory(playerName)
	for i = 1, table.maxn(mrpHistoryList) do
		if (mrpHistoryList[i].playerName == playerName) then
			return mrpHistoryList[i].history;
		end
	end
end

function mrpHaveDescription(playerName)
	for i = 1, table.maxn(mrpDescriptionList) do
		if (mrpDescriptionList[i].playerName == playerName) then
			return true;
		end
	end

	return false;
end

function mrpHaveHistory(playerName)
	for i = 1, table.maxn(mrpHistoryList) do
		if (mrpHistoryList[i].playerName == playerName) then
			return true;
		end
	end

	return false;
end

function mrpAddWaitingForInfo(target)
	local newSize = table.maxn(mrpWaitingForInfoList) + 1;

	table.insert(mrpWaitingForInfoList, newSize);
	mrpWaitingForInfoList[newSize] = target;
end

function mrpAddWaitingForDescription(target)
	local newSize = table.maxn(mrpWaitingForDescriptionList) + 1;

	table.insert(mrpWaitingForDescriptionList, newSize);
	mrpWaitingForDescriptionList[newSize] = target;
end

function mrpAddWaitingForHistory(target)
	local newSize = table.maxn(mrpWaitingForHistoryList) + 1;

	table.insert(mrpWaitingForHistoryList, newSize);
	mrpWaitingForHistoryList[newSize] = target;
end

function mrpIsWaitingForInfo(target)
	for i = 1, table.maxn(mrpWaitingForInfoList) do
		if (mrpWaitingForInfoList[i] == target) then
			return true;
		end
	end
	return false;
end

function mrpIsWaitingForDescription(target)
	for i = 1, table.maxn(mrpWaitingForDescriptionList) do
		if (mrpWaitingForDescriptionList[i] == target) then
			return true;
		end
	end
	return false;
end

function mrpIsWaitingForHistory(target)
	for i = 1, table.maxn(mrpWaitingForHistoryList) do
		if (mrpWaitingForHistoryList[i] == target) then
			return true;
		end
	end
	return false;
end

function mrpRemoveWaitingForInfo(target)
	for i, waiting in ipairs(mrpWaitingForInfoList) do
		if (waiting == target) then
			table.remove(mrpWaitingForInfoList, i);
			return;
		end
	end
end

function mrpRemoveWaitingForDescription(target)
	for i, waiting in ipairs(mrpWaitingForDescriptionList) do
		if (waiting == target) then
			table.remove(mrpWaitingForDescriptionList, i);
			return;
		end
	end
end

function mrpRemoveWaitingForHistory(target)
	for i, waiting in ipairs(mrpWaitingForHistoryList) do
		if (waiting == target) then
			table.remove(mrpWaitingForHistoryList, i);
			return;
		end
	end
end

function mrpGetRSPChannelList()
	ListChannelByName("xtensionxtooltip2");
	mtiUnregisterEvent(mrpRSPEventTimer);
end

function mrpFinalizeInit()
	mtiUnregisterEvent(mtiGetCurEventId());
	mrpDisplayMessage(MRP_LOCALE_SUCCESS_INIT);
	mrpIsInitialized = true;
	mcoRegisterEvent("MCO_CHANNEL_JOINED", mrpInitRSP);
	mcoRegisterChannel("xtensionxtooltip2");
end

function mrpInitRSP(channelName)
	if (channelName == "xtensionxtooltip2") then
		mcoUnregisterEvent("MCO_CHANNEL_JOINED", mrpInitRSP);
		mrpRSPEventTimer = mtiRegisterEvent(3, mrpGetRSPChannelList);
	end
end

function mrpSetCurProfile(profile)
	mdbHardEditData("MyRolePlayCharacter", "CurProfile", "name", profile);
end

function mrpCheckSettings(settingField, setting)
	return mdbGetData("MyRolePlaySettings", settingField, setting, 1);
end

function mrpSettingFieldExists(settingField)
	return mdbTableExists("MyRolePlaySettings", settingField);
end

function mrpChangeSettings(settingField, setting, newValue)
	mdbHardEditData("MyRolePlaySettings", settingField, setting, newValue);
end

function mrpAddSettingField(settingField)
	mdbCreateTable("MyRolePlaySettings", settingField);
end

function mrpAddSetting(settingField, setting, defaultValue)

	if (mdbColumnExists("MyRolePlaySettings", settingField, setting) == false) then
		mdbAddColumn("MyRolePlaySettings", settingField, setting);
	end

	if (defaultValue == nil) then
		defaultValue = MDB_NIL;
	end

	if (mdbGetNumValues("MyRolePlaySettings", settingField) == 0) then
		mdbInsertIntoData("MyRolePlaySettings", settingField, setting, defaultValue);
	else
		mdbHardEditData("MyRolePlaySettings", settingField, setting, defaultValue);
	end

	mduDisplayMessage("Adding Setting " .. setting .. " to " .. settingField .. " :: Default value of " .. tostring(defaultValue));
	mduDisplayMessage(tostring(mrpCheckSettings(settingField, setting)));
end

function mrpAddAddonCompatability(addonName)
	mrpAddSetting("Addon Compatability", addonName, true);
end

function mrpIsAddonCompatabilityEnabled(addonName)
	return mrpCheckSettings("Addon Compatability", addonName);
end

function mrpAddNewField(fieldName)
	mdbCreateTable("MyRolePlayCharacter", fieldName);
end

function mrpAddNewInfo(fieldName, name, defaultValue)
	mdbAddColumn("MyRolePlayCharacter", fieldName, name);
	mdbAddColumn("MyRolePlayPlayerList", fieldName, name);

	if (mdbGetNumValues("MyRolePlayCharacter", fieldName) == 0) then
		mdbInsertData("MyRolePlayCharacter", fieldName, defaultValue);
	else
		mdbHardEditData("MyRolePlayCharacter", fieldName, name, defaultValue);
	end

	if (mdbGetNumValues("MyRolePlayPlayerList", fieldName) == 0) then
		mdbInsertData("MyRolePlayPlayerList", fieldName, defaultValue);
	else
		mdbHardEditData("MyRolePlayPlayerList", fieldName, name, defaultValue);
	end
end

function mrpGetInfo(typeWanted, field, profile)
	local temp = mdbSearchData("MyRolePlayCharacter", mdbCreateTablePacket(nil, typeWanted), mdbCreateColumnPacket(field), mdbCreateSearchPacket("profile", "=", profile));

	return temp[1][1];
end

function mrpEditPlayerListInfo(playerName, location, field, newData)
	mdbEditData("MyRolePlayPlayerList", location, field, newData, mdbCreateSearchPacket("playerName", "=", playerName));
end

function mrpGetPlayerListInfo(typeWanted, field, playerName)
	local temp = mdbSearchData("MyRolePlayPlayerList", mdbCreateTablePacket(nil, typeWanted), mdbCreateColumnPacket(field), mdbCreateSearchPacket("playerName", "=", playerName));

	return temp[1][1];
end

function mrpGetCurProfile()
	local temp = mdbHardSearchData("MyRolePlayCharacter", mdbCreateTablePacket(nil, "CurProfile"), mdbCreateColumnPacket("name"));

	return temp[1][1];
end

function mrpGetNumProfiles()
	local temp = mdbHardSearchData("MyRolePlayCharacter", mdbCreateTablePacket(nil, "Identification"), mdbCreateColumnPacket("profile"));

	return table.maxn(temp);
end

function mrpProfileExists(profileName)
	local temp = mdbSearchData("MyRolePlayCharacter", mdbCreateTablePacket(nil, "Identification"), mdbCreateColumnPacket("profile"), mdbCreateSearchPacket("profile", "=", profileName));

	if (temp and temp ~= nil and temp[1] and temp[1] ~= nil) then
		return true;
	end

	return false;
end

function mrpGetNumTooltipOrders()
	local temp = mdbHardSearchData("MyRolePlayTooltip", mdbCreateTablePacket(nil, "Orders"), mdbCreateColumnPacket("id"));

	return table.maxn(temp);
end

function mrpSaveVariable(location, field, varToSave)

	mdbEditData("MyRolePlayCharacter", location, field, varToSave, mdbCreateSearchPacket("profile", "=", mrpGetCurProfile()));

	mrpUpdateText();

	if (mrpIsInitialized == true) then
		mrpSendMessage(MRP_RESPOND);
	end

	if (mrpIsRSPInitialized == true) then
		mrpRSPBroadcastData();
	end
end

function mrpUpdateText()
	local curProfile = mrpGetCurProfile();
	local search = mdbCreateSearchPacket("profile", "=", curProfile);
	local identification = mdbSearchData("MyRolePlayCharacter", mdbCreateTablePacket(nil, "Identification"), mdbCreateColumnPacket("prefix", "firstname", "middlename", "surname", "title", "nickname", "housename"), search);
	local appearance = mdbSearchData("MyRolePlayCharacter", mdbCreateTablePacket(nil, "Appearance"), mdbCreateColumnPacket("eyeColour", "height", "weight", "currentEmotion", "description"), search);
	local lore = mdbSearchData("MyRolePlayCharacter", mdbCreateTablePacket(nil, "Lore"), mdbCreateColumnPacket("curHome", "birthPlace", "motto", "history"), search);

	local prefix, firstname, middlename, surname, title, nickname, housename = unpack(identification[1]);
	local eyeColour, height, weight, currentEmotion, description = unpack(appearance[1]);
	local curHome, birthPlace, motto, history = unpack(lore[1]);

	FirstnameText:SetText(firstname);

	PlayerName:SetText(firstname);

	MiddlenameText:SetText(middlename);

	SurnameText:SetText(surname);

	PrefixText:SetText(prefix);

	TitleText:SetText(title);

	NicknameText:SetText(nickname);

	HousenameText:SetText(housename);

	EyeColourText:SetText(eyeColour);

	HeightText:SetText(height);

	WeightText:SetText(weight);

	DescriptionText:SetText(description);

	CurrentEmotionText:SetText(currentEmotion);

	HistoryText:SetText(history);

	MottoText:SetText(motto);

	HomecityText:SetText(curHome);

	BirthcityText:SetText(birthPlace);
end

function mrpEncodeStatus(status)
	if (status == MRP_LOCALE_DropDownCSNone) then
		status = "CS0";
	elseif (status == MRP_LOCALE_DropDownCSOOC) then
		status = "CS1";
	elseif (status == MRP_LOCALE_DropDownCSIC) then
		status = "CS2";
	elseif (status == MRP_LOCALE_DropDownCSFFAIC) then
		status = "CS3";
	elseif (status == MRP_LOCALE_DropDownCSST) then
		status = "CS4";
	elseif (status == MRP_LOCALE_DropDownRP0) then
		status = "RP0";
	elseif (status == MRP_LOCALE_DropDownRP1) then
		status = "RP1";
	elseif (status == MRP_LOCALE_DropDownRP1) then
		status = "RP";
	elseif (status == MRP_LOCALE_DropDownRP2) then
		status = "RP2";
	elseif (status == MRP_LOCALE_DropDownRP3) then
		status = "RP3";
	elseif (status == MRP_LOCALE_DropDownRP4) then
		status = "RP4";
	end

	return status;
end

function mrpDecodeStatus(status)
	if (status == "none") then
		status = MRP_LOCALE_DropDownCSNone;
	elseif (status == "ooc") then
		status = MRP_LOCALE_DropDownCSOOC;
	elseif (status == "ic") then
		status = MRP_LOCALE_DropDownCSIC;
	elseif (status == "ffa-ic") then
		status = MRP_LOCALE_DropDownCSFFAIC;
	elseif (status == "st") then
		status = MRP_LOCALE_DropDownCSST;
	elseif (status == "CS0") then
		status = MRP_LOCALE_DropDownCSNone;
	elseif (status == "CS1") then
		status = MRP_LOCALE_DropDownCSOOC;
	elseif (status == "CS2") then
		status = MRP_LOCALE_DropDownCSIC;
	elseif (status == "CS3") then
		status = MRP_LOCALE_DropDownCSFFAIC;
	elseif (status == "CS4") then
		status = MRP_LOCALE_DropDownCSST;
	elseif (status == "RP0") then
		status = MRP_LOCALE_DropDownRP0;
	elseif (status == "RP1") then
		status = MRP_LOCALE_DropDownRP1;
	elseif (status == "RP") then
		status = MRP_LOCALE_DropDownRP1;
	elseif (status == "RP2") then
		status = MRP_LOCALE_DropDownRP2;
	elseif (status == "RP3") then
		status = MRP_LOCALE_DropDownRP3;
	elseif (status == "RP4") then
		status = MRP_LOCALE_DropDownRP4;
	elseif (status == "RP5") then
		status = MRP_LOCALE_DropDownRP5; -- 'Mature' roleplayer
										 -- EM: As per Blizzard's request, we will never _send_ this.
										 -- As per Alsarna's request, we will display it simply as roleplayer.
	end

	return status;
end

function mrpRelativeLevelCheck(level)
	if ((level) == -1) then
		return (MRP_LOCALE_mrpRelative10h);
	elseif ((level) <= (UnitLevel("player") - 7)) then
		return(MRP_LOCALE_mrpRelative7l);
	elseif (((level) >= (UnitLevel("player")) - 6) and ((level) <= (UnitLevel("player") - 5  ))) then
		return (MRP_LOCALE_mrpRelative5to6l);
	elseif (((level) >= (UnitLevel("player")) - 4) and ((level) <= (UnitLevel("player") - 2  ))) then
		return (MRP_LOCALE_mrpRelative2to4l);
	elseif (((level) >= (UnitLevel("player")) - 1) and ((level) <= (UnitLevel("player") + 2  ))) then
		return (MRP_LOCALE_mrpRelative1to1h);
	elseif (((level) >= (UnitLevel("player")) + 2) and ((level) <= (UnitLevel("player") + 3  ))) then
		return (MRP_LOCALE_mrpRelative2to3h);
	elseif (((level) >= (UnitLevel("player")) + 4) and ((level) <= (UnitLevel("player") + 6  ))) then
		return (MRP_LOCALE_mrpRelative4to6h);
	elseif (((level) >= (UnitLevel("player")) + 7) and ((level) <= (UnitLevel("player") + 9  ))) then
		return (MRP_LOCALE_mrpRelative7to9h);
	else
		return (MRP_LOCALE_mrpRelative10h);
	end

end

function mrpSetTargetFactionRank(fromWhere)
	if (UnitPlayerControlled("mouseover") or UnitPlayerControlled("player")) then
		if (fromWhere == "MOUSEOVER" or fromWhere == "CHATMESSAGE") then
			mrpTarget.Identification.FactionRank = UnitPVPName("mouseover")
		elseif (fromWhere == "PLAYER") then
			mrpTarget.Identification.FactionRank = UnitPVPName("target")
		end
	end
end

--------------------------------------------------------------------------------------------------------

function mrpEnterInformationDialog(location, field, text, numLetters)
	mrpEnterInformationLocation = location;
	mrpEnterInformationField = field;
	mrpEnterInformationText:SetText(text);
	mrpEnterInformationEditBox:SetMaxLetters(numLetters);

	mrpEnterInformationEditBox:SetText(mrpGetInfo(location, field, mrpGetCurProfile()));

	mrpEnterInformation:Show();
end

function mrpEditTextPopup(location, field, whatToDoMessage, numLetters)
	StaticPopupDialogs["MRP_EDITDIALOG"] = {
	text = "%s",
	hasEditBox = 1,
	maxLetters = numLetters,
	button1 = "OK",
	button2 = MRP_LOCALE_CANCEL,
	OnAccept = function()
		local text = _G[this:GetParent():GetName().."EditBox"]:GetText();
		RenamePetition(text);
		if (location ~= "CurProfile" and location ~= "makeNewProfile") then
			mrpSaveVariable(location, field, text);
		elseif (location == "CurProfile") then
			mrpSaveProfile(text);
		elseif (location == "makeNewProfile") then
			mrpCreateNewProfile(text);
		end
	end,
	EditBoxOnEnterPressed = function()
		local text = _G[this:GetParent():GetName().."EditBox"]:GetText();
		RenamePetition(text);
		if (location ~= "CurProfile" and location ~= "makeNewProfile") then
			mrpSaveVariable(location, field, text);
		elseif (location == "CurProfile") then
			mrpSaveProfile(text);
		elseif (location == "makeNewProfile") then
			mrpCreateNewProfile(text);
		end
		StaticPopup_Hide("MRP_EDITDIALOG");
	end,
	OnShow = function()
		_G[this:GetName().."EditBox"]:SetFocus();
		if (location ~= "CurProfile" and location ~= "makeNewProfile") then
			_G[this:GetName().."EditBox"]:SetText(mrpGetInfo(location, field, mrpGetCurProfile()));
		elseif (location == "CurProfile") then
			_G[this:GetName().."EditBox"]:SetText(mrpGetCurProfile());
		end
	end,
	OnHide = function()
		if (ChatFrameEditBox:IsVisible()) then
			ChatFrameEditBox:SetFocus();
		end
		_G[this:GetName().."EditBox"]:SetText(MRP_EMPTY_STRING);
	end,
	timeout = 0,
	exclusive = 0,
	hideOnEscape = 1,
	whileDead = 1
	};

	StaticPopup_Show("MRP_EDITDIALOG", whatToDoMessage);
end

function mrpErrorMessageBox(msg)

	StaticPopupDialogs["MRP_ERRORMESSAGEBOX"] = {
	text = "%s",
	button1 = "OK",
	timeout = 0,
	exclusive = 0,
	hideOnEscape = 0,
	whileDead = 1
	};

	StaticPopup_Show("MRP_ERRORMESSAGEBOX", msg);
end

function mrpUpdateEditBoxScroller(editBox)
	local scrollbar = _G[editBox:GetParent():GetParent():GetName() .. "ScrollBar"];

	editBox:GetParent():GetParent():UpdateScrollChildRect();

	local min, max = scrollbar:GetMinMaxValues();

	if max > 0 and editBox.max ~= max then
		editBox.max = max;
		scrollbar:SetValue(max);
	end
end

function mrpCharacterFrameNextPageOnClick()
	if (mrpCharacterFrameIdentityFrame:IsShown()) then
		mrpCharacterFrameIdentityFrame:Hide();
		mrpCharacterFrameAppearanceFrame:Hide();
		mrpCharacterFrameLoreFrame:Show();
	end
end

function mrpCharacterFramePrevPageOnClick()
	if (mrpCharacterFrameLoreFrame:IsShown()) then
		mrpCharacterFrameLoreFrame:Hide();
		mrpCharacterFrameIdentityFrame:Show();
		mrpCharacterFrameAppearanceFrame:Show();
	end
end

mrpRPFirstRun = 1;

function mrpRPDropDownHandler()
	UIDropDownMenu_Initialize(mrpRPDropDown, mrpRPDropDownInitialize);
	if (mrpRPFirstRun == 1) then
		if (mrpGetInfo("Status", "roleplay", mrpGetCurProfile()) ~= "") then
			UIDropDownMenu_SetSelectedValue(mrpRPDropDown, mrpDecodeStatus(mrpGetInfo("Status", "roleplay", mrpGetCurProfile())));
		else
			UIDropDownMenu_SetSelectedValue(mrpRPDropDown, MRP_LOCALE_DropDownRP0);
		end
		mrpRPFirstRun = 0;
	end
	UIDropDownMenu_SetWidth(mrpRPDropDown, 200); -- EM: changed to frame,width,padding in 3.0
end

function mrpRPDropDownInitialize()
	local tempInfo = {};

	tempInfo.text = MRP_LOCALE_DropDownRP0;
	tempInfo.func = mrpRPDropDownOnClick;
	tempInfo.tooltipTitle = MRP_LOCALE_DropDownRP0;
	tempInfo.tooltipText = MRP_LOCALE_DropDownRP0Expl;
	tempInfo.checked = nil;

	UIDropDownMenu_AddButton(tempInfo);

	tempInfo.text = MRP_LOCALE_DropDownRP1;
	tempInfo.func = mrpRPDropDownOnClick;
	tempInfo.tooltipTitle = MRP_LOCALE_DropDownRP1;
	tempInfo.tooltipText = MRP_LOCALE_DropDownRP1Expl;
	tempInfo.checked = nil;

	UIDropDownMenu_AddButton(tempInfo);

	tempInfo.text = MRP_LOCALE_DropDownRP2;
	tempInfo.func = mrpRPDropDownOnClick;
	tempInfo.tooltipTitle = MRP_LOCALE_DropDownRP2;
	tempInfo.tooltipText = MRP_LOCALE_DropDownRP2Expl;
	tempInfo.checked = nil;

	UIDropDownMenu_AddButton(tempInfo);

	tempInfo.text = MRP_LOCALE_DropDownRP3;
	tempInfo.func = mrpRPDropDownOnClick;
	tempInfo.tooltipTitle = MRP_LOCALE_DropDownRP3;
	tempInfo.tooltipText = MRP_LOCALE_DropDownRP3Expl;
	tempInfo.checked = nil;

	UIDropDownMenu_AddButton(tempInfo);

	tempInfo.text = MRP_LOCALE_DropDownRP4;
	tempInfo.func = mrpRPDropDownOnClick;
	tempInfo.tooltipTitle = MRP_LOCALE_DropDownRP4;
	tempInfo.tooltipText = MRP_LOCALE_DropDownRP4Expl;
	tempInfo.checked = nil;

	UIDropDownMenu_AddButton(tempInfo);
end

function mrpRPDropDownOnClick()
	UIDropDownMenu_SetSelectedValue(mrpRPDropDown, this.value);
	mrpSaveVariable("Status", "roleplay", mrpEncodeStatus(UIDropDownMenu_GetSelectedValue(mrpRPDropDown)));
end

mrpCSFirstRun = 1;

function mrpCSDropDownHandler()
	UIDropDownMenu_Initialize(mrpCSDropDown, mrpCSDropDownInitialize);
	if (mrpCSFirstRun == 1) then
		if (mrpGetInfo("Status", "character", mrpGetCurProfile()) ~= "") then
			UIDropDownMenu_SetSelectedValue(mrpCSDropDown, mrpDecodeStatus(mrpGetInfo("Status", "character", mrpGetCurProfile())));
		else
			UIDropDownMenu_SetSelectedValue(mrpCSDropDown, MRP_LOCALE_DropDownCSNone);
		end
		mrpCSFirstRun = 0;
	end
	UIDropDownMenu_SetWidth(mrpCSDropDown, 200); -- EM: changed to frame,width,padding in 3.0
end

function mrpCSDropDownInitialize()
	local tempInfo = {};

	tempInfo.text = MRP_LOCALE_DropDownCSNone;
	tempInfo.func = mrpCSDropDownOnClick;
	tempInfo.tooltipTitle = MRP_LOCALE_DropDownCSNone;
	tempInfo.tooltipText = MRP_LOCALE_DropDownCSNoneExpl;
	tempInfo.checked = nil;

	UIDropDownMenu_AddButton(tempInfo);

	tempInfo.text = MRP_LOCALE_DropDownCSOOC;
	tempInfo.func = mrpCSDropDownOnClick;
	tempInfo.tooltipTitle = MRP_LOCALE_DropDownCSOOC;
	tempInfo.tooltipText = MRP_LOCALE_DropDownCSOOCExpl;
	tempInfo.checked = nil;

	UIDropDownMenu_AddButton(tempInfo);

	tempInfo.text = MRP_LOCALE_DropDownCSIC;
	tempInfo.func = mrpCSDropDownOnClick;
	tempInfo.tooltipTitle = MRP_LOCALE_DropDownCSIC;
	tempInfo.tooltipText = MRP_LOCALE_DropDownCSICExpl;
	tempInfo.checked = nil;

	UIDropDownMenu_AddButton(tempInfo);

	tempInfo.text = MRP_LOCALE_DropDownCSFFAIC;
	tempInfo.func = mrpCSDropDownOnClick;
	tempInfo.tooltipTitle = MRP_LOCALE_DropDownCSFFAIC;
	tempInfo.tooltipText = MRP_LOCALE_DropDownCSFFAICExpl;
	tempInfo.checked = nil;

	UIDropDownMenu_AddButton(tempInfo);

	tempInfo.text = MRP_LOCALE_DropDownCSST;
	tempInfo.func = mrpCSDropDownOnClick;
	tempInfo.tooltipTitle = MRP_LOCALE_DropDownCSST;
	tempInfo.tooltipText = MRP_LOCALE_DropDownCSSTExpl;
	tempInfo.checked = nil;

	UIDropDownMenu_AddButton(tempInfo);
end

function mrpCSDropDownOnClick()
	UIDropDownMenu_SetSelectedValue(mrpCSDropDown, this.value);
	mrpSaveVariable("Status", "character", mrpEncodeStatus(UIDropDownMenu_GetSelectedValue(mrpCSDropDown)));
end


function mrpProfileDropDownHandler()
	--UIDropDownMenu_ClearAll(mrpProfileDropDown);
	UIDropDownMenu_Initialize(mrpProfileDropDown, mrpProfileDropDownInitialize);
	UIDropDownMenu_Refresh(mrpProfileDropDown);

	UIDropDownMenu_SetSelectedValue(mrpProfileDropDown, mrpGetCurProfile());

	UIDropDownMenu_SetWidth(mrpProfileDropDown, 140); -- EM: changed to frame,width,padding in 3.0
end

function mrpProfileDropDownInitialize()
	local tempInfo = {};

	local temp = mdbHardSearchData("MyRolePlayCharacter", mdbCreateTablePacket(nil, "Identification"), mdbCreateColumnPacket("profile"));

	for i = 1, table.maxn(temp) do
		tempInfo.text = temp[i][1];
		tempInfo.func = mrpProfileDropDownOnClick;
		tempInfo.checked = nil;

		UIDropDownMenu_AddButton(tempInfo);
	end
end

function mrpProfileDropDownOnClick()
	UIDropDownMenu_SetSelectedValue(mrpProfileDropDown, this.value);
	mrpChangeProfile(UIDropDownMenu_GetSelectedValue(mrpProfileDropDown));
end

-----------------------------------------------------------------------------------------------

function mrpDeleteProfile()
	if (mrpGetNumProfiles() <= 1) then
		mrpErrorMessageBox(MRP_LOCALE_One_Profile);
	else
		local curProfile = mrpGetCurProfile();
		local search = mdbCreateSearchPacket("profile", "=", curProfile);

		mdbDeleteData("MyRolePlayCharacter", "Identification", search);
		mdbDeleteData("MyRolePlayCharacter", "Appearance", search);
		mdbDeleteData("MyRolePlayCharacter", "Lore", search);
		mdbDeleteData("MyRolePlayCharacter", "Status", search);
		mdbDeleteData("MyRolePlayCharacter", "Character", search);
		mdbDeleteData("MyRolePlayCharacter", "GuildInfo", search);
		mdbDeleteData("MyRolePlayCharacter", "Achievements", search);
		mdbDeleteData("MyRolePlayCharacter", "PetInfo", search);
		mdbDeleteData("MyRolePlayCharacter", "OocInfo", search);

		mrpChangeProfile(mdbGetData("MyRolePlayCharacter", "Identification", "profile", 1));
	end
end

function mrpChangeProfile(profileName)
	mdbHardEditData("MyRolePlayCharacter", "CurProfile", "name", profileName);
	mrpProfileDropDownHandler();
	mrpUpdateText();
	mrpSendMessage(MRP_RESPOND);
end

function mrpSaveProfile(profileName)
	if (mrpProfileExists(profileName) == false) then
		local curProfile = mrpGetCurProfile();
		local search = mdbCreateSearchPacket("profile", "=", curProfile);

		local identification = mdbSearchData("MyRolePlayCharacter", mdbCreateTablePacket(nil, "Identification"), mdbCreateColumnPacket("prefix", "firstname", "middlename", "surname", "title", "nickname", "housename", "FamilyName", "Professions", "dateOfBirth", "deity"), search);
		local appearance = mdbSearchData("MyRolePlayCharacter", mdbCreateTablePacket(nil, "Appearance"), mdbCreateColumnPacket("eyeColour", "height", "weight", "currentEmotion", "description", "apparentAge"), search);
		local lore = mdbSearchData("MyRolePlayCharacter", mdbCreateTablePacket(nil, "Lore"), mdbCreateColumnPacket("curHome", "birthPlace", "motto", "history"), search);
		local status = mdbSearchData("MyRolePlayCharacter", mdbCreateTablePacket(nil, "Status"), mdbCreateColumnPacket("roleplay", "character"), search);
		local character = mdbSearchData("MyRolePlayCharacter", mdbCreateTablePacket(nil, "Character"), mdbCreateColumnPacket("Race"), search);
		local oocinfo = mdbSearchData("MyRolePlayCharacter", mdbCreateTablePacket(nil, "OocInfo"), mdbCreateColumnPacket("info"), search);

		local prefixtext, firstnametext, middlenametext, surnametext, titletext, nicknametext, housetext, familynametext, professionstext, dobtext, dietytext = unpack(identification[1]);
		local eyecolourtext, heighttext, weighttext, emotiontext, desctext, apparentagetext = unpack(appearance[1]);
		local homecitytext, birthcitytext, mottotext, historytext = unpack(lore[1]);
		local rpstattext, charstattext = unpack(status[1]);
		local racetext = unpack(character[1]);
		local oocinfoInfo = unpack(oocinfo[1]);


		mdbInsertData("MyRolePlayCharacter", "Identification", profileName, prefixtext, firstnametext, middlenametext, surnametext, familynametext, titletext, nicknametext, housetext, professionstext, dobtext, dietytext);
		mdbInsertData("MyRolePlayCharacter", "Appearance", profileName, eyecolourtext, heighttext, weighttext, apparentagetext, emotiontext, desctext);
		mdbInsertData("MyRolePlayCharacter", "Lore", profileName, homecitytext, birthcitytext, mottotext, historytext);
		mdbInsertData("MyRolePlayCharacter", "Status", profileName, rpstattext, charstattext);
		mdbInsertData("MyRolePlayCharacter", "Character", profileName, racetext);
		mdbInsertData("MyRolePlayCharacter", "PetInfo", profileName);
		mdbInsertData("MyRolePlayCharacter", "Achievements", profileName);
		mdbInsertData("MyRolePlayCharacter", "OocInfo", profileName, oocinfoInfo);
	end

	mrpChangeProfile(profileName);
end

function mrpCreateNewProfile(profileName)
	if (mrpProfileExists(profileName) == true) then
		mrpErrorMessageBox(MRP_LOCALE_Profile_Exists_1 .. profileName .. MRP_LOCALE_Profile_Exists_2);
		return;
	end

	mdbInsertData("MyRolePlayCharacter", "Identification", profileName, "", UnitName("player"), "", "", "", "", "", "" ,"" ,"" ,"");
	mdbInsertData("MyRolePlayCharacter", "Appearance", profileName, "", "", "", "", "", "");
	mdbInsertData("MyRolePlayCharacter", "Lore", profileName, "", "", "", "");
	mdbInsertData("MyRolePlayCharacter", "Status", profileName, "RP0", "CS0");
	mdbInsertData("MyRolePlayCharacter", "Character", profileName, "");
	mdbInsertData("MyRolePlayCharacter", "PetInfo", profileName);
	mdbInsertData("MyRolePlayCharacter", "Achievements", profileName);
	mdbInsertData("MyRolePlayCharacter", "OocInfo", profileName, "");

	mrpChangeProfile(profileName);
end

function mrpViewTargetCharacterSheet()
	if (mrpCharacterSheet1Main:IsShown()) then
		mrpCharacterSheet1Main:Hide();
	else
		if (not UnitExists("target")) then
			mrpDisplayMessage(MRP_LOCALE_CHARACTER_SHEET_NO_TARGET);
		elseif (not UnitIsPlayer("target")) then
			mrpDisplayMessage(MRP_LOCALE_CHARACTER_SHEET_NOT_VALID_TARGET);
		elseif (mrpIsPlayerInMRP(UnitName("target")) == true) then
			if MRP_DEBUG then
				mrpDisplayMessage(MRP_LOCALE_CHARACTER_SHEET_MRP_USER);
			end
			mrpCurCharacterSheetTarget = UnitName("target");
			mrpCharacterSheet1Main:Show();
		elseif (mrpIsPlayerInMRP(UnitName("target")) == false) then
			if MRP_DEBUG then
				mrpDisplayMessage(MRP_LOCALE_CHARACTER_SHEET_RSP_USER);
			end
			mrpCurCharacterSheetTarget = UnitName("target");
			mrpCharacterSheet1Main:Show();
		elseif (UnitName("target") == UnitName("player")) then
			mrpCurCharacterSheetTarget = UnitName("target");
			mrpCharacterSheet1Main:Show();
		else
			mrpDisplayMessage(MRP_LOCALE_CHARACTER_SHEET_NOT_VALID_TARGET);
		end
	end
end

function mrpButtonIconDraggingFrameOnUpdate(arg1)
	local xpos, ypos = GetCursorPosition();
	local xmin, ymin = Minimap:GetLeft(), Minimap:GetBottom();

	xpos = xmin - xpos / UIParent:GetScale() + 70;
	ypos = ypos / UIParent:GetScale() - ymin - 70;

	mrpIconPos = math.deg(math.atan2(ypos, xpos));
	mrpMoveIcon();
end
mrpLocked = 1
function mrpButtonIconFrameOnClick(arg1)
	if arg1 == "LeftButton" then
		mrpViewTargetCharacterSheet();
	elseif arg1 == "RightButton" then
		if (mrpLocked == 0) then
			mrpLocked = 1;
			mrpDisplayMessage("MRP Display Button now locked; right-click the button to unlock for moving.");
		else
			mrpLocked = 0;
			mrpDisplayMessage("MRP Display Button now movable; right-click the button to lock.");
		end
	end
end

-- Doesn't do anything normally (taken out for testing in 2.7, may be readded in 2.8).
-- However, this function contains the workaround for XPerl unitframes, reanchoring the button if TargetFrame has been nuked.
function mrpMoveIcon()
	if (XPerl_Target~=nil) then
		mrpButtonIconFrame:SetPoint("TOPLEFT","XPerl_Target","BOTTOMRIGHT",-8,0);
	end
end

--/script mrpDisplayMessage(tostring(mrpIsPlayerInList("Artemetria")));
function mrpIsPlayerInList(name)
	-- Checks to see if target is in the list
	if (mrpIsInitialized ~= true) then
		return nil;
	end

	local temp = mdbSearchData("MyRolePlayPlayerList", mdbCreateTablePacket(nil, "Misc"), mdbCreateColumnPacket("playerName"), mdbCreateSearchPacket("playerName", "=", name));

	if (temp[1] and temp[1][1] and temp[1][1] ~= nil and temp[1][1] ~= "") then
		return true;
	end

	return false;
end
--/script mrpDisplayMessage(mrpGetNumOfPlayersInList());

-- Checks to see if target has MyRolePlay
function mrpIsPlayerInMRP(name)
	if (mrpIsInitialized ~= true) then
		return nil;
	end

	local temp = mdbSearchData("MyRolePlayPlayerList", mdbCreateTablePacket(nil, "Misc"), mdbCreateColumnPacket("channel"), mdbCreateSearchPacket("playerName", "=", name));

	if (temp[1] and temp[1][1] and temp[1][1] ~= nil and temp[1][1] ~= "") then
		if (temp[1][1] == "MyWarcraftCo") then
			return true;
		elseif (temp[1][1] == "xtensionxtooltip2") then
			return false;
		end
	end

	return nil;
end

function mrpPlayerHasInfo(name)
	if (mrpIsInitialized ~= true) then
		return nil;
	end

	local temp = mdbSearchData("MyRolePlayPlayerList", mdbCreateTablePacket(nil, "Misc"), mdbCreateColumnPacket("hasInfo"), mdbCreateSearchPacket("playerName", "=", name));

	if (temp and temp ~= nil and temp[1] and temp[1] ~= nil and temp[1][1]) then
		return temp[1][1];
	end
end

function mrpGetNumOfPlayersInList()
	local temp = mdbHardSearchData("MyRolePlayPlayerList", mdbCreateTablePacket(nil, "Misc"), mdbCreateColumnPacket("playerName"));

	return table.maxn(temp);
end

-- Parse data for a given player to update their player list info
function mrpUpdatePlayerListInfoFor(playerName, data)
	mrpRemoveWaitingForInfo(playerName); -- EM: We now have their info, no longer waiting on it.

	local temp = string.match(data, MRP_INFO_INDEX_PREFIX .. "([^" .. string.char(5) .. "]*)" .. string.char(5));
	if (temp and temp ~= nil) then
		mrpEditPlayerListInfo(playerName, "Identification", "prefix", temp);
	end

	temp = string.match(data, MRP_INFO_INDEX_FIRSTNAME .. "([^" .. string.char(5) .. "]*)" .. string.char(5));
	if (temp and temp ~= nil) then
		mrpEditPlayerListInfo(playerName, "Identification", "firstname", temp);
	end

	temp = string.match(data, MRP_INFO_INDEX_MIDDLENAME .. "([^" .. string.char(5) .. "]*)" .. string.char(5));
	if (temp and temp ~= nil) then
		mrpEditPlayerListInfo(playerName, "Identification", "middlename", temp);
	end

	temp = string.match(data, MRP_INFO_INDEX_SURNAME .. "([^" .. string.char(5) .. "]*)" .. string.char(5));
	if (temp and temp ~= nil) then
		mrpEditPlayerListInfo(playerName, "Identification", "surname", temp);
	end

	temp = string.match(data, MRP_INFO_INDEX_TITLE .. "([^" .. string.char(5) .. "]*)" .. string.char(5));
	if (temp and temp ~= nil) then
		mrpEditPlayerListInfo(playerName, "Identification", "title", temp);
	end

	temp = string.match(data, MRP_INFO_INDEX_NICKNAME .. "([^" .. string.char(5) .. "]*)" .. string.char(5));
	if (temp and temp ~= nil) then
		mrpEditPlayerListInfo(playerName, "Identification", "nickname", temp);
	end

	temp = string.match(data, MRP_INFO_INDEX_HOUSENAME .. "([^" .. string.char(5) .. "]*)" .. string.char(5));
	if (temp and temp ~= nil) then
		mrpEditPlayerListInfo(playerName, "Identification", "housename", temp);
	end

	temp = string.match(data, MRP_INFO_INDEX_HEIGHT .. "([^" .. string.char(5) .. "]*)" .. string.char(5));
	if (temp and temp ~= nil) then
		mrpEditPlayerListInfo(playerName, "Appearance", "height", temp);
	end

	temp = string.match(data, MRP_INFO_INDEX_WEIGHT .. "([^" .. string.char(5) .. "]*)" .. string.char(5));
	if (temp and temp ~= nil) then
		mrpEditPlayerListInfo(playerName, "Appearance", "weight", temp);
	end

	temp = string.match(data, MRP_INFO_INDEX_EYECOLOUR .. "([^" .. string.char(5) .. "]*)" .. string.char(5));
	if (temp and temp ~= nil) then
		mrpEditPlayerListInfo(playerName, "Appearance", "eyeColour", temp);
	end

	temp = string.match(data, MRP_INFO_INDEX_APPARENTAGE .. "([^" .. string.char(5) .. "]*)" .. string.char(5));
	if (temp and temp ~= nil) then
		mrpEditPlayerListInfo(playerName, "Appearance", "apparentAge", temp);
	end

	temp = string.match(data, MRP_INFO_INDEX_CURRENTEMOTION .. "([^" .. string.char(5) .. "]*)" .. string.char(5));
	if (temp and temp ~= nil) then
		mrpEditPlayerListInfo(playerName, "Appearance", "currentEmotion", temp);
	end

	temp = string.match(data, MRP_INFO_INDEX_CURHOME .. "([^" .. string.char(5) .. "]*)" .. string.char(5));
	if (temp and temp ~= nil) then
		mrpEditPlayerListInfo(playerName, "Lore", "curHome", temp);
	end

	temp = string.match(data, MRP_INFO_INDEX_BIRTHPLACE .. "([^" .. string.char(5) .. "]*)" .. string.char(5));
	if (temp and temp ~= nil) then
		mrpEditPlayerListInfo(playerName, "Lore", "birthPlace", temp);
	end

	temp = string.match(data, MRP_INFO_INDEX_MOTTO .. "([^" .. string.char(5) .. "]*)" .. string.char(5));
	if (temp and temp ~= nil) then
		mrpEditPlayerListInfo(playerName, "Lore", "motto", temp);
	end

	temp = string.match(data, MRP_INFO_INDEX_ROLEPLAYSTATUS .. "([^" .. string.char(5) .. "]*)" .. string.char(5));
	if (temp and temp ~= nil) then
		mrpEditPlayerListInfo(playerName, "Status", "roleplay", temp);
	end

	temp = string.match(data, MRP_INFO_INDEX_CHARACTERSTATUS .. "([^" .. string.char(5) .. "]*)" .. string.char(5));
	if (temp and temp ~= nil) then
		mrpEditPlayerListInfo(playerName, "Status", "character", temp);
	end

	temp = string.match(data, MRP_INFO_INDEX_VERSION .. "([^" .. string.char(5) .. "]*)" .. string.char(5));
	if (temp and temp ~= nil) then
		mrpEditPlayerListInfo(playerName, "Misc", "version", temp);
	end

	temp = string.match(data, MRP_INFO_INDEX_SUPPORTS .. "([^" .. string.char(5) .. "]*)" .. string.char(5));
	if (temp and temp ~= nil) then
		mrpEditPlayerListInfo(playerName, "Misc", "supports", temp);
	end

	mrpEditPlayerListInfo(playerName, "Misc", "hasInfo", true);
end

-- Process completed fields and hand them to mrpUpdatePlayerListInfoFor() for parsing.
-- Warning: This function removes completed packets from mrpPacketHolder().
function mrpUpdatePlayerListInfo()
	for i, packet in ipairs(mrpPacketHolder) do
		if ((tonumber(packet.dataLength) == tonumber(string.len(packet.data)))) then
			mrpUpdatePlayerListInfoFor(packet.playerName, packet.data);
			table.remove(mrpPacketHolder, i);
		end
	end
end
