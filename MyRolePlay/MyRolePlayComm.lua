MRP_GET_INFO = 0;
MRP_RESPOND = 1;

MRP_GET_DESC = 2;
MRP_GET_HIST = 3;

MRP_RESPOND_DESC = 4;
MRP_RESPOND_HIST = 5;

MRP_INFO_INDEX_PREFIX = string.char(5) .. "000";
MRP_INFO_INDEX_FIRSTNAME = string.char(5) .. "001";
MRP_INFO_INDEX_MIDDLENAME = string.char(5) .. "002";
MRP_INFO_INDEX_SURNAME = string.char(5) .. "003";
MRP_INFO_INDEX_TITLE = string.char(5) .. "004";
MRP_INFO_INDEX_NICKNAME = string.char(5) .. "005";
MRP_INFO_INDEX_HOUSENAME = string.char(5) .. "006";
MRP_INFO_INDEX_EYECOLOUR = string.char(5) .. "007";
MRP_INFO_INDEX_APPARENTAGE = string.char(5) .. "008";
MRP_INFO_INDEX_CURRENTEMOTION = string.char(5) .. "009";
MRP_INFO_INDEX_WEIGHT = string.char(5) .. "010";
MRP_INFO_INDEX_HEIGHT = string.char(5) .. "011";
MRP_INFO_INDEX_CURHOME = string.char(5) .. "012";
MRP_INFO_INDEX_BIRTHPLACE = string.char(5) .. "013";
MRP_INFO_INDEX_ROLEPLAYSTATUS = string.char(5) .. "014";
MRP_INFO_INDEX_CHARACTERSTATUS = string.char(5) .. "015";
MRP_INFO_INDEX_MOTTO = string.char(5) .. "016";
MRP_INFO_INDEX_VERSION = string.char(5) .. "017";
MRP_INFO_INDEX_SUPPORTS = string.char(5) .. "018";

MRP_GET_FLAGRSP_DESC = "<DP>";

mrpRSPDescriptionVersion = 1;

mrpMTI = nil;
mrpRSPMTI = nil;

mrpPacketHolder = {};

--/script mrpSaveVariable("Appearance", "description", mrpLongText);
function mrpCreateRSPDescription()
	local description = mrpGetInfo("Appearance", "description", mrpGetCurProfile());
	description = string.gsub(string.gsub(string.gsub(description, "<", "\\%("), ">", "\\%)"), "\n", "\\l");
	local length = string.len(description);
	local finalDescription = mcoSafeSplit(240,description);
	finalDescription[table.getn(finalDescription)]=finalDescription[table.getn(finalDescription)].."\\eod";
	return finalDescription;
end

function mrpRSPBroadcastData()
	local curProfile = mrpGetCurProfile();
	mcoSendHardMessage("<V>" .. mrpVersion .. "<S>" .. mrpSupports .. "<" .. mrpGetInfo("Status", "roleplay", curProfile) .. ">" .. "<" .. mrpGetInfo("Status", "character", curProfile) .. ">" .. "<DV>" .. mrpRSPDescriptionVersion .. "<T>" .. mrpGetInfo("Identification", "title", curProfile), "xtensionxtooltip2", mrpRSPEncodeMessage);
	mcoSendHardMessage("<N>" .. mrpGetInfo("Identification", "surname", curProfile) .. "<AN1>" .. mrpGetInfo("Identification", "prefix", curProfile) .. "<AN2>" .. mrpGetInfo("Identification", "middlename", curProfile) .. "<AN3>" .. mrpGetInfo("Identification", "surname", curProfile), "xtensionxtooltip2", mrpRSPEncodeMessage);

	mtiResetTimer(mrpRSPBroadcastTimer);
	mtiStartTimer(mrpRSPBroadcastTimer);
end

function mrpRSPEncodeMessage(data)
	return string.gsub(string.gsub(data, "|", ""), "\n", "\\l");
end

function mrpRSPEncodePayload(data)
	return string.gsub(string.gsub(data, "<", "\\%("), ">", "\\%)");
end

function mrpRSPDecodeMessage(data)
	return string.gsub(data, "\\l", "\n");
end

function mrpRSPDecodePayload(data)
	return string.gsub(string.gsub(data, "\\%(", ">"), "\\%)", ">");
end

