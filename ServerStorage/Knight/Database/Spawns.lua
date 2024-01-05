local database = {}

function database.get()
	return {
		["Blackwater City"] = {
			CanWithBounty = false,
			Pads = game:GetService("Workspace").Spawns.Blackwater:GetChildren(),
		},
		["Blackwater Mines"] = {
			CanWithBounty = false,
			Pads = game:GetService("Workspace").Spawns["Blackwater Mines"]:GetChildren(),
		},
		["Bearclaw City"] = {
			CanWithBounty = true,
			GiveBounty = true,
			Pads = game:GetService("Workspace").Spawns.Bearclaw:GetChildren(),
		},
		["Salvation City"] = {
			CanWithBounty = false,
			Pads = game:GetService("Workspace").Spawns.Salvation:GetChildren(),
		},
		["El Dorado"] = {
			CanWithBounty = false,
			Pads = game:GetService("Workspace").Spawns.Dorado:GetChildren(),
		},
		["Great Plains Mine"] = {
			CanWithBounty = false,
			Pads = game:GetService("Workspace").Spawns.Limestone:GetChildren(),
		},
		["Tribal Forest"] = {
			CanWithBounty = false,
			Pads = game:GetService("Workspace").Spawns.Tribal:GetChildren(),
		},
		["Snowfall Peak"] = {
			CanWithBounty = false,
			Pads = game:GetService("Workspace").Spawns["Snowfall Peak"]:GetChildren(),
		},
		["The Great Desert"] = {
			CanWithBounty = true,
			Pads = game:GetService("Workspace").Spawns["The Great Desert"]:GetChildren(),
		},
	}
end

return database