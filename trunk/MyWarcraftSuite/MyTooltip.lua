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
MTT_TYPE_ITEM = 2;
MTT_TYPE_SPELL = 3;
MTT_TYPE_CUSTOM = 4;


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
function mttCreateTooltip(name, tooltipType, tooltipFunction, owner, anchor, xOff, yOff)
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

function mttCallTooltipFunction(id, arg1, arg2, arg3, arg4, arg5, arg6, arg7 ,arg8, arg9, arg10, arg11, arg12, arg13, arg14, arg15, arg16, arg17, arg18, arg19, arg20)
	local index = mduGetIndexOfId(mttTooltips, id);
	local data = mttTooltips[index].tooltipFunction(arg1, arg2, arg3, arg4, arg5, arg6, arg7 ,arg8, arg9, arg10, arg11, arg12, arg13, arg14, arg15, arg16, arg17, arg18, arg19, arg20);

	return data;
end

--------------------------------------------------

function mttGetTooltipInfo(orderName, row, column)
	local temp = mdbSearchData("MyRolePlayTooltip", mdbCreateTablePacket(nil, "Orders"), mdbCreateColumnPacket("table"), mdbCreateSearchPacket("name", "=", orderName));

	return temp[1][1][row][column];
end

function mttGetNumTooltipColumns(orderName, row)
	local temp = mdbSearchData("MyRolePlayTooltip", mdbCreateTablePacket(nil, "Orders"), mdbCreateColumnPacket("table"), mdbCreateSearchPacket("name", "=", orderName));

	if (temp[1][1][row]) then
		return table.maxn(temp[1][1][row]);
	end

	return 0;
end

function mttGetNumTooltipRows(orderName)
	local temp = mdbSearchData("MyRolePlayTooltip", mdbCreateTablePacket(nil, "Orders"), mdbCreateColumnPacket("table"), mdbCreateSearchPacket("name", "=", orderName));

	return table.maxn(temp[1][1]);
end

function mttEditRowTooltipOrder(orderName, row, ...)
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

function mttCreateNewCONDITIONAL_NEWLINE(distance, Type, ...)
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

function mttCreateNewTooltipText(text, boA, colour)
	local temp = {};

	temp.text = text;
	temp.boA = boA;
	temp.Colours = colour;

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
arg1 = "test text";
	local data = mttCallTooltipFunction(id, arg1, arg2, arg3, arg4, arg5, arg6, arg7 ,arg8, arg9, arg10, arg11, arg12, arg13, arg14, arg15, arg16, arg17, arg18, arg19, arg20);

	GameTooltip:SetText(data);
	GameTooltip:AddLine(data);
	GameTooltip:AddLine(data);

	GameTooltip:Show();
end



--[[
MTT DEFAULT FUNCTIONS
]]

function mttTextFunction(text)
	return text;
end










