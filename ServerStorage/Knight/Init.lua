local repStor = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Knight = script.Parent

local directory = {Inited = false, Shared={}}
local modules = {}

_G.get_length = function(tbl: { [string | number]: any }): number
	local length = 0

	for _ in pairs(tbl) do
		length += 1
	end
	return length
end

function _G.tweenModel(model, CF, info, cb)
	if cb == nil then cb = false end

	local tween = nil
	local CFrameValue = Instance.new("CFrameValue")

	if model:IsA("Model") then
		CFrameValue.Value = model:GetPrimaryPartCFrame()

		CFrameValue:GetPropertyChangedSignal("Value"):Connect(function()
			model:SetPrimaryPartCFrame(CFrameValue.Value)
		end)

		tween = TweenService:Create(CFrameValue, info, {Value = CF})
		tween:Play()
	else
		tween = TweenService:Create(model, info, {CFrame = CF})
		tween:Play()
	end

	tween.Completed:Connect(function()
		CFrameValue:Destroy()
		if cb then cb() end
	end)
end

local function PackFolder(tab, folder, is_priority)
	if folder.Name == "Priority" and not is_priority then return end
	if folder.Name == "Database" and not is_priority then return end
	
	for i, child in pairs(folder:GetChildren()) do
		if child:IsA("Folder") then
			tab[child.Name] = PackFolder(
				setmetatable({}, {
					__index = function(t, i)
						if rawget(t, i) then
							return t[i]
						else
							local success, val = pcall(function()
								return child[i]
							end)

							if success then
								return val
							end
						end
					end,
					__call = function(t)
						return child
					end
				}),
				child
			)
		elseif child:IsA("ModuleScript") then
			if child.Name == "Internal" then -- override internal knight scripts into services
				tab = directory["Services"]
			end
			
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

directory.InitKnight = function(KnightMain)
	for i, folder in pairs(Knight:GetChildren()) do
		if folder:IsA("Folder") then
			directory[folder.Name] = {}
		end
	end
	
	directory.Inited = true
	directory.Knight = KnightMain
	directory.Shared = require(repStor:WaitForChild("Knight"):WaitForChild("Init"))(directory)
	directory.KnightCache = {
		UpdateEvent = directory.Shared.Objects.Event.new()
	}

	PackFolder(directory["Database"], Knight["Database"], true)
	task.wait()
	PackFolder(directory["Priority"], Knight["Priority"], true)
	
	for i, folder in pairs(Knight:GetChildren()) do
		if folder:IsA("Folder") then
			local r = PackFolder(directory[folder.Name], folder, false)
		end
	end

	for i, mod in ipairs(modules) do
		if mod.Start then
			task.spawn(function()
				mod.Start()
			end)
		end

		if mod.Update then
			directory.KnightCache.UpdateEvent:Connect(function(deltaTime)
				mod.Update(deltaTime)
			end)
		end
	end

	game:GetService("RunService").Heartbeat:Connect(function(deltaTime)
		directory.KnightCache.UpdateEvent:Fire(deltaTime)
	end)
	
	return directory
end

return directory