--[[ MyRolePlayHeader.lua

	What it is:
		This file initializes all of the constants, variables, tables, etc... that will be used throughout the addon.

]]

----------------------------------------------------------------------------
--				CONSTANTS				  --
----------------------------------------------------------------------------


-- 0 = before
-- 1 = after
-- 2 = always
-- 3 = both


-- This is the list of global constants that define what kind of information is to be displayed
-- on the current slot in a tooltip.

----------------------------------------------------------------------------
--				VARIABLES				  --
----------------------------------------------------------------------------

-- Options Variables --

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