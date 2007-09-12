--[[
	function
	name: mrpDisplayTooltip
	args: Unit target, String mrpFromWhere
	returns: nil;

	Description:
		mrpDisplayTooltip displays a tooltip describing the target chosen by the args.
		This function creates an arithmetically created tooltip. It is not static in any way.
		Depending on where the call came from, the target, and the information in the Order table,
		mrpDisplayTooltip will dynamically create new tooltips.

		Tooltips with this function are displayed in a table format, with rows and columns.
		For example:

		       | Col1 | Col2 | Col3 | Col4
		-------------------------------------
		Row1   | Mrs. |Trilia| Sair | Trinkart
		Row2   | Leader of the Forgotten people
		Row3   |Level |  14  | Priest
		Row4   | More data
		Row5   | And as much as you want up to 30 (the gametooltip limit)

		Notice how you don't have to have the same number of columns in each row.

		To pass information into this function, you use the foo[row][col] = x format.

	-- args description --
	Unit target:
		The Unit you want to display the information for.
		The following Units are handled currently in this function:
			"player"	-- you
			"target"	-- your target
			"mouseover"	-- the object you are mousing over

	String mrpFromWhere:
		This is a flag to tell the function where the request for a tooltip is coming from.
		Most calls to mrpDisplayTooltip are from a mouseover. So the appropriate name for mrpFromWhere
		in this case is "MOUSEOVER"
		Possible values:
			"CHATMESSAGE"	-- whenever a chat event calls the function
			"MOUSEOVER"	-- whenever a mouseover event calls the function
			"PLAYER"	-- whenever you call the function on yourself
]]
MRP_TOOLTIP_EMPTY_STRING = "";

function mrpDisplayTooltip(target, mrpFromWhere)
	-- If the display tooltips MRP style option is enabled, execute this code.
	if (mrpCheckSettings("Tooltip", "enabled") == true) then
		if (UnitIsPlayer(target)) then
			-- Reset the tooltip to be blank.
			GameTooltip:ClearLines();
			GameTooltip_SetDefaultAnchor(GameTooltip, UIParent);

			local i = nil;
			local j = nil;
			-- mrpTempString is a string that stores the temporary line that is being worked on.
			-- It is reset everytime a new sector is calculated.
			local mrpTempString = MRP_TOOLTIP_EMPTY_STRING;
			local firstRun = 1;
			local name = UnitName(target);

			if (UnitIsFriend("player", target)) then
				if (mrpFromWhere == "MOUSEOVER") then
					-- If the player has MyRolePlay, load his/her information into the target.
					if (mrpIsPlayerInList(name) == true) then
						if (mrpPlayerHasInfo(name) == true) then
							local search = mdbCreateSearchPacket("playerName", "=", name);
							mrpTarget = {};
							mrpTarget.Identification = {};
							mrpTarget.Appearance = {};
							mrpTarget.Lore = {};
							mrpTarget.Status = {};

							local temp = mdbSearchData("MyRolePlayPlayerList", mdbCreateTablePacket(nil, "Identification"), mdbCreateColumnPacket("prefix", "firstname", "middlename", "surname", "title", "nickname", "housename"), search);

							mrpTarget.Identification.Prefix, mrpTarget.Identification.Firstname, mrpTarget.Identification.Middlename, mrpTarget.Identification.Surname, mrpTarget.Identification.Title, mrpTarget.Identification.Nickname, mrpTarget.Identification.Housename = unpack(temp[1]);

							temp = mdbSearchData("MyRolePlayPlayerList", mdbCreateTablePacket(nil, "Status"), mdbCreateColumnPacket("roleplay", "character"), search);
							mrpTarget.Status.Roleplay, mrpTarget.Status.Character = unpack(temp[1]);

							mrpSetTargetFactionRank("MOUSEOVER");
						-- elseif the target has MyRolePlay information, grab it.
						else
							local inMRP = mrpIsPlayerInMRP(name);

							if (inMRP == true) then
								-- Experimental here, to stop us sending more than one request at a time!
								if ((UnitIsAFK("mouseover") ~= 1) and (mrpIsWaitingForInfo(name) == false)) then
									mrpSendMessage(MRP_GET_INFO, name);
								end

								mrpTarget = {};
								mrpTarget.Identification = {};
								mrpTarget.Appearance = {};
								mrpTarget.Lore = {};
								mrpTarget.Status = {};

								mrpTarget.Identification.Surname = MRP_TOOLTIP_EMPTY_STRING;
								mrpTarget.Identification.Title = MRP_TOOLTIP_EMPTY_STRING;
								mrpTarget.Status.Roleplay = MRP_TOOLTIP_EMPTY_STRING;
								mrpTarget.Status.Character = MRP_TOOLTIP_EMPTY_STRING;

								mrpTarget.Identification.Firstname = name;
								mrpTarget.Identification.Middlename = MRP_TOOLTIP_EMPTY_STRING;
								mrpTarget.Identification.Nickname = MRP_TOOLTIP_EMPTY_STRING;
								mrpTarget.Identification.Housename = MRP_TOOLTIP_EMPTY_STRING;

								mrpTarget.Appearance.EyeColour = MRP_TOOLTIP_EMPTYSTRING;
								mrpTarget.Appearance.Height = MRP_TOOLTIP_EMPTY_STRING;
								mrpTarget.Appearance.Weight = MRP_TOOLTIP_EMPTY_STRING;
								mrpTarget.Appearance.CurrentEmotion = MRP_TOOLTIP_EMPTY_STRING;

								mrpTarget.Lore.Motto = MRP_TOOLTIP_EMPTY_STRING;
								mrpTarget.Lore.Homecity = MRP_TOOLTIP_EMPTY_STRING;
								mrpTarget.Lore.Birthcity = MRP_TOOLTIP_EMPTY_STRING;

								mrpTarget.Identification.Prefix = MRP_TOOLTIP_EMPTY_STRING;
								mrpSetTargetFactionRank("MOUSEOVER");
							elseif (inMRP == false) then
								mrpTarget = {};
								mrpTarget.Identification = {};
								mrpTarget.Appearance = {};
								mrpTarget.Lore = {};
								mrpTarget.Status = {};

								mrpTarget.Identification.Surname = MRP_TOOLTIP_EMPTY_STRING;
								mrpTarget.Identification.Title = MRP_TOOLTIP_EMPTY_STRING;
								mrpTarget.Status.Roleplay = MRP_TOOLTIP_EMPTY_STRING;
								mrpTarget.Status.Character = MRP_TOOLTIP_EMPTY_STRING;

								mrpTarget.Identification.Firstname = name;
								mrpTarget.Identification.Middlename = MRP_TOOLTIP_EMPTY_STRING;
								mrpTarget.Identification.Nickname = MRP_TOOLTIP_EMPTY_STRING;
								mrpTarget.Identification.Housename = MRP_TOOLTIP_EMPTY_STRING;

								mrpTarget.Appearance.EyeColour = MRP_TOOLTIP_EMPTYSTRING;
								mrpTarget.Appearance.Height = MRP_TOOLTIP_EMPTY_STRING;
								mrpTarget.Appearance.Weight = MRP_TOOLTIP_EMPTY_STRING;
								mrpTarget.Appearance.CurrentEmotion = MRP_TOOLTIP_EMPTY_STRING;

								mrpTarget.Lore.Motto = MRP_TOOLTIP_EMPTY_STRING;
								mrpTarget.Lore.Homecity = MRP_TOOLTIP_EMPTY_STRING;
								mrpTarget.Lore.Birthcity = MRP_TOOLTIP_EMPTY_STRING;

								mrpTarget.Identification.Prefix = MRP_TOOLTIP_EMPTY_STRING;
								mrpSetTargetFactionRank("MOUSEOVER");
							end
						end

					-- else - The target is niether a MyRolePlay user or FlagRSP user. Load only UnitName.
					else
						mrpTarget = {};
						mrpTarget.Identification = {};
						mrpTarget.Appearance = {};
						mrpTarget.Lore = {};
						mrpTarget.Status = {};

						mrpTarget.Identification.Surname = MRP_TOOLTIP_EMPTY_STRING;
						mrpTarget.Identification.Title = MRP_TOOLTIP_EMPTY_STRING;
						mrpTarget.Status.Roleplay = MRP_TOOLTIP_EMPTY_STRING;
						mrpTarget.Status.Character = MRP_TOOLTIP_EMPTY_STRING;

						mrpTarget.Identification.Firstname = name;
						mrpTarget.Identification.Middlename = MRP_TOOLTIP_EMPTY_STRING;
						mrpTarget.Identification.Nickname = MRP_TOOLTIP_EMPTY_STRING;
						mrpTarget.Identification.Housename = MRP_TOOLTIP_EMPTY_STRING;

						mrpTarget.Appearance.EyeColour = MRP_TOOLTIP_EMPTYSTRING;
						mrpTarget.Appearance.Height = MRP_TOOLTIP_EMPTY_STRING;
						mrpTarget.Appearance.Weight = MRP_TOOLTIP_EMPTY_STRING;
						mrpTarget.Appearance.CurrentEmotion = MRP_TOOLTIP_EMPTY_STRING;

						mrpTarget.Lore.Motto = MRP_TOOLTIP_EMPTY_STRING;
						mrpTarget.Lore.Homecity = MRP_TOOLTIP_EMPTY_STRING;
						mrpTarget.Lore.Birthcity = MRP_TOOLTIP_EMPTY_STRING;

						mrpTarget.Identification.Prefix = MRP_TOOLTIP_EMPTY_STRING;
						mrpSetTargetFactionRank("MOUSEOVER");
					end

					local numOfLines = 0;
					local curLine = 1;

					for i = 1, mrpGetNumTooltipRows("default") do
						mrpTempString = MRP_TOOLTIP_EMPTY_STRING;

						for j = 1, mrpGetNumTooltipColumns("default", i) do
							mrpSecondTempString = mrpAssessTooltipInfo("default", i, j, target);

							if (mrpSecondTempString ~= MRP_TOOLTIP_EMPTY_STRING) then
								mrpTempString = mrpTempString .. mrpSecondTempString;
							end
						end

						if (firstRun == 1) then
							GameTooltip:SetUnit(target);
							numOfLines = GameTooltip:NumLines();

							if (mrpTempString ~= MRP_TOOLTIP_EMPTY_STRING) then
								GameTooltipTextLeft1:SetText(mrpTempString);
								firstRun = 0;
							end
						else
							if (mrpTempString ~= MRP_TOOLTIP_EMPTY_STRING) then
								curLine = curLine + 1;

								if (curLine <= numOfLines) then
									getglobal("GameTooltipTextLeft" .. curLine):SetText(mrpTempString);
								else
									GameTooltip:AddLine(mrpTempString);
								end
							end
						end
					end

				elseif (mrpFromWhere == "PLAYER") then
					-- Grab the rank only of the target.
					local curProfile = mrpGetCurProfile();

					mrpTarget = {};
					mrpTarget.Identification = {};
					mrpTarget.Appearance = {};
					mrpTarget.Lore = {};
					mrpTarget.Status = {};

					mrpTarget.Identification.Surname = mrpGetInfo("Identification", "surname", curProfile);
					mrpTarget.Identification.Title = mrpGetInfo("Identification", "title", curProfile);
					mrpTarget.Status.Roleplay = mrpGetInfo("Status", "roleplay", curProfile);
					mrpTarget.Status.Character = mrpGetInfo("Status", "character", curProfile);

					mrpTarget.Identification.Firstname = mrpGetInfo("Identification", "firstname", curProfile);
					mrpTarget.Identification.Middlename = mrpGetInfo("Identification", "middlename", curProfile);
					mrpTarget.Identification.Nickname = mrpGetInfo("Identification", "nickname", curProfile);
					mrpTarget.Identification.Housename = mrpGetInfo("Identification", "housename", curProfile);

					mrpTarget.Appearance.EyeColour = mrpGetInfo("Appearance", "eyeColour", curProfile);
					mrpTarget.Appearance.Height = mrpGetInfo("Appearance", "height", curProfile);
					mrpTarget.Appearance.Weight = mrpGetInfo("Appearance", "weight", curProfile);
					mrpTarget.Appearance.CurrentEmotion = mrpGetInfo("Appearance", "currentEmotion", curProfile);

					mrpTarget.Lore.Motto = mrpGetInfo("Lore", "motto", curProfile);
					mrpTarget.Lore.Homecity = mrpGetInfo("Lore", "curHome", curProfile);
					mrpTarget.Lore.Birthcity = mrpGetInfo("Lore", "birthPlace", curProfile);

					mrpTarget.Identification.Prefix = mrpGetInfo("Identification", "prefix", curProfile);
					mrpSetTargetFactionRank("PLAYER");

					local numOfLines = 0;
					local curLine = 1;

					for i = 1, mrpGetNumTooltipRows("default") do
						mrpTempString = MRP_TOOLTIP_EMPTY_STRING;

						for j = 1, mrpGetNumTooltipColumns("default", i) do
							mrpSecondTempString = mrpAssessTooltipInfo("default", i, j, target);

							if (mrpSecondTempString ~= MRP_TOOLTIP_EMPTY_STRING) then
								mrpTempString = mrpTempString .. mrpSecondTempString;
							end
						end

						if (firstRun == 1) then
							GameTooltip:SetUnit(target);
							numOfLines = GameTooltip:NumLines();

							if (mrpTempString ~= MRP_TOOLTIP_EMPTY_STRING) then
								GameTooltipTextLeft1:SetText(mrpTempString);
								firstRun = 0;
							end
						else
							if (mrpTempString ~= MRP_TOOLTIP_EMPTY_STRING) then
								curLine = curLine + 1;

								if (curLine <= numOfLines) then
									getglobal("GameTooltipTextLeft" .. curLine):SetText(mrpTempString);
								else
									GameTooltip:AddLine(mrpTempString);
								end
							end
						end
					end
				end
			elseif (UnitIsEnemy("player", target)) then
				mrpTarget = {};
				mrpTarget.Identification = {};
				mrpTarget.Appearance = {};
				mrpTarget.Lore = {};
				mrpTarget.Status = {};

				mrpTarget.Identification.Surname = MRP_TOOLTIP_EMPTY_STRING;
				mrpTarget.Identification.Title = MRP_TOOLTIP_EMPTY_STRING;
				mrpTarget.Status.Roleplay = MRP_TOOLTIP_EMPTY_STRING;
				mrpTarget.Status.Character = MRP_TOOLTIP_EMPTY_STRING;

				mrpTarget.Identification.Firstname = name;
				mrpTarget.Identification.Middlename = MRP_TOOLTIP_EMPTY_STRING;
				mrpTarget.Identification.Nickname = MRP_TOOLTIP_EMPTY_STRING;
				mrpTarget.Identification.Housename = MRP_TOOLTIP_EMPTY_STRING;

				mrpTarget.Appearance.EyeColour = MRP_TOOLTIP_EMPTYSTRING;
				mrpTarget.Appearance.Height = MRP_TOOLTIP_EMPTY_STRING;
				mrpTarget.Appearance.Weight = MRP_TOOLTIP_EMPTY_STRING;
				mrpTarget.Appearance.CurrentEmotion = MRP_TOOLTIP_EMPTY_STRING;

				mrpTarget.Lore.Motto = MRP_TOOLTIP_EMPTY_STRING;
				mrpTarget.Lore.Homecity = MRP_TOOLTIP_EMPTY_STRING;
				mrpTarget.Lore.Birthcity = MRP_TOOLTIP_EMPTY_STRING;

				mrpTarget.Identification.Prefix = MRP_TOOLTIP_EMPTY_STRING;
				mrpSetTargetFactionRank("MOUSEOVER");

				local numOfLines = 0;
				local curLine = 1;

				for i = 1, mrpGetNumTooltipRows("default") do
					mrpTempString = MRP_TOOLTIP_EMPTY_STRING;

					for j = 1, mrpGetNumTooltipColumns("default", i) do
						mrpSecondTempString = mrpAssessTooltipInfo("default", i, j, target);

						if (mrpSecondTempString ~= MRP_TOOLTIP_EMPTY_STRING) then
							mrpTempString = mrpTempString .. mrpSecondTempString;
						end
					end

					if (firstRun == 1) then
						GameTooltip:SetUnit(target);
						numOfLines = GameTooltip:NumLines();

						if (mrpTempString ~= MRP_TOOLTIP_EMPTY_STRING) then
							GameTooltipTextLeft1:SetText(mrpTempString);
							firstRun = 0;
						end
					else
						if (mrpTempString ~= MRP_TOOLTIP_EMPTY_STRING) then
							curLine = curLine + 1;

							if (curLine <= numOfLines) then
								getglobal("GameTooltipTextLeft" .. curLine):SetText(mrpTempString);
							else
								GameTooltip:AddLine(mrpTempString);
							end
						end
					end
				end
			end
			GameTooltip:Show();
		end
	end
