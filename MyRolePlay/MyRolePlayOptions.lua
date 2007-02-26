function mrpSetOptionsCheckButtons()
	mrpDisplayMessage(mrpCheckSettings("Tooltip", "relativeLevel"));
	mrpDisplayMessage(mrpCheckSettings("Tooltip", "enabled"));
	mprDisplayMessage(mrpCheckSettings("Tooltip", "mouse"));

	if (mrpCheckSettings("Tooltip", "relativeLevel") == false) then
		mrpRelativeLevelOptionButton:SetChecked(false);
	else
		mrpRelativeLevelOptionButton:SetChecked(true);
	end

	if (mrpCheckSettings("Tooltip", "enabled") == false) then
		mrpMRPTooltipOptionButton:SetChecked(nil);
	else
		mrpMRPTooltipOptionButton:SetChecked(1);
	end
	
	if (mrpCheckSettings("Tooltip", "mouse") == true) then
  		mrpMRPTooltipRelocateButton:SetChecked(true);
	else
	    mrpMRPTooltipRelocateButton:SetChecked(false)
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

function mrpOptionMouseTooltip()
	if (mrpCheckSettings("Tooltip", "mouse") == false) then
		mrpChangeSettings("Tooltip", "mouse", true);
		MRPTooltipPlacing = "MOUSE";
		mrpDisplayMessage(MRP_LOCALE_MouseTooltip_Enabled);
		
	else
		mrpChangeSettings("Tooltip", "mouse", false);
		MRPTooltipPlacing = "RIGHT"
		mrpDisplayMessage(MRP_LOCALE_MouseTooltip_Disabled);
	end
end
