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
	local texture = GetSpellTexture(spell_id) or GetSpellTexture(25675)
	return "|T" .. texture .. ":0|t"
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

CI_school_colours={}
CI_school_colours[1] = {255,255,0} -- physical
CI_school_colours[2] = {255,230,128} -- holy
CI_school_colours[4] = {255,128,0} -- fire
CI_school_colours[8] = {77,255,77} -- nature
CI_school_colours[16] = {128,255,255} -- frost
CI_school_colours[32] = {128,128,255} -- shadow
CI_school_colours[64] = {255,128,255} -- arcane

CI_effects_db = {}
CI_effects_db.asleep = {2637, 19386, 700, 18658, 462577, 367728, 8040, 24133, 24360, 15970, 18657, 24335, 26093, 1090, 24664, 26180, 7967, 16798, 24132, 450662, 15822, 20989, 448572, 3636, 8901, 12098, 20663, 24004, 446296, 447890, 448779, 8399, 8902, 9159, 20669, 24778, 449879, 460756}
CI_effects_db.banish = {18647, 710, 458389, 16451, 458399, 8994, 457569, 27565, 16045, 465352}
CI_effects_db.bleed = {414644, 1079, 1943, 703, 9896, 11275, 772, 11290, 6547, 407794, 424573, 430723, 19771, 12721, 9493, 11274, 11573, 11574, 412613, 15976, 21949, 29915, 417448, 6548, 11289, 13443, 14331, 3147, 9752, 9894, 24332, 27638, 412609, 8818, 9492, 15583, 17153, 18202, 27555, 8639, 11572, 12868, 13445, 14903, 24192, 5597, 5598, 6546, 8633, 13318, 14087, 14118, 16403, 18075, 18078, 18200, 27556, 436332, 462728, 462730, 8640, 9824, 9826, 10266, 11273, 12162, 16095, 16406, 16509, 23256, 24331, 28911, 462724, 462727, 4102, 4244, 8631, 8632, 9007, 11977, 12054, 12850, 13738, 14874, 16393, 17504, 18106, 28913, 30285, 462726, 462729}
CI_effects_db.charm = {20604, 605, 1098, 10912, 6358, 11726, 26740, 10911, 8356, 11446, 20882, 14515, 11725, 13181, 17405, 15859, 16053, 24327, 7645, 19469, 20740, 429687, 429688}
CI_effects_db.disarm = {676, 6713, 25057, 25655, 22691, 8379, 10851, 22419, 5259, 11879, 6608, 15752, 23365, 27581, 409495, 445282, 13534, 14180, 458880}
CI_effects_db.disorient = {2094, 19503, 446391, 26108, 447563, 446707}
CI_effects_db.distract = {1725, 5376, 15055, 15054}
CI_effects_db.flee = {5246, 5782, 19408, 18431, 6215, 8122, 10890, 461125, 5484, 12096, 23275, 425891, 7399, 14327, 26042, 17928, 14100, 445498, 1513, 8124, 22686, 19134, 26070, 26641, 29544, 6213, 6605, 21330, 21869, 27610, 29685, 460084, 460727, 10888, 20511, 13704, 25815, 26580, 437928, 460086, 5134, 16096, 29168, 29419, 3109, 7093, 8225, 22678, 22884, 25260, 27641, 27990, 30001, 31365, 411959, 443990, 8715, 12542, 14326, 16508, 21898, 28315, 30002, 444522, 447579}
CI_effects_db.frozen = {11958, 27619, 3355, 14309, 14308}
CI_effects_db.grip = {5917, 507, 474, 867}
CI_effects_db.heal = {7927, 18610, 30020, 3268, 10839, 1159, 10838, 18608, 24413, 24414, 746, 7926, 23567, 23696, 3267, 23569, 24412, 23568}
CI_effects_db.incapacitate = {1776, 6770, 20066, 11286, 12540, 22570, 11297, 2070, 13327, 24698, 8629, 11285, 15091, 1777, 17145, 28456, 13579, 15744, 16046, 17277, 22424, 23039, 23113, 25049}
CI_effects_db.interrupt = {2139, 15122, 20537, 20788, 29443, 10887, 19639}
CI_effects_db.invulnerable = {642, 1022, 498, 25771, 10278, 5573, 1020, 5599, 458371, 458312, 442948}
CI_effects_db.polymorph = {118, 22274, 12826, 28270, 28272, 11641, 28271, 12824, 13323, 18503, 23603, 851, 4060, 402686, 16707, 228, 12825, 16709, 457326, 16097, 10253, 450600, 17172, 26157, 27760, 14621, 29848, 434754, 15534, 16708, 22566, 24053, 24712, 26272, 17738, 24713, 24735, 24736, 26273, 26274}
CI_effects_db.root = {463448, 339, 15474, 6533, 14030, 12252, 30094, 13119, 15609, 16566, 15531, 10852, 443265, 8142, 24110, 12023, 9853, 11264, 10017, 16469, 22127, 8312, 22519, 22744, 9852, 13608, 19229, 19974, 22645, 22924, 446731, 1062, 5195, 5196, 26071, 14907, 25999, 28991, 404275, 440574, 447590, 113, 11922, 8346, 12748, 15532, 19970, 19971, 19973, 19975, 20654, 24152, 29849, 460690, 745, 4962, 5567, 9915, 11820, 11831, 12024, 12674, 13099, 13138, 15471, 19972, 20699, 21331, 22994, 23694, 28297, 368329, 435991, 441453, 448156, 448160, 465230, 512, 3542, 8377, 12494, 12747, 15063, 19185, 22415, 22800, 24648, 28858, 446631, 450005}
CI_effects_db.shackle = {9485, 10955, 9484}
CI_effects_db.shield = {17, 10901, 6788, 27607, 10898, 3747, 10900, 6065, 600, 6066, 22752, 592, 20706, 10899}
CI_effects_db.silence = {19393, 15487, 3589, 436534, 8281, 8988, 12528, 9552, 19821, 7074, 23207, 27559, 16838, 18469, 18498, 23918, 26069, 6726, 6942, 29943, 435968, 446639, 462664, 18278, 18425, 24687, 30225, 22666, 436828, 447589, 12946, 18327, 24259}
CI_effects_db.snare = {19496, 12323, 18223, 5116, 22639, 10987, 12705, 27634, 367740, 407548, 437617, 6136, 26379, 3600, 246, 7321, 17174, 3604, 7279, 7992, 9080, 13747, 25187, 406680, 5159, 12486, 25022, 26143, 29407, 404316, 89, 6146, 13810, 18118, 426495, 10855, 12485, 12531, 16050, 16568, 18328, 22356, 23953, 446573, 448573, 3409, 8716, 11201, 12484, 14897, 22914, 22919, 23600, 25809, 26078, 27640, 27993, 438142, 12551, 14207, 17165, 18802, 24415, 26141, 412526, 425239, 438720, 443813, 6984, 6985, 11436, 18972, 19137, 24225, 26211}
CI_effects_db.stun = {1833, 400009, 408, 853, 20277, 19780, 20549, 9005, 8643, 12809, 10308, 463168, 19641, 21749, 23618, 12562, 19798, 8983, 20683, 11650, 27757, 436831, 446728, 447555, 449890, 452857, 462586, 4068, 6266, 6524, 15239, 17286, 835, 23364, 5211, 462260, 2880, 12798, 16104, 16600, 17308, 19769, 22592, 4064, 18812, 20276, 22289, 3635, 15655, 20170, 446354, 5588, 13237, 14902, 20615, 3143, 5589, 9823, 17500, 20310, 21152, 3242, 3609, 5106, 7922, 11430, 11876, 15269, 15593, 15743, 15847, 18144, 25852, 429147, 56, 3551, 5276, 5708, 7139, 7803, 7964, 8285, 11836, 12421, 12734, 13902, 15535, 15753, 18395, 18763, 19410, 19784, 21099, 4065, 4066, 5164, 6253, 6728, 6982, 9827, 12355, 12543, 13808, 15878, 16350, 19136, 19482, 20253, 22427, 24375, 25189, 25653, 3263, 4069, 6409, 6435, 6607, 8150, 12461, 14102, 15398, 16497, 16727, 16869, 17293, 19128, 19364, 21748, 22915, 23103, 24213, 25056, 367741, 407546, 436100, 436473, 437324, 438721, 446489, 462395, 464650, 45, 4067, 5530, 5703, 6304, 6466, 6730, 6798, 8208, 8242, 8646, 10856, 11020, 15618, 16075, 16740, 16922, 17276, 18093, 18103, 20685, 23919, 24333, 24394, 25654, 27758, 27880, 28314, 28445, 28725, 30732, 411688, 440586, 447238, 462258, 462259, 3446, 5403, 5648, 5649, 5918, 6749, 6927, 6945, 8391, 11428, 13005, 15283, 15621, 15652, 16790, 16803, 17011, 20614, 21990, 22692, 23454, 24600, 24671, 27615, 28125, 427746, 437915, 460403}
CI_effects_db.turn = {10326, 2878, 5627}

