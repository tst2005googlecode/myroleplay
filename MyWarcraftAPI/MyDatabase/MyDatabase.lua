----------------------------------------------------------------------------------------------------------
--			LOCALE										--
----------------------------------------------------------------------------------------------------------
if (GetLocale() == "enUS") then
	MDB_LOCALE_DATABASEEXISTS_ERROR				= "ERROR: Database already exists: ";
	MDB_LOCALE_DATABASEDOESNOTEXIST_ERROR			= "ERROR: Database does not exist: ";
	MDB_LOCALE_TABLEEXISTS_ERROR				= "ERROR: Table already exists: ";
	MDB_LOCALE_TABLEDOESNOTEXIST_ERROR			= "ERROR: Table does not exist: ";
	MDB_LOCALE_COLUMNEXISTS_ERROR				= "ERROR: Column already exists: ";
	MDB_LOCALE_COLUMNDOESNOTEXIST_ERROR			= "ERROR: Column does not exist: ";
	--MDB_LOCALE_TABLEDOESNOTEXIST_ERROR			= "ERROR: Table does not exist: ";
	--MDB_LOCALE_TABLEDOESNOTEXIST_ERROR			= "ERROR: Table does not exist: ";
	--MDB_LOCALE_TABLEDOESNOTEXIST_ERROR			= "ERROR: Table does not exist: ";
	--MDB_LOCALE_TABLEDOESNOTEXIST_ERROR			= "ERROR: Table does not exist: ";
	--MDB_LOCALE_TABLEDOESNOTEXIST_ERROR			= "ERROR: Table does not exist: ";
else
	MDB_LOCALE_DATABASEEXISTS_ERROR				= "ERROR: Database already exists: ";
	MDB_LOCALE_DATABASEDOESNOTEXIST_ERROR			= "ERROR: Database does not exist: ";
	MDB_LOCALE_TABLEEXISTS_ERROR				= "ERROR: Table already exists: ";
	MDB_LOCALE_TABLEDOESNOTEXIST_ERROR			= "ERROR: Table does not exist: ";
	MDB_LOCALE_COLUMNEXISTS_ERROR				= "ERROR: Column already exists: ";
	MDB_LOCALE_COLUMNDOESNOTEXIST_ERROR			= "ERROR: Column does not exist: ";
end


----------------------------------------------------------------------------------------------------------
--			HEADER										--
----------------------------------------------------------------------------------------------------------
MDB_NAME = "MyDatabase";
MDB_VERSION = 0.1;

--[[CreateFrame("Frame", "MyDatabaseFrame", UIParent);
MyDatabaseFrame:Show();
MyDatabaseFrame:SetScript("OnLoad", mdbOnLoad);
MyDatabaseFrame:SetScript("OnEvent", mdbOnEvent);]]

if (not MyDatabase or MyDatabase == nil) then
	MyDatabase = {};
end

MyDatabase.Databases = {};



MDB_PRIVILAGES_READ = 1;
MDB_PRIVILAGES_WRITE = 2;

--[[
CREATE DATABASE databaseName
REMOVE DATABASE databaseName
RENAME DATABASE databaseName TO newDatabaseName
ALTER DATABASE databaseName (
	CREATE TABLE tableName {(columnName, ...)}
	REMOVE TABLE tableName
	RENAME TABLE tableName TO newTableName
	ALTER TABLE tableName (
		ADD columnName
		REMOVE columnName
		RENAME columnName TO newColumnName
		INSERT (value1, value2, ...)
		DELETE WHERE columnName = $variable | 1|2|3|...  | "string"
		ALTER columnName WHERE dataValue = $variable | 1|2|3|...  | "string" TO newDataValue
	)
)
READ DATABASE databaseName (
	GET columnName, ... FROM tableName TO $variable WHERE dataValue = $variable | 1|2|3|...  | "string"
	SEARCH FOR $data IN columnName FROM tableName SEND TO $variable
)
]]

MDB_SYNTAX_CREATEDATABASE = "CREATE DATABASE";
MDB_SYNTAX_REMOVEDATABASE = "REMOVE DATABASE";
MDB_SYNTAX_RENAMEDATABASE = "RENAME DATABASE";
MDB_SYNTAX_TO = "TO";
MDB_SYNTAX_ALTERDATABASE = "ALTER DATABASE";
MDB_SYNTAX_CREATETABLE = "CREATE TABLE";
MDB_SYNTAX_REMOVETABLE = "REMOVE TABLE";
MDB_SYNTAX_RENAMETABLE = "RENAME TABLE";
MDB_SYNTAX_ALTERTABLE = "ALTER TABLE";
MDB_SYNTAX_ADD = "ADD";
MDB_SYNTAX_REMOVE = "REMOVE";
MDB_SYNTAX_RENAME = "RENAME";
MDB_SYNTAX_INSERT = "INSERT";
MDB_SYNTAX_DELETEWHERE = "DELETE WHERE";
MDB_SYNTAX_ALTER = "ALTER";
MDB_SYNTAX_WHERE = "WHERE";
MDB_SYNTAX_SEARCHFOR = "SEARCH FOR";
MDB_SYNTAX_IN = "IN";
MDB_SYNTAX_FROM = "FROM";
MDB_SYNTAX_GET = "GET";
MDB_SYNTAX_SENDTO = "SEND TO";
MDB_SYNTAX_READDATABASE = "READ DATABASE";

MDB_NIL = string.char(2) .. "nil" .. string.char(3);

