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
end

local function CISetTooltipImmunities(immuneToAnything, immunityIcons, npcID)
  	if immunityIcons and immuneToAnything then
		local headline = 'Immunities'
		if IsAltKeyDown() then
			headline = headline .. ' : NPC ID (' .. npcID ..')'
		end
		GameTooltip:AddLine(headline)
		if not IsControlKeyDown() then
			local immuneTextures = ''
			for i, v in ipairs(immunityIcons) do
				immuneTextures = immuneTextures .. v[1] .. ' '
			end
			GameTooltip:AddLine(immuneTextures)
		else
			for i, v in ipairs(immunityIcons) do
				GameTooltip:AddLine(v[1] .. ' ' .. v[2])
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
					table.insert(immunityIcons, { spell_texture, display_name })
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
					table.insert(immunityIcons, { spell_texture, v.display_name })
				end
			
				if CI_global_settings.SHOW_ALL_CLASS_IMMUNITIES or classInWhiteList then
					if npcIDInWhiteList then
						local spell_texture = CIGetSpellTexture(v.icon_id)
						table.insert(immunityIcons, { spell_texture, v.display_name })
						isImmuneToAnything = true
					else
						if creatureTypeInBlackList and npcIDInBlackList == nil then
							local spell_texture = CIGetSpellTexture(v.icon_id)
							table.insert(immunityIcons, { spell_texture, v.display_name })
							isImmuneToAnything = true
						else
							if creatureTypeInWhiteList == nil then
								local spell_texture = CIGetSpellTexture(v.icon_id)
								table.insert(immunityIcons, { spell_texture, v.display_name })
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
	end
end

local f = CreateFrame("Frame")
f:RegisterEvent("ADDON_LOADED")
f:SetScript("OnEvent", default)

local function on_event(_frame, e, ...)
  if e == "PLAYER_ENTERING_WORLD" then
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

local event_first_part ={"SPELL","SPELL_PERIODIC"}
local event_second_part={"_DAMAGE","_AURA_APPLIED","_AURA_APPLIED_DOSE","_AURA_REFRESH","_LEECH","_DRAIN"}
local non_immune_events ={}
for k1,v1 in pairs(event_second_part) do
	for k2,v2 in pairs(event_first_part) do
		non_immune_events[v2 .. v1] = true
	end
end

local function RecordImmunities(self, event)
	local _,subevent,_,sourceGUID,_,_,_,destGUID,destName,_,_,spellId,_,spellSchool = CombatLogGetCurrentEventInfo()
	if destName ~= "nil" and destGUID ~= "0000000000000000" then
		local dest_unitType, _, _, _, _, destID, _ = strsplit("-", destGUID)
		local destID = tonumber(destID)
		if dest_unitType ~= "Pet" and dest_unitType ~= "Player" then
			if non_immune_events[subevent] then
				if CI_database[destID] == nil then
					CI_database[destID] = {}
				end
				CI_database[destID][spellId] = false
			elseif subevent == "SPELL_MISSED" or subevent == "SPELL_PERIODIC_MISSED" then
				local missType,_ ,_,_ = select(15, CombatLogGetCurrentEventInfo())
				if missType == "IMMUNE" then
					if CI_database[destID] == nil then
						CI_database[destID] = {}
					end
					-- check for false positive
					if CI_database[destID][spellId] == nil then
						CI_database[destID][spellId] = true
					end
				end
			end
		end
	end
end

local f = CreateFrame("Frame", "ClassicImmunityRecordImmunities")
f:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
f:SetScript("OnEvent", RecordImmunities)

local frame = CreateFrame("Frame", "ClassicImmunityEvents")
frame:RegisterEvent("PLAYER_ENTERING_WORLD")
frame:RegisterEvent("MODIFIER_STATE_CHANGED")
frame:SetScript("OnEvent", on_event)