end

--[[
	function
	name: mrpAssessTooltipInfo
	args: string orderName, int i, int j, Unit target
	returns: string

	Description:
		This function takes the data specified in a table but looking at row i and column j of the Order table of
		Order orderName and return a string with the information that the Order table told it to find.
		Most of the options here are fairly simple. A few are not though, and they are documented.

	-- args description --
	string orderName:
		This string determines the order which the tooltip is to be diplayed from the Order table.

	int i:
		The current row.

	int j:
		The current column.

	Unit target:
		The Unit you want to display the information for.
		The following Units are handled currently in this function:
			"player"	-- you
			"mouseover"	-- the object you are mousing over

	-- return description --
	This function returns many possible strings. Most are colour formatted with the options that the
	user has specified in the settings. Some returns have special meaning.

	return (" ")
		This is a newline.

	return (MRP_TOOLTIP_EMPTY_STRING)
		This is essentially a null. The function that this returns this string to will see a MRP_TOOLTIP_EMPTY_STRING (a blank string)
		and then not add its information to the tooltip.
]]
function mrpAssessTooltipInfo(orderName, i, j, target)
	local info = mrpGetTooltipInfo(orderName, i, j);

	if (info == MRP_TOOLTIP_NEWLINE) then
		return (" ");
	end

	-- This for loop handles the conditional newline. This means that it will only add a new line IF its condition is met.
	-- This is explained at the top of this lua file.
	if (type(info) == "table" and info.Values and info.Values ~= nil) then
		for curDistance = 1, info.distance do
			if (info.Type == 0) then
				for column = 1, mrpGetNumTooltipColumns(orderName, i - curDistance) do
					for curValue = 1, table.maxn(info.Values) do
						if (info.Values[curValue] == mrpGetTooltipInfo(orderName, i - curDistance, column) and mrpAssessTooltipInfo(orderName, i - curDistance, column, target) ~= MRP_TOOLTIP_EMPTY_STRING) then
							return (" ");
						end
					end
				end
			else
				for column = 1, mrpGetNumTooltipColumns(orderName, i + curDistance) do
					for curValue = 1, table.maxn(info.Values) do
						if (info.Values[curValue] == mrpGetTooltipInfo(orderName, i + curDistance, column) and mrpAssessTooltipInfo(orderName, i + curDistance, column, target) ~= MRP_TOOLTIP_EMPTY_STRING) then
							return (" ");
						end
					end
				end
			end
		end

		return (MRP_TOOLTIP_EMPTY_STRING);
	end
	if (type(info) == "table" and info.text and info.text ~= nil) then
		if (info.boA == MRP_TOOLTIP_TEXT_BEFORE) then
			if (mrpGetTooltipInfo(orderName, i, j - 1) ~= nil) then
				if (mrpAssessTooltipInfo(orderName, i, j - 1, target) ~= MRP_TOOLTIP_EMPTY_STRING) then
					return (mrpHexStart .. mduColourToHex(info.Colours.red, info.Colours.green, info.Colours.blue) .. info.text .. mrpHexEnd);
				end
			end
		elseif (info.boA == MRP_TOOLTIP_TEXT_AFTER) then
			if (mrpGetTooltipInfo(orderName, i, j + 1) ~= nil) then
				if (mrpAssessTooltipInfo(orderName, i, j + 1, target) ~= MRP_TOOLTIP_EMPTY_STRING) then
					return (mrpHexStart .. mduColourToHex(info.Colours.red, info.Colours.green, info.Colours.blue) .. info.text .. mrpHexEnd);
				end
			end
		elseif (info.boA == MRP_TOOLTIP_TEXT_ALWAYS) then
			return (mrpHexStart .. mduColourToHex(info.Colours.red, info.Colours.green, info.Colours.blue) .. info.text .. mrpHexEnd);

		elseif (info.boA == MRP_TOOLTIP_TEXT_BOTH) then
			if (mrpGetTooltipInfo(orderName, i, j + 1) ~= nil and mrpGetTooltipInfo(orderName, i, j - 1) ~= nil) then
				if (mrpAssessTooltipInfo(orderName, i, j + 1, target) ~= MRP_TOOLTIP_EMPTY_STRING and mrpAssessTooltipInfo(orderName, i, j - 1, target) ~= MRP_TOOLTIP_EMPTY_STRING) then
					return (mrpHexStart .. mduColourToHex(info.Colours.red, info.Colours.green, info.Colours.blue) .. info.text .. mrpHexEnd);
				end
			end
		end

		return (MRP_TOOLTIP_EMPTY_STRING);
	end
	if (info == MRP_TOOLTIP_PREFIX) then
		if (mrpTarget.Identification.Prefix ~= MRP_TOOLTIP_EMPTY_STRING) then
			if (UnitCanAttack(target, "player")) then
				return (mrpHexStart .. mduColourToHex(MyRolePlay.Settings.Colours.EnemyPvpHostile.red, MyRolePlay.Settings.Colours.EnemyPvpHostile.green, MyRolePlay.Settings.Colours.EnemyPvpHostile.blue) .. mrpTarget.Identification.Prefix .. " " .. mrpHexEnd);
			elseif (UnitCanAttack("player", target)) then
				return (mrpHexStart .. mduColourToHex(MyRolePlay.Settings.Colours.EnemyPvpNotHostile.red, MyRolePlay.Settings.Colours.EnemyPvpNotHostile.green, MyRolePlay.Settings.Colours.EnemyPvpNotHostile.blue) .. mrpTarget.Identification.Prefix .. " " .. mrpHexEnd);
			end
			if (UnitIsPVP(target)) then
				return (mrpHexStart .. mduColourToHex(MyRolePlay.Settings.Colours.PrefixPvp.red, MyRolePlay.Settings.Colours.PrefixPvp.green, MyRolePlay.Settings.Colours.PrefixPvp.blue) .. mrpTarget.Identification.Prefix .. " " .. mrpHexEnd);
			else
				return (mrpHexStart .. mduColourToHex(MyRolePlay.Settings.Colours.PrefixNonPvp.red, MyRolePlay.Settings.Colours.PrefixNonPvp.green, MyRolePlay.Settings.Colours.PrefixNonPvp.blue) .. mrpTarget.Identification.Prefix .. " " .. mrpHexEnd);
			end
		end
		return (MRP_TOOLTIP_EMPTY_STRING);
	end
	if (info == MRP_TOOLTIP_FIRSTNAME) then
		if (mrpTarget.Identification.Firstname ~= MRP_TOOLTIP_EMPTY_STRING) then
			if (UnitCanAttack(target, "player")) then
				return (mrpHexStart .. mduColourToHex(MyRolePlay.Settings.Colours.EnemyPvpHostile.red, MyRolePlay.Settings.Colours.EnemyPvpHostile.green, MyRolePlay.Settings.Colours.EnemyPvpHostile.blue) .. mrpTarget.Identification.Firstname .. " " .. mrpHexEnd);
			elseif (UnitCanAttack("player", target)) then
				return (mrpHexStart .. mduColourToHex(MyRolePlay.Settings.Colours.EnemyPvpNotHostile.red, MyRolePlay.Settings.Colours.EnemyPvpNotHostile.green, MyRolePlay.Settings.Colours.EnemyPvpNotHostile.blue) .. mrpTarget.Identification.Firstname .. " " .. mrpHexEnd);
			end
			if (UnitIsPVP(target)) then
				return (mrpHexStart .. mduColourToHex(MyRolePlay.Settings.Colours.FirstnamePvp.red, MyRolePlay.Settings.Colours.FirstnamePvp.green, MyRolePlay.Settings.Colours.FirstnamePvp.blue) .. mrpTarget.Identification.Firstname .. " " .. mrpHexEnd);
			else
				return (mrpHexStart .. mduColourToHex(MyRolePlay.Settings.Colours.FirstnameNonPvp.red, MyRolePlay.Settings.Colours.FirstnameNonPvp.green, MyRolePlay.Settings.Colours.FirstnameNonPvp.blue) .. mrpTarget.Identification.Firstname .. " " .. mrpHexEnd);
			end
		end
		return (MRP_TOOLTIP_EMPTY_STRING);
	end
	if (info == MRP_TOOLTIP_MIDDLENAME) then
		if (mrpTarget.Identification.Middlename ~= MRP_TOOLTIP_EMPTY_STRING) then
			if (UnitCanAttack(target, "player")) then
				return (mrpHexStart .. mduColourToHex(MyRolePlay.Settings.Colours.EnemyPvpHostile.red, MyRolePlay.Settings.Colours.EnemyPvpHostile.green, MyRolePlay.Settings.Colours.EnemyPvpHostile.blue) .. mrpTarget.Identification.Middlename .. " " .. mrpHexEnd);
			elseif (UnitCanAttack("player", target)) then
				return (mrpHexStart .. mduColourToHex(MyRolePlay.Settings.Colours.EnemyPvpNotHostile.red, MyRolePlay.Settings.Colours.EnemyPvpNotHostile.green, MyRolePlay.Settings.Colours.EnemyPvpNotHostile.blue) .. mrpTarget.Identification.Middlename .. " " .. mrpHexEnd);
			end
			if (UnitIsPVP(target)) then
				return (mrpHexStart .. mduColourToHex(MyRolePlay.Settings.Colours.MiddlenamePvp.red, MyRolePlay.Settings.Colours.MiddlenamePvp.green, MyRolePlay.Settings.Colours.MiddlenamePvp.blue) .. mrpTarget.Identification.Middlename .. " " .. mrpHexEnd);
			else
				return (mrpHexStart .. mduColourToHex(MyRolePlay.Settings.Colours.MiddlenameNonPvp.red, MyRolePlay.Settings.Colours.MiddlenameNonPvp.green, MyRolePlay.Settings.Colours.MiddlenameNonPvp.blue) .. mrpTarget.Identification.Middlename .. " " .. mrpHexEnd);
			end
		end
		return (MRP_TOOLTIP_EMPTY_STRING);
	end
	if (info == MRP_TOOLTIP_SURNAME) then
		if (mrpTarget.Identification.Surname ~= MRP_TOOLTIP_EMPTY_STRING) then
			if (UnitCanAttack(target, "player")) then
				return (mrpHexStart .. mduColourToHex(MyRolePlay.Settings.Colours.EnemyPvpHostile.red, MyRolePlay.Settings.Colours.EnemyPvpHostile.green, MyRolePlay.Settings.Colours.EnemyPvpHostile.blue) .. mrpTarget.Identification.Surname .. " " .. mrpHexEnd);
			elseif (UnitCanAttack("player", target)) then
				return (mrpHexStart .. mduColourToHex(MyRolePlay.Settings.Colours.EnemyPvpNotHostile.red, MyRolePlay.Settings.Colours.EnemyPvpNotHostile.green, MyRolePlay.Settings.Colours.EnemyPvpNotHostile.blue) .. mrpTarget.Identification.Surname .. " " .. mrpHexEnd);
			end
			if (UnitIsPVP(target)) then
				return (mrpHexStart .. mduColourToHex(MyRolePlay.Settings.Colours.SurnamePvp.red, MyRolePlay.Settings.Colours.SurnamePvp.green, MyRolePlay.Settings.Colours.SurnamePvp.blue) .. mrpTarget.Identification.Surname .. " " .. mrpHexEnd);
			else
				return (mrpHexStart .. mduColourToHex(MyRolePlay.Settings.Colours.SurnameNonPvp.red, MyRolePlay.Settings.Colours.SurnameNonPvp.green, MyRolePlay.Settings.Colours.SurnameNonPvp.blue) .. mrpTarget.Identification.Surname .. " " .. mrpHexEnd);
			end
		end
		return (MRP_TOOLTIP_EMPTY_STRING);
	end
	if (info == MRP_TOOLTIP_TITLE) then
		if (mrpTarget.Identification.Title ~= MRP_TOOLTIP_EMPTY_STRING) then
			return (mrpHexStart .. mduColourToHex(MyRolePlay.Settings.Colours.Title.red, MyRolePlay.Settings.Colours.Title.green, MyRolePlay.Settings.Colours.Title.blue) .. mrpTarget.Identification.Title .. " " .. mrpHexEnd);
		end
		return (MRP_TOOLTIP_EMPTY_STRING);
	end
	if (info == MRP_TOOLTIP_HOUSENAME) then
		if (mrpTarget.Identification.Housename ~= MRP_TOOLTIP_EMPTY_STRING) then
			return (mrpHexStart .. mduColourToHex(MyRolePlay.Settings.Colours.HouseName.red, MyRolePlay.Settings.Colours.HouseName.green, MyRolePlay.Settings.Colours.HouseName.blue) .. mrpTarget.Identification.Housename .. " " .. mrpHexEnd);
		end
		return (MRP_TOOLTIP_EMPTY_STRING);
	end
	if (info == MRP_TOOLTIP_NICKNAME) then
		if (mrpTarget.Identification.Nickname ~= MRP_TOOLTIP_EMPTY_STRING) then
			return (mrpHexStart .. mduColourToHex(MyRolePlay.Settings.Colours.Nickname.red, MyRolePlay.Settings.Colours.Nickname.green, MyRolePlay.Settings.Colours.Nickname.blue) .. mrpTarget.Identification.Nickname .. " " .. mrpHexEnd);
		end
		return (MRP_TOOLTIP_EMPTY_STRING);
	end
	if (info == MRP_TOOLTIP_GUILDRANK) then
		mrpTargetGuildName, mrpTargetGuildRank = GetGuildInfo(target);
		if (mrpTargetGuildName ~= nil) then
			return (mrpHexStart .. mduColourToHex(MyRolePlay.Settings.Colours.Guild.red, MyRolePlay.Settings.Colours.Guild.green, MyRolePlay.Settings.Colours.Guild.blue) .. mrpTargetGuildRank .. mrpHexEnd);
		end
		return (MRP_TOOLTIP_EMPTY_STRING);
	end
	if (info == MRP_TOOLTIP_GUILD) then
		mrpTargetGuildName, mrpTargetGuildRank = GetGuildInfo(target);
		if (mrpTargetGuildName ~= nil) then
			return (mrpHexStart .. mduColourToHex(MyRolePlay.Settings.Colours.Guild.red, MyRolePlay.Settings.Colours.Guild.green, MyRolePlay.Settings.Colours.Guild.blue) .. mrpTargetGuildName .. mrpHexEnd);
		end
		return (MRP_TOOLTIP_EMPTY_STRING);
	end
	if (info == MRP_TOOLTIP_PVPRANK) then
		if (UnitPlayerControlled(target)) then
			mrpTargetFaction = UnitFactionGroup(target);
			if (mrpTarget.Identification.FactionRank ~= MRP_TOOLTIP_EMPTY_STRING) then
				if (mrpTargetFaction == "Horde") then
					return (mrpHexStart .. mduColourToHex(MyRolePlay.Settings.Colours.FactionHorde.red, MyRolePlay.Settings.Colours.FactionHorde.green, MyRolePlay.Settings.Colours.FactionHorde.blue) .. mrpTarget.Identification.FactionRank .. MRP_LOCALE_OFTHE_HORDE_FACTION .. " " .. mrpHexEnd);
				else
					return (mrpHexStart .. mduColourToHex(MyRolePlay.Settings.Colours.FactionAlliance.red, MyRolePlay.Settings.Colours.FactionAlliance.green, MyRolePlay.Settings.Colours.FactionAlliance.blue) .. mrpTarget.Identification.FactionRank .. MRP_LOCALE_OFTHE_ALLIANCE_FACTION .. " " .. mrpHexEnd);
				end
			end
		end
		return (MRP_TOOLTIP_EMPTY_STRING);
	end
	if (info == MRP_TOOLTIP_PVPSTATUS) then
		if (UnitIsPVP(target)) then
			if (UnitIsEnemy(target, "player")) then
				return (mrpHexStart .. mduColourToHex(MyRolePlay.Settings.Colours.EnemyPvp.red, MyRolePlay.Settings.Colours.EnemyPvp.green, MyRolePlay.Settings.Colours.EnemyPvp.blue) .. "PvP" .. " " .. mrpHexEnd);
			elseif (UnitIsFriend(target, "player")) then
				return (mrpHexStart .. mduColourToHex(MyRolePlay.Settings.Colours.FriendlyPvp.red, MyRolePlay.Settings.Colours.FriendlyPvp.green, MyRolePlay.Settings.Colours.FriendlyPvp.blue) .. "PvP" .. " " .. mrpHexEnd);
			end
		else
			return (MRP_TOOLTIP_EMPTY_STRING);
		end
		return (MRP_TOOLTIP_EMPTY_STRING);
	end
	if (info == MRP_TOOLTIP_LEVEL) then
		if (mrpCheckSettings("Tooltip", "relativeLevel") == true) then
			return (mrpHexStart .. mduColourToHex(MyRolePlay.Settings.Colours.Level.red, MyRolePlay.Settings.Colours.Level.green, MyRolePlay.Settings.Colours.Level.blue) .. mrpRelativeLevelCheck(UnitLevel(target)) .. " " .. mrpHexEnd);
		else
			if (UnitLevel(target) > -1) then
				return (mrpHexStart .. mduColourToHex(MyRolePlay.Settings.Colours.Level.red, MyRolePlay.Settings.Colours.Level.green, MyRolePlay.Settings.Colours.Level.blue) .. UnitLevel(target) .. " " .. mrpHexEnd);
			else
				return (mrpHexStart .. mduColourToHex(MyRolePlay.Settings.Colours.Level.red, MyRolePlay.Settings.Colours.Level.green, MyRolePlay.Settings.Colours.Level.blue) .. " ?? " .. mrpHexEnd);
			end
		end
		return (MRP_TOOLTIP_EMPTY_STRING);
	end
	if (info == MRP_TOOLTIP_CLASS) then
		if (mrpCheckSettings("Colours", "classEnabled") == true) then
			return (mrpHexStart .. mduColourToHex(MyRolePlay.Settings.Colours.ClassSpecific[UnitClass(target)].red, MyRolePlay.Settings.Colours.ClassSpecific[UnitClass(target)].green, MyRolePlay.Settings.Colours.ClassSpecific[UnitClass(target)].blue) .. UnitClass(target) .. " " .. mrpHexEnd);
		else
			return (mrpHexStart .. mduColourToHex(MyRolePlay.Settings.Colours.Class.red, MyRolePlay.Settings.Colours.Class.green, MyRolePlay.Settings.Colours.Class.blue) .. UnitClass(target) .. " " .. mrpHexEnd);
		end
	end
	if (info == MRP_TOOLTIP_RACE) then
		return (mrpHexStart .. mduColourToHex(MyRolePlay.Settings.Colours.Race.red, MyRolePlay.Settings.Colours.Race.green, MyRolePlay.Settings.Colours.Race.blue) .. UnitRace(target) .. " " .. mrpHexEnd);
	end
	if (info == MRP_TOOLTIP_RPSTYLE) then
		if (mrpTarget.Status.Roleplay ~= MRP_TOOLTIP_EMPTY_STRING) then
			return (mrpHexStart .. mduColourToHex(MyRolePlay.Settings.Colours.Roleplay.red, MyRolePlay.Settings.Colours.Roleplay.green, MyRolePlay.Settings.Colours.Roleplay.blue) .. mrpDecodeStatus(mrpTarget.Status.Roleplay) .. " " .. mrpHexEnd);
		end
		return (MRP_TOOLTIP_EMPTY_STRING);
	end
	if (info == MRP_TOOLTIP_CSSTATUS) then
		if (mrpTarget.Status.Character ~= MRP_TOOLTIP_EMPTY_STRING) then
			return (mrpHexStart .. mduColourToHex(MyRolePlay.Settings.Colours.CharacterStat.red, MyRolePlay.Settings.Colours.CharacterStat.green, MyRolePlay.Settings.Colours.CharacterStat.blue) .. mrpDecodeStatus(mrpTarget.Status.Character) .. " " .. mrpHexEnd);
		end
		return (MRP_TOOLTIP_EMPTY_STRING);
	end
	if (info == MRP_TOOLTIP_UNITNAME) then
		if (UnitCanAttack(target, "player")) then
			return (mrpHexStart .. mduColourToHex(MyRolePlay.Settings.Colours.EnemyPvpHostile.red, MyRolePlay.Settings.Colours.EnemyPvpHostile.green, MyRolePlay.Settings.Colours.EnemyPvpHostile.blue) .. UnitName(target) .. " " .. mrpHexEnd);
		elseif (UnitCanAttack("player", target)) then
			return (mrpHexStart .. mduColourToHex(MyRolePlay.Settings.Colours.EnemyPvpNotHostile.red, MyRolePlay.Settings.Colours.EnemyPvpNotHostile.green, MyRolePlay.Settings.Colours.EnemyPvpNotHostile.blue) .. UnitName(target) .. " " .. mrpHexEnd);
		end
		if (UnitIsPVP(target)) then
			if (UnitIsEnemy(target, "player")) then
				return (mrpHexStart .. mduColourToHex(MyRolePlay.Settings.Colours.EnemyPvpNotHostile.red, MyRolePlay.Settings.Colours.EnemyPvpNotHostile.green, MyRolePlay.Settings.Colours.EnemyPvpNotHostile.blue) .. UnitName(target) .. " " .. mrpHexEnd);
			elseif (UnitIsFriend(target, "player")) then
				return (mrpHexStart .. mduColourToHex(MyRolePlay.Settings.Colours.FirstnamePvp.red, MyRolePlay.Settings.Colours.FirstnamePvp.green, MyRolePlay.Settings.Colours.FirstnamePvp.blue) .. UnitName(target) .. " " .. mrpHexEnd);
			end
		else
			return (mrpHexStart .. mduColourToHex(MyRolePlay.Settings.Colours.FirstnameNonPvp.red, MyRolePlay.Settings.Colours.FirstnameNonPvp.green, MyRolePlay.Settings.Colours.FirstnameNonPvp.blue) .. UnitName(target) .. " " .. mrpHexEnd);
		end
		return (MRP_TOOLTIP_EMPTY_STRING);
	end
	if (info == MRP_TOOLTIP_EYECOLOUR) then
		if (mrpTarget.Appearance.EyeColour ~= MRP_TOOLTIP_EMPTY_STRING) then
			return (MRP_LOCALE_Eye_Colour_TT .. mrpTarget.Appearance.EyeColour .. " ");
		end
	end
	if (info == MRP_TOOLTIP_HEIGHT) then
		if (mrpTarget.Appearance.Height ~= MRP_TOOLTIP_EMPTY_STRING) then
			return (MRP_LOCALE_Stands_TT .. mrpTarget.Appearance.Height .. " ");
		end
	end
	if (info == MRP_TOOLTIP_WEIGHT) then
		if (mrpTarget.Appearance.Weight ~= MRP_TOOLTIP_EMPTY_STRING) then
			return (MRP_LOCALE_Weighs_TT .. mrpTarget.Appearance.Weight .. " ");
		end
	end
	if (info == MRP_TOOLTIP_CURRENTEMOTION) then
		if (mrpTarget.Appearance.CurrentEmotion ~= MRP_TOOLTIP_EMPTY_STRING) then
			return (MRP_LOCALE_Current_Emotion_TT .. mrpTarget.Appearance.CurrentEmotion .. " ");
		end
	end
	if (info == MRP_TOOLTIP_HOMECITY) then
		if (mrpTarget.Lore.Homecity ~= MRP_TOOLTIP_EMPTY_STRING) then
			return (MRP_LOCALE_Home_TT .. mrpTarget.Lore.Homecity .. " ");
		end
	end
	if (info == MRP_TOOLTIP_BIRTHCITY) then
		if (mrpTarget.Lore.Birthcity ~= MRP_TOOLTIP_EMPTY_STRING) then
			return (MRP_LOCALE_Born_TT .. mrpTarget.Lore.Birthcity .. " ");
		end
	end
	if (info == MRP_TOOLTIP_AGE) then

	end
	if (info == MRP_TOOLTIP_BIRTHDATE) then

	end
	if (info == MRP_TOOLTIP_MOTTO) then
		if (mrpTarget.Lore.Motto ~= MRP_TOOLTIP_EMPTY_STRING) then
			return (MRP_LOCALE_Motto_TT .. mrpTarget.Lore.Motto .. " ");
		end
	end

	-- If it didn't find any of these options, make sure nothing is displayed in the column.
	return (MRP_TOOLTIP_EMPTY_STRING);
