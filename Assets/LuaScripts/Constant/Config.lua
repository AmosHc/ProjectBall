-- Generated by github.com/davyxu/tabtoy
-- Version: 2.9.3

local tab = {
	EntityTemplate = {
		{ EntityId = 1, EntityName = "球", ResPath = "Sprite/GameProtagonists/Ball", EntityType = 0 	},
		{ EntityId = 2, EntityName = "幸运星", ResPath = "Sprite/GameItems/Star", EntityType = 2 	},
		{ EntityId = 3, EntityName = "棒子", ResPath = "Sprite/GameAgencys/Line", EntityType = 1 	},
		{ EntityId = 4, EntityName = "摩天轮", ResPath = "Sprite/GameAgencys/FerrisWheel", EntityType = 1 	},
		{ EntityId = 5, EntityName = "楼梯哒哒哒", ResPath = "Sprite/GameAgencys/Stairs", EntityType = 1 	}
	}, 

	ThemeChooser = {
		{ index = 1, ThemeName = "这波我无敌", IconUrl = "url", levels = { 1, 2, 3, 4, 5 } 	},
		{ index = 2, ThemeName = "这波我真棒", IconUrl = "url", levels = { 6, 7, 8, 9, 10 } 	},
		{ index = 3, ThemeName = "这波我不行", IconUrl = "url", levels = { 11, 12, 13, 14, 15 } 	}
	}, 

	Balls = {
		{ EntityId = 1, BallName = "乒乓球", ColliderRadius = 0.25, MaterialResPath = "Material/Game/Ball/PingPong" 	}
	}, 

	Levels = {
		{ LevelID = 1, ownerIndex = 1, IconUrl = "url", LevelName = "第1关", SpawnPoint = { X= -8.23, Y= 4.71 }, EndPoint = { X= 9.332, Y= -5.603 }, ConstAgencys = {  }, Agencys = { 1, 2, 3 } 	},
		{ LevelID = 2, ownerIndex = 1, IconUrl = "url", LevelName = "第2关", SpawnPoint = { X= -8.23, Y= 4.72 }, EndPoint = { X= 9.332, Y= -5.604 }, ConstAgencys = {  }, Agencys = { 1, 2, 3 } 	},
		{ LevelID = 3, ownerIndex = 1, IconUrl = "url", LevelName = "第3关", SpawnPoint = { X= -8.23, Y= 4.73 }, EndPoint = { X= 9.332, Y= -5.605 }, ConstAgencys = {  }, Agencys = { 1, 2, 3 } 	},
		{ LevelID = 4, ownerIndex = 1, IconUrl = "url", LevelName = "第4关", SpawnPoint = { X= -8.23, Y= 4.74 }, EndPoint = { X= 9.332, Y= -5.606 }, ConstAgencys = {  }, Agencys = { 1, 2, 3 } 	},
		{ LevelID = 5, ownerIndex = 1, IconUrl = "url", LevelName = "第5关", SpawnPoint = { X= -8.23, Y= 4.75 }, EndPoint = { X= 9.332, Y= -5.607 }, ConstAgencys = {  }, Agencys = { 1, 2, 3 } 	},
		{ LevelID = 6, ownerIndex = 2, IconUrl = "url", LevelName = "第6关", SpawnPoint = { X= -8.23, Y= 4.76 }, EndPoint = { X= 9.332, Y= -5.608 }, ConstAgencys = {  }, Agencys = { 1, 2, 3 } 	},
		{ LevelID = 7, ownerIndex = 2, IconUrl = "url", LevelName = "第7关", SpawnPoint = { X= -8.23, Y= 4.77 }, EndPoint = { X= 9.332, Y= -5.609 }, ConstAgencys = {  }, Agencys = { 1, 2, 3 } 	},
		{ LevelID = 8, ownerIndex = 2, IconUrl = "url", LevelName = "第8关", SpawnPoint = { X= -8.23, Y= 4.78 }, EndPoint = { X= 9.332, Y= -5.610 }, ConstAgencys = {  }, Agencys = { 1, 2, 3 } 	},
		{ LevelID = 9, ownerIndex = 2, IconUrl = "url", LevelName = "第9关", SpawnPoint = { X= -8.23, Y= 4.79 }, EndPoint = { X= 9.332, Y= -5.611 }, ConstAgencys = {  }, Agencys = { 1, 2, 3 } 	},
		{ LevelID = 10, ownerIndex = 2, IconUrl = "url", LevelName = "第10关", SpawnPoint = { X= -8.23, Y= 4.80 }, EndPoint = { X= 9.332, Y= -5.612 }, ConstAgencys = {  }, Agencys = { 1, 2, 3 } 	},
		{ LevelID = 11, ownerIndex = 3, IconUrl = "url", LevelName = "第11关", SpawnPoint = { X= -8.23, Y= 4.81 }, EndPoint = { X= 9.332, Y= -5.613 }, ConstAgencys = {  }, Agencys = { 1, 2, 3 } 	},
		{ LevelID = 12, ownerIndex = 3, IconUrl = "url", LevelName = "第12关", SpawnPoint = { X= -8.23, Y= 4.82 }, EndPoint = { X= 9.332, Y= -5.614 }, ConstAgencys = {  }, Agencys = { 1, 2, 3 } 	},
		{ LevelID = 13, ownerIndex = 3, IconUrl = "url", LevelName = "第13关", SpawnPoint = { X= -8.23, Y= 4.83 }, EndPoint = { X= 9.332, Y= -5.615 }, ConstAgencys = {  }, Agencys = { 1, 2, 3 } 	},
		{ LevelID = 14, ownerIndex = 3, IconUrl = "url", LevelName = "第14关", SpawnPoint = { X= -8.23, Y= 4.84 }, EndPoint = { X= 9.332, Y= -5.616 }, ConstAgencys = {  }, Agencys = { 1, 2, 3 } 	},
		{ LevelID = 15, ownerIndex = 3, IconUrl = "url", LevelName = "第15关", SpawnPoint = { X= -8.23, Y= 4.85 }, EndPoint = { X= 9.332, Y= -5.617 }, ConstAgencys = {  }, Agencys = { 1, 2, 3 } 	}
	}, 

	Agencys = {
		{ ID = 1, AgencyName = "棒子", EntityId = 3, ScaleMax = { X= 10, Y= 10, Z= 10 }, ScaleMin = { X= 1, Y= 1, Z= 1 } 	},
		{ ID = 2, AgencyName = "摩天轮", EntityId = 4, ScaleMax = { X= 10, Y= 10, Z= 11 }, ScaleMin = { X= 1, Y= 1, Z= 2 } 	},
		{ ID = 3, AgencyName = "楼梯哒哒哒", EntityId = 5, ScaleMax = { X= 10, Y= 10, Z= 12 }, ScaleMin = { X= 1, Y= 1, Z= 3 } 	}
	}

}


-- EntityId
tab.EntityTemplateByEntityId = {}
for _, rec in pairs(tab.EntityTemplate) do
	tab.EntityTemplateByEntityId[rec.EntityId] = rec
end

-- index
tab.ThemeChooserByindex = {}
for _, rec in pairs(tab.ThemeChooser) do
	tab.ThemeChooserByindex[rec.index] = rec
end

-- EntityId
tab.BallsByEntityId = {}
for _, rec in pairs(tab.Balls) do
	tab.BallsByEntityId[rec.EntityId] = rec
end

-- LevelID
tab.LevelsByLevelID = {}
for _, rec in pairs(tab.Levels) do
	tab.LevelsByLevelID[rec.LevelID] = rec
end

-- ID
tab.AgencysByID = {}
for _, rec in pairs(tab.Agencys) do
	tab.AgencysByID[rec.ID] = rec
end

tab.Enum = {
}

return tab