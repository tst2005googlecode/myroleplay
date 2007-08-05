----------------------------------------------------------------------------------------------------------
--			LOCALE										--
----------------------------------------------------------------------------------------------------------
if (GetLocale() == "enUS") then
	MTI_LOCALE_UNREGISTER_ERROR_NOID			= "ERROR: Unable to unregister event. No id specifed.";
	MTI_LOCALE_UNREGISTER_ERROR_CANNOTFINDEVENT		= "ERROR: Unable to unregister event. Can't find specified event.";
else
	MTI_LOCALE_UNREGISTER_ERROR_NOID			= "ERROR: Unable to unregister event. No id specifed.";
	MTI_LOCALE_UNREGISTER_ERROR_CANNOTFINDEVENT		= "ERROR: Unable to unregister event. Can't find specified event.";
end


----------------------------------------------------------------------------------------------------------
--			HEADER										--
----------------------------------------------------------------------------------------------------------
MTI_NAME = "MyTime";
MTI_VERSION = 0.1;

mtiCurrentSystemTime = GetTime();
mtiCurrentServerTime = {};
	mtiCurrentServerTime.hours, mtiCurrentServerTime.minutes = GetGameTime();
--mtiPreviousSystemTime = mtiCurrentSystemTime;
--mtiUpTime = 0;

mtiEvents = {};
mtiQuedEvents = {};

mtiTimers = {};
mtiNumOfTimers = 0;

mtiNumOfEvents = 0;

mtiCurrentEventId = -1;

MTI_TIMER_STATE_RUNNING = 1;
MTI_TIMER_STATE_PENDING = 2;
MTI_TIMER_STATE_PAUSED = 3;
----------------------------------------------------------
--			FUNCTIONS                       --
----------------------------------------------------------

function mtiOnLoad()
	--Register the update time event.
	--mtiRegisterEvent(.001, mtiUpdateTime);
	--mtiRegisterEvent(.5, mtiTest);
	--mtiUptimeId = mtiCreateNewTimer(.1);
	--mtiRegisterEvent(3, mtiTest, true, "UPDATE_MOUSEOVER_UNIT");
	--mtiTimerTestId = mtiCreateNewTimer(2, 1, mtiTest);
	--mtiStartTimer(mtiTimerTestId);
end

function mtiOnUpdate()
	mtiPlayEvents(nil, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9);
end

function mtiOnEvent(event, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9)
	mtiPlayEvents(event, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9);
end


----------------------------------------------------------


function mtiRegisterEvent(updateInterval, eventFunction, queable, wowEvent)
	if (queable == nil) then
		queable = false;
	end

	local event = {};
			event.updateInterval = updateInterval;
			event.eventFunction = eventFunction;
			event.queable = queable;
			event.lastIntervalTime = mtiCurrentSystemTime;
			event.id = mtiGenerateNewEventId();
	if (wowEvent ~= nil) then
		mtiTimeWatcher:RegisterEvent(wowEvent);
		event.wowEvent = wowEvent;
	else
		event.wowEvent = MDU_EMPTY_STRING;
	end

	local index = table.maxn(mtiEvents) + 1;

	table.insert(mtiEvents, index);
	mtiEvents[index] = event;

	mduSendEvent("MYTIME_EVENT_REGISTERED", mtiEvents[index].id);

	return (mtiEvents[index].id);
end

function mtiUnregisterEvent(id)
	if (id == nil) then
		mduDisplayMessage(MTI_LOCALE_UNREGISTER_ERROR_NOID, MTI_NAME, 0, 0, .7, 1, 0, 0);
		return;
	end

	local eventToUnregister = MDU_EMPTY_STRING;
	local registeredEvents = {};
	local eventExists = false;
	local indexOfid = nil;

	for i = 1, table.maxn(mtiEvents) do
		if (mtiEvents[i].id == id) then
			indexOfid = i;

			if (mtiEvents[i].wowEvent ~= MDU_EMPTY_STRING) then
				eventToUnregister = mtiEvents[i].wowEvent;
			end
		else
			if (mtiEvents[i].wowEvent ~= MDU_EMPTY_STRING) then
				table.insert(registeredEvents, table.maxn(registeredEvents) + 1);
				registeredEvents[table.maxn(registeredEvents)] = mtiEvents[i].wowEvent;
			end
		end
	end

	for i = 1, table.maxn(registeredEvents) do
		if (registeredEvents[i] == eventToUnregister) then
			eventExists = true;
		end
	end

	if (eventExists == false) then
		mtiTimeWatcher:UnregisterEvent(eventToUnregister);
	end

	if (indexOfid ~= nil) then
		mduSendEvent("MYTIME_EVENT_UNREGISTERED", mtiEvents[indexOfid].id);
		table.remove(mtiEvents, indexOfid);
	else
		mduDisplayMessage(MTI_LOCALE_UNREGISTER_ERROR_CANNOTFINDEVENT, MTI_NAME, 0, 0, .7, 1, 0, 0);
	end
