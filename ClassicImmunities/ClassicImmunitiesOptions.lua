function CICreateOptions(db, globalSettings)
	local CIOptionsFrame = CreateFrame("Frame")
	CIOptionsFrame.name = "Classic Immunities"
	
    local catName = "|TInterface\\AddOns\\ClassicImmunities\\ci_icon.tga:16:16|t " .. CIOptionsFrame.name
	local ci_category = Settings.RegisterCanvasLayoutCategory(CIOptionsFrame, catName);
	ci_category.ID = CIOptionsFrame.name
	CIOptionsFrame.category = ci_category
	Settings.RegisterAddOnCategory(ci_category);
	
	local checkBoxHorizontalOffset = 175
	local checkBoxHorizontalSpacing = 80
	
	-- general settings --
	local generalSettingsLabel = CIOptionsFrame:CreateFontString("ARTWORK", nil, "GameFontNormal")
	generalSettingsLabel:SetPoint("TOPLEFT", 0, 0)
	generalSettingsLabel:SetText("General Settings")
	
	-- immunity filters --
	local settingsScrollChildCount = 0
	local settingsScrollChildVerticalSpacing = 25

	-- Create the scrolling parent frame and size it to fit inside the texture
	local settingsScrollFrame = CreateFrame("ScrollFrame", nil, CIOptionsFrame, "UIPanelScrollFrameTemplate")
	settingsScrollFrame:SetPoint("TOPLEFT", 3, -15)
	settingsScrollFrame:SetPoint("BOTTOMRIGHT", -27, (SettingsPanel.Container:GetHeight() / 2) + 50)

	-- Create the scrolling child frame, set its width to fit, and give it an arbitrary minimum height (such as 1)
	local settingsScrollChild = CreateFrame("Frame")
	settingsScrollFrame:SetScrollChild(settingsScrollChild)
	settingsScrollChild:SetWidth(SettingsPanel.Container:GetWidth() - 18)
	settingsScrollChild:SetHeight(1)
    
    local settingsDB = {
    {
        ["setting_name"] = "SHOW_ALL_CLASS_IMMUNITIES",
        ["display_name"] = "Show All Class Immunities",
        ["setting_type"] = "CHECKBOX",
    },
    {
        ["setting_name"] = "SHOW_FRIENDLY_NPC_IMMUNITIES",
        ["display_name"] = "Show Friendly NPC Immunities",
        ["setting_type"] = "CHECKBOX",
    },
    {
        ["setting_name"] = "SHOW_IMMUNITIES_TOOLTIP_HEADER",
        ["display_name"] = "Show Tooltip Header",
        ["setting_type"] = "CHECKBOX",
    },
    {
        ["setting_name"] = "HOLD_CTRL_TOGGLE_IMMUNITY_NAMES",
        ["display_name"] = "'CTRL' Shows/Hides Immunity Names",
        ["setting_type"] = "CHECKBOX",
    },
    {
        ["setting_name"] = "DISABLE_CTRL_KEY",
        ["display_name"] = "Disable 'CTRL' Key",
        ["setting_type"] = "CHECKBOX",
    },
    {
        ["setting_name"] = "HOLD_ALT_TOGGLE_NPC_ID",
        ["display_name"] = "'ALT' Shows/Hides NPC ID",
        ["setting_type"] = "CHECKBOX",
    },
    {
        ["setting_name"] = "DISABLE_ALT_KEY",
        ["display_name"] = "Disable 'ALT' Key",
        ["setting_type"] = "CHECKBOX",
    },
    {
        ["setting_name"] = "TOOLTIP_ICON_SIZE",
        ["display_name"] = "Tooltip Icon Size",
        ["setting_type"] = "SLIDER",
        ["slider_min"] = 2,
        ["slider_max"] = 32,
    }
    }

	for i, v in ipairs(settingsDB) do

        -- settings --
        local rowHeight = settingsScrollChildVerticalSpacing
        local row = CreateFrame("Frame", nil, settingsScrollChild)
        row:SetPoint("TOPLEFT", 0, -settingsScrollChildCount * rowHeight)
        row:SetSize(settingsScrollChild:GetWidth(), rowHeight)
        
        if settingsScrollChildCount % 2 == 1 then
            local bg = row:CreateTexture(nil, "BACKGROUND")
            bg:SetAllPoints()
            bg:SetColorTexture(1, 1, 1, 0.06) -- subtle light stripe
        end

		local settingLabel = settingsScrollChild:CreateFontString(nil, nil, "GameTooltipText")
        settingLabel:SetParent(row)
        settingLabel:SetPoint("LEFT", 4, 0)

		local settingLabelText = v.display_name --CIGetIconTexture(v.icon_id, 20) .. " " .. v.display_name
		settingLabel:SetText(settingLabelText)
		
        if v.setting_type == "CHECKBOX" then
            local checkBox = CreateFrame("CheckButton", "CheckButtonSetting%i", settingsScrollChild, "UICheckButtonTemplate")
            checkBox:SetParent(row)
            checkBox:SetPoint("LEFT", checkBoxHorizontalOffset + checkBoxHorizontalSpacing, 0)
            checkBox:SetChecked(globalSettings[v.setting_name])
            checkBox:SetScript("OnClick", function(frame)
                local tick = frame:GetChecked()
                    globalSettings[v.setting_name] = tick
                end)
        elseif v.setting_type == "SLIDER" then
            local slider = CreateFrame("Slider", "SliderSetting%i", settingsScrollChild, "OptionsSliderTemplate")
            -- slider:SetPoint("TOPLEFT", 20, -40)
            slider:SetParent(row)
            slider:SetPoint("LEFT", checkBoxHorizontalOffset + checkBoxHorizontalSpacing + 50, 0)
            slider:SetMinMaxValues(v.slider_min, v.slider_max)
            slider.Low:SetText(v.slider_min)
            slider.Low:SetPoint("TOPLEFT", -2, -4)
            slider.High:SetText(v.slider_max)
            slider.High:SetPoint("TOPRIGHT", 4, -4)
            slider.Text:SetText(globalSettings[v.setting_name])
            slider.Text:SetPoint("BOTTOM", slider, "LEFT", -35, -5)
            slider.Text:SetTextColor(1, 0.82, 0)
            slider:SetValueStep(1)
            slider:SetObeyStepOnDrag(true)
            slider:SetWidth(200)
            slider:SetValue(globalSettings[v.setting_name])
            slider:SetScript("OnValueChanged", function(self, value)
                value = math.floor(value + 0.5)
                globalSettings[v.setting_name] = value
                self.Text:SetText(value)
            end)
        else 
            print(v.display_name .. " invalid setting type")
        end

		settingsScrollChildCount = settingsScrollChildCount + 1
	end
    
    settingsScrollChild:SetHeight(settingsScrollChildCount * settingsScrollChildVerticalSpacing)

    local scrollWindowHeight = -SettingsPanel.Container:GetHeight() / 2
	
	-- immunity filters --
	local scrollChildCount = 0
	local scrollChildVerticalSpacing = 25
	
	local scrollLabel = CIOptionsFrame:CreateFontString("ARTWORK", nil, "GameFontNormal")
	scrollLabel:SetPoint("TOPLEFT", 0, scrollWindowHeight)
	scrollLabel:SetText("Source")
	
	scrollLabel = CIOptionsFrame:CreateFontString("ARTWORK", nil, "GameFontNormal")
	scrollLabel:SetPoint("TOPLEFT", checkBoxHorizontalOffset + checkBoxHorizontalSpacing + 5, scrollWindowHeight)
	scrollLabel:SetText("Class")
	
	scrollLabel = CIOptionsFrame:CreateFontString("ARTWORK", nil, "GameFontNormal")
	scrollLabel:SetPoint("TOPLEFT", checkBoxHorizontalOffset + checkBoxHorizontalSpacing * 2 - 5, scrollWindowHeight)
	scrollLabel:SetText("Force On")
	
	scrollLabel = CIOptionsFrame:CreateFontString("ARTWORK", nil, "GameFontNormal")
	scrollLabel:SetPoint("TOPLEFT", checkBoxHorizontalOffset + checkBoxHorizontalSpacing * 3 - 5, scrollWindowHeight)
	scrollLabel:SetText("Force Off")

	-- Create the scrolling parent frame and size it to fit inside the texture
	local scrollFrame = CreateFrame("ScrollFrame", nil, CIOptionsFrame, "UIPanelScrollFrameTemplate")
	scrollFrame:SetPoint("TOPLEFT", 3, -SettingsPanel.Container:GetHeight() / 2 - 15)
	scrollFrame:SetPoint("BOTTOMRIGHT", -27, 4)

	-- Create the scrolling child frame, set its width to fit, and give it an arbitrary minimum height (such as 1)
	local scrollChild = CreateFrame("Frame")
	scrollFrame:SetScrollChild(scrollChild)
	scrollChild:SetWidth(SettingsPanel.Container:GetWidth() - 18)
	scrollChild:SetHeight(1)

	for i, v in ipairs(db) do
		local globalSetting = CITableGetImmunityByDisplayName(globalSettings.FILTER_LIST, v.display_name)

        local rowHeight = scrollChildVerticalSpacing
        local row = CreateFrame("Frame", nil, scrollChild)
        row:SetPoint("TOPLEFT", 0, -scrollChildCount * rowHeight)
        row:SetSize(scrollChild:GetWidth(), rowHeight)
        
        if scrollChildCount % 2 == 1 then
            local bg = row:CreateTexture(nil, "BACKGROUND")
            bg:SetAllPoints()
            bg:SetColorTexture(1, 1, 1, 0.06) -- subtle light stripe
        end

		local checkBoxLabel = scrollChild:CreateFontString(nil, nil, "GameTooltipText")
        checkBoxLabel:SetParent(row)
        checkBoxLabel:SetPoint("LEFT", 4, 0)
		local checkBoxLabelText = CIGetIconTexture(v.icon_id, 20) .. " " .. v.display_name
		if true then
			local classCount = table.getn(v.class_uses_immunity_list)
			if classCount > 0 then
				checkBoxLabelText = checkBoxLabelText .. ' ('
				for d, x in ipairs(v.class_uses_immunity_list) do
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
		
        checkBoxClass:SetParent(row)
        checkBoxClass:SetPoint("LEFT", checkBoxHorizontalOffset + checkBoxHorizontalSpacing, 0)		
		checkBoxClass:SetChecked(globalSetting.FILTER_TYPE == "CLASS")		
		checkBoxClass:SetScript("OnClick", function(frame)
			local tick = frame:GetChecked()
			if tick then
				globalSetting.FILTER_TYPE = "CLASS"
				checkBoxForceOn:SetChecked(false)
				checkBoxForceOff:SetChecked(false)
			end
			end)
		
        checkBoxForceOn:SetParent(row)
        checkBoxForceOn:SetPoint("LEFT", checkBoxHorizontalOffset + (checkBoxHorizontalSpacing * 2), 0)
		checkBoxForceOn:SetChecked(globalSetting.FILTER_TYPE == "FORCE_ON")		
		checkBoxForceOn:SetScript("OnClick", function(frame)
			local tick = frame:GetChecked()
			if tick then
				globalSetting.FILTER_TYPE = "FORCE_ON"
				checkBoxClass:SetChecked(false)
				checkBoxForceOff:SetChecked(false)
			end
			end)
		
        checkBoxForceOff:SetParent(row)
        checkBoxForceOff:SetPoint("LEFT", checkBoxHorizontalOffset + (checkBoxHorizontalSpacing * 3), 0)
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
    
    scrollChild:SetHeight(scrollChildCount * scrollChildVerticalSpacing)
end

function GetClassIcon(className)
	if className == 'WARRIOR' then
		return "|T" .. "626008" .. ":16|t"
		
	elseif className == 'WARLOCK' then
		return "|T" .. "626007" .. ":16|t"
		
	elseif className == 'SHAMAN' then
		return "|T" .. "626006" .. ":16|t"
		
	elseif className == 'PALADIN' then
		return "|T" .. "626003" .. ":16|t"
		
	elseif className == 'ROGUE' then
		return "|T" .. "626005" .. ":16|t"
		
	elseif className == 'PRIEST' then
		return "|T" .. "626004" .. ":16|t"
		
	elseif className == 'HUNTER' then
		return "|T" .. "626000" .. ":16|t"
		
	elseif className == 'MAGE' then
		return "|T" .. "626001" .. ":16|t"	
		
	elseif className == 'DRUID' then
		return "|T" .. "625999" .. ":16|t"
		
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
