function CICreateOptions(db, globalSettings)
	local CIOptionsFrame = CreateFrame("Frame")
	CIOptionsFrame.name = "Classic Immunities"
	
	InterfaceOptions_AddCategory(CIOptionsFrame);
	
	local checkBoxHorizontalOffset = 125
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
	scrollChild:SetWidth(InterfaceOptionsFramePanelContainer:GetWidth() - 18)
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
					checkBoxLabelText = checkBoxLabelText .. x
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
	InterfaceOptionsFrame_OpenToCategory("Classic Immunities")
end, 'ci', 'classicimmunities')