function mrpOnCommEvent(event)
	if (event == "CHAT_MSG_CHANNEL") then
		local mrpIndexOfFlagRSPChannelExists = nil;
		local mrpIndexOfFlagRSPChannel = GetChannelName("xtensionxtooltip2");

		if (mrpIndexOfFlagRSPChannel ~= nil and arg8 == mrpIndexOfFlagRSPChannel and mrpIsRSPInitialized == true) then
			--local playerType = mrpIsPlayerInMRP(name);

			if (string.find(arg1, "<DP>" .. UnitName("player"))) then
				if (mtiGetTimerState(mrpRSPDescriptionTimer) == MTI_TIMER_STATE_PENDING or mtiGetTimerTime(mrpRSPDescriptionTimer) >= 10) then
					local descriptionChunks = mrpCreateRSPDescription();
					for chunkIndex,chunkData in ipairs(descriptionChunks) do
						mcoSendHardMessage("<D" .. string.format('%02d', chunkIndex) .. ">" .. chunkData, "xtensionxtooltip2", 0);
					end

					mtiResetTimer(mrpRSPDescriptionTimer);
					mtiStartTimer(mrpRSPDescriptionTimer);
				end
			end

			if (mrpIsPlayerInMRP(arg2) == false) then
				local temp = string.match(arg1, "<T>([^<.]*)");

				if (temp and temp ~= nil and temp ~= "") then
					mrpEditPlayerListInfo(arg2, "Identification", "title", temp);
					--if (playerType == false) then
						mrpEditPlayerListInfo(arg2, "Misc", "hasInfo", true);
					--end
				end


				temp = nil;
				temp = string.match(arg1, "<S>([^<.]*)");

				if (temp and temp ~= nil and temp ~= "") then
				  temp = mrpRSPDecodePayload(temp);
					mrpEditPlayerListInfo(arg2, "Misc", "supports", temp);
					--if (playerType == false) then
						mrpEditPlayerListInfo(arg2, "Misc", "hasInfo", true);
					--end
				end


				temp = nil;
				temp = string.match(arg1, "<V>([^<.]*)");

				if (temp and temp ~= nil and temp ~= "") then
				  temp = mrpRSPDecodePayload(temp);
					mrpEditPlayerListInfo(arg2, "Misc", "version", temp);
					--if (playerType == false) then
						mrpEditPlayerListInfo(arg2, "Misc", "hasInfo", true);
					--end
				end


				temp = nil;
				temp = string.match(arg1, "<N>([^<.]*)");

				if (temp and temp ~= nil and temp ~= "") then
				  temp = mrpRSPDecodePayload(temp);
					mrpEditPlayerListInfo(arg2, "Identification", "surname", temp);
					--if (playerType == false) then
						mrpEditPlayerListInfo(arg2, "Misc", "hasInfo", true);
					--end
				end


				temp = nil;
				temp = string.match(arg1, "<(CS%d*)>");

				if (temp and temp ~= nil and temp ~= "") then
					mrpEditPlayerListInfo(arg2, "Status", "character", temp);
					--if (playerType == false) then
						mrpEditPlayerListInfo(arg2, "Misc", "hasInfo", true);
					--end
				end


				temp = nil;
				temp = string.match(arg1, "<(RP%d*)>");

				if (temp and temp ~= nil and temp ~= "") then
					mrpEditPlayerListInfo(arg2, "Status", "roleplay", temp);
					--if (playerType == false) then
						mrpEditPlayerListInfo(arg2, "Misc", "hasInfo", true);
					--end
				end


				temp = nil;
				temp = string.match(arg1, "<AN1>([^<.]*)");

				if (temp and temp ~= nil and temp ~= "") then
					temp = mrpRSPDecodePayload(temp);
					-- It's not really a first name, it's used as a prefix. The documentation lies!
					-- But early versions sent it as a firstname. Let's check, because it can never differ...
					if ( temp ~= arg2 ) then
						mrpEditPlayerListInfo(arg2, "Identification", "prefix", temp);
					end
					--if (playerType == false) then
						mrpEditPlayerListInfo(arg2, "Misc", "hasInfo", true);
					--end
					tempver = nil;
				end


				temp = nil;
				temp = string.match(arg1, "<AN2>([^<.]*)");

				if (temp and temp ~= nil and temp ~= "") then
				  temp = mrpRSPDecodePayload(temp);
					mrpEditPlayerListInfo(arg2, "Identification", "middlename", temp);
					--if (playerType == false) then
						mrpEditPlayerListInfo(arg2, "Misc", "hasInfo", true);
					--end
				end


				temp = nil;
				temp = string.match(arg1, "<AN3>([^<.]*)");

				if (temp and temp ~= nil and temp ~= "") then
				  temp = mrpRSPDecodePayload(temp);
					mrpEditPlayerListInfo(arg2, "Identification", "surname", temp);
					--if (playerType == false) then
						mrpEditPlayerListInfo(arg2, "Misc", "hasInfo", true);
					--end
				end

				local descriptionVersionOne, descriptionVersionTwo, descriptionPiece = string.match(arg1, "<D(%d)(%d)>(.*)");

				if (descriptionVersionTwo and descriptionVersionTwo ~= nil and descriptionVersionTwo ~= "") then
					if (not descriptionPiece or descriptionPiece == nil) then
						descriptionPiece = "";
					end

					local descriptionVersion = (descriptionVersionOne * 10) + descriptionVersionTwo;

          descriptionPiece = mrpRSPDecodeMessage(descriptionPiece)
          descriptionPiece = string.gsub(descriptionPiece, "\\eod", "");

					mrpUpdatePlayerListDescription(arg2, descriptionPiece, tonumber(descriptionVersion));
					--if (playerType == false) then
						mrpEditPlayerListInfo(arg2, "Misc", "hasInfo", true);
					--end
				end
			end
		end
	end

	if (event == "CHAT_MSG_CHANNEL_JOIN") then
		if (arg9 == "MyWarcraftCo" and mrpIsInitialized == true) then
			if (arg2 ~= UnitName("player") and mrpIsPlayerInList(arg2) == false) then
				mdbInsertData("MyRolePlayPlayerList", "Identification", arg2, "", arg2, "", "", "", "", "" ,"" ,"" ,"");
				mdbInsertData("MyRolePlayPlayerList", "Appearance", arg2, "", "", "", "", "", "");
				mdbInsertData("MyRolePlayPlayerList", "Lore", arg2, "", "", "", "");
				mdbInsertData("MyRolePlayPlayerList", "Status", arg2, "", "");
				mdbInsertData("MyRolePlayPlayerList", "Character", arg2, "");
				mdbInsertData("MyRolePlayPlayerList", "PetInfo", arg2);
				mdbInsertData("MyRolePlayPlayerList", "OocInfo", arg2, "");
				mdbInsertData("MyRolePlayPlayerList", "Misc", arg2, false, "MyWarcraftCo");
				mrpEditPlayerListInfo(arg2, "Misc", "supports", "mrp");
				
			elseif (arg2 ~= UnitName("player") and mrpIsPlayerInMRP(arg2) == false) then
				mdbEditData("MyRolePlayPlayerList", "Misc", "channel", "MyWarcraftCo", mdbCreateSearchPacket("playerName", "=", arg2));
			end
		elseif (arg9 == "xtensionxtooltip2" and mrpIsRSPInitialized == true) then
			if (arg2 ~= UnitName("player") and mrpIsPlayerInList(arg2) == false) then
				mdbInsertData("MyRolePlayPlayerList", "Identification", arg2, "", arg2, "", "", "", "", "" ,"" ,"" ,"");
				mdbInsertData("MyRolePlayPlayerList", "Appearance", arg2, "", "", "", "", "", "");
				mdbInsertData("MyRolePlayPlayerList", "Lore", arg2, "", "", "", "");
				mdbInsertData("MyRolePlayPlayerList", "Status", arg2, "", "");
				mdbInsertData("MyRolePlayPlayerList", "Character", arg2, "");
				mdbInsertData("MyRolePlayPlayerList", "PetInfo", arg2);
				mdbInsertData("MyRolePlayPlayerList", "OocInfo", arg2, "");
				mdbInsertData("MyRolePlayPlayerList", "Misc", arg2, false, "xtensionxtooltip2");
				mrpEditPlayerListInfo(arg2, "Misc", "supports", "rsp");
			end
		end
	end

	if (event == "CHAT_MSG_CHANNEL_LEAVE") then
		-- EM: Make sure we don't remember waiting for them if they D/C, otherwise we'll be waiting forever.
		if (arg2 ~= nil) then
			mrpRemoveWaitingForInfo(arg2);
			mrpRemoveWaitingForDescription(arg2);
			mrpRemoveWaitingForHistory(arg2);
		end
		if (arg9 == "MyWarcraftCo") then
			if (mrpIsPlayerInMRP(arg2) == true) then
				local search = mdbCreateSearchPacket("playerName", "=", arg2);
				mdbDeleteData("MyRolePlayPlayerList", "Identification", search);
				mdbDeleteData("MyRolePlayPlayerList", "Appearance", search);
				mdbDeleteData("MyRolePlayPlayerList", "Lore", search);
				mdbDeleteData("MyRolePlayPlayerList", "Status", search);
				mdbDeleteData("MyRolePlayPlayerList", "Character", search);
				mdbDeleteData("MyRolePlayPlayerList", "PetInfo", search);
				mdbDeleteData("MyRolePlayPlayerList", "OocInfo", search);
				mdbDeleteData("MyRolePlayPlayerList", "Misc", search);
			end

		elseif (arg9 == "xtensionxtooltip2") then
			if (mrpIsPlayerInMRP(arg2) == false) then
				local search = mdbCreateSearchPacket("playerName", "=", arg2);
				mdbDeleteData("MyRolePlayPlayerList", "Identification", search);
				mdbDeleteData("MyRolePlayPlayerList", "Appearance", search);
				mdbDeleteData("MyRolePlayPlayerList", "Lore", search);
				mdbDeleteData("MyRolePlayPlayerList", "Status", search);
				mdbDeleteData("MyRolePlayPlayerList", "Character", search);
				mdbDeleteData("MyRolePlayPlayerList", "PetInfo", search);
				mdbDeleteData("MyRolePlayPlayerList", "OocInfo", search);
				mdbDeleteData("MyRolePlayPlayerList", "Misc", search);
			end
		end
	end

	if (event == "CHAT_MSG_CHANNEL_LIST") then
		local mrpIndexOfFlagRSPChannel = GetChannelName("xtensionxtooltip2");

		if (mrpIndexOfFlagRSPChannel ~= 0 and mrpIndexOfFlagRSPChannel ~= nil) then
			if (arg4 == mrpIndexOfFlagRSPChannel .. ". xtensionxtooltip2") then
				local mrpTempPlayerList = mduStringSplit(", ", arg1);
				local mrpNumInTable = table.maxn(mrpTempPlayerList);

				for i = 1, mrpNumInTable do
					mrpTempPlayerList[i] = { characterName = string.gsub(mrpTempPlayerList[i], "[%*]", MRP_EMPTY_STRING) };
					mrpTempPlayerList[i].characterName = string.gsub(mrpTempPlayerList[i].characterName, "[@]", MRP_EMPTY_STRING);

					if (mrpTempPlayerList[i].characterName ~= UnitName("player") and mrpIsPlayerInList(mrpTempPlayerList[i].characterName) == false and mrpIsPlayerInMRP(mrpTempPlayerList[i].characterName) ~= true) then
						mdbInsertData("MyRolePlayPlayerList", "Identification", mrpTempPlayerList[i].characterName, "", mrpTempPlayerList[i].characterName, "", "", "", "", "" ,"" ,"" ,"");
						mdbInsertData("MyRolePlayPlayerList", "Appearance", mrpTempPlayerList[i].characterName, "", "", "", "", "", "");
						mdbInsertData("MyRolePlayPlayerList", "Lore", mrpTempPlayerList[i].characterName, "", "", "", "");
						mdbInsertData("MyRolePlayPlayerList", "Status", mrpTempPlayerList[i].characterName, "", "");
						mdbInsertData("MyRolePlayPlayerList", "Character", mrpTempPlayerList[i].characterName, "");
						mdbInsertData("MyRolePlayPlayerList", "PetInfo", mrpTempPlayerList[i].characterName);
						mdbInsertData("MyRolePlayPlayerList", "OocInfo", mrpTempPlayerList[i].characterName, "");
						mdbInsertData("MyRolePlayPlayerList", "Misc", mrpTempPlayerList[i].characterName, false, "xtensionxtooltip2");
						mrpEditPlayerListInfo(mrpTempPlayerList[i].characterName, "Misc", "supports", "rsp");
					end
				end
				if (mrpRSPMTI == nil) then
					mrpRSPMTI = mtiRegisterEvent(6, mrpRSPSetupBroadcast);
				end

			end
		end

		local mrpIndexOfChannel = GetChannelName("MyWarcraftCo");

		if (mrpIndexOfChannel ~= 0 and mrpIndexOfChannel ~= nil) then
			if (arg4 == mrpIndexOfChannel .. ". MyWarcraftCo") then
				local mrpTempPlayerList = mduStringSplit(", ", arg1);
				local mrpNumInTable = table.maxn(mrpTempPlayerList);

				for i = 1, mrpNumInTable do
					mrpTempPlayerList[i] = { characterName = string.gsub(mrpTempPlayerList[i], "[%*]", MRP_EMPTY_STRING) };
					mrpTempPlayerList[i].characterName = string.gsub(mrpTempPlayerList[i].characterName, "[@]", MRP_EMPTY_STRING);

					if (mrpTempPlayerList[i].characterName ~= UnitName("player") and (mrpIsPlayerInList(mrpTempPlayerList[i].characterName) == false or mrpIsPlayerInList(mrpTempPlayerList[i].characterName) == nil)) then
						mdbInsertData("MyRolePlayPlayerList", "Identification", mrpTempPlayerList[i].characterName, "", mrpTempPlayerList[i].characterName, "", "", "", "", "" ,"" ,"" ,"");
						mdbInsertData("MyRolePlayPlayerList", "Appearance", mrpTempPlayerList[i].characterName, "", "", "", "", "", "");
						mdbInsertData("MyRolePlayPlayerList", "Lore", mrpTempPlayerList[i].characterName, "", "", "", "");
						mdbInsertData("MyRolePlayPlayerList", "Status", mrpTempPlayerList[i].characterName, "", "");
						mdbInsertData("MyRolePlayPlayerList", "Character", mrpTempPlayerList[i].characterName, "");
						mdbInsertData("MyRolePlayPlayerList", "PetInfo", mrpTempPlayerList[i].characterName);
						mdbInsertData("MyRolePlayPlayerList", "OocInfo", mrpTempPlayerList[i].characterName, "");
						mdbInsertData("MyRolePlayPlayerList", "Misc", mrpTempPlayerList[i].characterName, false, "MyWarcraftCo");
						mrpEditPlayerListInfo(mrpTempPlayerList[i].characterName, "Misc", "supports", "mrp");
					end
				end
				if (mrpMTI == nil) then
					mrpMTI = mtiRegisterEvent(6, mrpFinalizeInit);
				end
			end
		end
	end
