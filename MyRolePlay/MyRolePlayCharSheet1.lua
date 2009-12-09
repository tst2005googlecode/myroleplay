function mrpCharSheet1NextPageButtonOnClick()
	if (mrpCharacterSheet1SecondPage:IsShown()) then
		mrpCharacterSheet1SecondPage:Hide();
		mrpCharacterSheet1ThirdPage:Show();
		mrpCharacterSheet1NextPageButton:Disable();
	end
	if (mrpCharacterSheet1FrontPage:IsShown()) then
		mrpCharacterSheet1FrontPage:Hide();
		mrpCharacterSheet1SecondPage:Show();
		mrpCharacterSheet1PrevPageButton:Enable();
	end
end

function mrpCharSheet1PrevPageButtonOnClick()
	if (mrpCharacterSheet1SecondPage:IsShown()) then
		mrpCharacterSheet1SecondPage:Hide();
		mrpCharacterSheet1FrontPage:Show();
		mrpCharacterSheet1PrevPageButton:Disable();
	end
	if (mrpCharacterSheet1ThirdPage:IsShown()) then
		mrpCharacterSheet1ThirdPage:Hide();
		mrpCharacterSheet1SecondPage:Show();
		mrpCharacterSheet1NextPageButton:Enable();
	end
end

function mrpCharSheet1UpdatePageButton()
	if (mrpCharacterSheet1ThirdPage:IsShown()) then
		mrpCharacterSheet1NextPageButton:Disable();
	end
	if (mrpCharacterSheet1FrontPage:IsShown()) then
		mrpCharacterSheet1PrevPageButton:Disable();
	end
end

