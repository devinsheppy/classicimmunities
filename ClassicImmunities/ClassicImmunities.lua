local CI_DB = _G["ClassicImmunitiesDB"]
local CI_L = _G["ClassicImmunitiesLocalization"]

local CI_hook_installed = false
local CI_PLAYER_CLASS = "None"

local CI_LOGGING = false
local CI_DEBUGGING = false

CI_global_settings = CI_global_settings

-- global settings layout
--[[

CI_global_settings
{
	{
		["SHOW_ALL_CLASS_IMMUNITIES"] = false, -- if true, ignores the whitelist and blacklist for classes, showing all immunities
	
		["FILTER_LIST"] =
		{
			["display_name"]="Banish",
			["npc_id_white_list"]={},
			["npc_id_black_list"]={},
			["FILTER_TYPE"]= "CLASS" or "FORCE_ON" or "FORCE_OFF",
		}
	},
}

]]--

local function CILoadGlobalSettings(db)
	-- player has no data, start from scratch --
	if CI_global_settings == nil then
		CI_global_settings = {}		
	end
	
	if CI_global_settings.FILTER_LIST == nil then
		CI_global_settings.FILTER_LIST = {}
	end
	
	if CI_global_settings.SHOW_ALL_CLASS_IMMUNITIES == nil then
		CI_global_settings.SHOW_ALL_CLASS_IMMUNITIES = false
	end

	for i, v in ipairs(db) do
		if CITableGetImmunityByDisplayName(CI_global_settings.FILTER_LIST, v.display_name) == nil then
			table.insert(CI_global_settings.FILTER_LIST, { ["display_name"]=v.display_name, ["FILTER_TYPE"]="CLASS" })
		end
	end

	for k,t in pairs(CI_effects_db) do
		local temp = {}
		for i,v in ipairs(t) do
			temp[v] = true
		end
		CI_effects_db[k] = temp
	end
end

local name_school = {}

local function DecodeSchoolBitfield(school)
	local r = {}
	if school >= 1 then
		local rem = school
		for i = 7,0,-1 do
			local j = 2^i
			if rem >= j then
				rem = rem - j
				r[i+1] = 1
			else
				r[i+1] = 0
			end
		end
	end
	return r
end

local function school_to_colour(school)
	if school and school >= 1 then
		local s = DecodeSchoolBitfield(school)
		local n = 0
		local r = 0
		local g = 0
		local b = 0
		for i = 0,7 do
			if s[i+1] == 1 then
				local colour = CI_school_colours[2^i]
				n = n + 1
				r = r + colour[1]
				g = g + colour[2]
				b = b + colour[3]
			end
		end
		return CreateColorFromBytes(r/n,g/n,b/n,255)
	else
		return CreateColorFromBytes(255,255,255,255)
	end
end

local function infer_immunities(npcID)
	local schools = {}
	for i = 1,7 do
		schools[i] = {0,0,0,0,0,0,0}
 	end
	local x = CI_database[npcID]
	if x then
		for s,v1 in pairs(x) do
			local school = CI_school_database[s]
			for k,v2 in ipairs(DecodeSchoolBitfield(school)) do
				if v2 then
					if v1 then
						-- immune to school k
						--schools[k] = (schools[k],)
					else
						-- non immune to school k
						schools[k] = min(schools[k],-1)
					end
				end
			end
		end
	end
end