CI_effects_db.poison = {399963, 9991, 2094, 14280, 458820, 15852, 439471, 19386, 16468, 25295, 23299, 3043, 13550, 425737, 14532, 13555, 28776, 410140, 24587, 3034, 11469, 11471, 14792, 21787, 25497, 29865, 1056, 4286, 11470, 11539, 23862, 24011, 24725, 418442, 24321, 25053, 446294, 14276, 425733, 425735, 24640, 13551, 24133, 1978, 7125, 17330, 25811, 744, 14277, 425734, 6727, 2818, 8313, 12766, 13554, 17196, 22661, 23169, 7992, 13884, 14275, 14279, 25349, 3815, 11790, 16401, 24335, 25187, 26052, 447563, 3609, 5208, 5760, 13526, 13552, 14795, 17197, 21067, 24111, 25991, 28431, 29220, 30043, 370439, 425736, 3332, 6558, 6814, 7365, 8685, 8689, 11337, 13518, 24003, 24583, 26180, 28796, 32309, 425730, 434315, 437390, 437425, 7947, 11354, 11638, 13224, 18949, 21687, 24132, 24134, 24135, 25812, 348005, 425728, 425732, 438089, 3409, 5416, 6751, 8256, 8680, 11201, 11336, 13223, 13549, 13582, 14110, 14897, 15664, 16460, 17170, 18197, 19452, 19469, 20629, 21952, 24002, 24097, 24320, 24336, 25424, 25809, 26078, 434313, 434314, 447894, 2819, 3358, 3388, 3396, 3583, 5105, 6647, 6917, 8382, 8806, 11335, 11353, 11398, 11918, 12280, 13222, 13298, 13553, 15475, 15656, 16427, 16528, 16573, 16866, 17158, 17183, 17292, 17511, 18208, 19448, 21069, 22937, 23260, 24131, 24586, 25262, 25348, 25645, 25810, 26601, 28311, 29169, 425729, 434312, 439473, 443813, 446319, 4940, 6411, 6531, 7357, 7951, 8257, 8275, 8363, 8692, 12251, 13218, 14108, 14534, 16400, 16552, 16554, 18077, 18203, 21971, 22335, 22412, 24099, 24688, 25605, 27806, 422996, 434316, 435169, 439472}
CI_effects_db.taunt = {407631, 355, 5209, 1161, 403828, 20560, 6795, 412789, 410412, 23790, 25473, 408693, 442233, 408687, 694, 408690, 7400, 440589, 442226, 29060, 4092, 20559, 28140, 21860, 408681, 408685, 408689, 409372, 433672, 7402, 21008, 408683, 408688, 4101, 4507, 7211, 9741}
CI_effects_db.leech_health = {19280, 18265, 689, 11700, 2944, 22651, 18881, 18879, 462228, 403689, 699, 19279, 19277, 460658, 709, 403677, 16608, 18880, 19276, 7651, 11699, 28542, 460899, 16603, 403687, 18557, 19278, 27994, 403688, 403685, 4538, 9373, 17238, 17620, 24435, 3358, 3388, 5219, 7290, 8382, 16430, 17173, 20743, 24300, 403686, 2969, 24618, 465108}

