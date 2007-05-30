--[[ MyRolePlayDatabase.lua

	What it is:
		The file that contains the code for accessing, building, and destroying all of the database information in MyRolePlay.

]]

--mdbOpenConsole("CREATE DATABASE MyRolePlay CREATE DATABASE MyRolePlay");

function mrpCreateNewDatabase()

	mdbCreateDatabase("MyRolePlayCharacter", true, false);

	mdbCreateTable("MyRolePlayCharacter", "CurProfile");
		mdbAddColumn("MyRolePlayCharacter", "CurProfile", "name");

		mdbInsertData("MyRolePlayCharacter", "CurProfile", "Default");

	mdbCreateTable("MyRolePlayCharacter", "Identification");
		mdbAddColumn("MyRolePlayCharacter", "Identification", "profile");
		mdbAddColumn("MyRolePlayCharacter", "Identification", "prefix");
		mdbAddColumn("MyRolePlayCharacter", "Identification", "firstname");
		mdbAddColumn("MyRolePlayCharacter", "Identification", "middlename");
		mdbAddColumn("MyRolePlayCharacter", "Identification", "surname");
		mdbAddColumn("MyRolePlayCharacter", "Identification", "FamilyName");
		mdbAddColumn("MyRolePlayCharacter", "Identification", "title");
		mdbAddColumn("MyRolePlayCharacter", "Identification", "nickname");
		mdbAddColumn("MyRolePlayCharacter", "Identification", "housename");
		mdbAddColumn("MyRolePlayCharacter", "Identification", "Professions");
		mdbAddColumn("MyRolePlayCharacter", "Identification", "dateOfBirth");
		mdbAddColumn("MyRolePlayCharacter", "Identification", "deity");

	mdbCreateTable("MyRolePlayCharacter", "Appearance");
		mdbAddColumn("MyRolePlayCharacter", "Appearance", "profile");
		mdbAddColumn("MyRolePlayCharacter", "Appearance", "eyeColour");
		mdbAddColumn("MyRolePlayCharacter", "Appearance", "height");
		mdbAddColumn("MyRolePlayCharacter", "Appearance", "weight");
		mdbAddColumn("MyRolePlayCharacter", "Appearance", "apparentAge");
		mdbAddColumn("MyRolePlayCharacter", "Appearance", "currentEmotion");
		mdbAddColumn("MyRolePlayCharacter", "Appearance", "description");

	mdbCreateTable("MyRolePlayCharacter", "Lore");
		mdbAddColumn("MyRolePlayCharacter", "Lore", "profile");
		mdbAddColumn("MyRolePlayCharacter", "Lore", "curHome");
		mdbAddColumn("MyRolePlayCharacter", "Lore", "birthPlace");
		mdbAddColumn("MyRolePlayCharacter", "Lore", "motto");
		mdbAddColumn("MyRolePlayCharacter", "Lore", "history");

	mdbCreateTable("MyRolePlayCharacter", "Status");
		mdbAddColumn("MyRolePlayCharacter", "Status", "profile");
		mdbAddColumn("MyRolePlayCharacter", "Status", "roleplay");
		mdbAddColumn("MyRolePlayCharacter", "Status", "character");

	mdbCreateTable("MyRolePlayCharacter", "Character");
		mdbAddColumn("MyRolePlayCharacter", "Character", "profile");
		mdbAddColumn("MyRolePlayCharacter", "Character", "Race");

	mdbCreateTable("MyRolePlayCharacter", "GuildInfo");
		mdbAddColumn("MyRolePlayCharacter", "GuildInfo", "GuildAllianceID");
		mdbAddColumn("MyRolePlayCharacter", "GuildInfo", "myGuildId");

	mdbCreateTable("MyRolePlayCharacter", "PetInfo");
		mdbAddColumn("MyRolePlayCharacter", "PetInfo", "profile");

	mdbCreateTable("MyRolePlayCharacter", "Achievements");
		mdbAddColumn("MyRolePlayCharacter", "Achievements", "profile");

	mdbCreateTable("MyRolePlayCharacter", "OocInfo");
		mdbAddColumn("MyRolePlayCharacter", "OocInfo", "profile");
		mdbAddColumn("MyRolePlayCharacter", "OocInfo", "info");

	mdbInsertData("MyRolePlayCharacter", "Identification", "Default", "", UnitName("player"), "", "", "", "", "", "" ,"" ,"" ,"");
	mdbInsertData("MyRolePlayCharacter", "Appearance", "Default", "", "", "", "", "", "");
	mdbInsertData("MyRolePlayCharacter", "Lore", "Default", "", "", "", "");
	mdbInsertData("MyRolePlayCharacter", "Status", "Default", "RP0", "CS0");
	mdbInsertData("MyRolePlayCharacter", "Character", "Default", "");
	mdbInsertData("MyRolePlayCharacter", "PetInfo", "Default");
	mdbInsertData("MyRolePlayCharacter", "Achievements", "Default");
	mdbInsertData("MyRolePlayCharacter", "OocInfo", "Default", "");