----------------------------------------------------------
--			USER FUNCTIONS                  --
----------------------------------------------------------

function mdbOpenConsole(text)
	for line in string.gfind(text, MDB_SYNTAX_CREATEDATABASE .. "%s+%w+") do
		local databaseName = string.gsub(line, MDB_SYNTAX_CREATEDATABASE .. "%s+", "");

		mdbCreateDatabase(databaseName);
	end

	for line in string.gfind(text, MDB_SYNTAX_ALTERDATABASE .. "%s*%w+%s*%([.]*") do
		local databaseName = string.gsub(line, MDB_SYNTAX_ALTERDATABASE .. "%s*", "");

		mdbCreateTable(databaseName);
	end
end

----------------------------------------------------------
--		BACKEND FUNCTIONS			--
----------------------------------------------------------

function mdbOnLoad()
	mdbFrame:RegisterEvent("PLAYER_LOGOUT");
	mdbFrame:RegisterEvent("VARIABLES_LOADED");
end

function mdbOnEvent(event)
	if (event == "PLAYER_LOGOUT") then
		mdbGlobalSaved = MyDatabase.GlobalSaved;
		mdbSaved = MyDatabase.Saved;
		MyDatabase = nil;
	end

	if (event == "VARIABLES_LOADED") then
		if (not MyDatabase.Saved or MyDatabase.Saved == nil) then
			MyDatabase.Saved = {};
			if (mdbSaved and mdbSaved ~= nil) then
				MyDatabase.Saved = mdbSaved;
				mdbSaved = nil;
			end
		end

		if (not MyDatabase.GlobalSaved or MyDatabase.GlobalSaved == nil) then
			MyDatabase.GlobalSaved = {};
			if (mdbGlobalSaved and mdbGlobalSaved ~= nil) then
				MyDatabase.GlobalSaved = mdbGlobalSaved;
				mdbGlobalSaved = nil;
			end
		end
	end
end

function mdbCreateDatabase(databaseName, isSaved, isGlobal)
	if (mdbDatabaseExists(databaseName) == true) then
		mduDisplayMessage(MDB_LOCALE_DATABASEEXISTS_ERROR .. databaseName, MDB_NAME, .8, .8, 0, 1, 0, 0);

		return;
	end

	if (isSaved == true) then
		if (isGlobal == true) then
			table.insert(MyDatabase.GlobalSaved, databaseName);
			MyDatabase.GlobalSaved[databaseName] = {};

			table.insert(MyDatabase.GlobalSaved[databaseName], Privilages);

			MyDatabase.GlobalSaved[databaseName].Privilages = {};
			MyDatabase.GlobalSaved[databaseName].Privilages.inGuild = MDB_PRIVILAGES_WRITE;
			MyDatabase.GlobalSaved[databaseName].Privilages.guildLeader = MDB_PRIVILAGES_WRITE;
			MyDatabase.GlobalSaved[databaseName].Privilages.inParty = MDB_PRIVILAGES_WRITE;
			MyDatabase.GlobalSaved[databaseName].Privilages.partyLeader = MDB_PRIVILAGES_WRITE;
			MyDatabase.GlobalSaved[databaseName].Privilages.inRaid = MDB_PRIVILAGES_WRITE;
			MyDatabase.GlobalSaved[databaseName].Privilages.raidLeader = MDB_PRIVILAGES_WRITE;

			table.insert(MyDatabase.GlobalSaved[databaseName], Tables);

			MyDatabase.GlobalSaved[databaseName].Tables = {};

			MyDatabase.GlobalSaved[databaseName].isLocked = MDU_FALSE;
		elseif (isGlobal == false) then
			table.insert(MyDatabase.Saved, databaseName);
			MyDatabase.Saved[databaseName] = {};

			table.insert(MyDatabase.Saved[databaseName], Privilages);

			MyDatabase.Saved[databaseName].Privilages = {};
			MyDatabase.Saved[databaseName].Privilages.inGuild = MDB_PRIVILAGES_WRITE;
			MyDatabase.Saved[databaseName].Privilages.guildLeader = MDB_PRIVILAGES_WRITE;
			MyDatabase.Saved[databaseName].Privilages.inParty = MDB_PRIVILAGES_WRITE;
			MyDatabase.Saved[databaseName].Privilages.partyLeader = MDB_PRIVILAGES_WRITE;
			MyDatabase.Saved[databaseName].Privilages.inRaid = MDB_PRIVILAGES_WRITE;
			MyDatabase.Saved[databaseName].Privilages.raidLeader = MDB_PRIVILAGES_WRITE;

			table.insert(MyDatabase.Saved[databaseName], Tables);

			MyDatabase.Saved[databaseName].Tables = {};

			MyDatabase.Saved[databaseName].isLocked = MDU_FALSE;
		end
	else
		table.insert(MyDatabase.Databases, databaseName);
		MyDatabase.Databases[databaseName] = {};

		table.insert(MyDatabase.Databases[databaseName], Privilages);

		MyDatabase.Databases[databaseName].Privilages = {};
		MyDatabase.Databases[databaseName].Privilages.inGuild = MDB_PRIVILAGES_WRITE;
		MyDatabase.Databases[databaseName].Privilages.guildLeader = MDB_PRIVILAGES_WRITE;
		MyDatabase.Databases[databaseName].Privilages.inParty = MDB_PRIVILAGES_WRITE;
		MyDatabase.Databases[databaseName].Privilages.partyLeader = MDB_PRIVILAGES_WRITE;
		MyDatabase.Databases[databaseName].Privilages.inRaid = MDB_PRIVILAGES_WRITE;
		MyDatabase.Databases[databaseName].Privilages.raidLeader = MDB_PRIVILAGES_WRITE;

		table.insert(MyDatabase.Databases[databaseName], Tables);

		MyDatabase.Databases[databaseName].Tables = {};

		MyDatabase.Databases[databaseName].isLocked = MDU_FALSE;
	end