end


--[[
	function
	name: mrpResetLinse
	args: nil
	return: nil

	Description:
		This simple function resets each of the fontstrings in GameTooltip to nil and then hides them.
		This is done instead of ClearLines() because of some new issues with patch 1.10
]]

------------------------------------------------------------------------------------------------------------------
--					Tooltip Options Section                                                 --
------------------------------------------------------------------------------------------------------------------

function mrpTooltipEditorOnUpdate()

	FauxScrollFrame_Update(mrpTooltipScrollFrame, 30, 15, 16);

	local lineOffset = FauxScrollFrame_GetOffset(mrpTooltipScrollFrame);

	for line = 1, 30 do
		getglobal("mrpTooltipScrollFrameText" .. line):Hide();
		getglobal("mrpTooltipScrollFrameText" .. line):ClearAllPoints();
		if (line == 1) then
			getglobal("mrpTooltipScrollFrameText" .. line):SetPoint("TOPLEFT", "mrpTooltipScrollFrame", "TOPLEFT", 0, 17 * lineOffset);
		else
			getglobal("mrpTooltipScrollFrameText" .. line):SetPoint("TOPLEFT", getglobal("mrpTooltipScrollFrameText" .. (line - 1)), "BOTTOMLEFT", 0, -2);
		end
	end

	for line = 1, 15 do
		getglobal("mrpTooltipScrollFrameText" .. (line + lineOffset)):Show();
	end

	mrpPrevOffset = lineOffset;