end
--/script mduDisplayMessage(mdbGetData("MyRolePlayCharacter", "Identification", "prefix", 1));
function mrpInitializeRAM()
	mdbCreateDatabase("MyRolePlayPlayerList", false, false);

	mdbCreateTable("MyRolePlayPlayerList", "Misc");
		mdbAddColumn("MyRolePlayPlayerList", "Misc", "playerName");
		mdbAddColumn("MyRolePlayPlayerList", "Misc", "hasInfo");
		mdbAddColumn("MyRolePlayPlayerList", "Misc", "channel");
		mdbAddColumn("MyRolePlayPlayerList", "Misc", "version");
		mdbAddColumn("MyRolePlayPlayerList", "Misc", "supports");

	mdbCreateTable("MyRolePlayPlayerList", "Identification");
		mdbAddColumn("MyRolePlayPlayerList", "Identification", "playerName");
		mdbAddColumn("MyRolePlayPlayerList", "Identification", "prefix");
		mdbAddColumn("MyRolePlayPlayerList", "Identification", "firstname");
		mdbAddColumn("MyRolePlayPlayerList", "Identification", "middlename");
		mdbAddColumn("MyRolePlayPlayerList", "Identification", "surname");
		mdbAddColumn("MyRolePlayPlayerList", "Identification", "FamilyName");
		mdbAddColumn("MyRolePlayPlayerList", "Identification", "title");
		mdbAddColumn("MyRolePlayPlayerList", "Identification", "nickname");
		mdbAddColumn("MyRolePlayPlayerList", "Identification", "housename");
		mdbAddColumn("MyRolePlayPlayerList", "Identification", "dateOfBirth");
		mdbAddColumn("MyRolePlayPlayerList", "Identification", "deity");

	mdbCreateTable("MyRolePlayPlayerList", "Appearance");
		mdbAddColumn("MyRolePlayPlayerList", "Appearance", "playerName");
		mdbAddColumn("MyRolePlayPlayerList", "Appearance", "eyeColour");
		mdbAddColumn("MyRolePlayPlayerList", "Appearance", "height");
		mdbAddColumn("MyRolePlayPlayerList", "Appearance", "weight");
		mdbAddColumn("MyRolePlayPlayerList", "Appearance", "apparentAge");
		mdbAddColumn("MyRolePlayPlayerList", "Appearance", "currentEmotion");

	mdbCreateTable("MyRolePlayPlayerList", "Lore");
		mdbAddColumn("MyRolePlayPlayerList", "Lore", "playerName");
		mdbAddColumn("MyRolePlayPlayerList", "Lore", "curHome");
		mdbAddColumn("MyRolePlayPlayerList", "Lore", "birthPlace");
		mdbAddColumn("MyRolePlayPlayerList", "Lore", "motto");

	mdbCreateTable("MyRolePlayPlayerList", "Status");
		mdbAddColumn("MyRolePlayPlayerList", "Status", "playerName");
		mdbAddColumn("MyRolePlayPlayerList", "Status", "roleplay");
		mdbAddColumn("MyRolePlayPlayerList", "Status", "character");

	mdbCreateTable("MyRolePlayPlayerList", "Character");
		mdbAddColumn("MyRolePlayPlayerList", "Character", "playerName");
		mdbAddColumn("MyRolePlayPlayerList", "Character", "Race");

	mdbCreateTable("MyRolePlayPlayerList", "PetInfo");
		mdbAddColumn("MyRolePlayPlayerList", "PetInfo", "playerName");

	mdbCreateTable("MyRolePlayPlayerList", "OocInfo");
		mdbAddColumn("MyRolePlayPlayerList", "OocInfo", "playerName");
		mdbAddColumn("MyRolePlayPlayerList", "OocInfo", "info");
