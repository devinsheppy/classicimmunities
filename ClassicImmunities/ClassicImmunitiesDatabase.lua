-- 3100 -- elder mottled boar for testing
-- 1512 -- duskbat for testing
-- 19 -- for polymorph

-- ["icon_id"] -- used to display immunity icon in tooltip
-- ["display_name"] -- used to display immunity text in tooltip
-- ["class_white_list"] -- player class must be in this list IF ci_show_all_class_immunities == false
-- ["class_black_list"] -- player class must not be in this list IF ci_show_all_class_immunities == false -- redundant?
-- ["creature_type_white_list"] -- creature type must be in this list, this creature is immune
-- ["creature_type_black_list"] -- creature type must not be in this list
-- ["npc_id_white_list"] -- npc id must be in this list
-- ["npc_id_black_list"] -- npc id must not be in this list

-- sorting priority is as follows
-- class_white_list && > npc_id_white_list > npc_id_black_list > creature_type_white_list > creature_type_black_list

function CIGetSpellTexture(spell_id)
	local texture = GetSpellTexture(spell_id);	
	if (texture ~= nil) then
	  local icon = "|T" .. texture .. ":0|t";
	  return icon
	end
	return 'XXX'
end

function CITableFind(t, v)
	for i, v1 in ipairs(t) do
		if t[i] == v then return true end
	end
	return nil
end

function CITableGetImmunityByDisplayName(t, display_name)
	for i, x in ipairs(t) do
		if t[i].display_name == display_name then return t[i] end
	end
	return nil
end

function tprint(tbl, indent)
  if not indent then indent = 0 end
  local toprint = string.rep(" ", indent) .. "{\r\n"
  indent = indent + 2 
  for k, v in pairs(tbl) do
    toprint = toprint .. string.rep(" ", indent)
    if (type(k) == "number") then
      toprint = toprint .. "[" .. k .. "] = "
    elseif (type(k) == "string") then
      toprint = toprint  .. k ..  "= "   
    end
    if (type(v) == "number") then
      toprint = toprint .. v .. ",\r\n"
    elseif (type(v) == "string") then
      toprint = toprint .. "\"" .. v .. "\",\r\n"
    elseif (type(v) == "table") then
      toprint = toprint .. tprint(v, indent + 2) .. ",\r\n"
    else
      toprint = toprint .. "\"" .. tostring(v) .. "\",\r\n"
    end
  end
  toprint = toprint .. string.rep(" ", indent-2) .. "}"
  return toprint
end