end

function mrpRSPSetupBroadcast()
	mtiUnregisterEvent(mtiGetCurEventId());
	mrpIsRSPInitialized = true;
	mrpRSPDescriptionTimer = mtiCreateNewTimer(1);
	mrpRSPBroadcastTimer = mtiCreateNewTimer(1, 300, mrpRSPBroadcastData);
	mrpRSPBroadcastData();
end

--/script mrpSendMessage(MRP_GET_FLAGRSP_DESC, "Alontra")
function mrpSendMessage(msg, target)
	if (mrpToWho == nil) then
		mrpToWho = MRP_EMPTY_STRING;
	end

	if (msg == MRP_GET_INFO) then
		if (mrpIsWaitingForInfo(target) == false) then
			mrpAddWaitingForInfo(target);
		end
		mcoSendMessage("", "MyWarcraftCo", "MyRolePlay", nil, nil, MRP_GET_INFO, target);
	elseif (msg == MRP_RESPOND) then
		if (mtiGetTimerState(mrpRespondTimer) == MTI_TIMER_STATE_PENDING or mtiGetTimerTime(mrpRespondTimer) >= 5) then
			local finalMsg = mrpCreateRespondMessage();

			mcoSendMessage(finalMsg, "MyWarcraftCo", "MyRolePlay", nil, nil, MRP_RESPOND);
		end
		mtiResetTimer(mrpRespondTimer);
		mtiStartTimer(mrpRespondTimer);
	elseif (msg == MRP_GET_DESC) then
		if (mrpIsWaitingForDescription(target) == false) then
			mrpAddWaitingForDescription(target);
		end

		mcoSendMessage("", "MyWarcraftCo", "MyRolePlay", nil, nil, MRP_GET_DESC, target);
	elseif (msg == MRP_GET_HIST) then
		if (mrpIsWaitingForHistory(target) == false) then
			mrpAddWaitingForHistory(target);
		end

		mcoSendMessage("", "MyWarcraftCo", "MyRolePlay", nil, nil, MRP_GET_HIST, target);
	elseif (msg == MRP_RESPOND_DESC) then
		if (mtiGetTimerState(mrpDescTimer) == MTI_TIMER_STATE_PENDING or mtiGetTimerTime(mrpDescTimer) >= 5) then
			mcoSendMessage(mrpGetInfo("Appearance", "description", mrpGetCurProfile()), "MyWarcraftCo", "MyRolePlay", nil, nil, MRP_RESPOND_DESC);
		end
		mtiResetTimer(mrpDescTimer);
		mtiStartTimer(mrpDescTimer);

	elseif (msg == MRP_RESPOND_HIST) then
		if (mtiGetTimerState(mrpHistTimer) == MTI_TIMER_STATE_PENDING or mtiGetTimerTime(mrpHistTimer) >= 5) then
			mcoSendMessage(mrpGetInfo("Lore", "history", mrpGetCurProfile()), "MyWarcraftCo", "MyRolePlay", nil, nil, MRP_RESPOND_HIST);
		end

		mtiResetTimer(mrpHistTimer);
		mtiStartTimer(mrpHistTimer);

	elseif (msg == MRP_GET_FLAGRSP_DESC) then
		if (mrpIsWaitingForDescription(target) == false) then
			mrpAddWaitingForDescription(target);
		end

		mcoSendHardMessage("<DP>" .. target, "xtensionxtooltip2");
	end
