function mrpSetOptionsCheckButtons()
	-- mrpDisplayMessage(mrpCheckSettings("Tooltip", "relativeLevel"));
	-- mrpDisplayMessage(mrpCheckSettings("Tooltip", "enabled"));
	-- mrpDisplayMessage(mrpCheckSettings("Addon Compatability", "FlagRSP2/ImmersionRP"));

	if (mrpCheckSettings("Tooltip", "relativeLevel") == false) then
		mrpRelativeLevelOptionButton:SetChecked(false);
	else
		mrpRelativeLevelOptionButton:SetChecked(true);
	end

	if (mrpCheckSettings("Tooltip", "enabled") == false) then
		mrpMRPTooltipOptionButton:SetChecked(false);
	else
		mrpMRPTooltipOptionButton:SetChecked(true);
	end
end

function mrpOptionRelativeClick()
	if (mrpCheckSettings("Tooltip", "relativeLevel") == false) then
		mrpChangeSettings("Tooltip", "relativeLevel", true);
		mrpDisplayMessage(MRP_LOCALE_Relative_Enabled);
	else
		mrpChangeSettings("Tooltip", "relativeLevel", false);
		mrpDisplayMessage(MRP_LOCALE_Relative_Disabled);
	end
end

function mrpOptionMRPTooltips()
	if (mrpCheckSettings("Tooltip", "enabled") == false) then
		mrpChangeSettings("Tooltip", "enabled", true);
		mrpDisplayMessage(MRP_LOCALE_Tooltips_MRPStyle_Enabled);
	else
		mrpChangeSettings("Tooltip", "enabled", false);
		mrpDisplayMessage(MRP_LOCALE_Tooltips_MRPStyle_Disabled);
	end
end
