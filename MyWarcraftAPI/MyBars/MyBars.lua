--[[
Library file for bars. weee!
]]

MyBarsBarList = {};

MYBARS_START_LEFT = 0;
MYBARS_START_RIGHT = 1;
MYBARS_START_CENTER = 2;

MYBARS_TYPE_TIMER = 0;
MYBARS_TYPE_STATUS = 1;

MYBARS_TIMETYPE_STANDARD = 0;
MYBARS_TIMETYPE_SECONDS = 1;
MYBARS_TIMETYPE_MINUTES = 2;
MYBARS_TIMETYPE_HOURS = 3;

MYBARS_STATE_PENDING = 0;
MYBARS_STATE_RUNNING = 1;
MYBARS_STATE_PAUSED = 2;

function mbsCreateNewBar(leftValue, rightValue, type, startType, timeType)
	if (not startType) then
		startType = MYBARS_START_LEFT;
	end

	if (not timeType) then
		timeType = MYBARS_TIMETYPE_STANDARD;
	end

	local index = table.maxn(MyBarsBarList) + 1;

	local bar = {};
	bar.frame = CreateFrame("Frame", "MyBarsBar" .. index, UIParent, "MyBarsTemplate");
	bar.type = type;
	bar.timeType = timeType;
	bar.state = MYBARS_STATE_PENDING;

	getglobal(bar.frame:GetName() .. "StatusBar"):SetMinMaxValues(leftValue, rightValue);

	table.insert(MyBarsBarList, index, bar);

	return index;
end

function mbsGetBarLeftValue(id)
	local left, right = getglobal(MyBarsBarList[id].frame:GetName() .. "StatusBar"):GetMinMaxValues();

	return left;
end

function mbsGetBarRightValue(id)
	local left, right = getglobal(MyBarsBarList[id].frame:GetName() .. "StatusBar"):GetMinMaxValues();

	return right;
end

function mbsGetBarValue(id)
	return getglobal(MyBarsBarList[id].frame:GetName() .. "StatusBar"):GetValue();
end

function mbsSetBarValue(id, value)
	getglobal(MyBarsBarList[id].frame:GetName() .. "StatusBar"):SetValue(value);
end

function mbsStartTimerBar(id)
	MyBarsBarList[id].state = MYBARS_STATE_RUNNING;
	getglobal(MyBarsBarList[id].frame:GetName()):Show();
end

function mbsPauseTimerBar(id)
	MyBarsBarList[id].state = MYBARS_STATE_PAUSED;
end

function mbsStopTimerBar(id)
	MyBarsBarList[id].state = MYBARS_STATE_PAUSED;
	getglobal(MyBarsBarList[id].frame:GetName()):Hide();
end

function mbsResetTimerBar(id)
	MyBarsBarList[id].state = MYBARS_STATE_PENDING;
	mbsSetBarValue(id, mbsGetBarLeftValue(id));
end

function mbsSetBarTimerType(id, type)
	MyBarsBarList[id].timerType = type;
end

function mbsGetBarTimerType(id)
	return MyBarsBarList[id].timerType;
end

function mbsGetBarType(id)
	return MyBarsBarList[id].type;
end

function mbsGetBarState(id)
	return MyBarsBarList[id].state;
end

function mbsSetBarState(id, state)
	MyBarsBarList[id].state = state;
end

function mbsSetBarText(id, text, whichText)
	if (not whichText) then
		whichText = "CENTER";
	end

	getglobal(MyBarsBarList[id].frame:GetName() .. "StatusBar" .. string.upper(whichText) .. "Text"):SetText(text);
end

function mbsGetBarText(id, text, whichText)
	if (not whichText) then
		whichText = "CENTER";
	end

	return getglobal(MyBarsBarList[id].frame:GetName() .. "StatusBar" .. string.upper(whichText) .. "Text"):GetText();
end

function mbsUpdateTimerBars()
	for i = 1, table.maxn(MyBarsBarList) do
		if (mbsGetBarType(i) == MYBARS_TYPE_TIMER and mbsGetBarState(i) == MYBARS_STATE_RUNNING) then
			mbsSetBarValue(i, mbsGetBarValue(i) + 1);
			mbsSetBarText(i, mbsGetBarValue(i), "CENTER");
			mbsSetBarText(i, mbsGetBarValue(i), "LEFT");
			mbsSetBarText(i, mbsGetBarValue(i), "RIGHT");
			mbsSetBarText(i, mbsGetBarValue(i), "TOPLEFT");
			mbsSetBarText(i, mbsGetBarValue(i), "BOTTOMLEFT");
			mbsSetBarText(i, mbsGetBarValue(i), "TOPRIGHT");
			mbsSetBarText(i, mbsGetBarValue(i), "BOTTOMRIGHT");
			mbsSetBarText(i, mbsGetBarValue(i), "TOP");
			mbsSetBarText(i, mbsGetBarValue(i), "BOTTOM");

			if (mbsGetBarValue(i) >= mbsGetBarRightValue(i)) then
				mbsDisplayMessage("STOPPED");
				mbsStopTimerBar(i);
			end
		end
	end
end

function mbsDisplayMessage(msg)
	mduDisplayMessage(msg, "MyBars", 0, 1, .2, 1, 1, 0)
end