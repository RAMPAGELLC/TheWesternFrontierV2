-- Knight Init Service
local Knight = {};
local Service = { -- Never Index Service, Data is packed into Knight. Correctly index example: Knight.ServiceName
	ServiceName = script.Name,
	ServiceData = {
		Author = "vq9o",
		Description = "Knight service"
	},
	Cache = {
		CoreGui = false,
		Camera = false,
		Modules = {},
	}
}

for i,v in pairs(Service) do
	Knight[i] = v;
end

function Knight.Start()
	--[[
	local MaxDeer = 0
	local MaxGator = 0

	local DeerZone = Knight.Shared.External.Zone.new(workspace.Ignore.Animals.Deer)
	local GatorZone = Knight.Shared.External.Zone.new(workspace.Ignore.Animals.Gator)
	
	local function SpawnAnimal(AnimalName, Zone)
		task.spawn(function()
			local intersectionVector
			repeat
				local randomVector, touchingParts = Zone:getRandomPoint()
				local rayOrigin = randomVector + Vector3.new(0, 1, 0)
				local raycastParams = RaycastParams.new()
				raycastParams.FilterDescendantsInstances = touchingParts
				raycastParams.FilterType = Enum.RaycastFilterType.Whitelist
				local raycastResult = workspace:Raycast(rayOrigin, Vector3.new(0, -2, 0), raycastParams)
				intersectionVector = (raycastResult and raycastResult.Position)
				task.wait()
			until intersectionVector

			local Animal = Knight.Shared.Assets.Animals:FindFirstChild(AnimalName):Clone()
			Animal.Parent = workspace
			Animal:MoveTo(intersectionVector + Vector3.new(0, 6, 0))

			Animal.Humanoid.Died:Connect(function()
				task.wait(12)
				Animal:Destroy()
				task.wait(12)
				SpawnAnimal(AnimalName, Zone)
			end)
		end)
	end
	
	task.spawn(function()
		for i = 1, MaxDeer do
			SpawnAnimal("Deer", DeerZone)
			wait(1)
		end

		for i = 1, MaxGator do
			SpawnAnimal("Gator", GatorZone)
			wait(1)
		end
		
		print("[WESTERN] Loaded All Animals!")
	end)]]
end

return Knight