end

function mrpTooltipEditorUpdate(orderName)
	for i = 1, table.maxn(MyRolePlay.Settings.Tooltip.Order[orderName]) do
		lineText = MRP_TOOLTIP_EMPTY_STRING;
		lineTextTwo = MRP_TOOLTIP_EMPTY_STRING;
		for j = 1, table.maxn(MyRolePlay.Settings.Tooltip.Order[orderName][i]) do
			if (MyRolePlay.Settings.Tooltip.Order[orderName][i][j] == MRP_TOOLTIP_NEWLINE) then
				lineTextTwo = MRP_TOOLTIP_NEWLINE_STRING;
			end
			for newlineCheck = 1, table.maxn(MRP_CONDITIONAL_NEWLINE) do
				if (type(MyRolePlay.Settings.Tooltip.Order[orderName][i][j]) == "table" and MyRolePlay.Settings.Tooltip.Order[orderName][i][j].Value ~= nil and MyRolePlay.Settings.Tooltip.Order[orderName][i][j].Value[1] == MRP_CONDITIONAL_NEWLINE[newlineCheck].Value[1]) then
					lineTextTwo = MRP_TOOLTIP_NEWLINE_STRING;
					break;
				end
			end
			for textCheck = 1, table.maxn(MyRolePlay.Settings.Tooltip.Order.MRP_TEXT) do
				if (type(MyRolePlay.Settings.Tooltip.Order[orderName][i][j]) == "table" and MyRolePlay.Settings.Tooltip.Order[orderName][i][j].Text == MyRolePlay.Settings.Tooltip.Order.MRP_TEXT[textCheck].Text) then
					lineTextTwo = MyRolePlay.Settings.Tooltip.Order.MRP_TEXT[textCheck].Text;
					break;
				end
			end
			if (MyRolePlay.Settings.Tooltip.Order[orderName][i][j] == MRP_TOOLTIP_PREFIX) then
				lineTextTwo = MRP_TOOLTIP_PREFIX_STRING;
			end
			if (MyRolePlay.Settings.Tooltip.Order[orderName][i][j] == MRP_TOOLTIP_FIRSTNAME) then
				lineTextTwo = MRP_TOOLTIP_FIRSTNAME_STRING;
			end
			if (MyRolePlay.Settings.Tooltip.Order[orderName][i][j] == MRP_TOOLTIP_MIDDLENAME) then
				lineTextTwo = MRP_TOOLTIP_MIDDLENAME_STRING;
			end
			if (MyRolePlay.Settings.Tooltip.Order[orderName][i][j] == MRP_TOOLTIP_SURNAME) then
				lineTextTwo = MRP_TOOLTIP_SURNAME_STRING;
			end
			if (MyRolePlay.Settings.Tooltip.Order[orderName][i][j] == MRP_TOOLTIP_TITLE) then
				lineTextTwo = MRP_TOOLTIP_TITLE_STRING;
			end
			if (MyRolePlay.Settings.Tooltip.Order[orderName][i][j] == MRP_TOOLTIP_HOUSENAME) then
				lineTextTwo = MRP_TOOLTIP_HOUSENAME_STRING;
			end
			if (MyRolePlay.Settings.Tooltip.Order[orderName][i][j] == MRP_TOOLTIP_NICKNAME) then
				lineTextTwo = MRP_TOOLTIP_NICKNAME_STRING;
			end
			if (MyRolePlay.Settings.Tooltip.Order[orderName][i][j] == MRP_TOOLTIP_GUILDRANK) then
				lineTextTwo = MRP_TOOLTIP_GUILDRANK_STRING;
			end
			if (MyRolePlay.Settings.Tooltip.Order[orderName][i][j] == MRP_TOOLTIP_GUILD) then
				lineTextTwo = MRP_TOOLTIP_GUILD_STRING;
			end
			if (MyRolePlay.Settings.Tooltip.Order[orderName][i][j] == MRP_TOOLTIP_PVPRANK) then
				lineTextTwo = MRP_TOOLTIP_PVPRANK_STRING;
			end
			if (MyRolePlay.Settings.Tooltip.Order[orderName][i][j] == MRP_TOOLTIP_PVPSTATUS) then
				lineTextTwo = MRP_TOOLTIP_PVPSTATUS_STRING;
			end
			if (MyRolePlay.Settings.Tooltip.Order[orderName][i][j] == MRP_TOOLTIP_LEVEL) then
				lineTextTwo = MRP_TOOLTIP_LEVEL_STRING;
			end
			if (MyRolePlay.Settings.Tooltip.Order[orderName][i][j] == MRP_TOOLTIP_CLASS) then
				lineTextTwo = MRP_TOOLTIP_CLASS_STRING;
			end
			if (MyRolePlay.Settings.Tooltip.Order[orderName][i][j] == MRP_TOOLTIP_RACE) then
				lineTextTwo = MRP_TOOLTIP_RACE_STRING;
			end
			if (MyRolePlay.Settings.Tooltip.Order[orderName][i][j] == MRP_TOOLTIP_RPSTYLE) then
				lineTextTwo = MRP_TOOLTIP_RPSTYLE_STRING;
			end
			if (MyRolePlay.Settings.Tooltip.Order[orderName][i][j] == MRP_TOOLTIP_CSSTATUS) then
				lineTextTwo = MRP_TOOLTIP_CSSTATUS_STRING;
			end
			if (MyRolePlay.Settings.Tooltip.Order[orderName][i][j] == MRP_TOOLTIP_UNITNAME) then
				lineTextTwo = MRP_TOOLTIP_UNITNAME_STRING;
			end
			if (MyRolePlay.Settings.Tooltip.Order[orderName][i][j] == MRP_TOOLTIP_EYECOLOUR) then
				lineTextTwo = MRP_TOOLTIP_EYECOLOUR_STRING;
			end
			if (MyRolePlay.Settings.Tooltip.Order[orderName][i][j] == MRP_TOOLTIP_HEIGHT) then
				lineTextTwo = MRP_TOOLTIP_HEIGHT_STRING;
			end
			if (MyRolePlay.Settings.Tooltip.Order[orderName][i][j] == MRP_TOOLTIP_WEIGHT) then
				lineTextTwo = MRP_TOOLTIP_WEIGHT_STRING;
			end
			if (MyRolePlay.Settings.Tooltip.Order[orderName][i][j] == MRP_TOOLTIP_CURRENTEMOTION) then
				lineTextTwo = MRP_TOOLTIP_CURRENTEMOTION_STRING;
			end
			if (MyRolePlay.Settings.Tooltip.Order[orderName][i][j] == MRP_TOOLTIP_HOMECITY) then
				lineTextTwo = MRP_TOOLTIP_HOMECITY_STRING;
			end
			if (MyRolePlay.Settings.Tooltip.Order[orderName][i][j] == MRP_TOOLTIP_BIRTHCITY) then
				lineTextTwo = MRP_TOOLTIP_BIRTHCITY_STRING;
			end
			if (MyRolePlay.Settings.Tooltip.Order[orderName][i][j] == MRP_TOOLTIP_AGE) then
				lineTextTwo = MRP_TOOLTIP_AGE_STRING;
			end
			if (MyRolePlay.Settings.Tooltip.Order[orderName][i][j] == MRP_TOOLTIP_BIRTHDATE) then
				lineTextTwo = MRP_TOOLTIP_BIRTHDATE_STRING;
			end
			if (MyRolePlay.Settings.Tooltip.Order[orderName][i][j] == MRP_TOOLTIP_MOTTO) then
				lineTextTwo = MRP_TOOLTIP_MOTTO_STRING;
			end

			lineText = lineText .. lineTextTwo;
		end
		getglobal("mrpTooltipScrollFrameText" .. i .. "String"):SetText(lineText);
	end