end

function mdbCreateTable(databaseName, tableName)
	local databaseExists, tableExists = mdbExists(databaseName, tableName);

	if (databaseExists == false) then
		mduDisplayMessage(MDB_LOCALE_DATABASEDOESNOTEXIST_ERROR .. databaseName, MDB_NAME, .8, .8, 0, 1, 0, 0);

		return;
	end

	if (tableExists == true) then
		mduDisplayMessage(MDB_LOCALE_TABLEEXISTS_ERROR .. tableName, MDB_NAME, .8, .8, 0, 1, 0, 0);

		return;
	end

	local isSaved, isGlobal = mdbIsSaved(databaseName);

	if (isSaved == true) then
		if (isGlobal == true) then
			table.insert(MyDatabase.GlobalSaved[databaseName].Tables, tableName);
			MyDatabase.GlobalSaved[databaseName].Tables[tableName] = {};

			table.insert(MyDatabase.GlobalSaved[databaseName].Tables[tableName], Privilages);

			MyDatabase.GlobalSaved[databaseName].Tables[tableName].Privilages = {};
			MyDatabase.GlobalSaved[databaseName].Tables[tableName].Privilages.inGuild = MDB_PRIVILAGES_WRITE;
			MyDatabase.GlobalSaved[databaseName].Tables[tableName].Privilages.guildLeader = MDB_PRIVILAGES_WRITE;
			MyDatabase.GlobalSaved[databaseName].Tables[tableName].Privilages.inParty = MDB_PRIVILAGES_WRITE;
			MyDatabase.GlobalSaved[databaseName].Tables[tableName].Privilages.partyLeader = MDB_PRIVILAGES_WRITE;
			MyDatabase.GlobalSaved[databaseName].Tables[tableName].Privilages.inRaid = MDB_PRIVILAGES_WRITE;
			MyDatabase.GlobalSaved[databaseName].Tables[tableName].Privilages.raidLeader = MDB_PRIVILAGES_WRITE;
		end

		table.insert(MyDatabase.Saved[databaseName].Tables, tableName);
		MyDatabase.Saved[databaseName].Tables[tableName] = {};

		table.insert(MyDatabase.Saved[databaseName].Tables[tableName], Privilages);

		MyDatabase.Saved[databaseName].Tables[tableName].Privilages = {};
		MyDatabase.Saved[databaseName].Tables[tableName].Privilages.inGuild = MDB_PRIVILAGES_WRITE;
		MyDatabase.Saved[databaseName].Tables[tableName].Privilages.guildLeader = MDB_PRIVILAGES_WRITE;
		MyDatabase.Saved[databaseName].Tables[tableName].Privilages.inParty = MDB_PRIVILAGES_WRITE;
		MyDatabase.Saved[databaseName].Tables[tableName].Privilages.partyLeader = MDB_PRIVILAGES_WRITE;
		MyDatabase.Saved[databaseName].Tables[tableName].Privilages.inRaid = MDB_PRIVILAGES_WRITE;
		MyDatabase.Saved[databaseName].Tables[tableName].Privilages.raidLeader = MDB_PRIVILAGES_WRITE;


		table.insert(MyDatabase.Saved[databaseName].Tables[tableName], Columns);

		MyDatabase.Saved[databaseName].Tables[tableName].Columns = {};
	elseif (isSaved == false) then
		table.insert(MyDatabase.Databases[databaseName].Tables, tableName);
		MyDatabase.Databases[databaseName].Tables[tableName] = {};

		table.insert(MyDatabase.Databases[databaseName].Tables[tableName], Privilages);

		MyDatabase.Databases[databaseName].Tables[tableName].Privilages = {};
		MyDatabase.Databases[databaseName].Tables[tableName].Privilages.inGuild = MDB_PRIVILAGES_WRITE;
		MyDatabase.Databases[databaseName].Tables[tableName].Privilages.guildLeader = MDB_PRIVILAGES_WRITE;
		MyDatabase.Databases[databaseName].Tables[tableName].Privilages.inParty = MDB_PRIVILAGES_WRITE;
		MyDatabase.Databases[databaseName].Tables[tableName].Privilages.partyLeader = MDB_PRIVILAGES_WRITE;
		MyDatabase.Databases[databaseName].Tables[tableName].Privilages.inRaid = MDB_PRIVILAGES_WRITE;
		MyDatabase.Databases[databaseName].Tables[tableName].Privilages.raidLeader = MDB_PRIVILAGES_WRITE;


		table.insert(MyDatabase.Databases[databaseName].Tables[tableName], Columns);

		MyDatabase.Databases[databaseName].Tables[tableName].Columns = {};
	end
end

function mdbDeleteTable(databaseName, tableName)

end

