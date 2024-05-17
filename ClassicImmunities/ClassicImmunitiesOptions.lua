function CICreateOptions(db, globalSettings)
	local CIOptionsFrame = CreateFrame("Frame")
	CIOptionsFrame.name = "Classic Immunities"
	
	local ci_category = Settings.RegisterCanvasLayoutCategory(CIOptionsFrame, CIOptionsFrame.name);
	ci_category.ID = CIOptionsFrame.name
	CIOptionsFrame.category = ci_category
	Settings.RegisterAddOnCategory(ci_category);
	
	local checkBoxHorizontalOffset = 175
	local checkBoxHorizontalSpacing = 80
	
	-- general settings --
	local generalSettingsLabel = CIOptionsFrame:CreateFontString("ARTWORK", nil, "GameFontNormal")
	generalSettingsLabel:SetPoint("TOPLEFT", 0, 0)
	generalSettingsLabel:SetText("General Settings")
	
	local showAllClassLabel = CIOptionsFrame:CreateFontString("ARTWORK", nil, "GameTooltipText")
	showAllClassLabel:SetPoint("TOPLEFT", 0, -20)
	showAllClassLabel:SetText("Show All Class Immunities")

	local checkBoxShowAllClass = CreateFrame("CheckButton", "CheckButtonShowAllClass", CIOptionsFrame, "UICheckButtonTemplate")
	checkBoxShowAllClass:SetPoint("TOPLEFT", checkBoxHorizontalOffset + checkBoxHorizontalSpacing + 3, -10)
	checkBoxShowAllClass:SetChecked(globalSettings.SHOW_ALL_CLASS_IMMUNITIES)
	checkBoxShowAllClass:SetScript("OnClick", function(frame)
		local tick = frame:GetChecked()
		globalSettings.SHOW_ALL_CLASS_IMMUNITIES = tick
		end)

	local showDetailedLabel = CIOptionsFrame:CreateFontString("ARTWORK", nil, "GameTooltipText")
	showDetailedLabel:SetPoint("TOPLEFT", 0, -40)
	showDetailedLabel:SetText("Show Detailed Immunities")

	local checkBoxShowDetailed = CreateFrame("CheckButton", "CheckButtonShowDetailed", CIOptionsFrame, "UICheckButtonTemplate")
	checkBoxShowDetailed:SetPoint("TOPLEFT", checkBoxHorizontalOffset + checkBoxHorizontalSpacing + 3, -35)
	checkBoxShowDetailed:SetChecked(globalSettings.SHOW_DETAILED_IMMUNITIES)
	checkBoxShowDetailed:SetScript("OnClick", function(frame)
		local tick = frame:GetChecked()
		globalSettings.SHOW_DETAILED_IMMUNITIES = tick
		end)

	-- immunity filters --
	local scrollChildCount = 0
	local scrollChildVerticalSpacing = 25
	
	local scrollLabel = CIOptionsFrame:CreateFontString("ARTWORK", nil, "GameFontNormal")
	scrollLabel:SetPoint("TOPLEFT", 0, -60)
	scrollLabel:SetText("Source")
	
	scrollLabel = CIOptionsFrame:CreateFontString("ARTWORK", nil, "GameFontNormal")
	scrollLabel:SetPoint("TOPLEFT", checkBoxHorizontalOffset + checkBoxHorizontalSpacing, -60)
	scrollLabel:SetText("Class")
	
	scrollLabel = CIOptionsFrame:CreateFontString("ARTWORK", nil, "GameFontNormal")
	scrollLabel:SetPoint("TOPLEFT", checkBoxHorizontalOffset + checkBoxHorizontalSpacing * 2, -60)
	scrollLabel:SetText("Force On")
	
	scrollLabel = CIOptionsFrame:CreateFontString("ARTWORK", nil, "GameFontNormal")
	scrollLabel:SetPoint("TOPLEFT", checkBoxHorizontalOffset + checkBoxHorizontalSpacing * 3, -60)
	scrollLabel:SetText("Force Off")

	-- Create the scrolling parent frame and size it to fit inside the texture
	local scrollFrame = CreateFrame("ScrollFrame", nil, CIOptionsFrame, "UIPanelScrollFrameTemplate")
	scrollFrame:SetPoint("TOPLEFT", 3, -75)
	scrollFrame:SetPoint("BOTTOMRIGHT", -27, 4)

	-- Create the scrolling child frame, set its width to fit, and give it an arbitrary minimum height (such as 1)
	local scrollChild = CreateFrame("Frame")
	scrollFrame:SetScrollChild(scrollChild)
	scrollChild:SetWidth(SettingsPanel.Container:GetWidth() - 18)
	scrollChild:SetHeight(1)

	for i, v in ipairs(db) do
		local globalSetting = CITableGetImmunityByDisplayName(globalSettings.FILTER_LIST, v.display_name)
	
		local scrollChildHeight = scrollChildCount * scrollChildVerticalSpacing

		local checkBoxLabel = scrollChild:CreateFontString(nil, nil, "GameTooltipText")
		checkBoxLabel:SetPoint("TOPLEFT", 0, -scrollChildHeight - 10)
		local checkBoxLabelText = CIGetSpellTexture(v.icon_id) .. " " .. v.display_name
		if true then
			local classCount = table.getn(v.class_white_list)
			if classCount > 0 then
				checkBoxLabelText = checkBoxLabelText .. ' ('
				for d, x in ipairs(v.class_white_list) do
					local classWithColour = GetClassIcon(x)
					checkBoxLabelText = checkBoxLabelText .. classWithColour
					if d < classCount then
						checkBoxLabelText = checkBoxLabelText .. ', '
					end
				end
				checkBoxLabelText = checkBoxLabelText .. ')'
			end
		end
		checkBoxLabel:SetText(checkBoxLabelText)
		
		local checkBoxClass = CreateFrame("CheckButton", "CheckButtonClass%i", scrollChild, "UICheckButtonTemplate")
		local checkBoxForceOn = CreateFrame("CheckButton", "CheckButtonForceOn%i", scrollChild, "UICheckButtonTemplate")
		local checkBoxForceOff = CreateFrame("CheckButton", "CheckButtonForceOff%i", scrollChild, "UICheckButtonTemplate")
		
		checkBoxClass:SetPoint("TOPLEFT", checkBoxHorizontalOffset + checkBoxHorizontalSpacing, -scrollChildHeight)		
		checkBoxClass:SetChecked(globalSetting.FILTER_TYPE == "CLASS")		
		checkBoxClass:SetScript("OnClick", function(frame)
			local tick = frame:GetChecked()
			if tick then
				globalSetting.FILTER_TYPE = "CLASS"
				checkBoxForceOn:SetChecked(false)
				checkBoxForceOff:SetChecked(false)
			end
			end)

		checkBoxForceOn:SetPoint("TOPLEFT", checkBoxHorizontalOffset + (checkBoxHorizontalSpacing * 2), -scrollChildHeight)		
		checkBoxForceOn:SetChecked(globalSetting.FILTER_TYPE == "FORCE_ON")		
		checkBoxForceOn:SetScript("OnClick", function(frame)
			local tick = frame:GetChecked()
			if tick then
				globalSetting.FILTER_TYPE = "FORCE_ON"
				checkBoxClass:SetChecked(false)
				checkBoxForceOff:SetChecked(false)
			end
			end)
		
		checkBoxForceOff:SetPoint("TOPLEFT", checkBoxHorizontalOffset + (checkBoxHorizontalSpacing * 3), -scrollChildHeight)		
		checkBoxForceOff:SetChecked(globalSetting.FILTER_TYPE == "FORCE_OFF")		
		checkBoxForceOff:SetScript("OnClick", function(frame)
			local tick = frame:GetChecked()			
			if tick then
				globalSetting.FILTER_TYPE = "FORCE_OFF"
				checkBoxClass:SetChecked(false)
				checkBoxForceOn:SetChecked(false)
			end
			end)
		
		scrollChildCount = scrollChildCount + 1
	end