end

function mrpDisplayPreviewTooltip(orderName)
	for i = 1, table.maxn(MyRolePlay.Settings.Tooltip.Order[orderName]) do
		lineText = MRP_TOOLTIP_EMPTY_STRING;
		lineTextTwo = MRP_TOOLTIP_EMPTY_STRING;
		for j = 1, table.maxn(MyRolePlay.Settings.Tooltip.Order[orderName][i]) do
			if (MyRolePlay.Settings.Tooltip.Order[orderName][i][j] == MRP_TOOLTIP_NEWLINE) then
				lineTextTwo = MRP_TOOLTIP_NEWLINE_STRING;
			end
			for newlineCheck = 1, table.maxn(MRP_CONDITIONAL_NEWLINE) do
				if (type(MyRolePlay.Settings.Tooltip.Order[orderName][i][j]) == "table" and MyRolePlay.Settings.Tooltip.Order[orderName][i][j].Value ~= nil and MyRolePlay.Settings.Tooltip.Order[orderName][i][j].Value[1] == MRP_CONDITIONAL_NEWLINE[newlineCheck].Value[1]) then
					lineTextTwo = MRP_TOOLTIP_NEWLINE_STRING;
					break;
				end
			end
			for textCheck = 1, table.maxn(MyRolePlay.Settings.Tooltip.Order.MRP_TEXT) do
				if (type(MyRolePlay.Settings.Tooltip.Order[orderName][i][j]) == "table" and MyRolePlay.Settings.Tooltip.Order[orderName][i][j].Text == MyRolePlay.Settings.Tooltip.Order.MRP_TEXT[textCheck].Text) then
					lineTextTwo = MyRolePlay.Settings.Tooltip.Order.MRP_TEXT[textCheck].Text;
					break;
				end
			end
			if (MyRolePlay.Settings.Tooltip.Order[orderName][i][j] == MRP_TOOLTIP_PREFIX) then
				lineTextTwo = MRP_TOOLTIP_PREFIX_STRING;
			end
			if (MyRolePlay.Settings.Tooltip.Order[orderName][i][j] == MRP_TOOLTIP_FIRSTNAME) then
				lineTextTwo = MRP_TOOLTIP_FIRSTNAME_STRING;
			end
			if (MyRolePlay.Settings.Tooltip.Order[orderName][i][j] == MRP_TOOLTIP_MIDDLENAME) then
				lineTextTwo = MRP_TOOLTIP_MIDDLENAME_STRING;
			end
			if (MyRolePlay.Settings.Tooltip.Order[orderName][i][j] == MRP_TOOLTIP_SURNAME) then
				lineTextTwo = MRP_TOOLTIP_SURNAME_STRING;
			end
			if (MyRolePlay.Settings.Tooltip.Order[orderName][i][j] == MRP_TOOLTIP_TITLE) then
				lineTextTwo = MRP_TOOLTIP_TITLE_STRING;
			end
			if (MyRolePlay.Settings.Tooltip.Order[orderName][i][j] == MRP_TOOLTIP_HOUSENAME) then
				lineTextTwo = MRP_TOOLTIP_HOUSENAME_STRING;
			end
			if (MyRolePlay.Settings.Tooltip.Order[orderName][i][j] == MRP_TOOLTIP_NICKNAME) then
				lineTextTwo = MRP_TOOLTIP_NICKNAME_STRING;
			end
			if (MyRolePlay.Settings.Tooltip.Order[orderName][i][j] == MRP_TOOLTIP_GUILDRANK) then
				lineTextTwo = MRP_TOOLTIP_GUILDRANK_STRING;
			end
			if (MyRolePlay.Settings.Tooltip.Order[orderName][i][j] == MRP_TOOLTIP_GUILD) then
				lineTextTwo = MRP_TOOLTIP_GUILD_STRING;
			end
			if (MyRolePlay.Settings.Tooltip.Order[orderName][i][j] == MRP_TOOLTIP_PVPRANK) then
				lineTextTwo = MRP_TOOLTIP_PVPRANK_STRING;
			end
			if (MyRolePlay.Settings.Tooltip.Order[orderName][i][j] == MRP_TOOLTIP_PVPSTATUS) then
				lineTextTwo = MRP_TOOLTIP_PVPSTATUS_STRING;
			end
			if (MyRolePlay.Settings.Tooltip.Order[orderName][i][j] == MRP_TOOLTIP_LEVEL) then
				lineTextTwo = MRP_TOOLTIP_LEVEL_STRING;
			end
			if (MyRolePlay.Settings.Tooltip.Order[orderName][i][j] == MRP_TOOLTIP_CLASS) then
				lineTextTwo = MRP_TOOLTIP_CLASS_STRING;
			end
			if (MyRolePlay.Settings.Tooltip.Order[orderName][i][j] == MRP_TOOLTIP_RACE) then
				lineTextTwo = MRP_TOOLTIP_RACE_STRING;
			end
			if (MyRolePlay.Settings.Tooltip.Order[orderName][i][j] == MRP_TOOLTIP_RPSTYLE) then
				lineTextTwo = MRP_TOOLTIP_RPSTYLE_STRING;
			end
			if (MyRolePlay.Settings.Tooltip.Order[orderName][i][j] == MRP_TOOLTIP_CSSTATUS) then
				lineTextTwo = MRP_TOOLTIP_CSSTATUS_STRING;
			end
			if (MyRolePlay.Settings.Tooltip.Order[orderName][i][j] == MRP_TOOLTIP_UNITNAME) then
				lineTextTwo = MRP_TOOLTIP_UNITNAME_STRING;
			end
			if (MyRolePlay.Settings.Tooltip.Order[orderName][i][j] == MRP_TOOLTIP_EYECOLOUR) then
				lineTextTwo = MRP_TOOLTIP_EYECOLOUR_STRING;
			end
			if (MyRolePlay.Settings.Tooltip.Order[orderName][i][j] == MRP_TOOLTIP_HEIGHT) then
				lineTextTwo = MRP_TOOLTIP_HEIGHT_STRING;
			end
			if (MyRolePlay.Settings.Tooltip.Order[orderName][i][j] == MRP_TOOLTIP_WEIGHT) then
				lineTextTwo = MRP_TOOLTIP_WEIGHT_STRING;
			end
			if (MyRolePlay.Settings.Tooltip.Order[orderName][i][j] == MRP_TOOLTIP_CURRENTEMOTION) then
				lineTextTwo = MRP_TOOLTIP_CURRENTEMOTION_STRING;
			end
			if (MyRolePlay.Settings.Tooltip.Order[orderName][i][j] == MRP_TOOLTIP_HOMECITY) then
				lineTextTwo = MRP_TOOLTIP_HOMECITY_STRING;
			end
			if (MyRolePlay.Settings.Tooltip.Order[orderName][i][j] == MRP_TOOLTIP_BIRTHCITY) then
				lineTextTwo = MRP_TOOLTIP_BIRTHCITY_STRING;
			end
			if (MyRolePlay.Settings.Tooltip.Order[orderName][i][j] == MRP_TOOLTIP_AGE) then
				lineTextTwo = MRP_TOOLTIP_AGE_STRING;
			end
			if (MyRolePlay.Settings.Tooltip.Order[orderName][i][j] == MRP_TOOLTIP_BIRTHDATE) then
				lineTextTwo = MRP_TOOLTIP_BIRTHDATE_STRING;
			end
			if (MyRolePlay.Settings.Tooltip.Order[orderName][i][j] == MRP_TOOLTIP_MOTTO) then
				lineTextTwo = MRP_TOOLTIP_MOTTO_STRING;
			end

			lineText = lineText .. lineTextTwo;
		end
		GameTooltip:AddLine(lineText);
	end
	GameTooltip:Show();
