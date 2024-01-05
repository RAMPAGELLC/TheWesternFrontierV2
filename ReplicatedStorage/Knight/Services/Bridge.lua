local Bridge = {
	ServiceName = script.Name,
	ServiceData = {
		Author = "vq9o",
		Description = "Easier version of Remote Events & Remotes without calling several remotes."
	}
}

--[[
@Knight.Shared.Services.Bridge.new(BridgeName, IsShared  (optional; default false), Callback (optional; default false))

If you are registering something shared, you must register it server-sided.

-- Register bridge with callback
Knight.Shared.Services.Bridge.new("Example", true, function(Player)
	print("Got event")
end)

-- Register bridge without callback
local bridge = Knight.Shared.Services.Bridge.new("Example", true)

-- Connection onto the bridge
bridge.Event:Connect(function(Player)

end)
]]

Bridge.Bridges = {}

function Bridge.Start()
end

function Bridge.New(BridgeName, IsShared, Callback)
	warn("[WARNING] Bridge.New is deprecated, please use Bridge.new. Bridge.New will cease operation soon.")
	return Bridge.new(BridgeName, IsShared, Callback)
end

function Bridge:Connect(BridgeName, Callback)
	if Callback == nil then Callback = false end

	if Bridge.Player then
		-- client doesnt sync with server array, therefore we must use _INTERNAL BRIDGE SYNC.
		return false
	end
	
	if Bridge.Bridges[BridgeName] == nil then
		warn("[WARNING] Bridge " .. BridgeName .." does not exist. Bridge hook failed.")
		return false 
	end
	
	if not Callback then return Bridge.Bridges[BridgeName] end
	
	Bridge.Bridges[BridgeName].Event:Connect(function(...)
		if Callback then
			Callback(...)
		end
	end)
end

function Bridge.new(BridgeName, IsShared, Callback)
	local NewBridge = {}

	if IsShared == nil then IsShared = false end
	if Callback == nil then Callback = false end

	NewBridge.BridgeName = BridgeName
	NewBridge.Shared = IsShared
	NewBridge.Event = Bridge.Objects.Event.new()
	
	NewBridge.Internal = {
		Trigger = Bridge.Services.Remotes:Register(BridgeName, IsShared and "RemoteFunction" or "BindableEvent", function(...)
			NewBridge.Event:Fire(...)
		end)
	}

	NewBridge.Event:Connect(function(...)
		if Callback then
			Callback(...)
		end
	end)
	
	NewBridge.Fire = function(...)
		NewBridge.Internal.Trigger:Fire(...)
	end
	
	NewBridge.Destroy = function()
		NewBridge.Event:Destroy()
		
		if game:GetService("ReplicatedStorage").Knight.Events:FindFirstChild(NewBridge.BridgeName) then
			game:GetService("ReplicatedStorage").Knight.Events:FindFirstChild(NewBridge.BridgeName):Destroy()
		end
		
		Bridge.Bridges[BridgeName] = nil;
	end

	Bridge.Bridges[BridgeName] = NewBridge

	return NewBridge
end

return Bridge