_G["ClassicImmunitiesDB"] ={
{["icon_id"]=133,
["display_name"]="Fire",
["class_white_list"]={},
["creature_type_white_list"]={},
["creature_type_black_list"]={},
["npc_id_white_list"]={
4676, 6073, 7135, 7136, 89, 8608, 14668, 8616, 2745, 14461, 9376, 5850, 8910, 14460, 2760, 4038, 4037, 7738, 9178, 7266, 575,
8909, 8911, 11668, 12099, 11666, 11667, 12265, 6521, 3417, 9026, 9816, 8281, 6520, 12143, 2447, 7044, 7045, 7046, 2757, 2759, 2726,
12899, 7846, 9878, 9879, 2091, 9156, 9017, 9016, 9938, 5852, 7664},
["npc_id_black_list"]={}
},

{["icon_id"]=116,
["display_name"]="Frost",
["class_white_list"]={},
["creature_type_white_list"]={},
["creature_type_black_list"]={},
["npc_id_white_list"]={
9453, 6047, 15211, 12876, 3917, 8519, 8521, 10757, 10756, 2761, 10642, 14350, 6220, 691, 13256, 13696, 14457, 5461, 5462, 14269,
12759, 14458, 10664, 10202, 1796, 7429, 7428, 10198, 7358, 6922, 7664},
["npc_id_black_list"]={}
},

{["icon_id"]=403,
["display_name"]="Nature",
["class_white_list"]={},
["creature_type_white_list"]={},
["creature_type_black_list"]={},
["npc_id_white_list"]={
11782, 11781, 14464, 11745, 11745, 6239, 11747, 11746, 832, 11744, 329, 15307, 2791, 4034, 7032, 2736, 9396, 8667, 12101, 12076, 5718, 12496,
11665, 5465, 2735, 9397, 5855, 16043, 12806, 11321, 7031, 13021, 14435, 92, 4499, 2752, 2592, 9377, 14454, 5314, 12498, 5312, 12497, 12900,
5720, 5722, 5721, 5719},
["npc_id_black_list"]={}
},

{["icon_id"]=686,
["display_name"]="Shadow",
["class_white_list"]={},
["creature_type_white_list"]={},
["creature_type_black_list"]={},
["npc_id_white_list"]={
1364, 8197, 3654},
["npc_id_black_list"]={}
},

{["icon_id"]=5143,
["display_name"]="Arcane",
["class_white_list"]={},
["creature_type_white_list"]={},
["creature_type_black_list"]={},
["npc_id_white_list"]={},
["npc_id_black_list"]={}
},

{["icon_id"]=635,
["display_name"]="Holy",
["class_white_list"]={},
["creature_type_white_list"]={},
["creature_type_black_list"]={},
["npc_id_white_list"]={},
["npc_id_black_list"]={}
},

{["icon_id"]=355,
["display_name"]="Taunt",
["class_white_list"]={"WARRIOR", "DRUID"},
["creature_type_white_list"]={},
["creature_type_black_list"]={},
["npc_id_white_list"]={},
["npc_id_black_list"]={}
},

{["icon_id"]=1604,
["display_name"]="Slow",
["class_white_list"]={},
["creature_type_white_list"]={},
["creature_type_black_list"]={},
["npc_id_white_list"]={2447, 7044, 7045, 7046, 2757, 2759, 7846, 9019, 7309, 7076, 7077, 7011, 7012, 7396, 7397, 7664, 8095, 8120},
["npc_id_black_list"]={}
},

{["icon_id"]=122,
["display_name"]="Root",
["class_white_list"]={},
["creature_type_white_list"]={},
["creature_type_black_list"]={},
["npc_id_white_list"]={2447, 7044, 7045, 7046, 2757, 2759, 7846, 9019, 7309, 7076, 7077, 7011, 7012, 7396, 7397, 7664, 8095, 8120},
["npc_id_black_list"]={}
},

{["icon_id"]=853,
["display_name"]="Stun",
["class_white_list"]={},
["creature_type_white_list"]={},
["creature_type_black_list"]={},
["npc_id_white_list"]={2757, 2759, 10202, 7846, 9019, 7664},
["npc_id_black_list"]={}
},

{["icon_id"]=5782,
["display_name"]="Fear",
["class_white_list"]={"WARLOCK", "WARRIOR", "PRIEST"},
["creature_type_white_list"]={},
["creature_type_black_list"]={"Undead", "Mechanical"},
["npc_id_white_list"]={2447, 7044, 7045, 7046, 2757, 2759, 10664, 10202, 1940, 1939, 1942, 1944, 1943, 9019, 7664},
["npc_id_black_list"]={6669, 10996}
},

{["icon_id"]=710,
["display_name"]="Banish",
["class_white_list"]={"WARLOCK"},
["creature_type_white_list"]={"Elemental", "Demon"},
["creature_type_black_list"]={},
["npc_id_white_list"]={7664},
["npc_id_black_list"]={}
},

{["icon_id"]=1098,
["display_name"]="Subjugate Demon",
["class_white_list"]={"WARLOCK"},
["creature_type_white_list"]={"Demon"},
["creature_type_black_list"]={},
["npc_id_white_list"]={7664},
["npc_id_black_list"]={}
},

{["icon_id"]=16511,
["display_name"]="Bleed",
["class_white_list"]={},
["creature_type_white_list"]={},
["creature_type_black_list"]={"Mechanical", "Elemental"},
["npc_id_white_list"]={7664},
["npc_id_black_list"]={}
},

{["icon_id"]=25605,
["display_name"]="Poison",
["class_white_list"]={},
["creature_type_white_list"]={},
["creature_type_black_list"]={"Mechanical", "Elemental"},
["npc_id_white_list"]={2757, 2759, 7664, 5720, 5722, 5721, 5719},
["npc_id_black_list"]={}
},

{["icon_id"]=921,
["display_name"]="Pickpocket",
["class_white_list"]={"ROGUE"},
["creature_type_white_list"]={"Humanoid", "Undead"},
["creature_type_black_list"]={},
["npc_id_white_list"]={
752, 3757, 3755, 3754, 4788, 216659, 4789, 216660, 3767, 3770, 3765, 3771, 9877, 7110, 7107, 7105, 7106, 7111, 7109, 7108, 6200, 6201, 6202, 6126, 6125, 6127, 
3762, 3759, 3758, 3763, 10647, 11454, 11452, 11453, 11455, 11451, 11457, 11456, 12236, 2004, 2002, 2003, 2005, 3662, 3772, 221223, 6115, 11697, 11937, 4677, 4680,
221282, 4619, 5760, 4679, 4682, 4684, 221261, 221262, 221406, 7666, 8717, 6011, 7665, 7461, 7463, 9862, 7728, 12457, 2022, 2027, 2029, 3638, 3640, 3928, 1030, 4393,
1032, 4541, 6219, 4021, 1031, 6218, 1033, 4020, 4391, 9477, 12222, 7086, 4469, 8766, 5235, 6559, 2655, 2656, 4468, 6556, 12221, 6557, 5228, 224242, 7092, 1806, 7093,
8606, 8607, 1808},
["npc_id_black_list"]={}
},

{["icon_id"]=1776,
["display_name"]="Gouge",
["class_white_list"]={"ROGUE"},
["creature_type_white_list"]={},
["creature_type_black_list"]={},
["npc_id_white_list"]={9019, 7664},
["npc_id_black_list"]={}
},

{["icon_id"]=6770,
["display_name"]="Sap",
["class_white_list"]={"ROGUE"},
["creature_type_white_list"]={"Humanoid"},
["creature_type_black_list"]={},
["npc_id_white_list"]={9019},
["npc_id_black_list"]={}
},

{["icon_id"]=2094,
["display_name"]="Blind",
["class_white_list"]={"ROGUE"},
["creature_type_white_list"]={},
["creature_type_black_list"]={},
["npc_id_white_list"]={9019, 7664},
["npc_id_black_list"]={}
},

{["icon_id"]=1725,
["display_name"]="Distract",
["class_white_list"]={"ROGUE"},
["creature_type_white_list"]={},
["creature_type_black_list"]={},
["npc_id_white_list"]={5854, 7039, 6232},
["npc_id_black_list"]={}
},

{["icon_id"]=1766,
["display_name"]="Kick",
["class_white_list"]={"ROGUE"},
["creature_type_white_list"]={},
["creature_type_black_list"]={},
["npc_id_white_list"]={2447, 7358},
["npc_id_black_list"]={}
},

{["icon_id"]=6552,
["display_name"]="Pummel",
["class_white_list"]={"WARRIOR"},
["creature_type_white_list"]={},
["creature_type_black_list"]={},
["npc_id_white_list"]={2447, 7358},
["npc_id_black_list"]={}
},

{["icon_id"]=2139,
["display_name"]="Counterspell",
["class_white_list"]={"MAGE"},
["creature_type_white_list"]={},
["creature_type_black_list"]={},
["npc_id_white_list"]={2447, 7358},
["npc_id_black_list"]={}
},

{["icon_id"]=15487,
["display_name"]="Silence",
["class_white_list"]={"PRIEST"},
["creature_type_white_list"]={},
["creature_type_black_list"]={},
["npc_id_white_list"]={2447, 7358},
["npc_id_black_list"]={}
},

{["icon_id"]=1425,
["display_name"]="Shackle Undead",
["class_white_list"]={"PRIEST"},
["creature_type_white_list"]={"Undead"},
["creature_type_black_list"]={},
["npc_id_white_list"]={},
["npc_id_black_list"]={}
},

{["icon_id"]=605,
["display_name"]="Mind Control",
["class_white_list"]={"PRIEST"},
["creature_type_white_list"]={"Humanoid"},
["creature_type_black_list"]={},
["npc_id_white_list"]={},
["npc_id_black_list"]={}
},

{["icon_id"]=453,
["display_name"]="Mind Soothe",
["class_white_list"]={"PRIEST"},
["creature_type_white_list"]={"Humanoid"},
["creature_type_black_list"]={},
["npc_id_white_list"]={},
["npc_id_black_list"]={}
},

{["icon_id"]=879,
["display_name"]="Exorcism",
["class_white_list"]={"PALADIN"},
["creature_type_white_list"]={"Undead", "Demon"},
["creature_type_black_list"]={},
["npc_id_white_list"]={},
["npc_id_black_list"]={}
},

{["icon_id"]=2878,
["display_name"]="Turn Undead",
["class_white_list"]={"PALADIN"},
["creature_type_white_list"]={"Undead"},
["creature_type_black_list"]={},
["npc_id_white_list"]={},
["npc_id_black_list"]={}
},

{["icon_id"]=118,
["display_name"]="Polymorph",
["class_white_list"]={"MAGE"},
["creature_type_white_list"]={"Humanoid", "Beast", "Critter"},
["creature_type_black_list"]={},
["npc_id_white_list"]={9019, 8929},
["npc_id_black_list"]={}
},

{["icon_id"]=1513,
["display_name"]="Scare Beast",
["class_white_list"]={"HUNTER"},
["creature_type_white_list"]={"Beast"},
["creature_type_black_list"]={},
["npc_id_white_list"]={},
["npc_id_black_list"]={}
},

{["icon_id"]=2637,
["display_name"]="Hibernate",
["class_white_list"]={"DRUID"},
["creature_type_white_list"]={"Beast", "Dragonkin"},
["creature_type_black_list"]={},
["npc_id_white_list"]={},
["npc_id_black_list"]={}
},

{["icon_id"]=2908,
["display_name"]="Soothe Animal",
["class_white_list"]={"DRUID"},
["creature_type_white_list"]={"Beast"},
["creature_type_black_list"]={},
["npc_id_white_list"]={},
["npc_id_black_list"]={}
}
}