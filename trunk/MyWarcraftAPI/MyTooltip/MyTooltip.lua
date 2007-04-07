
mttTooltips = {};
mttIdMax = 0;

MTT_ANCHOR_DEFAULT = 0;
MTT_ANCHOR_NONE = 1;
MTT_ANCHOR_TOP = 2;
MTT_ANCHOR_TOPINSIDE = 3;
MTT_ANCHOR_TOPRIGHT = 4;
MTT_ANCHOR_TOPRIGHTINSIDE = 5;
MTT_ANCHOR_RIGHT = 6;
MTT_ANCHOR_RIGHTINSIDE = 7;
MTT_ANCHOR_BOTTOMRIGHT = 8;
MTT_ANCHOR_BOTTOMRIGHTINSIDE = 9;
MTT_ANCHOR_BOTTOM = 10;
MTT_ANCHOR_BOTTOMINSIDE = 11;
MTT_ANCHOR_BOTTOMLEFT = 12;
MTT_ANCHOR_BOTTOMLEFTINSIDE = 13;
MTT_ANCHOR_LEFT = 14;
MTT_ANCHOR_LEFTINSIDE = 15;
MTT_ANCHOR_TOPLEFT = 16;
MTT_ANCHOR_TOPLEFTINSIDE = 17;
MTT_ANCHOR_CURSOR = 18;
MTT_ANCHOR_MOUSE = 18;
MTT_ANCHOR_PRESERVE = 19;
MTT_ANCHOR_CENTER = 20;

MTT_TYPE_POPUP = 0;
MTT_TYPE_UNIT = 1;
MTT_TYPE_UNIT_ADVANCED = 2;
MTT_TYPE_ITEM = 3;
MTT_TYPE_SPELL = 4;
MTT_TYPE_CUSTOM = 5;

MTT_CONDITIONAL_NEWLINE_TYPE_UP = 0;
MTT_CONDITIONAL_NEWLINE_TYPE_DOWN = 1;

MTT_NEWLINE = " ";
MTT_NIL = string.char(2) .. "nil" .. string.char(3);;


local function mttDisplayMessage(msg)
	mduDisplayMessage(msg, "MyTooltip", 0, .2, 1);
end

local function mttGetNumTooltips()
	return table.maxn(mttTooltips);
end

local function mttGenerateNewId()
	mttIdMax = mttIdMax + 1;

	return mttIdMax;
end

local function mttConvertAnchor(value)
	local anchor, relative = "", "";

	if (value == MTT_ANCHOR_NONE) then
		anchor = "ANCHOR_NONE";
	elseif (value == MTT_ANCHOR_CURSOR) then
		anchor = "ANCHOR_CURSOR";
	elseif (value == MTT_ANCHOR_MOUSE) then
		anchor = "ANCHOR_CURSOR";
	elseif (value == MTT_ANCHOR_PRESERVE) then
		anchor = "ANCHOR_PRESERVE";
	elseif (value == MTT_ANCHOR_TOP) then
		anchor, relative = "BOTTOM", "TOP";
	elseif (value == MTT_ANCHOR_TOPINSIDE) then
		anchor, relative = "TOP", "TOP";
	elseif (value == MTT_ANCHOR_TOPRIGHT) then
		anchor, relative = "BOTTOMLEFT", "TOPRIGHT";
	elseif (value == MTT_ANCHOR_TOPRIGHTINSIDE) then
		anchor, relative = "TOPRIGHT", "TOPRIGHT";
	elseif (value == MTT_ANCHOR_RIGHT) then
		anchor, relative = "LEFT", "RIGHT";
	elseif (value == MTT_ANCHOR_RIGHTINSIDE) then
		anchor, relative = "RIGHT", "RIGHT";
	elseif (value == MTT_ANCHOR_BOTTOMRIGHT) then
		anchor, relative = "TOPLEFT", "BOTTOMRIGHT";
	elseif (value == MTT_ANCHOR_BOTTOMRIGHTINSIDE) then
		anchor, relative = "BOTTOMRIGHT", "BOTTOMRIGHT";
	elseif (value == MTT_ANCHOR_BOTTOM) then
		anchor, relative = "TOP", "BOTTOM";
	elseif (value == MTT_ANCHOR_BOTTOMINSIDE) then
		anchor, relative = "BOTTOM", "BOTTOM";
	elseif (value == MTT_ANCHOR_BOTTOMLEFT) then
		anchor, relative = "TOPRIGHT", "BOTTOMLEFT";
	elseif (value == MTT_ANCHOR_BOTTOMLEFTINSIDE) then
		anchor, relative = "BOTTOMLEFT", "BOTTOMLEFT";
	elseif (value == MTT_ANCHOR_LEFT) then
		anchor, relative = "RIGHT", "LEFT";
	elseif (value == MTT_ANCHOR_LEFTINSIDE) then
		anchor, relative = "LEFT", "LEFT";
	elseif (value == MTT_ANCHOR_TOPLEFT) then
		anchor, relative = "BOTTOMRIGHT", "TOPLEFT";
	elseif (value == MTT_ANCHOR_TOPLEFTINSIDE) then
		anchor, relative = "TOPLEFT", "TOPLEFT";
	elseif (value == MTT_ANCHOR_CENTER) then
		anchor, relative = "CENTER", "CENTER";
	end

	if (relative == "") then
		return anchor;
	end

	return anchor, relative;