local function CISetTooltipImmunities(immuneToAnything, immunityIcons, npcID)
	if immunityIcons and immuneToAnything then
		local sortedImmunityIcons = {}
		for name, texture in pairs(immunityIcons) do
			table.insert(sortedImmunityIcons,{name,texture,name_school[name] or 0})
		end
		table.sort(sortedImmunityIcons,
			function(a,b)
				if a[3] ~= b[3] then
					return a[3] > b[3]
				end
				return a[1] < b[1]
			end
		)
		local headline = 'Immunities'
		if IsAltKeyDown() then
			headline = headline .. ' : NPC ID (' .. npcID ..')'
		end
		GameTooltip:AddLine(headline)
		if not IsAltKeyDown() then
			local immuneTextures = ''
			for i, v in ipairs(sortedImmunityIcons) do
				immuneTextures = immuneTextures .. v[2] .. ' '
			end
			GameTooltip:AddLine(immuneTextures,1,1,1,true)
		else
			for i, v in ipairs(sortedImmunityIcons) do
 				local colour = school_to_colour(v[3])
				GameTooltip:AddLine(v[2] .. ' ' .. v[1],colour.r,colour.g,colour.b,colour.a,true)
			end
		end
	else
		if IsAltKeyDown() then
			local headline = 'Immunities'
			headline = headline .. ' : NPC ID (' .. npcID ..')'
			GameTooltip:AddLine(headline)
		end
	end
end

local function on_tooltip_set_unit()
  local _tt_name, tt_unit = GameTooltip:GetUnit()
  if not tt_unit then
    tt_unit = "mouseover" -- XXX: probably not necessary
  end
  
  local guid = UnitGUID(tt_unit)
  if not guid then
    return
  end

  guid = {strsplit("-", guid)}
 
  if guid[1] ~= "Creature" then
    return
  end  

  local npc_id = tonumber(guid[6])
  if not npc_id then
    return
  end
  
  local immunityIcons = { }  
  local isImmuneToAnything = false
  local c_creatureType = UnitCreatureType(tt_unit)
  local c_creatureTypeLocalizedFound, c_localizedCreatureType = CIGetLocalizedCreatureType(c_creatureType, CI_L)
	if CI_global_settings.SHOW_DETAILED_IMMUNITIES then
		if CI_database[npc_id] ~= nil then
			for k,v in pairs(CI_database[npc_id]) do
				if v == true then
					local display_name, _, _, _, _, _, _, _ = GetSpellInfo(k)
					local spell_texture = CIGetSpellTexture(k)
					immunityIcons[display_name] = spell_texture
					if CI_school_database[k] ~= nil then
						name_school[display_name] = CI_school_database[k]
					end
					isImmuneToAnything = true
				end
			end
		end
	else
		for i, v in ipairs(CI_DB) do
			local globalSetting = CITableGetImmunityByDisplayName(CI_global_settings.FILTER_LIST, v.display_name)
			
			if globalSetting.FILTER_TYPE == "CLASS" or globalSetting.FILTER_TYPE == "FORCE_ON" then
				local classInWhiteList = table.getn(v.class_white_list) == 0 or CITableFind(v.class_white_list, CI_PLAYER_CLASS)
				
				local creatureTypeInWhiteList = false
				local creatureTypeInBlackList = false
				
				if c_creatureTypeLocalizedFound then
					creatureTypeInWhiteList = table.getn(v.creature_type_white_list) == 0 or CITableFind(v.creature_type_white_list, c_localizedCreatureType)
					creatureTypeInBlackList = table.getn(v.creature_type_black_list) > 0 and CITableFind(v.creature_type_black_list, c_localizedCreatureType)
				end
				
				local npcIDInWhiteList = CITableFind(v.npc_id_white_list, npc_id)
				local npcIDInBlackList = CITableFind(v.npc_id_black_list, npc_id)
				
				if CI_LOGGING then
					print("------------------")
					print("immunity: " .. tostring(v.display_name))
					print("npc_id: " .. tostring(npc_id))
					print("classInWhiteList: " .. tostring(classInWhiteList))
					print("c_creatureTypeLocalizedFound: " .. tostring(c_creatureTypeLocalizedFound))
					print("creatureTypeInWhiteList: " .. tostring(creatureTypeInWhiteList))
					print("creatureTypeInBlackList: " .. tostring(creatureTypeInBlackList))
					print("npcIDInWhiteList: " .. tostring(npcIDInWhiteList))
					print("npcIDInBlackList: " .. tostring(npcIDInBlackList))
					print("------------------")
				end
				
				if CI_DEBUGGING and (npc_id == 3100 or npc_id == 1512) then
					local spell_texture = CIGetSpellTexture(v.icon_id)
					immunityIcons[v.display_name] = spell_texture
				end
			
				if CI_global_settings.SHOW_ALL_CLASS_IMMUNITIES or classInWhiteList then
					if npcIDInWhiteList then
						local spell_texture = CIGetSpellTexture(v.icon_id)
						immunityIcons[v.display_name] = spell_texture
						isImmuneToAnything = true
					else
						if creatureTypeInBlackList and npcIDInBlackList == nil then
							local spell_texture = CIGetSpellTexture(v.icon_id)
							immunityIcons[v.display_name] = spell_texture
							isImmuneToAnything = true
						else
							if creatureTypeInWhiteList == nil then
								local spell_texture = CIGetSpellTexture(v.icon_id)
								immunityIcons[v.display_name] = spell_texture
								isImmuneToAnything = true
							end
						end
					end
				end
			end
		end
	end
	CISetTooltipImmunities(isImmuneToAnything, immunityIcons, npc_id) 