function mdbAddColumn(databaseName, tableName, columnName)
	local databaseExists, tableExists, columnExists = mdbExists(databaseName, tableName, columnName);

	if (databaseExists == false) then
		mduDisplayMessage(MDB_LOCALE_DATABASEDOESNOTEXIST_ERROR .. databaseName, MDB_NAME, .8, .8, 0, 1, 0, 0);

		return;
	end

	if (tableExists == false) then
		mduDisplayMessage(MDB_LOCALE_TABLEDOESNOTEXIST_ERROR .. tableName, MDB_NAME, .8, .8, 0, 1, 0, 0);

		return;
	end

	if (columnName == true) then
		mduDisplayMessage(MDB_LOCALE_COLUMNEXISTS_ERROR .. columnName, MDB_NAME, .8, .8, 0, 1, 0, 0);

		return;
	end

	local isSaved, isGlobal = mdbIsSaved(databaseName);

	if (isSaved == true) then
		if (isGlobal == true) then
			local tableIterator = table.maxn(MyDatabase.GlobalSaved[databaseName].Tables[tableName].Columns) + 1;

			table.insert(MyDatabase.GlobalSaved[databaseName].Tables[tableName].Columns, tableIterator);
			MyDatabase.GlobalSaved[databaseName].Tables[tableName].Columns[tableIterator] = {};
			MyDatabase.GlobalSaved[databaseName].Tables[tableName].Columns[tableIterator].name = columnName;
			MyDatabase.GlobalSaved[databaseName].Tables[tableName].Columns[tableIterator].values = {};

			local maxValues = 0;

			for i = 1, tableIterator - 1 do
				local numOfValues = table.maxn(MyDatabase.GlobalSaved[databaseName].Tables[tableName].Columns[i].values)

				if (numOfValues > maxValues) then
					maxValues = numOfValues;
				end
			end

			for i = 1, maxValues do
				table.insert(MyDatabase.GlobalSaved[databaseName].Tables[tableName].Columns[tableIterator].values, i);
			end
		end

		local tableIterator = table.maxn(MyDatabase.Saved[databaseName].Tables[tableName].Columns) + 1;

		table.insert(MyDatabase.Saved[databaseName].Tables[tableName].Columns, tableIterator);
		MyDatabase.Saved[databaseName].Tables[tableName].Columns[tableIterator] = {};
		MyDatabase.Saved[databaseName].Tables[tableName].Columns[tableIterator].name = columnName;
		MyDatabase.Saved[databaseName].Tables[tableName].Columns[tableIterator].values = {};

		local maxValues = 0;

		for i = 1, tableIterator - 1 do
			local numOfValues = table.maxn(MyDatabase.Saved[databaseName].Tables[tableName].Columns[i].values)

			if (numOfValues > maxValues) then
				maxValues = numOfValues;
			end
		end

		for i = 1, maxValues do
			table.insert(MyDatabase.Saved[databaseName].Tables[tableName].Columns[tableIterator].values, i);
		end

	elseif (isSaved == false) then
		local tableIterator = table.maxn(MyDatabase.Databases[databaseName].Tables[tableName].Columns) + 1;

		table.insert(MyDatabase.Databases[databaseName].Tables[tableName].Columns, tableIterator);
		MyDatabase.Databases[databaseName].Tables[tableName].Columns[tableIterator] = {};
		MyDatabase.Databases[databaseName].Tables[tableName].Columns[tableIterator].name = columnName;
		MyDatabase.Databases[databaseName].Tables[tableName].Columns[tableIterator].values = {};

		local maxValues = 0;

		for i = 1, tableIterator - 1 do
			local numOfValues = table.maxn(MyDatabase.Databases[databaseName].Tables[tableName].Columns[i].values)

			if (numOfValues > maxValues) then
				maxValues = numOfValues;
			end
		end

		for i = 1, maxValues do
			table.insert(MyDatabase.Databases[databaseName].Tables[tableName].Columns[tableIterator].values, i);
		end
	end
end

function mdbInsertData(databaseName, tableName, ...)
	local databaseExists, tableExists = mdbExists(databaseName, tableName);

	if (databaseExists == false) then
		mduDisplayMessage(MDB_LOCALE_DATABASEDOESNOTEXIST_ERROR .. databaseName, MDB_NAME, .8, .8, 0, 1, 0, 0);

		return;
	end

	if (tableExists == false) then
		mduDisplayMessage(MDB_LOCALE_TABLEDOESNOTEXIST_ERROR .. tableName, MDB_NAME, .8, .8, 0, 1, 0, 0);

		return;
	end

	local isSaved, isGlobal = mdbIsSaved(databaseName);

	if (isSaved == true) then
		if (isGlobal == true) then
			local tempIterator = table.maxn(MyDatabase.GlobalSaved[databaseName].Tables[tableName].Columns[1].values) + 1;

			for i = 1, table.maxn(MyDatabase.GlobalSaved[databaseName].Tables[tableName].Columns) do
				local value = select(i, ...);

				if (value == nil) then
					value = MDB_NIL;
				end

				table.insert(MyDatabase.GlobalSaved[databaseName].Tables[tableName].Columns[i].values, tempIterator);
				MyDatabase.GlobalSaved[databaseName].Tables[tableName].Columns[i].values[tempIterator] = value;
			end
		end

		local tempIterator = table.maxn(MyDatabase.Saved[databaseName].Tables[tableName].Columns[1].values) + 1;

		for i = 1, table.maxn(MyDatabase.Saved[databaseName].Tables[tableName].Columns) do
			local value = select(i, ...);

			if (value == nil) then
				value = MDB_NIL;
			end

			table.insert(MyDatabase.Saved[databaseName].Tables[tableName].Columns[i].values, tempIterator);
			MyDatabase.Saved[databaseName].Tables[tableName].Columns[i].values[tempIterator] = value;
		end
	elseif (isSaved == false) then
		local tempIterator = table.maxn(MyDatabase.Databases[databaseName].Tables[tableName].Columns[1].values) + 1;

		for i = 1, table.maxn(MyDatabase.Databases[databaseName].Tables[tableName].Columns) do
			local value = select(i, ...);

			if (value == nil) then
				value = MDB_NIL;
			end

			table.insert(MyDatabase.Databases[databaseName].Tables[tableName].Columns[i].values, tempIterator);
			MyDatabase.Databases[databaseName].Tables[tableName].Columns[i].values[tempIterator] = value;
		end
	end