function mrpCharacterSheet1UpdateInformation()
	local firstnametext	= MRP_EMPTY_STRING;
	local prefixtext	= MRP_EMPTY_STRING;
	local middlenametext	= MRP_EMPTY_STRING;
	local surnametext	= MRP_EMPTY_STRING;
	local leveltext		= MRP_EMPTY_STRING;
	local titletext		= MRP_EMPTY_STRING;
	local housetext		= MRP_EMPTY_STRING;
	local nicknametext	= MRP_EMPTY_STRING;
	local housetext		= MRP_EMPTY_STRING;
	local rpstattext	= MRP_LOCALE_No_Status;
	local charstattext	= MRP_LOCALE_No_Status;
	local desctext		= MRP_EMPTY_STRING;
	local eyecolourtext	= MRP_EMPTY_STRING;
	local emotiontext	= MRP_EMPTY_STRING;
	local heighttext	= MRP_EMPTY_STRING;
	local weighttext	= MRP_EMPTY_STRING;
	local homecitytext	= MRP_EMPTY_STRING;
	local birthcitytext	= MRP_EMPTY_STRING;
	local mottotext		= MRP_EMPTY_STRING;
	local historytext	= MRP_EMPTY_STRING;



	if (UnitName("target") == UnitName("player")) then
		local curProfile = mrpGetCurProfile();

		local identification = mdbSearchData("MyRolePlayCharacter", mdbCreateTablePacket(nil, "Identification"), mdbCreateColumnPacket("prefix", "firstname", "middlename", "surname", "title", "nickname", "housename"), mdbCreateSearchPacket("profile", "=", curProfile));
		local appearance = mdbSearchData("MyRolePlayCharacter", mdbCreateTablePacket(nil, "Appearance"), mdbCreateColumnPacket("eyeColour", "height", "weight", "currentEmotion", "description"), mdbCreateSearchPacket("profile", "=", curProfile));
		local lore = mdbSearchData("MyRolePlayCharacter", mdbCreateTablePacket(nil, "Lore"), mdbCreateColumnPacket("curHome", "birthPlace", "motto", "history"), mdbCreateSearchPacket("profile", "=", curProfile));
		local status = mdbSearchData("MyRolePlayCharacter", mdbCreateTablePacket(nil, "Status"), mdbCreateColumnPacket("roleplay", "character"), mdbCreateSearchPacket("profile", "=", curProfile));

		prefixtext, firstnametext, middlenametext, surnametext, titletext, nicknametext, housetext = unpack(identification[1]);
		eyecolourtext, heighttext, weighttext, emotiontext, desctext = unpack(appearance[1]);
		homecitytext, birthcitytext, mottotext, historytext = unpack(lore[1]);
		rpstattext, charstattext = unpack(status[1]);

		prefixtext = prefixtext .. " ";
		firstnametext = firstnametext .. " ";
		middlenametext = middlenametext .. " ";
	else
		if (mrpIsPlayerInList(UnitName("target")) == true) then
			local identification = mdbSearchData("MyRolePlayPlayerList", mdbCreateTablePacket(nil, "Identification"), mdbCreateColumnPacket("prefix", "firstname", "middlename", "surname", "title", "nickname", "housename"), mdbCreateSearchPacket("playerName", "=", UnitName("target")));
			local appearance = mdbSearchData("MyRolePlayPlayerList", mdbCreateTablePacket(nil, "Appearance"), mdbCreateColumnPacket("eyeColour", "height", "weight", "currentEmotion"), mdbCreateSearchPacket("playerName", "=", UnitName("target")));
			local lore = mdbSearchData("MyRolePlayPlayerList", mdbCreateTablePacket(nil, "Lore"), mdbCreateColumnPacket("curHome", "birthPlace", "motto"), mdbCreateSearchPacket("playerName", "=", UnitName("target")));
			local status = mdbSearchData("MyRolePlayPlayerList", mdbCreateTablePacket(nil, "Status"), mdbCreateColumnPacket("roleplay", "character"), mdbCreateSearchPacket("playerName", "=", UnitName("target")));

			prefixtext, firstnametext, middlenametext, surnametext, titletext, nicknametext, housetext = unpack(identification[1]);
			eyecolourtext, heighttext, weighttext, emotiontext = unpack(appearance[1]);
			homecitytext, birthcitytext, mottotext = unpack(lore[1]);
			rpstattext, charstattext = unpack(status[1]);

			if (mrpHaveDescription(UnitName("target")) == true) then
				desctext = mrpGetDescription(UnitName("target"));
			end

			if (mrpHaveHistory(UnitName("target")) == true) then
				historytext = mrpGetHistory(UnitName("target"));
			end

			prefixtext = prefixtext .. " ";
			firstnametext = firstnametext .. " ";
			middlenametext = middlenametext .. " ";
		else
			firstnametext = UnitName("target") .. " ";
		end
	end

	if (mrpCheckSettings("Tooltip", "relativeLevel") == true) then
		leveltext = (mrpRelativeLevelCheck(UnitLevel("target")));
	else
		leveltext = (MRP_LOCALE_CHARACTER_SHEET_LEVEL .. " " .. UnitLevel("target"));
	end

	rpstattext = mrpDecodeStatus(rpstattext);
	charstattext = mrpDecodeStatus(charstattext);

	mrpCharSheet1NameText:SetText(prefixtext .. firstnametext .. middlenametext .. surnametext);
	mrpCharSheet1LevelRaceClassText:SetText(leveltext .. " " .. UnitRace("target") .. " " .. UnitClass("target") .. MRP_EMPTY_STRING);
	mrpCharSheet1TitleText:SetText(titletext);
	mrpCharSheet1HouseText:SetText(housetext);
	mrpCharSheet1NicknameText:SetText(nicknametext);
	mrpCharSheet1RPStatText:SetText(rpstattext);
	mrpCharSheet1CharStatText:SetText(charstattext);
	mrpCharSheet1DescBox:SetText(desctext);
	mrpCharSheet1HistBox:SetText(historytext);
	mrpCharSheet1EyeColourText:SetText(eyecolourtext);
	mrpCharSheet1EmotionText:SetText(emotiontext);
	mrpCharSheet1HeightText:SetText(heighttext);
	mrpCharSheet1WeightText:SetText(weighttext);
	mrpCharSheet1MottoText:SetText(mottotext);
	mrpCharSheet1HomeCityText:SetText(homecitytext);
	mrpCharSheet1BirthCityText:SetText(birthcitytext);
	mrpCharacterSheet1HeaderText:SetText(firstnametext);