end

function GetClassIcon(className)
	if className == 'WARRIOR' then
		return "|T" .. "626008" .. ":0|t"
		
	elseif className == 'WARLOCK' then
		return "|T" .. "626007" .. ":0|t"
		
	elseif className == 'SHAMAN' then
		return "|T" .. "626006" .. ":0|t"
		
	elseif className == 'PALADIN' then
		return "|T" .. "626003" .. ":0|t"
		
	elseif className == 'ROGUE' then
		return "|T" .. "626005" .. ":0|t"
		
	elseif className == 'PRIEST' then
		return "|T" .. "626004" .. ":0|t"
		
	elseif className == 'HUNTER' then
		return "|T" .. "626000" .. ":0|t"
		
	elseif className == 'MAGE' then
		return "|T" .. "626001" .. ":0|t"	
		
	elseif className == 'DRUID' then
		return "|T" .. "625999" .. ":0|t"
		
	else
		return className
	end
end

function GetClassNameWithColour(className)
	if className == 'WARRIOR' then
		return '\124cffC69B6D' .. className .. '\124r'
		
	elseif className == 'WARLOCK' then
		return '\124cff8788EE' .. className .. '\124r'
		
	elseif className == 'SHAMAN' then
		return '\124cff0070DD' .. className .. '\124r'	
		
	elseif className == 'PALADIN' then
		return '\124cffF48CBA' .. className .. '\124r'	
		
	elseif className == 'ROGUE' then
		return '\124cffFFF468' .. className .. '\124r'	
		
	elseif className == 'PRIEST' then
		return '\124cffFFFFFF' .. className .. '\124r'	
		
	elseif className == 'HUNTER' then
		return '\124cffAAD372' .. className .. '\124r'	
		
	elseif className == 'MAGE' then
		return '\124cff3FC7EB' .. className .. '\124r'	
		
	elseif className == 'DRUID' then
		return '\124cffFF7C0A' .. className .. '\124r'	
		
	else
		return className
	end
end

function SlashCmdList_AddSlashCommand(name, func, ...)
    SlashCmdList[name] = func
    local command = ''
    for i = 1, select('#', ...) do
        command = select(i, ...)
        if strsub(command, 1, 1) ~= '/' then
            command = '/' .. command
        end
        _G['SLASH_'..name..i] = command
    end
end

SlashCmdList_AddSlashCommand('CLASSICIMMUNITIES_SLASHCMD', function(msg)
	Settings.OpenToCategory("Classic Immunities");
end, 'ci', 'classicimmunities')