end

function mdbDeleteData(databaseName, tableName, ...)
	local databaseExists, tableExists = mdbExists(databaseName, tableName);

	if (databaseExists == false) then
		mduDisplayMessage(MDB_LOCALE_DATABASEDOESNOTEXIST_ERROR .. databaseName, MDB_NAME, .8, .8, 0, 1, 0, 0);

		return;
	end

	if (tableExists == false) then
		mduDisplayMessage(MDB_LOCALE_TABLEDOESNOTEXIST_ERROR .. tableName, MDB_NAME, .8, .8, 0, 1, 0, 0);

		return;
	end

	local isSaved, isGlobal = mdbIsSaved(databaseName);

	local listToDelete = {};

	for dataIterator = 1, mdbGetNumValues(databaseName, tableName) do
		for i = 1, select("#", ...) do
			local searchData = mdbGetData(databaseName, tableName, select(i, ...).column, dataIterator);
			local isValid = false;

			if (select(i, ...).operator == "=") then
				if (searchData == select(i, ...).argument) then
					isValid = true;
				end
			end
			if (select(i, ...).operator == "~=") then
				if (searchData ~= select(i, ...).argument) then
					isValid = true;
				end
			end
			if (select(i, ...).operator == ">") then
				if (searchData > select(i, ...).argument) then
					isValid = true;
				end
			end
			if (select(i, ...).operator == "<") then
				if (searchData < select(i, ...).argument) then
					isValid = true;
				end
			end
			if (select(i, ...).operator == ">=") then
				if (searchData >= select(i, ...).argument) then
					isValid = true;
				end
			end
			if (select(i, ...).operator == "<=") then
				if (searchData <= select(i, ...).argument) then
					isValid = true;
				end
			end

			if (isValid == true) then
				table.insert(listToDelete, table.maxn(listToDelete) + 1, dataIterator);
			end
		end
	end

	for j = 1, mdbGetNumColumns(databaseName, tableName) do
		for k = 1, table.maxn(listToDelete) do
			if (isSaved == true) then
				if (isGlobal == true) then
					table.remove(MyDatabase.GlobalSaved[databaseName].Tables[tableName].Columns[j].values, listToDelete[k]);
				elseif (isGlobal == false) then
					table.remove(MyDatabase.Saved[databaseName].Tables[tableName].Columns[j].values, listToDelete[k]);
				end
			elseif (isSaved == false) then
				table.remove(MyDatabase.Databases[databaseName].Tables[tableName].Columns[j].values, listToDelete[k]);
			end
		end
	end
end

function mdbHardEditData(databaseName, tableName, columnName, newData)
	local databaseExists, tableExists, columnExists = mdbExists(databaseName, tableName, columnName);

	if (databaseExists == false) then
		mduDisplayMessage(MDB_LOCALE_DATABASEDOESNOTEXIST_ERROR .. databaseName, MDB_NAME, .8, .8, 0, 1, 0, 0);

		return;
	end

	if (tableExists == false) then
		mduDisplayMessage(MDB_LOCALE_TABLEDOESNOTEXIST_ERROR .. tableName, MDB_NAME, .8, .8, 0, 1, 0, 0);

		return;
	end

	if (columnExists == false) then
		mduDisplayMessage(MDB_LOCALE_COLUMNDOESNOTEXIST_ERROR .. columnName, MDB_NAME, .8, .8, 0, 1, 0, 0);

		return;
	end

	if (newData == nil) then
		newData = MDB_NIL;
	end

	local isSaved, isGlobal = mdbIsSaved(databaseName);

	for dataIterator = 1, mdbGetNumValues(databaseName, tableName, columnName) do
		if (isSaved == true) then
			if (isGlobal == true) then
				MyDatabase.GlobalSaved[databaseName].Tables[tableName].Columns[mdbGetColumnIterator(databaseName, tableName, columnName)].values[dataIterator] = newData;
			elseif (isGlobal == false) then
				MyDatabase.Saved[databaseName].Tables[tableName].Columns[mdbGetColumnIterator(databaseName, tableName, columnName)].values[dataIterator] = newData;
			end
		elseif (isSaved == false) then
			MyDatabase.Databases[databaseName].Tables[tableName].Columns[mdbGetColumnIterator(databaseName, tableName, columnName)].values[dataIterator] = newData;
		end
	end
end

