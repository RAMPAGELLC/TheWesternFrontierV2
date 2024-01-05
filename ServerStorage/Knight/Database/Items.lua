local database = {}
local HungerSystemEnabled = false

_G.ItemIdToData = function(id)
	return database.search("ItemId", id)
end

_G.ItemNameToData = function(name)
	return database.search("Name", name)
end

function database.search(by, value)
	local f,d = false, {}

	for i,v in pairs(database.get()) do
		if v[by] == value then
			f,d = true, v;
			break
		end
	end

	return f,d
end

function database.get()
	return {
		{
			Name = "Golden Revolver",
			Description = "A special developer weapon",
			Type = "Firearm",
			ForSale = false,
			New = true,
			Rare = true,
			CanDiscard = false,
			CanDrop = false,
			Price = 0,
			ItemId = 1,
			Image = 8054565993,
			RobloxTool = true,
		},
        --[[
            ITEM DATABASE NOT COMPLETE.
            PENDING RELEASE BY ENGINEERING.
        ]]
	} 
end

return database