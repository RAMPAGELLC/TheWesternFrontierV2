local database = {}

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
			ScrollAuthor = "",
			ScrollDate = "",
			ScrollMessage = "Where the flames of the underworld burn bright, a gate stands to guard whats in sight the treasure awaits.",
		},
		{
			ScrollAuthor = "",
			ScrollDate = "",
			ScrollMessage = "Where the bear sees in sight across a city, there shall be my treasure.",
		},
		{
			ScrollAuthor = "",
			ScrollDate = "",
			ScrollMessage = "Where a legendary cowboy has dead rest.",
		},
		{
			ScrollAuthor = "",
			ScrollDate = "",
			ScrollMessage = "In where in a forest, near a powerful witch.",
		},
		{
			ScrollAuthor = "",
			ScrollDate = "",
			ScrollMessage = "My loot are safely stashed under a view of those who are condemned.",
		},
		{
			ScrollAuthor = "",
			ScrollDate = "",
			ScrollMessage = "The mayors treasure lays where a bell stands tall.",
		},
	}
end

return database