end

function mrpInitializeExtras()
	if (mdbDatabaseExists("MyRolePlayRaces") == false) then
		mdbCreateDatabase("MyRolePlayRaces", true, false);

		mdbCreateTable("MyRolePlayRaces", "Races");
			mdbAddColumn("MyRolePlayRaces", "Races", "id");
			mdbAddColumn("MyRolePlayRaces", "Races", "name");
			mdbAddColumn("MyRolePlayRaces", "Races", "description");
			mdbAddColumn("MyRolePlayRaces", "Races", "abilities");
			mdbAddColumn("MyRolePlayRaces", "Races", "lore");

		mrpNumberOfRaces = 0;

		mrpAddRace(MRP_LOCALE_RACE_HUMAN);
		mrpAddRace(MRP_LOCALE_RACE_NIGHTELF);
		mrpAddRace(MRP_LOCALE_RACE_DWARF);
		mrpAddRace(MRP_LOCALE_RACE_GNOME);
		mrpAddRace(MRP_LOCALE_RACE_DRAENEI);
		mrpAddRace(MRP_LOCALE_RACE_ORC);
		mrpAddRace(MRP_LOCALE_RACE_BLOODELF);
		mrpAddRace(MRP_LOCALE_RACE_TAUREN);
		mrpAddRace(MRP_LOCALE_RACE_UNDEAD);
		mrpAddRace(MRP_LOCALE_RACE_TROLL);
	else
		local temp = mdbSearchData("MyRolePlayRaces", mdbCreateTablePacket("Races"), mdbCreateColumnPacket("id"), mdbCreateSearchPacket("id", ">", "-1"));
		mrpNumberOfRaces = table.maxn(temp);
	end

	if (mdbDatabaseExists("MyRolePlayClasses") == false) then
		mdbCreateDatabase("MyRolePlayClasses", true, false);

		mdbCreateTable("MyRolePlayClasses", "Classes");
			mdbAddColumn("MyRolePlayClasses", "Classes", "id");
			mdbAddColumn("MyRolePlayClasses", "Classes", "name");
			mdbAddColumn("MyRolePlayClasses", "Classes", "description");
			mdbAddColumn("MyRolePlayClasses", "Classes", "abilities");
			mdbAddColumn("MyRolePlayClasses", "Classes", "lore");

		mrpNumberOfClasses = 0;

		mrpAddClass(MRP_LOCALE_CLASS_WARRIOR);
		mrpAddClass(MRP_LOCALE_CLASS_ROGUE);
		mrpAddClass(MRP_LOCALE_CLASS_MAGE);
		mrpAddClass(MRP_LOCALE_CLASS_SHAMAN);
		mrpAddClass(MRP_LOCALE_CLASS_HUNTER);
		mrpAddClass(MRP_LOCALE_CLASS_PALADIN);
		mrpAddClass(MRP_LOCALE_CLASS_DRUID);
		mrpAddClass(MRP_LOCALE_CLASS_WARLOCK);
		mrpAddClass(MRP_LOCALE_CLASS_PRIEST);
	else
		temp = mdbSearchData("MyRolePlayClasses", mdbCreateTablePacket("Classes"), mdbCreateColumnPacket("id"), mdbCreateSearchPacket("id", ">", "-1"));
		mrpNumberOfClasses = table.maxn(temp);
	end

	if (mdbDatabaseExists("MyRolePlaySettings") == false) then
		mdbCreateDatabase("MyRolePlaySettings", true, false);

		mrpAddSettingField("Colours");
			mrpAddSetting("Colours", "enabled", false);
			mrpAddSetting("Colours", "classEnabled", false);
			mrpAddSetting("Colours", "raceEnabled", false);

		mrpAddSettingField("Tooltip");
			mrpAddSetting("Tooltip", "enabled", true);
			mrpAddSetting("Tooltip", "relativeLevel", false);
			mrpAddSetting("Tooltip", "currentOrder", "default");

		mrpAddSettingField("Addon Compatability");
			mrpAddAddonCompatability("FlagRSP2/ImmersionRP");
			--mrpAddAddonCompatability("Outfitter");
	end

  if (not mrpSettingFieldExists("Addon Compatability")) then
		mrpAddSettingField("Addon Compatability");
  		mrpAddAddonCompatability("FlagRSP2/ImmersionRP");
			--mrpAddAddonCompatability("Outfitter");
  end
  

	if (mdbDatabaseExists("MyRolePlayTooltip") == false) then
		mdbCreateDatabase("MyRolePlayTooltip", true, false);

		mdbCreateTable("MyRolePlayTooltip", "Orders");
			mdbAddColumn("MyRolePlayTooltip", "Orders", "id");
			mdbAddColumn("MyRolePlayTooltip", "Orders", "name");
			mdbAddColumn("MyRolePlayTooltip", "Orders", "table");

			mrpCreateDefaultTooltip();
	end