end

local function default(self, event, addOnName)
	if addOnName == "ClassicImmunities" then
		CI_database = CI_database or {}
		CI_school_database = CI_school_database or {}
		CI_NPC_name_database = CI_NPC_name_database or {}
	end
end

local f = CreateFrame("Frame")
f:RegisterEvent("ADDON_LOADED")
f:SetScript("OnEvent", default)

local event_first_part ={"SPELL","SPELL_PERIODIC"}
local event_second_part={"_DAMAGE","_AURA_APPLIED","_AURA_APPLIED_DOSE","_AURA_REFRESH","_LEECH","_DRAIN"}
local non_immune_events ={}
non_immune_events["DAMAGE_SHIELD"] = true
for k1,v1 in pairs(event_second_part) do
	for k2,v2 in pairs(event_first_part) do
		non_immune_events[v2 .. v1] = true
	end
end

local function RecordImmunities(self, event)
	local _,subevent,_,sourceGUID,_,_,_,destGUID,destName,_,_,spellId,spellName,spellSchool = CombatLogGetCurrentEventInfo()
	spellId = tonumber(spellId)
	spellSchool = tonumber(spellSchool)
	local subevent_components = { strsplit("_",subevent) }
	if destName ~= "nil" and tonumber(destGUID) ~= 0 and (subevent_components[1] == "SPELL" or subevent_components[1] == "DAMAGE")  then
		local dest_unitType, _, _, _, _, destID, _ = strsplit("-", destGUID)		
		local destID = tonumber(destID)
		if subevent ~= "SPELL_ABSORBED" then
			CI_school_database[spellId] = spellSchool
		end
		if dest_unitType ~= "Pet" and dest_unitType ~= "Player" then
			--if DLAPI then DLAPI.DebugLog("ClassicImmunities", "evento %s id %s scuola %s", tostring(subevent), tostring(spellId),tostring(spellSchool)) end
			if destID and destName then
				CI_NPC_name_database[destID] = destName
			end
			if non_immune_events[subevent] then
				if CI_database[destID] == nil then
					CI_database[destID] = {}
				end
				CI_database[destID][spellId] = false
			elseif subevent_components[#subevent_components] == "MISSED" then
				local missType,_ ,_,_ = select(15, CombatLogGetCurrentEventInfo())
				if missType == "IMMUNE" then
					if CI_database[destID] == nil then
						CI_database[destID] = {}
					end
					-- check for false positive
					if CI_database[destID][spellId] == nil then
						CI_database[destID][spellId] = true
						print("ClassicImmunities new immunity recorded: " .. spellName .. " for " .. destName)
					end
				end
			end
		end
	end
end

local f = CreateFrame("Frame", "ClassicImmunityRecordImmunities")
f:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
f:SetScript("OnEvent", RecordImmunities)

local ScrollingTable = LibStub("ScrollingTable")
local NPCcols = { 
	{
		["name"] = "NPC ID",
		["width"] = 50,
		["align"] = "RIGHT",
		["sort"] = "asc",
		["defaultsort"] = "asc",
	}, 
	{
		["name"] = "NPC Name",
		["width"] = 200,
		["align"] = "LEFT",
		["defaultsort"] = "asc",
	},
}
local Spellcols = { 
	{
		["name"] = "Spell ID",
		["width"] = 50,
		["align"] = "RIGHT",
		["sort"] = "asc",
		["defaultsort"] = "asc",
	},
	{
		["name"] = "",
		["width"] = 20,
		["align"] = "CENTER",
	},
	{
		["name"] = "Spell Name",
		["width"] = 200,
		["align"] = "LEFT",
		["defaultsort"] = "asc",
	},
}

local function LeftNPCScrollingTable(rowFrame, cellFrame, data, cols, row, realrow, column, scrollingTable, ...)
	if row and realrow then
		local d = {}
		local NPCID = data[realrow].cols[1].value
		for spellid,v in pairs(CI_database[NPCID]) do
			if v then
				local display_name, _, _, _, _, _, _, _ = GetSpellInfo(spellid)
				local ID = {["value"] = spellid}
				local name = {["value"] = WrapTextInColor(display_name, school_to_colour(CI_school_database[spellid]))}
				local texture = {["value"] = CIGetSpellTexture(spellid)}
				table.insert(d,{["cols"] = {ID, texture ,name}})
			end
		end
		ClassicImmunitiesUI.content1.RightTable:SetData(d)
		ClassicImmunitiesUI.content1.RightTable:Refresh()
		ClassicImmunitiesUI.content1.RightTable:Show()
	end
end

local function RightSpellScrollingTable(rowFrame, cellFrame, data, cols, row, realrow, column, scrollingTable, ...)
	if row and realrow then
		local NPCID = data[realrow].cols[1].value
		local data = {}
		for spellid,v in pairs(CI_database[NPCID]) do
			if v then
				local display_name, _, _, _, _, _, _, _ = GetSpellInfo(spellid)
				local school = CI_school_database[spellid]
				local tex = CIGetSpellTexture(spellid)
				local ID = {["value"] = spellid}
				local name = {["value"] = WrapTextInColor(display_name, school_to_colour(school))}
				local texture = {["value"] = tex}
				table.insert(data,{["cols"] = {ID, texture ,name}})
			end
		end
		ClassicImmunitiesUI.content1.RightTable:SetData(data)
		ClassicImmunitiesUI.content1.RightTable:Refresh()
		ClassicImmunitiesUI.content1.RightTable:Show()
	end
end

local function LeftSpellScrollingTable(rowFrame, cellFrame, data, cols, row, realrow, column, scrollingTable, ...)
	if row and realrow then
		local d = {}
		local SpellID = data[realrow].cols[1].value
		local npclist = {}
		for npcid,spelltable in pairs(CI_database) do
			for spell, v in pairs(spelltable) do
				if v and spell == SpellID then
					npclist[npcid] = true
				end
			end
		end
		for npcid,v in pairs(npclist) do
			local ID = {["value"] = npcid}
			local name = {["value"] = CI_NPC_name_database[npcid] or (MI2_GetNameForId and MI2_GetNameForId(npcid)) or tostring(npcid)}
			table.insert(d,{["cols"] = {ID, name}})
		end
		ClassicImmunitiesUI.content2.RightTable:SetData(d)
		ClassicImmunitiesUI.content2.RightTable:Refresh()
		ClassicImmunitiesUI.content2.RightTable:Show()
	end
end

local function RightNPCScrollingTable(rowFrame, cellFrame, data, cols, row, realrow, column, scrollingTable, ...)
	if row and realrow then
		local SpellID = data[realrow].cols[1].value
		local data = {}
		local npclist = {}
		for npcid,spelltable in pairs(CI_database) do
			for spell, v in pairs(spelltable) do
				if v and spell == SpellID then
					npclist[npcid] = true
				end
			end
		end
		for npcid,v in pairs(npclist) do
			local ID = {["value"] = npcid}
			local name = {["value"] = CI_NPC_name_database[npcid] or MI2_GetNameForId(npcid) or tostring(npcid)}
			table.insert(data,{["cols"] = {ID, name}})
		end
		ClassicImmunitiesUI.content2.RightTable:SetData(data)
		ClassicImmunitiesUI.content2.RightTable:Refresh()
		ClassicImmunitiesUI.content2.RightTable:Show()
	end
end

local function ShowTables(type)
	local data = {}
	local LT = nil
	local RT = nil
	if type == 1 then
		ClassicImmunitiesUI.content2:Hide()
		ClassicImmunitiesUI.content1:Show()
		LT = ClassicImmunitiesUI.content1.LeftTable
		RT = ClassicImmunitiesUI.content1.RightTable
		for npcid,spelltable in pairs(CI_database) do
			for spellid,v in pairs(spelltable) do
				if v then
					local ID = {["value"] = npcid}
					local name = {["value"] = CI_NPC_name_database[npcid] or (MI2_GetNameForId and MI2_GetNameForId(npcid)) or tostring(npcid)}
					table.insert(data,{["cols"] = {ID, name}})
					break
				end
			end
		end
	else
		ClassicImmunitiesUI.content1:Hide()
		ClassicImmunitiesUI.content2:Show()
		LT = ClassicImmunitiesUI.content2.LeftTable
		RT = ClassicImmunitiesUI.content2.RightTable
		local spelllist = {}
		for npcid,spelltable in pairs(CI_database) do
			for spellid,v in pairs(spelltable) do
				if v then
					local display_name, _, _, _, _, _, _, _ = GetSpellInfo(spellid)
					spelllist[spellid] = display_name
				end
			end
		end
		for spellid,display_name in pairs(spelllist) do
			local texture = {["value"] = CIGetSpellTexture(spellid)}
			local ID = {["value"] = spellid}
			local name = {["value"] = WrapTextInColor(display_name, school_to_colour(CI_school_database[spellid]))}
			table.insert(data,{["cols"] = {ID, texture ,name}})
		end
	end

	LT:SetData(data)
	LT:Refresh()
	LT:Show()
	RT:Show()
end

local function Tab_OnClick(self)
	PanelTemplates_SetTab(self:GetParent(), self:GetID())
	if ClassicImmunitiesUI.content1 then
		ShowTables(self:GetID())
	end
end

local function SetTabs(frame, numTabs, ...)
	frame.numTabs = numTabs

	local contents = {};
	local frameName = frame:GetName()

	for i = 1, numTabs do
		local tab = CreateFrame("Button", frameName.."Tab"..i, frame, "CharacterFrameTabButtonTemplate")
		tab:SetID(i)
		tab:SetText(select(i, ...))
		tab:SetScript("OnClick", Tab_OnClick)

		tab.content = CreateFrame("Frame", nil, ClassicImmunitiesUI)
		tab.content:Hide()
		tab.content.RightList = CreateFrame("Frame","RightList",tab.content)
		tab.content.RightList:SetPoint("TOPRIGHT",ClassicImmunitiesUI,"TOPRIGHT",0,-40)
		tab.content.RightList:SetPoint("BOTTOMRIGHT",ClassicImmunitiesUI,"BOTTOMRIGHT",0,0)
		tab.content.RightList:SetPoint("LEFT",ClassicImmunitiesUI,"CENTER",0,0)
		tab.content.LeftList = CreateFrame("Frame","LeftList",tab.content)
		tab.content.LeftList:SetPoint("TOPLEFT",ClassicImmunitiesUI,"TOPLEFT",0,-40)
		tab.content.LeftList:SetPoint("BOTTOMLEFT",ClassicImmunitiesUI,"BOTTOMLEFT",0,0)
		tab.content.LeftList:SetPoint("RIGHT",ClassicImmunitiesUI,"CENTER",0,0)

		table.insert(contents, tab.content)
		
		if (i == 1) then
			tab:SetPoint("TOPLEFT", ClassicImmunitiesUI, "BOTTOMLEFT", 5, 7)
		else
			tab:SetPoint("TOPLEFT", _G[frameName.."Tab"..(i - 1)], "TOPRIGHT", -14, 0)
		end
	end
	
	Tab_OnClick(_G[frameName.."Tab1"])
	
	return unpack(contents)
end

local function CreateGUI()
	ClassicImmunitiesUI = CreateFrame("Frame","ClassicImmunitiesUI",UIParent,"BasicFrameTemplate")
	ClassicImmunitiesUI:Hide()
	ClassicImmunitiesUI:SetSize(600,640)
	ClassicImmunitiesUI:SetPoint("CENTER",UIParent,"CENTER")
	ClassicImmunitiesUI:SetMovable(true)
	ClassicImmunitiesUI:EnableMouse(true)
	ClassicImmunitiesUI:RegisterForDrag("LeftButton")
	ClassicImmunitiesUI:SetScript("OnDragStart",
		function(self, button)
			self:StartMoving()
		end
	)
	ClassicImmunitiesUI:SetScript("OnDragStop",
		function(self)
			self:StopMovingOrSizing()
		end
	)

	ClassicImmunitiesUI.content1, ClassicImmunitiesUI.content2 = SetTabs(ClassicImmunitiesUI, 2, "NPC", "Spells")
	ClassicImmunitiesUI.content1.LeftTable = ScrollingTable:CreateST(NPCcols, 32, 18, nil, ClassicImmunitiesUI.content1.LeftList)
	ClassicImmunitiesUI.content1.RightTable = ScrollingTable:CreateST(Spellcols, 32, 18, nil, ClassicImmunitiesUI.content1.RightList)
	ClassicImmunitiesUI.content1.LeftTable:RegisterEvents({["OnClick"] = RightSpellScrollingTable})
	ClassicImmunitiesUI.content1.LeftTable:Hide()
	ClassicImmunitiesUI.content1.RightTable:Hide()
	ClassicImmunitiesUI.content1.LeftTable:EnableSelection(true)
	
	ClassicImmunitiesUI.content2.LeftTable = ScrollingTable:CreateST(Spellcols, 32, 18, nil, ClassicImmunitiesUI.content2.LeftList)
	ClassicImmunitiesUI.content2.RightTable = ScrollingTable:CreateST(NPCcols, 32, 18, nil, ClassicImmunitiesUI.content2.RightList)
	ClassicImmunitiesUI.content2.LeftTable:RegisterEvents({["OnClick"] = RightNPCScrollingTable})
	ClassicImmunitiesUI.content2.LeftTable:Hide()
	ClassicImmunitiesUI.content2.RightTable:Hide()
	ClassicImmunitiesUI.content2.LeftTable:EnableSelection(true)

	ClassicImmunitiesUI:SetScript("OnShow",
		function(self)
			ShowTables(1)
		end
	)
end


local function on_event(_frame, e, ...)
  if e == "PLAYER_ENTERING_WORLD" then
	CreateGUI()
    if not CI_hook_installed then
      GameTooltip:HookScript("OnTooltipSetUnit", on_tooltip_set_unit)
      CI_hook_installed = true
	  local localizedClass, englishClass, classIndex = UnitClass("player");
	  CI_PLAYER_CLASS = englishClass
	  CILoadGlobalSettings(CI_DB)
	  CICreateOptions(CI_DB, CI_global_settings)
    end
  elseif e == "MODIFIER_STATE_CHANGED" then
    if UnitExists("mouseover") then
      GameTooltip:SetUnit("mouseover");
    end
  end
end

local frame = CreateFrame("Frame", "ClassicImmunityEvents")
frame:RegisterEvent("PLAYER_ENTERING_WORLD")
frame:RegisterEvent("MODIFIER_STATE_CHANGED")
frame:SetScript("OnEvent", on_event)

SLASH_CLASSICIMMUNITIES1 = "/ciui"
function SlashCmdList.CLASSICIMMUNITIES(msg, editBox)
    ClassicImmunitiesUI:Show()
end
