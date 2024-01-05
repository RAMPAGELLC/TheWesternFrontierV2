-- Copyright 2022 RAMPAGE Interactive
-- Written by vq9o

local RunService = game:GetService("RunService")
local Knight = {
	["IsServer"] = RunService:IsServer(),
	["Version"] = "<0.0.4> KNIGHT INTERNAL on Roblox " .. (RunService:IsStudio() and "Studio" or "Experience") .. " | Experience Version: " .. version(),
	["Core"] = {}
}
_G.Knight = {}

function Knight.Core.Log(Type, ...)
	local msgs = {...};
	local l = "[Knight Framework] [" .. Knight.Version .. "]";
	
	for _, message in pairs(msgs) do
		if string.lower(Type) == "print" then
			print(l .. message)
		elseif string.lower(Type) == "warn" then
			warn(l .. message)
		elseif string.lower(Type) == "error" then
			local s,e = pcall(function()
				error(l .. message)
			end)
		end
	end
end

function Knight:PrintVersion()
	Knight.Core.Log("print", "")
end

function Knight.Core.DeleteByClass(Children, Class)
	for i,v in pairs(Children) do
		if v:IsA(Class) then
			v:Destroy()
		end
	end
	
	return true
end

function Knight.Core:GetShared()
	return require(game:GetService("ReplicatedStorage"):WaitForChild("Knight").Init)
end

function Knight.Core:GetStorage(IsShared)
	if IsShared == nil then IsShared = false end
	
	if IsShared then return Knight.Core:GetShared() end
	
	if RunService:IsServer() then
		return require(game:GetService("ServerStorage"):WaitForChild("Knight").Init)
	else
		return require(game:GetService("Players").LocalPlayer.PlayerScripts:WaitForChild("Knight").Init)
	end
end

function Knight.Core:Init()
	local Storage = Knight.Core:GetStorage()
	local Init = Storage.InitKnight(Knight)
	
	return Init, Knight.Core:GetShared()(Init, Knight)
end

function Knight.Core:GetModule(Container, ServiceName, IsShared)
	local Storage = Knight.Core:GetStorage(IsShared)

	if not Storage.Inited then
		Knight.Core.Log("Warn", ServiceName .. " cannot be inited as it hasnt been started, " .. ServiceName .. " has been queued to return shortly.")

		repeat task.wait() until (Knight.Core:GetStorage(IsShared).Inited == true)
	end

	return Storage[Container][ServiceName] or {}
end

function Knight.Core:GetService(ServiceName, IsShared)
	return Knight.Core:GetModule("Services", ServiceName, IsShared)
end

return Knight