end

function mrpEditTooltipOrder(row)
	mrpCurrentRowBeingEdited = row
	mrpTooltipOrderBuilderWhichRowString:SetText(MRP_LOCALE_Editing_Row_1_TT .. row .. MRP_LOCALE_Editing_Row_2_TT);
	mrpTooltipOrderBuilderEditBox:Show();
	mrpTooltipOrderBuilderSaveButton:Show();
	mrpTooltipOrderBuilderCreateRegularTooltipButton:Hide();
	mrpTooltipOrderBuilderSaveConditionalNewlineButton:Hide();
	mrpTooltipOrderBuilderConditionalNewlineTypeCheckButtonBefore:Hide();
	mrpTooltipOrderBuilderEditBox:SetText("");
	mrpTooltipOrderBuilder:Show();

	for i = 1, table.maxn(MyRolePlay.Settings.Tooltip.Order.MRP[row]) do
		local mrpNewlineExists = false;
		local mrpTextExists = false;

		if (i == 1) then
			for newlineCheck = 1, table.maxn(MRP_CONDITIONAL_NEWLINE) do
				if (type(MyRolePlay.Settings.Tooltip.Order["MRP"][row][i]) == "table" and MyRolePlay.Settings.Tooltip.Order["MRP"][row][i].Value ~= nil and MyRolePlay.Settings.Tooltip.Order["MRP"][row][i].Value[1] == MRP_CONDITIONAL_NEWLINE[newlineCheck].Value[1]) then
					mrpTooltipOrderBuilderEditBox:Hide();
					mrpTooltipOrderBuilderSaveButton:Hide();
					mrpTooltipOrderBuilderCreateRegularTooltipButton:Show();
					mrpTooltipOrderBuilderSaveConditionalNewlineButton:Show();
					mrpTooltipOrderBuilderConditionalNewlineTypeCheckButtonBefore:Show();
					mrpTooltipOrderBuilderWhichRowString:SetText(MRP_LOCALE_Editing_Row_1_TT .. row .. MRP_LOCALE_Editing_Row_2_TT .. "\nThis is a conditional newline.");
					mrpNewlineExists = true;
				end
			end
			for textCheck = 1, table.maxn(MyRolePlay.Settings.Tooltip.Order.MRP_TEXT) do
				if (type(MyRolePlay.Settings.Tooltip.Order["MRP"][row][i]) == "table" and MyRolePlay.Settings.Tooltip.Order["MRP"][row][i].Text == MyRolePlay.Settings.Tooltip.Order.MRP_TEXT[textCheck].Text) then
					mrpTooltipOrderBuilderEditBox:SetText("\"" .. MyRolePlay.Settings.Tooltip.Order.MRP_TEXT[textCheck].Text .. "\"");
					mrpTextExists = true;
				end
			end
			if (mrpNewlineExists ~= true and mrpTextExists ~= true) then
				mrpTooltipOrderBuilderEditBox:SetText(mrpConvertNumberToText(MyRolePlay.Settings.Tooltip.Order.MRP[row][i]));
			end
		else
			for newlineCheck = 1, table.maxn(MRP_CONDITIONAL_NEWLINE) do
				if (MyRolePlay.Settings.Tooltip.Order.MRP[row][i] == MRP_CONDITIONAL_NEWLINE[newlineCheck]) then
					mrpTooltipOrderBuilderEditBox:SetText(mrpTooltipOrderBuilderEditBox:GetText() .. " " .. "Conditional Newline, press new conditional newline to change the properties of this newline.");
					mrpNewlineExists = true;
				end
			end
			for textCheck = 1, table.maxn(MyRolePlay.Settings.Tooltip.Order.MRP_TEXT) do
				if (MyRolePlay.Settings.Tooltip.Order.MRP[row][i] == MyRolePlay.Settings.Tooltip.Order.MRP_TEXT[textCheck]) then
					mrpTooltipOrderBuilderEditBox:SetText(mrpTooltipOrderBuilderEditBox:GetText() .. " \"" .. MyRolePlay.Settings.Tooltip.Order.MRP_TEXT[textCheck].Text .. "\"");
					mrpTextExists = true;
				end
			end
			if (mrpNewlineExists ~= true and mrpTextExists ~= true) then
				mrpTooltipOrderBuilderEditBox:SetText(mrpTooltipOrderBuilderEditBox:GetText() .. " " .. mrpConvertNumberToText(MyRolePlay.Settings.Tooltip.Order.MRP[row][i]));
			end
		end
	end
end

function mrpConvertToString(stringToEdit)
	stringToEdit = string.gsub(stringToEdit, "\"", "\\\"");

	return (stringToEdit);
end

function mrpConvertFromString(stringToEdit)
	stringToEdit = string.gsub(stringToEdit, "\\\"", "\"");

	return (stringToEdit);
