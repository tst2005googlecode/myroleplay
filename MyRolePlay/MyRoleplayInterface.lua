-- Binding Variables

BINDING_HEADER_RPSWITCH = "MyRolePlayInterface";
BINDING_NAME_RPSWITCH = "Toggle on / off";

-- End of Binding Variables

-- Start Setting

	-- MyRolePlayInterface Initialize

function mrpiOnLoad()

    mrpiStandardUI = true;

	if (mrpSettingFieldExists("MyRolePlay Interface") == false) then
		mrpAddSettingField("MyRolePlay Interface");
	end

	if (mrpCheckSettings("MyRolePlay Interface", "Fade Time") == MDB_NIL) then
		mrpAddSetting("MyRolePlay Interface", "Fade Time", 2);
	end

	if (mrpCheckSettings("MyRolePlay Interface", "Hide List") == MDB_NIL) then
		mrpAddSetting("MyRolePlay Interface", "Hide List", {});
	end

	if (mrpCheckSettings("MyRolePlay Interface", "Fade List") == MDB_NIL) then
		mrpAddSetting("MyRolePlay Interface", "Fade List", {});
	end

	if (mrpCheckSettings("MyRolePlay Interface", "Switch List") == MDB_NIL) then
		mrpAddSetting("MyRolePlay Interface", "Switch List", {});
	end

	if (mrpCheckSettings("MyRolePlay Interface", "Fade Disp Delay") == MDB_NIL) then
		mrpAddSetting("MyRolePlay Interface", "Fade Disp Delay", 0.3);

	MPRIFadeDisplayTime = mrpCheckSettings("MyRolePlay Interface", "Fade Time") + MRPIFadeDisplayTimeDelay;
end

	-- End of MyRolePlayInterface Initialize

	-- Slashcommands

SLASH_MYROLEPLAYINTERFACE1 = "/mrpi";

function mrpiSlashCommandList(args)
	local slashCommand, slashValue, slashValue2 = string.match(args, "(%a+)%s*([%w*%.?]*)%s*([%w*%.?]*)");

		if (slashCommand and string.lower(slashCommand) == "help") then
			mrpDisplayMessage(MRPI_LOCALE_TOGGLE);
			mrpDisplayMessage(MRPI_LOCALE_SETFADETIME);
			mrpDisplayMessage(MRPI_LOCALE_ADDFADE);
			mrpDisplayMessage(MRPI_LOCALE_EDITFADE);
			mrpDisplayMessage(MRPI_LOCALE_REMOVEFADE);
			mrpDisplayMessage(MRPI_LOCALE_ADDHIDE);
			mrpDisplayMessage(MRPI_LOCALE_REMOVEHIDE);
			mrpDisplayMessage(MRPI_LOCALE_ADDSWITCH);
			mrpDisplayMessage(MRPI_LOCALE_REMOVESWITCH);

		elseif (slashCommand and string.lower(slashCommand) == "toggle") then
			mrpiToggle();

		elseif (slashCommand and string.lower(slashCommand) == "setfadetime") then
			mrpiFadeTime = mduConvertStringToDecimal(slashValue);

		elseif (slashCommand and string.lower(slashCommand) == "addframetohide") then
			mrpiAddNewHideFrame(slashValue);

		elseif (slashCommand and string.lower(slashCommand) == "removeframetohide") then
			mrpiRemoveHideFrame(slashValue);

		elseif (slashCommand and string.lower(slashCommand) == "addframetofade") then
			mrpiAddNewFadeFrame(slashValue, mduConvertStringToDecimal(slashValue2));

		elseif (slashCommand and string.lower(slashCommand) == "editframetofade") then
			mrpiEditFadeFrame(slashValue, mduConvertStringToDecimal(slashValue2));

		elseif (slashCommand and string.lower(slashCommand) == "removefadeframe") then
			mrpiRemoveFadeFrame(slashValue);

		elseif (slashCommand and string.lower(slashCommand) == "addswitchframe") then
			mrpiAddSwitchFrame(slashValue);

		elseif (slashCommand and string.lower(slashCommand) == "removeswitchframe") then
			mrpiRemoveSwitchFrame(slashValue);

		else
			mrpDisplayMessage(MRPI_LOCALE_UNKNOWNCOMMAND)
		end