end

function mtiPlayEvents(wowEvent, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9)

	mtiCurrentSystemTime = GetTime();
	mtiCurrentServerTime.hours, mtiCurrentServerTime.minutes = GetGameTime();
	--mtiUpTime = mtiUpTime + (mtiCurrentSystemTime - mtiPreviousSystemTime);

	for i, event in ipairs(mtiQuedEvents) do
		if (event and GetTime() >= event.updateInterval + event.lastIntervalTime) then
			event.lastIntervalTime = mtiCurrentSystemTime;
			event.numOfCues = event.numOfCues - 1;
			mtiCurrentEventId = event.id;
			event.eventFunction(arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9);
			if (event and event.numOfCues == 0) then
				table.remove(mtiQuedEvents, i);
			end
		end
	end

	if (wowEvent == nil) then
		for i = 1, table.maxn(mtiEvents) do
			if ((mtiEvents[i] and mtiEvents[i].wowEvent == MDU_EMPTY_STRING) and (GetTime() >= mtiEvents[i].updateInterval + mtiEvents[i].lastIntervalTime)) then
				mtiEvents[i].lastIntervalTime = mtiCurrentSystemTime;
				mtiCurrentEventId = mtiEvents[i].id;
				mtiEvents[i].eventFunction(arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9);
			end
		end
	else
		for i = 1, table.maxn(mtiEvents) do
			if (mtiEvents[i] and mtiEvents[i].wowEvent == wowEvent) then
				if (GetTime() >= mtiEvents[i].updateInterval + mtiEvents[i].lastIntervalTime) then
					mtiEvents[i].lastIntervalTime = mtiCurrentSystemTime;
					mtiCurrentEventId = mtiEvents[i].id;
					mtiEvents[i].eventFunction(arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9);
				else
					if (mtiEvents[i].queable == true) then
						if (table.maxn(mtiQuedEvents) == 0) then
							table.insert(mtiQuedEvents, table.maxn(mtiQuedEvents) + 1);
							mtiQuedEvents[table.maxn(mtiQuedEvents)] = mtiEvents[i];
							mtiQuedEvents[table.maxn(mtiQuedEvents)].numOfCues = 1;
						else
							for j = 1, table.maxn(mtiQuedEvents) do
								if (mtiEvents[i].id == mtiQuedEvents[j].id) then
									mtiQuedEvents[j].numOfCues = mtiQuedEvents[j].numOfCues + 1;
								elseif (mtiEvents[i].id ~= mtiQuedEvents[j].id and j == table.maxn(mtiQuedEvents)) then
									table.insert(mtiQuedEvents, table.maxn(mtiQuedEvents) + 1);
									mtiQuedEvents[table.maxn(mtiQuedEvents)] = mtiEvents[i];
									mtiQuedEvents[table.maxn(mtiQuedEvents)].numOfCues = 1;
								end
							end
						end
					end
				end
			end
		end
	end

	--mtiPreviousSystemTime = GetTime();
end

function mtiGenerateNewEventId()
	mtiNumOfEvents = mtiNumOfEvents + 1;
	return (mtiNumOfEvents);
end

function mtiGenerateNewTimerId()
	mtiNumOfTimers = mtiNumOfTimers + 1;
	return (mtiNumOfTimers);
end

function mtiGetCurEventId()
	return mtiCurrentEventId;
end

----------------------------------------------------------
--			ULTILITY FUNCTIONS              --
----------------------------------------------------------

function mtiCreateNewTimer(timeStretch, timeUpdate, timerFunction, startTime, endTime)
	if (startTime == nil) then
		startTime = 0;
	end

	if (endTime == nil) then
		endTime = nil;
	end

	local timer = {};
		timer.id = mtiGenerateNewTimerId();
		timer.timeStretch = timeStretch;
		timer.timeUpdate = timeUpdate;
		timer.timerFunction = timerFunction;
		timer.startTime = startTime;
		timer.currentTime = startTime;
		timer.endTime = endTime;
		timer.state = MTI_TIMER_STATE_PENDING;
		timer.lastUpdated = GetTime();

	local index = table.maxn(mtiTimers) + 1;

	table.insert(mtiTimers, index);
	mtiTimers[index] = timer;

	mduSendEvent("MYTIME_TIMER_CREATED", mtiTimers[index].id);

	return (mtiTimers[index].id);
