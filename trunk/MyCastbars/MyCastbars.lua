
function mcbCreateBars()
	mbsCreateNewBar(0, 1000, MYBARS_TYPE_TIMER);
	mbsCreateNewBar(0, 100, MYBARS_TYPE_TIMER);
	mbsCreateNewBar(0, 10000, MYBARS_TYPE_TIMER);
	mbsCreateNewBar(200, 0, MYBARS_TYPE_TIMER, MYBARS_START_RIGHT);
end