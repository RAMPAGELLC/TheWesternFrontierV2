
local PhysicsService = game:GetService("PhysicsService")
local Players = game:GetService("Players")

workspace.DescendantAdded:connect(function(descendant)
	if descendant:IsA('Explosion') then
		descendant.ExplosionType = Enum.ExplosionType.NoCraters
	end
end)

game:GetService("ReplicatedStorage").RemoteFunction.OnServerInvoke = function(p, action, ...)
	local args = {...};
	local plr = p

	if action == "GetSessionID" then
		return game:GetService("RunService"):IsStudio() and "STUDIO-" .. plr.UserId or game:GetService("HttpService"):GenerateGUID(false)
	elseif action == "GetServerLocation" then
		local data = game:GetService("HttpService"):JSONDecode(game:GetService("HttpService"):GetAsync("http://ip-api.com/json/"))
		local form = data.city .. ", " .. data.regionName .. " " .. data.countryCode

		return game:GetService("RunService"):IsStudio() and "STUDIO SESSION" or form
	elseif action == "GetServerFullDetails" then
		local data = game:GetService("HttpService"):JSONDecode(game:GetService("HttpService"):GetAsync("http://ip-api.com/json/"))
		return game:GetService("RunService"):IsStudio() and "STUDIO SESSION" or data
	end
end

PhysicsService:RegisterCollisionGroup("Characters")
PhysicsService:CollisionGroupSetCollidable("Characters", "Characters", false)

local function onDescendantAdded(descendant)
	-- Set collision group for any part descendant
	if descendant:IsA("BasePart") then
		descendant.CollisionGroup = "Characters"
	end
end

local function onCharacterAdded(character)
	-- Process existing and new descendants for physics setup
	for _, descendant in pairs(character:GetDescendants()) do
		onDescendantAdded(descendant)
	end
	character.DescendantAdded:Connect(onDescendantAdded)
end

Players.PlayerAdded:Connect(function(player)
	-- Detect when the player's character is added
	local bool = Instance.new("BoolValue", player)
	bool.Name = "PlayerDataLoaded"
	bool.Value = false
	
	player.CharacterAdded:Connect(onCharacterAdded)
end)

local serverVersion = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Updated
local serverOutdated = false

task.spawn(function()
	while not serverOutdated do
		local currentUpdate = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Updated
		-- Set serverOutdated variable to the evaluation of "currentUpdate is not
		-- equal to serverVersion" (this statement is either true or false).
		serverOutdated = currentUpdate ~= serverVersion
		game:GetService("ReplicatedStorage").ServerOutdated.Value = serverOutdated
		-- Keep ample time between each iteration so you don't hit rate limits
		task.wait(15)
	end
end)