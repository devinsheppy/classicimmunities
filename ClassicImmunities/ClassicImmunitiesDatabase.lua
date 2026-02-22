-- 3100 -- elder mottled boar for testing
-- 1512 -- duskbat for testing
-- 19 -- for polymorph

-- ["icon_id"] -- used to display immunity icon in tooltip
-- ["display_name"] -- used to display immunity text in tooltip

-- ["class_uses_immunity_list"] -- player class has spells or abilities that use this immunity
-- ["race_uses_immunity_list"] -- player race has spells or abilities that use this immunity -- undead priest only thing that matters??

-- ["creature_type_is_immune_by_default_list"] -- creature type is immune by default

-- ["npc_id_forced_immune_list"] -- npc id is immune, regardless of creature type
-- ["npc_id_forced_not_immune_list"] -- npc id is not immune, regardless of creature type

-- ["npc_id_info_list] -- text info/descriptions for npc ids {{id1, id2, id3}, {"These satyr can be pickpocketed"}}

function CIGetIconTexture(icon_id, icon_size)
    if (icon_size == nil or icon_size < 0) then
        icon_size = 16
    end

    if (icon_id ~= nil) then
        return "|T" .. icon_id .. ":" .. icon_size .. "|t"
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

_G["ClassicImmunitiesDB"] ={
{["icon_id"]=135812,
["display_name"]="Fire",
["class_uses_immunity_list"]={},
["creature_type_is_immune_by_default_list"]={["None"] = false, ["Beast"] = false, ["Critter"] = false, ["Demon"] = false, ["Dragonkin"] = false, ["Elemental"] = false, ["Giant"] = false, ["Humanoid"] = false, ["Mechanical"] = false, ["Undead"] = false},
["npc_id_forced_immune_list"]={
4676, 6073, 7135, 7136, 89, 8608, 14668, 8616, 2745, 14461, 9376, 5850, 8910, 14460, 2760, 4038, 4037, 7738, 9178, 7266, 575,
8909, 8911, 11668, 12099, 11666, 11667, 12265, 6521, 3417, 9026, 9816, 8281, 6520, 12143, 2447, 7044, 7045, 7046, 2757, 2759, 2726,
12899, 7846, 9878, 9879, 2091, 9156, 9017, 9016, 9938, 5852, 7664},
["npc_id_forced_not_immune_list"]={}
},

{["icon_id"]=135846,
["display_name"]="Frost",
["class_uses_immunity_list"]={},
["creature_type_is_immune_by_default_list"]={["None"] = false, ["Beast"] = false, ["Critter"] = false, ["Demon"] = false, ["Dragonkin"] = false, ["Elemental"] = false, ["Giant"] = false, ["Humanoid"] = false, ["Mechanical"] = false, ["Undead"] = false},
["npc_id_forced_immune_list"]={
9453, 6047, 15211, 12876, 3917, 8519, 8521, 10757, 10756, 2761, 10642, 14350, 6220, 691, 13256, 13696, 14457, 5461, 5462, 14269,
12759, 14458, 10664, 10202, 1796, 7429, 7428, 10198, 7358, 6922, 7664},
["npc_id_forced_not_immune_list"]={}
},

{["icon_id"]=136048,
["display_name"]="Nature",
["class_uses_immunity_list"]={},
["creature_type_is_immune_by_default_list"]={["None"] = false, ["Beast"] = false, ["Critter"] = false, ["Demon"] = false, ["Dragonkin"] = false, ["Elemental"] = false, ["Giant"] = false, ["Humanoid"] = false, ["Mechanical"] = false, ["Undead"] = false},
["npc_id_forced_immune_list"]={
11782, 11781, 14464, 11745, 11745, 6239, 11747, 11746, 832, 11744, 329, 15307, 2791, 4034, 7032, 2736, 9396, 8667, 12101, 12076, 5718, 12496,
11665, 5465, 2735, 9397, 5855, 16043, 12806, 11321, 7031, 13021, 14435, 92, 4499, 2752, 2592, 9377, 14454, 5314, 12498, 5312, 12497, 12900,
5720, 5722, 5721, 5719, 4120},
["npc_id_forced_not_immune_list"]={}
},

{["icon_id"]=136197,
["display_name"]="Shadow",
["class_uses_immunity_list"]={},
["creature_type_is_immune_by_default_list"]={["None"] = false, ["Beast"] = false, ["Critter"] = false, ["Demon"] = false, ["Dragonkin"] = false, ["Elemental"] = false, ["Giant"] = false, ["Humanoid"] = false, ["Mechanical"] = false, ["Undead"] = false},
["npc_id_forced_immune_list"]={
1364, 8197, 3654},
["npc_id_forced_not_immune_list"]={}
},

{["icon_id"]=136096,
["display_name"]="Arcane",
["class_uses_immunity_list"]={},
["creature_type_is_immune_by_default_list"]={["None"] = false, ["Beast"] = false, ["Critter"] = false, ["Demon"] = false, ["Dragonkin"] = false, ["Elemental"] = false, ["Giant"] = false, ["Humanoid"] = false, ["Mechanical"] = false, ["Undead"] = false},
["npc_id_forced_immune_list"]={},
["npc_id_forced_not_immune_list"]={}
},

{["icon_id"]=135920,
["display_name"]="Holy",
["class_uses_immunity_list"]={},
["creature_type_is_immune_by_default_list"]={["None"] = false, ["Beast"] = false, ["Critter"] = false, ["Demon"] = false, ["Dragonkin"] = false, ["Elemental"] = false, ["Giant"] = false, ["Humanoid"] = false, ["Mechanical"] = false, ["Undead"] = false},
["npc_id_forced_immune_list"]={},
["npc_id_forced_not_immune_list"]={}
},

{["icon_id"]=136080,
["display_name"]="Taunt",
["class_uses_immunity_list"]={"WARRIOR", "DRUID"},
["creature_type_is_immune_by_default_list"]={["None"] = false, ["Beast"] = false, ["Critter"] = false, ["Demon"] = false, ["Dragonkin"] = false, ["Elemental"] = false, ["Giant"] = false, ["Humanoid"] = false, ["Mechanical"] = false, ["Undead"] = false},
["npc_id_forced_immune_list"]={16595},
["npc_id_forced_not_immune_list"]={}
},

{["icon_id"]=135860,
["display_name"]="Slow",
["class_uses_immunity_list"]={},
["creature_type_is_immune_by_default_list"]={["None"] = false, ["Beast"] = false, ["Critter"] = false, ["Demon"] = false, ["Dragonkin"] = false, ["Elemental"] = false, ["Giant"] = false, ["Humanoid"] = false, ["Mechanical"] = false, ["Undead"] = false},
["npc_id_forced_immune_list"]={2447, 7044, 7045, 7046, 2757, 2759, 7846, 9019, 7309, 7076, 7077, 7011, 7012, 7396, 7397, 7664, 8095, 8120},
["npc_id_forced_not_immune_list"]={}
},

{["icon_id"]=136100,
["display_name"]="Root",
["class_uses_immunity_list"]={},
["creature_type_is_immune_by_default_list"]={["None"] = false, ["Beast"] = false, ["Critter"] = false, ["Demon"] = false, ["Dragonkin"] = false, ["Elemental"] = false, ["Giant"] = false, ["Humanoid"] = false, ["Mechanical"] = false, ["Undead"] = false},
["npc_id_forced_immune_list"]={2447, 7044, 7045, 7046, 2757, 2759, 7846, 9019, 7309, 7076, 7077, 7011, 7012, 7396, 7397, 7664, 8095, 8120},
["npc_id_forced_not_immune_list"]={}
},

{["icon_id"]=135963,
["display_name"]="Stun",
["class_uses_immunity_list"]={},
["creature_type_is_immune_by_default_list"]={["None"] = false, ["Beast"] = false, ["Critter"] = false, ["Demon"] = false, ["Dragonkin"] = false, ["Elemental"] = false, ["Giant"] = false, ["Humanoid"] = false, ["Mechanical"] = false, ["Undead"] = false},
["npc_id_forced_immune_list"]={2757, 2759, 10202, 7846, 9019, 7664, 16408, 16414, 16471, 16473, 16472, 16470, 16482, 16526, 16544, 16545, 16595, 21148, 18848, 18796},
["npc_id_forced_not_immune_list"]={}
},

{["icon_id"]=136168,
["display_name"]="Bleed",
["class_uses_immunity_list"]={},
["creature_type_is_immune_by_default_list"]={["None"] = false, ["Beast"] = false, ["Critter"] = false, ["Demon"] = false, ["Dragonkin"] = false, ["Elemental"] = true, ["Giant"] = false, ["Humanoid"] = false, ["Mechanical"] = true, ["Undead"] = false},
["npc_id_forced_immune_list"]={7664},
["npc_id_forced_not_immune_list"]={}
},

{["icon_id"]=136016,
["display_name"]="Poison",
["class_uses_immunity_list"]={},
["creature_type_is_immune_by_default_list"]={["None"] = false, ["Beast"] = false, ["Critter"] = false, ["Demon"] = false, ["Dragonkin"] = false, ["Elemental"] = true, ["Giant"] = false, ["Humanoid"] = false, ["Mechanical"] = true, ["Undead"] = false},
["npc_id_forced_immune_list"]={2757, 2759, 7664, 5720, 5722, 5721, 5719},
["npc_id_forced_not_immune_list"]={}
},

{["icon_id"]=136183,
["display_name"]="Fear",
["class_uses_immunity_list"]={"WARLOCK", "WARRIOR", "PRIEST"},
["creature_type_is_immune_by_default_list"]={["None"] = false, ["Beast"] = false, ["Critter"] = false, ["Demon"] = false, ["Dragonkin"] = false, ["Elemental"] = false, ["Giant"] = false, ["Humanoid"] = false, ["Mechanical"] = true, ["Undead"] = true},
["npc_id_forced_immune_list"]={2447, 7044, 7045, 7046, 2757, 2759, 10664, 10202, 1940, 1939, 1942, 1944, 1943, 9019, 7664},
["npc_id_forced_not_immune_list"]={6669, 10996}
},

{["icon_id"]=136135,
["display_name"]="Banish",
["class_uses_immunity_list"]={"WARLOCK"},
["creature_type_is_immune_by_default_list"]={["None"] = true, ["Beast"] = true, ["Critter"] = true, ["Demon"] = false, ["Dragonkin"] = true, ["Elemental"] = false, ["Giant"] = true, ["Humanoid"] = true, ["Mechanical"] = true, ["Undead"] = true},
["npc_id_forced_immune_list"]={7664},
["npc_id_forced_not_immune_list"]={}
},

{["icon_id"]=136154,
["display_name"]="Subjugate Demon",
["class_uses_immunity_list"]={"WARLOCK"},
["creature_type_is_immune_by_default_list"]={["None"] = true, ["Beast"] = true, ["Critter"] = true, ["Demon"] = false, ["Dragonkin"] = true, ["Elemental"] = true, ["Giant"] = true, ["Humanoid"] = true, ["Mechanical"] = true, ["Undead"] = true},
["npc_id_forced_immune_list"]={7664},
["npc_id_forced_not_immune_list"]={}
},

{["icon_id"]=133644,
["display_name"]="Pickpocket",
["class_uses_immunity_list"]={"ROGUE"},
["creature_type_is_immune_by_default_list"]={["None"] = true, ["Beast"] = true, ["Critter"] = true, ["Demon"] = true, ["Dragonkin"] = true, ["Elemental"] = true, ["Giant"] = true, ["Humanoid"] = false, ["Mechanical"] = true, ["Undead"] = false},
["npc_id_forced_immune_list"]={747, 750, 751, 752, 950, 10996},
["npc_id_forced_not_immune_list"]={8766, 3757, 3755, 3754, 4788, 216659, 4789, 216660, 3767, 3770, 3765, 3771, 7110, 7105, 7106, 7109, 7108, 6200, 6201, 6202, 6126, 6125, 6127, 
3762, 3759, 3758, 3763, 10647, 11454, 11452, 11453, 11455, 11451, 11457, 11456, 12236, 3662, 3772, 221223, 2002, 2003, 2004, 2005, 6115, 11697, 11937, 4677, 4680,
221282, 4619, 5760, 4679, 4682, 4684, 221261, 221262, 221406, 7666, 8717, 6011, 7665, 7461, 7463, 7728, 12457, 2022, 2027, 2029, 8606, 8607, 6557, 6559, 7086, 1808, 2656, 7092, 9477, 1032, 6556,
7093, 4469, 4394, 4395, 4393, 5235, 1033, 4392, 224242, 4391, 5228, 1031, 3638, 3640, 3928, 1030, 4541, 6219, 4021, 6218, 4020, 12222, 5235, 2655, 4468, 12221, 1806, 7107, 9877, 7111, 9862, 9454},
},

{["icon_id"]=132155,
["display_name"]="Gouge",
["class_uses_immunity_list"]={"ROGUE"},
["creature_type_is_immune_by_default_list"]={["None"] = false, ["Beast"] = false, ["Critter"] = false, ["Demon"] = false, ["Dragonkin"] = false, ["Elemental"] = false, ["Giant"] = false, ["Humanoid"] = false, ["Mechanical"] = false, ["Undead"] = false},
["npc_id_forced_immune_list"]={9019, 7664},
["npc_id_forced_not_immune_list"]={}
},

{["icon_id"]=132310,
["display_name"]="Sap",
["class_uses_immunity_list"]={"ROGUE"},
["creature_type_is_immune_by_default_list"]={["None"] = true, ["Beast"] = true, ["Critter"] = true, ["Demon"] = true, ["Dragonkin"] = true, ["Elemental"] = true, ["Giant"] = true, ["Humanoid"] = false, ["Mechanical"] = true, ["Undead"] = true},
["npc_id_forced_immune_list"]={9019, 17455, 17281, 16700, 17465, 18323},
["npc_id_forced_not_immune_list"]={}
},

{["icon_id"]=136175,
["display_name"]="Blind",
["class_uses_immunity_list"]={"ROGUE"},
["creature_type_is_immune_by_default_list"]={["None"] = true, ["Beast"] = false, ["Critter"] = false, ["Demon"] = false, ["Dragonkin"] = false, ["Elemental"] = false, ["Giant"] = false, ["Humanoid"] = false, ["Mechanical"] = false, ["Undead"] = false},
["npc_id_forced_immune_list"]={9019, 7664},
["npc_id_forced_not_immune_list"]={}
},

{["icon_id"]=132289,
["display_name"]="Distract",
["class_uses_immunity_list"]={"ROGUE"},
["creature_type_is_immune_by_default_list"]={["None"] = false, ["Beast"] = false, ["Critter"] = false, ["Demon"] = false, ["Dragonkin"] = false, ["Elemental"] = false, ["Giant"] = false, ["Humanoid"] = false, ["Mechanical"] = false, ["Undead"] = false},
["npc_id_forced_immune_list"]={5854, 7039, 6232, 19166},
["npc_id_forced_not_immune_list"]={}
},

{["icon_id"]=132219,
["display_name"]="Kick",
["class_uses_immunity_list"]={"ROGUE"},
["creature_type_is_immune_by_default_list"]={["None"] = false, ["Beast"] = false, ["Critter"] = false, ["Demon"] = false, ["Dragonkin"] = false, ["Elemental"] = false, ["Giant"] = false, ["Humanoid"] = false, ["Mechanical"] = false, ["Undead"] = false},
["npc_id_forced_immune_list"]={2447, 7358},
["npc_id_forced_not_immune_list"]={}
},

{["icon_id"]=132320,
["display_name"]="Stealth",
["class_uses_immunity_list"]={"ROGUE", "DRUID"},
["creature_type_is_immune_by_default_list"]={["None"] = false, ["Beast"] = false, ["Critter"] = false, ["Demon"] = false, ["Dragonkin"] = false, ["Elemental"] = false, ["Giant"] = false, ["Humanoid"] = false, ["Mechanical"] = false, ["Undead"] = false},
["npc_id_forced_immune_list"]={11673, 11671, 8921, 8922, 16164, 16449, 16448, 10411, 17264, 17280, 16507, 17669, 17462, 17461, 20923, 17671, 17727, 21694, 17958, 16504},
["npc_id_forced_not_immune_list"]={}
},

{["icon_id"]=132938,
["display_name"]="Pummel",
["class_uses_immunity_list"]={"WARRIOR"},
["creature_type_is_immune_by_default_list"]={["None"] = false, ["Beast"] = false, ["Critter"] = false, ["Demon"] = false, ["Dragonkin"] = false, ["Elemental"] = false, ["Giant"] = false, ["Humanoid"] = false, ["Mechanical"] = false, ["Undead"] = false},
["npc_id_forced_immune_list"]={2447, 7358},
["npc_id_forced_not_immune_list"]={}
},

{["icon_id"]=135856,
["display_name"]="Counterspell",
["class_uses_immunity_list"]={"MAGE"},
["creature_type_is_immune_by_default_list"]={["None"] = false, ["Beast"] = false, ["Critter"] = false, ["Demon"] = false, ["Dragonkin"] = false, ["Elemental"] = false, ["Giant"] = false, ["Humanoid"] = false, ["Mechanical"] = false, ["Undead"] = false},
["creature_type_white_list"]={},
["creature_type_black_list"]={},
["npc_id_forced_immune_list"]={2447, 7358},
["npc_id_forced_not_immune_list"]={}
},

{["icon_id"]=136164,
["display_name"]="Silence",
["class_uses_immunity_list"]={"PRIEST"},
["creature_type_is_immune_by_default_list"]={["None"] = false, ["Beast"] = false, ["Critter"] = false, ["Demon"] = false, ["Dragonkin"] = false, ["Elemental"] = false, ["Giant"] = false, ["Humanoid"] = false, ["Mechanical"] = false, ["Undead"] = false},
["npc_id_forced_immune_list"]={2447, 7358},
["npc_id_forced_not_immune_list"]={}
},

{["icon_id"]=136091,
["display_name"]="Shackle Undead",
["class_uses_immunity_list"]={"PRIEST"},
["creature_type_is_immune_by_default_list"]={["None"] = true, ["Beast"] = true, ["Critter"] = true, ["Demon"] = true, ["Dragonkin"] = true, ["Elemental"] = true, ["Giant"] = true, ["Humanoid"] = true, ["Mechanical"] = true, ["Undead"] = false},
["npc_id_forced_immune_list"]={},
["npc_id_forced_not_immune_list"]={}
},

{["icon_id"]=136206,
["display_name"]="Mind Control",
["class_uses_immunity_list"]={"PRIEST"},
["creature_type_is_immune_by_default_list"]={["None"] = true, ["Beast"] = true, ["Critter"] = true, ["Demon"] = true, ["Dragonkin"] = true, ["Elemental"] = true, ["Giant"] = true, ["Humanoid"] = false, ["Mechanical"] = true, ["Undead"] = true},
["npc_id_forced_immune_list"]={},
["npc_id_forced_not_immune_list"]={}
},

{["icon_id"]=135933,
["display_name"]="Mind Soothe",
["class_uses_immunity_list"]={"PRIEST"},
["creature_type_is_immune_by_default_list"]={["None"] = true, ["Beast"] = true, ["Critter"] = true, ["Demon"] = true, ["Dragonkin"] = true, ["Elemental"] = true, ["Giant"] = true, ["Humanoid"] = false, ["Mechanical"] = true, ["Undead"] = true},
["npc_id_forced_immune_list"]={},
["npc_id_forced_not_immune_list"]={}
},

{["icon_id"]=135903,
["display_name"]="Exorcism",
["class_uses_immunity_list"]={"PALADIN"},
["creature_type_is_immune_by_default_list"]={["None"] = true, ["Beast"] = true, ["Critter"] = true, ["Demon"] = false, ["Dragonkin"] = true, ["Elemental"] = true, ["Giant"] = true, ["Humanoid"] = true, ["Mechanical"] = true, ["Undead"] = false},
["npc_id_forced_immune_list"]={},
["npc_id_forced_not_immune_list"]={}
},

{["icon_id"]=135983,
["display_name"]="Turn Undead",
["class_uses_immunity_list"]={"PALADIN"},
["creature_type_is_immune_by_default_list"]={["None"] = true, ["Beast"] = true, ["Critter"] = true, ["Demon"] = true, ["Dragonkin"] = true, ["Elemental"] = true, ["Giant"] = true, ["Humanoid"] = true, ["Mechanical"] = true, ["Undead"] = false},
["npc_id_forced_immune_list"]={},
["npc_id_forced_not_immune_list"]={}
},

{["icon_id"]=136071,
["display_name"]="Polymorph",
["class_uses_immunity_list"]={"MAGE"},
["creature_type_is_immune_by_default_list"]={["None"] = true, ["Beast"] = false, ["Critter"] = false, ["Demon"] = true, ["Dragonkin"] = true, ["Elemental"] = true, ["Giant"] = true, ["Humanoid"] = false, ["Mechanical"] = true, ["Undead"] = true},
["npc_id_forced_immune_list"]={9019, 8929},
["npc_id_forced_not_immune_list"]={}
},

{["icon_id"]=132118,
["display_name"]="Scare Beast",
["class_uses_immunity_list"]={"HUNTER"},
["creature_type_is_immune_by_default_list"]={["None"] = true, ["Beast"] = false, ["Critter"] = true, ["Demon"] = true, ["Dragonkin"] = true, ["Elemental"] = true, ["Giant"] = true, ["Humanoid"] = true, ["Mechanical"] = true, ["Undead"] = true},
["npc_id_forced_immune_list"]={},
["npc_id_forced_not_immune_list"]={}
},

{["icon_id"]=136090,
["display_name"]="Hibernate",
["class_uses_immunity_list"]={"DRUID"},
["creature_type_is_immune_by_default_list"]={["None"] = true, ["Beast"] = false, ["Critter"] = true, ["Demon"] = true, ["Dragonkin"] = false, ["Elemental"] = true, ["Giant"] = true, ["Humanoid"] = true, ["Mechanical"] = true, ["Undead"] = true},
["npc_id_forced_immune_list"]={},
["npc_id_forced_not_immune_list"]={}
},

{["icon_id"]=132163,
["display_name"]="Soothe Animal",
["class_uses_immunity_list"]={"DRUID"},
["creature_type_is_immune_by_default_list"]={["None"] = true, ["Beast"] = false, ["Critter"] = true, ["Demon"] = true, ["Dragonkin"] = true, ["Elemental"] = true, ["Giant"] = true, ["Humanoid"] = true, ["Mechanical"] = true, ["Undead"] = true},
["npc_id_forced_immune_list"]={},
["npc_id_forced_not_immune_list"]={}
}
}