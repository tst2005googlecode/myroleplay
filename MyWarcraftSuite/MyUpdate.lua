--[[ MyRolePlayHeader.lua

	What it is:
		This file initializes all of the constants, variables, tables, etc... that will be used throughout the addon.

]]

----------------------------------------------------------------------------
--				CONSTANTS				  --
----------------------------------------------------------------------------

mrpMessageToSend = 1;

-- 0 = before
-- 1 = after
-- 2 = always
-- 3 = both
MRP_TOOLTIP_TEXT_BEFORE = 0;
MRP_TOOLTIP_TEXT_AFTER = 1;
MRP_TOOLTIP_TEXT_ALWAYS = 2;
MRP_TOOLTIP_TEXT_BOTH = 3;



MRP_ALWAYS_DECLINE = 0;
MRP_ALWAYS_ALLOW = 1;
MRP_PROMPT = 2;


mrpSendDataFlagRSPInit = 0;
mrpSendDataInit = 1;

mrpCurrentTarget = MRP_EMPTY_STRING;

MRP_GUILDALLIANCE_NONE_ID = 0;

-- This is the list of global constants that define what kind of information is to be displayed
-- on the current slot in a tooltip.
MRP_EMPTY = 0;
MRP_NEWLINE = 3;
MRP_PREFIX = 4;
MRP_FIRSTNAME = 5;
MRP_MIDDLENAME = 6;
MRP_SURNAME = 7;
MRP_TITLE = 8;
MRP_HOUSENAME = 9;
MRP_NICKNAME = 10;
MRP_GUILDRANK = 11;
MRP_PVPRANK = 12;
MRP_PVPSTATUS = 13;
MRP_LEVEL = 14;
MRP_CLASS = 15;
MRP_RACE = 16;
MRP_RPSTYLE = 17;
MRP_CSSTATUS = 18;
MRP_UNITNAME = 19;
MRP_EYECOLOUR = 20;
MRP_HEIGHT = 21;
MRP_WEIGHT = 22;
MRP_CURRENT_EMOTION = 23;
MRP_HOMECITY = 24;
MRP_BIRTHCITY = 25;
MRP_AGE = 26;
MRP_BIRTHDATE = 27;
MRP_MOTTO = 28;
MRP_GUILD = 29;
----------------------------------------------------------------------------
--				VARIABLES				  --
----------------------------------------------------------------------------

-- Options Variables --
mrpTooltipsEnabled = 1;


mrpUniversalFrameState = 0; -- 0 = CharacterFrame is not visible, 1 = it is visible.

mrpEnterInformationLocation = nil; -- To do with the input for variables.

--Tooltip.lua
mrpPrevOffset = 1;

mrpCurrentRowBeingEdited = nil;

--Colours.lua
mrpColourEdit = 0

mrpHexStart = "|CFF";
mrpHexEnd = "|r"

mrpColours = {};

mrpColours.PrefixNonPvp = { red = 0.5, green = 0.5, blue = 1.0 };
mrpColours.PrefixPvp = { red = 0, green = 0.6, blue = 0 };
mrpColours.FirstnameNonPvp = { red = 0.5, green = 0.5, blue = 1.0 };
mrpColours.FirstnamePvp = { red = 0, green = 0.6, blue = 0 };
mrpColours.MiddlenameNonPvp = { red = 0.5, green = 0.5, blue = 1.0 };
mrpColours.MiddlenamePvp = { red = 0, green = 0.6, blue = 0 };
mrpColours.SurnameNonPvp = { red = 0.5, green = 0.5, blue = 1.0 };
mrpColours.SurnamePvp = { red = 0, green = 0.6, blue = 0 };
mrpColours.EnemyNonPvp = { red = 0.5, green = 0.5, blue = 1.0 };
mrpColours.EnemyPvpHostile = { red = 1.0, green = 0, blue = 0 };
mrpColours.EnemyPvpNotHostile = { red = 1.0, green = 1.0, blue = 0.0 };
mrpColours.FactionHorde = { red = 1.0, green = 0.0, blue = 0.0 };
mrpColours.FactionAlliance = { red = 0.3, green = 0.3, blue = 1.0 };
mrpColours.Title = { red = 1.0, green = 1.0, blue = 1.0 };
mrpColours.Guild = { red = 1.0, green = 1.0, blue = 1.0 };
mrpColours.Level = { red = 1.0, green = 1.0, blue = 0 };
mrpColours.Class = { red = 1.0, green = 1.0, blue = 0 };
mrpColours.Race = { red = 1.0, green = 1.0, blue = 0 };
mrpColours.HouseName = { red = 1.0, green = 1.0, blue = 1.0 };
mrpColours.Roleplay = { red = 1.0, green = 1.0, blue = 0.6 };
mrpColours.CharacterText = { red = 1.0, green = 1.0, blue = 1.0 };
mrpColours.CharacterStat = { red = 1.0, green = 1.0, blue = 0.6 };
mrpColours.Nickname = { red = 1.0, green = 1.0, blue = 1.0 };
mrpColours.FriendlyPvp = { red = 0, green = 0.6, blue = 0 };
mrpColours.EnemyPvp = { red = 1.0, green = 0, blue = 0 };

----------------------------------------------------------------------------
--				 TABLES					  --
----------------------------------------------------------------------------