end

function mrpCreateRespondMessage()
	local curProfile = mrpGetCurProfile();

	local finalMessage = MRP_INFO_INDEX_VERSION .. mrpVersion;
	finalMessage = finalMessage .. MRP_INFO_INDEX_SUPPORTS .. mrpSupports
	finalMessage = finalMessage .. MRP_INFO_INDEX_PREFIX .. mrpGetInfo("Identification", "prefix", curProfile);
	finalMessage = finalMessage .. MRP_INFO_INDEX_FIRSTNAME .. mrpGetInfo("Identification", "firstname", curProfile);
	finalMessage = finalMessage .. MRP_INFO_INDEX_MIDDLENAME .. mrpGetInfo("Identification", "middlename", curProfile);
	finalMessage = finalMessage .. MRP_INFO_INDEX_SURNAME .. mrpGetInfo("Identification", "surname", curProfile);
	finalMessage = finalMessage .. MRP_INFO_INDEX_TITLE .. mrpGetInfo("Identification", "title", curProfile);
	finalMessage = finalMessage .. MRP_INFO_INDEX_NICKNAME .. mrpGetInfo("Identification", "nickname", curProfile);
	finalMessage = finalMessage .. MRP_INFO_INDEX_HOUSENAME .. mrpGetInfo("Identification", "housename", curProfile);
	finalMessage = finalMessage .. MRP_INFO_INDEX_EYECOLOUR .. mrpGetInfo("Appearance", "eyeColour", curProfile);
	finalMessage = finalMessage .. MRP_INFO_INDEX_APPARENTAGE .. mrpGetInfo("Appearance", "apparentAge", curProfile);
	finalMessage = finalMessage .. MRP_INFO_INDEX_CURRENTEMOTION .. mrpGetInfo("Appearance", "currentEmotion", curProfile);
	finalMessage = finalMessage .. MRP_INFO_INDEX_WEIGHT .. mrpGetInfo("Appearance", "weight", curProfile);
	finalMessage = finalMessage .. MRP_INFO_INDEX_HEIGHT .. mrpGetInfo("Appearance", "height", curProfile);
	finalMessage = finalMessage .. MRP_INFO_INDEX_CURHOME .. mrpGetInfo("Lore", "curHome", curProfile);
	finalMessage = finalMessage .. MRP_INFO_INDEX_BIRTHPLACE .. mrpGetInfo("Lore", "birthPlace", curProfile);
	finalMessage = finalMessage .. MRP_INFO_INDEX_ROLEPLAYSTATUS .. mrpGetInfo("Status", "roleplay", curProfile);
	finalMessage = finalMessage .. MRP_INFO_INDEX_CHARACTERSTATUS .. mrpGetInfo("Status", "character", curProfile);
	finalMessage = finalMessage .. MRP_INFO_INDEX_MOTTO .. mrpGetInfo("Lore", "motto", curProfile);
	finalMessage = finalMessage .. string.char(5);

	return finalMessage;
