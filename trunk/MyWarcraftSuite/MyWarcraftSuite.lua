
mttVar = false;
MWS_TEST = nil;
MWS_NAME = nil;
mttTestVar = false;
MSW_FOUND = false;
mswee = "name";
function mwsTooltipTest()
	mttDisplayTooltip(mwsTestTooltip);
end

function mwsTextFunction()
	local h = "Mouse Focus!";
	local t = "No Frame!";
	mttTestVar = false;
	if (MWS_TEST == nil or MWS_TEST:GetName() ~= nil) then
		mduDisplayMessage("test")
		mwsTest();
		mduDisplayMessage(mswee);
	elseif (MSW_FOUND == false) then
		mttSetTooltipOwner(mwsTestTooltip, MWS_TEST);
		mttSetTooltipAnchor(mwsTestTooltip, MTT_ANCHOR_TOP);
		mduDisplayMessage(mswee);
		mttTestVar = true;
		MSW_FOUND = true;
	end
	if mttTestVar == true then
		mduDisplayMessage(mswee);
	end
	if (MWS_TEST ~= nil) then
		h = mduCreateString(mswee, .2, .5, .6);
		t = mduCreateString("Told ya its possible :)", 255, 0, 100);
	end

	return h, t;
end

function mwsLoad()
	mwsTestTooltip = mttCreateTooltip("Name", MTT_TYPE_POPUP, mwsTextFunction, MTT_ANCHOR_CURSOR);
	mttVar = true;
	mduRegisterEvent("UPDATE_MOUSEOVER_UNIT", mwsTooltipTest);
end

mduRegisterEvent("VARIABLES_LOADED", mwsLoad);

function mwsTest()
	local frame = EnumerateFrames("WorldFrame");

	while frame do
		if (frame:IsVisible() and MouseIsOver(frame) and frame:GetName() == nil) then
			MWS_TEST = frame;
			frame = EnumerateFrames(frame);
			MSW_NAME = select(5, frame:GetParent():GetRegions()):GetText() .. "test";
			mswee = MSW_NAME;
			break;
		end

		frame = EnumerateFrames(frame);
	end
end

---------------------------------------------------------------------------------------------------
-- Official Examples
---------------------------------------------------------------------------------------------------

--[[
MyTooltip Examples

MyTooltip allows you to create tooltips, from a simple 'popup' tooltip, to advanced 'custom' tooltips.

MTT (MyTooltip) does not modify, hook, or otherwise interfere with the default GameTooltip in any way.
It also does not create it's own tooltips, it uses the default GameTooltip to add/edit/get information.

When you create a MTT tooltip, you use the mttCreateTooltip function, and you can give your tooltip these features.

Name - the 'name' of your tooltip. This is mostly not useful in most situations. You do NOT use this name to
		edit/remove/display your tooltip.

Type - This is the tooltip type, which is required. The type will define what happens and what information is given
		to you when you display your tooltip. The possible types are defined below:

			MTT_TYPE_POPUP - This tooltip is only used to show a 'popup' to the user, like an information box.
						A popup can have a header and a body. Therefore, in your tooltip function (explained later),
						you need to return a header and can choose to return a body.
			MTT_TYPE_UNIT - This tooltip should generally be used for displaying information about a unit. (ie, a player, target, etc...))
						MTT will provide your tooltip function with various information that you choose about the unit.
						You will then return a custom table that contains the information about how to display the tooltip
						through MTT's grid layout.
			MTT_TYPE_UNIT_ADVANCED - This tooltip should ONLY be used if you want ALL the information about the unit (literally).
								This could cause lag on lower end systems.
			MTT_TYPE_ITEM - This tooltip should generally be used for displaying information about an item.
						TODO: What will we do here?
			MTT_TYPE_SPELL - This tooltip should generally be used for displaying information about a spell or ability.
						TODO: What will we do here?
			MTT_TYPE_CUSTOM - This is the most powerful of the tooltip types. You can register this type of tooltip to whatever information you want.
						You will then return a custom grid layout table from your tooltip funtion for MTT to display.

Tooltip Function - This function will get called every time your tooltip gets displayed.
				Depending on the tooltip type, certain values will be passed to your function.
				Also depending on the tooltip type, you must return a certain format of values back to MTT.

Anchor - This is where the tooltip will be anchored relative to it's owner (explained later).
		MTT gives you many more options for anchors, and makes your life much easier for anchoring.
		Here is the list of anchors available for you to use:

		MTT_ANCHOR_DEFAULT - WoW's default tooltip location, the bottom right of the WorldFrame, with the correct offsets. (NOTE, you do not need to specify an owner if you use this)
		MTT_ANCHOR_NONE - Should not be used, but here for completeness. Could be used to temporarily make your tootlip invisible.
		MTT_ANCHOR_TOP - Your tooltip will be displayed ontop of the owner.
		MTT_ANCHOR_TOPINSIDE - Your tooltip will be displayed on the inside of the top of the owner (the top of the tooltip is anchored to the top of the owner)
		MTT_ANCHOR_TOPRIGHT - The top right (outside) of the owner
		MTT_ANCHOR_TOPRIGHTINSIDE - The top right (inside) of the owner.
		MTT_ANCHOR_RIGHT - The right (outside) of the owner.
		MTT_ANCHOR_RIGHTINSIDE - The right (inside).
		MTT_ANCHOR_BOTTOMRIGHT - Bottom right (outside).
		MTT_ANCHOR_BOTTOMRIGHTINSIDE - Bottom right (inside).
		MTT_ANCHOR_BOTTOM - Bottom (outside).
		MTT_ANCHOR_BOTTOMINSIDE - Bottom (inside).
		MTT_ANCHOR_BOTTOMLEFT - Bottom left (outside).
		MTT_ANCHOR_BOTTOMLEFTINSIDE - Buttom left (inside).
		MTT_ANCHOR_LEFT - Left (ouside).
		MTT_ANCHOR_LEFTINSIDE - Left (inside).
		MTT_ANCHOR_TOPLEFT - Top left (outside).
		MTT_ANCHOR_TOPLEFTINSIDE - Top left (inside).
		MTT_ANCHOR_CURSOR - Your tooltip will follow your mouses' cursor (on top of it). (Same as MTT_ANCHOR_MOUSE).
		MTT_ANCHOR_MOUSE - Your tooltip will follow your mouses' cursor (on top of it). (Same as MTT_ANCHOR_CURSOR).
		MTT_ANCHOR_PRESERVE - ==FIXME== I 'think' this remembers the last anchor for GameTooltip and uses it. Not sure though.
		MTT_ANCHOR_CENTER - Your tooltip will be displayed in the center of the owner.

Owner - The 'owner' of the tooltip. If the owner is hidden, so will your tooltip, your anchor will be relative to this value.
		It's value is either a direct link to a frame, or a pointer (from getglobal) to the frame. Therefore, you can use UIParent or "UIParent".

X Offset - How many pixels the anchor will be offsetted along the X axis (right, or if a negative number, left).

Y Offset - How many pixels the anchor will be offsetted along the Y axis (up, or if a negative number, down).


When you create a tooltip using mttCreateTooltip, MTT will return the ID of your tooltip to you. You MUST keep this ID in order to do
anything with your tooltip.
]]