end

function mrpSaveTooltipOrder(row)
	local numOfNewCols = 1;
	local cols = {};
	local boxString = mrpTooltipOrderBuilderEditBox:GetText();
	local userTextEnabled = false;
	local curText = "";
	local backslashFlag = false;

	for i = 1, string.len(boxString) do
		local char = string.sub(boxString, i, i);

		if (userTextEnabled == false) then
			if (char == "\"") then
				curText = "";
				userTextEnabled = true;

				for textCheck, text in ipairs(MyRolePlay.Settings.Tooltip.Order.MRP_TEXT) do
					if (MyRolePlay.Settings.Tooltip.Order.MRP[row][i] == text) then
						table.remove(MyRolePlay.Settings.Tooltip.Order.MRP_TEXT, textCheck);
					end
				end

				local tempTable = {};
				tempTable.Text = "";
				tempTable.BoA = MRP_TOOLTIP_TEXT_AFTER;
				tempTable.Colours = MyRolePlay.Settings.Colours.Nickname;

				table.insert(MyRolePlay.Settings.Tooltip.Order.MRP_TEXT, tempTable);

			elseif (char == " ") then
				cols[numOfNewCols] = mrpConvertTextToNumber(curText);
				numOfNewCols = numOfNewCols + 1;
				curText = "";
				table.setn(cols, numOfNewCols);
			else
				if (i == string.len(boxString)) then
					curText = curText .. char;
					cols[numOfNewCols] = mrpConvertTextToNumber(curText);
					curText = "";
				else
					curText = curText .. char;
				end
			end
		else
			if (char == "\\" and backslashFlag == false) then
				backslashFlag = true;
			elseif (char == "\\" and backslashFlag == true) then
				MyRolePlay.Settings.Tooltip.Order.MRP_TEXT[table.maxn(MyRolePlay.Settings.Tooltip.Order.MRP_TEXT)].Text = MyRolePlay.Settings.Tooltip.Order.MRP_TEXT[table.maxn(MyRolePlay.Settings.Tooltip.Order.MRP_TEXT)].Text .. char;
				backslashFlag = false;
			elseif (char == "\"" and backslashFlag == true) then
				MyRolePlay.Settings.Tooltip.Order.MRP_TEXT[table.maxn(MyRolePlay.Settings.Tooltip.Order.MRP_TEXT)].Text = MyRolePlay.Settings.Tooltip.Order.MRP_TEXT[table.maxn(MyRolePlay.Settings.Tooltip.Order.MRP_TEXT)].Text .. char;
				backslashFlag = false;
			elseif (char == "\"" and backslashFlag == false) then
				userTextEnabled = false;

				if (i ~= string.len(boxString)) then
					cols[numOfNewCols] = MyRolePlay.Settings.Tooltip.Order.MRP_TEXT[table.maxn(MyRolePlay.Settings.Tooltip.Order.MRP_TEXT)];
					numOfNewCols = numOfNewCols + 1;
					curText = "";
					table.setn(cols, numOfNewCols);
					i = i + 1;
				else
					cols[numOfNewCols] = MyRolePlay.Settings.Tooltip.Order.MRP_TEXT[table.maxn(MyRolePlay.Settings.Tooltip.Order.MRP_TEXT)];
				end
				mrpDisplayMessage(numOfNewCols);
			else
				backslashFlag = false;
				MyRolePlay.Settings.Tooltip.Order.MRP_TEXT[table.maxn(MyRolePlay.Settings.Tooltip.Order.MRP_TEXT)].Text = MyRolePlay.Settings.Tooltip.Order.MRP_TEXT[table.maxn(MyRolePlay.Settings.Tooltip.Order.MRP_TEXT)].Text .. char;
			end
		end
	end

	if (boxString == "") then
		cols[numOfNewCols] = mrpConvertTextToNumber(MRP_LOCALE_ELEMENT_EMPTY);
	end

	MyRolePlay.Settings.Tooltip.Order.MRP[row] = nil;
	MyRolePlay.Settings.Tooltip.Order.MRP[row] = {};
	table.setn(MyRolePlay.Settings.Tooltip.Order.MRP[row], 0);

	for i = 1, numOfNewCols do
		table.setn(MyRolePlay.Settings.Tooltip.Order.MRP[row], table.maxn(MyRolePlay.Settings.Tooltip.Order.MRP[row]) + 1);
		MyRolePlay.Settings.Tooltip.Order.MRP[row][i] = cols[i];
	end

	for i = row - 1, 1, -1 do
		if (MyRolePlay.Settings.Tooltip.Order.MRP[i][1] == MRP_TOOLTIP_EMPTY) then
			MyRolePlay.Settings.Tooltip.Order.MRP[i] = {};

			local values = {};
			for j = 1, table.maxn(MyRolePlay.Settings.Tooltip.Order.MRP[row]) do
				values[j] = MyRolePlay.Settings.Tooltip.Order.MRP[row][j];
			end
			MyRolePlay.Settings.Tooltip.Order.MRP[i][1] = mrpCreateNewCONDITIONAL_NEWLINE(row - i, values, 1);
		end
	end

	mrpTooltipEditorUpdate("MRP")

	mrpTooltipOrderBuilder:Hide();
end

function mrpConvertTextToNumber(text)
	if (text == MRP_LOCALE_ELEMENT_EMPTY) then
		return (tonumber(MRP_TOOLTIP_EMPTY));
	elseif (text == MRP_LOCALE_ELEMENT_NEWLINE) then
		return (tonumber(MRP_TOOLTIP_NEWLINE));
	elseif (text == MRP_LOCALE_ELEMENT_PREFIX) then
		return (tonumber(MRP_TOOLTIP_PREFIX));
	elseif (text == MRP_LOCALE_ELEMENT_FIRSTNAME) then
		return (tonumber(MRP_TOOLTIP_FIRSTNAME));
	elseif (text == MRP_LOCALE_ELEMENT_MIDDLENAME) then
		return (tonumber(MRP_TOOLTIP_MIDDLENAME));
	elseif (text == MRP_LOCALE_ELEMENT_SURNAME) then
		return (tonumber(MRP_TOOLTIP_SURNAME));
	elseif (text == MRP_LOCALE_ELEMENT_TITLE) then
		return (tonumber(MRP_TOOLTIP_TITLE));
	elseif (text == MRP_LOCALE_ELEMENT_HOUSENAME) then
		return (tonumber(MRP_TOOLTIP_HOUSENAME));
	elseif (text == MRP_LOCALE_ELEMENT_NICKNAME) then
		return (tonumber(MRP_TOOLTIP_NICKNAME));
	elseif (text == MRP_LOCALE_ELEMENT_GUILDRANK) then
		return (tonumber(MRP_TOOLTIP_GUILDRANK));
	elseif (text == MRP_LOCALE_ELEMENT_PVPRANK) then
		return (tonumber(MRP_TOOLTIP_PVPRANK));
	elseif (text == MRP_LOCALE_ELEMENT_PVPSTATUS) then
		return (tonumber(MRP_TOOLTIP_PVPSTATUS));
	elseif (text == MRP_LOCALE_ELEMENT_LEVEL) then
		return (tonumber(MRP_TOOLTIP_LEVEL));
	elseif (text == MRP_LOCALE_ELEMENT_CLASS) then
		return (tonumber(MRP_TOOLTIP_CLASS));
	elseif (text == MRP_LOCALE_ELEMENT_RACE) then
		return (tonumber(MRP_TOOLTIP_RACE));
	elseif (text == MRP_LOCALE_ELEMENT_RPSTYLE) then
		return (tonumber(MRP_TOOLTIP_RPSTYLE));
	elseif (text == MRP_LOCALE_ELEMENT_CSTATUS) then
		return (tonumber(MRP_TOOLTIP_CSSTATUS));
	elseif (text == MRP_LOCALE_ELEMENT_UNITNAME) then
		return (tonumber(MRP_TOOLTIP_UNITNAME));
	elseif (text == MRP_LOCALE_ELEMENT_EYECOLOUR) then
		return (tonumber(MRP_TOOLTIP_EYECOLOUR));
	elseif (text == MRP_LOCALE_ELEMENT_HEIGHT) then
		return (tonumber(MRP_TOOLTIP_HEIGHT));
	elseif (text == MRP_LOCALE_ELEMENT_WEIGHT) then
		return (tonumber(MRP_TOOLTIP_WEIGHT));
	elseif (text == MRP_LOCALE_ELEMENT_CURRENTEMOTION) then
		return (tonumber(MRP_TOOLTIP_CURRENTEMOTION));
	elseif (text == MRP_LOCALE_ELEMENT_HOME) then
		return (tonumber(MRP_TOOLTIP_HOMECITY));
	elseif (text == MRP_LOCALE_ELEMENT_BIRTHPLACE) then
		return (tonumber(MRP_TOOLTIP_BIRTHCITY));
	elseif (text == MRP_LOCALE_ELEMENT_AGE) then-- doesn't work yet
		return (tonumber(MRP_TOOLTIP_AGE)); -- doesn't work yet
	elseif (text == MRP_LOCALE_ELEMENT_BIRTHDATE) then-- doesn't work yet
		return (tonumber(MRP_TOOLTIP_BIRTHDATE));-- doesn't work yet
	elseif (text == MRP_LOCALE_ELEMENT_MOTTO) then
		return (tonumber(MRP_TOOLTIP_MOTTO));
	elseif (text == MRP_LOCALE_ELEMENT_GUILDNAME) then
		return (tonumber(MRP_TOOLTIP_GUILD));
	end

	return (tonumber(MRP_TOOLTIP_EMPTY));
end