end


--[[
tooltipTypes:
Popup = Will only display a simple message with a header.
Unit = A specific unit.
Item = An item tooltip
Spell = A spell tootlip
Custom = Full table style control.

anchorTypes:
none = nothing
top = to the top of the owner.
topinside
topright
toprightinside
right
rightinside
bottomright
bottomrightinside
bottom
bottominside
bottomleft
bottomleftinside
left
leftinside
topleft
topleftinside
cursor/mouse
preserve? --FIXME what is this?
default = the default game tooltip location.

]]
function mttCreateTooltip(name, tooltipType, tooltipFunction, anchor, owner, xOff, yOff, ...)
	local temp = mttGetNumTooltips() + 1;

	table.insert(mttTooltips, temp, {});
	mttTooltips[temp].id = mttGenerateNewId();
	mttTooltips[temp].name = name;
	mttTooltips[temp].type = tooltipType;
	mttTooltips[temp].tooltipFunction = tooltipFunction;

	if (not owner or owner == nil) then
		owner = UIParent;
	end

	if (type(owner) == "string") then
		mttTooltips[temp].owner = getglobal(owner);
	else
		mttTooltips[temp].owner = owner;
	end

	if (not anchor or anchor == nil) then
		anchor = MTT_ANCHOR_BOTTOMRIGHTINSIDE;
	end

	if (not xOff or xOff == nil) then
		if (anchor == MTT_ANCHOR_DEFAULT) then
			xOff = "default";
		else
			xOff = 0;
		end
	end

	if (not yOff or yOff == nil) then
		if (anchor == MTT_ANCHOR_DEFAULT) then
			yOff = "default";
		else
			yOff = 0;
		end
	end

	mttTooltips[temp].anchor = anchor;
	mttTooltips[temp].xOff = xOff;
	mttTooltips[temp].yOff = yOff;

	table.insert(mttTooltips[temp], 1, {});
	table.insert(mttTooltips[temp][1], 1, {});
	mttTooltips[temp].numOfRows = 1;

	return mttTooltips[temp].id;
end

function mttDeleteTooltip(id)
	local index = mduGetIndexOfId(mttTooltips, id);
	table.remove(mttTooltips, index);
end

function mttSetTooltipType(id, newType)
	local index = mduGetIndexOfId(mttTooltips, id);
	mttTooltips[index].type = string.upper(newType);
end

function mttSetTooltipFunction(id, newfunction)
	local index = mduGetIndexOfId(mttTooltips, id);
	mttTooltips[index].tooltipFunction = newfunction;
