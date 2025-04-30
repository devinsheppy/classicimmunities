function CIGetLocalizedCreatureType(creatureType, db)
	local localizedCreatureType = db[creatureType]
	local foundLocalizedCreatureType = localizedCreatureType ~= nil
	return foundLocalizedCreatureType, localizedCreatureType
end

_G["ClassicImmunitiesLocalization"] ={
	--enUS
	["Beast"] = "Beast",
	["Critter"] = "Critter",
	["Demon"] = "Demon",
	["Dragonkin"] = "Dragonkin",
	["Elemental"] = "Elemental",
	["Giant"] = "Giant",
	["Humanoid"] = "Humanoid",
	["Mechanical"] = "Mechanical",
	["Undead"] = "Undead",
	
	--deDE
	["Wildtier"] = "Beast",
	["Kleintier"] = "Critter",
	["Dämon"] = "Demon",
	["Drachkin"] = "Dragonkin",
	["Elementar"] = "Elemental",
	["Riese"] = "Giant",
	--["Humanoid"] = "Humanoid",
	["Mechanisch"] = "Mechanical",
	["Untoter"] = "Undead",
	
	--frFR
	["Bête"] = "Beast",
	["Bestiole"] = "Critter",
	["Démon"] = "Demon",
	["Draconien"] = "Dragonkin",
	["Elémentaire"] = "Elemental",
	["Géant"] = "Giant",
	["Humanoïde"] = "Humanoid",
	["Machine"] = "Mechanical",
	["Mort-vivant"] = "Undead",
	
	--koKR
	["야수"] = "Beast",
	["동물"] = "Critter",
	["악마"] = "Demon",
	["용족"] = "Dragonkin",
	["정령"] = "Elemental",
	["거인"] = "Giant",
	["인간형"] = "Humanoid",
	["기계"] = "Mechanical",
	["언데드"] = "Undead",
	
	--esES
	["Bestia"] = "Beast",
	["Alma"] = "Critter",
	["Demonio"] = "Demon",
	["Dragón"] = "Dragonkin",
	--["Elemental"] = "Elemental",
	["Gigante"] = "Giant",
	["Humanoide"] = "Humanoid",
	["Mecánico"] = "Mechanical",
	["No-muerto"] = "Undead",
	
	--esMX
	--["Bestia"] = "Beast",
	--["Alma"] = "Critter",
	--["Demonio"] = "Demon",
	["Dragon"] = "Dragonkin",
	--["Elemental"] = "Elemental",
	--["Gigante"] = "Giant",
	--["Humanoide"] = "Humanoid",
	--["Mecánico"] = "Mechanical",
	--["No-muerto"] = "Undead",
	
	--ptBR
	["Fera"] = "Beast",
	["Bicho"] = "Critter",
	["Demônio"] = "Demon",
	["Dracônico"] = "Dragonkin",
	--["Elemental"] = "Elemental",
	--["Gigante"] = "Giant",
	--["Humanoide"] = "Humanoid",
	["Mecânico"] = "Mechanical",
	["Morto-vivo"] = "Undead",
	
	--itIT
	--["Bestia"] = "Beast",
	["Animale"] = "Critter",
	["Demone"] = "Demon",
	["Dragoide"] = "Dragonkin",
	["Elementale"] = "Elemental",
	--["Gigante"] = "Giant",
	["Umanoide"] = "Humanoid",
	["Meccanico"] = "Mechanical",
	["Non Morto"] = "Undead",
	
	--ruRU
	["Животное"] = "Beast",
	["Существо"] = "Critter",
	["Демон"] = "Demon",
	["Дракон"] = "Dragonkin",
	["Элементаль"] = "Elemental",
	["Великан"] = "Giant",
	["Гуманоид"] = "Humanoid",
	["Механизм"] = "Mechanical",
	["Нежить"] = "Undead",
	
	--zhCN
	["野兽"] = "Beast",
	["小动物"] = "Critter",
	["恶魔"] = "Demon",
	["龙类"] = "Dragonkin",
	["元素生物"] = "Elemental",
	["巨人"] = "Giant",
	["人型生物"] = "Humanoid",
	["机械"] = "Mechanical",
	["亡灵"] = "Undead",
	
	--zhTW
	["野獸"] = "Beast",
	["小動物"] = "Critter",
	["惡魔"] = "Demon",
	["龍類"] = "Dragonkin",
	--["元素生物"] = "Elemental",
	--["巨人"] = "Giant",
	--["人型生物"] = "Humanoid",
	["機械"] = "Mechanical",
	["不死族"] = "Undead"
}