function mdbEditData(databaseName, tableName, columnName, newData, ...)
	local databaseExists, tableExists, columnExists = mdbExists(databaseName, tableName, columnName);

	if (databaseExists == false) then
		mduDisplayMessage(MDB_LOCALE_DATABASEDOESNOTEXIST_ERROR .. databaseName, MDB_NAME, .8, .8, 0, 1, 0, 0);

		return;
	end

	if (tableExists == false) then
		mduDisplayMessage(MDB_LOCALE_TABLEDOESNOTEXIST_ERROR .. tableName, MDB_NAME, .8, .8, 0, 1, 0, 0);

		return;
	end

	if (columnExists == false) then
		mduDisplayMessage(MDB_LOCALE_COLUMNDOESNOTEXIST_ERROR .. columnName, MDB_NAME, .8, .8, 0, 1, 0, 0);

		return;
	end

	if (newData == nil) then
		newData = MDB_NIL;
	end

	local isSaved, isGlobal = mdbIsSaved(databaseName);

	for dataIterator = 1, mdbGetNumValues(databaseName, tableName) do
		local isValid = false;

		for i = 1, select("#", ...) do
			local searchData = mdbGetData(databaseName, tableName, select(i, ...).column, dataIterator);

			if (select(i, ...).operator == "=") then
				if (searchData == select(i, ...).argument) then
					isValid = true;
					break;
				end
			end
			if (select(i, ...).operator == "~=") then
				if (searchData ~= select(i, ...).argument) then
					isValid = true;
					break;
				end
			end
			if (select(i, ...).operator == ">") then
				if (searchData > select(i, ...).argument) then
					isValid = true;
					break;
				end
			end
			if (select(i, ...).operator == "<") then
				if (searchData < select(i, ...).argument) then
					isValid = true;
					break;
				end
			end
			if (select(i, ...).operator == ">=") then
				if (searchData >= select(i, ...).argument) then
					isValid = true;
					break;
				end
			end
			if (select(i, ...).operator == "<=") then
				if (searchData <= select(i, ...).argument) then
					isValid = true;
					break;
				end
			end
		end

		if (isSaved == true) then
			if (isGlobal == true) then
				if (isValid == true) then
					MyDatabase.GlobalSaved[databaseName].Tables[tableName].Columns[mdbGetColumnIterator(databaseName, tableName, columnName)].values[dataIterator] = newData;
				end
			elseif (isGlobal == false) then
				if (isValid == true) then
					MyDatabase.Saved[databaseName].Tables[tableName].Columns[mdbGetColumnIterator(databaseName, tableName, columnName)].values[dataIterator] = newData;
				end
			end
		elseif (isSaved == false) then
			if (isValid == true) then
				MyDatabase.Databases[databaseName].Tables[tableName].Columns[mdbGetColumnIterator(databaseName, tableName, columnName)].values[dataIterator] = newData;
			end
		end
	end
end

function mdbExists(databaseName, tableName, columnName)
	local databaseExists = false;
	local tableExists = false;
	local columnExists = false;

	if (MyDatabase.GlobalSaved[databaseName]) then
		databaseExists = true;
	elseif (MyDatabase.Saved[databaseName]) then
		databaseExists = true;
	elseif (MyDatabase.Databases[databaseName]) then
		databaseExists = true;
	end

	if (databaseExists == false) then
		return databaseExists, tableExists, columnExists;
	end

	if (not tableName or tableName == nil) then
		return databaseExists, tableExists, columnExists;
	end

	local isSaved, isGlobal = mdbIsSaved(databaseName);

	if (isSaved == true) then
		if (isGlobal == true) then
			if (MyDatabase.GlobalSaved[databaseName].Tables[tableName]) then
				tableExists = true;
			end
		end

		if (MyDatabase.Saved[databaseName].Tables[tableName]) then
			tableExists = true;
		end
	elseif (isSaved == false) then
		if (MyDatabase.Databases[databaseName].Tables[tableName]) then
			tableExists = true;
		end
	end

	if (tableExists == false) then
		return databaseExists, tableExists, columnExists;
	end

	if (not columnName or columnName == nil) then
		return databaseExists, tableExists, columnExists;
	end

	if (isSaved == true) then
		if (isGlobal == true) then
			for i = 1, table.maxn(MyDatabase.GlobalSaved[databaseName].Tables[tableName].Columns) do
				if (MyDatabase.GlobalSaved[databaseName].Tables[tableName].Columns[i].name == columnName) then
					columnExists = true;
					break;
				end
			end
		end

		for i = 1, table.maxn(MyDatabase.Saved[databaseName].Tables[tableName].Columns) do
			if (MyDatabase.Saved[databaseName].Tables[tableName].Columns[i].name == columnName) then
				columnExists = true;
				break;
			end
		end
	elseif (isSaved == false) then
		for i = 1, table.maxn(MyDatabase.Databases[databaseName].Tables[tableName].Columns) do
			if (MyDatabase.Databases[databaseName].Tables[tableName].Columns[i].name == columnName) then
				columnExists = true;
				break;
			end
		end
	end

	return databaseExists, tableExists, columnExists;
end

function mdbDatabaseExists(databaseName)
	return mdbExists(databaseName);
end

function mdbTableExists(databaseName, tableName)
	local databaseExists, tableExists = mdbExists(databaseName, tableName);

	return tableExists;
end

function mdbColumnExists(databaseName, tableName, columnName)
	local databaseExists, tableExists, columnExists = mdbExists(databaseName, tableName, columnName);

	return columnExists;
end

function mdbIsSaved(databaseName)
	if (MyDatabase.Saved and MyDatabase.Saved[databaseName]) then
		return true, false;
	elseif (MyDatabase.GlobalSaved and MyDatabase.GlobalSaved[databaseName]) then
		return true, true;
	end

	return false, false;