end

function mtiUpdateTimers(updatedLast)
	for i = 1, table.maxn(mtiTimers) do
		if (mtiTimers[i].state == MTI_TIMER_STATE_RUNNING) then
			mtiTimers[i].currentTime = mtiTimers[i].currentTime + (updatedLast * mtiTimers[i].timeStretch);

			if (mtiTimers[i].timerFunction and mtiTimers[i].timerFunction ~= nil and mtiTimers[i].timeUpdate and mtiTimers[i].timeUpdate ~= nil and (GetTime() >= mtiTimers[i].lastUpdated  + (mtiTimers[i].timeUpdate * mtiTimers[i].timeStretch))) then
				mtiTimers[i].timerFunction(arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9);
				mtiTimers[i].lastUpdated = GetTime();
			end
			if (mtiTimers[i].endTime ~= nil and mtiTimers[i].currentTime >= mtiTimers[i].endTime) then
				mtiPauseTimer(mtiTimers[i].id);
				mduSendEvent("MYTIME_TIMER_ENDED", mtiTimers[i].id, mtiTimers[i].endTime);
			end

		end
	end
end

function mtiStartTimer(id)
	local index = mduGetIndexOfId(mtiTimers, id);

	if (mtiTimers[index]) then
		mtiTimers[index].state = MTI_TIMER_STATE_RUNNING;
		mduSendEvent("MYTIME_TIMER_STARTED", mtiTimers[index].id, mtiTimers[index].startTime);
	end
end
-- /script mtiPauseTimer(mtiTimerTestId);
-- /script mtiStartTimer(mtiTimerTestId);
-- /script mtiResetTimer(mtiTimerTestId);
-- /script mtiRemoveTimer(mtiTimerTestId);
-- /script mtiSetTimerTime(mtiTimerTestId, 23);
function mtiPauseTimer(id)
	local index = mduGetIndexOfId(mtiTimers, id);

	mtiTimers[index].state = MTI_TIMER_STATE_PAUSED;
	mduSendEvent("MYTIME_TIMER_PAUSED", mtiTimers[index].id, mtiTimers[index].currentTime);
end

function mtiResetTimer(id)
	local index = mduGetIndexOfId(mtiTimers, id);

	mtiTimers[index].currentTime = mtiTimers[index].startTime;
	mtiTimers[index].state = MTI_TIMER_STATE_PENDING;
	mduSendEvent("MYTIME_TIMER_RESET", mtiTimers[index].id, mtiTimers[index].currentTime);
end

function mtiRemoveTimer(id)
	local index = mduGetIndexOfId(mtiTimers, id);

	mtiUnregisterEvent(mtiTimers[index].eventId);
	mduSendEvent("MYTIME_TIMER_REMOVED", mtiTimers[index].id);
	table.remove(mtiTimers, index);
end

function mtiGetTimerTime(id)
	local index = mduGetIndexOfId(mtiTimers, id);

	return (mtiTimers[index].currentTime);
end

function mtiSetTimerTime(id, newTime)
	local index = mduGetIndexOfId(mtiTimers, id);

	mtiTimers[index].currentTime = newTime;

	if (mtiTimers[index].endTime ~= nil and mtiTimers[index].currentTime > mtiTimers[index].endTime) then
		mtiTimers[index].endTime = mtiTimers[index].currentTime;
	end

	if (mtiTimers[index].currentTime < mtiTimers[index].startTime) then
		mtiTimers[index].startTime = mtiTimers[index].currentTime;
	end
end

function mtiGetTimerState(id)
	local index = mduGetIndexOfId(mtiTimers, id);

	return (mtiTimers[index].state);
end

function mtiGetTimerEndTime(id)
	local index = mduGetIndexOfId(mtiTimers, id);

	return (mtiTimers[index].endTime);
end

function mtiGetTimerStartTime(id)
	local index = mduGetIndexOfId(mtiTimers, id);

	return (mtiTimers[index].startTime);
end

function mtiGetServerHour()
	return (mtiCurrentServerTime.hours);
end

function mtiGetServerMinute()
	return (mtiCurrentServerTime.minutes);
end

function mtiGetTime()
	return (mtiCurrentSystemTime);
end
