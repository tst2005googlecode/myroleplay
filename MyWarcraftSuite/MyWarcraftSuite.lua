
mwsTestTooltip = mttCreateTooltip("Name", MTT_TYPE_POPUP, mttTextFunction, DEFAULT_CHAT_FRAME, MTT_ANCHOR_TOP, 0, 0);

function mwsTooltipTest()
	mttDisplayTooltip(mwsTestTooltip);
end

mduRegisterEvent("UPDATE_MOUSEOVER_UNIT", mwsTooltipTest);