end

function mrpDataRequest(data, dataVersion, dataLength, target, sender)
	if (target == UnitName("player")) then
		mrpSendMessage(MRP_RESPOND);
	end
end

function mrpDataRespond(data, dataVersion, dataLength, target, sender)
	for i = 1, table.maxn(mrpPacketHolder) do
		if (mrpPacketHolder[i].playerName == sender) then
			if (mrpPacketHolder[i].dataLength == dataLength and mrpPacketHolder[i].dataVersion < dataVersion) then
				mrpPacketHolder[i].dataVersion = dataVersion;
				mrpPacketHolder[i].data = mrpPacketHolder[i].data .. data;
			else
				mrpPacketHolder[i].data = data;
				mrpPacketHolder[i].dataVersion = dataVersion;
				mrpPacketHolder[i].dataLength = dataLength;
			end

			mrpUpdatePlayerListInfo();

			return;
		end
	end

	local newSize = table.maxn(mrpPacketHolder) + 1;

	table.insert(mrpPacketHolder, newSize, {});
	mrpPacketHolder[newSize].playerName = sender;
	mrpPacketHolder[newSize].data = data;
	mrpPacketHolder[newSize].dataVersion = dataVersion;
	mrpPacketHolder[newSize].dataLength = dataLength;

	mrpUpdatePlayerListInfo();

	return;
