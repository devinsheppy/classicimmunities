local CI_DB = _G["ClassicImmunitiesDB"]
local CI_L = _G["ClassicImmunitiesLocalization"]

local CI_hook_installed = false
local CI_PLAYER_CLASS = "None"

CI_global_settings = CI_global_settings

--[[ -- global settings layout

CI_global_settings
{
	{
		["SHOW_ALL_CLASS_IMMUNITIES"] = false, -- if true, ignores the class_uses_immunity_list, showing all immunities
        ["SHOW_FRIENDLY_NPC_IMMUNITIES"] = false -- if true, shows immunities for friendly NPCs like city guards
        ["SHOW_IMMUNITIES_TOOLTIP_HEADER"] = true -- if true, shows "Immunities" header in tooltip before icons
        ["TOOLTIP_ICON_SIZE"] = int 2-36, size of the icons in the tooltip
        ["HOLD_CTRL_TOGGLE_IMMUNITY_NAMES"] = true
        ["DISABLE_CTRL_KEY"] = false
        ["HOLD_ALT_TOGGLE_NPC_ID"] = true
        ["DISABLE_ALT_KEY"] = false
	
		["FILTER_LIST"] =
		{
			["display_name"]="Banish",
			["FILTER_TYPE"]= "CLASS" or "FORCE_ON" or "FORCE_OFF",
		}
	},
}

]]

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
    
    if CI_global_settings.SHOW_FRIENDLY_NPC_IMMUNITIES == nil then
		CI_global_settings.SHOW_FRIENDLY_NPC_IMMUNITIES = false
	end
    
    if CI_global_settings.SHOW_IMMUNITIES_TOOLTIP_HEADER == nil then
		CI_global_settings.SHOW_IMMUNITIES_TOOLTIP_HEADER = true
	end
    
    if CI_global_settings.TOOLTIP_ICON_SIZE == nil then
		CI_global_settings.TOOLTIP_ICON_SIZE = 16
	end
    
    if CI_global_settings.HOLD_CTRL_TOGGLE_IMMUNITY_NAMES == nil then
		CI_global_settings.HOLD_CTRL_TOGGLE_IMMUNITY_NAMES = true
	end
    
    if CI_global_settings.DISABLE_CTRL_KEY == nil then
		CI_global_settings.DISABLE_CTRL_KEY = false
	end
    
    if CI_global_settings.HOLD_ALT_TOGGLE_NPC_ID == nil then
		CI_global_settings.HOLD_ALT_TOGGLE_NPC_ID = true
	end
    
    if CI_global_settings.DISABLE_ALT_KEY == nil then
		CI_global_settings.DISABLE_ALT_KEY = false
	end

	for i, v in ipairs(db) do
		if CITableGetImmunityByDisplayName(CI_global_settings.FILTER_LIST, v.display_name) == nil then
			table.insert(CI_global_settings.FILTER_LIST, { ["display_name"]=v.display_name, ["FILTER_TYPE"]="CLASS" })
		end
	end
end

local function CIAddTooltipHeader(npcID)
    local headline = 'Immunities'
    
    local addNPCID = CI_global_settings.DISABLE_ALT_KEY == false and 
    ((IsAltKeyDown() and CI_global_settings.HOLD_ALT_TOGGLE_NPC_ID) or 
    (IsAltKeyDown() == false and CI_global_settings.HOLD_ALT_TOGGLE_NPC_ID == false))
    
    if addNPCID then
        headline = headline .. ' : NPC ID (|cFFFFFFFF' .. npcID ..'|r)'
        GameTooltip:AddLine(headline)
    else
        if CI_global_settings.SHOW_IMMUNITIES_TOOLTIP_HEADER then
            GameTooltip:AddLine(headline)
        end    
    end
end

local function CISetTooltipImmunities(immuneToAnything, immunityIcons, npcID)

    CIAddTooltipHeader(npcID)
    
    local addImmunityNames = CI_global_settings.DISABLE_CTRL_KEY == false and 
        ((IsControlKeyDown() and CI_global_settings.HOLD_CTRL_TOGGLE_IMMUNITY_NAMES) or 
        (IsControlKeyDown() == false and CI_global_settings.HOLD_CTRL_TOGGLE_IMMUNITY_NAMES == false))

  	if immunityIcons and immuneToAnything then
		if addImmunityNames then
            for i, v in ipairs(immunityIcons) do
				GameTooltip:AddLine(v[1] .. ' ' .. v[2])
			end
		else
			local immuneTextures = ''
			for i, v in ipairs(immunityIcons) do
				immuneTextures = immuneTextures .. v[1] .. ' '
			end
			GameTooltip:AddLine(immuneTextures)
		end
	end
end

local function CIGetCreateImmunityInfo(npc_id, npc_hasCreatureType, npc_localizedCreatureType)
  local isImmuneToAnything = false
  local immunityIcons = { }

	for i, v in ipairs(CI_DB) do

		local globalSetting = CITableGetImmunityByDisplayName(CI_global_settings.FILTER_LIST, v.display_name)
		if globalSetting.FILTER_TYPE == "CLASS" or globalSetting.FILTER_TYPE == "FORCE_ON" then
            
            local doesClassUseImmunity = CI_global_settings.SHOW_ALL_CLASS_IMMUNITIES == true or table.getn(v.class_uses_immunity_list) == 0 or CITableFind(v.class_uses_immunity_list, CI_PLAYER_CLASS)
            if doesClassUseImmunity or globalSetting.FILTER_TYPE == "FORCE_ON" then
                
                local isNPCIDForcedNotImmune = CITableFind(v.npc_id_forced_not_immune_list, npc_id)
                if isNPCIDForcedNotImmune == nil then
                
                    local isNPCIDForcedImmune = CITableFind(v.npc_id_forced_immune_list, npc_id)
                    local isNPCCreatureTypeDefaultImmune = --[[npc_hasCreatureType and]] v.creature_type_is_immune_by_default_list[npc_localizedCreatureType]
                    if isNPCIDForcedImmune or isNPCCreatureTypeDefaultImmune then
                    
                        isImmuneToAnything = true
                        local spell_texture = CIGetIconTexture(v.icon_id, CI_global_settings.TOOLTIP_ICON_SIZE)
                        table.insert(immunityIcons, { spell_texture, v.display_name })
                    end
                end
            end
        end
    end

  return isImmuneToAnything, immunityIcons
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
    
    if not CI_global_settings.SHOW_FRIENDLY_NPC_IMMUNITIES then
        local unitIsEnemy = UnitIsEnemy("player", tt_unit)
        if not unitIsEnemy then
            return
        end
    end

    local c_creatureType = UnitCreatureType(tt_unit)
    local c_creatureTypeLocalizedFound, c_localizedCreatureType = CIGetLocalizedCreatureType(c_creatureType, CI_L)

    local isImmuneToAnything, immunityIcons = CIGetCreateImmunityInfo(npc_id, c_creatureTypeLocalizedFound, c_localizedCreatureType)

    CISetTooltipImmunities(isImmuneToAnything, immunityIcons, npc_id) 
end

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

local frame = CreateFrame("Frame", "ClassicImmunityEvents")
frame:RegisterEvent("PLAYER_ENTERING_WORLD")
frame:RegisterEvent("MODIFIER_STATE_CHANGED")
frame:SetScript("OnEvent", on_event)