end

function mttSetTooltipOwner(id, newOwner)
	local index = mduGetIndexOfId(mttTooltips, id);

	if (type(owner) == "string") then
		mttTooltips[index].owner = getglobal(newOwner);
	else
		mttTooltips[index].owner = newOwner;
	end
end

function mttSetTooltipAnchor(id, newAnchor)
	local index = mduGetIndexOfId(mttTooltips, id);
	mttTooltips[index].anchor = newAnchor;
end

function mttSetTooltipXYOffset(id, newX, newY)
	local index = mduGetIndexOfId(mttTooltips, id);
	mttTooltips[index].xOff = newX;
	mttTooltips[index].yOff = newY;
end

function mttGetTooltipOwner(id)
	local index = mduGetIndexOfId(mttTooltips, id);
	return (mttTooltips[index].owner);
end

function mttGetTooltipAnchor(id)
	local index = mduGetIndexOfId(mttTooltips, id);
	return (mttTooltips[index].anchor);
end

function mttGetTooltipOffsetX(id)
	local index = mduGetIndexOfId(mttTooltips, id);
	return (mttTooltips[index].xOff);
end

function mttGetTooltipOffsetY(id)
	local index = mduGetIndexOfId(mttTooltips, id);
	return (mttTooltips[index].yOff);
end

function mttGetTooltipType(id)
	local index = mduGetIndexOfId(mttTooltips, id);
	return (mttTooltips[index].type);
end

function mttGetTooltipName(id)
	local index = mduGetIndexOfId(mttTooltips, id);
	return (mttTooltips[index].name);
end

function mttCallTooltipFunction(id, arg1, arg2, arg3, arg4, arg5, arg6, arg7 ,arg8, arg9, arg10, arg11, arg12, arg13, arg14, arg15, arg16, arg17, arg18, arg19, arg20)
	local index = mduGetIndexOfId(mttTooltips, id);

	return mttTooltips[index].tooltipFunction(arg1, arg2, arg3, arg4, arg5, arg6, arg7 ,arg8, arg9, arg10, arg11, arg12, arg13, arg14, arg15, arg16, arg17, arg18, arg19, arg20);
end

--------------------------------------------------

function mttGetTooltipGridCell(id, row, column)
	local index = mduGetIndexOfId(mttTooltips, id);

	return mttTooltips[index][row][column];
end

function mttGetTooltipGridRow(id, row)
	local index = mduGetIndexOfId(mttTooltips, id);

	return mttTooltips[index][row];
end

function mttGetTooltipGrid(id)
	local index = mduGetIndexOfId(mttTooltips, id);
	local temp = {};

	for (i = 1, mttGetNumTooltipRows(id)) do
		table.insert(temp, i, mttTooltips[index][i]);
	end

	return temp;
end

function mttGetNumTooltipColumns(id, row)
	local index = mduGetIndexOfId(mttTooltips, id);

	if (mttTooltips[index][row]) then
		return table.maxn(mttTooltips[index][row]);
	end

	return 0;
end

function mttGetNumTooltipRows(id)
	local index = mduGetIndexOfId(mttTooltips, id);

	return mttTooltips[index].numOfRows);
end

function mttEditRowTooltipOrder(id, row, ...)
	local index = mduGetIndexOfId(mttTooltips, id);

	if (not mttTooltips[index][row]) then
		table.insert(mttTooltips[index], row, {});
		mttTooltips[index].numOfRows = mttTooltips[index].numOfRows + 1;
	end

	mttTooltips[index][row] = {};

	for i = 1, select("#", ...) do
		mttTooltips[index][row][i] = select(i, ...);
	end
end

function mttCreateConditionalNewline(distance, uoD, ...)
	local temp = {};

	temp.values = {};

	for i = 1, select("#", ...) do
		local value = select(i, ...);

		table.insert(temp.values, i, value);
	end

	temp.distance = distance;
	temp.uoD = uoD;

	return temp;
end

