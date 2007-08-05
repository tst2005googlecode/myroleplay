----------------------------------------------------------------------------------------------------------
--			LOCALE										--
----------------------------------------------------------------------------------------------------------
if (GetLocale() == "enUS") then
	MDU_LOCALE_MDUDISPLAYMESSAGE_ERROR_NOMESSAGE		= "ERROR: No message entered in function mduDisplayMessage.";
	MDU_LOCALE_MDUDISPLAYMESSAGE_ERROR_MESSAGEWRONGFORMAT	= "ERROR: Message not a string or number in function mduDisplayMessage.";
else
	MDU_LOCALE_MDUDISPLAYMESSAGE_ERROR_NOMESSAGE		= "ERROR: No message entered in function mduDisplayMessage.";
	MDU_LOCALE_MDUDISPLAYMESSAGE_ERROR_MESSAGEWRONGFORMAT	= "ERROR: Message not a string or number in function mduDisplayMessage.";
end


----------------------------------------------------------------------------------------------------------
--			HEADER										--
----------------------------------------------------------------------------------------------------------
MDU_EMPTY_STRING = "";
MDU_DEFULT_MESSAGEOWNER = "MyDevUtilites";

MDU_VERSION = 0.5;

MDU_COLOURS_OWNER_R = 1;
MDU_COLOURS_OWNER_G = 0;
MDU_COLOURS_OWNER_B = 0;

MDU_COLOURS_MESSAGE_R = 1;
MDU_COLOURS_MESSAGE_G = 1;
MDU_COLOURS_MESSAGE_B = 1;

mduEventList = {};

MDU_TRUE = 1;
MDU_FALSE = 0;

SLASH_MYDEVUTILITES1 = "/mdu";
SLASH_MYDEVUTILITES2 = "/MyDevUtilities";

----------------------------------------------------------
--			FUNCTIONS                       --
----------------------------------------------------------

SlashCmdList["MYDEVUTILITES"] = mduHandleSlashCommand;

function mduGenerateNewId(highLimit, lowLimit)
	if (highLimit == nil) then
		highLimit = 99999999;
	end

	if (lowLimit == nil) then
		lowLimit = 1;
	end

	return (math.random(lowLimit, highLimit));
end

function mduGetIndexOfId(t, id)
	for i = 1, table.maxn(t) do
		if (t[i].id == id) then
			return (i);
		end
	end
end

function mduGetIndexOfTable(t, value)
	for i, v in ipairs(t) do
		if (v == value) then
			return (i);
		end
	end
end

function mduHandleSlashCommand(arg1)
	if (arg1 == "d") then
		mduDisplayMessage();
	end
end

function mduDisplayMessage(msg, owner, ownerR, ownerG, ownerB, messageR, messageG, messageB)
	if (msg == nil) then
		msg = MDU_LOCALE_MDUDISPLAYMESSAGE_ERROR_NOMESSAGE;
	else
		if (type(msg) ~= "string" and type(msg) ~= "number") then
			message = MDU_LOCALE_MDUDISPLAYMESSAGE_ERROR_MESSAGEWRONGFORMAT;
		end
	end

	if (owner == nil) then
		owner = MDU_DEFULT_MESSAGEOWNER;
	end

	if (ownerR == nil) then
		ownerR = MDU_COLOURS_OWNER_R;
	end

	if (ownerG == nil) then
		ownerG = MDU_COLOURS_OWNER_G;
	end

	if (ownerB == nil) then
		ownerB = MDU_COLOURS_OWNER_B;
	end

	if (messageR == nil) then
		messageR = MDU_COLOURS_MESSAGE_R;
	end

	if (messageG == nil) then
		messageG = MDU_COLOURS_MESSAGE_G;
	end

	if (messageB == nil) then
		messageB = MDU_COLOURS_MESSAGE_B;
	end

	if (DEFAULT_CHAT_FRAME) then
		if (type(owner) == "number" and owner == 0) then
			DEFAULT_CHAT_FRAME:AddMessage(tostring(msg), messageR, messageG, messageB);
		else
			DEFAULT_CHAT_FRAME:AddMessage("|CFF" .. mduColourToHex(ownerR, ownerG, ownerB) .."<" .. owner .. ">|r " .. tostring(msg), messageR, messageG, messageB);
		end
	end
end

function mduColourToHex(r, g, b)
	local red = string.format("%.2X", (r * 255));
	local green = string.format("%.2X", (g * 255));
	local blue = string.format("%.2X", (b * 255));

	local colour = red .. green .. blue;

	return (colour);
end

-- splits the specified text into an array on the specified separator
function mduStringSplit(separator, text, limit)
    local parts, position, length, last, jump, count = {}, 1, string.len( text ), nil, string.len( separator ), 0;

    while true do
        last = string.find(text, separator, position, true);
        if (last and (not limit or count < limit)) then
            table.insert(parts, string.sub(text, position, last - 1));
            position, count = last + jump, count + 1;
        else
            table.insert(parts, string.sub(text, position));
            break;
        end
    end

    return parts;
end

function mduConvertStringToDecimal(str)
	local wholeNumber, decimal = string.match(str, "(%d*)%.?(%d*)");

	if (not wholeNumber or wholeNumber == nil or wholeNumber == "") then
		wholeNumber = 0;
	end

	if (not decimal or decimal == nil or decimal == "") then
		decimal = 0;
	end

	local finalNumber = tonumber(wholeNumber) + (tonumber(decimal) / (10 ^ string.len(decimal)));

	return finalNumber;
end

function mduRegisterEvent(event, eventFunction)
	if (not mduEventList[event]) then
		table.insert(mduEventList, event);
		mduEventList[event] = {};
		mduEventList[event].eventFunctions = {};
		mduEventHandler:RegisterEvent(event);
	end

	table.insert(mduEventList[event].eventFunctions, table.maxn(mduEventList[event].eventFunctions) + 1);
	mduEventList[event].eventFunctions[table.maxn(mduEventList[event].eventFunctions)] = eventFunction;
end

function mduUnregisterEvent(event, eventFunction)
	for i, eventFunctionToTest in ipairs(mduEventList[event].eventFunctions) do
		if (eventFunctionToTest == eventFunction) then
			table.remove(mduEventList[event].eventFunctions, i);

			for j, eventName in ipairs(mduEventList) do
				if (eventName == event and table.maxn(mduEventList[event].eventFunctions) == 0) then
					table.remove(mduEventList, j);
					mduEventHandler:UnregisterEvent(event);
				end
			end

			return;
		end
	end
end

function mduOnEvent(event, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12, arg13, arg14, arg15, arg16, arg17, arg18, arg19, arg20)
	for i, eventFunction in ipairs(mduEventList) do
		if (event == eventFunction) then
			for j = 1, table.maxn(mduEventList[event].eventFunctions) do
				mduEventList[event].eventFunctions[j](arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12, arg13, arg14, arg15, arg16, arg17, arg18, arg19, arg20);
			end
		end
	end
end

function mduSendEvent(event, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12, arg13, arg14, arg15, arg16, arg17, arg18, arg19, arg20)
	mduOnEvent(event, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12, arg13, arg14, arg15, arg16, arg17, arg18, arg19, arg20);
end