end

function mdbGetColumnIterator(databaseName, tableName, columnName)
	local isSaved, isGlobal = mdbIsSaved(databaseName);

	if (isSaved == true) then
		if (isGlobal == true) then
			for i = 1, table.maxn(MyDatabase.GlobalSaved[databaseName].Tables[tableName].Columns) do
				if (MyDatabase.GlobalSaved[databaseName].Tables[tableName].Columns[i].name == columnName) then
					return (i);
				end
			end
		end

		for i = 1, table.maxn(MyDatabase.Saved[databaseName].Tables[tableName].Columns) do
			if (MyDatabase.Saved[databaseName].Tables[tableName].Columns[i].name == columnName) then
				return (i);
			end
		end
	elseif (isSaved == false) then
		for i = 1, table.maxn(MyDatabase.Databases[databaseName].Tables[tableName].Columns) do
			if (MyDatabase.Databases[databaseName].Tables[tableName].Columns[i].name == columnName) then
				return (i);
			end
		end
	end

	return;
end

function mdbGetNumColumns(databaseName, tableName)
	local isSaved, isGlobal = mdbIsSaved(databaseName);

	if (isSaved == false) then
		return table.maxn(MyDatabase.Databases[databaseName].Tables[tableName].Columns);
	end

	if (isSaved == true) then
		if (isGlobal == true) then
			return table.maxn(MyDatabase.GlobalSaved[databaseName].Tables[tableName].Columns);
		end

		return table.maxn(MyDatabase.Saved[databaseName].Tables[tableName].Columns);
	end
end

function mdbGetNumValues(databaseName, tableName)
	local isSaved, isGlobal = mdbIsSaved(databaseName);

	if (isSaved == false) then
		return (table.maxn(MyDatabase.Databases[databaseName].Tables[tableName].Columns[1].values));
	end

	if (isSaved == true) then
		if (isGlobal == true) then
			return (table.maxn(MyDatabase.GlobalSaved[databaseName].Tables[tableName].Columns[1].values));
		end

		return (table.maxn(MyDatabase.Saved[databaseName].Tables[tableName].Columns[1].values));
	end
end

function mdbCreateColumnPacket(...)
	local result = {};

	for i = 1, select("#", ...) do
		local newMax = table.maxn(result) + 1;
		local s = select(i, ...);
		table.insert(result, newMax, s);
	end

	return (result);
end

function mdbCreateTablePacket(usingColumn, ...)
	local result = {};

	result.tables = {};
	result.usingColumn = usingColumn;

	for i = 1, select("#", ...) do
		local newMax = table.maxn(result.tables) + 1;
		local s = select(i, ...);
		table.insert(result.tables, newMax, s);
	end

	return (result);
end

function mdbCreateSearchPacket(column, operator, argument)
	local result = {};

	result.column = column;
	result.operator = operator;
	result.argument = argument;

	return (result);
end

function mdbHardSearchData(databaseName, tablesWanted, columnsWanted)
	local result = {};
	local columnsMax = table.maxn(columnsWanted);

	local isSaved, isGlobal = mdbIsSaved(databaseName);

	if (isSaved == false) then
		for dataIterator = 1, mdbGetNumValues(databaseName, tablesWanted.tables[1]) do
			table.insert(result, dataIterator, {});

			for i = 1, columnsMax do
				table.insert(result[dataIterator], i, MyDatabase.Databases[databaseName].Tables[tablesWanted.tables[1]].Columns[mdbGetColumnIterator(databaseName, tablesWanted.tables[1], columnsWanted[i])].values[dataIterator]);
			end
		end

		return result;
	end

	if (isSaved == true) then
		if (isGlobal == true) then
			for dataIterator = 1, mdbGetNumValues(databaseName, tablesWanted.tables[1]) do
				table.insert(result, dataIterator, {});

				for i = 1, columnsMax do
					table.insert(result[dataIterator], i, MyDatabase.GlobalSaved[databaseName].Tables[tablesWanted.tables[1]].Columns[mdbGetColumnIterator(databaseName, tablesWanted.tables[1], columnsWanted[i])].values[dataIterator]);
				end
			end

			return result;
		end

		for dataIterator = 1, mdbGetNumValues(databaseName, tablesWanted.tables[1]) do
			table.insert(result, dataIterator, {});

			for i = 1, columnsMax do
				table.insert(result[dataIterator], i, MyDatabase.Saved[databaseName].Tables[tablesWanted.tables[1]].Columns[mdbGetColumnIterator(databaseName, tablesWanted.tables[1], columnsWanted[i])].values[dataIterator]);
			end
		end

		return result;
	end