end

SlashCmdList["MYROLEPLAYINTERFACE"] = mrpiSlashCommandList;

	-- End of Slashcommands

-- End of Start Setting

-- Functions

	-- MyRolePlayInterface Toggle Function

function mrpiToggle()
	if (mrpiStandardUI == true) then

        	-- MyRolePlayInterface Toggle On Funtion

		for i = 1, table.maxn(mrpCheckSettings("MyRolePlay Interface", "Fade List")) do
			UIFrameFadeOut(getglobal(mrpCheckSettings("MyRolePlay Interface", "Fade List")[i].frameName), mrpCheckSettings("MyRolePlay Interface", "Fade Time"), 1, mrpCheckSettings("MyRolePlay Interface", "Fade List")[i].fadeOpacity);
		end

		for i = 1, table.maxn(mrpCheckSettings("MyRolePlay Interface", "Hide List")) do
			getglobal(mrpCheckSettings("MyRolePlay Interface", "Hide List")[i].frameName):Hide();
		end

		for i = 1, table.maxn(mrpCheckSettings("MyRolePlay Interface", "Switch List")) do
			mrpCheckSettings("MyRolePlay Interface", "Switch List")[i].frameName:SetParent(MRPIParent);
		end

		mrpiOnDispTimer = mtiCreateNewTimer(1, 2.5, mrpiOnDisp, 0, 3);

		mtiStartTimer(mrpiOnDispTimer);

		-- End of MyRolePlayInterface Toggle On Funtion

		mrpiStandardUI = false;
	elseif (mrpiStandardUI == false) then

        -- MyRolePlayInterface Toggle Off Funtion

        	for i = 1, table.maxn(mrpCheckSettings("MyRolePlay Interface", "Fade List")) do
			UIFrameFadeIn(getglobal(mrpCheckSettings("MyRolePlay Interface", "Fade List")[i].frameName), mrpCheckSettings("MyRolePlay Interface", "Fade Time"), mrpCheckSettings("MyRolePlay Interface", "Fade List")[i].fadeOpacity, 1);
		end

		for i = 1, table.maxn(mrpCheckSettings("MyRolePlay Interface", "Hide List")) do
			getglobal(mrpCheckSettings("MyRolePlay Interface", "Hide List")[i].frameName):Show();
		end

		for i = 1, table.maxn(mrpCheckSettings("MyRolePlay Interface", "Switch List")) do
			getglobal(mrpCheckSettings("MyRolePlay Interface", "Switch List")[i].frameName):SetParent(getglobal(mrpCheckSettings("MyRolePlay Interface", "Switch List")[i].parent));
		end

		mrpiOffDispTimer = mtiCreateNewTimer(1, 2.5, mrpiOffDisp, 0, 3);

		mtiStartTimer(mrpiOffDispTimer);

		mrpiStandardUI = true;

	end

end

		-- End of MyRolePlayInterface Toggle Off Funtion

	-- End of MyRolePlayInterface Toggle Function

	-- Display Functions

function mrpiOnDisp()

	mrpDisplayMessage(MRPI_LOCALE_TOGGLEON);
end

function mrpiOffDisp()

	mrpDisplayMessage(MRPI_LOCALE_TOGGLEOFF);
end

	-- End of Display Functions

	-- Frame Fade Table Functions

function mrpiAddNewFadeFrame(frameName, fadeOpacity)
	local temp = mrpCheckSettings("MyRolePlay Interface", "Fade List");
	local newSize = table.maxn(temp) + 1;

	for i = 1, table.maxn(temp) do
		if (temp[i].frameName == frameName) then
			return;
		end
	end

	table.insert(temp, newSize, {});
	temp[newSize].frameName = frameName;
	temp[newSize].fadeOpacity = fadeOpacity;

	mrpChangeSettings("MyRolePlay Interface", "Fade List", temp);
end