-- Simple function creating all the different types of tooltips.
function mwsMttCreateTooltips()
	-- This is a popup tooltip. Note that I am making the variable mwsMttPopupTooltip equals the ID of the new tooltip.
	-- When I want to edit this tooltip or display it later, I will use this variable.
	-- This tooltip doesn't need an owner or offsets because its anchor is the WoW Default (bottom right of the screen).
	mwsMttPopupTooltip = mttCreateTooltip("ExamplePopupTooltip", MTT_TYPE_POPUP, mwsMttPopupExampleFunction, MTT_ANCHOR_DEFAULT);

	-- This is a unit tooltip. It will be displayed ontop of the DEFAULT_CHAT_FRAME.
	-- Every time this tooltip is called, the function mwsMttUnitExampleFunction will be called, and several values will be passed
	-- to it. Check out the mwsMttUnitExampleFunction below to see what is passed and how you might use this information.
	mwsMttUnitTooltip = mttCreateTooltip("ExampleUnitTooltip", MTT_TYPE_UNIT, mwsMttUnitExampleFunction, MTT_ANCHOR_TOP, DEFAULT_CHAT_FRAME);
end

function mwsMttPopupExampleFunction()
	local h = "MyTooltip Popup Header!";
	local t = "Aren't popup tooltips neat and easy?";

	-- To make things more interesting (this is NOT necessary), I'm using MyDevUtilities' mduCreateString function.
	-- It simply provides me an easy way to add colour to a string. Notice that you can use values of 0 - 1 or 0 - 255.
	h = mduCreateString(h, .2, .5, .6);
	t = mduCreateString(t, 255, 0, 100);

	return h, t;
end

function mwsMttUnitExampleFunction(unitId, unitName, unitRace, unitLevel, unitGuildName, unitGuildRank, unitClassification, unitHealth, unitHealthMax, unitIsPVP, unitIsPVPFreeForAll, unitMana, unitManaMax, unitPVPName)

end

function mwsMttUnitAdvancedExampleFunction(unitId, unitName, unitRace, unitLevel, unitSex, unitGuildName, unitGuildRank, interactDistance, spellCanTargetUnit, unitAffectingCombat, unitCanAssistOrAttackYou, youCanAssistOrAttackUnit, unitCanCooperate, unitClassification, unitCreatureFamily, unitCreatureType, unitFactionGroup, unitHealth, unitHealthMax, unitIsCivilian, unitIsFriendOrEnemy, unitIsPVP, unitIsPlayer, unitIsTapped, unitMana, unitManaMax, unitPlayerControlled, unitInPartyOrRaid, unitPVPName, unitPVPRank, unitPowerType, unitReactionToYou)

end