_G["ClassicImmunitiesDB"] ={
{["icon_id"]=133,
["display_name"]="Fire",
["class_white_list"]={},
["creature_type_white_list"]={},
["creature_type_black_list"]={},
["npc_id_white_list"]={
4676, 6073, 7135, 7136, 89, 8608, 14668, 8616, 2745, 14461, 9376, 5850, 8910, 14460, 2760, 4038, 4037, 7738, 9178, 7266, 575,
8909, 8911, 11668, 12099, 11666, 11667, 12265, 6521, 3417, 9026, 9816, 8281, 6520, 12143, 2447, 7044, 7045, 7046, 2757, 2759, 2726,
12899, 7846, 9878, 9879, 2091, 9156, 9017, 9016, 9938, 5852},
["npc_id_black_list"]={}
},

{["icon_id"]=116,
["display_name"]="Frost",
["class_white_list"]={},
["creature_type_white_list"]={},
["creature_type_black_list"]={},
["npc_id_white_list"]={
9453, 6047, 15211, 12876, 3917, 8519, 8521, 10757, 10756, 2761, 10642, 14350, 6220, 691, 13256, 13696, 14457, 5461, 5462, 14269,
12759, 14458, 10664, 10202, 1796, 7429, 7428, 10198, 7358, 6922},
["npc_id_black_list"]={}
},

{["icon_id"]=403,
["display_name"]="Nature",
["class_white_list"]={},
["creature_type_white_list"]={},
["creature_type_black_list"]={},
["npc_id_white_list"]={
11782, 11781, 14464, 11745, 11745, 6239, 11747, 11746, 832, 11744, 329, 15307, 2791, 4034, 7032, 2736, 9396, 8667, 12101, 12076,
11665, 5465, 2735, 9397, 5855, 16043, 12806, 11321, 7031, 13021, 14435, 92, 4499, 2752, 2592, 9377, 14454},
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
["npc_id_white_list"]={2447, 7044, 7045, 7046, 2757, 2759, 7846, 9019, 7309, 7076, 7077, 7011, 7012, 7396, 7397},
["npc_id_black_list"]={}
},

{["icon_id"]=122,
["display_name"]="Root",
["class_white_list"]={},
["creature_type_white_list"]={},
["creature_type_black_list"]={},
["npc_id_white_list"]={2447, 7044, 7045, 7046, 2757, 2759, 7846, 9019, 7309, 7076, 7077, 7011, 7012, 7396, 7397},
["npc_id_black_list"]={}
},

{["icon_id"]=853,
["display_name"]="Stun",
["class_white_list"]={},
["creature_type_white_list"]={},
["creature_type_black_list"]={},
["npc_id_white_list"]={2757, 2759, 10202, 7846, 9019},
["npc_id_black_list"]={}
},

{["icon_id"]=5782,
["display_name"]="Fear",
["class_white_list"]={"WARLOCK", "WARRIOR", "PRIEST"},
["creature_type_white_list"]={},
["creature_type_black_list"]={"Undead", "Mechanical"},
["npc_id_white_list"]={2447, 7044, 7045, 7046, 2757, 2759, 10664, 10202, 1940, 1939, 1942, 1944, 1943, 9019},
["npc_id_black_list"]={6669, 10996}
},

{["icon_id"]=710,
["display_name"]="Banish",
["class_white_list"]={"WARLOCK"},
["creature_type_white_list"]={"Elemental"},
["creature_type_black_list"]={},
["npc_id_white_list"]={},
["npc_id_black_list"]={}
},

{["icon_id"]=1098,
["display_name"]="Subjugate Demon",
["class_white_list"]={"WARLOCK"},
["creature_type_white_list"]={"Demon"},
["creature_type_black_list"]={},
["npc_id_white_list"]={},
["npc_id_black_list"]={}
},

{["icon_id"]=16511,
["display_name"]="Bleed",
["class_white_list"]={},
["creature_type_white_list"]={},
["creature_type_black_list"]={"Mechanical", "Elemental"},
["npc_id_white_list"]={},
["npc_id_black_list"]={}
},

{["icon_id"]=25605,
["display_name"]="Poison",
["class_white_list"]={},
["creature_type_white_list"]={},
["creature_type_black_list"]={"Mechanical", "Elemental"},
["npc_id_white_list"]={2757, 2759},
["npc_id_black_list"]={}
},

{["icon_id"]=921,
["display_name"]="Pickpocket",
["class_white_list"]={"ROGUE"},
["creature_type_white_list"]={"Humanoid", "Undead"},
["creature_type_black_list"]={},
["npc_id_white_list"]={},
["npc_id_black_list"]={}
},

{["icon_id"]=1776,
["display_name"]="Gouge",
["class_white_list"]={"ROGUE"},
["creature_type_white_list"]={},
["creature_type_black_list"]={},
["npc_id_white_list"]={9019},
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
["npc_id_white_list"]={9019},
["npc_id_black_list"]={}
},

{["icon_id"]=1725,
["display_name"]="Distract",
["class_white_list"]={"ROGUE"},
["creature_type_white_list"]={},
["creature_type_black_list"]={},
["npc_id_white_list"]={5854},
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