end

function mrpSendDescription(data, dataVersion, dataLength, target, sender)
	if (target == UnitName("player")) then
		mrpSendMessage(MRP_RESPOND_DESC);
	end
end

function mrpSendHistory(data, dataVersion, dataLength, target, sender)
	if (target == UnitName("player")) then
		mrpSendMessage(MRP_RESPOND_HIST);
	end
end

function mrpRecordDescription(data, dataVersion, dataLength, target, sender)
	mrpUpdatePlayerListDescription(sender, data, dataVersion);
	mrpEditPlayerListInfo(sender, "Misc", "hasInfo", true);
end

function mrpRecordHistory(data, dataVersion, dataLength, target, sender)
	mrpUpdatePlayerListHistory(sender, data, dataVersion);
	mrpEditPlayerListInfo(sender, "Misc", "hasInfo", true);
end

function mrpRegisterDataIds()
	mcoRegisterDataId(MRP_GET_INFO, mrpDataRequest, "MyWarcraftCo", "MyRolePlay");
	mcoRegisterDataId(MRP_RESPOND, mrpDataRespond, "MyWarcraftCo", "MyRolePlay");
	mcoRegisterDataId(MRP_GET_DESC, mrpSendDescription, "MyWarcraftCo", "MyRolePlay");
	mcoRegisterDataId(MRP_GET_HIST, mrpSendHistory, "MyWarcraftCo", "MyRolePlay");
	mcoRegisterDataId(MRP_RESPOND_DESC, mrpRecordDescription, "MyWarcraftCo", "MyRolePlay");
	mcoRegisterDataId(MRP_RESPOND_HIST, mrpRecordHistory, "MyWarcraftCo", "MyRolePlay");
end

function mrpUnregisterDataIds()
	mcoUnregisterDataId(MRP_GET_INFO, "MyWarcraftCo", "MyRolePlay");
	mcoUnregisterDataId(MRP_RESPOND, "MyWarcraftCo", "MyRolePlay");
	mcoUnregisterDataId(MRP_GET_DESC, "MyWarcraftCo", "MyRolePlay");
	mcoUnregisterDataId(MRP_GET_HIST, "MyWarcraftCo", "MyRolePlay");
	mcoUnregisterDataId(MRP_RESPOND_DESC, "MyWarcraftCo", "MyRolePlay");
	mcoUnregisterDataId(MRP_RESPOND_HIST, "MyWarcraftCo", "MyRolePlay");
end

--/script mcoSendMessage("testData", "MyWarcraftCo", "MyRolePlay", nil, nil, MRP_GET_INFO, UnitName("player"));