end
---------------------------------------------------------------------------------

function mrpAddRace(raceName)
	mrpNumberOfRaces = mrpNumberOfRaces + 1;

	mdbInsertData("MyRolePlayRaces", "Races", mrpNumberOfRaces, raceName);
end

function mrpEditRace(raceName, toEdit, data)

end

function mrpAddClass(className)
	mrpNumberOfClasses = mrpNumberOfClasses + 1;

	mdbInsertData("MyRolePlayClasses", "Classes", mrpNumberOfClasses, className);
end

function mrpEditClass(className, toEdit, data)

end

MyRolePlay = {};
MyRolePlay.Settings = {};
MyRolePlay.Settings.Colours = {};
MyRolePlay.Settings.Tooltip = {};
MyRolePlay.Settings.Colours.Saved = {};

	MyRolePlay.Settings.Colours.Enabled = 1;
	MyRolePlay.Settings.Colours.PrefixNonPvp = { red = 0.5, green = 0.5, blue = 1.0 };
	MyRolePlay.Settings.Colours.PrefixPvp = { red = 0, green = 0.6, blue = 0 };
	MyRolePlay.Settings.Colours.FirstnameNonPvp = { red = 0.5, green = 0.5, blue = 1.0 };
	MyRolePlay.Settings.Colours.FirstnamePvp = { red = 0, green = 0.6, blue = 0 };
	MyRolePlay.Settings.Colours.MiddlenameNonPvp = { red = 0.5, green = 0.5, blue = 1.0 };
	MyRolePlay.Settings.Colours.MiddlenamePvp = { red = 0, green = 0.6, blue = 0 };
	MyRolePlay.Settings.Colours.SurnameNonPvp = { red = 0.5, green = 0.5, blue = 1.0 };
	MyRolePlay.Settings.Colours.SurnamePvp = { red = 0, green = 0.6, blue = 0 };
	MyRolePlay.Settings.Colours.EnemyNonPvp = { red = 0.5, green = 0.5, blue = 1.0 };
	MyRolePlay.Settings.Colours.EnemyPvpHostile = { red = 1.0, green = 0, blue = 0 };
	MyRolePlay.Settings.Colours.EnemyPvpNotHostile = { red = 1.0, green = 1.0, blue = 0.0 };
	MyRolePlay.Settings.Colours.FactionHorde = { red = 1.0, green = 0.0, blue = 0.0 };
	MyRolePlay.Settings.Colours.FactionAlliance = { red = 0.3, green = 0.3, blue = 1.0 };
	MyRolePlay.Settings.Colours.Title = { red = 1.0, green = 1.0, blue = 1.0 };
	MyRolePlay.Settings.Colours.Guild = { red = 1.0, green = 1.0, blue = 1.0 };
	MyRolePlay.Settings.Colours.Level = { red = 1.0, green = 1.0, blue = 0 };
	MyRolePlay.Settings.Colours.Class = { red = 1.0, green = 1.0, blue = 0 };
	MyRolePlay.Settings.Colours.Race = { red = 1.0, green = 1.0, blue = 0 };
	MyRolePlay.Settings.Colours.HouseName = { red = 1.0, green = 1.0, blue = 1.0 };
	MyRolePlay.Settings.Colours.Roleplay = { red = 1.0, green = 1.0, blue = 0.6 };
	MyRolePlay.Settings.Colours.CharacterText = { red = 1.0, green = 1.0, blue = 1.0 };
	MyRolePlay.Settings.Colours.CharacterStat = { red = 1.0, green = 1.0, blue = 0.6 };
	MyRolePlay.Settings.Colours.Nickname = { red = 1.0, green = 1.0, blue = 1.0 };
	MyRolePlay.Settings.Colours.FriendlyPvp = { red = 0, green = 0.6, blue = 0 };
	MyRolePlay.Settings.Colours.EnemyPvp = { red = 1.0, green = 0, blue = 0 };

	MyRolePlay.Settings.Colours.ClassSpecific = {};
	MyRolePlay.Settings.Colours.ClassSpecific.Rogue = { red = 1.0, green = 1.0, blue = 0 };
	MyRolePlay.Settings.Colours.ClassSpecific.Warrior = { red = 1.0, green = 1.0, blue = 0 };
	MyRolePlay.Settings.Colours.ClassSpecific.Priest = { red = 1.0, green = 1.0, blue = 0 };
	MyRolePlay.Settings.Colours.ClassSpecific.Mage = { red = 1.0, green = 1.0, blue = 0 };
	MyRolePlay.Settings.Colours.ClassSpecific.Shaman = { red = 1.0, green = 1.0, blue = 0 };
	MyRolePlay.Settings.Colours.ClassSpecific.Paladin = { red = 1.0, green = 1.0, blue = 0 };
	MyRolePlay.Settings.Colours.ClassSpecific.Druid = { red = 1.0, green = 1.0, blue = 0 };
	MyRolePlay.Settings.Colours.ClassSpecific.Warlock = { red = 1.0, green = 1.0, blue = 0 };
	MyRolePlay.Settings.Colours.ClassSpecific.Hunter = { red = 1.0, green = 1.0, blue = 0 };

	MyRolePlay.Settings.Colours.RaceSpecific = {};
	MyRolePlay.Settings.Colours.RaceSpecific.Human = { red = 1.0, green = 1.0, blue = 0 };
	MyRolePlay.Settings.Colours.RaceSpecific.Gnome = { red = 1.0, green = 1.0, blue = 0 };
	MyRolePlay.Settings.Colours.RaceSpecific.Dwarf = { red = 1.0, green = 1.0, blue = 0 };
	MyRolePlay.Settings.Colours.RaceSpecific.NightElf = { red = 1.0, green = 1.0, blue = 0 };
	MyRolePlay.Settings.Colours.RaceSpecific.Draenei = { red = 1.0, green = 1.0, blue = 0 };
	MyRolePlay.Settings.Colours.RaceSpecific.Orc = { red = 1.0, green = 1.0, blue = 0 };
	MyRolePlay.Settings.Colours.RaceSpecific.Troll = { red = 1.0, green = 1.0, blue = 0 };
	MyRolePlay.Settings.Colours.RaceSpecific.Tauren = { red = 1.0, green = 1.0, blue = 0 };
	MyRolePlay.Settings.Colours.RaceSpecific.Undead = { red = 1.0, green = 1.0, blue = 0 };
	MyRolePlay.Settings.Colours.RaceSpecific.BloodElf = { red = 1.0, green = 1.0, blue = 0 };

	MyRolePlay.Settings.Colours.Saved.PrefixNonPvp = { red = 0.5, green = 0.5, blue = 1.0 };
	MyRolePlay.Settings.Colours.Saved.PrefixPvp = { red = 0, green = 0.6, blue = 0 };
	MyRolePlay.Settings.Colours.Saved.FirstnameNonPvp = { red = 0.5, green = 0.5, blue = 1.0 };
	MyRolePlay.Settings.Colours.Saved.FirstnamePvp = { red = 0, green = 0.6, blue = 0 };
	MyRolePlay.Settings.Colours.Saved.MiddlenameNonPvp = { red = 0.5, green = 0.5, blue = 1.0 };
	MyRolePlay.Settings.Colours.Saved.MiddlenamePvp = { red = 0, green = 0.6, blue = 0 };
	MyRolePlay.Settings.Colours.Saved.SurnameNonPvp = { red = 0.5, green = 0.5, blue = 1.0 };
	MyRolePlay.Settings.Colours.Saved.SurnamePvp = { red = 0, green = 0.6, blue = 0 };
	MyRolePlay.Settings.Colours.Saved.EnemyNonPvp = { red = 0.5, green = 0.5, blue = 1.0 };
	MyRolePlay.Settings.Colours.Saved.EnemyPvpHostile = { red = 1.0, green = 0, blue = 0 };
	MyRolePlay.Settings.Colours.Saved.EnemyPvpNotHostile = { red = 1.0, green = 1.0, blue = 0.0 };
	MyRolePlay.Settings.Colours.Saved.FactionHorde = { red = 1.0, green = 0.0, blue = 0.0 };
	MyRolePlay.Settings.Colours.Saved.FactionAlliance = { red = 0.3, green = 0.3, blue = 1.0 };
	MyRolePlay.Settings.Colours.Saved.Title = { red = 1.0, green = 1.0, blue = 1.0 };
	MyRolePlay.Settings.Colours.Saved.Guild = { red = 1.0, green = 1.0, blue = 1.0 };
	MyRolePlay.Settings.Colours.Saved.Level = { red = 1.0, green = 1.0, blue = 0 };
	MyRolePlay.Settings.Colours.Saved.Class = { red = 1.0, green = 1.0, blue = 0 };
	MyRolePlay.Settings.Colours.Saved.Race = { red = 1.0, green = 1.0, blue = 0 };
	MyRolePlay.Settings.Colours.Saved.HouseName = { red = 1.0, green = 1.0, blue = 1.0 };
	MyRolePlay.Settings.Colours.Saved.Roleplay = { red = 1.0, green = 1.0, blue = 0.6 };
	MyRolePlay.Settings.Colours.Saved.CharacterText = { red = 1.0, green = 1.0, blue = 1.0 };
	MyRolePlay.Settings.Colours.Saved.CharacterStat = { red = 1.0, green = 1.0, blue = 0.6 };
	MyRolePlay.Settings.Colours.Saved.Nickname = { red = 1.0, green = 1.0, blue = 1.0 };
	MyRolePlay.Settings.Colours.Saved.FriendlyPvp = { red = 0, green = 0.6, blue = 0 };
	MyRolePlay.Settings.Colours.Saved.EnemyPvp = { red = 1.0, green = 0, blue = 0 };


	--[[
	This next bit of code, MRP_CONDITIONAL_NEWLINE is another global tooltip type. Though it is special.
	It is a table that holds the information to create a conditional. This means that this newline will ONLY
	display IF its conditions are met. Here is an explaination of those conditions:

	Value - The value table holds information that tells the tooltip what to look for. If it finds any of these values
		within its given distance and direction (see below), it will display a newline in the tooltip.

	Distance - The amount of lines that the tooltip is to look in relavance to itself for the values.

	Type - 1 means look after the current location by [distance] rows. 0 means look before.
	]]



