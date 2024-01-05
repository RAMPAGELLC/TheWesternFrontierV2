local repStor = game:GetService("ReplicatedStorage")

local folder = script.Parent

local directory = {}
directory.Main = {}
directory.Inited = false

for i, folder in pairs(folder:GetChildren()) do
	if folder:IsA("Folder") then
		directory[folder.Name] = {}
	end
end

local modules = {}

local function PackFolder(tab, folder)
	for i, child in pairs(folder:GetChildren()) do
		if child:IsA("Folder") then
			tab[child.Name] = PackFolder(
				setmetatable({}, {
					__call = function(t)
						return child
					end
				}),
				child
			)
		elseif child:IsA("ModuleScript") then
			local mod = require(child)

			if typeof(mod) == "table" then
				for k, v in pairs(directory) do
					mod[k] = v
				end

				if mod.Init then
					mod.Init()
				end

				modules[#modules + 1] = mod
			end

			tab[typeof(mod) == "table" and mod.ServiceName ~= nil and mod.ServiceName or child.Name] = mod
		elseif child:IsA("ValueBase") then
			tab[child.Name] = child.Value
		else
			tab[child.Name] = child
		end
	end
	return tab
end

for i, folder in pairs(folder:GetChildren()) do
	if folder:IsA("Folder") then
		PackFolder(directory[folder.Name], folder)
	end
end

for i, mod in ipairs(modules) do
	if mod.Start then
		task.spawn(function()
			mod.Start()
		end)
	end
end

return function(main, k)
	directory.Assets = game:GetService("ReplicatedStorage"):WaitForChild("Assets")
	directory.Roblox = {
		GroupService = game:GetService("GroupService"),
		UserInputService = game:GetService("UserInputService"),
		HttpService = game:GetService("HttpService"),
		ServerScriptService = game:GetService("ServerScriptService") ~= nil and game:GetService("ServerScriptService") or false,
		ServerStorage = game:GetService("ServerStorage") ~= nil and game:GetService("ServerStorage") or false,
		DataStoreService = game:GetService("DataStoreService") ~= nil and game:GetService("DataStoreService") or false,
		Players = game:GetService("Players"),
		ReplicatedStorage = game:GetService("ReplicatedStorage"),
		ReplicatedFirst = game:GetService("ReplicatedFirst"),
		Workspace = game:GetService("Workspace"),
		Lighting = game:GetService("Lighting"),
		StarterGui = game:GetService("StarterGui"),
		StarterPlayer = game:GetService("StarterPlayer"),
		StarterPack = game:GetService("StarterPack"),
		Chat = game:GetService("Chat"),
		Teams = game:GetService("Teams"),
		SoundService = game:GetService("SoundService"),
		TeleportService = game:GetService("TeleportService"),
		TextService = game:GetService("TextService"),
		TweenService = game:GetService("TweenService"),
		ContextActionService = game:GetService("ContextActionService"),
		RunService = game:GetService("RunService"),
	}
	directory.Thread = function(a)
		task.spawn(a)
	end
	directory.Player = game.Players.LocalPlayer ~= nil and game.Players.LocalPlayer or false
	directory.Knight = k;
	directory.Inited = true
	
	for i, v in pairs(main) do
		directory.Main[i] = v
	end
	
	return directory
end