function mrpiEditFadeFrame(frameName, newOpacity)
	local temp = mrpCheckSettings("MyRolePlay Interface", "Fade List");

	for i = 1, table.maxn(temp) do
		if (temp[i].frameName == frameName) then
		    temp[i].fadeOpacity = newOpacity;

			mrpChangeSettings("MyRolePlay Interface", "Fade List", temp);
			return;
		end
	end
end


function mrpiRemoveFadeFrame(frameName)
	local temp = mrpCheckSettings("MyRolePlay Interface", "Fade List");

	for i, value in ipairs(temp) do
		if (value.frameName == frameName) then
			table.remove(temp, i);

			mrpChangeSettings("MyRolePlay Interface", "Fade List", temp);
			return;
		end
	end
end

	-- End of Frame Fade Table Functions

	-- Frame Hide Table Functions

function mrpiAddNewHideFrame(frameName)
	local temp = mrpCheckSettings("MyRolePlay Interface", "Hide List");

	for i = 1, table.maxn(temp) do
		if (temp[i].frameName == frameName) then
			return;
		end
	end

	local newSize = table.maxn(temp) + 1;

	table.insert(temp, newSize, {});
	temp[newSize].frameName = frameName;

	mrpChangeSettings("MyRolePlay Interface", "Hide List", temp);
end

function mrpiRemoveHideFrame(frameName)
	local temp = mrpCheckSettings("MyRolePlay Interface", "Hide List");

	for i, value in ipairs(temp) do
		if (value.frameName == frameName) then
			table.remove(temp, i);

			mrpChangeSettings("MyRolePlay Interface", "Hide List", temp);
			return;
		end
	end
end

	-- End of Frame Hide Table Functions

	-- Switch Ownership Table Functions

function mrpiAddSwitchFrame(frameName)
    local temp = mrpCheckSettings("MyRolePlay Interface", "Switch List");

	for i = 1, table.maxn(temp) do
		if (temp[i].frameName == frameName) then
		mrpDisplayMessage("Please check your input and repeat.");
		return;
		end
	end

	local newSize = table.maxn(temp) + 1;

	table.insert(temp, newSize {});
	temp[newSize].frameName = frameName;
	temp[newSize].parent = GetParent(frameName);

	mrpChangeSettings("MyRolePlay Interface", "Switch List", temp);
end

function mrpiRemoveSwitchFrame(frameName)
	local temp = mrpCheckSettings("MyRolePlay Interface", "Switch List");

	for i, value in ipairs(temp) do
		if (value.frameName == frameName) then
			table.remove(temp, i);

			mrpChangeSettings("MyRolePlay Interface", "Switch List", temp);
			return;
		end
	end
end

	-- End of Switch Ownership Table Functions

-- End of Functions

-- Checkboxes

	-- Hide Default Buff Frame
if MRPIBuffFrameHide == true then

	if MPRIStandardBuffFrameHide == true then

		mrpiAddNewHideFrame(BuffFrame);
		mrpiAddNewHideFrame(TemporaryEnchantFrame);
	end
end

	-- End of Hide Default Buff Frame

	-- Hide Minimap (not optimal)

if MPRIMiniMapHide == true then

	ToggleMinimap();

end

	-- End of Hide Minimap

	-- Keep ChatFrame1

if MRPISwitchChatFrame1 == true then

	mrpiAddSwitchFrame(ChatFrame1);
	mrpiAddSwitchFrame(ChatMenuButton);

end

	-- End of Keep ChatFrame1

	-- Keep ChatFrame2

if MRPISwitchChatFrame2 == true then

	mrpiAddSwitchFrame(ChatFrame2);

end

   -- End of Keep ChatFrame2

   -- Keep ChatFrame3

if MRPISwitchChatFrame3 == true then

	mrpiAddSwitchFrame(ChatFrame3);

end

	-- End of Keep ChatFrame3

	-- Keep ChatFrame4

if MRPISwitchChatFrame4 == true then

	mrpiAddSwitchFrame(ChatFrame4);

end

	-- End of Keep ChatFrame4

-- End of Checkboxes