end

-- Note, this is a protected function, however, care is taken in the FrameXML code to minimise the bad effects of taint.
TargetFrame_CheckLevel = NewTargetFrame_CheckLevel;

function TargetFrame_CheckLevel (self)
	local targetLevel = UnitLevel(self.unit);
	
	if ( UnitIsCorpse(self.unit) ) then
		self.levelText:Hide();
		self.highLevelTexture:Show();
	elseif ( targetLevel > 0 ) then
		if (mrpCheckSettings("Tooltip", "relativeLevel") == true) then
			if (targetLevel == -1) then
				self.levelText:SetText(MRP_LOCALE_mrpRelative10hshort);
			elseif (targetLevel <= (UnitLevel("player") - 7)) then
				self.levelText:SetText(MRP_LOCALE_mrpRelative7lshort);
			elseif ( (targetLevel >= (UnitLevel("player")) - 6) and (targetLevel <= (UnitLevel("player") - 5  ))) then
				self.levelText:SetText(MRP_LOCALE_mrpRelative5to6lshort);
			elseif ( (targetLevel >= (UnitLevel("player")) - 4) and (targetLevel <= (UnitLevel("player") - 2  ))) then
				self.levelText:SetText(MRP_LOCALE_mrpRelative2to4lshort);
			elseif ( (targetLevel >= (UnitLevel("player")) - 1) and (targetLevel <= (UnitLevel("player") + 2  ))) then
				self.levelText:SetText(MRP_LOCALE_mrpRelative1to1hshort);
			elseif ( (targetLevel >= (UnitLevel("player")) + 2) and (targetLevel <= (UnitLevel("player") + 3  ))) then
				self.levelText:SetText(MRP_LOCALE_mrpRelative2to3hshort);
			elseif ( (targetLevel >= (UnitLevel("player")) + 4) and (targetLevel <= (UnitLevel("player") + 6  ))) then
				self.levelText:SetText(MRP_LOCALE_mrpRelative4to6hshort);
			elseif ( (targetLevel >= (UnitLevel("player")) + 7) and (targetLevel <= (UnitLevel("player") + 9  ))) then
				self.levelText:SetText(MRP_LOCALE_mrpRelative7to9hshort);
			else
				self.levelText:SetText(MRP_LOCALE_mrpRelative10hshort);
			end
		else
			-- Normal level target
			self.levelText:SetText(targetLevel);
		end
		-- Color level number
		if ( UnitCanAttack("player", self.unit) ) then
			local color = GetQuestDifficultyColor(targetLevel);
			self.levelText:SetVertexColor(color.r, color.g, color.b);
		else
			self.levelText:SetVertexColor(1.0, 0.82, 0.0);
		end
		self.levelText:Show();
		self.highLevelTexture:Hide();
	else
		-- Target is too high level to tell
		self.levelText:Hide();
		self.highLevelTexture:Show();
	end
	
	-- Let's update the MRP data for the target here. It may be redundant, however this will do.
	if (UnitName("target") == UnitName("player")) then
		TargetFrameTextureFrameName:SetText(mrpGetInfo("Identification", "firstname", mrpGetCurProfile()));
	elseif (mrpIsPlayerInList(UnitName("target") == true)) then
		TargetFrameTextureFrameName:SetText(mrpGetPlayerListInfo("Identification", "firstname", UnitName("target")));
	else
		TargetFrameTextureFrameName:SetText(UnitName("target"));
	end
end