function mttCreateTooltipText(text, boA)
	local temp = {};

	temp.text = text;
	temp.boA = boA;

	return temp;
end



function mttDisplayTooltip(id)
	local anchor = mttGetTooltipAnchor(id);

	if (anchor == MTT_ANCHOR_DEFAULT) then
		GameTooltip:SetOwner(mttGetTooltipOwner(id), "ANCHOR_NONE");
		GameTooltip:SetPoint("BOTTOMRIGHT", "UIParent", "BOTTOMRIGHT", -CONTAINER_OFFSET_X - 13, CONTAINER_OFFSET_Y);
	else
		if (anchor ~= MTT_ANCHOR_NONE and anchor ~= MTT_ANCHOR_CURSOR and anchor ~= MTT_ANCHOR_MOUSE and anchor ~= MTT_ANCHOR_PRESERVE) then
			local point, relative = mttConvertAnchor(anchor);
			GameTooltip:SetOwner(mttGetTooltipOwner(id), "ANCHOR_NONE");
			GameTooltip:SetPoint(point, mttGetTooltipOwner(id), relative, mttGetTooltipOffsetX(id), mttGetTooltipOffsetY(id));
		else
			local finalAnchor = mttConvertAnchor(anchor);
			GameTooltip:SetOwner(mttGetTooltipOwner(id), finalAnchor, mttGetTooltipOffsetX(id), mttGetTooltipOffsetY(id));
		end
	end

	local tooltipType = mttGetTooltipType(id);

	if (tooltipType == MTT_TYPE_POPUP) then
		mttSetupPopup(id);
	elseif (tooltipType == MTT_TYPE_UNIT) then
		mttSetupUnit(id)
	elseif (tooltipType == MTT_TYPE_UNIT_ADVANCED) then
		mttSetupUnitAdvanced(id)
	elseif (tooltipType == MTT_TYPE_ITEM) then
		mttSetupItem(id)
	elseif (tooltipType == MTT_TYPE_SPELL) then
		mttSetupSpell(id)
	elseif (tooltipType == MTT_TYPE_CUSTOM) then
		mttSetupCustom(id)
	end

	GameTooltip:Show();
end

function mttGetNumGridRows(grid)
	return table.maxn(grid);
end

function mttGetNumGridColumns(grid, row)
	if (grid[row]) then
		return table.maxn(grid[row]);
	end

	return 0;
end

function mttAssessGrid(grid, i, j)
	local info = grid[i][j];

	-- This for loop handles the conditional newline. This means that it will only add a new line IF its condition is met.
	-- This is explained at the top of this lua file.
	if (type(info) == "table" and info.values and info.values ~= nil) then
		for (curDistance = 1, info.distance) do
			if (info.uoD == MTT_CONDITIONAL_NEWLINE_TYPE_UP) then
				for (column = 1, mttGetNumGridColumns(grid, i - curDistance)) do
					for curValue = 1, table.maxn(info.values) do
						if (info.values[curValue] == grid[i - curDistance][column]) and mrpAssessTooltipInfo(orderName, i - curDistance, column, target) ~= MRP_TOOLTIP_EMPTY_STRING) then
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
end

--[[
MTT SETUP FUNCTIONS
]]

function mttSetupPopup(id)
	local header, text = mttCallTooltipFunction(id);

	GameTooltip:SetText(header);

	if (text ~= nil) then
		GameTooltip:AddLine(text);
	end
end

function mttSetupUnit(id)
	local grid = mttCallTooltipFunction(id);

	local numOfLines = 0;
	local curLine = 1;

	for i = 1, mttGetNumTooltipRows(grid) do
		mrpTempString = "";

		for j = 1, mttGetNumGridColumns(grid, i) do
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

	for (i = curline + 1, numOfLines) do
		getglobal("GameTooltipTextLeft" .. i):SetText(nil);
	end
end

function mttSetupUnitAdvanced(id)

end

function mttSetupItem(id)

end

function mttSetupSpell(id)

end

function mttSetupCustom(id)

end

