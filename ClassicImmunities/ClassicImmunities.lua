local DB = _G["ClassicImmunities"]

local ci_show_all_class_immunities = false -- if true, ignores the whitelist and blacklist for classes, showing all immunities

local hook_installed = false
local CI_PLAYER_CLASS = "None"

local CI_LOGGING = false
local CI_DEBUGGING = false

CI_temp_database_settings = {}

local function CIGetSpellTexture(spell_id)
	local texture = GetSpellTexture(spell_id);	
	if (texture ~= nil) then
	  local icon = "|T" .. texture .. ":0|t";
	  return icon
	end
	return 'XXX'
end

local function CITableFind(t, v)
	for i, v1 in ipairs(t) do
		if t[i] == v then return true end
	end
	return nil
end

local function CIAddToTempDatabase(npcID, playerClass, immunity)
	if CITableFind(CI_temp_database_settings, npcID) == nil then
		table.insert(CI_temp_database_settings, npcID)
	end
end

local function CIPrintTempDatabase()
	for i, v1 in ipairs(CI_temp_database_settings) do
		print('y')
		print(v1)
	end
end

local function CISetTooltipImmunities(immunityIcons, npcID)
  	if immunityIcons then
		local headline = 'Immunities'
		if IsAltKeyDown() then
			headline = headline .. ' : ' .. npcID
			--CIAddToTempDatabase(npcID, CI_PLAYER_CLASS, nil)
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
	
	for i, v in ipairs(DB) do	
		local classInWhiteList = table.getn(v.class_white_list) == 0 or CITableFind(v.class_white_list, CI_PLAYER_CLASS)
		
		local creatureTypeInWhiteList = table.getn(v.creature_type_white_list) == 0 or CITableFind(v.creature_type_white_list, c_creatureType)
		local creatureTypeInBlackList = table.getn(v.creature_type_black_list) > 0 and CITableFind(v.creature_type_black_list, c_creatureType)
		
		local npcIDInWhiteList = CITableFind(v.npc_id_white_list, npc_id)
		local npcIDInBlackList = CITableFind(v.npc_id_black_list, npc_id)
		
		if CI_LOGGING then
			print("------------------")
			print("immunity: " .. tostring(v.display_name))
			print("npc_id: " .. tostring(npc_id))
			print("classInWhiteList: " .. tostring(classInWhiteList))
			print("creatureTypeInWhiteList: " .. tostring(creatureTypeInWhiteList))
			print("creatureTypeInBlackList: " .. tostring(creatureTypeInBlackList))
			print("npcIDInWhiteList: " .. tostring(npcIDInWhiteList))
			print("npcIDInBlackList: " .. tostring(npcIDInBlackList))
			print("------------------")
		end
		
		if CI_DEBUGGING and npc_id == 3100 then
			local spell_texture = CIGetSpellTexture(v.icon_id)
			table.insert(immunityIcons, { spell_texture, v.display_name })
		end
	
		if ci_show_all_class_immunities or classInWhiteList then
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
  
  if isImmuneToAnything then	
	CISetTooltipImmunities(immunityIcons, npc_id)
  end    
end

local function on_event(_frame, e, ...)
  if e == "PLAYER_ENTERING_WORLD" then
    if not hook_installed then
      GameTooltip:HookScript("OnTooltipSetUnit", on_tooltip_set_unit)
      hook_installed = true
	  local playerClass, englishClass = UnitClass("player");
	  CI_PLAYER_CLASS = playerClass
	  --print("ClassicImmunities Loaded")
	  --print(table.getn(CI_temp_database_settings))
	  --CIPrintTempDatabase()
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