end
--/script local d,t,c = mdbExists("MyRolePlayCharacter", "Identification", "firstname");mduDisplayMessage(tostring(d)..":"..tosting(t)..":"..tostring(c));
function mdbSearchData(databaseName, tablesWanted, columnsWanted, ...)
	if (mdbDatabaseExists(databaseName) == false) then
		mduDisplayMessage(MDB_LOCALE_DATABASEDOESNOTEXIST_ERROR .. databaseName, MDB_NAME, .8, .8, 0, 1, 0, 0);

		return;
	end

	local result = {};
	local numOfResults = 0;

	local tablesMax = table.maxn(tablesWanted.tables);
	local columnsMax = table.maxn(columnsWanted);

	if (tablesMax >= 2 and tablesWanted.usingColumn ~= nil) then
		for tableIterator = 2, tablesMax do
			for dataIteratorMain = 1, mdbGetNumValues(databaseName, tablesWanted.tables[1]) do
				for dataIterator = 1, mdbGetNumValues(databaseName, tablesWanted.tables[tableIterator]) do
					local dataMain = mdbGetData(databaseName, tablesWanted.tables[1], tablesWanted.usingColumn, dataIteratorMain);
					local dataSecondary = mdbGetData(databaseName, tablesWanted.tables[tableIterator], tablesWanted.usingColumn, dataIterator);

					if (dataMain == dataSecondary) then
						local isValid = false;

						for i = 1, select("#", ...) do
							local s = select(i, ...);
							local searchData = mdbGetData(databaseName, tablesWanted.tables[tableIterator], s.column, dataIterator);

							if (searchData or searchData ~= nil) then
								if (select(i, ...).operator == "=") then
									if (searchData == select(i, ...).argument) then
										isValid = true;
									end
								end
								if (select(i, ...).operator == "~=") then
									if (searchData ~= select(i, ...).argument) then
										isValid = true;
									end
								end
								if (select(i, ...).operator == ">") then
									if (searchData > select(i, ...).argument) then
										isValid = true;
									end
								end
								if (select(i, ...).operator == "<") then
									if (searchData < select(i, ...).argument) then
										isValid = true;
									end
								end
								if (select(i, ...).operator == ">=") then
									if (searchData >= select(i, ...).argument) then
										isValid = true;
									end
								end
								if (select(i, ...).operator == "<=") then
									if (searchData <= select(i, ...).argument) then
										isValid = true;
									end
								end
							end

						end

						if (isValid == true) then

							numOfResults = numOfResults + 1;

							for columnIterator = 1, table.maxn(columnsWanted) do
								local tempData = mdbGetData(databaseName, tablesWanted.tables[tableIterator], columnsWanted[columnIterator], dataIterator);
								local tempDataMain = mdbGetData(databaseName, tablesWanted.tables[1], columnsWanted[columnIterator], dataIteratorMain);

								if (not result[numOfResults]) then
									table.insert(result, numOfResults, {});
								end

								local newMax = table.maxn(result[numOfResults]) + 1;
								table.insert(result[numOfResults], newMax, tempDataMain);

								newMax = table.maxn(result[numOfResults]) + 1;
								table.insert(result[numOfResults], newMax, tempData);
							end
						end
					end
				end
			end
		end
	end

	if (tablesMax == 1 and tablesWanted.usingColumn == nil) then
		for dataIterator = 1, mdbGetNumValues(databaseName, tablesWanted.tables[1]) do
			local isValid = false;

			for i = 1, select("#", ...) do
				local searchData = mdbGetData(databaseName, tablesWanted.tables[1], select(i, ...).column, dataIterator);

				if (select(i, ...).operator == "=") then
					if (searchData == select(i, ...).argument) then
						isValid = true;
					end
				end
				if (select(i, ...).operator == "~=") then
					if (searchData ~= select(i, ...).argument) then
						isValid = true;
					end
				end
				if (select(i, ...).operator == ">") then
					if (searchData > select(i, ...).argument) then
						isValid = true;
					end
				end
				if (select(i, ...).operator == "<") then
					if (searchData < select(i, ...).argument) then
						isValid = true;
					end
				end
				if (select(i, ...).operator == ">=") then
					if (searchData >= select(i, ...).argument) then
						isValid = true;
					end
				end
				if (select(i, ...).operator == "<=") then
					if (searchData <= select(i, ...).argument) then
						isValid = true;
					end
				end
			end

			if (isValid == true) then

				numOfResults = numOfResults + 1;

				for columnIterator = 1, columnsMax do
					local tempData = mdbGetData(databaseName, tablesWanted.tables[1], columnsWanted[columnIterator], dataIterator);

					if (not result[numOfResults]) then
						table.insert(result, numOfResults, {});
					end

					newMax = table.maxn(result[numOfResults]) + 1;
					table.insert(result[numOfResults], newMax, tempData);
				end
			end
		end
	end

	return (result);
end

function mdbGetData(databaseName, tableName, columnName, dataIterator)
	local isSaved, isGlobal = mdbIsSaved(databaseName);

	if (isSaved == false) then
		if (MyDatabase.Databases[databaseName].Tables[tableName].Columns[mdbGetColumnIterator(databaseName, tableName, columnName)].values[dataIterator]) then
			return (MyDatabase.Databases[databaseName].Tables[tableName].Columns[mdbGetColumnIterator(databaseName, tableName, columnName)].values[dataIterator]);
		end

		return MDB_NIL;
	end

	if (isSaved == true) then
		if (isGlobal == true) then
			if (MyDatabase.GlobalSaved[databaseName].Tables[tableName].Columns[mdbGetColumnIterator(databaseName, tableName, columnName)].values[dataIterator]) then
				return (MyDatabase.GlobalSaved[databaseName].Tables[tableName].Columns[mdbGetColumnIterator(databaseName, tableName, columnName)].values[dataIterator]);
			end

			return MDB_NIL;
		end

		if (MyDatabase.Saved[databaseName].Tables[tableName].Columns[mdbGetColumnIterator(databaseName, tableName, columnName)].values[dataIterator]) then
			return (MyDatabase.Saved[databaseName].Tables[tableName].Columns[mdbGetColumnIterator(databaseName, tableName, columnName)].values[dataIterator]);
		end

		return MDB_NIL;
	end
end