--[[FamilyName(Id)
	Id(familyName, RelativesList)
		RelativesList(Username)
			Username(RelativeName)
				RelativeName(firstName, middleName, surName, relativeType)
]]--[[
function mrpInitializeFamilyNameTable()
	MyRolePlay.Identification.FamilyName = {};
	MyRolePlay.Identification.FamilyName.myFamilyId = mrpGenerateNewId();
	MyRolePlay.Identification.FamilyName[MyRolePlay.Identification.FamilyName.myFamilyId] = {};
	MyRolePlay.Identification.FamilyName[MyRolePlay.Identification.FamilyName.myFamilyId].familyName = MRP_LOCALE_DEFAULT_FAMILYNAME;
	MyRolePlay.Identification.FamilyName[MyRolePlay.Identification.FamilyName.myFamilyId].RelativesList = {};
	MyRolePlay.Identification.FamilyName[MyRolePlay.Identification.FamilyName.myFamilyId].RelativesList[UnitName("player")] = {};
	MyRolePlay.Identification.FamilyName[MyRolePlay.Identification.FamilyName.myFamilyId].RelativesList[UnitName("player")][MyRolePlay.Identification.firstname] = {};
	MyRolePlay.Identification.FamilyName[MyRolePlay.Identification.FamilyName.myFamilyId].RelativesList[UnitName("player")][MyRolePlay.Identification.firstname].firstname = MyRolePlay.Identification.firstname;
	MyRolePlay.Identification.FamilyName[MyRolePlay.Identification.FamilyName.myFamilyId].RelativesList[UnitName("player")][MyRolePlay.Identification.firstname].middlename = MyRolePlay.Identification.middlename;
	MyRolePlay.Identification.FamilyName[MyRolePlay.Identification.FamilyName.myFamilyId].RelativesList[UnitName("player")][MyRolePlay.Identification.firstname].surname = MyRolePlay.Identification.surname;
	MyRolePlay.Identification.FamilyName[MyRolePlay.Identification.FamilyName.myFamilyId].RelativesList[UnitName("player")][MyRolePlay.Identification.firstname].relativeType = MRP_LOCALE_FAMILYTYPE_ME;
end
]]
--[[Professions(Id)
	Id(professionName, professionDescription, skillLevel, SkillList)
		SkillList(Id)
			Id(skillName, skillDescription, difficultyLevel, LinkedCreateItem, LinkedReagents)
				LinkedCreateItem(Item, itemName)
				LinkedReagents(Index)
					Index(Item, itemNames)
]]--[[
function mrpInitializeProfessionsTable()
	MyRolePlay.Identification.Professions = {};
end
]]

--[[GuildInfo(GuildAllianceID, myGuildId)
	GuildAllianceID(guildAllianceName, GuildList, guildAllianceRank)
		GuildList()
]]--[[
function mrpInitializeGuildInfoTable()
	MyRolePlay.GuildInfo.myGuildId = MRP_GUILDALLIANCE_NONE_ID;
	MyRolePlay.GuildInfo.[MRP_GUILDALLIANCE_NONE_ID] = {};
	MyRolePlay.GuildInfo.[MRP_GUILDALLIANCE_NONE_ID].guildAllianceName = MRP_LOCALE_GUILDALLIANCE_NAME_NONE;
	MyRolePlay.GuildInfo.[MRP_GUILDALLIANCE_NONE_ID].GuildList = {};
	MyRolePlay.GuildInfo.[MRP_GUILDALLIANCE_NONE_ID].guildAllianceRank = MRP_EMPTY_STRING;
end]]