function mrpConvertNumberToText(number)
	if (number == MRP_TOOLTIP_EMPTY) then
		return (MRP_LOCALE_ELEMENT_EMPTY);
	elseif (number == MRP_TOOLTIP_NEWLINE) then
		return (MRP_LOCALE_ELEMENT_NEWLINE);
	elseif (number == MRP_TOOLTIP_PREFIX) then
		return (MRP_LOCALE_ELEMENT_PREFIX);
	elseif (number == MRP_TOOLTIP_FIRSTNAME) then
		return (MRP_LOCALE_ELEMENT_FIRSTNAME);
	elseif (number == MRP_TOOLTIP_MIDDLENAME) then
		return (MRP_LOCALE_ELEMENT_MIDDLENAME);
	elseif (number == MRP_TOOLTIP_SURNAME) then
		return (MRP_LOCALE_ELEMENT_SURNAME);
	elseif (number == MRP_TOOLTIP_TITLE) then
		return (MRP_LOCALE_ELEMENT_TITLE);
	elseif (number == MRP_TOOLTIP_HOUSENAME) then
		return (MRP_LOCALE_ELEMENT_HOUSENAME);
	elseif (number == MRP_TOOLTIP_NICKNAME) then
		return (MRP_LOCALE_ELEMENT_NICKNAME);
	elseif (number == MRP_TOOLTIP_GUILDRANK) then
		return (MRP_LOCALE_ELEMENT_GUILDRANK);
	elseif (number == MRP_TOOLTIP_PVPRANK) then
		return (MRP_LOCALE_ELEMENT_PVPRANK);
	elseif (number == MRP_TOOLTIP_PVPSTATUS) then
		return (MRP_LOCALE_ELEMENT_PVPSTATUS);
	elseif (number == MRP_TOOLTIP_LEVEL) then
		return (MRP_LOCALE_ELEMENT_LEVEL);
	elseif (number == MRP_TOOLTIP_CLASS) then
		return (MRP_LOCALE_ELEMENT_CLASS);
	elseif (number == MRP_TOOLTIP_RACE) then
		return (MRP_LOCALE_ELEMENT_RACE);
	elseif (number == MRP_TOOLTIP_RPSTYLE) then
		return (MRP_LOCALE_ELEMENT_RPSTYLE);
	elseif (number == MRP_TOOLTIP_CSSTATUS) then
		return (MRP_LOCALE_ELEMENT_CSTATUS);
	elseif (number == MRP_TOOLTIP_UNITNAME) then
		return (MRP_LOCALE_ELEMENT_UNITNAME);
	elseif (number == MRP_TOOLTIP_EYECOLOUR) then
		return (MRP_LOCALE_ELEMENT_EYECOLOUR);
	elseif (number == MRP_TOOLTIP_HEIGHT) then
		return (MRP_LOCALE_ELEMENT_HEIGHT);
	elseif (number == MRP_TOOLTIP_WEIGHT) then
		return (MRP_LOCALE_ELEMENT_WEIGHT);
	elseif (number == MRP_TOOLTIP_CURRENTEMOTION) then
		return (MRP_LOCALE_ELEMENT_CURRENTEMOTION);
	elseif (number == MRP_TOOLTIP_HOMECITY) then
		return (MRP_LOCALE_ELEMENT_HOME);
	elseif (number == MRP_TOOLTIP_BIRTHCITY) then
		return (MRP_LOCALE_ELEMENT_BIRTHPLACE);
	elseif (number == MRP_TOOLTIP_AGE) then-- doesn't work yet
		return (MRP_LOCALE_ELEMENT_AGE); -- doesn't work yet
	elseif (number == MRP_TOOLTIP_BIRTHDATE) then-- doesn't work yet
		return (MRP_LOCALE_ELEMENT_BIRTHDATE);-- doesn't work yet
	elseif (number == MRP_TOOLTIP_MOTTO) then
		return (MRP_LOCALE_ELEMENT_MOTTO);
	elseif (number == MRP_TOOLTIP_GUILD) then
		return (MRP_LOCALE_ELEMENT_GUILDNAME);
	end
end

function mrpGetTooltipInfo(orderName, row, column)
	local temp = mdbSearchData("MyRolePlayTooltip", mdbCreateTablePacket(nil, "Orders"), mdbCreateColumnPacket("table"), mdbCreateSearchPacket("name", "=", orderName));

	return temp[1][1][row][column];
end

function mrpGetNumTooltipColumns(orderName, row)
	local temp = mdbSearchData("MyRolePlayTooltip", mdbCreateTablePacket(nil, "Orders"), mdbCreateColumnPacket("table"), mdbCreateSearchPacket("name", "=", orderName));

	if (temp[1][1][row]) then
		return table.maxn(temp[1][1][row]);
	end

	return 0;
end

function mrpGetNumTooltipRows(orderName)
	local temp = mdbSearchData("MyRolePlayTooltip", mdbCreateTablePacket(nil, "Orders"), mdbCreateColumnPacket("table"), mdbCreateSearchPacket("name", "=", orderName));

	return table.maxn(temp[1][1]);
end

function mrpEditRowTooltipOrder(orderName, row, ...)
	local tempTable = mdbSearchData("MyRolePlayTooltip", mdbCreateTablePacket(nil, "Orders"), mdbCreateColumnPacket("table"), mdbCreateSearchPacket("name", "=", orderName));
	local temp = tempTable[1][1];

	if (not temp[row]) then
		table.insert(temp, row, {});
	end

	temp[row] = {};

	for i = 1, select("#", ...) do
		temp[row][i] = select(i, ...);
	end

	mdbEditData("MyRolePlayTooltip", "Orders", "table", temp, mdbCreateSearchPacket("name", "=", orderName));
end

function mrpCreateNewCONDITIONAL_NEWLINE(distance, Type, ...)
	local temp = {};

	temp.Values = {};

	for i = 1, select("#", ...) do
		local value = select(i, ...);

		table.insert(temp.Values, i, value);
	end

	temp.distance = distance;
	temp.Type = Type;

	return temp;
end

function mrpCreateNewTooltipText(text, boA, colour)
	local temp = {};

	temp.text = text;
	temp.boA = boA;
	temp.Colours = colour;

	return temp;
end

function mrpCreateNewTooltipOrder(orderName)
	mdbInsertData("MyRolePlayTooltip", "Orders", mrpGetNumTooltipOrders() + 1, orderName, {{MRP_TOOLTIP_EMPTY}});
end

function mrpCreateDefaultTooltip()
	mrpCreateNewTooltipOrder("default");

	mrpEditRowTooltipOrder("default", 1, MRP_TOOLTIP_PREFIX, MRP_TOOLTIP_FIRSTNAME, MRP_TOOLTIP_MIDDLENAME, MRP_TOOLTIP_SURNAME);
	mrpEditRowTooltipOrder("default", 2, mrpCreateNewTooltipText(MRP_LOCALE_TOOLTIP_DEFAULT_HOUSE, MRP_TOOLTIP_TEXT_AFTER, MyRolePlay.Settings.Colours.HouseName), MRP_TOOLTIP_HOUSENAME);
	mrpEditRowTooltipOrder("default", 3, MRP_TOOLTIP_TITLE);
	mrpEditRowTooltipOrder("default", 4, mrpCreateNewCONDITIONAL_NEWLINE(2, 0, MRP_TOOLTIP_TITLE, MRP_TOOLTIP_HOUSENAME));
	mrpEditRowTooltipOrder("default", 5, mrpCreateNewTooltipText(MRP_LOCALE_TOOLTIP_DEFAULT_NICKNAME, MRP_TOOLTIP_TEXT_AFTER, MyRolePlay.Settings.Colours.Nickname), MRP_TOOLTIP_NICKNAME);
	mrpEditRowTooltipOrder("default", 6, MRP_TOOLTIP_GUILDRANK, mrpCreateNewTooltipText(MRP_LOCALE_TOOLTIP_DEFAULT_GUILD, MRP_TOOLTIP_TEXT_AFTER, MyRolePlay.Settings.Colours.Guild), MRP_TOOLTIP_GUILD);
	mrpEditRowTooltipOrder("default", 7, MRP_TOOLTIP_PVPRANK);
	mrpEditRowTooltipOrder("default", 8, mrpCreateNewCONDITIONAL_NEWLINE(3, 0, MRP_TOOLTIP_GUILDRANK, MRP_TOOLTIP_NICKNAME, MRP_TOOLTIP_PVPRANK));
	mrpEditRowTooltipOrder("default", 9, MRP_TOOLTIP_RPSTYLE);
	mrpEditRowTooltipOrder("default", 10, mrpCreateNewTooltipText(MRP_LOCALE_TOOLTIP_DEFAULT_CHARSTATUS, MRP_TOOLTIP_TEXT_AFTER, MyRolePlay.Settings.Colours.CharacterText), MRP_TOOLTIP_CSSTATUS);
	mrpEditRowTooltipOrder("default", 11, mrpCreateNewCONDITIONAL_NEWLINE(2, 0, MRP_TOOLTIP_RPSTYLE, MRP_TOOLTIP_CSSTATUS));
	mrpEditRowTooltipOrder("default", 12, mrpCreateNewTooltipText(MRP_LOCALE_TOOLTIP_DEFAULT_LEVELKNOWN, MRP_TOOLTIP_TEXT_ALWAYS, MyRolePlay.Settings.Colours.Level), MRP_TOOLTIP_LEVEL, MRP_TOOLTIP_RACE, MRP_TOOLTIP_CLASS);
	mrpEditRowTooltipOrder("default", 13, MRP_TOOLTIP_PVPSTATUS);
end

MRP_TOOLTIP_EMPTY = 0;
MRP_TOOLTIP_NEWLINE = 3;
MRP_TOOLTIP_PREFIX = 4;
MRP_TOOLTIP_FIRSTNAME = 5;
MRP_TOOLTIP_MIDDLENAME = 6;
MRP_TOOLTIP_SURNAME = 7;
MRP_TOOLTIP_TITLE = 8;
MRP_TOOLTIP_HOUSENAME = 9;
MRP_TOOLTIP_NICKNAME = 10;
MRP_TOOLTIP_GUILDRANK = 11;
MRP_TOOLTIP_PVPRANK = 12;
MRP_TOOLTIP_PVPSTATUS = 13;
MRP_TOOLTIP_LEVEL = 14;
MRP_TOOLTIP_CLASS = 15;
MRP_TOOLTIP_RACE = 16;
MRP_TOOLTIP_RPSTYLE = 17;
MRP_TOOLTIP_CSSTATUS = 18;
MRP_TOOLTIP_UNITNAME = 19;
MRP_TOOLTIP_EYECOLOUR = 20;
MRP_TOOLTIP_HEIGHT = 21;
MRP_TOOLTIP_WEIGHT = 22;
MRP_TOOLTIP_CURRENTEMOTION = 23;
MRP_TOOLTIP_HOMECITY = 24;
MRP_TOOLTIP_BIRTHCITY = 25;
MRP_TOOLTIP_AGE = 26;
MRP_TOOLTIP_BIRTHDATE = 27;
MRP_TOOLTIP_MOTTO = 28;
MRP_TOOLTIP_GUILD = 29;

MRP_TOOLTIP_TEXT_BEFORE = 0;
MRP_TOOLTIP_TEXT_AFTER = 1;
MRP_TOOLTIP_TEXT_ALWAYS = 2;
MRP_TOOLTIP_TEXT_BOTH = 3;
